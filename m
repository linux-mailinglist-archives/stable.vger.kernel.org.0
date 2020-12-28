Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3E82E3CD5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438472AbgL1OHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438133AbgL1OHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 740002063A;
        Mon, 28 Dec 2020 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164416;
        bh=bvyXunQACEy+UokIkdUr00dVkELIAMl6AY2yc8hY0YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iw76ynGyz3HHaOwg5vI/xSP/v8T+SGj7UJRH3/YCQ+Y8QHdET74+0Ql6zRc3JrfZh
         GFwPLGceF3SL98Q0HtcT/9qmov2wVIlHcfkA7dRopJqQGM1ssEWqEHoidmAFeANEV+
         LrOYL/ez08jigl+/ez0+w0k3Aemzfsyyz4nUJH5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/717] ASoC: intel: SND_SOC_INTEL_KEEMBAY should depend on ARCH_KEEMBAY
Date:   Mon, 28 Dec 2020 13:42:23 +0100
Message-Id: <20201228125027.909219664@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9a207228bdf0a4933b794c944d7111564353ea94 ]

The Intel Keem Bay audio module is only present on Intel Keem Bay SoCs.
Hence add a dependency on ARCH_KEEMBAY, to prevent asking the user about
this driver when configuring a kernel without Intel Keem Bay platform
support.

Fixes: c544912bcc2dc806 ("ASoC: Intel: Add makefiles and kconfig changes for KeemBay")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20201110145001.3280479-1-geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/Kconfig b/sound/soc/intel/Kconfig
index a5b446d5af19f..c1bf69a0bcfe1 100644
--- a/sound/soc/intel/Kconfig
+++ b/sound/soc/intel/Kconfig
@@ -198,7 +198,7 @@ endif ## SND_SOC_INTEL_SST_TOPLEVEL || SND_SOC_SOF_INTEL_TOPLEVEL
 
 config SND_SOC_INTEL_KEEMBAY
 	tristate "Keembay Platforms"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARCH_KEEMBAY || COMPILE_TEST
 	depends on COMMON_CLK
 	help
 	  If you have a Intel Keembay platform then enable this option
-- 
2.27.0



