Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46433249D51
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgHSMEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:04:25 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:56621 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728238AbgHSLru (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:47:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B8817194223C;
        Wed, 19 Aug 2020 07:47:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/d1qOt
        BtMKExr+LEYHNYzDdEo2JD+6JEppy+DOA7zT0=; b=fvKK8Tm8w/V+T6HeBAlB8A
        TEmmjKkzGopqwYTRfdBxw+jLcyK0IZFAs+GuWCb0L546Xw9+e57KCigNkj3HbhOF
        mRSxqFpvrF+7TaxTkIPoy+5DH7zdtqpfoTaJ4I8OT91Fyg2SQyWVbCPPZdMY2Qa0
        qjO/5N/1hxFHYPa7D5Li5k/CTqHUYGTlgcYT65FrGzYTE0h9B3Npk2DL/c1ZRXk3
        Ju/M7fk0vi1p7b9xuTLzbFbLenRd9M9kF71vRYnPQIeuymwCsAevXED7hzwIitke
        KUD1P5u3mosQqHHev2OhSlDkELz6GeDUOKZToHvlAnLvYJJbiUPqEZYLSywg3sCg
        ==
X-ME-Sender: <xms:VRE9X4ZLMXwCX86mkL1B3OT6Apnn9L2QX6muMaXjRLtfBN4lUb_0OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:VRE9XzaoVUZnRiT2thwZ-PZGJ5OzGwGMtRxIrcDomyk0oed5cyX98g>
    <xmx:VRE9Xy97wcTE25ACVdv2mM5ojjY6yxl_TMBGuFvGL_51gRj3j0n91Q>
    <xmx:VRE9XyoZRTFeykgZGLMJUAuMZbeMJW9JZ5ERg4Xwx4q9ptYDx3ZlAQ>
    <xmx:VRE9XyQvi6_g_iBR3qhyqnaMppcl0D6QZPspcggO43pM8Fd4QSOUHA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5253D30600B4;
        Wed, 19 Aug 2020 07:47:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] pinctrl: baytrail: Fix pin being driven low for a while on" failed to apply to 4.14-stable tree
To:     hdegoede@redhat.com, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:47:56 +0200
Message-ID: <159783767691135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 156abe2961601d60a8c2a60c6dc8dd6ce7adcdaf Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 6 Jun 2020 11:31:50 +0200
Subject: [PATCH] pinctrl: baytrail: Fix pin being driven low for a while on
 gpiod_get(..., GPIOD_OUT_HIGH)

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

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index e3ceb3dfeabe..a917a2df520e 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -800,6 +800,21 @@ static void byt_gpio_disable_free(struct pinctrl_dev *pctl_dev,
 	pm_runtime_put(vg->dev);
 }
 
+static void byt_gpio_direct_irq_check(struct intel_pinctrl *vg,
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
+		dev_info_once(vg->dev, "Potential Error: Setting GPIO with direct_irq_en to output");
+}
+
 static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 				  struct pinctrl_gpio_range *range,
 				  unsigned int offset,
@@ -807,7 +822,6 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
 {
 	struct intel_pinctrl *vg = pinctrl_dev_get_drvdata(pctl_dev);
 	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
-	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
 	unsigned long flags;
 	u32 value;
 
@@ -817,14 +831,8 @@ static int byt_gpio_set_direction(struct pinctrl_dev *pctl_dev,
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
 
@@ -1165,19 +1173,50 @@ static int byt_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 
 static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned int offset)
 {
-	return pinctrl_gpio_direction_input(chip->base + offset);
+	struct intel_pinctrl *vg = gpiochip_get_data(chip);
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
+	struct intel_pinctrl *vg = gpiochip_get_data(chip);
+	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
+	unsigned long flags;
+	u32 reg;
 
-	if (ret)
-		return ret;
+	raw_spin_lock_irqsave(&byt_lock, flags);
+
+	byt_gpio_direct_irq_check(vg, offset);
 
-	byt_gpio_set(chip, offset, value);
+	reg = readl(val_reg);
+	reg &= ~BYT_DIR_MASK;
+	if (value)
+		reg |= BYT_LEVEL;
+	else
+		reg &= ~BYT_LEVEL;
 
+	writel(reg, val_reg);
+
+	raw_spin_unlock_irqrestore(&byt_lock, flags);
 	return 0;
 }
 

