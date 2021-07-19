Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60183CDFD3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344893AbhGSPMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344442AbhGSPKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EFAF60FE7;
        Mon, 19 Jul 2021 15:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709858;
        bh=tbA/lKVsaEn+VFYF2bNhqaPs0XK7uaPD1Cxi2aKEdIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFLGi8pvNPdrdJiYRQVLKi8zBeWWIAs3q5Le/3p2o1PAwHZhzSsaPciqLau4Kv09V
         QtgLLZ1TJXUOEJ7cY9OLDNX3z1YEqsRIE0aWHKtuYwg66moPIzEKHoQyiRAeoifOFI
         ixHLDO9beesFKTqHTznBfBbyGP6ErnjPYjH39KDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/149] arm64: dts: renesas: v3msk: Fix memory size
Date:   Mon, 19 Jul 2021 16:53:53 +0200
Message-Id: <20210719144930.979901996@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentine Barshak <valentine.barshak@cogentembedded.com>

[ Upstream commit a422ec20caef6a50cf3c1efa93538888ebd576a6 ]

The V3MSK board has 2 GiB RAM according to the datasheet and schematics.

Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
[geert: Verified schematics]
Fixes: cc3e267e9bb0ce7f ("arm64: dts: renesas: initial V3MSK board device tree")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210326121050.1578460-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts b/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts
index d7c7b9156e08..5c391248ddb3 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts
@@ -59,7 +59,7 @@
 	memory@48000000 {
 		device_type = "memory";
 		/* first 128MB is reserved for secure area. */
-		reg = <0x0 0x48000000 0x0 0x38000000>;
+		reg = <0x0 0x48000000 0x0 0x78000000>;
 	};
 
 	osc5_clk: osc5-clock {
-- 
2.30.2



