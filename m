Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F18B6AF518
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCGTWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbjCGTVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:21:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818C1BF8FE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E1C96152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169FAC433EF;
        Tue,  7 Mar 2023 19:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215999;
        bh=EqPvwCpfLxqn8WfVFVduOkeI7AUGN58iR0FX4sEGzJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFCni0hHru7XQ8Vaien0vLHTUXyLmMonbcSxFk4rnW4HEC4cAKn1mcSFWU3119j15
         iGjt7KWEcCDBYaTIiDFqm0XNBajcHzWDNIz1RtHT98kHGJawa+dRQhsDzIAsvszo12
         vwx8TDjFprhLQR82LdNqIbgLDH2+zUDDTMDWj5mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 443/567] ARM: dts: exynos: correct HDMI phy compatible in Exynos4
Date:   Tue,  7 Mar 2023 18:02:59 +0100
Message-Id: <20230307165925.102530184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit af1c89ddb74f170eccd5a57001d7317560b638ea upstream.

The HDMI phy compatible was missing vendor prefix.

Fixes: ed80d4cab772 ("ARM: dts: add hdmi related nodes for exynos4 SoCs")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230125094513.155063-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos4.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -605,7 +605,7 @@
 			status = "disabled";
 
 			hdmi_i2c_phy: hdmiphy@38 {
-				compatible = "exynos4210-hdmiphy";
+				compatible = "samsung,exynos4210-hdmiphy";
 				reg = <0x38>;
 			};
 		};


