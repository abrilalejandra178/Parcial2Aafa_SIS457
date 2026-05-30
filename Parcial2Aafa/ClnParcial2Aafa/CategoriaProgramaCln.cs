using CadParcial2Aafa;
using System.Collections.Generic;
using System.Linq;

namespace ClnParcial2Aafa
{
    public class CategoriaProgramaCln
    {
        public static List<CategoriaPrograma> listar()
        {
            using (var context = new Parcial2AafaEntities())
            {
                return context.CategoriaPrograma
                    .Where(x => x.estado == 1)
                    .OrderBy(x => x.nombre)
                    .ToList();
            }
        }
    }
}