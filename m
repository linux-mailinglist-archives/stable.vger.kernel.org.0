Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585434EF4D8
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237589AbiDAOxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351061AbiDAOsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:48:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A46E5B3C8;
        Fri,  1 Apr 2022 07:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F38B82505;
        Fri,  1 Apr 2022 14:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34A3C34112;
        Fri,  1 Apr 2022 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823906;
        bh=b51VNEiKO+Fx8+RwLfJTXx0nWoth9Ssof+K5dUkMstw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqoooJMbDn3u1DY3Zyo5MawmssEG6IaCpT+vpAbb1Ua5SsT6KM6qd4U6CCS2sj4+g
         9zcZuwk7aJPosdtmrAhHMIEh08PwfBy9OxC75t6jRCkViQ27Gi9WZ0xh6YAS4rvEm9
         6EHn9Bw9uEIctqDWcLOPpuSgWS/r4FTmiHpX2jszTph2NSITMtCRBg2v2RFwlW+Qwf
         ICRkgiM31ro/xecRB65rkRlBQBuTjzN/mYpAzq/swf3lQsfFDW102wJJmJFtzY16hl
         BgehL7UgW1kcnh3a2eBp/NZJlIjICCsjjkeT0EdkXXncq8DYV8OTpgwslVlENu+eOV
         uOhSWu9XNAElQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzk+dt@kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 12/98] powerpc: dts: t104xrdb: fix phy type for FMAN 4/5
Date:   Fri,  1 Apr 2022 10:36:16 -0400
Message-Id: <20220401143742.1952163-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Maxim Kiselev <bigunclemax@gmail.com>

[ Upstream commit 17846485dff91acce1ad47b508b633dffc32e838 ]

T1040RDB has two RTL8211E-VB phys which requires setting
of internal delays for correct work.

Changing the phy-connection-type property to `rgmii-id`
will fix this issue.

Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211230151123.1258321-1-bigunclemax@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
index 099a598c74c0..bfe1ed5be337 100644
--- a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
@@ -139,12 +139,12 @@ pca9546@77 {
 		fman@400000 {
 			ethernet@e6000 {
 				phy-handle = <&phy_rgmii_0>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			ethernet@e8000 {
 				phy-handle = <&phy_rgmii_1>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			mdio0: mdio@fc000 {
-- 
2.34.1

