Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679E24F3DB9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352773AbiDEMWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344198AbiDEKjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34DB167F8;
        Tue,  5 Apr 2022 03:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 810D0B81C8A;
        Tue,  5 Apr 2022 10:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82DCC385A1;
        Tue,  5 Apr 2022 10:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154303;
        bh=vSWwKbrR19XdVO7iI7iBtjrl3iBpFXIU9WwNPn5PLvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJgYycZmPECV0oIKA+6dnvTRL+HMDbc6gZ33gs+zfpKUHoWiRDZ6VgeAARcRctCBO
         tShBKaQQ43tFBNHHS8/yCUwk6GWGNvCF4GXfXNvfPvNurAbMsrQqTV3NlWBFn2x7rz
         Lq8EGal1b9rYuan0gaWz383XZdwKSq44ex9/zyQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/599] arm64: defconfig: build imx-sdma as a module
Date:   Tue,  5 Apr 2022 09:33:08 +0200
Message-Id: <20220405070313.529133383@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5cfe3cf6f2ac..2bdf38d05fa5 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -837,7 +837,7 @@ CONFIG_DMADEVICES=y
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



