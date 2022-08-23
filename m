Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9E59D99E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345548AbiHWJ6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352529AbiHWJ5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:57:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52B5A1A4A;
        Tue, 23 Aug 2022 01:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FBE661485;
        Tue, 23 Aug 2022 08:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80278C433C1;
        Tue, 23 Aug 2022 08:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244462;
        bh=DsVmaptLfGCsQ/cJXoqcuHsaqqRmiKwEQQuGkw90wIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOefoa2ngIuPEsywkD8Npfcmw09eyLCfgR1niNsSwYjeEN9GRfGd2ij/LvWZRpQCE
         OGhb4ymjTmDkt8VvWKtVQJmUlhhEFINzt2Ml5stnec78ln62idDkRUbC/XGnj56r7H
         J5vupMah+rCD3PbsUFzMHDHNmHvujqhPk3A+kTHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 084/244] dt-bindings: arm: qcom: fix MSM8916 MTP compatibles
Date:   Tue, 23 Aug 2022 10:24:03 +0200
Message-Id: <20220823080101.844362583@linuxfoundation.org>
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
@@ -135,8 +135,8 @@ properties:
           - const: qcom,msm8974
 
       - items:
-          - const: qcom,msm8916-mtp/1
           - const: qcom,msm8916-mtp
+          - const: qcom,msm8916-mtp/1
           - const: qcom,msm8916
 
       - items:


