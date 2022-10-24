Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BF260A49B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiJXMNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbiJXMMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:12:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04C3167F1;
        Mon, 24 Oct 2022 04:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BEF2612A5;
        Mon, 24 Oct 2022 11:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00CAC433C1;
        Mon, 24 Oct 2022 11:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612418;
        bh=G2Iq+E2IQldK7wPBaBskETo3Zul+M0o1nQ7kNdoncQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmlEc0rVutsK+K5vqSHdKlWO60LuFJtAcL+Fzw4BGZKC172tgUI5mWChJh6hHCa3S
         R3nnZKE6rdHji/jgBOYPC2nS5xQ2hPYEdzlsT7Umlcqlv23wLdi0xgBiyad1BTrAed
         NwCUKoTFtxdBkOB/8SWc+ZVJ3X3hCWSDY2MzS+K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 190/210] ARM: dts: imx6q: add missing properties for sram
Date:   Mon, 24 Oct 2022 13:31:47 +0200
Message-Id: <20221024113003.119860896@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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

[ Upstream commit b11d083c5dcec7c42fe982c854706d404ddd3a5f ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 4747ede61acd..7b335e8050d3 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -82,6 +82,9 @@
 		ocram: sram@00900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x40000>;
+			ranges = <0 0x00900000 0x40000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1



