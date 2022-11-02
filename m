Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A2D615849
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiKBCsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiKBCsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:48:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BCF65FF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97A3FB82072
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D82C433D6;
        Wed,  2 Nov 2022 02:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357330;
        bh=VzhH0KAUvACaNvHDFp3OYR77Ro+9zja7bAu6HqIpEwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7DrVQp9zTA77ZmxAwQDO7ZGLVGkGh4IJrqVLiEKZxaf8lO20dgoQEbPT53KmtmZr
         7gAd6ddPJlsDW+qXzjt5xkUmQqcyupK5/BQ8FpCy9Uv0p2X8Yz4toPQhmcP3Z39q4O
         br7cTM9rwB6Wgys/86+sjkZmltGFkHnBecdmwrVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 123/240] media: sun8i-rotate: Add a Kconfig dependency on RESET_CONTROLLER
Date:   Wed,  2 Nov 2022 03:31:38 +0100
Message-Id: <20221102022114.165245878@linuxfoundation.org>
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

[ Upstream commit b9273150b8b7f8b02ac961463057191d243f953d ]

The driver relies on the reset controller API to work, so add
RESET_CONTROLLER as one of its Kconfig dependencies.

Fixes: d77182ada3d4 ("media: sun8i: Add Allwinner A83T Rotate driver")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun8i-rotate/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun8i-rotate/Kconfig b/drivers/media/platform/sunxi/sun8i-rotate/Kconfig
index cfba29072d75..ee2c1f248c64 100644
--- a/drivers/media/platform/sunxi/sun8i-rotate/Kconfig
+++ b/drivers/media/platform/sunxi/sun8i-rotate/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_SUN8I_ROTATE
 	depends on V4L_MEM2MEM_DRIVERS
 	depends on VIDEO_DEV
 	depends on ARCH_SUNXI || COMPILE_TEST
-	depends on COMMON_CLK && OF
+	depends on COMMON_CLK && RESET_CONTROLLER && OF
 	depends on PM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
2.35.1



