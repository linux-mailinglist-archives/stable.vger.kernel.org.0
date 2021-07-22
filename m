Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679433D29CC
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhGVQGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbhGVQFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 012AB61D1A;
        Thu, 22 Jul 2021 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972371;
        bh=qSQUeiNqGzPizAQIR+7xBEKODiOr8d6y2OCaRAjvHX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5EjzZs5pIE8xwn1JIqyjl9HLtO8XggSBmWXUMxIP153VAgERxi9gvJHMTxjuqhx6
         6gB1hqOxCB9fOQPutxuShzbj5Ucv5IXVLb2AkL9yv9C4eVL5FDrheqVfaW23j4HNyR
         T/YAdLTObuWXdDTUlIpvtIeW3aE4snplGecsCTfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Konstantin Porotchkin <kostap@marvell.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 089/156] arch/arm64/boot/dts/marvell: fix NAND partitioning scheme
Date:   Thu, 22 Jul 2021 18:31:04 +0200
Message-Id: <20210722155631.260846820@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -260,7 +260,7 @@
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



