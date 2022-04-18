Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DDD50532D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiDRMz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240335AbiDRMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9299AE5C;
        Mon, 18 Apr 2022 05:36:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BD33B80EDB;
        Mon, 18 Apr 2022 12:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77AAC385A8;
        Mon, 18 Apr 2022 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285387;
        bh=pNqvtigH1UvR7xszdOOR5JgxaJmqI6f+QEhS7rm9qFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXizCNydTmbm7zf1XtmwQq6/3Ti75WSXh75mxKvI+n2+lvJoOXmieZ9oAXLYzo92/
         bE/xmgn8krad5iJ8jf35Rpi932a0Q794Nl4Kj6jzFmhPp9SWem11oK8Ar0m26/jPw2
         GyPMyy9yOhS6lucdZcsIHvYoYNNNw60j7kAQBLNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongjin Yang <dj76.yang@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 174/189] dt-bindings: net: snps: remove duplicate name
Date:   Mon, 18 Apr 2022 14:13:14 +0200
Message-Id: <20220418121207.801781560@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
         - allwinner,sun8i-r40-emac
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


