Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451731FDB6C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgFRBLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbgFRBLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B61CF21924;
        Thu, 18 Jun 2020 01:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442693;
        bh=1GHEktr/FGZJLGxJRB9jHKx37ExbftyAROwdmO92/to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRo+xIWUceqgRKC+HTHebBzVPHj4eK2s8puR8I1+wjZhzxR0m0bPvtHGwl0iRwJ1G
         XMhFNMB3okpdubvLaW8bsp0XJOnYolxCiXajPcij71JP7Pz5yaF/Rt0xyRisAXthcQ
         /LifQeFIW72+b/Hmuq0iBTsCQ/Wk2KfO0p4oCwPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 158/388] arm64: dts: meson-g12b-ugoos-am6: fix board compatible
Date:   Wed, 17 Jun 2020 21:04:15 -0400
Message-Id: <20200618010805.600873-158-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 5c28dcbb3a1be167c07784b5f710ec602a57bea2 ]

Add missing amlogic,s922x in the board compatible list.

It fixes:
meson-g12b-ugoos-am6.dt.yaml: /: compatible: ['ugoos,am6', 'amlogic,g12b'] is not valid under any of the given schemas

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20200326165958.19274-4-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts b/arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts
index 06c5430eb92d..fdaacfd96b97 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts
@@ -14,7 +14,7 @@
 #include <dt-bindings/sound/meson-g12a-tohdmitx.h>
 
 / {
-	compatible = "ugoos,am6", "amlogic,g12b";
+	compatible = "ugoos,am6", "amlogic,s922x", "amlogic,g12b";
 	model = "Ugoos AM6";
 
 	aliases {
-- 
2.25.1

