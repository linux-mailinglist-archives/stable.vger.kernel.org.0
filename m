Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B584F3C8F98
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbhGNTw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240248AbhGNTth (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA587613F2;
        Wed, 14 Jul 2021 19:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291896;
        bh=Xe1YxtBwK5MDibkRq5gzYlM4QXbTY8HByV5XQO5CWhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSjibXeQL1AAuTY6AhdtggvNtxoWW0fdJi/7GKbxN8qIL/TgqcUMk8rHvHDE02FJe
         Dk/AvXVlnUA3Mm1q3jityxnD8HD7l37dNkxBDat02VDkSEmnn2emJEoq9JbwhzBPhG
         UKoZOvnJ2SDor9LFhQhl5PguNQr+ffU+6TtYTGynDB8EVEjPFJdiicLTwqNAz6DyiK
         8fMv9vudmKuppkMfGNgZCqOVPoqCaH/PDaquyjwbdw3YBdLU9HluWcxQzCjwPVf2vx
         Ll7PAdunf3BrCbALSLkPtyMp1lQHG/HBVj5lRH9WNizoIdOOOGfSao37BzCwgqwT1s
         +unWct8GFdkRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Porotchkin <kostap@marvell.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 76/88] arch/arm64/boot/dts/marvell: fix NAND partitioning scheme
Date:   Wed, 14 Jul 2021 15:42:51 -0400
Message-Id: <20210714194303.54028-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Porotchkin <kostap@marvell.com>

[ Upstream commit e3850467bf8c82de4a052619136839fe8054b774 ]

Eliminate 1MB gap between Linux and filesystem partitions.

Signed-off-by: Konstantin Porotchkin <kostap@marvell.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/cn9130-db.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9130-db.dts b/arch/arm64/boot/dts/marvell/cn9130-db.dts
index ce49a70d88a0..d24294888400 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-db.dts
+++ b/arch/arm64/boot/dts/marvell/cn9130-db.dts
@@ -258,7 +258,7 @@ partition@0 {
 			};
 			partition@200000 {
 				label = "Linux";
-				reg = <0x200000 0xd00000>;
+				reg = <0x200000 0xe00000>;
 			};
 			partition@1000000 {
 				label = "Filesystem";
-- 
2.30.2

