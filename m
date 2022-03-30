Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6544EC23D
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241848AbiC3L65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345254AbiC3LyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B68281828;
        Wed, 30 Mar 2022 04:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26B85615B7;
        Wed, 30 Mar 2022 11:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1ACC36AE7;
        Wed, 30 Mar 2022 11:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641043;
        bh=ad5NuxpHH/Hvd4cfnrHfXY6pLQKYnybTjf9eWocz+E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv6qKB8vKFr/O70Ga91Lgx3kuZFA/LWbgH1vH/3/B69k2Gs3xKfQ57pMb4VO+8YSw
         LSRqpi1xACvYD8zEEivD1johQZDLhvEpNt68YS4crpDyXpFqCm4vGVOA0uTaLoh01L
         +7YDugLgMnsnAxUd8ihmxiip7y4OnvGziOFpfmcgHGrJ2URe2E87HmC8T+A+JoysLA
         IcHWp9DLOSb0AmuVsjMOOEQ7QohJa4tqbNEdxCfJtLEYTtHEWO/ALXpEfsI0dfk0wm
         ACSU1LrPI7tnG6swZ4ZSMav2UT+1XJq8rpN4UPLbXA+fj/alSd/99P59GL2cnlBGSR
         JbMPb1t3bbkAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 24/50] arm64: defconfig: build imx-sdma as a module
Date:   Wed, 30 Mar 2022 07:49:38 -0400
Message-Id: <20220330115005.1671090-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
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
index 545197bc0501..4972a81d40d6 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -921,7 +921,7 @@ CONFIG_DMADEVICES=y
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

