Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084772C6E80
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 03:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgK1CbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 21:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730967AbgK0T51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 14:57:27 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DBDC0617A7
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 11:29:18 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id a3so7423371wmb.5
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 11:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=kHjfialPq/YZie9YRJKVup94ecHvvpJaA2PlYKkcsh0=;
        b=Keb5AL8S745AjC902lhzbojkX512vHkAlS36KklFe7YsANwp1xfIFPGK+XtlwJ0jTL
         sbj6mq0XdHNLLxUFas3q34CZ7BXmj3najhu4hk4IGzgq5qEwvi9u+HB106z7oKfa9giD
         FQFGuhsGkGvHw9r+3gHooqUF3ko1FmWfYFKCbCU8Zp7VvTRU8P5it/Z0dKb6v7MnIaDY
         oNOFUvJRhc8RTUTGINWXw6ARH3IQyN6rM9nLLpBdijqFq3/dSlL6JNmiSWFTAMCbGWR8
         /w907cpUWtUjFxnkJwBF91O8rvz6K/2EgUq/7JZJ2XSUsFRlkGRpqtk1JoXeLhRJYt8A
         ZYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=kHjfialPq/YZie9YRJKVup94ecHvvpJaA2PlYKkcsh0=;
        b=RnM8qPy/qO5/fMPHKqzpBIS29fUdR+uCssAx1UbUjnrLBeGs7taS52LXTFPcm3Zh3i
         me0jfxSezyw5r2qMcqItLg6AP+JKGW+IrzVBolFLxgBk1rbCI/5ANuCjGo2urvB0/lH6
         /kaE7iPKMKGLkJhC3HCKQUbj/OyqjlrxocEpfDhU9m8B99GFlSOyT9+FpYjBAXP5ngOz
         TLfvwVzhFIW+DX728XSp/6SuIqhvPaI4v5WZUjppqh298GZBdFdlxND5hLSs013jy+wp
         6JKHiiL18UiSKTU9OPHArf9WLMnuWkjIGQXwfIrmH8/UlxPOlnH7Al07xNZmwoX3oUaM
         yTlA==
X-Gm-Message-State: AOAM531Il2d6sx5vcomE6AOr7572oSf6N2cWaw6lv6wmhzsq1/CWq0Pa
        ++6t5ZIs5gcV+jfwTwtiQpct3rEUYCGagQ==
X-Google-Smtp-Source: ABdhPJxGqu4ZhIh+6tz59CqoKbSvwruieS4Ny9tWHueI2+v7qiGzppE8j3jQaaE0NiA77NTT9ej73g==
X-Received: by 2002:a7b:cbcc:: with SMTP id n12mr11070956wmi.115.1606505356959;
        Fri, 27 Nov 2020 11:29:16 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id w10sm16140133wra.34.2020.11.27.11.29.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Nov 2020 11:29:16 -0800 (PST)
Date:   Fri, 27 Nov 2020 19:29:14 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ceggers@arri.de, u.kleine-koenig@pengutronix.de, wsa@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] i2c: imx: Fix reset of I2SR_IAL flag"
 failed to apply to 4.4-stable tree
Message-ID: <20201127192914.hjmj7tattqx2s72e@debian>
References: <160240561415148@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xrztlobkux2f3sie"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160240561415148@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xrztlobkux2f3sie
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Oct 11, 2020 at 10:40:14AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport for 4.4-stable.

--
Regards
Sudip

--xrztlobkux2f3sie
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-i2c-imx-Fix-reset-of-I2SR_IAL-flag.patch"
Content-Transfer-Encoding: 8bit

From 6f15f009d202a8a1f327557947595d73a91c7e98 Mon Sep 17 00:00:00 2001
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
index 37303a7a2e73..23b390f90d86 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -420,6 +420,19 @@ static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
 /** Functions for IMX I2C adapter driver ***************************************
 *******************************************************************************/
 
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
@@ -432,8 +445,7 @@ static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy)
 
 		/* check for arbitration lost */
 		if (temp & I2SR_IAL) {
-			temp &= ~I2SR_IAL;
-			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
+			i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
 			return -EAGAIN;
 		}
 
@@ -595,9 +607,7 @@ static irqreturn_t i2c_imx_isr(int irq, void *dev_id)
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


--xrztlobkux2f3sie--
