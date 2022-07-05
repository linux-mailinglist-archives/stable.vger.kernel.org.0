Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2209456680D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 12:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiGEKdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 06:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiGEKdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 06:33:13 -0400
X-Greylist: delayed 2002 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 03:33:11 PDT
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5FA15735
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 03:33:11 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1o8fLP-00FUx0-S9; Tue, 05 Jul 2022 09:59:47 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 05 Jul 2022 09:59:14 +0000
Subject: [git:media_stage/master] media: isl7998x: select V4L2_FWNODE to fix build error
To:     linuxtv-commits@linuxtv.org
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Michael Tretter <m.tretter@pengutronix.de>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Marek Vasut <marex@denx.de>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1o8fLP-00FUx0-S9@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: isl7998x: select V4L2_FWNODE to fix build error
Author:  Randy Dunlap <rdunlap@infradead.org>
Date:    Wed Mar 30 02:56:52 2022 +0100

Fix build error when VIDEO_ISL7998X=y and V4L2_FWNODE=m
by selecting V4L2_FWNODE.

microblaze-linux-ld: drivers/media/i2c/isl7998x.o: in function `isl7998x_probe':
(.text+0x8f4): undefined reference to `v4l2_fwnode_endpoint_parse'

Cc: stable@vger.kernel.org # 5.18 and above
Fixes: 51ef2be546e2 ("media: i2c: isl7998x: Add driver for Intersil ISL7998x")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 2b20aa6c37b1..c926e5d43820 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1178,6 +1178,7 @@ config VIDEO_ISL7998X
 	depends on OF_GPIO
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
+	select V4L2_FWNODE
 	help
 	  Support for Intersil ISL7998x analog to MIPI-CSI2 or
 	  BT.656 decoder.
