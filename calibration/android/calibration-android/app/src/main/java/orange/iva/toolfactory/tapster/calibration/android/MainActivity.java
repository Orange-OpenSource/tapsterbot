// SPDX-FileCopyrightText: 2018 Orange SA
// SPDX-License-Identifier: BSD-2-Clause OR MIT

package orange.iva.toolfactory.tapster.calibration.android;

import android.graphics.Point;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Display;
import android.view.MotionEvent;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.FrameLayout.LayoutParams;

/**
 * The main screen of the app.
 * Will display the 2D coordinates of each contact point in the layout.
 *
 * @version 1.0.0
 * @since 23/10/2017
 */
public class MainActivity extends AppCompatActivity {


    /**
     * The width of the screen
     */
    private int mScreenWidth;

    /**
     * The heigfht of the screen
     */
    private int mScreenHeight;


    /**
     * Triggered when the activity will be created
     * @param savedInstanceState - Maye be null
     */
    @Override
    protected void onCreate( Bundle savedInstanceState ){

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        // Get dimensions of screen
        Display display = getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        mScreenWidth = size.x;
        mScreenHeight = size.y;

        // Define the layout wichi will coontain the labels
        RelativeLayout layout = (RelativeLayout) findViewById(R.id.layout);
        LayoutParams params = new LayoutParams(mScreenWidth, mScreenHeight);
        layout.setLayoutParams(params);

        // Without aciton bar, title is hidden, and the bot can click in a higher area
        if( getSupportActionBar() != null ){
            ActionBar actionBar = getSupportActionBar();
            actionBar.hide();
        }

    }

    /**
     * Method used when the user (or the bot) touches the screen.
     * A label is displayed with the 2D coordinates of the contact point.
     *
     * @param event - The touch event, cannot be null
     * @return boolean - Always true
     */
    @Override
    public boolean onTouchEvent( MotionEvent event ){

        // The layout
        RelativeLayout layout = (RelativeLayout) findViewById(R.id.layout);

        // The number of contact points
        int pointerCount = event.getPointerCount();

        layout.removeAllViews();

        // When the last finger is up: clean the layout
        if ( event.getAction() == MotionEvent.ACTION_UP ){

            layout.removeAllViews();

        // Displays the contact coordinates
        } else {

            for ( int i = 0; i < pointerCount; i++ ){

                // FIXME Seems to be the (X,Y) coordinate adjusted to the parent view
                TextView coordinates = new TextView(this);
                int x = (int) event.getX(i);
                int y = (int) event.getY(i);
                coordinates.setText("("+x+", "+y+")");
                coordinates.setTextSize(30);

                final float THRESHOLD_BORDER = 0.25f;
                final float DISPLAY_RATIO_X = 0.60f;
                final float DISPLAY_RATIO_Y = 0.90f;

                // If the contact point is too close of borders, displays the label at the opposite to keep it fully visible

                // Case #1:  Here point placed too close of right border
                if ( x >= mScreenWidth - mScreenWidth * THRESHOLD_BORDER ){
                    coordinates.setX(mScreenWidth * DISPLAY_RATIO_X);
                    coordinates.setY(y);
                // Case #2: Here point placed too close of bottom border
                } else if ( y >= mScreenHeight - mScreenHeight * THRESHOLD_BORDER ){
                    coordinates.setX(x);
                    coordinates.setY(mScreenHeight * DISPLAY_RATIO_Y);
                } else {
                    coordinates.setX(x);
                    coordinates.setY(y);
                }

                layout.addView(coordinates);

            }

        } // End of else of if ( event.getAction() == MotionEvent.ACTION_UP )

        return true;

    }

}
