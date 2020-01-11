Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EED13800D
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbgAKKYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgAKKYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:24:52 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D392082E;
        Sat, 11 Jan 2020 10:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738292;
        bh=Qf+Lke/xZRTcVCvZC0012unFzCPQGzOZY/o5doau+BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsmBMEjK+8lBU+Y6scCXiESPZz7p1y+maKl7q1qUiUodCkX2lPgXzUH9lLscxD0Ga
         d2N/pWf14caEety/HchXHCmmXEHFIGgt2X/hOsG1kobM69DZwwaZRGE1fmeKCKPLVh
         GsPxQ74bVjiUXdlR3luLOIpwdRXlLA121EUvA+d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Tang Yuantian <andy.tang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/165] arm64: dts: ls1028a: fix typo in TMU calibration data
Date:   Sat, 11 Jan 2020 10:49:31 +0100
Message-Id: <20200111094925.721232525@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



