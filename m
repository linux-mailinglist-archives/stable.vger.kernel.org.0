Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768FB6AF314
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjCGTAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjCGS7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:59:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78445B8623
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:46:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3764CE1C6A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36BBC433D2;
        Tue,  7 Mar 2023 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214760;
        bh=YTB2LrvUsAhC339pGmRR9hznggeunOXw8XVe3qIxNVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w20AjK6PbK9U+gsGSeAFDYIf5QKtuabvnSxjya1N7mIyNVdtxg3eyKGHOQT2Y4LPb
         QFCdybYyyEhTMUWXOOSmDurF9TJuietDV+SVPII4zByVsLvc2CKc0gZf5dIjVSoqYo
         z6vJDvaa7SuflqhhLk70vBKyXR4qo2jB+aI1OVKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/567] arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name
Date:   Tue,  7 Mar 2023 17:56:16 +0100
Message-Id: <20230307165907.669183827@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit d19189f70ba596798ea49166d2d1ef36a8df5289 ]

Fixes:
bus@c8834000: eth-phy-mux: {...} should not be valid under {'type': 'object'}

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-9-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index c3ac531c4f84a..3500229350522 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -759,7 +759,7 @@ mux {
 		};
 	};
 
-	eth-phy-mux {
+	eth-phy-mux@55c {
 		compatible = "mdio-mux-mmioreg", "mdio-mux";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.2



