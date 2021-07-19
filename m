Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ABA3CDEFE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245014AbhGSPHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345695AbhGSPEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345926112D;
        Mon, 19 Jul 2021 15:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709501;
        bh=1fOpBQFPGJh3jYfnNThexnAEFH4o1IaAuITIQp2BZdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdO71O6ZLC/R9iillcCu/1m6hZT3BufG1m281bopyA2LWnxtZpy4697pJyaGxJfqz
         7W51p+3OUB+F6zIW8keMV/Zs6I1zlAUzSuyb/VBzlM6CXv4rNZwlPmPsv2zc57zYFI
         LpFkcfq7+46/rSu1twOgmtfk8k9oEPHIs/8UOTVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 410/421] ARM: dts: am335x: align ti,pindir-d0-out-d1-in property with dt-shema
Date:   Mon, 19 Jul 2021 16:53:41 +0200
Message-Id: <20210719145000.533096425@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 414bfe1d26b60ef20b58e36efd5363188a694bab ]

ti,pindir-d0-out-d1-in property is expected to be of type boolean.
Therefore, fix the property accordingly.

Fixes: 444d66fafab8 ("ARM: dts: add spi wifi support to cm-t335")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-cm-t335.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-cm-t335.dts b/arch/arm/boot/dts/am335x-cm-t335.dts
index 947c81b7aaaf..56a04d3086c3 100644
--- a/arch/arm/boot/dts/am335x-cm-t335.dts
+++ b/arch/arm/boot/dts/am335x-cm-t335.dts
@@ -552,7 +552,7 @@ status = "okay";
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&spi0_pins>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 	/* WLS1271 WiFi */
 	wlcore: wlcore@1 {
 		compatible = "ti,wl1271";
-- 
2.30.2



