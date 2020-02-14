Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AE315F250
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbgBNPyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731456AbgBNPyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4E024686;
        Fri, 14 Feb 2020 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695655;
        bh=O223LQV9enNAUAJH8Cah5pckGd311AgxJ5giEGsj2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDJhl8tTcKLMGsLwPvR8+1CTEGnnR0P9wAwYLYHQk96v8LnsWL03UHFOWx8NsoQWw
         0aS55xgIsLAQb3L1GhRBCFQ/U6WMICSW4d/Y1Wnuw/g9ii31rLDPW1x7CFljpVb9x/
         lQ4NFReW21Q1AA1813+yINa7SPcm/kRPXOBXr2kg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 247/542] arm64: dts: renesas: r8a77990: ebisu: Remove clkout-lr-synchronous from sound
Date:   Fri, 14 Feb 2020 10:43:59 -0500
Message-Id: <20200214154854.6746-247-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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

