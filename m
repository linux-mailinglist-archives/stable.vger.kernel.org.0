Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85556579C09
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbiGSMfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241200AbiGSMey (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:34:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE83A79686;
        Tue, 19 Jul 2022 05:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D986178A;
        Tue, 19 Jul 2022 12:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6D1C341CA;
        Tue, 19 Jul 2022 12:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232785;
        bh=fr9eRr9LYNLPJAml2G3Qm16Rayd/ibjXZQcpvaqCjY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUsyAJAVusGc7sRi999Qu0ME5FDCrkfu3X+5gIejf1AfKwuXqNVvsA2i/owVLF86B
         KLRT2y8L9dtCGTETNtUW7uXroKTgV51KGz7iVHXoXO8LS4Hfy2p1YUxbERo5OK0W2A
         NNMR6/I9ur/kur13V+LxAPZL06J5xl/wQSfCXPf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/167] ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero
Date:   Tue, 19 Jul 2022 13:53:16 +0200
Message-Id: <20220719114702.735759553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 884b66976a7279ee889ba885fe364244d50b79e7 ]

The device tree should include generic "jedec,spi-nor" compatible, and a
manufacturer-specific one.
The macronix part is what is shipped on the boards that come with a
flash chip.

Fixes: 45857ae95478 ("ARM: dts: orange-pi-zero: add node for SPI NOR")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220708174529.3360-1-msuchanek@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
index f19ed981da9d..3706216ffb40 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
@@ -169,7 +169,7 @@ &spi0 {
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "mxicy,mx25l1606e", "winbond,w25q128";
+		compatible = "mxicy,mx25l1606e", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <40000000>;
 	};
-- 
2.35.1



