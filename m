Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1465820A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiL1Qc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiL1Qc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AF8192A9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6810B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E178C433D2;
        Wed, 28 Dec 2022 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244959;
        bh=dRCMaNydInFQ/tG2XTzF+1HqvwiZ6fy+vxvxIUa9J6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVEo7OTFjVgk7GAcdpXzkk/WACmePulQ1TsLqqsOf/yLzXI3Rlm483SgoYtdUDYa5
         VjYmpc8JFw/wBMuDRYAxXbjWiZGB26q7A+0yocsNfcJZoCqxrKijzIGHQv5nhWZhFj
         1RMtu2RKAdE8wtVA8gkLU9JrrS3DsWfJjf8eFjiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0806/1073] powerpc: dts: turris1x.dts: Add channel labels for temperature sensor
Date:   Wed, 28 Dec 2022 15:39:54 +0100
Message-Id: <20221228144349.901420480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 67bbb62f61e810734da0a1577a9802ddaed24140 ]

Channel 0 of SA56004ED chip refers to internal SA56004ED chip sensor (chip
itself is located on the board) and channel 1 of SA56004ED chip refers to
external sensor which is connected to temperature diode of the P2020 CPU.

Fixes: 54c15ec3b738 ("powerpc: dts: Add DTS file for CZ.NIC Turris 1.x routers")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220930123901.10251-1-pali@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/turris1x.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/powerpc/boot/dts/turris1x.dts b/arch/powerpc/boot/dts/turris1x.dts
index 045af668e928..e9cda34a140e 100644
--- a/arch/powerpc/boot/dts/turris1x.dts
+++ b/arch/powerpc/boot/dts/turris1x.dts
@@ -69,6 +69,20 @@ temperature-sensor@4c {
 				interrupt-parent = <&gpio>;
 				interrupts = <12 IRQ_TYPE_LEVEL_LOW>, /* GPIO12 - ALERT pin */
 					     <13 IRQ_TYPE_LEVEL_LOW>; /* GPIO13 - CRIT pin */
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				/* Local temperature sensor (SA56004ED internal) */
+				channel@0 {
+					reg = <0>;
+					label = "board";
+				};
+
+				/* Remote temperature sensor (D+/D- connected to P2020 CPU Temperature Diode) */
+				channel@1 {
+					reg = <1>;
+					label = "cpu";
+				};
 			};
 
 			/* DDR3 SPD/EEPROM */
-- 
2.35.1



