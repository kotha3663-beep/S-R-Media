package com.sr.media.ui.screens

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.scale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.sr.media.R
import kotlinx.coroutines.delay

@Composable
fun SplashScreen(navController: NavController) {
    var startAnimation by remember { mutableStateOf(false) }
    
    val alphaAnim by animateFloatAsState(
        targetValue = if (startAnimation) 1f else 0f,
        animationSpec = tween(durationMillis = 1000),
        label = "alpha"
    )
    
    val scaleAnim by animateFloatAsState(
        targetValue = if (startAnimation) 1f else 0.5f,
        animationSpec = tween(durationMillis = 1000),
        label = "scale"
    )

    LaunchedEffect(key1 = true) {
        startAnimation = true
        delay(2500) 
        navController.navigate("home") {
            popUpTo("splash") { inclusive = true }
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Image(
                painter = painterResource(id = R.drawable.ic_launcher_foreground), 
                contentDescription = "S R Media Logo",
                modifier = Modifier
                    .size(120.dp)
                    .scale(scaleAnim)
                    .alpha(alphaAnim)
            )
            
            Spacer(modifier = Modifier.height(16.dp))
            
            Text(
                text = "S R Media",
                color = MaterialTheme.colorScheme.primary,
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.alpha(alphaAnim)
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Text(
                text = "All-in-One Media Editor",
                color = MaterialTheme.colorScheme.onBackground.copy(alpha = 0.7f),
                fontSize = 14.sp,
                modifier = Modifier.alpha(alphaAnim)
            )
            
            Spacer(modifier = Modifier.height(48.dp))
            
            CircularProgressIndicator(
                color = MaterialTheme.colorScheme.primary,
                strokeWidth = 3.dp,
                modifier = Modifier
                    .size(40.dp)
                    .alpha(alphaAnim)
            )
        }
    }
}
