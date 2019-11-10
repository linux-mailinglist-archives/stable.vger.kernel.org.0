Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5C2F65DD
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfKJDKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:10:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbfKJCoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B908C21D7F;
        Sun, 10 Nov 2019 02:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353857;
        bh=7O0a6f7OAljtZm3g5vT7cbtIr3K62GbeufgrYTkBfgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nO1Uxd33YQ/JxXjRxk8UgVpSYQT2sBdCE3zyzV54oZDUuGEQMGEFQ//w1ybBrwbuY
         VL8cWZj9vd436AJED96mdc4pFQ5LCTJgFi7As43p11fWMaw4HrnXSEpEFFmjGV5Olp
         KfCylIr2zZoUsvoVDfo6Oi8E71ztNqLdf0dk+6iQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Dietrich <marvin24@gmx.de>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 142/191] ARM: dts: paz00: fix wakeup gpio keycode
Date:   Sat,  9 Nov 2019 21:39:24 -0500
Message-Id: <20191110024013.29782-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dietrich <marvin24@gmx.de>

[ Upstream commit ebea2a43fdafdbce918bd7e200b709d6c33b9f3b ]

The power key is controlled solely by the EC, which only tiggeres this
gpio after wakeup.
Fixes immediately return to suspend after wake from LP1.

Signed-off-by: Marc Dietrich <marvin24@gmx.de>
Tested-by: Nicolas Chauvet <kwizart@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-paz00.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index ef245291924f0..4f9b4a889febe 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -524,10 +524,10 @@
 	gpio-keys {
 		compatible = "gpio-keys";
 
-		power {
-			label = "Power";
+		wakeup {
+			label = "Wakeup";
 			gpios = <&gpio TEGRA_GPIO(J, 7) GPIO_ACTIVE_LOW>;
-			linux,code = <KEY_POWER>;
+			linux,code = <KEY_WAKEUP>;
 			wakeup-source;
 		};
 	};
-- 
2.20.1

