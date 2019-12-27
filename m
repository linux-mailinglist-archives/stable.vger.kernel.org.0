Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D9A12B84A
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfL0RmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfL0RmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C2A222C3;
        Fri, 27 Dec 2019 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468541;
        bh=Qf+Lke/xZRTcVCvZC0012unFzCPQGzOZY/o5doau+BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+IwSrXxzggoZKnoBNBGvM09Li3dGNxONPZGZ6DJycHxunIc0+ZLAIAZnei52zlW0
         hZtQQEJbxJLj1qptWTH3quoH9xDX2m+dXopcpm1xNihbGvrqH/fW5TtBnQ0b6AZvuz
         m9D7Sk1uSUJHJQvr1nXN6yZicN3HR44YBeMfdxbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Tang Yuantian <andy.tang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 070/187] arm64: dts: ls1028a: fix typo in TMU calibration data
Date:   Fri, 27 Dec 2019 12:38:58 -0500
Message-Id: <20191227174055.4923-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 961f8209c8d5ef5d33da42e6656d7c8179899da0 ]

The temperature sensor may jump backwards because there is a wrong
calibration value. Both values have to be monotonically increasing.
Fix it.

This was tested on a custom board.

Fixes: 571cebfe8e2b ("arm64: dts: ls1028a: Add Thermal Monitor Unit node")
Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Tang Yuantian <andy.tang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 72b9a75976a1..c7dae9ec17da 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -567,7 +567,7 @@
 					       0x00010004 0x0000003d
 					       0x00010005 0x00000045
 					       0x00010006 0x0000004d
-					       0x00010007 0x00000045
+					       0x00010007 0x00000055
 					       0x00010008 0x0000005e
 					       0x00010009 0x00000066
 					       0x0001000a 0x0000006e
-- 
2.20.1

