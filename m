Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850C934DB63
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhC2W2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhC2WZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22F9961613;
        Mon, 29 Mar 2021 22:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056627;
        bh=xijELzIbG11EAeYB9pA2+IKC5TFVDVEPkhj8LCfB5Ew=;
        h=From:To:Cc:Subject:Date:From;
        b=a7whbFxrH6UG1X76NSPZv05y71LXL007idmF5GYR2Zy4l3CkDWojdRmwKeefw41P5
         Z6eC54mba9rGCEQNxZW994VCeZpld0UbxJjgN3712e9jPw4+/2DUGG75CUyvDoVTcn
         3/0cRdhba4gebvNY/ONLIhEpTG9vE487Pie8NYld9Xx8r8lRpdktGhf55gHJhzOZF3
         BIOMtdbwanelTRgx0jC1YR6Y/4weA539UKY+y0YF7ZqEoW1H1jBo9KhvHNZ4g1gVvk
         df68bsUsEKyyqYT8lBB3aL8wV4bjBXWJeyPpSazQ1N9fgEN6KdShD1lP5EdRbPAWBS
         pjRJLSXRWduRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mans Rullgard <mans@mansr.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/12] ARM: dts: am33xx: add aliases for mmc interfaces
Date:   Mon, 29 Mar 2021 18:23:34 -0400
Message-Id: <20210329222345.2383777-1-sashal@kernel.org>
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
index e58fab8aec5d..8923273a2f73 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -38,6 +38,9 @@ aliases {
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

