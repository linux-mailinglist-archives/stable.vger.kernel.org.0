Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EC63D2825
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhGVPz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232742AbhGVPy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AA9E61370;
        Thu, 22 Jul 2021 16:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971733;
        bh=jzF89QLmygoj1LYAbcUOfTSNA7WwU8hx8sh7s6N9rhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcrCk9gLiJuFR1EcwdN17YGM0C5+Bgj7xCSYz/EM+QdVSPEj22aLMFkDRQW3x1EvR
         4Fr+u7IiCo9UNarZ22IxR6YXIbYrftwcOWk4bhKMsaNDlkOdxEtoY1PadiHA4GQ+nI
         2CgiASJXhENA5pM4Utj6Laxiz67S4fiLvSO3fQQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/71] arm64: dts: armada-3720-turris-mox: add firmware node
Date:   Thu, 22 Jul 2021 18:31:20 +0200
Message-Id: <20210722155619.369941821@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

[ Upstream commit 46d2f6d0c99f7f95600e633c7dc727745faaf95e ]

Add the node representing the firmware running on the secure processor.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index fad70c2df7bc..861469a439a5 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -106,6 +106,14 @@
 		/* enabled by U-Boot if SFP module is present */
 		status = "disabled";
 	};
+
+	firmware {
+		turris-mox-rwtm {
+			compatible = "cznic,turris-mox-rwtm";
+			mboxes = <&rwtm 0>;
+			status = "okay";
+		};
+	};
 };
 
 &i2c0 {
-- 
2.30.2



