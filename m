Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837DD249C09
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgHSLpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:45:10 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:45927 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbgHSLpJ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 19 Aug 2020 07:45:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 93ABD1942466;
        Wed, 19 Aug 2020 07:45:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:45:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RICdWP
        4E/0VQssNSm//FayufehqlZYV+UmCwPjxpiVU=; b=nFBftCqxIsiwQ727k9GRy9
        /5HQsqSkKgNCGfJFSHwQdgdjTvclz/pb3K0yOffVNzAapWnO8rjKy/xQHgnjwmH+
        9uABesRv5BAPEziMAl90VE0PkYTdcNZJCW19Cv78rX5a/VOEJLweI7BaNXdyJB61
        uxwJk5u3F7H9tMOM9LNcabYhYS0Cdk9madynF+Mez16BvCKIOuJkL1cSVAcF8RMN
        6DT+3Xk2CD4GQg1hHbCQBM7Z8IauLvZzdvtUGUF7X7Q94fMPvxp97pqZw0ywslvE
        S48rI4tOwrlTW6uccqe1fdqvjrbOeWBJ39s9WSvqETZIzPOTV+YFVWQArxVs6dzA
        ==
X-ME-Sender: <xms:wBA9XxmOOTFZCV85hivHsg_HSsO6bJdoTW2TocQ_vP0TSUrMaKRFUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:wBA9X80SLqCrEEqYORbkH29sw3vtFpv4Li13CUKpf0otbTDp0qRJNg>
    <xmx:wBA9X3qH3qoMIvkeKUN7Di4a-ebnf4XPVmPMn_tXaG7BbOjB9TTiLg>
    <xmx:wBA9Xxm30qNWzlipeFeqffCIZcDzPk4cvSsuehx0R7wMoBcGlIKxwg>
    <xmx:wBA9X89Zw7-YhAkca21sTcighSa3RI3CjcvB8b6WQcDVUnkk06PifA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2687E3280065;
        Wed, 19 Aug 2020 07:45:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: reset hw ts after resume" failed to apply to 4.19-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, sean@geanix.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:45:18 +0200
Message-ID: <1597837518117249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

