using System.Diagnostics;
using System.Windows.Forms;

namespace PictureBoxRubberBandRectangle
{
    public partial class MainForm : Form
    {
        private Point mStartPoint = Point.Empty;
        private Point mEndPoint = Point.Empty;
        private Bitmap mBitmap;
        private bool mIsSelectingArea = false;
        private Bitmap mSelectedBitmap;
        private Graphics mSelectedGraphics;

        public MainForm()
        {
            InitializeComponent();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            this.mBitmap = null;
        }

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                mIsSelectingArea = true;
                mStartPoint = e.Location;
                if (mBitmap.PixelFormat == System.Drawing.Imaging.PixelFormat.Format8bppIndexed)
                {
                    mSelectedBitmap = new Bitmap(mBitmap);
                }
                else
                {
                    mSelectedBitmap = (Bitmap)mBitmap.Clone();
                }

                mSelectedGraphics = Graphics.FromImage(mSelectedBitmap);
                pictureBox1.Image = mSelectedBitmap;
            }
        }

        private Rectangle GetRectangle(Point start, Point end)
        {
            return new Rectangle(Math.Min(start.X, end.X), Math.Min(start.Y, end.Y), Math.Abs(start.X - end.X), Math.Abs(start.Y - end.Y));
        }

        private void loadImageToolStripMenuItem_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Title = "Select Image";
            openFileDialog.Filter = "그림 파일 (*.jpg, *.gif, *.bmp) | *.jpg; *.gif; *.bmp; | 모든 파일 (*.*) | *.*";

            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    pictureBox1.Image = Bitmap.FromFile(openFileDialog.FileName);
                    mBitmap = (Bitmap)pictureBox1.Image;

                    mStartPoint = Point.Empty;
                    mEndPoint = Point.Empty;
                }
                catch (Exception ex)
                {
                    Debug.WriteLine(ex.Message.ToString());
                }
            }
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
        {
            if (!mIsSelectingArea)
            {
                return;
            }

            mEndPoint = e.Location;
            mSelectedGraphics.DrawImage(mBitmap, 0, 0);

            using (Pen selectPen = new Pen(Color.Red, 1))
            {
                selectPen.DashStyle = System.Drawing.Drawing2D.DashStyle.Dash;
                Rectangle rectangle = GetRectangle(mStartPoint, mEndPoint);
                this.mSelectedGraphics.DrawRectangle(selectPen, rectangle);
            }
            pictureBox1.Refresh();
        }

        private void pictureBox1_MouseUp(object sender, MouseEventArgs e)
        {
            if (!mIsSelectingArea)
            {
                return;
            }

            this.mIsSelectingArea = false;
            this.mSelectedBitmap = null;
            this.mSelectedGraphics = null;

            if (!mStartPoint.IsEmpty && !mEndPoint.IsEmpty)
            {
                Rectangle rect = GetRectangle(mStartPoint, mEndPoint);
                toolStripStatusLabel1.Text = "(top, left, width, height) = (" + rect.X + ", " + rect.Y + ", " + rect.Width + ", " + rect.Height + ")";
            }
            else
            {
                toolStripStatusLabel1.Text = "";
            }
            mStartPoint = Point.Empty;
            mEndPoint = Point.Empty;
        }
    }
}
