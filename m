Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1E761584F
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiKBCt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiKBCt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:49:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E61C6562
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18172B82072
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA735C433D6;
        Wed,  2 Nov 2022 02:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357365;
        bh=6KuX6lHKki3skYVe1wlL8l/d/bVhw6cJ48/uPFdP55I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6/kupm04S6MG0hn+ChIcPa2IcCRJBTFVxdYQf7nw1Q0jtCpmsdxhV7Vlc6RMpWcp
         k1n/Zdcz19phPDkcPWRSzqzUfKNEMOlqVhM55I1V+iDGiFpBtnKnrXduG9t6R7AO7A
         MmyC0bK/6pNY7HgziKVoWVtQ9nfwBNHQHxlYCvxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 119/240] media: sun8i-a83t-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER
Date:   Wed,  2 Nov 2022 03:31:34 +0100
Message-Id: <20221102022114.077043633@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 398c479234894c3d3347d83869760db3c406c269 ]

The driver relies on the reset controller API to work, so add
RESET_CONTROLLER as one of its Kconfig dependencies.

Fixes: 576d196c522b ("media: sunxi: Add support for the A83T MIPI CSI-2 controller")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig
index 789d58ee12ea..47a8c0fb7eb9 100644
--- a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig
+++ b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_SUN8I_A83T_MIPI_CSI2
 	tristate "Allwinner A83T MIPI CSI-2 Controller and D-PHY Driver"
 	depends on V4L_PLATFORM_DRIVERS && VIDEO_DEV
 	depends on ARCH_SUNXI || COMPILE_TEST
-	depends on PM && COMMON_CLK
+	depends on PM && COMMON_CLK && RESET_CONTROLLER
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
-- 
2.35.1



