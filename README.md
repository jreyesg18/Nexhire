# Nexhire

Selección de personal con matching psicométrico — encontrá al candidato ideal de forma objetiva y sin sesgos de IA.

Nexhire es una plataforma SaaS full-stack donde reclutadores publican ofertas laborales y postulantes construyen su perfil profesional. El diferencial está en el motor de compatibilidad: cada candidato completa un test psicológico Big Five (OCEAN) y el sistema calcula matemáticamente qué tan bien encaja con el perfil ideal que definió el reclutador para cada cargo.

## El problema que resuelve

Los procesos de selección tradicionales dependen de la intuición del reclutador o de herramientas de IA que son cajas negras. Nexhire introduce una capa de evaluación psicométrica objetiva: el mismo test validado para todos los candidatos, una fórmula determinista para calcular el match, y un ranking transparente donde cada puntaje puede explicarse. Sin IA, sin bias, sin misterio.

## Demo

```
bin/dev → http://localhost:3000
```

| Rol | Email | Contraseña |
|---|---|---|
| Reclutador | recruiter@nexhire.com | password |
| Postulante (test activo) | applicant1@nexhire.com | password |
| Postulante (test vencido) | applicant2@nexhire.com | password |

| Vista | Descripción |
|---|---|
| `/` | Landing page pública |
| `/users/sign_up` | Registro con selección de rol |
| `/job_offers` | Listado público de ofertas |
| `/job_offers/:id` | Detalle de oferta + match % del candidato |
| `/applicants/profile` | Perfil estilo LinkedIn del postulante |
| `/applicants/personality_test` | Test OCEAN de 30 preguntas |
| `/job_applications` | Historial de postulaciones del candidato |
| `/recruiters/job_offers` | Dashboard del reclutador |
| `/recruiters/job_offers/:id` | Ranking de candidatos por oferta |
| `/recruiters/job_offers/:id/job_applications/:id` | Perfil completo del candidato + breakdown OCEAN |

## Funcionalidades

**Autenticación con roles** — registro, login y logout con Devise. Al registrarse, el usuario elige su rol (postulante o reclutador) y el sistema lo redirige al flujo correspondiente.

**Perfil profesional del postulante** — nombre, foto, skills y un historial dinámico de experiencia laboral y educación, editable en cualquier momento.

**Test psicométrico Big Five (OCEAN)** — 30 preguntas con escala Likert 1–5, mapeadas a las cinco dimensiones de personalidad (Apertura, Responsabilidad, Extraversión, Amabilidad, Neuroticismo). El resultado es válido por 90 días; vencido ese plazo, el sistema exige retomarlo antes de postular.

**Scoring 100% heurístico** — sin IA. Cada pregunta tiene dirección positiva o inversa. El puntaje por dimensión se calcula sumando las respuestas ponderadas y normalizando a una escala 0–100. La fórmula es reproducible y auditable.

**Match % determinista** — al postular, el sistema compara los scores OCEAN del candidato con el perfil ideal definido por el reclutador usando la fórmula `100 - promedio(|score_candidato - score_ideal|)` por dimensión. El snapshot OCEAN queda congelado en la postulación para mantener integridad histórica.

**Dashboard del reclutador** — gestión completa de ofertas laborales con configuración del perfil OCEAN ideal por cargo (sliders 0–100 por dimensión). Vista de candidatos rankeados con match % y breakdown visual por dimensión.

**Gestión de postulaciones** — el reclutador puede marcar cada postulación como `pending`, `reviewed`, `accepted` o `rejected`. El postulante ve el estado actualizado desde su historial.

## Stack técnico

| Capa | Tecnología |
|---|---|
| Backend | Ruby on Rails 8.1 |
| Base de datos | PostgreSQL |
| Frontend | Hotwire (Turbo + Stimulus) |
| Autenticación | Devise |
| Estilos | Tailwind CSS v4 + Glassmorphism custom |
| Assets | Propshaft + Importmap |
| Almacenamiento | Active Storage (fotos de perfil) |

## Decisiones técnicas

**Scoring heurístico en lugar de IA.** Los tests psicométricos validados como el Big Five tienen algoritmos de scoring fijos y publicados. No hay ninguna razón para usar un modelo de lenguaje para calcular algo que es pura aritmética. El resultado es más rápido, más barato, completamente reproducible y elimina el riesgo de alucinaciones o inconsistencias.

**Snapshot OCEAN al postular.** El puntaje del candidato se congela en el momento de la postulación y se guarda en la columna `ocean_snapshot` de `job_applications`. Esto preserva la integridad histórica: si el candidato retoma el test 6 meses después, el match calculado para postulaciones pasadas no cambia.

