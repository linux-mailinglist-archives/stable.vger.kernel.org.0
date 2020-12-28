Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761692E6404
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404664AbgL1Ppm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404654AbgL1Noo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80014205CB;
        Mon, 28 Dec 2020 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163069;
        bh=qmWQmxdPvn09YYGmNGIJb+8FozXlDtKJpd/7SJqFVLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snjjpdCY7ITg056cfRHxMFHUvPoeOSvGm3kEP8X6LOPhibQBKb1Xqvz6E1225iQQF
         1kcv510KzoR7o5M/xSBjzAka/bJymWhcIJ/GAE0m7hRRr3FBrGvcfbHHHhp+cAoLnb
         XnFGpPojCfO0z0ljhrpKZ/p3117pfCKB/wXFcWS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/453] clk: meson: Kconfig: fix dependency for G12A
Date:   Mon, 28 Dec 2020 13:46:34 +0100
Message-Id: <20201228124944.810656460@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hilman <khilman@baylibre.com>

[ Upstream commit bae69bfa3a586493469078ec4ca35499b754ba5c ]

When building only G12A, ensure that VID_PLL_DIV clock driver is
selected, otherwise results in this build error:

ERROR: modpost: "meson_vid_pll_div_ro_ops" [drivers/clk/meson/g12a.ko] undefined!

Fixes: 085a4ea93d54 ("clk: meson: g12a: add peripheral clock controller")
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201118190930.34352-1-khilman@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/meson/Kconfig b/drivers/clk/meson/Kconfig
index dabeb435d0678..3f8dcdcdde499 100644
--- a/drivers/clk/meson/Kconfig
+++ b/drivers/clk/meson/Kconfig
@@ -103,6 +103,7 @@ config COMMON_CLK_G12A
 	select COMMON_CLK_MESON_AO_CLKC
 	select COMMON_CLK_MESON_EE_CLKC
 	select COMMON_CLK_MESON_CPU_DYNDIV
+	select COMMON_CLK_MESON_VID_PLL_DIV
 	select MFD_SYSCON
 	help
 	  Support for the clock controller on Amlogic S905D2, S905X2 and S905Y2
-- 
2.27.0



