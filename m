Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5519A2F1FEB
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391300AbhAKTxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391295AbhAKTxz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 11 Jan 2021 14:53:55 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9067C0617A2
        for <Stable@vger.kernel.org>; Mon, 11 Jan 2021 11:53:14 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id q75so373606wme.2
        for <Stable@vger.kernel.org>; Mon, 11 Jan 2021 11:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n2wcC/+Oemb6wJu9QjneWGvsBk1pMldN5iwdbbx+DU0=;
        b=QSUWq+vXzQjvD7cO88XhR1KZeACh2R3jTEX4GO8JU/r25x7x+/2qt/Cf5s6F8Wkr/F
         K8Gj8AhQGiKT7MXj1pSyHpzRa/xunY+TlpJQOPdt5//deenAHk6/SNrAN/VS4F9QCQeT
         qawBkC82B/ycr+O2aLnojNG/9acUeDrtJPm2OIyoK/myX0ljpIHFGunTH5PZgl54J+Nx
         Ck9y7NBKYBkBBCJlT6LYsBddo5izIKfowAL6B/YsqQbjwRJ7la4c+ZPpVEL6oEOsiW8X
         lm9yQL9Jht3J/wDeek2BnxsGetK0nqL4lA0J8LOv7vOfWzmhwuLtsI0CuSD8KXXJBN+O
         6UtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n2wcC/+Oemb6wJu9QjneWGvsBk1pMldN5iwdbbx+DU0=;
        b=tx2hJYrwbZNIBJYiAWHXqNtKVcBXjLoJ/mHplj1mE5QZO+fO8jQT7E0K5gnavnsskq
         3JN/q/QNhoj9ZOWhYBtneLXqFOxz0P41+qiLsy22bFLypTDec+eimTtN43PMu4YHVRD6
         TvA7CO37X3aplQ1Kp+8MBmVYEQsy8mVrg6QJ7rIAQugmX5ZP2Xyt9hY6aURGz3P7KFK+
         t42YzwAXKDaX15aCAXcPNWjNHkcU4wjO3tDoJNIsHDHd6PJIhLm3kQlQbDkjIXSK9iEu
         95ZWzSNb1cfexJ9DbuLVcQ1LC6NaD4WpYkwaDmOiAcwdIiVtemGcNVhfNvOAwFEoUfOH
         OW8g==
X-Gm-Message-State: AOAM533opAVMmKkAzLqxB12uHVKggam+kY1IxjBxBS2DaEsDpj5MXl96
        sSu5/djPyYuo0MHY7WZwdEw=
X-Google-Smtp-Source: ABdhPJx0/R/yUKLWttFsd/uWVaxemqswhlEuohULSLR/RMj+oox6lMMWyVAmNdpqNrIc3uY4oTTGow==
X-Received: by 2002:a1c:1dd4:: with SMTP id d203mr386752wmd.118.1610394793513;
        Mon, 11 Jan 2021 11:53:13 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id l8sm459664wmf.35.2021.01.11.11.53.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 11:53:12 -0800 (PST)
Date:   Mon, 11 Jan 2021 19:53:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: fix edge-trigger
 interrupts" failed to apply to 4.19-stable tree
Message-ID: <20210111195311.bz65ze4hc4npzzqz@debian>
References: <160915397516183@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="27eb6g3ghy2zv5z6"
Content-Disposition: inline
In-Reply-To: <160915397516183@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--27eb6g3ghy2zv5z6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with ec76d918f230 ("iio: imu: st_lsm6dsx: flip
irq return logic") which made backporting little easier.

--
Regards
Sudip

--27eb6g3ghy2zv5z6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-imu-st_lsm6dsx-flip-irq-return-logic.patch"

From a1dd5a8427b056ae7574a622090401c455f0e01f Mon Sep 17 00:00:00 2001
From: Sean Nyekjaer <sean@geanix.com>
Date: Mon, 15 Jul 2019 09:07:15 +0200
Subject: [PATCH 1/2] iio: imu: st_lsm6dsx: flip irq return logic

commit ec76d918f23034f9f662539ca9c64e2ae3ba9fba upstream

No need for using reverse logic in the irq return,
fix this by flip things around.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index 631360b14ca7..8974d7ba657b 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -481,7 +481,7 @@ static irqreturn_t st_lsm6dsx_handler_thread(int irq, void *private)
 	count = st_lsm6dsx_read_fifo(hw);
 	mutex_unlock(&hw->fifo_lock);
 
-	return !count ? IRQ_NONE : IRQ_HANDLED;
+	return count ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int st_lsm6dsx_buffer_preenable(struct iio_dev *iio_dev)
-- 
2.11.0


--27eb6g3ghy2zv5z6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-iio-imu-st_lsm6dsx-fix-edge-trigger-interrupts.patch"

From 98d9a672f7da10abf7bb3cb36ec5dc755cf6a70d Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 14 Nov 2020 19:39:05 +0100
Subject: [PATCH 2/2] iio: imu: st_lsm6dsx: fix edge-trigger interrupts

commit 3f9bce7a22a3f8ac9d885c9d75bc45569f24ac8b upstream

If we are using edge IRQs, new samples can arrive while processing
current interrupt since there are no hw guarantees the irq line
stays "low" long enough to properly detect the new interrupt.
In this case the new sample will be missed.
Polling FIFO status register in st_lsm6dsx_handler_thread routine
allow us to read new samples even if the interrupt arrives while
processing previous data and the timeslot where the line is "low"
is too short to be properly detected.

Fixes: 89ca88a7cdf2 ("iio: imu: st_lsm6dsx: support active-low interrupts")
Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/5e93cda7dc1e665f5685c53ad8e9ea71dbae782d.1605378871.git.lorenzo@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[sudip: manual backport to old irq handler path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index 8974d7ba657b..4d89de0be58b 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -475,13 +475,29 @@ static irqreturn_t st_lsm6dsx_handler_irq(int irq, void *private)
 static irqreturn_t st_lsm6dsx_handler_thread(int irq, void *private)
 {
 	struct st_lsm6dsx_hw *hw = private;
-	int count;
+	int fifo_len = 0, len;
 
-	mutex_lock(&hw->fifo_lock);
-	count = st_lsm6dsx_read_fifo(hw);
-	mutex_unlock(&hw->fifo_lock);
+	/*
+	 * If we are using edge IRQs, new samples can arrive while
+	 * processing current interrupt since there are no hw
+	 * guarantees the irq line stays "low" long enough to properly
+	 * detect the new interrupt. In this case the new sample will
+	 * be missed.
+	 * Polling FIFO status register allow us to read new
+	 * samples even if the interrupt arrives while processing
+	 * previous data and the timeslot where the line is "low" is
+	 * too short to be properly detected.
+	 */
+	do {
+		mutex_lock(&hw->fifo_lock);
+		len = st_lsm6dsx_read_fifo(hw);
+		mutex_unlock(&hw->fifo_lock);
+
+		if (len > 0)
+			fifo_len += len;
+	} while (len > 0);
 
-	return count ? IRQ_HANDLED : IRQ_NONE;
+	return fifo_len ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int st_lsm6dsx_buffer_preenable(struct iio_dev *iio_dev)
-- 
2.11.0


--27eb6g3ghy2zv5z6--
