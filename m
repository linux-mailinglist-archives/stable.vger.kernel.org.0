Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335C22F2026
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbhAKT5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731772AbhAKT5J (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 11 Jan 2021 14:57:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD35C061786
        for <Stable@vger.kernel.org>; Mon, 11 Jan 2021 11:56:28 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d26so981115wrb.12
        for <Stable@vger.kernel.org>; Mon, 11 Jan 2021 11:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HcbH769xv2RyoUQvT/U+6ccJf4JDzAPeruRveXgp81A=;
        b=exrkiPQk8B4HhyAz7ChgvtMmcLuSZH/EOTLiQvVLhaEvXcUj0KAqYppTLi/25xg/xX
         qUh3TBAYJus/u3NfPFFmItQYgwCXKB/VIERIrKTYOtLAxCsHrlJk58QpjhjdZ7y9rpmn
         S/tcchbytdsXVsTaK7gZCI0O/e7MgT/2leweQXqvBmvBWtFNamTF67HDZwAh7U/+4vN+
         /oGFBdqiw+F0tLA1QXzASlw5RrLRU39ZiEwUjazaHql7IWRIiHVIH5LNZOlP+4IZDQQy
         4G9kBrM1KnUXFatn2s6ZVTz5lpNsdCuxglosV54v/wUfrajW6cPxLZ5bVmUr37gTOk5f
         FHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HcbH769xv2RyoUQvT/U+6ccJf4JDzAPeruRveXgp81A=;
        b=LFZUsb/PZ2417m+GjaiJ0SaSf+XcUlwipK/hcl7vnfcu7x4zo6BW5WieeG4dp++d3I
         3GV3DEvfA0aYADRndGa6c/LIGNnoyogiDvkpFRvBoQ7c7YHO5gqd8aeRuJCPQYJWwFDn
         CWcbcl7t1ciw1htTl6+42knqCuEikT9QoTBNpf9mmh44Swg7J1vDNT7+a9eHNA0t4zhC
         ERePZ/w2YVZZRAjCjJQQNeEsrhhFPPoEOHmklAqjVYDL+AzVMNzKEkudTs8BCiGz+/5k
         AsGsdKh/3u+vT9epiOrFt3mfTf6iVm4NqLV0qtGmc8DV4cOQ//Gco58+u/yvXrThMyHY
         Vh8g==
X-Gm-Message-State: AOAM533PL9fgGuX7VHbjkI2DHEamStemzxTnXQ3LrdQmvupbkgtPhtC9
        mFJX7AbT+eEv+9tIFspp/Pk=
X-Google-Smtp-Source: ABdhPJzlrRhr7ACdG+c9jxRtkcQUbLNKf2lsxn4TbtBRXicfvFoHnNL3sZBqMIODYPkExq2VZXT9iw==
X-Received: by 2002:adf:94e1:: with SMTP id 88mr675152wrr.341.1610394987606;
        Mon, 11 Jan 2021 11:56:27 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id g14sm789584wrd.32.2021.01.11.11.56.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 11:56:27 -0800 (PST)
Date:   Mon, 11 Jan 2021 19:56:25 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: fix edge-trigger
 interrupts" failed to apply to 4.14-stable tree
Message-ID: <20210111195625.ckrqusk73lyhx54s@debian>
References: <160915397497172@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tp4vbc26foxvwp2z"
Content-Disposition: inline
In-Reply-To: <160915397497172@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tp4vbc26foxvwp2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:12:54PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the same backport as 4.19-stable. Missed mentioning in that mail
that it will also apply to 4.14-stable.

--
Regards
Sudip

--tp4vbc26foxvwp2z
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


--tp4vbc26foxvwp2z
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


--tp4vbc26foxvwp2z--
