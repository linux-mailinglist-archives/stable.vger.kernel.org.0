Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D2059D669
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbiHWJIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347950AbiHWJHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5BC8606E;
        Tue, 23 Aug 2022 01:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0426614BC;
        Tue, 23 Aug 2022 08:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FFEC433C1;
        Tue, 23 Aug 2022 08:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243404;
        bh=tOxOsK6iWiCcwAk/an/4W+NYxsrfjp2xKkg+Fes1HWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2YNm4UZCBfTZmyu82jivPXApSFFjXCOzlcv8LP0nDC22XH+EOAi2JxKi7HdebtWx
         JLyY+x4cHwBNWBl+UrUVCq0vJTnWn2rYI0O1KFnXuDXo9cw4RDVPB/OlXE49W6DMCA
         NMzyuwORV5iBk/XZsHm4dfocaUK+K8019/6XasME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.19 236/365] dt-bindings: display: sun4i: Add D1 TCONs to conditionals
Date:   Tue, 23 Aug 2022 10:02:17 +0200
Message-Id: <20220823080128.110651267@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

commit 2a29f80e155a9cf40ca8b6648bcdc8422db4c4e4 upstream.

When adding the D1 TCON bindings, I missed the conditional blocks that
restrict the binding for TCON LCD vs TCON TV hardware. Add the D1 TCON
variants to the appropriate blocks for DE2 TCON LCDs and TCON TVs.

Fixes: ae5a5d26c15c ("dt-bindings: display: Add D1 display engine compatibles")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220812073702.57618-1-samuel@sholland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
index 4a92a4c7dcd7..f8168986a0a9 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
@@ -233,6 +233,7 @@ allOf:
               - allwinner,sun8i-a83t-tcon-lcd
               - allwinner,sun8i-v3s-tcon
               - allwinner,sun9i-a80-tcon-lcd
+              - allwinner,sun20i-d1-tcon-lcd
 
     then:
       properties:
@@ -252,6 +253,7 @@ allOf:
               - allwinner,sun8i-a83t-tcon-tv
               - allwinner,sun8i-r40-tcon-tv
               - allwinner,sun9i-a80-tcon-tv
+              - allwinner,sun20i-d1-tcon-tv
 
     then:
       properties:
@@ -278,6 +280,7 @@ allOf:
               - allwinner,sun9i-a80-tcon-lcd
               - allwinner,sun4i-a10-tcon
               - allwinner,sun8i-a83t-tcon-lcd
+              - allwinner,sun20i-d1-tcon-lcd
 
     then:
       required:
@@ -294,6 +297,7 @@ allOf:
               - allwinner,sun8i-a23-tcon
               - allwinner,sun8i-a33-tcon
               - allwinner,sun8i-a83t-tcon-lcd
+              - allwinner,sun20i-d1-tcon-lcd
 
     then:
       properties:
-- 
2.37.2



