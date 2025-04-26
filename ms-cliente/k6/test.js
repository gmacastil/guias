import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,  // Virtual Users (número de usuarios virtuales concurrentes)
  duration: '30s',  // Duración total de la prueba
};

export default function () {
  // Definimos los headers para la solicitud
  const headers = {
    'Accept': 'application/json',
  };

  // Realizamos la solicitud GET
  const response = http.get('http://localhost:9090/api/clientes/1/facturas', { headers });

  // Verificamos que la respuesta sea exitosa (código 200)
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  // Pequeña pausa entre solicitudes
  sleep(1);
}