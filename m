Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80188150D1C
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgBCQel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbgBCQek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:40 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2142F20CC7;
        Mon,  3 Feb 2020 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747679;
        bh=57FOBy08qBEXlKgCxiaToUjk/k0ohn9GFat1iPhq1H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPuSEoKFYbDuHrRmRZGVwxoGkvyRoyYI78CPa7lCS3KXBcMlpakPvoFSUTzaCULEW
         nj5iDy1dY0oXc030FQHl5LjgzCf9F1aBu3HeTDPWkAsnXEaNZtmP08MMUEA3zsbwx3
         i12q0BKHiOiaBQzBRjFKaZYgI1MtoksVr2stV14Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume La Roque <glaroque@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/90] arm64: dts: meson-sm1-sei610: add gpio bluetooth interrupt
Date:   Mon,  3 Feb 2020 16:19:28 +0000
Message-Id: <20200203161920.928315872@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume La Roque <glaroque@baylibre.com>

[ Upstream commit 30388cc075720aa0af4f2cb5933afa1f8f39d313 ]

add gpio irq to support interrupt trigger mode.

Signed-off-by: Guillaume La Roque <glaroque@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
index 3435aaa4e8db5..5d6a8dafe8dc0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
@@ -361,6 +361,8 @@
 
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
+		interrupt-parent = <&gpio_intc>;
+		interrupts = <95 IRQ_TYPE_LEVEL_HIGH>;
 		shutdown-gpios = <&gpio GPIOX_17 GPIO_ACTIVE_HIGH>;
 		max-speed = <2000000>;
 		clocks = <&wifi32k>;
-- 
2.20.1



