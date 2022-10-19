Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6B6603DB1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiJSJFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiJSJEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA0CAE220;
        Wed, 19 Oct 2022 01:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39DC461880;
        Wed, 19 Oct 2022 08:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C88BC433B5;
        Wed, 19 Oct 2022 08:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169826;
        bh=Ua6YMqnfkbM15JLdu3O+bToQBX7HwM46++QEcvORw5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJRaX8QJ6CfIArrfAT8fawR+I0IkpL+GP457r7qeaK+9HtajJ341jBI01n9HAsDk+
         JwEm9wwtEzE3OSj8F1DkvnP9znE8jadUg/vpd/BYstzVbGfhgQBTF2iB+Np4VV8w3+
         psZZRZtEArUgSJKJBmWKrdSm8dBDDuOsH5S3v/os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 424/862] arm64: dts: renesas: r9a07g043: Fix SCI{Rx,Tx} interrupt types
Date:   Wed, 19 Oct 2022 10:28:31 +0200
Message-Id: <20221019083308.693908158@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 40201a16d653..af84d4797972 100644
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



