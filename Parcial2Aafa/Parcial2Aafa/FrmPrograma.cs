using ClnParcial2Aafa;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Parcial2Aafa
{
    public partial class FrmPrograma : Form
    {
        public FrmPrograma()
        {
            InitializeComponent();
        }

        private void listar()
        {
            dgvLista.DataSource = ProgramaCln.listarPa(txtParametro.Text);
            dgvLista.Columns["id"].Visible = false;
            dgvLista.Columns["idCanal"].Visible = false;
            dgvLista.Columns["Estado"].Visible = false;
        }

        private void FrmPrograma_Load(object sender, EventArgs e)
        {
            Size = new Size(1196, 454);
            listar();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click_1(object sender, EventArgs e)
        {

        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            listar();
        }

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            Size = new Size(1196, 696);
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            Size = new Size(1196, 696);
        }

        private void btnCancelar_Click(object sender, EventArgs e)
        {
            Size = new Size(1196, 454);
        }


        private bool validar()
        {
            bool esValido = true;
            erpCanal.Clear();
            erpDescripcion.Clear();
            erpDuracion.Clear();
            erpTitulo.Clear();
            erpProductor.Clear();
            if (string.IsNullOrWhiteSpace(txtTitulo.Text))
            {
                erpTitulo.SetError(txtTitulo, "El Codigo es obligatorio");
                esValido = false;
            }
            if (string.IsNullOrWhiteSpace(txtDescripcion.Text))
            {
                erpDescripcion.SetError(txtDescripcion, "La Descripcion es obligatorio");
                esValido = false;
            }
            if (string.IsNullOrWhiteSpace (cbxCanal.Text))
            {
                erpCanal.SetError(cbxCanal, "El canal es obligatorio");
                esValido = false;
            }

            return esValido;
        }
        private void btnGuardar_Click(object sender, EventArgs e)
        {
           
        }
    }
}
