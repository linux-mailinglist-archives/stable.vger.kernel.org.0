Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46649121290
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLPRxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfLPRxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E430120733;
        Mon, 16 Dec 2019 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518830;
        bh=l+iuQlcezMBd/7Et/nhWonLvMUief6HtBQvhF9FLr0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPNLy/OetpZOBSW3Mp+SXbO8+yzYq4DJ7/4y56fJGTL9EAPcEyFDQDP9BKHEcwj2U
         PBbDXaD3EEMtjAPQjhDr++R+6I7jd5eu6QrA5a6ubM+jG8sb37q266xO8fZNfo+30n
         lBZAM15hPHdYNfmDkfqWt1+4tYCAgNNdh8CMO4h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/267] arm64: dts: meson-gxl-libretech-cc: fix GPIO lines names
Date:   Mon, 16 Dec 2019 18:46:50 +0100
Message-Id: <20191216174857.585681299@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 11fa9774612decea87144d7f950a9c53a4fe3050 ]

The gpio line names were set in the pinctrl node instead of the gpio node,
at the time it was merged, it worked, but was obviously wrong.
This patch moves the properties to the gpio nodes.

Fixes: 47884c5c746e ("ARM64: dts: meson-gxl-libretech-cc: Add GPIO lines names")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
index 0814b6b29b86a..e2c71753e3278 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
@@ -139,7 +139,7 @@
 	};
 };
 
-&pinctrl_aobus {
+&gpio_ao {
 	gpio-line-names = "UART TX",
 			  "UART RX",
 			  "Blue LED",
@@ -152,7 +152,7 @@
 			  "7J1 Header Pin13";
 };
 
-&pinctrl_periphs {
+&gpio {
 	gpio-line-names = /* Bank GPIOZ */
 			  "", "", "", "", "", "", "",
 			  "", "", "", "", "", "", "",
-- 
2.20.1



