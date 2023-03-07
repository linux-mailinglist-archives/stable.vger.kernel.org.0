Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FFB6AF312
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjCGTAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCGS7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A883B78BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:46:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3D306150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1569EC433D2;
        Tue,  7 Mar 2023 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214757;
        bh=iYharW0ASddqdQWwFA+V9ThNp6RTq0N+JARnjoTT4L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1AGznILtvvOQwKzzAZGCaHSP5m9XPJ3bF/urtR8twOE6uG/BmFlqvfdWbiBAH+0z
         c1ExzDQTgSZqt/QtbhCPmWVMffEWz8+cdcpCyZosXtDuqXHUSh4l1CsuvWfBXcRfSR
         mrWMN8+cOBvPN4ww/4ka64bgREGnz67YtXFhqxY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/567] arm64: dts: amlogic: meson-gx: add missing unit address to rng node name
Date:   Tue,  7 Mar 2023 17:56:15 +0100
Message-Id: <20230307165907.629148011@linuxfoundation.org>
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
index 31bbfe4868d8e..32cc9fab4490f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -531,7 +531,7 @@ periphs: bus@c8834000 {
 			#size-cells = <2>;
 			ranges = <0x0 0x0 0x0 0xc8834000 0x0 0x2000>;
 
-			hwrng: rng {
+			hwrng: rng@0 {
 				compatible = "amlogic,meson-rng";
 				reg = <0x0 0x0 0x0 0x4>;
 			};
-- 
2.39.2



