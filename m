Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A4653189E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbiEWRaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242289AbiEWR1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F4F7CB06;
        Mon, 23 May 2022 10:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AECDB811FF;
        Mon, 23 May 2022 17:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1DEC385A9;
        Mon, 23 May 2022 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326571;
        bh=IoJRm/i4IXJI9no6CdAXI1whNbfhbv4o8gGiDQE+UGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqileH+NIjjQ61Y/7U6SpKKmRtCZ74T5WC84TjyTjWXmygepIGOZ6BQ8JAA8EHgUJ
         KeS6/S8lW3yWHi+YrnfliIqcrrpQdrzAq0EHVLJ2hOm4MmghxY6lcYeQgwwx3TyeDh
         rH8pPT5qa+tkQ0nGjWVpZA8EirEsWKa1Y/ERr9Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/132] riscv: dts: sifive: fu540-c000: align dma node name with dtschema
Date:   Mon, 23 May 2022 19:05:14 +0200
Message-Id: <20220523165840.886090758@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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
index 7db861053483..64c06c9b41dc 100644
--- a/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu540-c000.dtsi
@@ -166,7 +166,7 @@ uart0: serial@10010000 {
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



