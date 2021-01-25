Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E90B303399
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbhAZFAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730896AbhAYSuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E67C224B8;
        Mon, 25 Jan 2021 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600629;
        bh=uDmCUkyc/OAUaXt/5Dv9yzbOeM8S2pf/Cwf5ZPGIZrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evqlkCj3j8paPC950xlQER8QvsTeR3JnaW9SdSS8k7O9aC6lgWoF4Lc2jxnGkm55O
         +0tSBApjwyKfuYeMY6Yf5rwoofwg6+mOVVLrexfW+VsIyZiprdiS7i+Q/8xom89NRb
         G6Qbc8E2P7r8NlMOcZvbjtL1mWzabPjV5qTRfmrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/199] dts: phy: add GPIO number and active state used for phy reset
Date:   Mon, 25 Jan 2021 19:38:01 +0100
Message-Id: <20210125183218.759858441@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagar Shrikant Kadam <sagar.kadam@sifive.com>

[ Upstream commit a0fa9d727043da2238432471e85de0bdb8a8df65 ]

The GEMGXL_RST line on HiFive Unleashed is pulled low and is
using GPIO number 12. Add these reset-gpio details to dt-node
using which the linux phylib can reset the phy.

Signed-off-by: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
index 60846e88ae4b1..24d75a146e02d 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -90,6 +90,7 @@
 	phy0: ethernet-phy@0 {
 		compatible = "ethernet-phy-id0007.0771";
 		reg = <0>;
+		reset-gpios = <&gpio 12 GPIO_ACTIVE_LOW>;
 	};
 };
 
-- 
2.27.0



