	<%@ page import=" java.awt.Color, java.awt.Frame, java.awt.Graphics, java.awt.Image,
	 java.awt.Toolkit,
	java.awt.event.KeyEvent,
	 java.awt.event.KeyListener,
	 java.awt.event.WindowAdapter,
	 java.awt.event.WindowEvent,
	 java.awt.image.BufferStrategy,
	java.util.ArrayList,
	 java.util.Arrays,
	 java.util.Random"%>
	 <HTML>
 	<BODY>
<%	class Snake_v001 extends Frame implements KeyListener {

		private final BufferStrategy strategy;
		private Random rand;
		private int width = 1024, height = 512; // window settings
		private int[] head;
		private int dir;
		private int xlaenge;
		private int ylaenge;
		private int actualdir;
		private boolean playvar;
		private boolean pressedf;
		private int[] seed;
		private ArrayList<Integer> position;
		private boolean gameover;
		private int blinker;
		private int idle;
		private ArrayList<Integer> segmentdir;
		private int[] endsegment;
		private Image img;

		public Snake_v001() {
			idle = 40;
			dir = 0;
			blinker = 0;
			playvar = false;
			pressedf = false;
			actualdir = 4;
			head = new int[] { 32, 32 };
			seed = new int[2];
			endsegment = new int[] { 0, 3, 4, 1, 2 };
			rand = new Random();
			xlaenge = (width - 3) / head[0];
			ylaenge = (height - 32) / head[1];
			width = xlaenge * head[0] + head[0] + 3;
			height = ylaenge * head[1] + 33 + head[1];
			position = new ArrayList<Integer>(Arrays.asList(0, 0, 0, 1, 0, 2, 0, 3));
			segmentdir = new ArrayList<Integer>(Arrays.asList(4, 44, 44, 4));
			Image img = getToolkit().getImage("C:\\Users\\FreierP\\Pictures\\Camera Roll\\New_Super_Mario_Bros.jpg");
			setseed();
			setSize(width, height);
			setTitle("Snake");
			setResizable(false);
			addWindowListener(new WindowAdapter() {
				@Override
				public void windowClosing(WindowEvent e) {
					dispose();
				}
			});
			addKeyListener(this);
			setVisible(true);
			createBufferStrategy(2);
			strategy = getBufferStrategy();
		}

		public void gameLoop() {
			try {
				while (!gameover) {
					calculateScene();
					renderScene();
					Thread.sleep(idle);
				}
				Thread.sleep(2000);
				dispose();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

		private void calculateScene() {
			deadoralive();
			if (gameover == true)
				return;
			nextStep();
			eat();
		}

		private void renderScene() {
			Graphics graphics = strategy.getDrawGraphics();
			graphics.setColor(Color.black);
			graphics.fillRect(0, 0, width, height);
			graphics.drawImage(img,3,32,this);
			renderBlinker(graphics);
			renderSnake(graphics);
			graphics.setColor(Color.WHITE);
			graphics.drawString("Punktestand: " + position.size() / 2, 3, 42);
			graphics.dispose();
			strategy.show();
			Toolkit.getDefaultToolkit().sync();
		}

		private void renderSnake(Graphics graphics) {
			if (gameover == true)
				graphics.setColor(Color.ORANGE);
			else
				graphics.setColor(Color.RED);
			for (int i = 0; position.size() - 1 >= i; i += 2) {
				int richtung;

				if (i == 0 || i == position.size() - 2) {
					if (i == 0) {
						richtung = segmentdir.get(i / 2);
					} else
						richtung = endsegment[segmentdir.get(i / 2)];
					switch (richtung) {
					case 1:
						graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32 + head[1] / 2,
								head[0], head[1] / 2);
						break;
					case 2:
						graphics.fillRect(position.get(i) * head[0] + 3 + head[0] / 2, position.get(i + 1) * head[1] + 32,
								head[0] / 2, head[1]);
						break;
					case 3:
						graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0],
								head[1] / 2);
						break;
					case 4:
						graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0] / 2,
								head[1]);
						break;
					}
					graphics.fillOval(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0], head[1]);
				} else
					switch (segmentdir.get(i / 2)) {
					case 11:
						rect(graphics, i);
						break;
					case 12:
						oval(graphics, i, 3);
						break;
					case 14:
						oval(graphics, i, 4);
						break;
					case 21:
						oval(graphics, i, 1);
						break;
					case 22:
						rect(graphics, i);
						break;
					case 23:
						oval(graphics, i, 4);
						break;
					case 32:
						oval(graphics, i, 2);
						break;
					case 33:
						rect(graphics, i);
						break;
					case 34:
						oval(graphics, i, 1);
						break;
					case 41:
						oval(graphics, i, 2);
						break;
					case 43:
						oval(graphics, i, 3);
						break;
					case 44:
						rect(graphics, i);
						break;
					}
			}
		}

		private void oval(Graphics graphics, int i, int modus) {
			graphics.fillOval(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0], head[1]);
			switch (modus) {
			case 1:
				graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0] / 2, head[1]);
				graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32 + head[1] / 2, head[0],
						head[1] / 2);
				break;
			case 2:
				graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32 + head[0] / 2, head[0],
						head[1] / 2);
				graphics.fillRect(position.get(i) * head[0] + 3 + head[0] / 2, position.get(i + 1) * head[1] + 32,
						head[0] / 2, head[1]);
				break;
			case 3:
				graphics.fillRect(position.get(i) * head[0] + 3 + head[0] / 2, position.get(i + 1) * head[1] + 32,
						head[0] / 2, head[1]);
				graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0], head[1]/2);
				break;
			case 4:
				graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0], head[1]/2);
				graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0] / 2, head[1]);
				break;
			}
		}

		private void rect(Graphics graphics, int i) {
			graphics.fillRect(position.get(i) * head[0] + 3, position.get(i + 1) * head[1] + 32, head[0], head[1]);
		}

		private void renderBlinker(Graphics graphics) {
			graphics.setColor(Color.green);
			if (blinker == 1000 / idle)
				blinker = 0;
			blinker++;
			if (blinker <= 500 / idle)
				graphics.fillOval(seed[0] * head[0] + 3, seed[1] * head[1] + 32, head[0], head[1]);
			else if (blinker <= 1000 / idle)
				graphics.fillOval((seed[0] * head[0] + 3) + head[0] / 4, (seed[1] * head[1] + 32) + head[1] / 4,
						head[0] / 2, head[1] / 2);

		}

		private void eat() {
			if (position.get(0) == seed[0] && position.get(1) == seed[1]) {
				setseed();
			} else {
				position.remove(position.size() - 1);
				position.remove(position.size() - 1);
				segmentdir.remove(segmentdir.size() - 1);
			}
			updateSegmentdir();
		}

		private void deadoralive() {
			for (int i = 0; i < position.size(); i += 2) {
				for (int j = i + 2; j < position.size(); j += 2) {
					if (position.get(i) == position.get(j) && position.get(i + 1) == position.get(j + 1)) {
						gameover = true;
						return;
					}
				}
			}
		}

		public void setseed() {
	//		ArrayList<Integer> belegt=new ArrayList<Integer>();
	//		for (int i = 0; i < position.size()-1; i+=2) {
	//			belegt.add(0,position.get(i)*ylaenge+position.get(i+1));
	//		System.out.println(belegt);
	//		//anderr array
	//		}
	//		int random=(int)(Math.random()*xlaenge*ylaenge);
			seed[0] = rand.nextInt(xlaenge);
			seed[1] = rand.nextInt(ylaenge);
		}

		public void nextStep() {
			if (!pressedf)
				changeDirection();
			if (playvar)
				moveDiagonal();
			else
				moveNormal();
			checkBorders();
			dir = 0;
		}

		private void updateSegmentdir() {
			int size = segmentdir.size();
			segmentdir.add(0, actualdir);
			segmentdir.set(1, segmentdir.get(1) + 10 * actualdir);
			segmentdir.set(size, segmentdir.get(size - 1) % 10);
		}

		private void changeDirection() {
			if (dir == 1 && actualdir != 3) {
				actualdir = 1;
			} else if (dir == 2 && actualdir != 4) {
				actualdir = 2;
			} else if (dir == 3 && actualdir != 1) {
				actualdir = 3;
			} else if (dir == 4 && actualdir != 2) {
				actualdir = 4;
			}
		}

		private void moveDiagonal() {
			if (position.get(0) != seed[0]) {
				if (actualdir != 2)
					position.add(0, position.get(0) + 1);
				else
					position.add(0, position.get(0) - 1);
			} else
				position.add(0, position.get(0));

			if (position.get(2) != seed[1]) {
				if (actualdir != 1)
					position.add(1, position.get(2) + 1);
				else
					position.add(1, position.get(2) - 1);
			} else
				position.add(1, position.get(2));
		}

		private void moveNormal() {
			if (actualdir == 1) {
				position.add(0, position.get(0));
				position.add(1, position.get(2) - 1);
			} else if (actualdir == 2) {
				position.add(0, position.get(0) - 1);
				position.add(1, position.get(2));
			} else if (actualdir == 3) {
				position.add(0, position.get(0));
				position.add(1, position.get(2) + 1);
			} else if (actualdir == 4) {
				position.add(0, position.get(0) + 1);
				position.add(1, position.get(2));
			}
		}

		private void checkBorders() {
			if (position.get(0) > xlaenge) {
				position.set(0, 0);
			} else if (position.get(0) < 0) {
				position.set(0, xlaenge);
			} else if (position.get(1) > ylaenge) {
				position.set(1, 0);
			} else if (position.get(1) < 0) {
				position.set(1, ylaenge);
			}
		}

		@Override
		public void keyPressed(KeyEvent e) {
			int keys = e.getKeyCode();
			if (keys == KeyEvent.VK_W)
				dir = 1;
			else if (keys == KeyEvent.VK_A)
				dir = 2;
			else if (keys == KeyEvent.VK_S)
				dir = 3;
			else if (keys == KeyEvent.VK_D)
				dir = 4;
			else if (keys == KeyEvent.VK_F)
				pressedf = !pressedf;
			else if (keys == KeyEvent.VK_G)
				playvar = !playvar;
		}

		@Override
		public void keyReleased(KeyEvent arg0) {
		}

		@Override
		public void keyTyped(KeyEvent arg0) {
		}

	}%>
</BODY>
</HTML>
