Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642576087CC
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiJVIGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiJVIFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:05:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36512C2AD2;
        Sat, 22 Oct 2022 00:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78985B82E10;
        Sat, 22 Oct 2022 07:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94620C433D6;
        Sat, 22 Oct 2022 07:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425123;
        bh=Q4JHJu+FS1cZcSaWDMVIpJu42fBheHX5lVnvNO+s2IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rj0W9REfjslsVncivrFIPtUU/0ekkWCWNP1v96W5fnnvXavxApsRokmVrf7vHC1uo
         65btLfGSVB0n4Fk0+rl/EAN+dPH57S15AooubfBUyXfHcDdoE/WU6/VncWgAgcJZTB
         j6B1GQruK4tz6c76v/8OV8s/rkMte7uJnMqK5muM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 357/717] arm64: dts: renesas: r9a07g043: Fix SCI{Rx,Tx} interrupt types
Date:   Sat, 22 Oct 2022 09:23:56 +0200
Message-Id: <20221022072511.919091215@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 72a482dbaec4b9e4d54b81be6bdb8c016fd2f4bd ]

As per the RZ/G2UL Hardware User's Manual (Rev.1.00 Apr, 2022),
the interrupt type of SCI{Rx,Tx} is edge triggered.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Fixes: cf40c9689e5109bf ("arm64: dts: renesas: Add initial DTSI for RZ/G2UL SoC")
Link: https://lore.kernel.org/r/20220802101534.1401342-3-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g043.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g043.dtsi b/arch/arm64/boot/dts/renesas/r9a07g043.dtsi
index b31fb713ae4d..434ae73664a2 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g043.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g043.dtsi
@@ -334,8 +334,8 @@
 			compatible = "renesas,r9a07g043-sci", "renesas,sci";
 			reg = <0 0x1004d000 0 0x400>;
 			interrupts = <GIC_SPI 405 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 406 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 407 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 406 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 407 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 408 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "eri", "rxi", "txi", "tei";
 			clocks = <&cpg CPG_MOD R9A07G043_SCI0_CLKP>;
@@ -349,8 +349,8 @@
 			compatible = "renesas,r9a07g043-sci", "renesas,sci";
 			reg = <0 0x1004d400 0 0x400>;
 			interrupts = <GIC_SPI 409 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 410 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 411 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 410 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 411 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 412 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "eri", "rxi", "txi", "tei";
 			clocks = <&cpg CPG_MOD R9A07G043_SCI1_CLKP>;
-- 
2.35.1



