import http from 'k6/http';
import { check, sleep } from 'k6';
import { SharedArray } from 'k6/data';
import { Rate } from 'k6/metrics';

// Configuración de variables
const BASE_URL = 'http://localhost:8081';
const API_PATH = '/api/facturas';

// Definir métricas personalizadas
const errorRate = new Rate('errors');

// Lista de IDs de facturas para consultar (simulada)
// En un escenario real, esto podría cargarse desde un archivo CSV o JSON
const facturaIds = new SharedArray('facturas', function() {
  // Simulamos 10 IDs de facturas, en un caso real estos serían IDs válidos
  return Array.from({ length: 10 }, (_, i) => i + 1);
});

// Configuración de escenarios de carga
export const options = {
  scenarios: {
    // Escenario de carga constante
    constant_load: {
      executor: 'constant-vus',
      vus: 10,         // 10 usuarios virtuales
      duration: '30s',  // duración de 30 segundos
    },
    // Escenario con aumento gradual de carga
    ramp_up: {
      executor: 'ramping-vus',
      startVUs: 1,      // comienza con 1 usuario
      stages: [
        { duration: '10s', target: 5 },   // aumenta a 5 usuarios en 10 segundos
        { duration: '20s', target: 20 },  // aumenta a 20 usuarios en 20 segundos
        { duration: '10s', target: 0 },   // reduce a 0 usuarios en 10 segundos
      ],
    },
    // Escenario de prueba de estrés
    stress_test: {
      executor: 'ramping-arrival-rate',
      startRate: 5,     // 5 peticiones por segundo al inicio
      timeUnit: '1s',
      stages: [
        { duration: '10s', target: 10 },  // aumenta a 10 peticiones por segundo en 10 segundos
        { duration: '30s', target: 30 },  // aumenta a 30 peticiones por segundo en 30 segundos
        { duration: '10s', target: 0 },   // reduce a 0 peticiones por segundo en 10 segundos
      ],
      preAllocatedVUs: 30,  // pre-asigna 30 VUs para reutilización
    }
  },
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% de las solicitudes deben completarse en menos de 500ms
    'http_req_duration{endpoint:getFacturaById}': ['p(95)<300'], // Threshold específico para este endpoint
    errors: ['rate<0.1'], // La tasa de error debe ser inferior al 10%
  },
};

export default function() {
  // Seleccionar aleatoriamente un ID de factura de nuestra lista
  const facturaId = facturaIds[Math.floor(Math.random() * facturaIds.length)];
  
  // Construir la URL para consultar una factura específica
  const url = `${BASE_URL}${API_PATH}/${facturaId}`;
  
  // Configurar headers
  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    tags: {
      endpoint: 'getFacturaById',
    },
  };
  
  // Realizar la petición GET
  const response = http.get(url, params);
  
  // Verificar el resultado
  const checkResults = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
    'response has expected format': (r) => {
      try {
        const body = JSON.parse(r.body);
        return body.id && body.numero && body.fechaEmision && body.total && body.clienteId !== undefined;
      } catch (e) {
        return false;
      }
    },
  });
  
  // Registrar errores si las comprobaciones fallan
  errorRate.add(!checkResults);
  
  // Registrar información detallada sobre cada solicitud
  console.log(`Factura ID: ${facturaId}, Status: ${response.status}, Duration: ${response.timings.duration}ms`);
  
  // Añadir algo de tiempo de espera entre solicitudes para simular comportamiento de usuario
  sleep(Math.random() * 2 + 1); // Entre 1 y 3 segundos
}

// Función setup que se ejecuta antes de comenzar las pruebas
export function setup() {
  console.log('Iniciando pruebas de rendimiento para el endpoint de consulta de facturas por ID...');
  
  // Verificar que el servicio esté disponible antes de comenzar
  const healthCheck = http.get(`${BASE_URL}/`);
  check(healthCheck, {
    'API is up': (r) => r.status === 200,
  });
  
  return { startTime: new Date().toISOString() };
}

// Función teardown que se ejecuta después de finalizar las pruebas
export function teardown(data) {
  console.log(`Pruebas de rendimiento finalizadas. Inicio: ${data.startTime}, Fin: ${new Date().toISOString()}`);
}