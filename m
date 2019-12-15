Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5571811F703
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfLOJaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:30:22 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43521 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbfLOJaV (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 15 Dec 2019 04:30:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C2FF66B0;
        Sun, 15 Dec 2019 04:30:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:30:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3yzpB0
        OawhhY5XeIGs3V5D0t1tm2mkXYneJXzpPM0/U=; b=sywO2I6KyP46ERGqNMOI56
        8spFUmjJG/5PTd5FS7FbX08fCQB6i4Yu4faugbWczhyImiqzingVJ05OVVeYQ5Df
        73WjEmcsEsIY8+tyIWjRaxbC9RRYWQ02n+R44yFblwTSG65mBZQ1NstPyy+fpzOE
        ejAZGdZvHSQrOz/oba6gUDGwiCd5kYpf9qf/iWG4F2SzfnLMz2TBiA0ta+tJGAjh
        1fhL8F0uMM7dRomZVzi84e8ENYKEu3KKEsAmzgLYNi8rpsVWnmcaV+DR/2lTbUnJ
        V9uXv/c112pK3pS+dI9LAIYgFIf3kUtnubyAGXqXJTLLf9j+DuWfoBRbwxvf2n2w
        ==
X-ME-Sender: <xms:LP31XdAEBo5CLwo0Qaafwc4TEM9VSAoEMM8QXz3S6P7cvLSzp9rl-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:LP31XU9wj7fVH3CQ052uPKm-o0_ZuviWfyPqXypIBvL8054s9yqZuQ>
    <xmx:LP31XZYmsOFVgiXFGC_eq9I6kCHUANwiqwZgxOEmYq5ZpLQcVQauiA>
    <xmx:LP31XTGHXl3ZJEpIvEOwyJrbX7WbrPiS4w_nzA2QUxbAt7y7RvcfBg>
    <xmx:LP31Xf2VVv3akmzy2UvvieAmEoB1XdqRF7fM9sXm_ttJhNHe0x2keg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D0BE30600D4;
        Sun, 15 Dec 2019 04:30:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw" failed to apply to 5.3-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:30:18 +0100
Message-ID: <157640221818196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fc3f6ad7f5dc6c899fbda0255865737bac88c2e0 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 27 Oct 2019 19:02:30 +0100
Subject: [PATCH] iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw

Since st_lsm6dsx i2c master controller relies on accel device as trigger
and slave devices can run at different ODRs we must select an accel_odr >=
slave_odr. Report real accel ODR in st_lsm6dsx_check_odr() in order to
properly set sensor frequency in st_lsm6dsx_write_raw and avoid to
report unsupported frequency

Fixes: 6ffb55e5009ff ("iio: imu: st_lsm6dsx: introduce ST_LSM6DSX_ID_EXT sensor ids")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index a3333c215339..2f9396745bc8 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1377,8 +1377,7 @@ int st_lsm6dsx_check_odr(struct st_lsm6dsx_sensor *sensor, u16 odr, u8 *val)
 		return -EINVAL;
 
 	*val = odr_table->odr_avl[i].val;
-
-	return 0;
+	return odr_table->odr_avl[i].hz;
 }
 
 static u16 st_lsm6dsx_check_odr_dependency(struct st_lsm6dsx_hw *hw, u16 odr,
@@ -1542,8 +1541,10 @@ static int st_lsm6dsx_write_raw(struct iio_dev *iio_dev,
 	case IIO_CHAN_INFO_SAMP_FREQ: {
 		u8 data;
 
-		err = st_lsm6dsx_check_odr(sensor, val, &data);
-		if (!err)
+		val = st_lsm6dsx_check_odr(sensor, val, &data);
+		if (val < 0)
+			err = val;
+		else
 			sensor->odr = val;
 		break;
 	}

