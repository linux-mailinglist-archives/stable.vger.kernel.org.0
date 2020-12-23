Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6622E16A4
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgLWDAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbgLWCT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB89206EC;
        Wed, 23 Dec 2020 02:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689976;
        bh=zRH9S+A7nqD/PgK6wNXM/NUjpJqcyUYTYVa3oHScwtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWfurFNyJjLG0nPT/70DT+X2kg25kkoAqNZMzP5mblmNMq+Dhg20iZDbHexUyOLJI
         7xT+017OOaiOcQLHnb08RUQG4gHtebCNqdFKhNmvzcTWouduGjwIR1xXjMXjpK539D
         AcVo4kFRNEJAh7TiAonPZAfBXWKZtSdStVIsPR1S/hpMM1sSsCX3PSU1Inohf4VqT8
         szwi3BHIyJjUZ2JmcJNB67/8FkSF1mBewk5j9iF5y7yoUPZo8MzBH0mQUKSfEWPIdd
         XtH5Oa4cIfBV/y9Fo3RGz8Ev2mNCtAaJm7rb9lbdqQe4MVCYJgWJw0WMwG9pUkl4lK
         3yiqNedVUvW7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 064/130] ARM: dts: hisilicon: fix errors detected by simple-bus.yaml
Date:   Tue, 22 Dec 2020 21:17:07 -0500
Message-Id: <20201223021813.2791612-64-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 8e9e8dd7ce093344a89792deaeb6caedde636dcf ]

Change bus node name from "amba" to "amba-bus" to match
'^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/hi3620-hi4511.dts | 2 +-
 arch/arm/boot/dts/hi3620.dtsi       | 2 +-
 arch/arm/boot/dts/hip01.dtsi        | 2 +-
 arch/arm/boot/dts/hisi-x5hd2.dtsi   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/hi3620-hi4511.dts b/arch/arm/boot/dts/hi3620-hi4511.dts
index 1c62bdcca647a..29eedc7fef986 100644
--- a/arch/arm/boot/dts/hi3620-hi4511.dts
+++ b/arch/arm/boot/dts/hi3620-hi4511.dts
@@ -22,7 +22,7 @@ memory {
 		reg = <0x40000000 0x20000000>;
 	};
 
-	amba {
+	amba-bus {
 		dual_timer0: dual_timer@800000 {
 			status = "ok";
 		};
diff --git a/arch/arm/boot/dts/hi3620.dtsi b/arch/arm/boot/dts/hi3620.dtsi
index cb7e932e094f6..fa3a287c50b5a 100644
--- a/arch/arm/boot/dts/hi3620.dtsi
+++ b/arch/arm/boot/dts/hi3620.dtsi
@@ -63,7 +63,7 @@ cpu@3 {
 		};
 	};
 
-	amba {
+	amba-bus {
 
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/boot/dts/hip01.dtsi b/arch/arm/boot/dts/hip01.dtsi
index fd09e6d9309c7..2a79636053900 100644
--- a/arch/arm/boot/dts/hip01.dtsi
+++ b/arch/arm/boot/dts/hip01.dtsi
@@ -35,7 +35,7 @@ soc {
 		interrupt-parent = <&gic>;
 		ranges = <0 0x10000000 0x20000000>;
 
-		amba {
+		amba-bus {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			compatible = "simple-bus";
diff --git a/arch/arm/boot/dts/hisi-x5hd2.dtsi b/arch/arm/boot/dts/hisi-x5hd2.dtsi
index da42b9400759b..f9daee9392506 100644
--- a/arch/arm/boot/dts/hisi-x5hd2.dtsi
+++ b/arch/arm/boot/dts/hisi-x5hd2.dtsi
@@ -30,7 +30,7 @@ soc {
 		interrupt-parent = <&gic>;
 		ranges = <0 0xf8000000 0x8000000>;
 
-		amba {
+		amba-bus {
 			#address-cells = <1>;
 			#size-cells = <1>;
 			compatible = "simple-bus";
-- 
2.27.0

