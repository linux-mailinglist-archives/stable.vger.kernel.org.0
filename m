Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694C72E3D2E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438669AbgL1OMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439833AbgL1OMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C97F206E5;
        Mon, 28 Dec 2020 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164727;
        bh=bl8TsFUb7Ae1oj2PIweBEAL69R8mx+luOK8efIldbIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duiSP+U/xvmu3qCR/Vn5CgYEnpP+ki61OLiuSv6TGM7bbfgweWBsPjEdyv1+4AckU
         kUE05nx/dPuDD9jQvIL2YKnVYt3GWzaI6M6uNAbYd3KEqt9dNsi/nwctUr+NNvVv2J
         6O4Q6mdtTAHWL4f0Mf6oqoDCRCdMqdTZFNJV7bf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongjin Kim <tobetter@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/717] arm64: dts: meson-sm1: fix typo in opp table
Date:   Mon, 28 Dec 2020 13:44:03 +0100
Message-Id: <20201228125032.722413538@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongjin Kim <tobetter@gmail.com>

[ Upstream commit b6a1c8a1eaa73b1e2ae251399308e9445d74cef7 ]

The freqency 1512000000 should be 1500000000.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
Fixes: 3d9e76483049 ("arm64: dts: meson-sm1-sei610: enable DVFS")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20201130060320.GA30098@anyang-linuxfactory-or-kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
index 71317f5aada1d..c309517abae32 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
@@ -130,7 +130,7 @@
 			opp-microvolt = <790000>;
 		};
 
-		opp-1512000000 {
+		opp-1500000000 {
 			opp-hz = /bits/ 64 <1500000000>;
 			opp-microvolt = <800000>;
 		};
-- 
2.27.0



