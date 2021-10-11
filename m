Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0178429176
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbhJKOTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243522AbhJKOQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9576103C;
        Mon, 11 Oct 2021 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961160;
        bh=Hf2n9xfbqFkxvyar5vNGFeR2VXs0Bc4gXJF2VAyjc10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnMmEmHoKrPM3odlSkuV2bLsQ2o/HDB+hyx4KlejYzYQbfM1Zc/O4fXeoYvpoHQXH
         a5LIMn/Czp4PG1OFiNYBGKCoUdTpI59T4ITl/y311tPVDx/bI59m28UOVqcsRdILid
         DnhDxFrTlI1xwg6r4KFmzw0Ti6zMvrEbzNA+mFwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Scott Wood <oss@buserror.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/28] powerpc/fsl/dts: Fix phy-connection-type for fm1mac3
Date:   Mon, 11 Oct 2021 15:47:06 +0200
Message-Id: <20211011134641.233158553@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit eed183abc0d3b8adb64fd1363b7cea7986cd58d6 ]

Property phy-connection-type contains invalid value "sgmii-2500" per scheme
defined in file ethernet-controller.yaml.

Correct phy-connection-type value should be "2500base-x".

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to the board device tree(s)")
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t1023rdb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/fsl/t1023rdb.dts b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
index 5ba6fbfca274..f82f85c65964 100644
--- a/arch/powerpc/boot/dts/fsl/t1023rdb.dts
+++ b/arch/powerpc/boot/dts/fsl/t1023rdb.dts
@@ -154,7 +154,7 @@
 
 			fm1mac3: ethernet@e4000 {
 				phy-handle = <&sgmii_aqr_phy3>;
-				phy-connection-type = "sgmii-2500";
+				phy-connection-type = "2500base-x";
 				sleep = <&rcpm 0x20000000>;
 			};
 
-- 
2.33.0



