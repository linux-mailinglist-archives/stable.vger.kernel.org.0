Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2144F59D9DA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350687AbiHWKDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352177AbiHWKBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9DB481EE;
        Tue, 23 Aug 2022 01:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8122ECE1B44;
        Tue, 23 Aug 2022 08:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB78C433D6;
        Tue, 23 Aug 2022 08:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244531;
        bh=/2iN9ZUAX5ag3aUD6VdxWCJF8EhmGNhcvw+NYou29Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qi0ZBr11oLzvM7WWiGI41V3a1jdXZpPEZjgJUwXUtQziRTs86rJaJZ/g6cbNGCZHu
         b/20yzdxa2LmLn2APzXlG/kmHNczrAYf3sn/usIX0+pmyldjA7jCHYqUYabU/xtsK3
         ANlrnjZHBw+L+DP9O3j1IOJbPh/rA8D+W0WlKBsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 085/244] dt-bindings: arm: qcom: fix MSM8994 boards compatibles
Date:   Tue, 23 Aug 2022 10:24:04 +0200
Message-Id: <20220823080101.874848429@linuxfoundation.org>
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

commit c704bd373f58a84193eebe40bd271d6b73c138b0 upstream.

The compatibles for APQ8094/MSM8994 boards are different than specified
in bindings.  None of them use fallback to other SoC variant.

Fixes: 9ad3c08f6f1b ("dt-bindings: arm: qcom: Document sony boards for apq8094")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220520123252.365762-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom.yaml |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -154,12 +154,15 @@ properties:
       - items:
           - enum:
               - sony,karin_windy
+          - const: qcom,apq8094
+
+      - items:
+          - enum:
               - sony,karin-row
               - sony,satsuki-row
               - sony,sumire-row
               - sony,suzuran-row
-              - qcom,msm8994
-          - const: qcom,apq8094
+          - const: qcom,msm8994
 
       - items:
           - const: qcom,msm8996-mtp


