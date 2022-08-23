Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B883459D7FB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243572AbiHWJlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344258AbiHWJkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA22E78BFA;
        Tue, 23 Aug 2022 01:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 782426155E;
        Tue, 23 Aug 2022 08:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774D6C433D7;
        Tue, 23 Aug 2022 08:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244026;
        bh=N1qxb1d5A0ahyPnmnnSrdHQ4ijl9mV+imj7CvZo3YMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKcjXJceHAGcpx7xyiUDOJjsk83FOzQTvrzUF9ib/ge9BjitUFbVb5TidB+hZ7Jam
         5CTJy8B72QIaKrzQjliEPG9XsSSYMoxUkHzhq4ohjzUnD2py2iXK8ed9I8XJscw5dM
         sy4yz5L/JgWg9BfSKBhe++nRtvseP6pGKP6146Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.15 026/244] dt-bindings: usb: mtk-xhci: Allow wakeup interrupt-names to be optional
Date:   Tue, 23 Aug 2022 10:23:05 +0200
Message-Id: <20220823080059.925877376@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit b2c510ffe29f20a5f6ff31ae28d32ffa494b8cfb upstream.

Add missing "minItems: 1" to the interrupt-names property to allow the
second interrupt-names, "wakeup", to be optional.

Fixes: fe8e488058c4 ("dt-bindings: usb: mtk-xhci: add wakeup interrupt")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20220623193702.817996-2-nfraprado@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
+++ b/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
@@ -56,6 +56,7 @@ properties:
       - description: optional, wakeup interrupt used to support runtime PM
 
   interrupt-names:
+    minItems: 1
     items:
       - const: host
       - const: wakeup


