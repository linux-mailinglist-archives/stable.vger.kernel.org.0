Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2275634DABF
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhC2WXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232069AbhC2WWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5409A61989;
        Mon, 29 Mar 2021 22:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056544;
        bh=/f8PHLgOoBRK9H053cwLq8xLIhrP9vYDSvC2JRE5oBM=;
        h=From:To:Cc:Subject:Date:From;
        b=tC7l0boUe8uksNdeZMcL50vWPc+kWoaehbLQCrbmWQIQmC9h5SUIiekaqN3COI5wS
         77iWXQc1AIR59owceMEPTOl5RXtPKcFrl3fMAWZl3hSr+epmDTSzwmqG0KnDARbgON
         7YU+Np/zY2j5lTnwax0emKMNxueVNd39d7IqFC9Gl6PW2S+97o/CpzRy9vQw2ufFMX
         9yT6eKsp7G/S7l6UEkpIEBDISPbz6sLcy/WAe3u0DSSoW5V5wERLml3i6qrqO1v2CD
         x9Pwnu90Rz+VSRQA1z+wYyWrgxj3DaNEc4fFTID+0qKB/Vg3CXgk6X9x5Oeanlw2vF
         YAOAaQPr037Xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mans Rullgard <mans@mansr.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/33] ARM: dts: am33xx: add aliases for mmc interfaces
Date:   Mon, 29 Mar 2021 18:21:49 -0400
Message-Id: <20210329222222.2382987-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit 9bbce32a20d6a72c767a7f85fd6127babd1410ac ]

Without DT aliases, the numbering of mmc interfaces is unpredictable.
Adding them makes it possible to refer to devices consistently.  The
popular suggestion to use UUIDs obviously doesn't work with a blank
device fresh from the factory.

See commit fa2d0aa96941 ("mmc: core: Allow setting slot index via
device tree alias") for more discussion.

Signed-off-by: Mans Rullgard <mans@mansr.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 4c2298024137..f09a61cac2dc 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -40,6 +40,9 @@ aliases {
 		ethernet1 = &cpsw_emac1;
 		spi0 = &spi0;
 		spi1 = &spi1;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
 	};
 
 	cpus {
-- 
2.30.1

