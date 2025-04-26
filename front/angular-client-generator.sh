#!/bin/bash

# Crear un nuevo proyecto Angular
echo "Creando un nuevo proyecto Angular 'cliente-app'..."
ng new cliente-app --routing=true --style=scss --skip-git --skip-tests

# Navegar al directorio del proyecto
cd cliente-app

# Instalar dependencias adicionales
echo "Instalando dependencias adicionales..."
npm install @angular/material @angular/cdk @angular/animations
npm install bootstrap

# Crear modelos
echo "Creando modelos..."
mkdir -p src/app/models
cat > src/app/models/cliente.model.ts << 'EOF'
export interface Cliente {
  id?: number;
  nombre: string;
  apellido: string;
  documento: string;
  telefono: string;
  email: string;
  direccion?: string;
}
EOF

cat > src/app/models/factura.model.ts << 'EOF'
export interface Factura {
  id?: number;
  numero: string;
  fechaEmision: string;
  total: number;
  clienteId: number;
  descripcion?: string;
}
EOF

cat > src/app/models/cliente-con-facturas.model.ts << 'EOF'
import { Cliente } from './cliente.model';
import { Factura } from './factura.model';

export interface ClienteConFacturas {
  cliente: Cliente;
  facturas: Factura[];
}
EOF

