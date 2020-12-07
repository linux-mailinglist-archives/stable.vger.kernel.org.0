Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9A2D1379
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 15:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgLGOXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 09:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgLGOXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 09:23:01 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D71C0613D0
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 06:22:14 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t4so12906874wrr.12
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 06:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K29KrSdVlWiVRuak/EwiQh7wE6ITtCuajbP+V3Nrkw4=;
        b=i0VL4oju35ESS+Na28krosdPY0v27TNmUA+lUNLUABDxIh7D8PYSZLzN/cNcFneVqw
         uFbvIph9oWWao4umO7t3vjxBa5QTrIUdVAN73qgoGZtmifie4Mz3MuYEsDmgy6yH6gSB
         fnPBPc5vjsYXdjevTn0iuYbtrMs7i3z5TyLQpxgZ9g6/5fhpcXrT4syQOOolZXRSyE+X
         GldVCD95a92v1evBB6mbfMlVNI1uVAaIksfngYWg6+A8d/yEMlAswivyYXSPM5BewHEU
         63FAE8xC4ShTrKab3ZXtOUYQl48wSHeDTR4W8Qg7GE35/R4Zz7irUQmKVykU7stEbb1i
         oDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K29KrSdVlWiVRuak/EwiQh7wE6ITtCuajbP+V3Nrkw4=;
        b=RsST5YBFMOd62MNTpGClfWOzVxQqyH8qGxOQMytLoi+5rpAYWp8y3qduvJkI1N2f24
         lM5gTrdeK9UPNbK0YsGMliipXFroo09uvcNrjxVuSrYR+K7a6Q1kBw93EdiNWYXU91BN
         fNTU6ElqfYY/ZX7PprDLRPnzYjqkupypQIhJ7a8urPJ0xg/SkN1hnEZ9t+jWs4DfStAj
         z3wnYbNvzBoxIac7Qj9iLQCzEbrx64Q99XmsA0KFReXOE9qbroNUTZv8YXGh2TuWOI4r
         ig06llO9HdNNM4GS2NvATBSJbwguOqz2l8gs/UlrJOmYdDoKL5dQj4kUPVTXotZDs3cM
         Fl1A==
X-Gm-Message-State: AOAM533Cy/TNsnJp+rX3zr4xEREvJsOTmGsk2O6Z1sFw4ijiJdiarpp5
        f3zDkD5+USJzOUYrWW0S1zA=
X-Google-Smtp-Source: ABdhPJy6gHFmTIQSVg1iI3SNNFg810cQy7BugOD70FCwtw7r1j2VGD44pLvKeXUKqf2/L681pJQvjg==
X-Received: by 2002:adf:ed51:: with SMTP id u17mr20156738wro.61.1607350933683;
        Mon, 07 Dec 2020 06:22:13 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id d8sm14030429wmb.11.2020.12.07.06.22.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Dec 2020 06:22:12 -0800 (PST)
Date:   Mon, 7 Dec 2020 14:22:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     hdegoede@redhat.com, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: baytrail: Fix pin being driven
 low for a while on" failed to apply to 4.9-stable tree
Message-ID: <20201207142211.anmpfxfx4lzc5b54@debian>
References: <159783767814665@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zcuu7acelgzrfusq"
Content-Disposition: inline
In-Reply-To: <159783767814665@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zcuu7acelgzrfusq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Aug 19, 2020 at 01:47:58PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport and also e2b74419e5cc ("pinctrl: baytrail: Replace
WARN with dev_info_once when setting direct-irq pin to output") which is
needed for the backport. This will apply from 4.9-stable to 5.4-stable.


--
Regards
Sudip

--zcuu7acelgzrfusq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-pinctrl-baytrail-Replace-WARN-with-dev_info_once-whe.patch"

From 490f45d984565c48246d1a4aa2d358ab6e2e16f7 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Wed, 1 Jan 2020 15:52:43 +0100
Subject: [PATCH 1/2] pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output

commit e2b74419e5cc7cfc58f3e785849f73f8fa0af5b3 upstream

Suspending Goodix touchscreens requires changing the interrupt pin to
output before sending them a power-down command. Followed by wiggling
the interrupt pin to wake the device up, after which it is put back
in input mode.

On Cherry Trail device the interrupt pin is listed as a GpioInt ACPI
resource so we can do this without problems as long as we release the
IRQ before changing the pin to output mode.

On Bay Trail devices with a Goodix touchscreen direct-irq mode is used
in combination with listing the pin as a normal GpioIo resource. This
works fine, but this triggers the WARN in byt_gpio_set_direction-s output
path because direct-irq support is enabled on the pin.

This commit replaces the WARN call with a dev_info_once call, fixing a
bunch of WARN splats in dmesg on each suspend/resume cycle.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index cae7caf5ab28..326e85f0f3ab 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -828,15 +828,15 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 	value &= ~BYT_DIR_MASK;
 	if (input)
 		value |= BYT_OUTPUT_EN;
-	else
+	else if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
 		/*
 		 * Before making any direction modifications, do a check if gpio
 		 * is set for direct IRQ.  On baytrail, setting GPIO to output
-		 * does not make sense, so let's at least warn the caller before
+		 * does not make sense, so let's at least inform the caller before
 		 * they shoot themselves in the foot.
 		 */
-		WARN(readl(conf_reg) & BYT_DIRECT_IRQ_EN,
-		     "Potential Error: Setting GPIO with direct_irq_en to output");
+		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+
 	writel(value, val_reg);
 
 	raw_spin_unlock_irqrestore(&byt_lock, flags);
-- 
2.11.0


--zcuu7acelgzrfusq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-pinctrl-baytrail-Fix-pin-being-driven-low-for-a-whil.patch"

From e6a9ea606b1d5b5e01c375cb0eaab1c9194d068f Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 6 Jun 2020 11:31:50 +0200
Subject: [PATCH 2/2] pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)

