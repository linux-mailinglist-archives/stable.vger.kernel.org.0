Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA32F1FDD
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391029AbhAKTwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390955AbhAKTwA (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 11 Jan 2021 14:52:00 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EA7C061795
        for <Stable@vger.kernel.org>; Mon, 11 Jan 2021 11:51:20 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id k10so307073wmi.3
        for <Stable@vger.kernel.org>; Mon, 11 Jan 2021 11:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MMmpt7PZmxXLNdxlS5MO/gZr/sGvWAZvLTTxoKgKALg=;
        b=vI6rRSnSzcDhH7q2ifzyDVGnvemBoe93YbpJszjB6FPuPkNvfXywATy4UHTO5gN8oO
         nDQbnO4AKichnNujdPj3QeJug5o4c0NDowmanTO0GpWeWU/HlvljdxKbQtYOmBaYQacI
         cogLc+/OPK94N06x+bN+vcR5ZukE8JKO0IGHvv97u+ru5X8WMMjShFiiChRzhODC1nTe
         lp9stj7lMdeUsM5dElNWL6C/6IqMkRY0DWrZUBzAf4MNORXjdk389HWfn5Q7RoNU07Km
         JO56CKmynm3SuXjRyqyfUBOzhFd5Yeg6enT6V5tmZNBEd/U8RelWiMqlXNQuUFVEQZVS
         DX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MMmpt7PZmxXLNdxlS5MO/gZr/sGvWAZvLTTxoKgKALg=;
        b=MyxYqjPpDGTHIorZlObK1v3iNsu62iE7pRDaEDMvOQa5u4Xw3LaUN1KW+5PH9U5Fzx
         5IzmfsI6mtVcxSkbLc3n5dcc8Ea1ogovZd05GYYIbtyefR5CuWAVS/7aiaEH5cO7tzWq
         4AIAN68aPChokNiiBXK+aKI3O1A/zUcK4AlRtkI7v9kM77W8RcZiVDj18ZeneoQyVIjp
         vj/COI0NrUEvu5LzHpmYJaPGEn8bGG7T6QAoYNgUD0g9v3ixSashd8HAhbbSMKbYQZ7T
         LLZFP6DU9GRgGrdh4I37ILvqE8mEU2a2If8202OhPgqmlIfhRy6lkIk2ghyJhsvniOLT
         3rsA==
X-Gm-Message-State: AOAM532FZXt3895bgWkaucbrsN2cb16TN1uqF9wZsK+9vHAaHs+WbXCu
        cJ4vbG0aW8uQzoMAePQ5qA8=
X-Google-Smtp-Source: ABdhPJwD57jDykhAqTD7eoC7WPZbQbBmzjRNUgbk5AfUXeDYWR0aa7tS7Ni9gWG4SnEAU7n900MRTw==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr393867wmi.36.1610394678752;
        Mon, 11 Jan 2021 11:51:18 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id l8sm452721wmf.35.2021.01.11.11.51.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 11:51:17 -0800 (PST)
Date:   Mon, 11 Jan 2021 19:51:16 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: fix edge-trigger
 interrupts" failed to apply to 5.4-stable tree
Message-ID: <20210111195116.pj4vk5ebmpqa27vw@debian>
References: <1609153975178175@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hujscgmhnqq4jv4m"
Content-Disposition: inline
In-Reply-To: <1609153975178175@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hujscgmhnqq4jv4m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--hujscgmhnqq4jv4m
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iio-imu-st_lsm6dsx-fix-edge-trigger-interrupts.patch"

From 1a0094adf70fca60dcff572853697dd5bce9a6eb Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 14 Nov 2020 19:39:05 +0100
Subject: [PATCH] iio: imu: st_lsm6dsx: fix edge-trigger interrupts

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
index b0f3da1976e4..d1f2109012ed 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -664,13 +664,29 @@ static irqreturn_t st_lsm6dsx_handler_irq(int irq, void *private)
 static irqreturn_t st_lsm6dsx_handler_thread(int irq, void *private)
 {
 	struct st_lsm6dsx_hw *hw = private;
-	int count;
+	int fifo_len = 0, len;
 
-	mutex_lock(&hw->fifo_lock);
-	count = hw->settings->fifo_ops.read_fifo(hw);
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
+		len = hw->settings->fifo_ops.read_fifo(hw);
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


--hujscgmhnqq4jv4m--
