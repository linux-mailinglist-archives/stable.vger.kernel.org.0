Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B431461DA6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378327AbhK2S1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:27:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59086 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbhK2SZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:25:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 962C0B815CC;
        Mon, 29 Nov 2021 18:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA15FC53FCD;
        Mon, 29 Nov 2021 18:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210102;
        bh=lIpb4fWq7jdC9OWXaSDFADr1ySAwdJ0R/GNsemv4Pxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOW/9Il583gDcopNcJNEet4uqizTvP+zOJx/uFG3au4l46abLVCXSffj+PNxqDanG
         o+kulW7lQ7P+7I8EtgTnztCnxiW5QcBQSjTi9fmwGX+AEI8LfaAi5utOv8vasMHjZ+
         eLN2XxBNnsuyBWckQIjN7EZXgtLsWJ1HrQMU+IUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 35/69] arm64: dts: marvell: armada-37xx: declare PCIe reset pin
Date:   Mon, 29 Nov 2021 19:18:17 +0100
Message-Id: <20211129181704.814043926@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a5470af981a0cc14a650af8da5186668971a4fc8 upstream.

One pin can be muxed as PCIe endpoint card reset.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -254,6 +254,15 @@
 					function = "mii";
 				};
 
+				pcie_reset_pins: pcie-reset-pins {
+					groups = "pcie1";
+					function = "pcie";
+				};
+
+				pcie_clkreq_pins: pcie-clkreq-pins {
+					groups = "pcie1_clkreq";
+					function = "pcie";
+				};
 			};
 
 			eth0: ethernet@30000 {


