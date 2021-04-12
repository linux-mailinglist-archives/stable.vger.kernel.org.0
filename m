Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85635C07C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbhDLJN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240606AbhDLJKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4572A61391;
        Mon, 12 Apr 2021 09:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218349;
        bh=O/x923Ua/aCxnAlLUK8NTTGSTkG40YPZNM/h21AGjmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pks+CGAG74Evjvh8d+NIPuU7Yh9yHhds8XQ1jIPC1bcAdfNArU/kXUqtoUeSt8rEH
         hFA/EvJ/xUUbQFXbNOm625YobFwohohMZmXVBzgbemRPuainwq0vCY7io5bfKaEMMo
         czJA3OstXUm6JZ4ciCd9HmE74VpxHyxKvCsoPU0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Klaus Kudielka <klaus.kudielka@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 163/210] ARM: dts: turris-omnia: fix hardware buffer management
Date:   Mon, 12 Apr 2021 10:41:08 +0200
Message-Id: <20210412084021.466517940@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Salvaterra <rsalvaterra@gmail.com>

[ Upstream commit 5b2c7e0ae762fff2b172caf16b2766cc3e1ad859 ]

Hardware buffer management has never worked on the Turris Omnia, as the
required MBus window hadn't been reserved. Fix thusly.

Fixes: 018b88eee1a2 ("ARM: dts: turris-omnia: enable HW buffer management")

Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-turris-omnia.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index b0f3fd8e1429..5bd6a66d2c2b 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -32,7 +32,8 @@
 		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x100000
 			  MBUS_ID(0x01, 0x1d) 0 0xfff00000 0x100000
 			  MBUS_ID(0x09, 0x19) 0 0xf1100000 0x10000
-			  MBUS_ID(0x09, 0x15) 0 0xf1110000 0x10000>;
+			  MBUS_ID(0x09, 0x15) 0 0xf1110000 0x10000
+			  MBUS_ID(0x0c, 0x04) 0 0xf1200000 0x100000>;
 
 		internal-regs {
 
-- 
2.30.2



