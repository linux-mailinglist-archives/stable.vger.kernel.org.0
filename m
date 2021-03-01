Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C6F328CE1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhCATBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:01:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236742AbhCASyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:54:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F16D650A5;
        Mon,  1 Mar 2021 17:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620096;
        bh=1GfRdhj7jWDgfq6pmdHMfsCIR4d51gaglmodvJ2pnng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zM99sPkIstHZdXgTZ6OiK3W7YK1MNhp9UjfgcupTI6ypwlGYe1Mk6G7fnjOzmMobR
         AI/Tk2tiOFmRm0ISBfZiTPXE3De4mncFwqUsJs0qKUEr4XbSWT0N+zFT8CWdzJHJON
         GwDsYsVAMs9Y2A2oW6Q0BWhHwpf+oXdajYnORTMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 028/775] arm64: dts: renesas: beacon: Fix audio-1.8V pin enable
Date:   Mon,  1 Mar 2021 17:03:16 +0100
Message-Id: <20210301161203.111903669@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 5a5da0b758b327b727c5392d7f11e046e113a195 ]

The fact the audio worked at all was a coincidence because the wrong
gpio enable was used.  Use the correct GPIO pin to ensure its operation.

Fixes: a1d8a344f1ca ("arm64: dts: renesas: Introduce r8a774a1-beacon-rzg2m-kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20201213183759.223246-6-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index e66b5b36e4894..759734b7715bd 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -150,7 +150,7 @@
 		regulator-name = "audio-1.8V";
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
-		gpio = <&gpio_exp2 7 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio_exp4 1 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 
-- 
2.27.0



