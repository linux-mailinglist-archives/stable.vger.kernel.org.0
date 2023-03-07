Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C57C6AE88E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjCGRRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjCGRQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8940A9C9A2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A16F61507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CF6C433D2;
        Tue,  7 Mar 2023 17:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209141;
        bh=dcd1Fg7XxtMMgTmRmH/HqoWFp7pfGZM91tV0ZKayNEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jx5iyAjQKm5rYEDq2XGXF220GzpNJyyah2Jfo8q/t1/neWmzXZaVH1qaeIIFtrwfe
         1ww0eIhZCaTCcHPZ3poRat/fSrAMTv83dYtFc5DG5Jm/gyWIN81Evb9n7O73hpw4/B
         pS575jrVdP6Q/+h+PN3k5IlHBxTzcinZ1z82hOH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0094/1001] ARM: dts: imx7s: correct iomuxc gpr mux controller cells
Date:   Tue,  7 Mar 2023 17:47:46 +0100
Message-Id: <20230307170026.251822369@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 0e3e1946606a2919b1dda9967ab2e1c5af2fedd6 ]

Per binding doc reg-mux.yaml, the #mux-control-cells should be 1

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Fixes: 94a905a79f2c ("ARM: dts: imx7s: add multiplexer controls")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 0fc9e6b8b05dc..11b9321badc51 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -513,7 +513,7 @@ gpr: iomuxc-gpr@30340000 {
 
 				mux: mux-controller {
 					compatible = "mmio-mux";
-					#mux-control-cells = <0>;
+					#mux-control-cells = <1>;
 					mux-reg-masks = <0x14 0x00000010>;
 				};
 
-- 
2.39.2



