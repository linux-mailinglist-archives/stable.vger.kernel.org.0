Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B584290AD
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbhJKOL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243004AbhJKOJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:09:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75B10610E8;
        Mon, 11 Oct 2021 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960911;
        bh=IO/edUeyz9D9Jjbybo3a5FrnAHGZyOQn/oTN6edKiX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHBqCCSf8VAGXA7Rkik6h19P1jpWdwnz2PHrIsURglRabMbWqQKvh5v98Cr6r4nEr
         oWwjHPG8qZTenNOoM5u+N9vmi6lEhjSDuwfRuGynHEo7nLyh8SMYWI9kaEFyyqDbF8
         6/z0FFT8eXf+jPw0mHkHb3LOeoHauYGDLx3al0ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Thiery <heiko.thiery@gmail.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 078/151] arm64: dts: imx8mm-kontron-n801x-som: do not allow to switch off buck2
Date:   Mon, 11 Oct 2021 15:45:50 +0200
Message-Id: <20211011134520.368389000@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Thiery <heiko.thiery@gmail.com>

[ Upstream commit 9786cca4b477f2b2f9d573d474c929d87579b501 ]

The buck2 output of the PMIC is the VDD core voltage of the cpu.
Switching off this will poweroff the CPU. Add the 'regulator-always-on'
property to avoid this.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
index d0456daefda8..9db9b90bf2bc 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
@@ -102,6 +102,7 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <950000>;
 				regulator-boot-on;
+				regulator-always-on;
 				regulator-ramp-delay = <3125>;
 				nxp,dvs-run-voltage = <950000>;
 				nxp,dvs-standby-voltage = <850000>;
-- 
2.33.0