**Vigencia de 90 días del test.** Evita que un candidato complete el test una sola vez y use ese resultado indefinidamente. El perfil psicológico puede cambiar; 90 días es un equilibrio razonable entre fricción para el usuario y frescura del dato.

**Hotwire en lugar de una SPA.** Para un producto con formularios, perfiles y rankings, Turbo + Stimulus es suficiente y mantiene todo en un solo proyecto Rails. No hay una API separada que mantener, no hay estado de frontend que sincronizar, y el HTML se renderiza en el servidor donde vive la lógica de negocio.

**Roles con enum en el modelo User.** En lugar de una tabla de roles separada, el rol está almacenado como un integer con enum en el modelo `User`. Para dos roles fijos (applicant/recruiter), esto es simple, eficiente y evita joins innecesarios en cada request autenticado.

## Instalación

### Requisitos

- Ruby 3.3+
- PostgreSQL 14+
- Bundler 4+

### Setup

```bash
# 1. Clonar el repositorio
git clone https://github.com/jreyesg18/Nexhire.git
cd Nexhire

# 2. Instalar dependencias
bundle install

# 3. Configurar la base de datos
bin/rails db:create db:schema:load db:seed

# 4. Arrancar
bin/dev
```

> **Nota macOS:** Si tenés el Ruby del sistema (2.6) activo en lugar del de Homebrew, primero ejecutá:
> ```bash
> export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"
> export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"
> ```
> Para que sea permanente, agregá esas líneas a tu `~/.zshrc`.

El seed crea automáticamente un reclutador, dos postulantes y dos ofertas laborales de prueba con sus respectivos puntajes OCEAN.

## Estructura del proyecto

```
.
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb            # Devise params + redirección por rol
│   │   ├── home_controller.rb
│   │   ├── job_offers_controller.rb             # Vista pública de ofertas
│   │   ├── job_applications_controller.rb       # Postulaciones del candidato
│   │   ├── applicants/
│   │   │   ├── profiles_controller.rb
│   │   │   ├── personality_tests_controller.rb  # Scoring heurístico OCEAN
│   │   │   ├── work_experiences_controller.rb
│   │   │   └── educations_controller.rb
│   │   └── recruiters/
│   │       ├── job_offers_controller.rb
│   │       └── job_applications_controller.rb   # Ranking + cambio de estado
│   │
│   ├── models/
│   │   ├── user.rb                         # Roles enum + latest_valid_test_result
│   │   ├── applicant_profile.rb            # skill_list, Active Storage photo
│   │   ├── personality_test_result.rb      # QUESTIONS constant + expired?
│   │   ├── job_offer.rb                    # match_percentage_for_scores/user
│   │   ├── job_application.rb              # ocean_snapshot + match_percentage
│   │   ├── work_experience.rb
│   │   └── education.rb
│   │
│   ├── views/
│   │   ├── home/                           # Landing page
│   │   ├── job_offers/                     # Listado y detalle público
│   │   ├── job_applications/               # Historial del postulante
│   │   ├── applicants/
│   │   │   ├── profiles/                   # Perfil LinkedIn-style
│   │   │   ├── personality_tests/          # Test OCEAN (30 preguntas)
│   │   │   ├── work_experiences/
│   │   │   └── educations/
│   │   ├── recruiters/
│   │   │   ├── job_offers/                 # Dashboard + ranking de candidatos
│   │   │   └── job_applications/           # Perfil completo del candidato
│   │   ├── devise/                         # Registro con selección de rol
│   │   └── layouts/application.html.erb   # Navbar adaptiva por rol
│   │
│   └── javascript/controllers/
│       └── toast_controller.js             # Notificaciones Stimulus
│
├── db/
│   ├── schema.rb
│   └── seeds.rb                            # Datos de prueba listos para usar
│
└── config/routes.rb                        # Namespaces applicants/ + recruiters/
```

## Fórmula de scoring OCEAN

**Paso 1 — Puntaje por ítem:**
```
item_score = dirección == positiva ? respuesta : (6 - respuesta)
```

**Paso 2 — Suma por dimensión** (6 ítems por dimensión, escala resultante 6–30):
```
dimension_sum = Σ item_scores
```

**Paso 3 — Normalización a 0–100:**
```
score = ((dimension_sum - 6) / 24.0) × 100
```

**Paso 4 — Match % candidato vs. oferta:**
```
match = 100 - promedio(|score_candidato[d] - score_ideal[d]|) para d en {O, C, E, A, N}
```

## Herramientas de desarrollo

El scaffolding inicial del proyecto fue generado con Google Antigravity usando Claude Sonnet 4.6. La configuración del entorno, corrección de errores y documentación fueron asistidos con Claude en Cowork.

## Licencia

MIT
