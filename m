Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C553D28AC
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhGVP6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhGVP5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 254BE61370;
        Thu, 22 Jul 2021 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971894;
        bh=CL5KckW+kN8oGBCeBdyBLw8PzDaItvwdA3yenFxbSGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0i6G5VylHYOr6z5s6D7EG+FpJ7VqH6ljnXjT8QowJpgA0izjJ9TfOMqPZ4hWSO7+3
         QHP32qd7QG3DiWYCQDrZcbmS19O+pWC0x3yeREQbSujw0fEhPD/o86MQ4E2KT+AZ/f
         iJZaRUFuQXn4+pal2+filJX7PKaGlAA/NTvafr4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/125] ARM: dts: stm32: Remove extra size-cells on dhcom-pdk2
Date:   Thu, 22 Jul 2021 18:30:31 +0200
Message-Id: <20210722155626.027071752@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 28b9a4679d8074512f12967497c161b992eb3b75 ]

Fix make dtbs_check warning:
arch/arm/boot/dts/stm32mp157c-dhcom-pdk2.dt.yaml: gpio-keys-polled: '#address-cells' is a dependency of '#size-cells'
arch/arm/boot/dts/stm32mp157c-dhcom-pdk2.dt.yaml: gpio-keys: '#address-cells' is a dependency of '#size-cells'

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 8456f172d4b1..180a0187a956 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -34,7 +34,6 @@
 
 	gpio-keys-polled {
 		compatible = "gpio-keys-polled";
-		#size-cells = <0>;
 		poll-interval = <20>;
 
 		/*
@@ -60,7 +59,6 @@
 
 	gpio-keys {
 		compatible = "gpio-keys";
-		#size-cells = <0>;
 
 		button-1 {
 			label = "TA2-GPIO-B";
-- 
2.30.2



