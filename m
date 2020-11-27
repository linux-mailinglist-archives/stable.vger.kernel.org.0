Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162D82C6E74
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 03:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbgK0T6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 14:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730990AbgK0T51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 14:57:27 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFDDC061A04
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 11:27:47 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id f190so4427282wme.1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 11:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=AP21F+TnvcNMAcaaWG1jprdCjS1gAu0i3yFku4fv+y0=;
        b=fut8IMGo1JTtvXOmXW2DuGHIR7YYSZUNuvVpwJyl5ke05whdgAZm3fRwAy8/rwmeBf
         QCwW9er2i+0EyWfXOKjpzVKfQluJteYjQyd9uZIqGEAZzvvirwYiOCnRe6dm2MyswLyh
         gS845C7tHY+cqcjt+le8EXO8U3qrPsemKrRzXwOYeg97k91pmWlvTFLnK+ijV86jAu41
         bbQZZAKZzjaipnql30lDlFFoExXZoinfPwzo88X6loUjnBd2yvTb4Uc+PzN1J7iW4Ljw
         nDvFFaDx6/UVMG8+jgIoJThkU7Irs1ci81DMYLgcO6X9g0fpfqP0lPYCJZnZMxDqSw6r
         WWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=AP21F+TnvcNMAcaaWG1jprdCjS1gAu0i3yFku4fv+y0=;
        b=FUbi0iRHk2/6sujKKSLZe0NgmAICNF0Q5OgT3AnfYy9b9YLsVFk+rpEF1E5n6xBvs/
         oHama+cUemCeQK0CdCP2RGLX3UiMedvbNFtqGQVp4EWe/tR+KMm9GSEIsxR5jsu2+gqX
         0pU6kewCpFCjYFRAm1gYRAzpT9mtBZHjOjbx0Qvh97h9f6mAZf0QmzUDh1+UQnwhMKI1
         I/sJd+hiWeEdwvFNWxWp11uQbQOZfY/XQaS7wvQ+Z5bTnYcyEhxXbtyYbHwqQRy5wEGu
         Ul+onUeYz0pkOvPCtOChhouazWaTWHVUSTl0D8CzLqUDp5TqJWlYg3HSNIY+sLv6KeL5
         Y/ZA==
X-Gm-Message-State: AOAM531J01NV21PjXSS4r/VgH8ceLeaBgK6hdrbZ/p1FEciqvnHPtitE
        KJL5EZzc2KhIYMnTJXq1dpM=
X-Google-Smtp-Source: ABdhPJzz1qc38PgFYLWnO+EDQFyALx+XbGxq8HxADHCpvkWLcadzyGv/1JkpterF3R5UIBg4INRSKA==
X-Received: by 2002:a1c:32c6:: with SMTP id y189mr11119362wmy.133.1606505265960;
        Fri, 27 Nov 2020 11:27:45 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id v4sm17158380wru.12.2020.11.27.11.27.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Nov 2020 11:27:45 -0800 (PST)
Date:   Fri, 27 Nov 2020 19:27:42 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ceggers@arri.de, u.kleine-koenig@pengutronix.de, wsa@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] i2c: imx: Fix reset of I2SR_IAL flag"
 failed to apply to 5.4-stable tree
Message-ID: <20201127192742.mwxcjkmmzj72v7zz@debian>
References: <1602405612123102@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dldtnn27i4jwtui4"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1602405612123102@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dldtnn27i4jwtui4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Oct 11, 2020 at 10:40:12AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. It will apply till 4.9-stable.


--
Regards
Sudip

--dldtnn27i4jwtui4
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-i2c-imx-Fix-reset-of-I2SR_IAL-flag.patch"
Content-Transfer-Encoding: 8bit

From a031ac83a3ef681040a44b1090c0cbf9a3d8b328 Mon Sep 17 00:00:00 2001
From: Christian Eggers <ceggers@arri.de>
Date: Wed, 7 Oct 2020 10:45:22 +0200
Subject: [PATCH] i2c: imx: Fix reset of I2SR_IAL flag
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit fa4d30556883f2eaab425b88ba9904865a4d00f3 upstream

According to the "VFxxx Controller Reference Manual" (and the comment
block starting at line 97), Vybrid requires writing a one for clearing
an interrupt flag. Syncing the method for clearing I2SR_IIF in
i2c_imx_isr().

Signed-off-by: Christian Eggers <ceggers@arri.de>
Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks")
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Wolfram Sang <wsa@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/i2c/busses/i2c-imx.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 9543c9816eed..ddaea7c6d30e 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -414,6 +414,19 @@ static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
 	dma->chan_using = NULL;
 }
 
+static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned int bits)
+{
+	unsigned int temp;
+
+	/*
+	 * i2sr_clr_opcode is the value to clear all interrupts. Here we want to
+	 * clear only <bits>, so we write ~i2sr_clr_opcode with just <bits>
+	 * toggled. This is required because i.MX needs W1C and Vybrid uses W0C.
+	 */
+	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+}
+
 static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy)
 {
 	unsigned long orig_jiffies = jiffies;
@@ -426,8 +439,7 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy)
 
 		/* check for arbitration lost */
 		if (temp & I2SR_IAL) {
-			temp &= ~I2SR_IAL;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+			i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
 			return -EAGAIN;
 		}
 
@@ -597,9 +609,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
 	if (temp & I2SR_IIF) {
 		/* save status register */
 		i2c_imx->i2csr = temp;
-		temp &= ~I2SR_IIF;
-		temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IIF);
-		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IIF);
 		wake_up(&i2c_imx->queue);
 		return IRQ_HANDLED;
 	}
-- 
2.11.0


--dldtnn27i4jwtui4--
