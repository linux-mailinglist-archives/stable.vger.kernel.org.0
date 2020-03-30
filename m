Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F104E198095
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgC3QJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 12:09:57 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43373 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729991AbgC3QJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 12:09:56 -0400
Received: by mail-qt1-f193.google.com with SMTP id a5so15494256qtw.10;
        Mon, 30 Mar 2020 09:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8az6hDKY7FHJFo4TlScJiI//xvWvp101VJi61sHgWdg=;
        b=dTRP83aFcRU4vEXJxSAzvSa5sPU/M09cTwacAA1KR6B9DY6ey0WJXcMe3LQ83VVWq4
         HWwZ4/QMUffdrVEDBTnNMP0p5aN0KjuTj8juP92mtl2ZbKZ5fYWpiSZMvMhgLB6M0dyx
         lPEdURknnTujUsxilQCQOp90T/2Le7yxPnwq5+XszHQPv0ldKtJQWyX1J3LaY5d+gW5B
         J2/aHhO0jO+3p6PaF1BHq6XlrxcveJCentnxvUHxbkk+7JuMNd+9REXb8uoIV2I11VXG
         JC4/iTdjj1q1C6EpSQNQXzf6gdnW21vLkait+hM5bnn28GdPeh7XHpW99jhuW2kZJT4o
         m0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8az6hDKY7FHJFo4TlScJiI//xvWvp101VJi61sHgWdg=;
        b=A3/UKRH5St9uukb6uts2jjPZ5eg8cZCvYptdaa4w+ILoqdxTvs2Zb47JsuJ+c3Uud9
         JbdLXLVK9tmLmqGHNWB6g4x8r+jd/RDLs1DZlNyAUG+KcYuTYJrfCMzgiGORIjusw2ST
         3kUy5gGqUcOmeYf/Z+hEEsYL+cil5RUtuapM+4LcAfo2UDz7wJ1du1eYAuNmR0qAwJIp
         V2eRclbNAh1QmDwPk1kJ7KvSL9FqgU0KU/WzVLkncb7o7pNEuFVATWlOdjuQVZwNAahv
         Io/SIqH8+IAkQ1MK86VQLAqlTVHg81L5G4Gjb0Zc+p8qHHhqHiJu3mcyif98OTGl90fM
         gmWA==
X-Gm-Message-State: ANhLgQ3KO/5pqaBOaP/jrqnvwiISzpIpkUV4Nu3MAQ3OgwjQ+vkNLRCH
        A5QJtAuAUrKRXAzgrBc55yo=
X-Google-Smtp-Source: ADFU+vsiUQM589r3oUJoHwSoYDrP4Gt6tMo4znqgcFYYE3Y0zumUCKoUa5W0aXTe7hbAJwKnxal6jA==
X-Received: by 2002:aed:3e50:: with SMTP id m16mr677800qtf.75.1585584594983;
        Mon, 30 Mar 2020 09:09:54 -0700 (PDT)
Received: from stingray.lan (pool-173-76-255-234.bstnma.fios.verizon.net. [173.76.255.234])
        by smtp.gmail.com with ESMTPSA id z18sm11789091qtz.77.2020.03.30.09.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:09:54 -0700 (PDT)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     alsa-devel@alsa-project.org
Cc:     linux-kernel@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hui Wang <hui.wang@canonical.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Sergey Bostandzhyan <jin@mediatomb.cc>,
        Takashi Iwai <tiwai@suse.com>,
        Tomas Espeleta <tomas.espeleta@gmail.com>
Subject: [PATCH v2 2/3] ALSA: hda/realtek - Set principled PC Beep configuration for ALC256
Date:   Mon, 30 Mar 2020 12:09:38 -0400
Message-Id: <bf22b417d1f2474b12011c2a39ed6cf8b06d3bf5.1585584498.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1585584498.git.tommyhebb@gmail.com>
References: <cover.1585584498.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Realtek PC Beep Hidden Register[1] is currently set by
patch_realtek.c in two different places:

In alc_fill_eapd_coef(), it's set to the value 0x5757, corresponding to
non-beep input on 1Ah and no 1Ah loopback to either headphones or
speakers. (Although, curiously, the loopback amp is still enabled.) This
write was added fairly recently by commit e3743f431143 ("ALSA:
hda/realtek - Dell headphone has noise on unmute for ALC236") and is a
safe default. However, it happens in the wrong place:
alc_fill_eapd_coef() runs on module load and cold boot but not on S3
resume, meaning the register loses its value after suspend.

Conversely, in alc256_init(), the register is updated to unset bit 13
(disable speaker loopback) and set bit 5 (set non-beep input on 1Ah).
Although this write does run on S3 resume, it's not quite enough to fix
up the register's default value of 0x3717. What's missing is a set of
bit 14 to disable headphone loopback. Without that, we end up with a
feedback loop where the headphone jack is being driven by amplified
samples of itself[2].

This change eliminates the update in alc256_init() and replaces it with
the 0x5757 write from alc_fill_eapd_coef(). Kailang says that 0x5757 is
supposed to be the codec's default value, so using it will make
debugging easier for Realtek.

Affects the ALC255, ALC256, ALC257, ALC235, and ALC236 codecs.

[1] Newly documented in Documentation/sound/hd-audio/realtek-pc-beep.rst

[2] Setting the "Headphone Mic Boost" control from userspace changes
this feedback loop and has been a widely-shared workaround for headphone
noise on laptops like the Dell XPS 13 9350. This commit eliminates the
feedback loop and makes the workaround unnecessary.

Fixes: e3743f431143 ("ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
---

Changes in v2:
- Change fixed value from 0x4727 to 0x5757, which should behave
  identically, on advice from Kailang.

 sound/pci/hda/patch_realtek.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 63e1a56f705b..9efb0a858c64 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -367,7 +367,9 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0233:
 	case 0x10ec0235:
+	case 0x10ec0236:
 	case 0x10ec0255:
+	case 0x10ec0256:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -379,11 +381,6 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0300:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
-	case 0x10ec0236:
-	case 0x10ec0256:
-		alc_write_coef_idx(codec, 0x36, 0x5757);
-		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
-		break;
 	case 0x10ec0275:
 		alc_update_coef_idx(codec, 0xe, 0, 1<<0);
 		break;
@@ -3269,7 +3266,13 @@ static void alc256_init(struct hda_codec *codec)
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 1 << 15); /* Clear bit */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 0 << 15);
-	alc_update_coef_idx(codec, 0x36, 1 << 13, 1 << 5); /* Switch pcbeep path to Line in path*/
+	/*
+	 * Expose headphone mic (or possibly Line In on some machines) instead
+	 * of PC Beep on 1Ah, and disable 1Ah loopback for all outputs. See
+	 * Documentation/sound/hd-audio/realtek-pc-beep.rst for details of
+	 * this register.
+	 */
+	alc_write_coef_idx(codec, 0x36, 0x5757);
 }
 
 static void alc256_shutup(struct hda_codec *codec)
-- 
2.25.2

