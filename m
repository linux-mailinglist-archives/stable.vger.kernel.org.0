Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF28657C88
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbiL1Pdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiL1Pd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529971648C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEC4361553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC19CC433D2;
        Wed, 28 Dec 2022 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241605;
        bh=OXd+8esVDkGQ20tS8zPZVXp640EXSvrC5adQLCoQl9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeJbynGJiROi7m5Heiu/GyXDsuh0CRGh5Bjnah3Y/cQ+BhtCmSMd0aGS2Z18fFQ/3
         WT8wsUpQVtqMLDX7huf1hciCKgr12hsGDKQVM0x4pXSZuA9HKxE3aGyqLfKFFiHfDr
         1o59GHMAKCvsbZ8WOYlS9j7LZUGtfYsW6TE9D2oU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/731] iio: adis: stylistic changes
Date:   Wed, 28 Dec 2022 15:39:42 +0100
Message-Id: <20221228144310.318022751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit c39010ea6ba13bdf0003bd353e1d4c663aaac0a8 ]

Minor stylistic changes to address checkptach complains when called with
'--strict'.

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220122130905.99-3-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 99c05e4283a1 ("iio: adis: add '__adis_enable_irq()' implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis.c         | 47 +++++++++++++++++----------------
 drivers/iio/imu/adis_buffer.c  |  6 ++---
 drivers/iio/imu/adis_trigger.c |  3 +--
 include/linux/iio/imu/adis.h   | 48 ++++++++++++++++++----------------
 4 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/iio/imu/adis.c b/drivers/iio/imu/adis.c
index cb0d66bf6561..638957001653 100644
--- a/drivers/iio/imu/adis.c
+++ b/drivers/iio/imu/adis.c
@@ -30,8 +30,8 @@
  * @value: The value to write to device (up to 4 bytes)
  * @size: The size of the @value (in bytes)
  */
-int __adis_write_reg(struct adis *adis, unsigned int reg,
-	unsigned int value, unsigned int size)
+int __adis_write_reg(struct adis *adis, unsigned int reg, unsigned int value,
+		     unsigned int size)
 {
 	unsigned int page = reg / ADIS_PAGE_SIZE;
 	int ret, i;
@@ -114,7 +114,7 @@ int __adis_write_reg(struct adis *adis, unsigned int reg,
 	ret = spi_sync(adis->spi, &msg);
 	if (ret) {
 		dev_err(&adis->spi->dev, "Failed to write register 0x%02X: %d\n",
-				reg, ret);
+			reg, ret);
 	} else {
 		adis->current_page = page;
 	}
@@ -130,8 +130,8 @@ EXPORT_SYMBOL_GPL(__adis_write_reg);
  * @val: The value read back from the device
  * @size: The size of the @val buffer
  */
-int __adis_read_reg(struct adis *adis, unsigned int reg,
-	unsigned int *val, unsigned int size)
+int __adis_read_reg(struct adis *adis, unsigned int reg, unsigned int *val,
+		    unsigned int size)
 {
 	unsigned int page = reg / ADIS_PAGE_SIZE;
 	struct spi_message msg;
@@ -201,12 +201,12 @@ int __adis_read_reg(struct adis *adis, unsigned int reg,
 	ret = spi_sync(adis->spi, &msg);
 	if (ret) {
 		dev_err(&adis->spi->dev, "Failed to read register 0x%02X: %d\n",
-				reg, ret);
+			reg, ret);
 		return ret;
-	} else {
-		adis->current_page = page;
 	}
 
+	adis->current_page = page;
+
 	switch (size) {
 	case 4:
 		*val = get_unaligned_be32(adis->rx);
@@ -247,13 +247,13 @@ EXPORT_SYMBOL_GPL(__adis_update_bits_base);
 
 #ifdef CONFIG_DEBUG_FS
 
-int adis_debugfs_reg_access(struct iio_dev *indio_dev,
-	unsigned int reg, unsigned int writeval, unsigned int *readval)
+int adis_debugfs_reg_access(struct iio_dev *indio_dev, unsigned int reg,
+			    unsigned int writeval, unsigned int *readval)
 {
 	struct adis *adis = iio_device_get_drvdata(indio_dev);
 
 	if (readval) {
-		uint16_t val16;
+		u16 val16;
 		int ret;
 
 		ret = adis_read_reg_16(adis, reg, &val16);
@@ -261,9 +261,9 @@ int adis_debugfs_reg_access(struct iio_dev *indio_dev,
 			*readval = val16;
 
 		return ret;
-	} else {
-		return adis_write_reg_16(adis, reg, writeval);
 	}
+
+	return adis_write_reg_16(adis, reg, writeval);
 }
 EXPORT_SYMBOL(adis_debugfs_reg_access);
 
@@ -279,14 +279,16 @@ EXPORT_SYMBOL(adis_debugfs_reg_access);
 int adis_enable_irq(struct adis *adis, bool enable)
 {
 	int ret = 0;
-	uint16_t msc;
+	u16 msc;
 
 	mutex_lock(&adis->state_lock);
 
 	if (adis->data->enable_irq) {
 		ret = adis->data->enable_irq(adis, enable);
 		goto out_unlock;
-	} else if (adis->data->unmasked_drdy) {
+	}
+
+	if (adis->data->unmasked_drdy) {
 		if (enable)
 			enable_irq(adis->spi->irq);
 		else
@@ -322,7 +324,7 @@ EXPORT_SYMBOL(adis_enable_irq);
  */
 int __adis_check_status(struct adis *adis)
 {
-	uint16_t status;
+	u16 status;
 	int ret;
 	int i;
 
@@ -358,7 +360,7 @@ int __adis_reset(struct adis *adis)
 	const struct adis_timeout *timeouts = adis->data->timeouts;
 
 	ret = __adis_write_reg_8(adis, adis->data->glob_cmd_reg,
-			ADIS_GLOB_CMD_SW_RESET);
+				 ADIS_GLOB_CMD_SW_RESET);
 	if (ret) {
 		dev_err(&adis->spi->dev, "Failed to reset device: %d\n", ret);
 		return ret;
@@ -414,7 +416,7 @@ int __adis_initial_startup(struct adis *adis)
 {
 	const struct adis_timeout *timeouts = adis->data->timeouts;
 	struct gpio_desc *gpio;
-	uint16_t prod_id;
+	u16 prod_id;
 	int ret;
 
 	/* check if the device has rst pin low */
@@ -423,7 +425,7 @@ int __adis_initial_startup(struct adis *adis)
 		return PTR_ERR(gpio);
 
 	if (gpio) {
-		msleep(10);
+		usleep_range(10, 12);
 		/* bring device out of reset */
 		gpiod_set_value_cansleep(gpio, 0);
 		msleep(timeouts->reset_ms);
@@ -477,7 +479,8 @@ EXPORT_SYMBOL_GPL(__adis_initial_startup);
  * a error bit in the channels raw value set error_mask to 0.
  */
 int adis_single_conversion(struct iio_dev *indio_dev,
-	const struct iio_chan_spec *chan, unsigned int error_mask, int *val)
+			   const struct iio_chan_spec *chan,
+			   unsigned int error_mask, int *val)
 {
 	struct adis *adis = iio_device_get_drvdata(indio_dev);
 	unsigned int uval;
@@ -486,7 +489,7 @@ int adis_single_conversion(struct iio_dev *indio_dev,
 	mutex_lock(&adis->state_lock);
 
 	ret = __adis_read_reg(adis, chan->address, &uval,
-			chan->scan_type.storagebits / 8);
+			      chan->scan_type.storagebits / 8);
 	if (ret)
 		goto err_unlock;
 
@@ -521,7 +524,7 @@ EXPORT_SYMBOL_GPL(adis_single_conversion);
  * called.
  */
 int adis_init(struct adis *adis, struct iio_dev *indio_dev,
-	struct spi_device *spi, const struct adis_data *data)
+	      struct spi_device *spi, const struct adis_data *data)
 {
 	if (!data || !data->timeouts) {
 		dev_err(&spi->dev, "No config data or timeouts not defined!\n");
diff --git a/drivers/iio/imu/adis_buffer.c b/drivers/iio/imu/adis_buffer.c
index 351c303c8a8c..d3527cf5ed37 100644
--- a/drivers/iio/imu/adis_buffer.c
+++ b/drivers/iio/imu/adis_buffer.c
@@ -20,7 +20,7 @@
 #include <linux/iio/imu/adis.h>
 
 static int adis_update_scan_mode_burst(struct iio_dev *indio_dev,
-	const unsigned long *scan_mask)
+				       const unsigned long *scan_mask)
 {
 	struct adis *adis = iio_device_get_drvdata(indio_dev);
 	unsigned int burst_length, burst_max_length;
@@ -67,7 +67,7 @@ static int adis_update_scan_mode_burst(struct iio_dev *indio_dev,
 }
 
 int adis_update_scan_mode(struct iio_dev *indio_dev,
-	const unsigned long *scan_mask)
+			  const unsigned long *scan_mask)
 {
 	struct adis *adis = iio_device_get_drvdata(indio_dev);
 	const struct iio_chan_spec *chan;
@@ -158,7 +158,7 @@ static irqreturn_t adis_trigger_handler(int irq, void *p)
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev, adis->buffer,
-		pf->timestamp);
+					   pf->timestamp);
 
 irq_done:
 	iio_trigger_notify_done(indio_dev->trig);
diff --git a/drivers/iio/imu/adis_trigger.c b/drivers/iio/imu/adis_trigger.c
index c461bd1e8e69..0e7fb00ba241 100644
--- a/drivers/iio/imu/adis_trigger.c
+++ b/drivers/iio/imu/adis_trigger.c
@@ -15,8 +15,7 @@
 #include <linux/iio/trigger.h>
 #include <linux/iio/imu/adis.h>
 
-static int adis_data_rdy_trigger_set_state(struct iio_trigger *trig,
-						bool state)
+static int adis_data_rdy_trigger_set_state(struct iio_trigger *trig, bool state)
 {
 	struct adis *adis = iio_trigger_get_drvdata(trig);
 
diff --git a/include/linux/iio/imu/adis.h b/include/linux/iio/imu/adis.h
index 7c02f5292eea..6193f9a6fbc2 100644
--- a/include/linux/iio/imu/adis.h
+++ b/include/linux/iio/imu/adis.h
@@ -32,6 +32,7 @@ struct adis_timeout {
 	u16 sw_reset_ms;
 	u16 self_test_ms;
 };
+
 /**
  * struct adis_data - ADIS chip variant specific data
  * @read_delay: SPI delay for read operations in us
@@ -45,7 +46,7 @@ struct adis_timeout {
  * @self_test_mask: Bitmask of supported self-test operations
  * @self_test_reg: Register address to request self test command
  * @self_test_no_autoclear: True if device's self-test needs clear of ctrl reg
- * @status_error_msgs: Array of error messgaes
+ * @status_error_msgs: Array of error messages
  * @status_error_mask: Bitmask of errors supported by the device
  * @timeouts: Chip specific delays
  * @enable_irq: Hook for ADIS devices that have a special IRQ enable/disable
@@ -130,12 +131,12 @@ struct adis {
 	unsigned long		irq_flag;
 	void			*buffer;
 
-	uint8_t			tx[10] ____cacheline_aligned;
-	uint8_t			rx[4];
+	u8			tx[10] ____cacheline_aligned;
+	u8			rx[4];
 };
 
 int adis_init(struct adis *adis, struct iio_dev *indio_dev,
-	struct spi_device *spi, const struct adis_data *data);
+	      struct spi_device *spi, const struct adis_data *data);
 int __adis_reset(struct adis *adis);
 
 /**
@@ -156,9 +157,9 @@ static inline int adis_reset(struct adis *adis)
 }
 
 int __adis_write_reg(struct adis *adis, unsigned int reg,
-	unsigned int val, unsigned int size);
+		     unsigned int val, unsigned int size);
 int __adis_read_reg(struct adis *adis, unsigned int reg,
-	unsigned int *val, unsigned int size);
+		    unsigned int *val, unsigned int size);
 
 /**
  * __adis_write_reg_8() - Write single byte to a register (unlocked)
@@ -167,7 +168,7 @@ int __adis_read_reg(struct adis *adis, unsigned int reg,
  * @value: The value to write
  */
 static inline int __adis_write_reg_8(struct adis *adis, unsigned int reg,
-	uint8_t val)
+				     u8 val)
 {
 	return __adis_write_reg(adis, reg, val, 1);
 }
@@ -179,7 +180,7 @@ static inline int __adis_write_reg_8(struct adis *adis, unsigned int reg,
  * @value: Value to be written
  */
 static inline int __adis_write_reg_16(struct adis *adis, unsigned int reg,
-	uint16_t val)
+				      u16 val)
 {
 	return __adis_write_reg(adis, reg, val, 2);
 }
@@ -191,7 +192,7 @@ static inline int __adis_write_reg_16(struct adis *adis, unsigned int reg,
  * @value: Value to be written
  */
 static inline int __adis_write_reg_32(struct adis *adis, unsigned int reg,
-	uint32_t val)
+				      u32 val)
 {
 	return __adis_write_reg(adis, reg, val, 4);
 }
@@ -203,7 +204,7 @@ static inline int __adis_write_reg_32(struct adis *adis, unsigned int reg,
  * @val: The value read back from the device
  */
 static inline int __adis_read_reg_16(struct adis *adis, unsigned int reg,
-	uint16_t *val)
+				     u16 *val)
 {
 	unsigned int tmp;
 	int ret;
@@ -222,7 +223,7 @@ static inline int __adis_read_reg_16(struct adis *adis, unsigned int reg,
  * @val: The value read back from the device
  */
 static inline int __adis_read_reg_32(struct adis *adis, unsigned int reg,
-	uint32_t *val)
+				     u32 *val)
 {
 	unsigned int tmp;
 	int ret;
@@ -242,7 +243,7 @@ static inline int __adis_read_reg_32(struct adis *adis, unsigned int reg,
  * @size: The size of the @value (in bytes)
  */
 static inline int adis_write_reg(struct adis *adis, unsigned int reg,
-	unsigned int val, unsigned int size)
+				 unsigned int val, unsigned int size)
 {
 	int ret;
 
@@ -261,7 +262,7 @@ static inline int adis_write_reg(struct adis *adis, unsigned int reg,
  * @size: The size of the @val buffer
  */
 static int adis_read_reg(struct adis *adis, unsigned int reg,
-	unsigned int *val, unsigned int size)
+			 unsigned int *val, unsigned int size)
 {
 	int ret;
 
@@ -279,7 +280,7 @@ static int adis_read_reg(struct adis *adis, unsigned int reg,
  * @value: The value to write
  */
 static inline int adis_write_reg_8(struct adis *adis, unsigned int reg,
-	uint8_t val)
+				   u8 val)
 {
 	return adis_write_reg(adis, reg, val, 1);
 }
@@ -291,7 +292,7 @@ static inline int adis_write_reg_8(struct adis *adis, unsigned int reg,
  * @value: Value to be written
  */
 static inline int adis_write_reg_16(struct adis *adis, unsigned int reg,
-	uint16_t val)
+				    u16 val)
 {
 	return adis_write_reg(adis, reg, val, 2);
 }
@@ -303,7 +304,7 @@ static inline int adis_write_reg_16(struct adis *adis, unsigned int reg,
  * @value: Value to be written
  */
 static inline int adis_write_reg_32(struct adis *adis, unsigned int reg,
-	uint32_t val)
+				    u32 val)
 {
 	return adis_write_reg(adis, reg, val, 4);
 }
@@ -315,7 +316,7 @@ static inline int adis_write_reg_32(struct adis *adis, unsigned int reg,
  * @val: The value read back from the device
  */
 static inline int adis_read_reg_16(struct adis *adis, unsigned int reg,
-	uint16_t *val)
+				   u16 *val)
 {
 	unsigned int tmp;
 	int ret;
@@ -334,7 +335,7 @@ static inline int adis_read_reg_16(struct adis *adis, unsigned int reg,
  * @val: The value read back from the device
  */
 static inline int adis_read_reg_32(struct adis *adis, unsigned int reg,
-	uint32_t *val)
+				   u32 *val)
 {
 	unsigned int tmp;
 	int ret;
@@ -443,8 +444,8 @@ static inline void adis_dev_unlock(struct adis *adis)
 }
 
 int adis_single_conversion(struct iio_dev *indio_dev,
-	const struct iio_chan_spec *chan, unsigned int error_mask,
-	int *val);
+			   const struct iio_chan_spec *chan,
+			   unsigned int error_mask, int *val);
 
 #define ADIS_VOLTAGE_CHAN(addr, si, chan, name, info_all, bits) { \
 	.type = IIO_VOLTAGE, \
@@ -493,7 +494,7 @@ int adis_single_conversion(struct iio_dev *indio_dev,
 	.modified = 1, \
 	.channel2 = IIO_MOD_ ## mod, \
 	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) | \
-		 info_sep, \
+		 (info_sep), \
 	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE), \
 	.info_mask_shared_by_all = info_all, \
 	.address = (addr), \
@@ -527,7 +528,7 @@ devm_adis_setup_buffer_and_trigger(struct adis *adis, struct iio_dev *indio_dev,
 int devm_adis_probe_trigger(struct adis *adis, struct iio_dev *indio_dev);
 
 int adis_update_scan_mode(struct iio_dev *indio_dev,
-	const unsigned long *scan_mask);
+			  const unsigned long *scan_mask);
 
 #else /* CONFIG_IIO_BUFFER */
 
@@ -551,7 +552,8 @@ static inline int devm_adis_probe_trigger(struct adis *adis,
 #ifdef CONFIG_DEBUG_FS
 
 int adis_debugfs_reg_access(struct iio_dev *indio_dev,
-	unsigned int reg, unsigned int writeval, unsigned int *readval);
+			    unsigned int reg, unsigned int writeval,
+			    unsigned int *readval);
 
 #else
 
-- 
2.35.1



