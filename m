Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B59660876A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiJVIBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiJVH75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403D855C5E;
        Sat, 22 Oct 2022 00:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FDBD60ADD;
        Sat, 22 Oct 2022 07:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4226C4347C;
        Sat, 22 Oct 2022 07:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425004;
        bh=0W0DPC96UQVJK7c3z8nHQBdkuOIdZZVm8tIXy8mpT1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOhkFjvIrsBQu4orvUc2maihudKUK2IMksQTsT67X1pnVwPONPikGh8jQ5Ae7OIc6
         +FFieKXMxE0DfffcLUCgJN7E29bC0pu+PhH0iw7Q/gVh6xoFSVnBRaJ3TCLEA271Rp
         3ysn660MPMkXKpURnbw0A7kMUQNRZ0ftGuKs9yOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 355/717] arm64: dts: renesas: r9a07g044: Fix SCI{Rx,Tx} interrupt types
Date:   Sat, 22 Oct 2022 09:23:54 +0200
Message-Id: <20221022072511.772168721@linuxfoundation.org>
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

[ Upstream commit f3b7bc89c97b98aa6f157d5f296695af8940a5ac ]

As per the latest RZ/G2L Hardware User's Manual (Rev.1.10 Apr, 2022),
the interrupt type of SCI{Rx,Tx} is edge triggered.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Fixes: f9a2adcc9e908907 ("arm64: dts: renesas: r9a07g044: Add SCI[0-1] nodes")
Link: https://lore.kernel.org/r/20220802101534.1401342-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
index 3652e511160f..265140b20dad 100644
--- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
@@ -394,8 +394,8 @@
 			compatible = "renesas,r9a07g044-sci", "renesas,sci";
 			reg = <0 0x1004d000 0 0x400>;
 			interrupts = <GIC_SPI 405 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 406 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 407 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 406 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 407 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 408 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "eri", "rxi", "txi", "tei";
 			clocks = <&cpg CPG_MOD R9A07G044_SCI0_CLKP>;
@@ -409,8 +409,8 @@
 			compatible = "renesas,r9a07g044-sci", "renesas,sci";
 			reg = <0 0x1004d400 0 0x400>;
 			interrupts = <GIC_SPI 409 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 410 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 411 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 410 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 411 IRQ_TYPE_EDGE_RISING>,
 				     <GIC_SPI 412 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "eri", "rxi", "txi", "tei";
 			clocks = <&cpg CPG_MOD R9A07G044_SCI1_CLKP>;
-- 
2.35.1



