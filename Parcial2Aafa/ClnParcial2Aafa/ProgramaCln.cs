using CadParcial2Aafa;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ClnParcial2Aafa
{
    public class ProgramaCln
    {
        public static int crear(Programa programa)
        {
            using (var context = new Parcial2AafaEntities())
            {
                programa.estado = 1; 
                programa.fechaRegistro = DateTime.Now;
                programa.usuarioRegistro = Environment.UserName;

                context.Programa.Add(programa);
                context.SaveChanges();
                return programa.id;
            }
        }

        public static int modificar(Programa programa)
        {
            using (var context = new Parcial2AafaEntities())
            {
                var existente = context.Programa.Find(programa.id);
                if (existente != null)
                {
                    existente.idCanal = programa.idCanal;
                    existente.idCategoriaPrograma = programa.idCategoriaPrograma;                     existente.titulo = programa.titulo;
                    existente.descripcion = programa.descripcion;
                    existente.duracion = programa.duracion;
                    existente.productor = programa.productor;
                    existente.fechaEstreno = programa.fechaEstreno; 
                    existente.usuarioRegistro = Environment.UserName; 
                    return context.SaveChanges();
                }
                return 0;
            }
        }

        public static int eliminar(int id, string usuarioRegistro)
        {
            using (var context = new Parcial2AafaEntities())
            {
                var existente = context.Programa.Find(id);
                if (existente != null)
                {
                    existente.estado = 0; // Eliminación lógica coordinada con el SP
                    existente.usuarioRegistro = usuarioRegistro;
                    return context.SaveChanges();
                }
                return 0;
            }
        }

        public static Programa obtenerUno(int id)
        {
            using (var context = new Parcial2AafaEntities())
            {
                return context.Programa.Find(id);
            }
        }

        public static List<Programa> listar(int id)
        {
            using (var context = new Parcial2AafaEntities())
            {
                return context.Programa.Where(x => x.estado == 1).ToList();
            }
        }

        public static List<paProgramaListar_Result> listarPa(string parametro)
        {
            using (var context = new Parcial2AafaEntities())
            {
                return context.paProgramaListar(parametro.Trim()).ToList();
            }
        }
    }
}