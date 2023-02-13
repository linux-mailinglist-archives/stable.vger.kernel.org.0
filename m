Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5676949F5
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjBMPDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjBMPDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4DA1E1EA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CA761122
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4B7C433D2;
        Mon, 13 Feb 2023 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300583;
        bh=mKMtYGUi6EE7cBFlIcoLmALfj0P1c3k95YLF5gyXM3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQevi0wQ8dp7AtsD6lyOXhS7WYEje7Ohe5hd7Y+c/iRZRktw+dLobfR/xiE/HIdut
         OU930kMKMXpqvc1PoFNMpRE+RVpZA98Ezb8qQE4sc0kg+j1I2Hevoo520dHDKxpEdz
         Sl5IttN30LjD7D3C0xSJcXeMGTlVFLxNsmR584/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/139] i2c: rk3x: fix a bunch of kernel-doc warnings
Date:   Mon, 13 Feb 2023 15:49:47 +0100
Message-Id: <20230213144747.888274169@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0582d984793d30442da88fe458674502bad1ad29 ]

Fix multiple W=1 kernel-doc warnings in i2c-rk3x.c:

drivers/i2c/busses/i2c-rk3x.c:83: warning: missing initial short description on line:
 * struct i2c_spec_values:
drivers/i2c/busses/i2c-rk3x.c:139: warning: missing initial short description on line:
 * struct rk3x_i2c_calced_timings:
drivers/i2c/busses/i2c-rk3x.c:162: warning: missing initial short description on line:
 * struct rk3x_i2c_soc_data:
drivers/i2c/busses/i2c-rk3x.c:242: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Generate a START condition, which triggers a REG_INT_START interrupt.
drivers/i2c/busses/i2c-rk3x.c:261: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Generate a STOP condition, which triggers a REG_INT_STOP interrupt.
drivers/i2c/busses/i2c-rk3x.c:304: warning: expecting prototype for Setup a read according to i2c(). Prototype was for rk3x_i2c_prepare_read() instead
drivers/i2c/busses/i2c-rk3x.c:335: warning: expecting prototype for Fill the transmit buffer with data from i2c(). Prototype was for rk3x_i2c_fill_transmit_buf() instead
drivers/i2c/busses/i2c-rk3x.c:535: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Get timing values of I2C specification
drivers/i2c/busses/i2c-rk3x.c:552: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Calculate divider values for desired SCL frequency
drivers/i2c/busses/i2c-rk3x.c:713: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Calculate timing values for desired SCL frequency
drivers/i2c/busses/i2c-rk3x.c:963: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Setup I2C registers for an I2C operation specified by msgs, num.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rk3x.c | 44 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 02ddb237f69a..13c14eb175e9 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -80,7 +80,7 @@ enum {
 #define DEFAULT_SCL_RATE  (100 * 1000) /* Hz */
 
 /**
- * struct i2c_spec_values:
+ * struct i2c_spec_values - I2C specification values for various modes
  * @min_hold_start_ns: min hold time (repeated) START condition
  * @min_low_ns: min LOW period of the SCL clock
  * @min_high_ns: min HIGH period of the SCL cloc
@@ -136,7 +136,7 @@ static const struct i2c_spec_values fast_mode_plus_spec = {
 };
 
 /**
- * struct rk3x_i2c_calced_timings:
+ * struct rk3x_i2c_calced_timings - calculated V1 timings
  * @div_low: Divider output for low
  * @div_high: Divider output for high
  * @tuning: Used to adjust setup/hold data time,
@@ -159,7 +159,7 @@ enum rk3x_i2c_state {
 };
 
 /**
- * struct rk3x_i2c_soc_data:
+ * struct rk3x_i2c_soc_data - SOC-specific data
  * @grf_offset: offset inside the grf regmap for setting the i2c type
  * @calc_timings: Callback function for i2c timing information calculated
  */
@@ -239,7 +239,8 @@ static inline void rk3x_i2c_clean_ipd(struct rk3x_i2c *i2c)
 }
 
 /**
- * Generate a START condition, which triggers a REG_INT_START interrupt.
+ * rk3x_i2c_start - Generate a START condition, which triggers a REG_INT_START interrupt.
+ * @i2c: target controller data
  */
 static void rk3x_i2c_start(struct rk3x_i2c *i2c)
 {
@@ -258,8 +259,8 @@ static void rk3x_i2c_start(struct rk3x_i2c *i2c)
 }
 
 /**
- * Generate a STOP condition, which triggers a REG_INT_STOP interrupt.
- *
+ * rk3x_i2c_stop - Generate a STOP condition, which triggers a REG_INT_STOP interrupt.
+ * @i2c: target controller data
  * @error: Error code to return in rk3x_i2c_xfer
  */
 static void rk3x_i2c_stop(struct rk3x_i2c *i2c, int error)
