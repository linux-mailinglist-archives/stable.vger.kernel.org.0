Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342B2328C7B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbhCASxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240387AbhCASqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A19C9652C9;
        Mon,  1 Mar 2021 17:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620304;
        bh=E0cr/6ezm6nBvKdVtXE2sJ7xXAo5B1hcNrNsFh/WUDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrwmnDsoA0xMTcNsckJQYoKcfYzFbhXidYSrxavzlHEdpf6QlbPpTrfeUcPsPApk6
         TtK0a75GLvvoPBK0/MVh/xBs5ViLSMKRDd0xRGUC1dRPdWtlGrg5i+SGLdcD68jyp9
         LP71RmV/C+tx8O90zjsfervoWMCQ9P0FQLfkuLt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 074/775] arm64: dts: armada-3720-turris-mox: rename u-boot mtd partition to a53-firmware
Date:   Mon,  1 Mar 2021 17:04:02 +0100
Message-Id: <20210301161205.334513357@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit a9d9bfcadfb43b856dbcf9419de75f7420d5a225 ]

The partition called "u-boot" in reality contains TF-A and U-Boot, and
TF-A is before U-Boot.

Rename this parition to "a53-firmware" to avoid confusion for users,
since they cannot simply build U-Boot from U-Boot repository and flash
the resulting image there. Instead they have to build the firmware with
the sources from the mox-boot-builder repository [1] and flash the
a53-firmware.bin binary there.

[1] https://gitlab.nic.cz/turris/mox-boot-builder

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 7109d817db2e ("arm64: dts: marvell: add DTS for Turris Mox")
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index f5ec3b6447692..d239ab70ed995 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -205,7 +205,7 @@
 			};
 
 			partition@20000 {
-				label = "u-boot";
+				label = "a53-firmware";
 				reg = <0x20000 0x160000>;
 			};
 
-- 
2.27.0



