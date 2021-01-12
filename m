Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91B22F2F8D
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 13:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbhALM4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:56:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388975AbhALM4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:56:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 465E72311D;
        Tue, 12 Jan 2021 12:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456141;
        bh=o//x4t3L4c7A2s0gm9YfzsSy/uW230ICsDlCevPIAu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deQxVXy4O7Z7bbY8NqgmCtDDkwpOUV4J4ErI4y6vJjfOklYmDP9yEqTOSe+oIlxXw
         PafEc6oOaJ8GkhDhv9E74xCYVa4NA7dJvpi/CHak8Hs8SN0wjMNLIGnz/LGkva+KFZ
         cG12vbCB5Q83j/dk1CZzBVC544DwQz5JMoMFK1WDgsiefz/KBRKUCgh7BqnGpyHoaV
         6sGgOSeYP2pFDjKLUVPZxu5LS6cHDD1lGS2ySdSxWljfYozUHK+OTbiHivGLx0br6d
         rxs99fwC5TBRRtQtSM9a1hvMQUvQElpLA6eFN+ebmNWrwiRYNcNfnmpM7/DlNGLXwu
         LwkihH2f2eExg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Carl Philipp Klemm <philipp@uvos.xyz>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 05/51] ARM: omap2: pmic-cpcap: fix maximum voltage to be consistent with defaults on xt875
Date:   Tue, 12 Jan 2021 07:54:47 -0500
Message-Id: <20210112125534.70280-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Philipp Klemm <philipp@uvos.xyz>

[ Upstream commit c0bc969c176b10598b31d5d1a5edf9a5261f0a9f ]

xt875 comes up with a iva voltage of 1375000 and android runs at this too. fix
maximum voltage to be consistent with this.

Signed-off-by: Carl Philipp Klemm <philipp@uvos.xyz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pmic-cpcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pmic-cpcap.c b/arch/arm/mach-omap2/pmic-cpcap.c
index eab281a5fc9f7..09076ad0576d9 100644
--- a/arch/arm/mach-omap2/pmic-cpcap.c
+++ b/arch/arm/mach-omap2/pmic-cpcap.c
@@ -71,7 +71,7 @@ static struct omap_voltdm_pmic omap_cpcap_iva = {
 	.vp_vstepmin = OMAP4_VP_VSTEPMIN_VSTEPMIN,
 	.vp_vstepmax = OMAP4_VP_VSTEPMAX_VSTEPMAX,
 	.vddmin = 900000,
-	.vddmax = 1350000,
+	.vddmax = 1375000,
 	.vp_timeout_us = OMAP4_VP_VLIMITTO_TIMEOUT_US,
 	.i2c_slave_addr = 0x44,
 	.volt_reg_addr = 0x0,
-- 
2.27.0

