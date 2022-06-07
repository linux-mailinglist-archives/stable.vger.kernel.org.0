Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E1C540919
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349903AbiFGSFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351844AbiFGSCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E03E158947;
        Tue,  7 Jun 2022 10:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC7B1616A3;
        Tue,  7 Jun 2022 17:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F00C385A5;
        Tue,  7 Jun 2022 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623949;
        bh=VfEohdirGWqMYKm8EJN/0nGqKpK6fovf6VVJ591kVQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nU3i5RvLQ92im26j39nJ0YdIAUN8lpWMuxsDEv+ToutVEEEybffYs5+uoZcHWqeve
         Mkh47NbDDnZsJLf4/dTXbFrQiGQTGiIxU3xmLNNQ7K8/D2uBI4Hh7lC1X47ARJDPXp
         N7rpoxhWeotwO5v+cpcPV1o860JbE05H9BNhBx2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/667] ARM: dts: socfpga: align interrupt controller node name with dtschema
Date:   Tue,  7 Jun 2022 18:56:55 +0200
Message-Id: <20220607164939.317271683@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c9bdd50d2019f78bf4c1f6a79254c27771901023 ]

Fixes dtbs_check warnings like:

  $nodename:0: 'intc@fffed000' does not match '^interrupt-controller(@[0-9a-f,]+)*$'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20220317115705.450427-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/socfpga.dtsi         | 2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 7c1d6423d7f8..b8c5dd7860cb 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -46,7 +46,7 @@
 		      <0xff113000 0x1000>;
 	};
 
-	intc: intc@fffed000 {
+	intc: interrupt-controller@fffed000 {
 		compatible = "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
 		interrupt-controller;
diff --git a/arch/arm/boot/dts/socfpga_arria10.dtsi b/arch/arm/boot/dts/socfpga_arria10.dtsi
index 3ba431dfa8c9..f1e50d2e623a 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -38,7 +38,7 @@
 		      <0xff113000 0x1000>;
 	};
 
-	intc: intc@ffffd000 {
+	intc: interrupt-controller@ffffd000 {
 		compatible = "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
 		interrupt-controller;
-- 
2.35.1



