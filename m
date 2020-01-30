Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C3714D89B
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 11:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgA3KGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 05:06:06 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39699 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbgA3KGG (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 30 Jan 2020 05:06:06 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 8401921CFD;
        Thu, 30 Jan 2020 05:06:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 05:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B8wESH
        j3cPZ+yayVdzLTMzHCf4oOoPIv0yccDHPuWlQ=; b=swTYYDJdXSphYBVgg/OKVN
        q5FDDZqftsCRZG4jBfv7x4FFW1URNB0mZfzqVHprkZNqUfJj8ZJNCBXp0ldl30v/
        ZyGQ1IiPvibSmJ7BYD7vBKTILeoNFRmIfXsEBF5byV4/loF3QIv2ma6mpUR/FjLT
        vvN09W/reVs+U2SUVt6VZ5cMiBL3bagv1NSaNi0bqPtEBtRxGcPIawnwvpQLICmY
        1M0MiIoGfrbiWcAz9pRtftTqw+8v+DH9afIHtoBDE+maKe21Aw6X9kyP6drVDfW3
        1ZQmueAErra9Ut5U4rAi1VBf25nk5yLLQoBNjAiwxaSrqkw3rVE8gD60WAjB1gEg
        ==
X-ME-Sender: <xms:jaoyXkHazJ1nZ8c9_Jm5UkSjqVAAgCvpH5HGJphQfhwy8dsgNZuIiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jaoyXoiROp52Q2Y_19Hpw2r2dUjvrRFP8PQxa5pSlSKA2n1cgx-0GA>
    <xmx:jaoyXh-lSFPMZEsydPF_4YnYdfvieReRIxKGSaPTqLcRw3qHPsq7eg>
    <xmx:jaoyXgYuibOrmkU-iaCiIgQ73PORuTPqeo-v3KehWyPoksSgdl2fhA>
    <xmx:jaoyXst_Rx-zuRv-1xhLiM6Lu_LPmUe-Somq7TO0Q_zKvDUyA8G2jg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E03933280063;
        Thu, 30 Jan 2020 05:06:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: st_gyro: Correct data for LSM9DS0 gyro" failed to apply to 4.9-stable tree
To:     andriy.shevchenko@linux.intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, leonard.crestez@nxp.com,
        lorenzo.bianconi83@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 11:06:03 +0100
Message-ID: <158037876398197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e825070f697abddf3b9b0a675ed0ff1884114818 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 17 Dec 2019 19:10:38 +0200
Subject: [PATCH] iio: st_gyro: Correct data for LSM9DS0 gyro

The commit 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
assumes that gyro in LSM9DS0 is the same as others with 0xd4 WAI ID,
but datasheet tells slight different story, i.e. the first scale factor
for the chip is 245 dps, and not 250 dps.

Correct this by introducing a separate settings for LSM9DS0.

Fixes: 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
Depends-on: 45a4e4220bf4 ("iio: gyro: st_gyro: fix L3GD20H support")
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index 57be68b291fa..26c50b24bc08 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -138,7 +138,6 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			[2] = LSM330DLC_GYRO_DEV_NAME,
 			[3] = L3G4IS_GYRO_DEV_NAME,
 			[4] = LSM330_GYRO_DEV_NAME,
-			[5] = LSM9DS0_GYRO_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
@@ -208,6 +207,80 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 		.multi_read_bit = true,
 		.bootime = 2,
 	},
+	{
+		.wai = 0xd4,
+		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
+		.sensors_supported = {
+			[0] = LSM9DS0_GYRO_DEV_NAME,
+		},
+		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
+		.odr = {
+			.addr = 0x20,
+			.mask = GENMASK(7, 6),
+			.odr_avl = {
+				{ .hz = 95, .value = 0x00, },
+				{ .hz = 190, .value = 0x01, },
+				{ .hz = 380, .value = 0x02, },
+				{ .hz = 760, .value = 0x03, },
+			},
+		},
+		.pw = {
+			.addr = 0x20,
+			.mask = BIT(3),
+			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
+			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
+		},
+		.enable_axis = {
+			.addr = ST_SENSORS_DEFAULT_AXIS_ADDR,
+			.mask = ST_SENSORS_DEFAULT_AXIS_MASK,
+		},
+		.fs = {
+			.addr = 0x23,
+			.mask = GENMASK(5, 4),
+			.fs_avl = {
+				[0] = {
+					.num = ST_GYRO_FS_AVL_245DPS,
+					.value = 0x00,
+					.gain = IIO_DEGREE_TO_RAD(8750),
+				},
+				[1] = {
+					.num = ST_GYRO_FS_AVL_500DPS,
+					.value = 0x01,
+					.gain = IIO_DEGREE_TO_RAD(17500),
+				},
+				[2] = {
+					.num = ST_GYRO_FS_AVL_2000DPS,
+					.value = 0x02,
+					.gain = IIO_DEGREE_TO_RAD(70000),
+				},
+			},
+		},
+		.bdu = {
+			.addr = 0x23,
+			.mask = BIT(7),
+		},
+		.drdy_irq = {
+			.int2 = {
+				.addr = 0x22,
+				.mask = BIT(3),
+			},
+			/*
+			 * The sensor has IHL (active low) and open
+			 * drain settings, but only for INT1 and not
+			 * for the DRDY line on INT2.
+			 */
+			.stat_drdy = {
+				.addr = ST_SENSORS_DEFAULT_STAT_ADDR,
+				.mask = GENMASK(2, 0),
+			},
+		},
+		.sim = {
+			.addr = 0x23,
+			.value = BIT(0),
+		},
+		.multi_read_bit = true,
+		.bootime = 2,
+	},
 	{
 		.wai = 0xd7,
 		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,

