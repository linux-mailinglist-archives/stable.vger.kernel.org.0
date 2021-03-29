Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483EC34DAF3
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhC2WYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232390AbhC2WXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FFF619A6;
        Mon, 29 Mar 2021 22:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056584;
        bh=qfLGf4w8riGoxlfluKRrSoDo1l3KCOH2bb0AnwY1vNg=;
        h=From:To:Cc:Subject:Date:From;
        b=m9BpS7zdPdT4eoUzxHlbMkiWP/70ppTYliDdh27q+FmCWBzPTP8hpak7vyRq7RFWZ
         XBTybNeERSdO9HzH5CfhhGC22OHzK0VKbZrFmh2wpbrWIHc3kr825zOFi7i6D7aEn+
         zp0B311qBJhQim/8xNqCagHhN6Sc5IywdHoWTRAF+eyo7RQZHeOvBuIuBi+Ie1v72M
         GEIP2wXvBrgSVMovI5QGJWz00i2zcu+Y2KHU4ChriCwkklDfWYqoFIiMSM+mC1jm0a
         4x/rU23fYTb1Ho97hYh7KD7BPEpLwAS1eoumIgQkKlFdNq86PTYzIn/BTaTirmSovL
         xZ7p4DbxO0XYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mans Rullgard <mans@mansr.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/19] ARM: dts: am33xx: add aliases for mmc interfaces
Date:   Mon, 29 Mar 2021 18:22:44 -0400
Message-Id: <20210329222303.2383319-1-sashal@kernel.org>
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
index fb6b8aa12cc5..77fa7c0f2104 100644
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

