Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB72250517C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbiDRMfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239770AbiDRMdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08AD1AD84;
        Mon, 18 Apr 2022 05:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CABD60FD6;
        Mon, 18 Apr 2022 12:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B137C385A1;
        Mon, 18 Apr 2022 12:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284748;
        bh=Dv2nQtKpFMGTkvbRsuyUoVMA9sqeh/9RZyJAAnVcAPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zj/ewMzwCa4mCuo7R/8WGVvpq3YRLQh+TxflIyvj200wTQvdKbIQ/wPqyZlbrK0Gl
         Giz3k8/CT579Qkvo9iZrIZ6Wu/95/2RtfcnDJ9dfpAJ4oserbZtG/t7Plznz2qAZo2
         b4gOe82HAajQp6DFbxTEwkOKMFn1MZav5rY+UFTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongjin Yang <dj76.yang@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.17 213/219] dt-bindings: net: snps: remove duplicate name
Date:   Mon, 18 Apr 2022 14:13:02 +0200
Message-Id: <20220418121212.829261350@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongjin Yang <dj76.yang@samsung.com>

commit ce8b3ad1071b764e963d9b08ac34ffddddf12da6 upstream.

snps,dwmac has duplicated name for loongson,ls2k-dwmac and
loongson,ls7a-dwmac.

Signed-off-by: Dongjin Yang <dj76.yang@samsung.com>
Fixes: 68277749a013 ("dt-bindings: dwmac: Add bindings for new Loongson SoC and bridge chip")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -53,20 +53,18 @@ properties:
         - allwinner,sun8i-r40-gmac
         - allwinner,sun8i-v3s-emac
         - allwinner,sun50i-a64-emac
-        - loongson,ls2k-dwmac
-        - loongson,ls7a-dwmac
         - amlogic,meson6-dwmac
         - amlogic,meson8b-dwmac
         - amlogic,meson8m2-dwmac
         - amlogic,meson-gxbb-dwmac
         - amlogic,meson-axg-dwmac
-        - loongson,ls2k-dwmac
-        - loongson,ls7a-dwmac
         - ingenic,jz4775-mac
         - ingenic,x1000-mac
         - ingenic,x1600-mac
         - ingenic,x1830-mac
         - ingenic,x2000-mac
+        - loongson,ls2k-dwmac
+        - loongson,ls7a-dwmac
         - rockchip,px30-gmac
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac


