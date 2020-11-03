Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1F22A4815
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgKCO2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:28:46 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:54593 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729710AbgKCO20 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 3 Nov 2020 09:28:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B7C4DD1A;
        Tue,  3 Nov 2020 09:28:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:28:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=61PkHl
        UbBzTeTZTBg/JDIAqXssLIyFqJYTcTMm2ujw8=; b=kVRIP1RcmDgHhG310bF+y3
        n4Hcfe9d3vqqoVoWzmFnkmqTOPFCEQ+i4AcEWrLbRxC4W84iCPoqXDG11b74ZJZD
        TVGKYmMaLYA8XfbG/+lFck5ENIgBmMDY0+rw0oc6hVPhLlMAQnlAH5+QSP3uqtGT
        6ln3dlIBv9h3RJ4GdPCgInyFnTIjhx276Sw+ZKLK+K11Q3mBw24MV3UCac8jBCI3
        Bmw2w5Qx++vZxZktu6820ors/eaxkttHNQyfaHP1kyH4fUzfswDuq80iI5DwTHlN
        OB0pLWYKZop+/zWhGypSSywJ4U314oUEcJS+3ZUm/Ye2z11X6HgbIU8XKT+HVUNg
        ==
X-ME-Sender: <xms:CWmhXxGr_ESRhDTndN-onWmvf9s-z1CYbz76zsak2MNh3RNuPEmj5A>
    <xme:CWmhX2U46Bpwsjm8uvw4kLkaMPnA9pdg6WvpIm7AbQuhd_RzM8N9K1HtsBTp_MUQy
    OlD8j1Gf6vLkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CWmhXzIZB6L2BlnSDDEnMHp5d9Q_BPctep_qeTwG_SjoPTL_EglWvg>
    <xmx:CWmhX3ESpDi2DQd8TsJuFTUAaX_UPexm6coDIjKhPxhl6Qx9L-cGaw>
    <xmx:CWmhX3Uk3cAih2dkOtoCt8tzEGf_JdzJ5DLJKDoJ2AZMLf6vzHwvsA>
    <xmx:CWmhX0hr2uIYkjmC48wm187UF8ypinkOWiyOznbyl0dOd01bj65M-1d_nNs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DBBB43064610;
        Tue,  3 Nov 2020 09:28:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:imu:st_lsm6dsx Fix alignment and data leak issues" failed to apply to 5.4-stable tree
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de,
        lorenzo.bianconi83@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:29:11 +0100
Message-ID: <16044137518268@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c14edb4d0bdc53f969ea84c7f384472c28b1a9f8 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:52 +0100
Subject: [PATCH] iio:imu:st_lsm6dsx Fix alignment and data leak issues

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to an array of suitable structures in the iio_priv() data.

This data is allocated with kzalloc so no data can leak apart from
previous readings.

For the tagged path the data is aligned by using __aligned(8) for
the buffer on the stack.

