Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EAC59D90D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242059AbiHWJuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245098AbiHWJsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A489D13B;
        Tue, 23 Aug 2022 01:44:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4785E61552;
        Tue, 23 Aug 2022 08:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE7BC433C1;
        Tue, 23 Aug 2022 08:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244249;
        bh=5EGipDdU2+zRIeFDfIZ3UOF/XCO12wJYUgIqgofijBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+5UFNh14iFWDfja3nvSvOGTL0tzB482ScAnMABce3ptdL+nl69Xqx4tpRUfHnQ/F
         GrusGt4rQmlajoDgL8hSqxeCoB5lzQRtmf40El/9xDmWa8ic/aVuSAHpPmt7zafHXt
         FaPhhTLRkqBoYHpl7zUic+xtQLgE8Jb5yisuEUjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 062/244] dt-bindings: arm: qcom: fix Alcatel OneTouch Idol 3 compatibles
Date:   Tue, 23 Aug 2022 10:23:41 +0200
Message-Id: <20220823080101.154720859@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -135,14 +135,13 @@ properties:
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


