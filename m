Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDAB299E9C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411552AbgJ0AKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411550AbgJ0AKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF7E20791;
        Tue, 27 Oct 2020 00:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757433;
        bh=96qkF3OVvKbNjSRVzcNNdUCeRvK4nfDw20DQkavEE5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4c4+KbgnxmVHyBx19MVElPEp+JccEtjpEqQSp8l5XwWdrCCf3FbJV3efhSSsy5Wu
         5+yx/HTIXyZ3xm9ADvXu39uCz4Qhati2bjeU6KMb7tE21Py6Z8agSFh67GWP66eFHQ
         cQQhcQ+LSekrFm/7oVO/cLp3bOxY0cy+SkGXWPLc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 39/46] arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes
Date:   Mon, 26 Oct 2020 20:09:38 -0400
Message-Id: <20201027000946.1026923-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
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
index e95d99265af9d..38f846530fcde 100644
--- a/arch/arm64/boot/dts/renesas/ulcb.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb.dtsi
@@ -397,6 +397,7 @@ &sdhi2 {
 	bus-width = <8>;
 	mmc-hs200-1_8v;
 	non-removable;
+	full-pwr-cycle-in-suspend;
 	status = "okay";
 };
 
-- 
2.25.1

