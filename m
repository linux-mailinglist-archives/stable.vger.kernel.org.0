Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03BC15ED37
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390437AbgBNQGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390435AbgBNQG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83319206D7;
        Fri, 14 Feb 2020 16:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696389;
        bh=O223LQV9enNAUAJH8Cah5pckGd311AgxJ5giEGsj2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKkyb6uCIQf4P7VmAvndURRa0TssA8m1YwroFbIsxyc/z+JRmR0i0jHp+IXR5Bue/
         4a0H5LB1H7lVl7GhobX3pAA3C8hvTwAqZ6/9aO+jQstbN35JVePhrc2caSM+V5U6RF
         v7CVu6Ss9KoZTLsnEvOxS7+zTNNxx9sdE8A4vhjE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 215/459] arm64: dts: renesas: r8a77990: ebisu: Remove clkout-lr-synchronous from sound
Date:   Fri, 14 Feb 2020 10:57:45 -0500
Message-Id: <20200214160149.11681-215-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit bf2b74ce9b33a2edd6ba1930ce60a71830790910 ]

rcar_sound doesn't support clkout-lr-synchronous in upstream.
It was supported under out-of-tree rcar_sound.
upstream rcar_sound is supporting
	- clkout-lr-synchronous
	+ clkout-lr-asynchronous

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87mubt3tux.wl-kuninori.morimoto.gx@renesas.com
Fixes: 56629fcba94c698d ("arm64: dts: renesas: ebisu: Enable Audio")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
index b38f9d442fc08..e6d700f8c1948 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
@@ -636,7 +636,6 @@
 	/* audio_clkout0/1/2/3 */
 	#clock-cells = <1>;
 	clock-frequency = <12288000 11289600>;
-	clkout-lr-synchronous;
 
 	status = "okay";
 
-- 
2.20.1

