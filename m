Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8636259D405
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbiHWISm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243103AbiHWIQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE067646;
        Tue, 23 Aug 2022 01:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3F4D6122D;
        Tue, 23 Aug 2022 08:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87CCC433D7;
        Tue, 23 Aug 2022 08:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242294;
        bh=2QoUdqntMSIGnko29k9Mv6PoCJqWaulAFQaGzvw9jnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEQVks5yqmddpmlXf7olCrwSxbd9q2j10MEzhXJPQZ8XEkOcQx7p9RL6E4dAGTY0l
         AAasiPqiDSqIq2l5YsLT1LPFun5/uCPInhGpPvBs41Pksdmnc38+xjL9Xrli/4FVq4
         QMnzytdPWdYgkdQg4Tn5MQv9jedTvGW2Ip3c1Pqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.19 089/365] dt-bindings: arm: qcom: fix Alcatel OneTouch Idol 3 compatibles
Date:   Tue, 23 Aug 2022 09:59:50 +0200
Message-Id: <20220823080121.917673113@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 944de5182f0269e72ffe0a8880c8dbeb30f473d8 upstream.

The MSM8916 Alcatel OneTouch Idol 3 does not use MTP fallbacks in
compatibles:

  msm8916-alcatel-idol347.dtb: /: compatible: 'oneOf' conditional failed, one must be fixed:
    ['alcatel,idol347', 'qcom,msm8916'] is too short

Reported-by: Rob Herring <robh@kernel.org>
Fixes: e9dd2f7204ed ("dt-bindings: arm: qcom: Document alcatel,idol347 board")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20220520123252.365762-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom.yaml |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -153,14 +153,13 @@ properties:
           - const: qcom,msm8974
 
       - items:
-          - enum:
-              - alcatel,idol347
           - const: qcom,msm8916-mtp/1
           - const: qcom,msm8916-mtp
           - const: qcom,msm8916
 
       - items:
           - enum:
+              - alcatel,idol347
               - longcheer,l8150
               - samsung,a3u-eur
               - samsung,a5u-eur


