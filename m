Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E383C8D25
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhGNTnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235846AbhGNTnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10F8C613DC;
        Wed, 14 Jul 2021 19:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291618;
        bh=JxfxbU+hWiQO2Ji+lo8fLwh1c+vG9CbvECsWFUbwYN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWAd9gQPk6PVC22Zx0qE9eDPuNVKtB6AjjmbOn5XW+ffLn9xKIXteUVYByR4sryxP
         NTjSk67RV1Df3D5bhc0PH9flb7Li3zPvyrHHOcd9/ByoRvVBjnsgrawSW+EraZBwFl
         LVv4aLIKyOXYX9rlWwukRV6XWljCvrMktUhKZbU5y7CHIxZ1YPG1OZThgwezk0FNMD
         4Oq2708xnY6hzYwppqadOUtwVwnKQeWq55UcKI3dM6QCik8I4LnbeTNfjR2HlPhu5b
         yhL65QhtL1to+SaqCto+BJaG+OCloWQs1BmiQFElECsnM7zRS7s/r8axWhwkDW1c7D
         nlWEfBcvbSuAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Porotchkin <kostap@marvell.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 096/108] arch/arm64/boot/dts/marvell: fix NAND partitioning scheme
Date:   Wed, 14 Jul 2021 15:37:48 -0400
Message-Id: <20210714193800.52097-96-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 2c2af001619b..9758609541c7 100644
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

