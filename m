Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660CD60B29F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiJXQuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbiJXQsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:48:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669AB1A224;
        Mon, 24 Oct 2022 08:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA623B81A01;
        Mon, 24 Oct 2022 12:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E51AC433D7;
        Mon, 24 Oct 2022 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616088;
        bh=xDZ5H2RmEQh2bUXmTz0UOznmAG4tgU7w8djHcP5pD1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1lLagUtFA7ajN/TviWmZed34x6r+kaw2anSKGxLz6OtOGQ6vG+AbjbcRLVuvkQXI
         A2UeRopc5sHLaMzu0YfcrLq7ksiuQlkUhiRcNnkRITWgzS223eBxqJMJuqH4uzEtFi
         Fl0BNUabX6Gvq0P0KJs59hs7B6g47CR+QAyUcdI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/530] ARM: dts: imx6qp: add missing properties for sram
Date:   Mon, 24 Oct 2022 13:33:30 +0200
Message-Id: <20221024113106.137489644@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 088fe5237435ee2f7ed4450519b2ef58b94c832f ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@940000: '#address-cells' is a required property
sram@940000: '#size-cells' is a required property
sram@940000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qp.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qp.dtsi b/arch/arm/boot/dts/imx6qp.dtsi
index b310f13a53f2..4d23c92aa8a6 100644
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -9,12 +9,18 @@
 		ocram2: sram@940000 {
 			compatible = "mmio-sram";
 			reg = <0x00940000 0x20000>;
+			ranges = <0 0x00940000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
 		ocram3: sram@960000 {
 			compatible = "mmio-sram";
 			reg = <0x00960000 0x20000>;
+			ranges = <0 0x00960000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1



