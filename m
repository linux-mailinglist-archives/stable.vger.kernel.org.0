Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9869EF003
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfKDVvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730616AbfKDVvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:51:49 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6166217F5;
        Mon,  4 Nov 2019 21:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904308;
        bh=3jd1QXiIJq7pwdxdFPxZxL35hTozreZSrHTnwM13H/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjtlbtxU9YfMjUoYoq4d91Xn5oByg13R4vssd7cmbYehFSbfauwWJ39DTAHXSLu8K
         RziDHMsKHFxtyzDXxE1dWkaFyOEMU4eQAZpyJD0U86hZ0xKEeBYDyrmdcUGQ5tnTTM
         shC7YWU5jtFHAh6DYjEfeCdPcrHVNp/DIns85GSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 59/62] ALSA: timer: Follow standard EXPORT_SYMBOL() declarations
Date:   Mon,  4 Nov 2019 22:45:21 +0100
Message-Id: <20191104211959.358824279@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 988563929d5b65c021439880ac6bd1b207722f26 ]

Just a tidy up to follow the standard EXPORT_SYMBOL*() declarations
in order to improve grep-ability.

- Move EXPORT_SYMBOL*() to the position right after its definition

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index 152254193c697..cfcc6718aafce 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -318,6 +318,7 @@ int snd_timer_open(struct snd_timer_instance **ti,
 	*ti = timeri;
 	return 0;
 }
+EXPORT_SYMBOL(snd_timer_open);
 
 /*
  * close a timer instance
@@ -383,6 +384,7 @@ int snd_timer_close(struct snd_timer_instance *timeri)
 	mutex_unlock(&register_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(snd_timer_close);
 
 unsigned long snd_timer_resolution(struct snd_timer_instance *timeri)
 {
@@ -397,6 +399,7 @@ unsigned long snd_timer_resolution(struct snd_timer_instance *timeri)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(snd_timer_resolution);
 
 static void snd_timer_notify1(struct snd_timer_instance *ti, int event)
 {
@@ -588,6 +591,7 @@ int snd_timer_start(struct snd_timer_instance *timeri, unsigned int ticks)
 	else
 		return snd_timer_start1(timeri, true, ticks);
 }
+EXPORT_SYMBOL(snd_timer_start);
 
 /*
  * stop the timer instance.
@@ -601,6 +605,7 @@ int snd_timer_stop(struct snd_timer_instance *timeri)
 	else
 		return snd_timer_stop1(timeri, true);
 }
+EXPORT_SYMBOL(snd_timer_stop);
 
 /*
  * start again..  the tick is kept.
@@ -616,6 +621,7 @@ int snd_timer_continue(struct snd_timer_instance *timeri)
 	else
 		return snd_timer_start1(timeri, false, 0);
 }
+EXPORT_SYMBOL(snd_timer_continue);
 
 /*
  * pause.. remember the ticks left
@@ -627,6 +633,7 @@ int snd_timer_pause(struct snd_timer_instance * timeri)
 	else
 		return snd_timer_stop1(timeri, false);
 }
+EXPORT_SYMBOL(snd_timer_pause);
 
 /*
  * reschedule the timer
@@ -808,6 +815,7 @@ void snd_timer_interrupt(struct snd_timer * timer, unsigned long ticks_left)
 	if (use_tasklet)
 		tasklet_schedule(&timer->task_queue);
 }
+EXPORT_SYMBOL(snd_timer_interrupt);
 
 /*
 
@@ -858,6 +866,7 @@ int snd_timer_new(struct snd_card *card, char *id, struct snd_timer_id *tid,
 		*rtimer = timer;
 	return 0;
 }
+EXPORT_SYMBOL(snd_timer_new);
 
 static int snd_timer_free(struct snd_timer *timer)
 {
@@ -977,6 +986,7 @@ void snd_timer_notify(struct snd_timer *timer, int event, struct timespec *tstam
 	}
 	spin_unlock_irqrestore(&timer->lock, flags);
 }
+EXPORT_SYMBOL(snd_timer_notify);
 
 /*
  * exported functions for global timers
@@ -992,11 +1002,13 @@ int snd_timer_global_new(char *id, int device, struct snd_timer **rtimer)
 	tid.subdevice = 0;
 	return snd_timer_new(NULL, id, &tid, rtimer);
 }
+EXPORT_SYMBOL(snd_timer_global_new);
 
 int snd_timer_global_free(struct snd_timer *timer)
 {
 	return snd_timer_free(timer);
 }
+EXPORT_SYMBOL(snd_timer_global_free);
 
 int snd_timer_global_register(struct snd_timer *timer)
 {
@@ -1006,6 +1018,7 @@ int snd_timer_global_register(struct snd_timer *timer)
 	dev.device_data = timer;
 	return snd_timer_dev_register(&dev);
 }
+EXPORT_SYMBOL(snd_timer_global_register);
 
 /*
  *  System timer
@@ -2121,17 +2134,3 @@ static void __exit alsa_timer_exit(void)
 
 module_init(alsa_timer_init)
 module_exit(alsa_timer_exit)
-
-EXPORT_SYMBOL(snd_timer_open);
-EXPORT_SYMBOL(snd_timer_close);
-EXPORT_SYMBOL(snd_timer_resolution);
-EXPORT_SYMBOL(snd_timer_start);
-EXPORT_SYMBOL(snd_timer_stop);
-EXPORT_SYMBOL(snd_timer_continue);
-EXPORT_SYMBOL(snd_timer_pause);
-EXPORT_SYMBOL(snd_timer_new);
-EXPORT_SYMBOL(snd_timer_notify);
-EXPORT_SYMBOL(snd_timer_global_new);
-EXPORT_SYMBOL(snd_timer_global_free);
-EXPORT_SYMBOL(snd_timer_global_register);
-EXPORT_SYMBOL(snd_timer_interrupt);
-- 
2.20.1



