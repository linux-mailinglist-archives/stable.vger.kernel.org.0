Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6215A680F82
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbjA3Ny3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbjA3NyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E49E36FE9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2419861028
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265CFC4339B;
        Mon, 30 Jan 2023 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086851;
        bh=hKJmJhD1xtAkPmNDmMbLjXX3s1IvUv4E/amn+7+KCHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqT3nj33oClTzSSc5Ov45UYnp2rGkYagHCvymXcTbh4tDDjFoVJ7KOX8tce11GGi5
         WTluVMZ2m0VuwKQiRlFM1lp1JydsWIRLcg6gHJraYUWPJ2p/38oNlVbnkAaRWQHysO
         C23nSOGV26pp3q7ShFT3v3m41RYekQ/vOzF2KnRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adam Ford <aford173@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/313] arm64: dts: imx8mp: Fix power-domain typo
Date:   Mon, 30 Jan 2023 14:47:34 +0100
Message-Id: <20230130134337.549255520@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 10e2f328bd900787fd2db24e474f87e1d525ccc4 ]

dt_binding_check detects an issue with the pgc_hsiomix power
domain:
  pgc: 'power-domains@17' does not match any of the regexes

This is because 'power-domains' should be 'power-domain'

Fixes: 2ae42e0c0b67 ("arm64: dts: imx8mp: add HSIO power-domains")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 4d06bb707a02..47fd6a0ba05a 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -590,7 +590,7 @@ pgc_mipi_phy2: power-domain@16 {
 						reg = <IMX8MP_POWER_DOMAIN_MIPI_PHY2>;
 					};
 
-					pgc_hsiomix: power-domains@17 {
+					pgc_hsiomix: power-domain@17 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MP_POWER_DOMAIN_HSIOMIX>;
 						clocks = <&clk IMX8MP_CLK_HSIO_AXI>,
-- 
2.39.0



