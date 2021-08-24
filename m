Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB96D3F670D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbhHXRaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239430AbhHXR1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D11561B4F;
        Tue, 24 Aug 2021 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824708;
        bh=k1ZvagljKZjVAmbbmEIG7ecGJya4hyULOpISnKeN52I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUZAJQM8F9ZRjiOidDI183zizPq45eFbSqqrZOR24VkRlM044Alspk23z8ik+DTkA
         k8FTAzXI5g9FCQYq7EgYmGKv3/s6JCxY6iYqkfGtRROJflXIh/FIE5CuaPVPSGRBDO
         1exc8/rQNtnQ/bXcZaZRtZXYHNImh9CAji14t1MuFT++f72tg1jdpCC7pKnEv7qS6b
         p0mEgpw00xoiIkgSVTsjb56RZq8eVE6XISW96RykkQhKYzKaV2EvcKdIV/K3oia4jQ
         5b6Hbh9nLMYTljGskrrhoSDxU395cpvJmrwb/ORwOVODNsE28+CV669jsP3xPX3jk+
         MiNJQbyA6XGaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/64] net: dsa: mt7530: add the missing RxUnicast MIB counter
Date:   Tue, 24 Aug 2021 13:04:03 -0400
Message-Id: <20210824170457.710623-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

[ Upstream commit aff51c5da3208bd164381e1488998667269c6cf4 ]

Add the missing RxUnicast counter.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 58c16aa00a70..fdfef3a7c05a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -54,6 +54,7 @@ static const struct mt7530_mib_desc mt7530_mib[] = {
 	MIB_DESC(2, 0x48, "TxBytes"),
 	MIB_DESC(1, 0x60, "RxDrop"),
 	MIB_DESC(1, 0x64, "RxFiltering"),
+	MIB_DESC(1, 0x68, "RxUnicast"),
 	MIB_DESC(1, 0x6c, "RxMulticast"),
 	MIB_DESC(1, 0x70, "RxBroadcast"),
 	MIB_DESC(1, 0x74, "RxAlignErr"),
-- 
2.30.2

