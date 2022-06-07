Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4780E540CC7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352521AbiFGSjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352519AbiFGSiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:38:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C35544A07;
        Tue,  7 Jun 2022 10:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91067CE2422;
        Tue,  7 Jun 2022 17:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B7CC34115;
        Tue,  7 Jun 2022 17:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624689;
        bh=x0P5R9GI1l+hP0SWBjuJVpRkgRW3S32aI4BdkUQLV44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2TPTdgEy+BgR2p/u+uVfb9YO7QNcBWlzMxH5tR7jNQJhYZWDGhfu9eVEi0rupJe7
         qnwr6eEkh20L4CatRyxVw3PNlMq0pNYUPCmQXd6zQVbQdDyN+PcxF8+vbFpZCXXkY8
         AgK88ko/I8d7HILSnQvaIZV5CrzxVBFGGR7CHDtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/667] arm64: dts: qcom: qrb5165-rb5: Fix can-clock node name
Date:   Tue,  7 Jun 2022 19:01:23 +0200
Message-Id: <20220607164947.272178430@linuxfoundation.org>
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

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 1eae95fb1d696968ca72be3ac8e0d62bb4d8da42 ]

Per DT spec node names should not have underscores (_) in them, so
change can_clock to can-clock.

Fixes: 5c44c564e449 ("arm64: dts: qcom: qrb5165-rb5: Add support for MCP2518FD")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220421073502.1824089-1-vkoul@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index 28d5b5528516..0ce2d36ab257 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -27,7 +27,7 @@
 	};
 
 	/* Fixed crystal oscillator dedicated to MCP2518FD */
-	clk40M: can_clock {
+	clk40M: can-clock {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <40000000>;
-- 
2.35.1



