Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569412A480F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgKCO0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:26:53 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42287 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729748AbgKCO0v (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 3 Nov 2020 09:26:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F2358CBA;
        Tue,  3 Nov 2020 09:26:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=L6NEhZ
        Wpf0CscW8ddIERm34WSwAlUKrZL2eatgXLXdY=; b=FgS784OfvjPKlwl9ru2wNH
        8U2ErEKt6eK12wcI13FlVHC3xsis0ojrs0ndyE8voIGphVpw20KpJhTHSDjsZeDg
        w7vcDda0/Vr45fxE3EV8XUnUll52wNWRWd/8rmI2Ye96NWoaNhociHplldsuFHQm
        am9mODi+Y1AR1vIIOGDdLudPrES9l1ez0nfpzQYI0vwug6/h/pflk+fHUR1O4BJp
        U0rdtT2bOeb6aJxQL1v6bf6x+QzMxOcFGMRQcLPT3hDhpPjBMEBCxNMIY6dtNod2
        vw5qIpoBzC8AcP12bKOluM9K4+vM5RhMizRq5i+ESzNpDWopkUoe2Llzabo0h4Qw
        ==
X-ME-Sender: <xms:qWihX2QP7Ly56Kw6fiDgT1k-gfp8RMPgKp8p-elqhccrp-iJRZo_8w>
    <xme:qWihX7yBfLaYHZYP_Tfrjoh3QEvpA8epj8pyCatqPCCG88nXHTMWOWPOFxjjYD5mq
    ebbfnyBWYEmsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qWihXz19Qiho0ZzwYBo077n41OgsFQWi5czD7SPVq9HHwyxQvyx-FA>
    <xmx:qWihXyCN83-3xtOKhkz1gUc0NTF1kwRtiPdMhdcr0WLPEc79f4yfow>
    <xmx:qWihX_iaQWHKcdjsi0Tz6-DlF8sE6M8jcQuWDnCVBDzqfJCLx4Gj0Q>
    <xmx:qWihX3YcAyQeZ73CN0X49LZTESFLuN5_EXkylAsNpN2dngWBZvqV2MJWdeE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F37B306468E;
        Tue,  3 Nov 2020 09:26:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return" failed to apply to 5.4-stable tree
To:     trix@redhat.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:27:42 +0100
Message-ID: <1604413662200104@kroah.com>
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

From f71e41e23e129640f620b65fc362a6da02580310 Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Sun, 9 Aug 2020 10:55:51 -0700
Subject: [PATCH] iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return

Potential error return is not checked.  This can lead to use
of undefined data.

Detected by clang static analysis.

st_lsm6dsx_shub.c:540:8: warning: Assigned value is garbage or undefined
        *val = (s16)le16_to_cpu(*((__le16 *)data));
             ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Tom Rix <trix@redhat.com
Cc: <Stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20200809175551.6794-1-trix@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
index ed83471dc7dd..8c8d8870ca07 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -313,6 +313,8 @@ st_lsm6dsx_shub_read(struct st_lsm6dsx_sensor *sensor, u8 addr,
 
 	err = st_lsm6dsx_shub_read_output(hw, data,
 					  len & ST_LS6DSX_READ_OP_MASK);
+	if (err < 0)
+		return err;
 
 	st_lsm6dsx_shub_master_enable(sensor, false);
 

