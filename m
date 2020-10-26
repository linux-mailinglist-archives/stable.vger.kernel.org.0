Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7761F299C9D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437166AbgJ0AAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436571AbgJZX4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F389221FA;
        Mon, 26 Oct 2020 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756602;
        bh=ijSyz/hPHxWjmDDbgMyFJoLONPNpCbVKlRy8CQz4Bgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIg43W35ddG8v9bBXfSiGQVkfEWhv5UozcB1l1nGfhfk5ZHSuJVlxhQKZ2X6PqqLm
         peocsqPnMroveJ7o8axEeju2DLALYRURQ30I52BuSZNBe9Dl/SMIft2auPJS6TdQVA
         Pi8ZNyFjGuhNlAyPHyMkLTAq03KnfBrVyZj0H+Zc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 71/80] arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes
Date:   Mon, 26 Oct 2020 19:55:07 -0400
Message-Id: <20201026235516.1025100-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 992d7a8b88c83c05664b649fc54501ce58e19132 ]

Add full-pwr-cycle-in-suspend property to do a graceful shutdown of
the eMMC device in system suspend.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1594989201-24228-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/ulcb.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/ulcb.dtsi b/arch/arm64/boot/dts/renesas/ulcb.dtsi
index 3ef89171538ff..d8fccf3d4987a 100644
--- a/arch/arm64/boot/dts/renesas/ulcb.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb.dtsi
@@ -470,6 +470,7 @@ &sdhi2 {
 	mmc-hs200-1_8v;
 	mmc-hs400-1_8v;
 	non-removable;
+	full-pwr-cycle-in-suspend;
 	status = "okay";
 };
 
-- 
2.25.1

