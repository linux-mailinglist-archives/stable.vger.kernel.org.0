Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2973C8E5D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbhGNTre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236860AbhGNTqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F65613E8;
        Wed, 14 Jul 2021 19:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291764;
        bh=bJOeM4Fan3/lEmKugSFVzgY8cVs2vwVBou4cqklMHRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/5JoAjYetfk7ZZa6MQfWFaMNb6BAFsuLj/tDYEFlM+T8Zc3XElYlpcgPrdTPJ2JE
         DCzFS9g6L8K8TR7lTAXAY4c0h7P3LORKS91QgnkI+CyNYiHkNtMlq+AUspIIr9NKm5
         2U1Ep8oEJCioqECLqYbztBUQ+xlOmDzCt5tFed6iCDh+QX2els79vxjCOSJ3jULvmr
         PfgI/iGNDJG6zPn5fmpGNZ13SHJT/TJZ+6XeGxk6yXEO2sWtl15tLV7fLmczAh+PZa
         bRt0vr4snLpbfg/aw7WcM94xU8RyxNhpiaAmycLhwdgl/4v14VSa2ZpuGhO8HL5y7v
         +Kb3YBrW6pJIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Porotchkin <kostap@marvell.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 090/102] arch/arm64/boot/dts/marvell: fix NAND partitioning scheme
Date:   Wed, 14 Jul 2021 15:40:23 -0400
Message-Id: <20210714194036.53141-90-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 79020e6d2792..741ae534b477 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-db.dts
+++ b/arch/arm64/boot/dts/marvell/cn9130-db.dts
@@ -260,7 +260,7 @@ partition@0 {
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

