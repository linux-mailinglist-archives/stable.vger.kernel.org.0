Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075A6541C2D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382684AbiFGVz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383759AbiFGVxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1D2244F51;
        Tue,  7 Jun 2022 12:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE54A618EC;
        Tue,  7 Jun 2022 19:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC880C385A2;
        Tue,  7 Jun 2022 19:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629136;
        bh=AI3ZPRVKoLMW8n1kDaiCEYvP2yicAHgSGb0ItYrciIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Syk7hU4WugJTINhhd7BzMrzSael9AJsdof0ej3DRPel5CiEfKTaQJd9ETXHJ/S6Xg
         7goxANYlVCKVGRKDiEZ5t2u2wOEGtwc8LPaZnJ8ohEAqAnnnou/sYgx9wXYmo7xd/F
         jAiTjrMkByxPtNkinqLzRNZX4ZPc2RFUdQME+UHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 581/879] arm64: dts: qcom: qrb5165-rb5: Fix can-clock node name
Date:   Tue,  7 Jun 2022 19:01:39 +0200
Message-Id: <20220607165019.718514227@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 845eb7a6bf92..0e63f707b911 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -29,7 +29,7 @@
 	};
 
 	/* Fixed crystal oscillator dedicated to MCP2518FD */
-	clk40M: can_clock {
+	clk40M: can-clock {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <40000000>;
-- 
2.35.1