There has been a lot of churn in this driver, so likely backports
may be needed for stable.

Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-17-jic23@kernel.org

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index d80ba2e688ed..9275346a9cc1 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -383,6 +383,7 @@ struct st_lsm6dsx_sensor {
  * @iio_devs: Pointers to acc/gyro iio_dev instances.
  * @settings: Pointer to the specific sensor settings in use.
  * @orientation: sensor chip orientation relative to main hardware.
+ * @scan: Temporary buffers used to align data before iio_push_to_buffers()
  */
 struct st_lsm6dsx_hw {
 	struct device *dev;
@@ -411,6 +412,11 @@ struct st_lsm6dsx_hw {
 	const struct st_lsm6dsx_settings *settings;
 
 	struct iio_mount_matrix orientation;
+	/* Ensure natural alignment of buffer elements */
+	struct {
+		__le16 channels[3];
+		s64 ts __aligned(8);
+	} scan[3];
 };
 
 static __maybe_unused const struct iio_event_spec st_lsm6dsx_event = {
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index 7de10bd636ea..12ed0a2e55e4 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -353,9 +353,6 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 	int err, sip, acc_sip, gyro_sip, ts_sip, ext_sip, read_len, offset;
 	u16 fifo_len, pattern_len = hw->sip * ST_LSM6DSX_SAMPLE_SIZE;
 	u16 fifo_diff_mask = hw->settings->fifo_ops.fifo_diff.mask;
-	u8 gyro_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
-	u8 acc_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
-	u8 ext_buff[ST_LSM6DSX_IIO_BUFF_SIZE];
 	bool reset_ts = false;
 	__le16 fifo_status;
 	s64 ts = 0;
@@ -416,19 +413,22 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 
 		while (acc_sip > 0 || gyro_sip > 0 || ext_sip > 0) {
 			if (gyro_sip > 0 && !(sip % gyro_sensor->decimator)) {
-				memcpy(gyro_buff, &hw->buff[offset],
-				       ST_LSM6DSX_SAMPLE_SIZE);
-				offset += ST_LSM6DSX_SAMPLE_SIZE;
+				memcpy(hw->scan[ST_LSM6DSX_ID_GYRO].channels,
+				       &hw->buff[offset],
+				       sizeof(hw->scan[ST_LSM6DSX_ID_GYRO].channels));
+				offset += sizeof(hw->scan[ST_LSM6DSX_ID_GYRO].channels);
 			}
 			if (acc_sip > 0 && !(sip % acc_sensor->decimator)) {
-				memcpy(acc_buff, &hw->buff[offset],
-				       ST_LSM6DSX_SAMPLE_SIZE);
-				offset += ST_LSM6DSX_SAMPLE_SIZE;
+				memcpy(hw->scan[ST_LSM6DSX_ID_ACC].channels,
+				       &hw->buff[offset],
+				       sizeof(hw->scan[ST_LSM6DSX_ID_ACC].channels));
+				offset += sizeof(hw->scan[ST_LSM6DSX_ID_ACC].channels);
 			}
 			if (ext_sip > 0 && !(sip % ext_sensor->decimator)) {
-				memcpy(ext_buff, &hw->buff[offset],
-				       ST_LSM6DSX_SAMPLE_SIZE);
-				offset += ST_LSM6DSX_SAMPLE_SIZE;
+				memcpy(hw->scan[ST_LSM6DSX_ID_EXT0].channels,
+				       &hw->buff[offset],
+				       sizeof(hw->scan[ST_LSM6DSX_ID_EXT0].channels));
+				offset += sizeof(hw->scan[ST_LSM6DSX_ID_EXT0].channels);
 			}
 
 			if (ts_sip-- > 0) {
@@ -458,19 +458,22 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 			if (gyro_sip > 0 && !(sip % gyro_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_GYRO],
-					gyro_buff, gyro_sensor->ts_ref + ts);
+					&hw->scan[ST_LSM6DSX_ID_GYRO],
+					gyro_sensor->ts_ref + ts);
 				gyro_sip--;
 			}
 			if (acc_sip > 0 && !(sip % acc_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_ACC],
-					acc_buff, acc_sensor->ts_ref + ts);
+					&hw->scan[ST_LSM6DSX_ID_ACC],
+					acc_sensor->ts_ref + ts);
 				acc_sip--;
 			}
 			if (ext_sip > 0 && !(sip % ext_sensor->decimator)) {
 				iio_push_to_buffers_with_timestamp(
 					hw->iio_devs[ST_LSM6DSX_ID_EXT0],
-					ext_buff, ext_sensor->ts_ref + ts);
+					&hw->scan[ST_LSM6DSX_ID_EXT0],
+					ext_sensor->ts_ref + ts);
 				ext_sip--;
 			}
 			sip++;
@@ -555,7 +558,14 @@ int st_lsm6dsx_read_tagged_fifo(struct st_lsm6dsx_hw *hw)
 {
 	u16 pattern_len = hw->sip * ST_LSM6DSX_TAGGED_SAMPLE_SIZE;
 	u16 fifo_len, fifo_diff_mask;
-	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE], tag;
+	/*
+	 * Alignment needed as this can ultimately be passed to a
+	 * call to iio_push_to_buffers_with_timestamp() which
+	 * must be passed a buffer that is aligned to 8 bytes so
+	 * as to allow insertion of a naturally aligned timestamp.
+	 */
+	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8);
+	u8 tag;
 	bool reset_ts = false;
 	int i, err, read_len;
 	__le16 fifo_status;

