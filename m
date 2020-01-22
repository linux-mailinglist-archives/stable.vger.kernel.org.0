Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464AF144FE5
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbgAVJmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733219AbgAVJmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354CE24686;
        Wed, 22 Jan 2020 09:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686128;
        bh=P4BITB953pc9Zi4u61h9J8Co5S+Xeh3jJJKspwO/i+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPo6vNbFs5389M56EJHE5zDaqoMAc31y0vqXPRoCA3Qrz9DUDEp/skreap2UaqQX/
         GYwogkeavyfWy23XyWkSYc/7Kx6XQDdjtGSIQdpbQg4+pNxJrUbw+5MM5buQ5PETPj
         29ZfACamotB4Ha1poxaQowRdIIP4n7yaQLiVBiQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/103] arm64: dts: agilex/stratix10: fix pmu interrupt numbers
Date:   Wed, 22 Jan 2020 10:29:10 +0100
Message-Id: <20200122092811.810664924@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 210de0e996aee8e360ccc9e173fe7f0a7ed2f695 ]

Fix up the correct interrupt numbers for the PMU unit on Agilex
and Stratix10.

Fixes: 78cd6a9d8e15 ("arm64: dts: Add base stratix 10 dtsi")
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
index 9a1ea8a46405..85fffe03b96b 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
@@ -59,10 +59,10 @@
 
 	pmu {
 		compatible = "arm,armv8-pmuv3";
-		interrupts = <0 120 8>,
-			     <0 121 8>,
-			     <0 122 8>,
-			     <0 123 8>;
+		interrupts = <0 170 4>,
+			     <0 171 4>,
+			     <0 172 4>,
+			     <0 173 4>;
 		interrupt-affinity = <&cpu0>,
 				     <&cpu1>,
 				     <&cpu2>,
-- 
2.20.1



