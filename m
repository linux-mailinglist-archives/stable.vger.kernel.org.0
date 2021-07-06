Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EF23BCFA1
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhGFLa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235208AbhGFL3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D820261D97;
        Tue,  6 Jul 2021 11:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570444;
        bh=3uC1IbFr2lkzY3C+U2Tiset1LD7mESzC9mOCdlJVX9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8KCNZeB0Je7zNMFwxJ5RNsPHWDROIMaPpRi9micHc2rKdc7kHz0BF7p/34chozjm
         wtCYf/p6kS8RR/zpOd+nlmI8PmLCpKWt0XJsCzzMUG/Obg9GkZeTYZ4AkHShKsA5qY
         dSLBMIvD4O7SMVgv/zW8bWLg2NOPCx8SY8Ryr+liLyrtSp6QtBRgxoZhdb/fyENRdy
         VBGmnLs2BOgRRGADPrAqJfZfzs6SR3TJzSXbQB522jTQ7/pxerOQOSVMGxIdGTEbCW
         AluVMJMLlhb75yVXPjSzwaIcEeofqhHhhDZsWV6uQzlpdCiZEnqXGJuHF2WKKXs7OU
         n7VS6THo/j7bQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 103/160] net: fix mistake path for netdev_features_strings
Date:   Tue,  6 Jul 2021 07:17:29 -0400
Message-Id: <20210706111827.2060499-103-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 2d8ea148e553e1dd4e80a87741abdfb229e2b323 ]

Th_strings arrays netdev_features_strings, tunable_strings, and
phy_tunable_strings has been moved to file net/ethtool/common.c.
So fixes the comment.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdev_features.h | 2 +-
 include/uapi/linux/ethtool.h    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 3de38d6a0aea..2c6b9e416225 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -93,7 +93,7 @@ enum {
 
 	/*
 	 * Add your fresh new feature above and remember to update
-	 * netdev_features_strings[] in net/core/ethtool.c and maybe
+	 * netdev_features_strings[] in net/ethtool/common.c and maybe
 	 * some feature mask #defines below. Please also describe it
 	 * in Documentation/networking/netdev-features.rst.
 	 */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 5afea692a3f7..e36eee9132ec 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -233,7 +233,7 @@ enum tunable_id {
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
-	 * tunable_strings[] in net/core/ethtool.c
+	 * tunable_strings[] in net/ethtool/common.c
 	 */
 	__ETHTOOL_TUNABLE_COUNT,
 };
@@ -297,7 +297,7 @@ enum phy_tunable_id {
 	ETHTOOL_PHY_EDPD,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
-	 * phy_tunable_strings[] in net/core/ethtool.c
+	 * phy_tunable_strings[] in net/ethtool/common.c
 	 */
 	__ETHTOOL_PHY_TUNABLE_COUNT,
 };
-- 
2.30.2

