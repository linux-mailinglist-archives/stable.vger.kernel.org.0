Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00788328F2D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhCATqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237830AbhCATgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:36:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D88465178;
        Mon,  1 Mar 2021 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618469;
        bh=K5/yF9zX9cMWNg2dhFcFWiBg5idgupN3N2fLEo+OKjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6ORRjLsrqqy1yxzfEgZIZju2PLr+e0Ykrml+nq8dysoQ4i1zYFzS/cb8qI/l3eAs
         WP1qjHasQycc8bLNuBP77uqFfNLUYR62v/w+nFcvhQ0jcTx+g9P3ze8gyCCeKA3W0T
         owg9q1dq8YRFJbrDbQYL1YXBF5HjYMu1NgbNvtWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/663] arm64: dts: renesas: beacon: Fix EEPROM compatible value
Date:   Mon,  1 Mar 2021 17:05:16 +0100
Message-Id: <20210301161145.097684486@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 74477936a828a7c91a61ba7e625b7ce2299c8c98 ]

"make dtbs_check" fails with:

    arch/arm64/boot/dts/renesas/r8a774b1-beacon-rzg2n-kit.dt.yaml: eeprom@50: compatible: 'oneOf' conditional failed, one must be fixed:
	    'microchip,at24c64' does not match '^(atmel|catalyst|microchip|nxp|ramtron|renesas|rohm|st),(24(c|cs|lc|mac)[0-9]+|spd)$'

Fix this by dropping the bogus "at" prefix.

Fixes: a1d8a344f1ca0709 ("arm64: dts: renesas: Introduce r8a774a1-beacon-rzg2m-kit")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210128110136.2293490-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 6d24b36ca0a7c..289cf711307d6 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -147,7 +147,7 @@
 	};
 
 	eeprom@50 {
-		compatible = "microchip,at24c64", "atmel,24c64";
+		compatible = "microchip,24c64", "atmel,24c64";
 		pagesize = <32>;
 		read-only;	/* Manufacturing EEPROM programmed at factory */
 		reg = <0x50>;
-- 
2.27.0



