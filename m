Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA0347AF1B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhLTPJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbhLTPHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:07:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6A6C09CE61;
        Mon, 20 Dec 2021 06:53:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC13EB80EEF;
        Mon, 20 Dec 2021 14:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBA1C36AE7;
        Mon, 20 Dec 2021 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012019;
        bh=MdH5tgg5AMGYfquqNdFMBmZioaGKm1Izga8Kg+tPskE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehglnQI7dAWipq4kzJh9610HhKRU3ErAzu4yv0AlAQRSPU696ykpYnH53HU9KuGeF
         LL+zsJEGo8xxHOKixlRx4CW7PGstvxca69fUSiW7fVt4K5/lv15zW/aFC+V4GoGNr+
         EBMUcbhToj/OWvgT7njzceMK8NFDCmjLTQJOumxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/177] arm64: dts: imx8mq: remove interconnect property from lcdif
Date:   Mon, 20 Dec 2021 15:33:21 +0100
Message-Id: <20211220143041.817839565@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit e5e6268f77badf18bd6ab435364cfe21c7396c31 ]

The mxsfb driver handling imx8mq lcdif doesn't yet request the
interconnect bandwidth that's needed at runtime when the description is
present in the DT node.

So remove that description and bring it back when it's supported.

Fixes: ad1abc8a03fd ("arm64: dts: imx8mq: Add interconnect for lcdif")
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 4066b16126552..2bc57d8f29c7f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -524,8 +524,6 @@ lcdif: lcd-controller@30320000 {
 						  <&clk IMX8MQ_VIDEO_PLL1>,
 						  <&clk IMX8MQ_VIDEO_PLL1_OUT>;
 				assigned-clock-rates = <0>, <0>, <0>, <594000000>;
-				interconnects = <&noc IMX8MQ_ICM_LCDIF &noc IMX8MQ_ICS_DRAM>;
-				interconnect-names = "dram";
 				status = "disabled";
 
 				port@0 {
-- 
2.33.0



