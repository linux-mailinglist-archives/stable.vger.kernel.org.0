Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE0C5EA4BC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbiIZLvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbiIZLt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:49:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DFC74DD9;
        Mon, 26 Sep 2022 03:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 089C1B802C7;
        Mon, 26 Sep 2022 10:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CB8C433B5;
        Mon, 26 Sep 2022 10:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189280;
        bh=Ct3miofx3F/zPwYmpdA0sas9EW659SuBF+YogFlBK7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlch9tFw2PBu0K9YKwXPTvoP/x8L1xQZTk613enFthi6aSNr6XDYQgCmLJnhIiOJt
         hsVoz63gHHU/DhWIpVdk1tCYk7GSxAJK+3SuzyKG6ov712KItH9XkplbLRokLwh8DW
         3pz94xwjSEdastSUsYmz7d7Y4Ihabgby1DI41+OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 102/207] arm64: dts: imx8mp-venice-gw74xx: fix port/phy validation
Date:   Mon, 26 Sep 2022 12:11:31 +0200
Message-Id: <20220926100811.157024871@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit f7fc391a5e28216150ab5390df35032309ead7e5 ]

Since commit 65ac79e18120 ("net: dsa: microchip: add the phylink
get_caps") the phy-mode must be set otherwise the switch driver will
assume "NA" mode and invalidate the port.

Fixes: 7899eb6cb15d ("arm64: dts: imx: Add i.MX8M Plus Gateworks gw7400 dts support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
index 3df7ee9a2fe1..211e6a1b296e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -483,30 +483,35 @@ ports {
 			lan1: port@0 {
 				reg = <0>;
 				label = "lan1";
+				phy-mode = "internal";
 				local-mac-address = [00 00 00 00 00 00];
 			};
 
 			lan2: port@1 {
 				reg = <1>;
 				label = "lan2";
+				phy-mode = "internal";
 				local-mac-address = [00 00 00 00 00 00];
 			};
 
 			lan3: port@2 {
 				reg = <2>;
 				label = "lan3";
+				phy-mode = "internal";
 				local-mac-address = [00 00 00 00 00 00];
 			};
 
 			lan4: port@3 {
 				reg = <3>;
 				label = "lan4";
+				phy-mode = "internal";
 				local-mac-address = [00 00 00 00 00 00];
 			};
 
 			lan5: port@4 {
 				reg = <4>;
 				label = "lan5";
+				phy-mode = "internal";
 				local-mac-address = [00 00 00 00 00 00];
 			};
 
-- 
2.35.1



