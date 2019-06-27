Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8173A57596
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfF0Aag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbfF0Aaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:30:35 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385B721726;
        Thu, 27 Jun 2019 00:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595434;
        bh=TYU7MJVlLbgtCu3sjGDET9yaRvf3aCgXu+2yQrNrfIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iu+WufGqPq5KW/LGkkBw32iEJIU7oc1lDPUK/yWss7XqkCYzgcopd2J0fJIhVtHi8
         oMb8DaQYgWbzoBLHw5pUECTHqtu8yqAUqQo015Re1fvYffQ2H+JQlmJar6yuePxZrt
         hNfQ7upQx/35zhGbJ4z0lmBJew9HUN4t7a+HT0Nw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keerthy <j-keerthy@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 04/95] ARM: dts: dra71x: Disable usb4_tm target module
Date:   Wed, 26 Jun 2019 20:28:49 -0400
Message-Id: <20190627003021.19867-4-sashal@kernel.org>
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

[ Upstream commit 34b1b8061de3215208db9accfe60cc3f5b40178f ]

usb4_tm is unsed on dra71 and accessing the module
with ti,sysc is causing a boot crash hence disable its target
module.

Fixes: 549fce068a3112 ("ARM: dts: dra7: Add l4 interconnect hierarchy and ti-sysc data")
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra71x.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dra71x.dtsi b/arch/arm/boot/dts/dra71x.dtsi
index aad7394902a6..695a08ed0360 100644
--- a/arch/arm/boot/dts/dra71x.dtsi
+++ b/arch/arm/boot/dts/dra71x.dtsi
@@ -11,3 +11,7 @@
 &rtctarget {
 	status = "disabled";
 };
+
+&usb4_tm {
+	status = "disabled";
+};
-- 
2.20.1

