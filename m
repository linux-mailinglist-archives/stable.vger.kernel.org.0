Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BF3150BCC
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgBCQac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729684AbgBCQa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:28 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9331F2087E;
        Mon,  3 Feb 2020 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747428;
        bh=aF/BTm/ry3ZPezd9ZAZKJhW2hopoqOnb4lMGR5HlmH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVYmGd9wEWmMVZahj4iEp+qTgFWc7B/TZFcODzt93dLGjMCsxJZhbhnpfFNzEOdpa
         7F3wFsVFDUKc88fBYbc/AUWdNF5/4DJudr02FQ+ivx4/5FTYgq4Vvc8SquAFr9Asqh
         jkHBmfxPEt7WieQZEnwPHONBjWnxQw8mEp2HMpEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 80/89] powerpc/fsl/dts: add fsl,erratum-a011043
Date:   Mon,  3 Feb 2020 16:20:05 +0000
Message-Id: <20200203161926.600817290@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>

[ Upstream commit 73d527aef68f7644e59f22ce7f9ac75e7b533aea ]

Add fsl,erratum-a011043 to internal MDIO buses.
Software may get false read error when reading internal
PCS registers through MDIO. As a workaround, all internal
MDIO accesses should ignore the MDIO_CFG[MDIO_RD_ER] bit.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi             | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi              | 1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi              | 1 +
 18 files changed, 18 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
index e1a961f05dcd5..baa0c503e741b 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi
@@ -63,6 +63,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy0: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
index c288f3c6c6378..93095600e8086 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi
@@ -60,6 +60,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy6: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
index 94f3e71750124..ff4bd38f06459 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi
@@ -63,6 +63,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy1: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
index 94a76982d214b..1fa38ed6f59e2 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi
@@ -60,6 +60,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy7: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
index b5ff5f71c6b8b..a8cc9780c0c42 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy0: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
index ee44182c63485..8b8bd70c93823 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy1: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
index f05f0d775039b..619c880b54d8d 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe5000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy2: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
index a9114ec510759..d7ebb73a400d0 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe7000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy3: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
index 44dd00ac7367f..b151d696a0699 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe9000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy4: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
index 5b1b84b58602f..adc0ae0013a3c 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi
@@ -59,6 +59,7 @@ fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xeb000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy5: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
index 0e1daaef9e74b..435047e0e250e 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi
@@ -60,6 +60,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy14: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
index 68c5ef779266a..c098657cca0a7 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi
@@ -60,6 +60,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xf3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy15: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
index 605363cc1117f..9d06824815f34 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy8: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
index 1955dfa136348..70e947730c4ba 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy9: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
index 2c1476454ee01..ad96e65295959 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe5000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy10: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
index b8b541ff5fb03..034bc4b71f7a5 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe7000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy11: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
index 4b2cfddd1b155..93ca23d82b39b 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xe9000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy12: ethernet-phy@0 {
 			reg = <0x0>;
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
index 0a52ddf7cc171..23b3117a2fd2a 100644
--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi
@@ -59,6 +59,7 @@ fman@500000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xeb000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
 
 		pcsphy13: ethernet-phy@0 {
 			reg = <0x0>;
-- 
2.20.1



