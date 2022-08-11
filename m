Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4D58FF76
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbiHKP3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiHKP3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:29:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D50995695;
        Thu, 11 Aug 2022 08:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B9736160D;
        Thu, 11 Aug 2022 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C90C433D7;
        Thu, 11 Aug 2022 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231762;
        bh=9FeYYRV5Pnc12SQ73cjyxL/8SmCxH/PivF9Ez+bntXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwcArKFv8QkZNmlCSu5pcvWhUZ8GPMC13QveU37ZYrt86mrt2aOYQ3v1Jk6/wWTsS
         QbbwW9oAvdap88FzH/2eqHbF8z9aMo4d3VxD9aV0edTPH9eCzEEj+bp21I+UyQFruR
         9RcKWUNqv7fsaB6/0635jd2xJohgmw3Me4dFbLrYDBLmfu/ftw3UMgB1tiCD/Sks6u
         1xD0x6Dmab+l3Rk6FlUVt/nETrqGCmEBAN8Awh48h1yHFz3am/0oHYn3rCOfFnR+h0
         wENtmPU57aJUHSNazAgqgAcw5eQ+ng9zd3AgTQ+wH+G46EFVAcsugyLyQwiOwRFfyJ
         N+uxiuYNFQ0ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh@kernel.org,
        tomeu.vizoso@collabora.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 008/105] drm/panfrost: Add arm,mali-valhall-jm compatible
Date:   Thu, 11 Aug 2022 11:26:52 -0400
Message-Id: <20220811152851.1520029-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>

[ Upstream commit 952cd974509251d6b5074bc3677b8297826a6ef1 ]

The most important Valhall-specific quirks have been handled, so add the
Valhall compatible and probe.

v2: Use arm,mali-valhall-jm compatible.

Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220525145754.25866-10-alyssa.rosenzweig@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index b1e6d238674f..2d870cf73b07 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -665,6 +665,7 @@ static const struct of_device_id dt_match[] = {
 	{ .compatible = "arm,mali-t860", .data = &default_data, },
 	{ .compatible = "arm,mali-t880", .data = &default_data, },
 	{ .compatible = "arm,mali-bifrost", .data = &default_data, },
+	{ .compatible = "arm,mali-valhall-jm", .data = &default_data, },
 	{ .compatible = "mediatek,mt8183-mali", .data = &mediatek_mt8183_data },
 	{}
 };
-- 
2.35.1

