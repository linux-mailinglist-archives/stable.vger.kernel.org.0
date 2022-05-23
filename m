Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9F4531B13
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbiEWRyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244836AbiEWRwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DA373552;
        Mon, 23 May 2022 10:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC6AEB811A1;
        Mon, 23 May 2022 17:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AB5C385A9;
        Mon, 23 May 2022 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326991;
        bh=Kbw3Xnbq7oGP6QE0nQJ/oVo/wLpyBdbsLPrTHZNtse0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffzRN2h4BW52jvgtSJf212PAk9s/9hP51zSwecS+jFWAgBUTK62Q7PnDpAPx388HJ
         hNVB97l1OxOF9+KI5GcNXJqoBCyL9c67P4aJhZ/WPn0Wx6GgBVJQuUF/YisjkDqLzQ
         G60mvOcQqiHiVkNsLG+kM+ScG3ClJLWmh2s2LsKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 122/158] riscv: dts: sifive: fu540-c000: align dma node name with dtschema
Date:   Mon, 23 May 2022 19:04:39 +0200
Message-Id: <20220523165850.970191315@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit b17410182b6f98191fbf7f42d3b4a78512769d29 ]

Fixes dtbs_check warnings like:

  dma@3000000: $nodename:0: 'dma@3000000' does not match '^dma-controller(@.*)?$'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20220407193856.18223-1-krzysztof.kozlowski@linaro.org
Fixes: c5ab54e9945b ("riscv: dts: add support for PDMA device of HiFive Unleashed Rev A00")
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/fu540-c000.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
index 3eef52b1a59b..fd93fdadd28c 100644
--- a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
@@ -167,7 +167,7 @@ uart0: serial@10010000 {
 			clocks = <&prci PRCI_CLK_TLCLK>;
 			status = "disabled";
 		};
-		dma: dma@3000000 {
+		dma: dma-controller@3000000 {
 			compatible = "sifive,fu540-c000-pdma";
 			reg = <0x0 0x3000000 0x0 0x8000>;
 			interrupt-parent = <&plic0>;
-- 
2.35.1



