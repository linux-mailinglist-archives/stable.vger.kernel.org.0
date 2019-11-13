Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC777FA356
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfKMB7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:59:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727677AbfKMB7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C5622473;
        Wed, 13 Nov 2019 01:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610378;
        bh=prXEgeBzUWkQNvhLuQjaWuLFvngDSuk8BMs3Vtu2gTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zoy50IepG3OdXZOC3HjnwKNoNKW+BU6jc7wPLrUHrQjwKjIGFYSvPB+mV78ds2N93
         RLIilza2o2k/WnDF3GWlXTDTx9Doj9b7QpK9f093hffKuh7pMA0UQIPRi63v4vaVTi
         Au9V3DuNqkfUrwXL8PD4ImH+SnpShG/C0GSgmGtw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Roger Quadros <rogerq@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/68] ARM: dts: omap5: enable OTG role for DWC3 controller
Date:   Tue, 12 Nov 2019 20:58:27 -0500
Message-Id: <20191113015932.12655-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit 656c1a65ab555ee5c7cd0d6aee8ab82ca3c1795f ]

Since SMPS10 and OTG cable detection extcon are described here, and
work to enable OTG power when an OTG cable is plugged in, we can
define OTG mode in the controller (which is disabled by default in
omap5.dtsi).

Tested on OMAP5EVM and Pyra.

Suggested-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap5-board-common.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index 4caadb2532497..3e9e3d90f2b4f 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -694,6 +694,10 @@
 	vbus-supply = <&smps10_out1_reg>;
 };
 
+&dwc3 {
+	dr_mode = "otg";
+};
+
 &mcspi1 {
 
 };
-- 
2.20.1

