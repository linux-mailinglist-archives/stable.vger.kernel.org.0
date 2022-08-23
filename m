Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A21359D991
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243718AbiHWJ6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351975AbiHWJ4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A92A0259;
        Tue, 23 Aug 2022 01:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90D3C61499;
        Tue, 23 Aug 2022 08:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9332AC433C1;
        Tue, 23 Aug 2022 08:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244427;
        bh=WK+iLOfAkg4qoR51CflwzR1X5RRiADyEICS3AZD9u4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9RfKtw9As3/wVpeHRhrNoBvdhzldtWe2yTKzsVOoUXmfk/KLXtFTmjj1JlMxqFgQ
         G+pFwKzi68XU3JgtuKs6qVFBSMkiqjpquzDn8RmY8+7+iWXl0i+ZJg5e8bbKlObgTc
         AtMHUqO3Fyj3DWx0gShvqOnnBYkCT9P5ySrNPMxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 083/244] dt-bindings: arm: qcom: fix Longcheer L8150 compatibles
Date:   Tue, 23 Aug 2022 10:24:02 +0200
Message-Id: <20220823080101.814727880@linuxfoundation.org>
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

commit 25d203d0751ca191301bc578ba5d59fa401f1fbf upstream.

The MSM8916 Longcheer L8150 uses a fallback in compatible:

  msm8916-longcheer-l8150.dtb: /: compatible: 'oneOf' conditional failed, one must be fixed:
    ['longcheer,l8150', 'qcom,msm8916-v1-qrd/9-v1', 'qcom,msm8916'] is too long

Fixes: b72160fa886d ("dt-bindings: qcom: Document bindings for new MSM8916 devices")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20220520123252.365762-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom.yaml |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -142,12 +142,16 @@ properties:
       - items:
           - enum:
               - alcatel,idol347
-              - longcheer,l8150
               - samsung,a3u-eur
               - samsung,a5u-eur
           - const: qcom,msm8916
 
       - items:
+          - const: longcheer,l8150
+          - const: qcom,msm8916-v1-qrd/9-v1
+          - const: qcom,msm8916
+
+      - items:
           - enum:
               - sony,karin_windy
               - sony,karin-row


