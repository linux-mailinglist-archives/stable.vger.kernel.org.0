Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10ABF5758E
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfF0Aa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfF0Aa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:30:29 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7BC821726;
        Thu, 27 Jun 2019 00:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595428;
        bh=WBtRuunkqy7VHiWQi66iH6h4T9GOvP9bbqgjH6mURK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8Aveeh4IbPVJrvR8ZjGCPT7cKDLaHcYdp9gPcF7oG2evhe7FbFQm7iSRbcWRzI2E
         Gw6FtwYM5BbTKMO6BXJVt2JXuULNqGW2M8x+yK10BeD/L3a09z8ljfAl1/385yUZzy
         0jW+vWXBYlZ4Cg/c/KpnoRjukNv+8MzEZ/zcM14w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keerthy <j-keerthy@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 02/95] ARM: dts: dra76x: Disable usb4_tm target module
Date:   Wed, 26 Jun 2019 20:28:47 -0400
Message-Id: <20190627003021.19867-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

[ Upstream commit b07bd27e02b9108ce8412cc2dc6faf621f57d224 ]

usb4_tm is unsed on dra76 and accessing the module
with ti,sysc is causing a boot crash hence disable its target
module.

Fixes: 549fce068a3112 ("ARM: dts: dra7: Add l4 interconnect hierarchy and ti-sysc data")
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra76x.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dra76x.dtsi b/arch/arm/boot/dts/dra76x.dtsi
index 5c437271d307..82b3dc90b7d6 100644
--- a/arch/arm/boot/dts/dra76x.dtsi
+++ b/arch/arm/boot/dts/dra76x.dtsi
@@ -85,3 +85,7 @@
 &rtctarget {
 	status = "disabled";
 };
+
+&usb4_tm {
+	status = "disabled";
+};
-- 
2.20.1

