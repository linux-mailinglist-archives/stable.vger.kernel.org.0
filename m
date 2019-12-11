Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9F711B040
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbfLKPVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732275AbfLKPVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ADF122527;
        Wed, 11 Dec 2019 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077662;
        bh=nZclWlApGY5pU7wPW025S/sgkSEEpV2el8r4Y2YgVWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxB//2Md7zC/e/lRSCmmiIW3tVTOCFLNHVZOr74H1rvZETWGiT1YBgfGq44uTtdHJ
         oPDdpmPg5J6K7oI50B+sjOzEPNbyxxBArn4URzZxn9pwtZMRO5X4U9RVmi15cZirAW
         7VtbLnnVgXemULqUdtsD/ncWZ14hZn7z335N0xNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/243] ARM: dts: sun5i: a10s: Fix HDMI output DTC warning
Date:   Wed, 11 Dec 2019 16:04:46 +0100
Message-Id: <20191211150347.500124183@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit ed5fc60b909427be6ca93d3e07a0a5f296d7000a ]

Our HDMI output endpoint on the A10s DTSI has a warning under DTC: "graph
node has single child node 'endpoint', #address-cells/#size-cells are not
necessary". Fix this by removing those properties.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun5i-a10s.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5i-a10s.dtsi
index 316cb8b2945b1..a66d9f92f58f5 100644
--- a/arch/arm/boot/dts/sun5i-a10s.dtsi
+++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
@@ -104,8 +104,6 @@
 				};
 
 				hdmi_out: port@1 {
-					#address-cells = <1>;
-					#size-cells = <0>;
 					reg = <1>;
 				};
 			};
-- 
2.20.1



