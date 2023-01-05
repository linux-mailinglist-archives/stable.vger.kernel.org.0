Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B6B65EB35
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjAEM5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjAEM5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:57:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BA91CB02
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:57:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 109C1B81AD4
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A29DC433EF;
        Thu,  5 Jan 2023 12:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923434;
        bh=VSt31uJ8fmG2SieepGjj/WbpRdf5Laaeb7QjbKWb9ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3pv3VXwXDIvV0WlKRSJ5c8EfqNMpaxi/ud/cQrka/x1/Drh+MxHbyZiRDdW2W5et
         JapE241vEWXffZU5W5mF8kut/vk+GrYh69YfU6jRxdyIAF1/bpcqp32Xkk5WTSWCGH
         dnmQJtr493zl0GZZ9asFUdQE8AB8pfy+3AidGwIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 019/251] ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port
Date:   Thu,  5 Jan 2023 13:52:36 +0100
Message-Id: <20230105125335.622607549@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit dcc7d8c72b64a479b8017e4332d99179deb8802d ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 74ecaa403a74 ("ARM: dove: add PCIe controllers to SoC DT")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dove.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 11342aeccb73..278c7321b1b9 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -127,7 +127,7 @@ pcie0: pcie-port@0 {
 			pcie1: pcie-port@1 {
 				device_type = "pci";
 				status = "disabled";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x80000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				clocks = <&gate_clk 5>;
 				marvell,pcie-port = <1>;
-- 
2.35.1



