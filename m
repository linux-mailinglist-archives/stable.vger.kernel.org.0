Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6EF11B4D3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732248AbfLKPV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731800AbfLKPV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E39C8214AF;
        Wed, 11 Dec 2019 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077716;
        bh=p0rYq8DNTEvI2nZKWkRzFO8maTF/mCBCjUX9Fx7inuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DENFKnz8WZ8253JjBAJp3mruhyYxpGacgQGK43ECkZOWiwruhYmEtoCDPTfKs5ms
         ZZ8Vnd7j9CBXHpZvxXMvCi9v4e7/q8V71IMNjBJP2zLOSF5lN3cMBrbfwph13h9pcj
         NHjKzPip5HBxRsNFHVJTIGgybLCCBVPq1nEyDCt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/243] arm64: dts: meson-gxl-khadas-vim: fix GPIO lines names
Date:   Wed, 11 Dec 2019 16:05:04 +0100
Message-Id: <20191211150348.749585416@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 5b78012636f537344bd551934387f5772c38ba80 ]

The gpio line names were set in the pinctrl node instead of the gpio node,
at the time it was merged, it worked, but was obviously wrong.
This patch moves the properties to the gpio nodes.

Fixes: 60795933b709 ("ARM64: dts: meson-gxl-khadas-vim: Add GPIO lines names")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts
index d32cf38463702..864ef0111b01a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts
@@ -112,7 +112,7 @@
 	linux,rc-map-name = "rc-geekbox";
 };
 
-&pinctrl_aobus {
+&gpio_ao {
 	gpio-line-names = "UART TX",
 			  "UART RX",
 			  "Power Key In",
@@ -127,7 +127,7 @@
 			  "";
 };
 
-&pinctrl_periphs {
+&gpio {
 	gpio-line-names = /* Bank GPIOZ */
 			  "", "", "", "", "", "", "",
 			  "", "", "", "", "", "", "",
-- 
2.20.1



