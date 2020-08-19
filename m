Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC0249C08
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHSLo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:44:58 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42857 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727079AbgHSLo5 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 19 Aug 2020 07:44:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7746A19423C8;
        Wed, 19 Aug 2020 07:44:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EIHz0M
        GgD9QYPrJYW94M1aq3YiXuu14w25NuPG4VKWc=; b=GB/PeCZcGRZKudIgb/N/d7
        AdiTwgVAj0Ac7MrLpvc9heyJEd9GQpVtOBNLX8bi+60J9eCIffX9rxE1igQWQ13Y
        2ANUcAXe0zwcrbo3ztWjfahkt8mE8oJ7zhqU+TfogL6NCQhwsia2lQf9cQgfuzdd
        5xf6prxMQcIh74BUWg6QRg3p4iu+CLnCfXuNbeZa02/CD60qFoT51gAFDP60ZVtx
        4QGDWnjXo3ssfufHJbWZzPuyk0nFzzJv1huqMMr8wKv+CHepANPsdVsjv2fPBfpx
        8eW6GHpdiaHm6pIyIdYATGrVkYCXeZOLtkvznFPv7k7yRHXrRRGT0AgPWI0PkPjw
        ==
X-ME-Sender: <xms:txA9X9ro-7KHeMQEGxP4kZltrRCmQw22OzaxAn1B6ztrxbjJlPgh2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:txA9X_ocZIVBu51rE_DlJXt4PzfMJcvupW7Xd2kFaE0y7DErzLn5RA>
    <xmx:txA9X6NKgTfzc36Db38cgd31S6C3y7tLDzetWunv2wTeIGHPFK69kQ>
    <xmx:txA9X46lQjjFti7_5m4M1NhyPCtUe2ltrfqxUPC3GzFhNEsAMSEo7g>
    <xmx:uBA9Xxj54aOnjU8_lCoNUZ4QWhZO49ONx-Fg5_8HdjuwJ3hQbdt9Hw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D0723280064;
        Wed, 19 Aug 2020 07:44:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: reset hw ts after resume" failed to apply to 5.4-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, sean@geanix.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:45:18 +0200
Message-ID: <15978375187370@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a1bab9396c2d98c601ce81c27567159dfbc10c19 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 13 Jul 2020 13:40:19 +0200
Subject: [PATCH] iio: imu: st_lsm6dsx: reset hw ts after resume

Reset hw time samples generator after system resume in order to avoid
disalignment between system and device time reference since FIFO
batching and time samples generator are disabled during suspend.

Fixes: 213451076bd3 ("iio: imu: st_lsm6dsx: add hw timestamp support")
Tested-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index d82ec6398222..d80ba2e688ed 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -436,8 +436,7 @@ int st_lsm6dsx_update_watermark(struct st_lsm6dsx_sensor *sensor,
 				u16 watermark);
 int st_lsm6dsx_update_fifo(struct st_lsm6dsx_sensor *sensor, bool enable);
 int st_lsm6dsx_flush_fifo(struct st_lsm6dsx_hw *hw);
-int st_lsm6dsx_set_fifo_mode(struct st_lsm6dsx_hw *hw,
-			     enum st_lsm6dsx_fifo_mode fifo_mode);
+int st_lsm6dsx_resume_fifo(struct st_lsm6dsx_hw *hw);
 int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw);
 int st_lsm6dsx_read_tagged_fifo(struct st_lsm6dsx_hw *hw);
 int st_lsm6dsx_check_odr(struct st_lsm6dsx_sensor *sensor, u32 odr, u8 *val);
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index afd00daeefb2..7de10bd636ea 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -184,8 +184,8 @@ static int st_lsm6dsx_update_decimators(struct st_lsm6dsx_hw *hw)
 	return err;
 }
 
-int st_lsm6dsx_set_fifo_mode(struct st_lsm6dsx_hw *hw,
-			     enum st_lsm6dsx_fifo_mode fifo_mode)
+static int st_lsm6dsx_set_fifo_mode(struct st_lsm6dsx_hw *hw,
+				    enum st_lsm6dsx_fifo_mode fifo_mode)
 {
 	unsigned int data;
 
@@ -302,6 +302,18 @@ static int st_lsm6dsx_reset_hw_ts(struct st_lsm6dsx_hw *hw)
 	return 0;
 }
 
+int st_lsm6dsx_resume_fifo(struct st_lsm6dsx_hw *hw)
+{
+	int err;
+
+	/* reset hw ts counter */
+	err = st_lsm6dsx_reset_hw_ts(hw);
+	if (err < 0)
+		return err;
+
+	return st_lsm6dsx_set_fifo_mode(hw, ST_LSM6DSX_FIFO_CONT);
+}
+
 /*
  * Set max bulk read to ST_LSM6DSX_MAX_WORD_LEN/ST_LSM6DSX_MAX_TAGGED_WORD_LEN
  * in order to avoid a kmalloc for each bus access
@@ -675,12 +687,7 @@ int st_lsm6dsx_update_fifo(struct st_lsm6dsx_sensor *sensor, bool enable)
 		goto out;
 
 	if (fifo_mask) {
-		/* reset hw ts counter */
-		err = st_lsm6dsx_reset_hw_ts(hw);
-		if (err < 0)
-			goto out;
-
-		err = st_lsm6dsx_set_fifo_mode(hw, ST_LSM6DSX_FIFO_CONT);
+		err = st_lsm6dsx_resume_fifo(hw);
 		if (err < 0)
 			goto out;
 	}
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index c8ddeb3f48ff..346c24281d26 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2457,7 +2457,7 @@ static int __maybe_unused st_lsm6dsx_resume(struct device *dev)
 	}
 
 	if (hw->fifo_mask)
-		err = st_lsm6dsx_set_fifo_mode(hw, ST_LSM6DSX_FIFO_CONT);
+		err = st_lsm6dsx_resume_fifo(hw);
 
 	return err;
 }

