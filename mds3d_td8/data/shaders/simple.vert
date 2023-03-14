#version 330 core

#define PI 3.1415926538

uniform mat4 obj_mat;
uniform mat4 proj_mat;
uniform mat4 view_mat;
uniform mat3 normal_mat;

in vec3 vtx_position;
in vec3 vtx_normal;
in vec2 vtx_texcoord;

out vec3 v_normal;
out vec2 v_uv;

vec3 cylinder(float u, float v, vec3 A, vec3 B, float r){

  vec3 t = normalize(B - A); 
  vec3 b = vec3(-t.y, t.x, t.z);
  vec3 n = cross(b, t);
  vec3 p = (1 - u) * A + u * B;

  mat4 mat_tbn = mat4(vec4(t, 0), vec4(b, 0), vec4(n, 0), vec4(p, 1));

  float x = 0;
  float y = r * cos(v * 2 * PI);
  float z = r * sin(v * 2 * PI);

  // vec4 p_cyl = mat_tbn * vec4(x,y,z,1);
  vec4 p_cyl = vec4(x,y,z,1);
  return vec3(p_cyl.x, p_cyl.y, p_cyl.z);
}

vec3 bezier(float u, vec3 B[4], out vec3 tangent, out vec3 normal, out vec3 binormal){
  vec3 p01 = (1-u) * B[0] + u * B[1];
  vec3 p11 = (1-u) * B[1] + u * B[2];
  vec3 p21 = (1-u) * B[2] + u * B[3];

  vec3 p02 = (1-u) * p01 + u * p11; 
  vec3 p12 = (1-u) * p11 + u * p21;

  // Ajouter des paramètres en sortie pour récupérer les points de contrôle.
  tangent = normalize(p12 - p02);
  normal = normalize(cross(tangent, vec3(-tangent.y, tangent.x, tangent.z)));
  binormal = cross(normal, tangent);

  return (1-u) * p02 + u * p12;
}

vec3 cylBezierYZ(float u, float v, vec3 B[4], float r){
  vec3 tangent, normal, binormal;
  vec3 bu = bezier(u, B, tangent, binormal, normal);

  mat4 tbnp = mat4(vec4(tangent, 0), vec4(binormal, 0), vec4(normal, 0), vec4(bu, 1));

  vec2 c_unit = vec2(r * cos(v * 2 * PI), r * sin(v * 2 * PI));

  return (tbnp * vec4(0, c_unit.x, c_unit.y, 1)).xyz;
}

void main()
{
  v_uv  = vtx_texcoord;

  // Cylindre le long d'un axe.
  vec3 A = vec3(1,0,0);
  vec3 B = vec3(-1,1,0);
  vec3 cylinder = cylinder(vtx_texcoord.x, vtx_texcoord.y, A, B, 0.5);

  // Points de la courbe de Bézier.
  vec3 courbe[4];

  courbe = vec3[4](vec3(-1,0,2), vec3(-0.3,0,4), vec3(0.3,0,2), vec3(1,0,-0.5));

  courbe = vec3[4](vec3(-0.5,-1,-1), vec3(1.5, 1,-0.3), vec3(-1.5, 1, 0.3), vec3(0.5,-1,1));

  courbe = vec3[4](vec3(-1,-0.5,-1), vec3(-1, 1,-0.3), vec3(1, -1, 0.3), vec3(1,0.5,1));

  // Cylindre le long d'une courbe de Bézier.
  // vec3 cylinder = cylBezierYZ(vtx_texcoord.x, vtx_texcoord.y, courbe, 0.2);

  v_normal = normalize(normal_mat * vtx_normal);
  vec4 p = view_mat * (obj_mat * vec4(cylinder, 1.)); 
  // Notre fonction remplace vtx_position : vec4 p = view_mat * (obj_mat * vec4(vtx_position, 1.));
  gl_Position = proj_mat * p;
}
