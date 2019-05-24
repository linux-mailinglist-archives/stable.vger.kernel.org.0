Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36A29052
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 07:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfEXFVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 01:21:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32983 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfEXFVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 01:21:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id h17so4386142pgv.0
        for <stable@vger.kernel.org>; Thu, 23 May 2019 22:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dZw2XLRnf4iZ+8HINOmAiZ2bSPbP/ZDgrl/m4RkW9o0=;
        b=RugBw5tvj4/uBNxAvP8f7PN7PVQzJufeVQ9QjC33vKALJdMow+m2QDGzdX5THRTs2p
         aT6PkQP7291JSfmEoTi8cGleZWJ0hdg0P9C8rFKKtpY1ufSBWWBAiKi0GKqcTMyqT74Z
         pdF8C2pmRJICIN62SKlRNZr9rB8BBv83Y42nbcp4YVrXFg5UeP7UOMqdRXMHhlRkM+ml
         +aUExL/Jz2xbh+wPR4OHDdW1uDj+719+QCjDRWnvsfofXyF1DrZo1/EgRoY0VuHwY3E1
         F6K4X1KdN8fJ7wY6VXb3a8kn861pigeaSZbQpwcafzsnI0epXqUHwocVLIws4gU26Dzx
         hASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dZw2XLRnf4iZ+8HINOmAiZ2bSPbP/ZDgrl/m4RkW9o0=;
        b=rw1rhUICBT5A/iHlvCuLwkMRvSkdhI7DS/ObUH2dKyQLrSAIgGQDmnXjTAzfSLfmHX
         XW9YBDp0K2OeN/yCoCc8Ee1iB7fcCZgQZK5xYSXx0qpWNQRmcf519OkWKTI20JW5j9ee
         m/H1D0SoxWjQRN6q2gGu/vEv1tnhMXOmPWdUlIPNme7EA/lLNe5xokYflXSetIltBK+x
         N5HWywZ7nCNSnk79rV3pWF2Sg3VyZAlO+Z2xalaZhHT4RNtEKYcB2zrgvo2saevk1UlK
         v/3tpcIQltm2/TSymNVSda787zWBMXvYEHAimU4zDyS8D1+7p+M1FjQe4p2ysM+pYUhd
         Q1gQ==
X-Gm-Message-State: APjAAAXW5baTryoApYxJ/0d9nxbqODKW87IUJg3R8/lWHnImHYQKYtQG
        +QX4/w1Rf6VZaaYIsfXCYSGuyQQHMr+4K6YaZSCYypJ4XrahQqoB0EPmMZbkpvJw9oMXZhPXbpQ
        TEIiHxUo2bPunMMCWAy0m4ytFlGPajePPAMZkrVKe7xcEmwHHqpeZP/ZvdwObm559mUxh9GxO6A
        ==
X-Google-Smtp-Source: APXvYqzqcgqwQ0GEc7AuQBZpH68LGX306PqD5RvbDDdBN9bYf8vn6B1uG9ZNHEiaPvMPlJaXeMK4HQ==
X-Received: by 2002:a17:90a:ac18:: with SMTP id o24mr6783104pjq.116.1558675274744;
        Thu, 23 May 2019 22:21:14 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id x7sm1147224pfm.82.2019.05.23.22.21.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 22:21:14 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     stable@vger.kernel.org
Cc:     linux@endlessm.com, tiwai@suse.de,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH] Revert "ALSA: hda - Enforces runtime_resume after S3 and S4 for each codec"
Date:   Fri, 24 May 2019 13:10:17 +0800
Message-Id: <20190524051015.4680-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have an ASUS E406MA laptop equipped with Intel N5000 CPU.  After
system suspend & resume, the audio playback does not work anymore. The
device for sound output is listed as a headphone device.  Plugging in
headphones no sound is audible neither.

Here are the error messages after resume:

[  184.525681] snd_hda_intel 0000:00:0e.0: azx_get_response timeout, switching to polling mode: last cmd=0x20bf8100
[  185.528682] snd_hda_intel 0000:00:0e.0: No response from codec, disabling MSI: last cmd=0x20bf8100
[  186.532683] snd_hda_intel 0000:00:0e.0: azx_get_response timeout, switching to single_cmd mode: last cmd=0x20bf8100
[  186.736838] snd_hda_codec_realtek hdaudioC0D0: Unable to sync register 0x2b8000. -5
[  186.738742] snd_hda_codec_realtek hdaudioC0D0: Unable to sync register 0x2b8000. -5
[  186.767080] snd_hda_codec_hdmi hdaudioC0D2: Unable to sync register 0x2f0d00. -5

After bisect, we found reverting the commit b5a236c175b0 "ALSA: hda -
Enforces runtime_resume after S3 and S4 for each codec" can solve this
issue on Linux stable 5.0.x series.

This reverts commit a57af6d07512716b78f1a32d9426bcdf6aafc50c.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=203623
Fixes: a57af6d07512 ("ALSA: hda - Enforces runtime_resume after S3 and S4 for each codec")
Cc: <stable@vger.kernel.org> # 5.0.x
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 sound/pci/hda/hda_codec.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b238e903b9d7..dbc9eaa81358 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2952,20 +2952,6 @@ static int hda_codec_runtime_resume(struct device *dev)
 #endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
-static int hda_codec_force_resume(struct device *dev)
-{
-	int ret;
-
-	/* The get/put pair below enforces the runtime resume even if the
-	 * device hasn't been used at suspend time.  This trick is needed to
-	 * update the jack state change during the sleep.
-	 */
-	pm_runtime_get_noresume(dev);
-	ret = pm_runtime_force_resume(dev);
-	pm_runtime_put(dev);
-	return ret;
-}
-
 static int hda_codec_pm_suspend(struct device *dev)
 {
 	dev->power.power_state = PMSG_SUSPEND;
@@ -2975,7 +2961,7 @@ static int hda_codec_pm_suspend(struct device *dev)
 static int hda_codec_pm_resume(struct device *dev)
 {
 	dev->power.power_state = PMSG_RESUME;
-	return hda_codec_force_resume(dev);
+	return pm_runtime_force_resume(dev);
 }
 
 static int hda_codec_pm_freeze(struct device *dev)
@@ -2987,13 +2973,13 @@ static int hda_codec_pm_freeze(struct device *dev)
 static int hda_codec_pm_thaw(struct device *dev)
 {
 	dev->power.power_state = PMSG_THAW;
-	return hda_codec_force_resume(dev);
+	return pm_runtime_force_resume(dev);
 }
 
 static int hda_codec_pm_restore(struct device *dev)
 {
 	dev->power.power_state = PMSG_RESTORE;
-	return hda_codec_force_resume(dev);
+	return pm_runtime_force_resume(dev);
 }
 #endif /* CONFIG_PM_SLEEP */
 
-- 
2.21.0

