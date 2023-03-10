Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E996B4395
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjCJOP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjCJOP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:15:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C435245
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:14:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC4E6B822B5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E8FC433EF;
        Fri, 10 Mar 2023 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457662;
        bh=pi3oEtwKoyYCNDtvZHQajuMeIxgrgfJLtWsgEqMdfGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbTIRBHt55Sg5ZKXKE2MAi3FOXw81w19BB+F3e6oSJiH93+108zZmQHPu+Xcx3kCB
         PiOAwoREbUbXlyI3mtt0g1UXFzfCbutaiqlrG3iijej2pmyQ0Ej6nBvgouxe3sbs8a
         h8TIN0iU7urdCW2sjuKHnmpdEx/egF+XmLF5msNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/252] arm64: dts: amlogic: meson-gx: add missing unit address to rng node name
Date:   Fri, 10 Mar 2023 14:36:25 +0100
Message-Id: <20230310133719.289985751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

[ Upstream commit 61ff70708b98a85516eccb3755084ac97b42cf48 ]

Fixes:
bus@c8834000: rng: {...} should not be valid under {'type': 'object'}

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-6-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 85e69bfd21744..c167023ca1db7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -423,7 +423,7 @@ periphs: periphs@c8834000 {
 			#size-cells = <2>;
 			ranges = <0x0 0x0 0x0 0xc8834000 0x0 0x2000>;
 
-			hwrng: rng {
+			hwrng: rng@0 {
 				compatible = "amlogic,meson-rng";
 				reg = <0x0 0x0 0x0 0x4>;
 			};
-- 
2.39.2



