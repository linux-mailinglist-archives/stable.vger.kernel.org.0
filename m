Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695B4590131
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiHKPwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiHKPv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:51:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB969DF9F;
        Thu, 11 Aug 2022 08:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17F3AB82128;
        Thu, 11 Aug 2022 15:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1189C433D7;
        Thu, 11 Aug 2022 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232590;
        bh=9Ueg5z2RmYuHVN12Ymoa2nwN1mbLVrlL9TUmV9jv+48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5+JYZwH6klAmtNEzhbrmoxpRTccxNjO4AmiB/HEWd/00FC7vsdgHeK+CoOrELMeE
         0C9NNdXpKureLvEN9nUS/MV7N7bWova9JYU87q9MOyzoJ5JTmdqUTVZwqQ+ybKRuN9
         0RmlAAHRhUpncT8p0f6TzqgCxungxIeLYDI9msDmc34daDTOvHE5NlcOSD3UM9Cscu
         n4OYecpVpCOMoNntM6BXA+GdVfc1+P5NpoQ13iyzLh99Q5K0YtqAD0UzhAZqfN227K
         5hW6V7t1gBWonmv/JaFJ5wXF1ufXEIgcFSQ+KAmqM5dSO1S1/CLrmChEhRUYJ01WLz
         MS7gt7TYhEKGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh@kernel.org,
        tomeu.vizoso@collabora.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 08/93] drm/panfrost: Add arm,mali-valhall-jm compatible
Date:   Thu, 11 Aug 2022 11:41:02 -0400
Message-Id: <20220811154237.1531313-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index 601e124842e1..c1260532f003 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -664,6 +664,7 @@ static const struct of_device_id dt_match[] = {
 	{ .compatible = "arm,mali-t860", .data = &default_data, },
 	{ .compatible = "arm,mali-t880", .data = &default_data, },
 	{ .compatible = "arm,mali-bifrost", .data = &default_data, },
+	{ .compatible = "arm,mali-valhall-jm", .data = &default_data, },
 	{ .compatible = "mediatek,mt8183-mali", .data = &mediatek_mt8183_data },
 	{}
 };
-- 
2.35.1

