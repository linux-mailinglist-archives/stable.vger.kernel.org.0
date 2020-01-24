Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFE4147F31
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733171AbgAXLAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:00:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732904AbgAXLAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:00:22 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BFDC20838;
        Fri, 24 Jan 2020 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863621;
        bh=UWl/S2js9Wg1+AuLTYSHxvlC9MVnFZjfyWK5de/QnHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP65Cj592Fvwzu4VI6bHvfTKljC6Q2OvJYb2K7T4dGj+OinOSLP6wHnUWTriYCGGd
         B2rNA0ksOriNAEuf2II3HSGGWGwMHFomn/pj6Wce1z21PufbOfx0WCkcyYNKk1XuB8
         TuXPGMKfoTJSO6qzRCyOfv/u85ECcHHxJAJjlUTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/639] ARM: dts: at91: nattis: set the PRLUD and HIPOW signals low
Date:   Fri, 24 Jan 2020 10:23:09 +0100
Message-Id: <20200124093049.605522294@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit 29feb2c960ab32fc24249443d4434194ce96f083 ]

AT91_PINCTRL_OUTPUT_VAL(0) without AT91_PINCTRL_OUTPUT is a no-op, so
make sure the pins really output a zero.

Fixes: 0e4323899973 ("ARM: dts: at91: add devicetree for the Axentia Nattis with Natte power")
Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-nattis-2-natte-2.dts | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-nattis-2-natte-2.dts b/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
index af9f38456d04e..bfa5815a07214 100644
--- a/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
+++ b/arch/arm/boot/dts/at91-nattis-2-natte-2.dts
@@ -38,14 +38,16 @@
 						atmel,pins =
 							<AT91_PIOA 21
 							 AT91_PERIPH_GPIO
-							 AT91_PINCTRL_OUTPUT_VAL(0)>;
+							 (AT91_PINCTRL_OUTPUT |
+							  AT91_PINCTRL_OUTPUT_VAL(0))>;
 					};
 
 					pinctrl_lcd_hipow0: lcd_hipow0 {
 						atmel,pins =
 							<AT91_PIOA 23
 							 AT91_PERIPH_GPIO
-							 AT91_PINCTRL_OUTPUT_VAL(0)>;
+							 (AT91_PINCTRL_OUTPUT |
+							  AT91_PINCTRL_OUTPUT_VAL(0))>;
 					};
 				};
 			};
-- 
2.20.1



