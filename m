Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBCE121943
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfLPRx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbfLPRx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367D721739;
        Mon, 16 Dec 2019 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518837;
        bh=U7b312bTOfKIQ9C33uLex1IfKC+Nxv4IdvkyXjf+DTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5szvK9F/albUBr+RP45y6sG3hST825NJUebGH+GBtzObV5qjkppP3dbMOxvnuw1b
         /YsVwujqEMogZfH/bgLY9Y/l1FxfLiAiBIfdHjU/bPWsawRHw86TYKTnd5IhLFXfpw
         +KiiYGaE6p49L4BBAYrcZ4Xeo6KwouwgE9DuR+sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/267] arm64: dts: meson-gxl-khadas-vim: fix GPIO lines names
Date:   Mon, 16 Dec 2019 18:46:53 +0100
Message-Id: <20191216174857.794624572@linuxfoundation.org>
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
index edc512ad0bac3..fb5db5f33e8c3 100644
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
@@ -125,7 +125,7 @@
 			  "SYS LED";
 };
 
-&pinctrl_periphs {
+&gpio {
 	gpio-line-names = /* Bank GPIOZ */
 			  "", "", "", "", "", "", "",
 			  "", "", "", "", "", "", "",
-- 
2.20.1



