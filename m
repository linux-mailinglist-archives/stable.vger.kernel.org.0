Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4846ECD98
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjDXNYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjDXNYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549D412E
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2AED6229D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FF5C433D2;
        Mon, 24 Apr 2023 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342682;
        bh=S9gg9G0bW1nYmWID1vHNh6W28jlxKVh0dP3uCW2laWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ6XSbCJyct5U7QJoi69x5vOQBQuqEl3LWlabwHx2g+VQlwcWI7AXu8tu4eQcRFWK
         zd9ibFBnoi+CbzT4SmB1cDIdaYW/vCcEBKwzssk8knJkyIPioi3omM7jStqux1Tjp2
         p0HZHxathPVyZbR+ZqXhQZYi57tOPEaxFtbanW/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Gonzalez <mgonzalez@freebox.fr>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/98] arm64: dts: meson-g12-common: specify full DMC range
Date:   Mon, 24 Apr 2023 15:16:29 +0200
Message-Id: <20230424131134.077680873@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit aec4353114a408b3a831a22ba34942d05943e462 ]

According to S905X2 Datasheet - Revision 07:
DRAM Memory Controller (DMC) register area spans ff638000-ff63a000.

According to DeviceTree Specification - Release v0.4-rc1:
simple-bus nodes do not require reg property.

Fixes: 1499218c80c99a ("arm64: dts: move common G12A & G12B modes to meson-g12-common.dtsi")
Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230327120932.2158389-2-mgonzalez@freebox.fr
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 131a8a5a9f5a0..88b848c65b0d2 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1571,10 +1571,9 @@
 
 			dmc: bus@38000 {
 				compatible = "simple-bus";
-				reg = <0x0 0x38000 0x0 0x400>;
 				#address-cells = <2>;
 				#size-cells = <2>;
-				ranges = <0x0 0x0 0x0 0x38000 0x0 0x400>;
+				ranges = <0x0 0x0 0x0 0x38000 0x0 0x2000>;
 
 				canvas: video-lut@48 {
 					compatible = "amlogic,canvas";
-- 
2.39.2



