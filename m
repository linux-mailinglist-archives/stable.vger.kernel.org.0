Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E510E1F06DB
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 15:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFFN5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 09:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgFFN5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 09:57:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E04C03E96A
        for <stable@vger.kernel.org>; Sat,  6 Jun 2020 06:57:23 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g10so10925275wmh.4
        for <stable@vger.kernel.org>; Sat, 06 Jun 2020 06:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=xfsmSzt88xNplVXKxLC9tYLWFki5wpzyznqbG/0KmNo=;
        b=ndE1/NsffLHnBUXSBauvCEHfvhGitLPmkwEEv+f2ZC0IYFwY3Abow8wySZmrmcKJ8Z
         SJzXDpK6Z34QXqiyx/zlm18jh4dQ5UoB8sBjEHb7T3s70PfbkMVSEYtSSdJFzA9E5nqh
         UEQp0Rxs5ts9fyYAL9FlTfgvoYX33JFOemjDSZhpzaL2wSui0Im8pajbCYg123PqXrlf
         7yYjgStfaAhwz2c4tg1fm+Y9usSuia08gSFcDAVGFAbvAkmc1+a8oLxKjd1YZtjDa3rO
         3q3Z0mgzgVyBtzqbwuQHX1+z1oczUWoSwywqwEH8qqxUnUBzrExung/utIWdI8u+jLYC
         0tXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=xfsmSzt88xNplVXKxLC9tYLWFki5wpzyznqbG/0KmNo=;
        b=toB+0HrAjaN3Rd6TjnbL7KgFYixI3+lNUy5bRYg9XE2LJhsTrPCMa+dlPQNUdEqKxU
         lS4+FGXxvjaDNXTP8SEHHBVobQmerPFQvJtefqyRa5m2os5Qg29FSiBotqd/024DSYjY
         HkOXsEsQ+EjCw6ex/FURAQR5czMtDEDQRjYm/u5n+MAbPWNAzVJ9VY8+dDckceK2sEXR
         9eGKV7Ho4qMRvXs/Y4Z77Uw3C8VsoRxgc7FgLtr9wIkIkDEaIaCRejTomTcuw9HG93gI
         JA6VVw2Hq2sMI3xzHqxV9qGnp7nOrg79tWLjcYCUDeYyBZjW/uVCE9MTuKmPEAb8zXkI
         F16A==
X-Gm-Message-State: AOAM531/WTfj8OtLx9+jbvLY0AXV1RWRYFTqFDpns8dvqymkZiOx8jKy
        zmcc575dYWbUa+o150FEsFI=
X-Google-Smtp-Source: ABdhPJw5zdbEjxR+Yv98vCMEujRuaDXTYf9OzV0/+qVeHttszQx1k/GM/xH/uTzOiLeKUYigcy+zow==
X-Received: by 2002:a05:600c:4146:: with SMTP id h6mr7797080wmm.170.1591451841995;
        Sat, 06 Jun 2020 06:57:21 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id b185sm21011105wmd.3.2020.06.06.06.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 06:57:20 -0700 (PDT)
Date:   Sat, 6 Jun 2020 15:57:20 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Please apply commit 9453264ef586 ("media: go7007: fix a miss of
 snd_card_free") to v4.9.y up to v5.4.y
Message-ID: <20200606135720.GA1832951@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Could you please apply 9453264ef586 ("media: go7007: fix a miss of
snd_card_free") to v4.9.y up to v5.4.y stable series? The fix is
related to CVE-2019-20810.

The commit can be cherry-picked as is for 5.4.y but needs a small
adjustment for context for versions which do not contain c0decac19da3
("media: use strscpy() instead of strlcpy()") and ba78170ef153
("media: go7007: Fix misuse of strscpy"). Attached a respective patch
which applies with that refresh back to v4.9.y.

Regards,
Salvatore

From fd93d8ec8b3447fd29509d2d2f92352e26ff3804 Mon Sep 17 00:00:00 2001
From: Chuhong Yuan <hslester96@gmail.com>
Date: Tue, 10 Dec 2019 04:15:48 +0100
Subject: [PATCH] media: go7007: fix a miss of snd_card_free

go7007_snd_init() misses a snd_card_free() in an error path.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
[Salvatore Bonaccorso: Adjust context for backport to versions which do
not contain c0decac19da3 ("media: use strscpy() instead of strlcpy()")
and ba78170ef153 ("media: go7007: Fix misuse of strscpy")]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 drivers/media/usb/go7007/snd-go7007.c | 35 +++++++++++++--------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index 137fc253b122..96c37a131deb 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -244,22 +244,18 @@ int go7007_snd_init(struct go7007 *go)
 	gosnd->capturing = 0;
 	ret = snd_card_new(go->dev, index[dev], id[dev], THIS_MODULE, 0,
 			   &gosnd->card);
-	if (ret < 0) {
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_snd;
+
 	ret = snd_device_new(gosnd->card, SNDRV_DEV_LOWLEVEL, go,
 			&go7007_snd_device_ops);
-	if (ret < 0) {
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_card;
+
 	ret = snd_pcm_new(gosnd->card, "go7007", 0, 0, 1, &gosnd->pcm);
-	if (ret < 0) {
-		snd_card_free(gosnd->card);
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_card;
+
 	strlcpy(gosnd->card->driver, "go7007", sizeof(gosnd->card->driver));
 	strlcpy(gosnd->card->shortname, go->name, sizeof(gosnd->card->driver));
 	strlcpy(gosnd->card->longname, gosnd->card->shortname,
@@ -270,11 +266,8 @@ int go7007_snd_init(struct go7007 *go)
 			&go7007_snd_capture_ops);
 
 	ret = snd_card_register(gosnd->card);
-	if (ret < 0) {
-		snd_card_free(gosnd->card);
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_card;
 
 	gosnd->substream = NULL;
 	go->snd_context = gosnd;
@@ -282,6 +275,12 @@ int go7007_snd_init(struct go7007 *go)
 	++dev;
 
 	return 0;
+
+free_card:
+	snd_card_free(gosnd->card);
+free_snd:
+	kfree(gosnd);
+	return ret;
 }
 EXPORT_SYMBOL(go7007_snd_init);
 
-- 
2.27.0.rc0

