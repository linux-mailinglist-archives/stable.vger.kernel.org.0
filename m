Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287C659E120
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358253AbiHWLwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358766AbiHWLuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:50:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8940FD31C3;
        Tue, 23 Aug 2022 02:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81EB861335;
        Tue, 23 Aug 2022 09:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76558C433C1;
        Tue, 23 Aug 2022 09:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247108;
        bh=QpaOQGnPyiaqjTcP0TWmOZuX9U8CU0Dku+XEIud8RJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+RTdvemnDWuSlAOjag8RN2975nzdcZbZl9FQP4sTCQ4I/FniBni/eBUl5HXnj/RD
         o1V+4nwk9NogXREJcx4tIv8rzlQoHEggpL4VU+byuUv9ZRxefk2uIeStNuzH8l6Wun
         5Eg2tEhWJDqs7gxz2JsOUxv3AiHlG9FIBzFiUT9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.4 320/389] dt-bindings: arm: qcom: fix MSM8916 MTP compatibles
Date:   Tue, 23 Aug 2022 10:26:38 +0200
Message-Id: <20220823080128.914246920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

commit bb35fe1efbae4114bd288fae0f56070f563adcfc upstream.

The order of compatibles for MSM8916 MTP board is different:

  msm8916-mtp.dtb: /: compatible: 'oneOf' conditional failed, one must be fixed:
    ['qcom,msm8916-mtp', 'qcom,msm8916-mtp/1', 'qcom,msm8916'] is too long

Fixes: 9d3ef77fe568 ("dt-bindings: arm: Convert QCom board/soc bindings to json-schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220520123252.365762-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -112,8 +112,8 @@ properties:
           - const: qcom,msm8974
 
       - items:
-          - const: qcom,msm8916-mtp/1
           - const: qcom,msm8916-mtp
+          - const: qcom,msm8916-mtp/1
           - const: qcom,msm8916
 
       - items:


