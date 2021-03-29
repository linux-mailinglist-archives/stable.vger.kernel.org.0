Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7864834DB27
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhC2WZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232356AbhC2WXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21E1D61989;
        Mon, 29 Mar 2021 22:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056608;
        bh=QYf+o391oxwQiLlr8qRgJfQwrpwQtS4oM5GXM2xDvmw=;
        h=From:To:Cc:Subject:Date:From;
        b=vHWcbk5Eb3FvSVyGhleUTWnMRv9ETTpd29jop4bJs2fbcbAEqXUQX890qxtW4tWUB
         KRAqOHRudHjXgZ8xhBxr5A3doDvBekF1S97NeAAGNTOBAkGxsd1Gp4cCuDvEwmv9UB
         asH/83EU33fWduruzwVTWrpkLM9w/0sIrXEzrPW43Gov1DH3SC5NF13/P06FGD2BmW
         6UFuFvcg55boIT78XEy/SJo1Ux9VBUVfrp4apruppxQyayScYP5hTH+zsk4sYaUUe+
         DIBJ5l1uypDDvQ5J5XLBoIyouwjIp57SqHKCL6af5KIVq8RJklDU2O1CBP4iX+kXmd
         nWbfbvLnhWgAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mans Rullgard <mans@mansr.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/15] ARM: dts: am33xx: add aliases for mmc interfaces
Date:   Mon, 29 Mar 2021 18:23:12 -0400
Message-Id: <20210329222327.2383533-1-sashal@kernel.org>
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
index d3dd6a16e70a..e321acaf35d6 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -39,6 +39,9 @@ aliases {
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

