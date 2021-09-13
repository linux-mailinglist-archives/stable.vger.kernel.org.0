Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94974091C0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243709AbhIMOFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244824AbhIMOCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1190F61A2C;
        Mon, 13 Sep 2021 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540298;
        bh=neG9+V7kBLXXADzbNuhl5BYEGqzNe5F6hzZ9xdcCcdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw+Gwibkq9oyDQtQCs4RAvqinqgk6u29qQqe2tKCC85SP260dsHuKk6lPqGMKENET
         +NpcOwnsIJ85UXv+iTvb1JOGku2bkuccRJZPOdlR890XCczVyt2mYCqReMmZPHN6Zk
         cVHW1mOjMVeXL1lYiT5nwZPxzgjOUZCYz2v9JRaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 136/300] arm64: dts: renesas: hihope-rzg2-ex: Add EtherAVB internal rx delay
Date:   Mon, 13 Sep 2021 15:13:17 +0200
Message-Id: <20210913131113.994265202@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit c96ca5604a889a142d6b60889cc6da48498806e9 ]

Hihope boards use Realtek PHY. From the very beginning it use only
tx delays. However the phy driver commit bbc4d71d63549bcd003
("net: phy: realtek: fix rtl8211e rx/tx delay config") introduced
NFS mount failure. Now it needs rx delay inaddition to tx delay
for NFS mount to work. This patch fixes NFS mount failure issue
by adding MAC internal rx delay.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Fixes: bbc4d71d63549bcd ("net: phy: realtek: fix rtl8211e rx/tx delay config")
Link: https://lore.kernel.org/r/20210721180632.15080-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
index 202c4fc88bd5..dde3a07bc417 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
@@ -20,6 +20,7 @@
 	pinctrl-names = "default";
 	phy-handle = <&phy0>;
 	tx-internal-delay-ps = <2000>;
+	rx-internal-delay-ps = <1800>;
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
-- 
2.30.2



