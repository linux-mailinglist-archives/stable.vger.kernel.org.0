Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38122469ADF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348216AbhLFPLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59006 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347861AbhLFPJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:09:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8611D6132E;
        Mon,  6 Dec 2021 15:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC05C341C1;
        Mon,  6 Dec 2021 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803172;
        bh=Ik7W+lTWyzOnKO0uyQEQkeg1D/dDAlFK+D8do+1JhTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrdaMsfJB9usd+VLtHfJyBge+wkGJIWTuw6G3NkEhP+U+rJdWRZNCcOZv2iNYVmVJ
         Lw+ViNVLQfyWYBSppcij/GHAB0WodFH5s40SkUTYH+PCJgcU8kYqiKUt2zyGcfAA7V
         bLkn0bAfnUDh75yXE4v6BL8LEIdD4Q96MujksVvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 054/106] arm64: dts: marvell: armada-37xx: declare PCIe reset pin
Date:   Mon,  6 Dec 2021 15:56:02 +0100
Message-Id: <20211206145557.299428938@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
@@ -239,6 +239,15 @@
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


