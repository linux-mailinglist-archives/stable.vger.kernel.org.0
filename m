Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333012C0704
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgKWMgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731712AbgKWMge (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:36:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF97F20857;
        Mon, 23 Nov 2020 12:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134992;
        bh=W4wD3aHABnQFjHfUrj6jpTM2a5eS3kJtR3UhujtJubk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/YhQqjyv/dl85uTjqtFQJxchgmnsDHeBDMZvfj90QU96f9ahfUyxTRd76RiCyHam
         kQQEp4kJaQhfQLWBYBSNqa4h0Ce4O04RD1wAnlC2s1xNfdxr6pbiroIZUf3w2t/e6s
         AoPEO1gvyRFQRnTxo0kU5r/nyJ1GqsL96ekz7ssQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/158] arm64: dts: imx8mm: fix voltage for 1.6GHz CPU operating point
Date:   Mon, 23 Nov 2020 13:21:34 +0100
Message-Id: <20201123121823.120914640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit d19d2152ca055baf20339cfacbf039c2cfb8d936 ]

The datasheet for both the industrial and consumer variant of the
SoC lists a typical voltage of 0.95V for the 1.6GHz CPU operating
point.

Fixes: e85c9d0faa75 (arm64: dts: imx8mm: Add cpufreq properties)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index fde1849d36ca5..7b178a77cc712 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -126,7 +126,7 @@
 
 		opp-1600000000 {
 			opp-hz = /bits/ 64 <1600000000>;
-			opp-microvolt = <900000>;
+			opp-microvolt = <950000>;
 			opp-supported-hw = <0xc>, <0x7>;
 			clock-latency-ns = <150000>;
 			opp-suspend;
-- 
2.27.0



