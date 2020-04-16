Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A231AC376
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbgDPNnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgDPNnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:43:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 807A0214D8;
        Thu, 16 Apr 2020 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044612;
        bh=pPQAnpLJ6swHilZZiXwdXrhXTemHxz69XOukH7cla4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1CAyKdXimIUYaOnNqNFZ3LRp1M2oK45+4uv2DrjPl/PY6ma0JCYhk7le7EA6/71w
         5PTFzObB8Zhc5HmrNCGy5Bk7g+yeXbuOzyO6LjPFlDeM61dpfYmsb52/cZG/s6j8Eo
         vhwaVkdbaRDYaww7J/KkKqno+9CjHXI/YoSPrdqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/232] ARM: dts: Fix dm814x Ethernet by changing to use rgmii-id mode
Date:   Thu, 16 Apr 2020 15:21:37 +0200
Message-Id: <20200416131317.023733829@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit b46b2b7ba6e104d265ab705914859ec0db7a98c5 ]

Commit cd28d1d6e52e ("net: phy: at803x: Disable phy delay for RGMII mode")
caused a regression for dm814x boards where NFSroot would no longer work.

Let's fix the issue by configuring "rgmii-id" mode as internal delays are
needed that is no longer the case with "rgmii" mode.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dm8148-evm.dts       | 4 ++--
 arch/arm/boot/dts/dm8148-t410.dts      | 4 ++--
 arch/arm/boot/dts/dra62x-j5eco-evm.dts | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/dm8148-evm.dts b/arch/arm/boot/dts/dm8148-evm.dts
index 3931fb068ff09..91d1018ab75fc 100644
--- a/arch/arm/boot/dts/dm8148-evm.dts
+++ b/arch/arm/boot/dts/dm8148-evm.dts
@@ -24,12 +24,12 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &cpsw_emac1 {
 	phy-handle = <&ethphy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &davinci_mdio {
diff --git a/arch/arm/boot/dts/dm8148-t410.dts b/arch/arm/boot/dts/dm8148-t410.dts
index 9e43d5ec0bb2f..79ccdd4470f4c 100644
--- a/arch/arm/boot/dts/dm8148-t410.dts
+++ b/arch/arm/boot/dts/dm8148-t410.dts
@@ -33,12 +33,12 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &cpsw_emac1 {
 	phy-handle = <&ethphy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &davinci_mdio {
diff --git a/arch/arm/boot/dts/dra62x-j5eco-evm.dts b/arch/arm/boot/dts/dra62x-j5eco-evm.dts
index 861ab90a3f3aa..c16e183822bee 100644
--- a/arch/arm/boot/dts/dra62x-j5eco-evm.dts
+++ b/arch/arm/boot/dts/dra62x-j5eco-evm.dts
@@ -24,12 +24,12 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &cpsw_emac1 {
 	phy-handle = <&ethphy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 };
 
 &davinci_mdio {
-- 
2.20.1



