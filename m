Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911CF2E3B2E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405170AbgL1NrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405215AbgL1NqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EAC4205CB;
        Mon, 28 Dec 2020 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163163;
        bh=fwBLQeDKWm/gijYIvp7pqIRjCPCBrcfO3wPwOpA3iSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kI6cX9sG+/twXfWOvBn961jp3Z/4qhz/y3BbNIgOmbCJZvWguQnrjEBr+vjUi8WPv
         Xl3tXWDdDg5g7OLV3c3n3QNhD7X5oM5tECxv10Mkq6L+TOyMzBjeCxSaYxJfYAsvWv
         oWDIzVS4M6/ZZP8dqAcsKVvyowO0UStJ/WMwU6+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongjin Kim <tobetter@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/453] arm64: dts: meson-sm1: fix typo in opp table
Date:   Mon, 28 Dec 2020 13:47:08 +0100
Message-Id: <20201228124946.451092296@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 521573f3a5bab..8ba3555ca3693 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
@@ -90,7 +90,7 @@
 			opp-microvolt = <790000>;
 		};
 
-		opp-1512000000 {
+		opp-1500000000 {
 			opp-hz = /bits/ 64 <1500000000>;
 			opp-microvolt = <800000>;
 		};
-- 
2.27.0



