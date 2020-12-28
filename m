Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FACB2E3CE0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438604AbgL1OIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438552AbgL1OIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4DD3206E5;
        Mon, 28 Dec 2020 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164450;
        bh=Ywt15Zwqf3VTaNk8Ef0FwNLl59vvQMRTtbHV3UaJV7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJJIQDk1ZIy/UleO5FkQ9EwjabFhMYXbQ2j78ndk6zWXOWhbqvFOsWWgVkRuOS6RA
         nJbA3s0hB4eozdiuU5EhRDG86NJaHfFCPwSQcwJC77+UJFoZgx5QrKuHTxDI6n9zIf
         +UP/jyUZsHouYwIb2ABXyZScu3P8G4lfmaA8Q1R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/717] clk: meson: Kconfig: fix dependency for G12A
Date:   Mon, 28 Dec 2020 13:43:03 +0100
Message-Id: <20201228125029.832662633@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 034da203e8e0e..9a8a548d839d8 100644
--- a/drivers/clk/meson/Kconfig
+++ b/drivers/clk/meson/Kconfig
@@ -110,6 +110,7 @@ config COMMON_CLK_G12A
 	select COMMON_CLK_MESON_AO_CLKC
 	select COMMON_CLK_MESON_EE_CLKC
 	select COMMON_CLK_MESON_CPU_DYNDIV
+	select COMMON_CLK_MESON_VID_PLL_DIV
 	select MFD_SYSCON
 	help
 	  Support for the clock controller on Amlogic S905D2, S905X2 and S905Y2
-- 
2.27.0



