Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C675943F9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350663AbiHOWkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351357AbiHOWiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C207C13263D;
        Mon, 15 Aug 2022 12:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F7C161226;
        Mon, 15 Aug 2022 19:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15834C433D6;
        Mon, 15 Aug 2022 19:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593068;
        bh=CYfpdsBOQFEtHaNixnCNJV84+HqfaVHx/0xGYqIT8yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kf41yPlfHaA+TCQ/ZPBfqueWsi4dbbqj1XVwkb9ZyQr7TANJBeUzao4MAmACUY7Uq
         FKgui8+wRg42zLrWuyVgaXvdCNaz6xd23o8AhWOJy3/B0p6O+MHmD4xtM/75WGl4hM
         MPye+C8K16exHEypJotmU0KOIIta5KunNTT/vN7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0208/1157] ARM: dts: imx7-colibri-eval-v3: correct can controller comment
Date:   Mon, 15 Aug 2022 19:52:44 +0200
Message-Id: <20220815180447.954682277@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 32f054fef145878c5331f9dd343014970a15ebfa ]

Correct CAN controller comment. It is a MCP2515 rather than a mpc258x.

Fixes: 66d59b678a87 ("ARM: dts: imx7-colibri: add MCP2515 CAN controller")
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
index 4cf4107fb642..b5f632921df2 100644
--- a/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/imx7-colibri-eval-v3.dtsi
@@ -4,7 +4,7 @@
  */
 
 / {
-	/* fixed crystal dedicated to mpc258x */
+	/* Fixed crystal dedicated to MCP2515. */
 	clk16m: clk16m {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
-- 
2.35.1



