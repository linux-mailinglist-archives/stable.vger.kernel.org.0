Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322EA150D37
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgBCQmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbgBCQdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:45 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA50B21741;
        Mon,  3 Feb 2020 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747625;
        bh=QsjbUwwT6G2tcMfHQDcUEaZfQFcpR3qcXYmk4I4shpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9bvl4no5v6UeCQMOS2bGGZpSyR/01S7L9tMvFVtYqzepa3p+w09VQUD0cBGm/6Au
         ptcuB73Kzbt68ZSqvaJO2a8+ju5kZ4W62fK1wIlv+KXzejBWc7iCc9cE/ZeXpXgZGf
         ANdhH0d6rru1TRG9Po8IParbhmzZkqCqxhOkugeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/70] ARM: dts: am335x-boneblack-common: fix memory size
Date:   Mon,  3 Feb 2020 16:20:05 +0000
Message-Id: <20200203161920.022371354@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matwey V. Kornilov <matwey@sai.msu.ru>

[ Upstream commit 5abd45ea0fc3060f7805e131753fdcbafd6c6618 ]

BeagleBone Black series is equipped with 512MB RAM
whereas only 256MB is included from am335x-bone-common.dtsi

This leads to an issue with unusual setups when devicetree
is loaded by GRUB2 directly.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-boneblack-common.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-boneblack-common.dtsi b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
index 21bc1173fa6b9..cb4267edde63d 100644
--- a/arch/arm/boot/dts/am335x-boneblack-common.dtsi
+++ b/arch/arm/boot/dts/am335x-boneblack-common.dtsi
@@ -131,6 +131,11 @@
 };
 
 / {
+	memory@80000000 {
+		device_type = "memory";
+		reg = <0x80000000 0x20000000>; /* 512 MB */
+	};
+
 	clk_mcasp0_fixed: clk_mcasp0_fixed {
 		#clock-cells = <0>;
 		compatible = "fixed-clock";
-- 
2.20.1