# Crear servicios
echo "Creando servicios..."
mkdir -p src/app/services
cat > src/app/services/cliente.service.ts << 'EOF'
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Cliente } from '../models/cliente.model';
import { ClienteConFacturas } from '../models/cliente-con-facturas.model';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ClienteService {
  private apiUrl = `${environment.apiUrl}/api/clientes`;

  constructor(private http: HttpClient) { }

  getAllClientes(): Observable<Cliente[]> {
    return this.http.get<Cliente[]>(this.apiUrl);
  }

  getClienteById(id: number): Observable<Cliente> {
    return this.http.get<Cliente>(`${this.apiUrl}/${id}`);
  }

  createCliente(cliente: Cliente): Observable<Cliente> {
    return this.http.post<Cliente>(this.apiUrl, cliente);
  }

  updateCliente(id: number, cliente: Cliente): Observable<Cliente> {
    return this.http.put<Cliente>(`${this.apiUrl}/${id}`, cliente);
  }

  deleteCliente(id: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/${id}`);
  }

  getClienteConFacturas(id: number): Observable<ClienteConFacturas> {
    return this.http.get<ClienteConFacturas>(`${this.apiUrl}/${id}/facturas`);
  }
}
EOF

# Crear entorno
echo "Configurando entornos..."
cat > src/environments/environment.ts << 'EOF'
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8082'
};
EOF

cat > src/environments/environment.prod.ts << 'EOF'
export const environment = {
  production: true,
  apiUrl: 'http://localhost:8082'
};
EOF

# Crear componentes
echo "Creando componentes..."
ng generate component components/cliente-list
ng generate component components/cliente-form
ng generate component components/cliente-detail
ng generate component components/cliente-facturas
ng generate component components/navbar

# Personalizar componentes
cat > src/app/components/cliente-list/cliente-list.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Cliente } from '../../models/cliente.model';
import { ClienteService } from '../../services/cliente.service';

@Component({
  selector: 'app-cliente-list',
  templateUrl: './cliente-list.component.html',
  styleUrls: ['./cliente-list.component.scss']
})
export class ClienteListComponent implements OnInit {
  clientes: Cliente[] = [];
  displayedColumns: string[] = ['id', 'nombre', 'apellido', 'documento', 'telefono', 'email', 'acciones'];
  
  constructor(
    private clienteService: ClienteService,
    private router: Router
  ) { }

  ngOnInit(): void {
    this.loadClientes();
  }

  loadClientes(): void {
    this.clienteService.getAllClientes().subscribe({
      next: (data) => {
        this.clientes = data;
      },
      error: (error) => {
        console.error('Error al cargar clientes', error);
        alert('Error al cargar la lista de clientes');
      }
    });
  }

  verDetalle(id: number): void {
    this.router.navigate(['/clientes', id]);
  }

  verFacturas(id: number): void {
    this.router.navigate(['/clientes', id, 'facturas']);
  }

  editarCliente(id: number): void {
    this.router.navigate(['/clientes/editar', id]);
  }

  eliminarCliente(id: number): void {
    if (confirm('¿Está seguro de eliminar este cliente?')) {
      this.clienteService.deleteCliente(id).subscribe({
        next: () => {
          this.loadClientes();
          alert('Cliente eliminado con éxito');
        },
        error: (error) => {
          console.error('Error al eliminar cliente', error);
          alert('Error al eliminar el cliente');
        }
      });
    }
  }
}
EOF

cat > src/app/components/cliente-list/cliente-list.component.html << 'EOF'
<div class="container mt-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Lista de Clientes</h2>
    <button class="btn btn-primary" routerLink="/clientes/nuevo">Nuevo Cliente</button>
  </div>

  <div class="table-responsive">
    <table class="table table-striped table-hover">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nombre</th>
          <th>Apellido</th>
          <th>Documento</th>
          <th>Teléfono</th>
          <th>Email</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr *ngFor="let cliente of clientes">
          <td>{{ cliente.id }}</td>
          <td>{{ cliente.nombre }}</td>
          <td>{{ cliente.apellido }}</td>
          <td>{{ cliente.documento }}</td>
          <td>{{ cliente.telefono }}</td>
          <td>{{ cliente.email }}</td>
          <td>
            <button class="btn btn-sm btn-info me-1" (click)="verDetalle(cliente.id)">Ver</button>
            <button class="btn btn-sm btn-warning me-1" (click)="editarCliente(cliente.id)">Editar</button>
            <button class="btn btn-sm btn-danger me-1" (click)="eliminarCliente(cliente.id)">Eliminar</button>
            <button class="btn btn-sm btn-secondary" (click)="verFacturas(cliente.id)">Facturas</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
  
  <div *ngIf="clientes.length === 0" class="alert alert-info">
    No hay clientes registrados.
  </div>
</div>
EOF

cat > src/app/components/cliente-form/cliente-form.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Cliente } from '../../models/cliente.model';
import { ClienteService } from '../../services/cliente.service';

@Component({
  selector: 'app-cliente-form',
  templateUrl: './cliente-form.component.html',
  styleUrls: ['./cliente-form.component.scss']
})
export class ClienteFormComponent implements OnInit {
  clienteForm: FormGroup;
  isEditing = false;
  clienteId: number;
  
  constructor(
    private fb: FormBuilder,
    private clienteService: ClienteService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.clienteForm = this.fb.group({
      nombre: ['', [Validators.required]],
      apellido: ['', [Validators.required]],
      documento: ['', [Validators.required]],
      telefono: ['', [Validators.required, Validators.pattern('\\d{10}')]],
      email: ['', [Validators.required, Validators.email]],
      direccion: ['']
    });
    
    this.clienteId = 0;
  }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.isEditing = true;
        this.clienteId = +params['id'];
        this.loadClienteData();
      }
    });
  }

  loadClienteData(): void {
    this.clienteService.getClienteById(this.clienteId).subscribe({
      next: (cliente) => {
        this.clienteForm.patchValue(cliente);
      },
      error: (error) => {
        console.error('Error al cargar cliente', error);
        alert('Error al cargar los datos del cliente');
        this.router.navigate(['/clientes']);
      }
    });
  }

  onSubmit(): void {
    if (this.clienteForm.invalid) {
      this.clienteForm.markAllAsTouched();
      return;
    }

    const clienteData: Cliente = this.clienteForm.value;
    
    if (this.isEditing) {
      this.clienteService.updateCliente(this.clienteId, clienteData).subscribe({
        next: () => {
          alert('Cliente actualizado correctamente');
          this.router.navigate(['/clientes']);
        },
        error: (error) => {
          console.error('Error al actualizar cliente', error);
          alert('Error al actualizar el cliente');
        }
      });
    } else {
      this.clienteService.createCliente(clienteData).subscribe({
        next: () => {
          alert('Cliente creado correctamente');
          this.router.navigate(['/clientes']);
        },
        error: (error) => {
          console.error('Error al crear cliente', error);
          alert('Error al crear el cliente');
        }
      });
    }
  }
}
EOF

cat > src/app/components/cliente-form/cliente-form.component.html << 'EOF'
<div class="container mt-4">
  <h2>{{ isEditing ? 'Editar' : 'Nuevo' }} Cliente</h2>
  
  <form [formGroup]="clienteForm" (ngSubmit)="onSubmit()" class="mt-4">
    <div class="row mb-3">
      <div class="col-md-6">
        <label for="nombre" class="form-label">Nombre*</label>
        <input type="text" class="form-control" id="nombre" formControlName="nombre">
        <div *ngIf="clienteForm.get('nombre')?.touched && clienteForm.get('nombre')?.invalid" class="text-danger">
          El nombre es requerido
        </div>
      </div>
      
      <div class="col-md-6">
        <label for="apellido" class="form-label">Apellido*</label>
        <input type="text" class="form-control" id="apellido" formControlName="apellido">
        <div *ngIf="clienteForm.get('apellido')?.touched && clienteForm.get('apellido')?.invalid" class="text-danger">
          El apellido es requerido
        </div>
      </div>
    </div>
    
    <div class="row mb-3">
      <div class="col-md-6">
        <label for="documento" class="form-label">Documento*</label>
        <input type="text" class="form-control" id="documento" formControlName="documento">
        <div *ngIf="clienteForm.get('documento')?.touched && clienteForm.get('documento')?.invalid" class="text-danger">
          El documento es requerido
        </div>
      </div>
      
      <div class="col-md-6">
        <label for="telefono" class="form-label">Teléfono*</label>
        <input type="text" class="form-control" id="telefono" formControlName="telefono">
        <div *ngIf="clienteForm.get('telefono')?.touched && clienteForm.get('telefono')?.invalid" class="text-danger">
          <span *ngIf="clienteForm.get('telefono')?.errors?.['required']">El teléfono es requerido</span>
          <span *ngIf="clienteForm.get('telefono')?.errors?.['pattern']">Debe contener 10 dígitos</span>
        </div>
      </div>
    </div>
    
    <div class="row mb-3">
      <div class="col-md-6">
        <label for="email" class="form-label">Email*</label>
        <input type="email" class="form-control" id="email" formControlName="email">
        <div *ngIf="clienteForm.get('email')?.touched && clienteForm.get('email')?.invalid" class="text-danger">
          <span *ngIf="clienteForm.get('email')?.errors?.['required']">El email es requerido</span>
          <span *ngIf="clienteForm.get('email')?.errors?.['email']">Formato de email inválido</span>
        </div>
      </div>
      
      <div class="col-md-6">
        <label for="direccion" class="form-label">Dirección</label>
        <input type="text" class="form-control" id="direccion" formControlName="direccion">
      </div>
    </div>
    
    <div class="mt-4 d-flex gap-2">
      <button type="submit" class="btn btn-primary" [disabled]="clienteForm.invalid">
        {{ isEditing ? 'Actualizar' : 'Guardar' }}
      </button>
      <button type="button" class="btn btn-secondary" routerLink="/clientes">Cancelar</button>
    </div>
  </form>
</div>
EOF

cat > src/app/components/cliente-detail/cliente-detail.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Cliente } from '../../models/cliente.model';
import { ClienteService } from '../../services/cliente.service';

@Component({
  selector: 'app-cliente-detail',
  templateUrl: './cliente-detail.component.html',
  styleUrls: ['./cliente-detail.component.scss']
})
export class ClienteDetailComponent implements OnInit {
  cliente: Cliente | null = null;
  clienteId: number;
  
  constructor(
    private clienteService: ClienteService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.clienteId = 0;
  }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.clienteId = +params['id'];
        this.loadClienteDetail();
      }
    });
  }

  loadClienteDetail(): void {
    this.clienteService.getClienteById(this.clienteId).subscribe({
      next: (data) => {
        this.cliente = data;
      },
      error: (error) => {
        console.error('Error al cargar detalles del cliente', error);
        alert('Error al cargar los detalles del cliente');
        this.router.navigate(['/clientes']);
      }
    });
  }

  verFacturas(): void {
    this.router.navigate(['/clientes', this.clienteId, 'facturas']);
  }

  editarCliente(): void {
    this.router.navigate(['/clientes/editar', this.clienteId]);
  }

  volver(): void {
    this.router.navigate(['/clientes']);
  }
}
EOF

cat > src/app/components/cliente-detail/cliente-detail.component.html << 'EOF'
<div class="container mt-4">
  <div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h2 class="mb-0">Detalles del Cliente</h2>
      <button class="btn btn-secondary" (click)="volver()">Volver</button>
    </div>
    
    <div class="card-body" *ngIf="cliente">
      <div class="row mb-3">
        <div class="col-md-6">
          <p><strong>ID:</strong> {{ cliente.id }}</p>
          <p><strong>Nombre:</strong> {{ cliente.nombre }}</p>
          <p><strong>Apellido:</strong> {{ cliente.apellido }}</p>
          <p><strong>Documento:</strong> {{ cliente.documento }}</p>
        </div>
        <div class="col-md-6">
          <p><strong>Teléfono:</strong> {{ cliente.telefono }}</p>
          <p><strong>Email:</strong> {{ cliente.email }}</p>
          <p><strong>Dirección:</strong> {{ cliente.direccion || 'No especificada' }}</p>
        </div>
      </div>
      
      <div class="mt-3">
        <button class="btn btn-warning me-2" (click)="editarCliente()">Editar</button>
        <button class="btn btn-info" (click)="verFacturas()">Ver Facturas</button>
      </div>
    </div>
    
    <div class="card-body" *ngIf="!cliente">
      <p class="text-center">Cargando información del cliente...</p>
    </div>
  </div>
</div>
EOF

cat > src/app/components/cliente-facturas/cliente-facturas.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ClienteConFacturas } from '../../models/cliente-con-facturas.model';
import { ClienteService } from '../../services/cliente.service';

@Component({
  selector: 'app-cliente-facturas',
  templateUrl: './cliente-facturas.component.html',
  styleUrls: ['./cliente-facturas.component.scss']
})
export class ClienteFacturasComponent implements OnInit {
  clienteConFacturas: ClienteConFacturas | null = null;
  clienteId: number;
  displayedColumns: string[] = ['id', 'numero', 'fechaEmision', 'total', 'descripcion'];
  
  constructor(
    private clienteService: ClienteService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.clienteId = 0;
  }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.clienteId = +params['id'];
        this.loadClienteConFacturas();
      }
    });
  }

  loadClienteConFacturas(): void {
    this.clienteService.getClienteConFacturas(this.clienteId).subscribe({
      next: (data) => {
        this.clienteConFacturas = data;
      },
      error: (error) => {
        console.error('Error al cargar cliente con facturas', error);
        alert('Error al cargar las facturas del cliente');
        this.router.navigate(['/clientes']);
      }
    });
  }

  volver(): void {
    this.router.navigate(['/clientes', this.clienteId]);
  }
}
EOF

cat > src/app/components/cliente-facturas/cliente-facturas.component.html << 'EOF'
<div class="container mt-4">
  <div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h2 class="mb-0">Facturas del Cliente</h2>
      <button class="btn btn-secondary" (click)="volver()">Volver</button>
    </div>
    
    <div class="card-body" *ngIf="clienteConFacturas">
      <div class="mb-4">
        <h3>Información del Cliente</h3>
        <p><strong>ID:</strong> {{ clienteConFacturas.cliente.id }}</p>
        <p><strong>Nombre Completo:</strong> {{ clienteConFacturas.cliente.nombre }} {{ clienteConFacturas.cliente.apellido }}</p>
        <p><strong>Documento:</strong> {{ clienteConFacturas.cliente.documento }}</p>
      </div>
      
      <h3>Listado de Facturas</h3>
      
      <div class="table-responsive mt-3" *ngIf="clienteConFacturas.facturas.length > 0">
        <table class="table table-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Número</th>
              <th>Fecha Emisión</th>
              <th>Total</th>
              <th>Descripción</th>
            </tr>
          </thead>
          <tbody>
            <tr *ngFor="let factura of clienteConFacturas.facturas">
              <td>{{ factura.id }}</td>
              <td>{{ factura.numero }}</td>
              <td>{{ factura.fechaEmision | date:'dd/MM/yyyy' }}</td>
              <td>{{ factura.total | currency }}</td>
              <td>{{ factura.descripcion || 'Sin descripción' }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div *ngIf="clienteConFacturas.facturas.length === 0" class="alert alert-info">
        Este cliente no tiene facturas registradas.
      </div>
    </div>
    
    <div class="card-body" *ngIf="!clienteConFacturas">
      <p class="text-center">Cargando información de facturas...</p>
    </div>
  </div>
</div>
EOF

cat > src/app/components/navbar/navbar.component.ts << 'EOF'
import { Component } from '@angular/core';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent {
  constructor() { }
}
EOF

cat > src/app/components/navbar/navbar.component.html << 'EOF'
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" routerLink="/">Sistema de Gestión de Clientes</a>
    
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" routerLink="/clientes" routerLinkActive="active">Clientes</a>
        </li>
      </ul>
    </div>
  </div>
</nav>
EOF

# Configurar el módulo principal
echo "Configurando app.module.ts..."
cat > src/app/app.module.ts << 'EOF'
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { ClienteListComponent } from './components/cliente-list/cliente-list.component';
import { ClienteFormComponent } from './components/cliente-form/cliente-form.component';
import { ClienteDetailComponent } from './components/cliente-detail/cliente-detail.component';
import { ClienteFacturasComponent } from './components/cliente-facturas/cliente-facturas.component';
import { NavbarComponent } from './components/navbar/navbar.component';

@NgModule({
  declarations: [
    AppComponent,
    ClienteListComponent,
    ClienteFormComponent,
    ClienteDetailComponent,
    ClienteFacturasComponent,
    NavbarComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    BrowserAnimationsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
EOF

# Configurar rutas
echo "Configurando app-routing.module.ts..."
cat > src/app/app-routing.module.ts << 'EOF'
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ClienteListComponent } from './components/cliente-list/cliente-list.component';
import { ClienteFormComponent } from './components/cliente-form/cliente-form.component';
import { ClienteDetailComponent } from './components/cliente-detail/cliente-detail.component';
import { ClienteFacturasComponent } from './components/cliente-facturas/cliente-facturas.component';

const routes: Routes = [
  { path: '', redirectTo: '/clientes', pathMatch: 'full' },
  { path: 'clientes', component: ClienteListComponent },
  { path: 'clientes/nuevo', component: ClienteFormComponent },
  { path: 'clientes/editar/:id', component: ClienteFormComponent },
  { path: 'clientes/:id', component: ClienteDetailComponent },
  { path: 'clientes/:id/facturas', component: ClienteFacturasComponent },
  { path: '**', redirectTo: '/clientes' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
EOF

# Configurar app.component
echo "Configurando app.component..."
cat > src/app/app.component.html << 'EOF'
<app-navbar></app-navbar>
<router-outlet></router-outlet>
EOF

# Configurar estilos globales
echo "Configurando estilos globales..."
cat > src/styles.scss << 'EOF'
/* Bootstrap import */
@import 'bootstrap/dist/css/bootstrap.min.css';

/* Estilos globales */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f8f9fa;
}

.required-field::after {
  content: " *";
  color: red;
}

.table-responsive {
  overflow-x: auto;
}

.btn {
  margin-right: 0.25rem;
}

.card {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  border: none;
}

.card-header {
  background-color: #f8f9fa;
}
EOF

# Actualizar el archivo index.html
echo "Configurando index.html..."
cat > src/index.html << 'EOF'
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Sistema de Gestión de Clientes</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>
  <app-root></app-root>
</body>
</html>
EOF

# Instrucciones para compilar y ejecutar
echo "
=============================================
APLICACIÓN ANGULAR PARA API DE CLIENTES CREADA
=============================================

Para ejecutar la aplicación:

1. Navega al directorio cliente-app:
   cd cliente-app

2. Instala las dependencias:
   npm install

3. Ejecuta el servidor de desarrollo:
   ng serve

4. Abre tu navegador en http://localhost:4200

Para compilar para producción:
   ng build --prod

Los archivos compilados estarán disponibles en la carpeta dist/cliente-app
"

# Fin del script
echo "Script de creación finalizado."
