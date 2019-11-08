Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9209F49A8
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbfKHMEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389773AbfKHLmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6573E222C5;
        Fri,  8 Nov 2019 11:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213326;
        bh=4q0wxmlT8LNfXIg3Vz5jn72hLNxKgjL8rMq45doAlCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUDzYVoGP3euwLnEOkThbzbyljtrqvitknHJ8LAvYUz0/p0MCfgwVHjSl2hqXyBuG
         lAMDKJFdBtjwQAOpGhztPwRK6ptiEItck0/f/uwxRkEgqwv5+e3RmnPcahEd6BuGts
         3VznNQC81XAWYbFwuQzA5yfR6Agz0/yUX9QwL3ZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 168/205] arm64: dts: renesas: r8a77965: Fix HS-USB compatible
Date:   Fri,  8 Nov 2019 06:37:15 -0500
Message-Id: <20191108113752.12502-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 99584d93e301d820d817bba2eb77b9152e13009c ]

Should be "renesas,usbhs-r8a77965", not "renesas,usbhs-r8a7796".

Fixes: a06e8af801760a98 ("arm64: dts: renesas: r8a77965: add HS-USB node")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77965.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index 0da4841162610..2ccb1138cdf0c 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -545,7 +545,7 @@
 		};
 
 		hsusb: usb@e6590000 {
-			compatible = "renesas,usbhs-r8a7796",
+			compatible = "renesas,usbhs-r8a77965",
 				     "renesas,rcar-gen3-usbhs";
 			reg = <0 0xe6590000 0 0x100>;
 			interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.20.1

