Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CBE43A029
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhJYT3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234954AbhJYT0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9548B610A6;
        Mon, 25 Oct 2021 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189792;
        bh=t0D97tyNHfJ/dkvA9wcXR6/ikyKglEVqBfbjrKMlvK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIsJgRTtx2U8RdySuUSBW3fkFr5S9XAjEBcoKHRvR73NYPpFvs+YCXJCq88VpUOcv
         mOVuuJZCKneWZ4Y+h7nPBS4H1qswA47lUk4ZewbpRejQcSnSaSFIvhcMRcDG1w6ClX
         yZPQA+KuuuuU+SQ9G0oh3f1ItyqolUemxmNh8lEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/37] ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default
Date:   Mon, 25 Oct 2021 21:14:26 +0200
Message-Id: <20211025190928.536289840@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
index e86e0c00eb6b..f37af915a37e 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -106,7 +106,6 @@
 			isc: isc@f0008000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_isc_base &pinctrl_isc_data_8bit &pinctrl_isc_data_9_10 &pinctrl_isc_data_11_12>;
-				status = "okay";
 			};
 
 			spi0: spi@f8000000 {
-- 
2.33.0



