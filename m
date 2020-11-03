Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9C92A39CA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgKCB17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:27:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgKCBS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:18:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8C6222EC;
        Tue,  3 Nov 2020 01:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366336;
        bh=cQKBuozStwVPabIxB53pg1BlJKITloUGrYVj4iHkxPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwikQhIAW+h5BE28iv0a9/YikrbXj5t6v5WTSU+0IIz3NhnHW2hDgV3RdQmBySNyE
         xPVXwz4n2BuA40MXWQ2GRMmHkNtbhSzFDF3ble9AAVzTmKiVLdQEdYM/8/3NY4hzL8
         Oyir9DaYqT492WlHDcDiEcWifjh8BSxhiDXyeR/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 11/35] ARM: dts: mmp3: Add power domain for the camera
Date:   Mon,  2 Nov 2020 20:18:16 -0500
Message-Id: <20201103011840.182814-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 202f8e5c4975a95babf3bcdfb2c18952f06b030a ]

The camera interfaces on MMP3 are on a separate power island that needs
to be turned on for them to operate and, ideally, turned off when the
cameras are not in use.

This hooks the power island with the camera interfaces in the device
tree.

Link: https://lore.kernel.org/r/20200925234805.228251-2-lkundrak@v3.sk
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/mmp3.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/mmp3.dtsi b/arch/arm/boot/dts/mmp3.dtsi
index cc4efd0efabd2..4ae630d37d094 100644
--- a/arch/arm/boot/dts/mmp3.dtsi
+++ b/arch/arm/boot/dts/mmp3.dtsi
@@ -296,6 +296,7 @@ camera0: camera@d420a000 {
 				interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&soc_clocks MMP2_CLK_CCIC0>;
 				clock-names = "axi";
+				power-domains = <&soc_clocks MMP3_POWER_DOMAIN_CAMERA>;
 				#clock-cells = <0>;
 				clock-output-names = "mclk";
 				status = "disabled";
@@ -307,6 +308,7 @@ camera1: camera@d420a800 {
 				interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&soc_clocks MMP2_CLK_CCIC1>;
 				clock-names = "axi";
+				power-domains = <&soc_clocks MMP3_POWER_DOMAIN_CAMERA>;
 				#clock-cells = <0>;
 				clock-output-names = "mclk";
 				status = "disabled";
-- 
2.27.0