commit 156abe2961601d60a8c2a60c6dc8dd6ce7adcdaf upstream

The pins on the Bay Trail SoC have separate input-buffer and output-buffer
enable bits and a read of the level bit of the value register will always
return the value from the input-buffer.

The BIOS of a device may configure a pin in output-only mode, only enabling
the output buffer, and write 1 to the level bit to drive the pin high.
This 1 written to the level bit will be stored inside the data-latch of the
output buffer.

But a subsequent read of the value register will return 0 for the level bit
because the input-buffer is disabled. This causes a read-modify-write as
done by byt_gpio_set_direction() to write 0 to the level bit, driving the
pin low!

Before this commit byt_gpio_direction_output() relied on
pinctrl_gpio_direction_output() to set the direction, followed by a call
to byt_gpio_set() to apply the selected value. This causes the pin to
go low between the pinctrl_gpio_direction_output() and byt_gpio_set()
calls.

Change byt_gpio_direction_output() to directly make the register
modifications itself instead. Replacing the 2 subsequent writes to the
value register with a single write.

Note that the pinctrl code does not keep track internally of the direction,
so not going through pinctrl_gpio_direction_output() is not an issue.

This issue was noticed on a Trekstor SurfTab Twin 10.1. When the panel is
already on at boot (no external monitor connected), then the i915 driver
does a gpiod_get(..., GPIOD_OUT_HIGH) for the panel-enable GPIO. The
temporarily going low of that GPIO was causing the panel to reset itself
after which it would not show an image until it was turned off and back on
again (until a full modeset was done on it). This commit fixes this.

This commit also updates the byt_gpio_direction_input() to use direct
register accesses instead of going through pinctrl_gpio_direction_input(),
to keep it consistent with byt_gpio_direction_output().

Note for backporting, this commit depends on:
commit e2b74419e5cc ("pinctrl: baytrail: Replace WARN with dev_info_once
when setting direct-irq pin to output")

Cc: stable@vger.kernel.org
Fixes: 86e3ef812fe3 ("pinctrl: baytrail: Update gpio chip operations")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[sudip: use byt_gpio and vg->pdev->dev for dev_info()]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 67 +++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 326e85f0f3ab..5a1174a8e2ba 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -811,6 +811,21 @@ static void byt_gpio_disable_free(struct pinctrl_dev *pctl_dev,
 	pm_runtime_put(&vg->pdev->dev);
 }
 
+static void byt_gpio_direct_irq_check(struct byt_gpio *vg,
+				      unsigned int offset)
+{
+	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
+
+	/*
+	 * Before making any direction modifications, do a check if gpio is set
+	 * for direct IRQ. On Bay Trail, setting GPIO to output does not make
+	 * sense, so let's at least inform the caller before they shoot
+	 * themselves in the foot.
+	 */
+	if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
+		dev_info_once(&vg->pdev->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+}
+
 static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 				  struct pinctrl_gpio_range *range,
 				  unsigned int offset,
@@ -818,7 +833,6 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 {
 	struct byt_gpio *vg = pinctrl_dev_get_drvdata(pctl_dev);
 	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
-	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
 	unsigned long flags;
 	u32 value;
 
@@ -828,14 +842,8 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 	value &= ~BYT_DIR_MASK;
 	if (input)
 		value |= BYT_OUTPUT_EN;
-	else if (readl(conf_reg) & BYT_DIRECT_IRQ_EN)
-		/*
-		 * Before making any direction modifications, do a check if gpio
-		 * is set for direct IRQ.  On baytrail, setting GPIO to output
-		 * does not make sense, so let's at least inform the caller before
-		 * they shoot themselves in the foot.
-		 */
-		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+	else
+		byt_gpio_direct_irq_check(vg, offset);
 
 	writel(value, val_reg);
 
@@ -1176,19 +1184,50 @@ static int byt_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 
 static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
-	return pinctrl_gpio_direction_input(chip->base + offset);
+	struct byt_gpio *vg = gpiochip_get_data(chip);
+	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
+	unsigned long flags;
+	u32 reg;
+
+	raw_spin_lock_irqsave(&byt_lock, flags);
+
+	reg = readl(val_reg);
+	reg &= ~BYT_DIR_MASK;
+	reg |= BYT_OUTPUT_EN;
+	writel(reg, val_reg);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
+	return 0;
 }
 
+/*
+ * Note despite the temptation this MUST NOT be converted into a call to
+ * pinctrl_gpio_direction_output() + byt_gpio_set() that does not work this
+ * MUST be done as a single BYT_VAL_REG register write.
+ * See the commit message of the commit adding this comment for details.
+ */
 static int byt_gpio_direction_output(struct gpio_chip *chip,
 				     unsigned int offset, int value)
 {
-	int ret = pinctrl_gpio_direction_output(chip->base + offset);
+	struct byt_gpio *vg = gpiochip_get_data(chip);
+	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
+	unsigned long flags;
+	u32 reg;
 
-	if (ret)
-		return ret;
+	raw_spin_lock_irqsave(&byt_lock, flags);
 
-	byt_gpio_set(chip, offset, value);
+	byt_gpio_direct_irq_check(vg, offset);
 
+	reg = readl(val_reg);
+	reg &= ~BYT_DIR_MASK;
+	if (value)
+		reg |= BYT_LEVEL;
+	else
+		reg &= ~BYT_LEVEL;
+
+	writel(reg, val_reg);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
 
-- 
2.11.0


--zcuu7acelgzrfusq--