@@ -298,7 +299,8 @@ static void rk3x_i2c_stop(struct rk3x_i2c *i2c, int error)
 }
 
 /**
- * Setup a read according to i2c->msg
+ * rk3x_i2c_prepare_read - Setup a read according to i2c->msg
+ * @i2c: target controller data
  */
 static void rk3x_i2c_prepare_read(struct rk3x_i2c *i2c)
 {
@@ -329,7 +331,8 @@ static void rk3x_i2c_prepare_read(struct rk3x_i2c *i2c)
 }
 
 /**
- * Fill the transmit buffer with data from i2c->msg
+ * rk3x_i2c_fill_transmit_buf - Fill the transmit buffer with data from i2c->msg
+ * @i2c: target controller data
  */
 static void rk3x_i2c_fill_transmit_buf(struct rk3x_i2c *i2c)
 {
@@ -532,11 +535,10 @@ static irqreturn_t rk3x_i2c_irq(int irqno, void *dev_id)
 }
 
 /**
- * Get timing values of I2C specification
- *
+ * rk3x_i2c_get_spec - Get timing values of I2C specification
  * @speed: Desired SCL frequency
  *
- * Returns: Matched i2c spec values.
+ * Return: Matched i2c_spec_values.
  */
 static const struct i2c_spec_values *rk3x_i2c_get_spec(unsigned int speed)
 {
@@ -549,13 +551,12 @@ static const struct i2c_spec_values *rk3x_i2c_get_spec(unsigned int speed)
 }
 
 /**
- * Calculate divider values for desired SCL frequency
- *
+ * rk3x_i2c_v0_calc_timings - Calculate divider values for desired SCL frequency
  * @clk_rate: I2C input clock rate
  * @t: Known I2C timing information
  * @t_calc: Caculated rk3x private timings that would be written into regs
  *
- * Returns: 0 on success, -EINVAL if the goal SCL rate is too slow. In that case
+ * Return: %0 on success, -%EINVAL if the goal SCL rate is too slow. In that case
  * a best-effort divider value is returned in divs. If the target rate is
  * too high, we silently use the highest possible rate.
  */
@@ -710,13 +711,12 @@ static int rk3x_i2c_v0_calc_timings(unsigned long clk_rate,
 }
 
 /**
- * Calculate timing values for desired SCL frequency
- *
+ * rk3x_i2c_v1_calc_timings - Calculate timing values for desired SCL frequency
  * @clk_rate: I2C input clock rate
  * @t: Known I2C timing information
  * @t_calc: Caculated rk3x private timings that would be written into regs
  *
- * Returns: 0 on success, -EINVAL if the goal SCL rate is too slow. In that case
+ * Return: %0 on success, -%EINVAL if the goal SCL rate is too slow. In that case
  * a best-effort divider value is returned in divs. If the target rate is
  * too high, we silently use the highest possible rate.
  * The following formulas are v1's method to calculate timings.
@@ -960,14 +960,14 @@ static int rk3x_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
 }
 
 /**
- * Setup I2C registers for an I2C operation specified by msgs, num.
- *
- * Must be called with i2c->lock held.
- *
+ * rk3x_i2c_setup - Setup I2C registers for an I2C operation specified by msgs, num.
+ * @i2c: target controller data
  * @msgs: I2C msgs to process
  * @num: Number of msgs
  *
- * returns: Number of I2C msgs processed or negative in case of error
+ * Must be called with i2c->lock held.
+ *
+ * Return: Number of I2C msgs processed or negative in case of error
  */
 static int rk3x_i2c_setup(struct rk3x_i2c *i2c, struct i2c_msg *msgs, int num)
 {
-- 
2.39.0



