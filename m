Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF9439FE3
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhJYTZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232699AbhJYTXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E652610A6;
        Mon, 25 Oct 2021 19:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189669;
        bh=B42P9uUZze9v54MpO1kUEUAC1OxHMbBXcA/wrjPM7Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGsuebYYNiCmaBGS36/ROCXz0Z2zgT4VmyYoFdDRl1O9Z7juH9s9lb5vyXhYuBdiu
         ZF6XlkDsHqd4hg7n8Oqg3Hp40kmMB55r44e/gteRQsgH9fbRfIF3yhjiXJlfcIa6vy
         IU0aRouCSQ/llMk/hq7cuFFH6BATVpUwdIp1R1zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/30] ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default
Date:   Mon, 25 Oct 2021 21:14:22 +0200
Message-Id: <20211025190923.396425775@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 4348cc10da6377a86940beb20ad357933b8f91bb ]

Without a sensor node, the ISC will simply fail to probe, as the
corresponding port node is missing.
It is then logical to disable the node in the devicetree.
If we add a port with a connection to a sensor endpoint, ISC can be enabled.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20210902121358.503589-1-eugen.hristev@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index 60cb084a8d92..7e1acec92b50 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -98,7 +98,6 @@
 			isc: isc@f0008000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_isc_base &pinctrl_isc_data_8bit &pinctrl_isc_data_9_10 &pinctrl_isc_data_11_12>;
-				status = "okay";
 			};
 
 			spi0: spi@f8000000 {
-- 
2.33.0



