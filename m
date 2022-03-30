Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBECA4EC288
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiC3Lzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344592AbiC3LxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9563D2675B9;
        Wed, 30 Mar 2022 04:49:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B257B81C39;
        Wed, 30 Mar 2022 11:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046CCC36AE5;
        Wed, 30 Mar 2022 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640953;
        bh=QzSIcaDzb8HnSCLtk/JYXGW98gjjpvoITr3c8rYkXFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1NdFsU7/933Ipddyduv6MrzVel5tUgh0ZsFNUD92j1QpCsmv5P0hL5qEH9YUa1v6
         2KnfMqhYjWEyGNbHxMs+fuUn4v6IF2PVx1c4239+bQzUGOVRmmU4Yasyf0Ujbv57hB
         0cGXvAYxUjkbgGmQhJbsjzfBZBPMDurnXwRSI3iu5GL53+o20OeR5Y6eT79dR8979y
         5kCw5Q0/6A6cw4tX8bqnzF2SNgl8cXhYEpgCoMuAQXEygWsN7yl8bFmA/P8bu6xmD4
         KCnyJs1jVRdod+SmGnxd0AttRCm8gpOkBDwy49AR6+I6wAS2dfGftmuX059YzaeuEn
         SUxEHXbi/K3fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 26/59] arm64: defconfig: build imx-sdma as a module
Date:   Wed, 30 Mar 2022 07:47:58 -0400
Message-Id: <20220330114831.1670235-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit e95622289f263662240544a9f0009b25c19e64d4 ]

This avoids firmware load error and sysfs fallback reported as follows:

[    0.199448] imx-sdma 302c0000.dma-controller: Direct firmware load
 for imx/sdma/sdma-imx7d.bin failed with error -2
[    0.199487] imx-sdma 302c0000.dma-controller: Falling back to sysfs
 fallback for: imx/sdma/sdma-imx7d.bin

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index f2e2b9bdd702..d1fdf68be26e 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -931,7 +931,7 @@ CONFIG_DMADEVICES=y
 CONFIG_DMA_BCM2835=y
 CONFIG_DMA_SUN6I=m
 CONFIG_FSL_EDMA=y
-CONFIG_IMX_SDMA=y
+CONFIG_IMX_SDMA=m
 CONFIG_K3_DMA=y
 CONFIG_MV_XOR=y
 CONFIG_MV_XOR_V2=y
-- 
2.34.1

