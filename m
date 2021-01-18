Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930DC2FA30B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbhARObT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390809AbhARLnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A422245C;
        Mon, 18 Jan 2021 11:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970154;
        bh=o//x4t3L4c7A2s0gm9YfzsSy/uW230ICsDlCevPIAu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1ZpefW8xCZtD897Q+CuGpsPGxuOoRT4x8BhP9CaAxs7Pddgr/xHyjMibr9+BpL9H
         yV+AoOgAxS+edzaAjpC/iI2G9F4vLPMDQxFzAav+zfCtKrer6AyYUjJd1WWY2bI35J
         DbTcqB2oI5ZEIKdAny4NF4GBSxx08qXkXBm6taok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Philipp Klemm <philipp@uvos.xyz>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/152] ARM: omap2: pmic-cpcap: fix maximum voltage to be consistent with defaults on xt875
Date:   Mon, 18 Jan 2021 12:33:54 +0100
Message-Id: <20210118113355.622838192@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



