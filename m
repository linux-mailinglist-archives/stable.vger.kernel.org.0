Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1533A3BD537
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhGFMTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237190AbhGFLf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64B6E61EB2;
        Tue,  6 Jul 2021 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570765;
        bh=p0xEP71v2pVTXpsAnPOnIZadJ9WCWIox2A3wpKBA9TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTNmns3MnnxZrYBRo5Flfqx3BEfn/Vv6PyA06o6A+4GzB8IQTKQgVGuL8Qkeu046Q
         RsgucXOH27BEZL9JMumMuQnMQBeRmmxQggRu3W6U/Y4oPPLU5zzSjoQsueq9zr9nzF
         M/UPRbAIzFSL+XlqqxU2ph18ggQsYvmZ6eU12pvYouYou08a6YuSLWeu/pkCgzRCBm
         U03ozADCZ0nsbzmPHgpQ+ImV+Th5B9igBY9I+Wrnl29M2FAU+QtmyHtxB3edvKFw5+
         tNQ+xBFCnjtxFkGP8DFZWDW+M8iPThnGG5tp+mNPRqO0/7cNR2UX6NnUjXm8ZgUDve
         aoT+Xwx6sogZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 49/74] net: fix mistake path for netdev_features_strings
Date:   Tue,  6 Jul 2021 07:24:37 -0400
Message-Id: <20210706112502.2064236-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 4b19c544c59a..640e7279f161 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -83,7 +83,7 @@ enum {
 
 	/*
 	 * Add your fresh new feature above and remember to update
-	 * netdev_features_strings[] in net/core/ethtool.c and maybe
+	 * netdev_features_strings[] in net/ethtool/common.c and maybe
 	 * some feature mask #defines below. Please also describe it
 	 * in Documentation/networking/netdev-features.txt.
 	 */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 7857aa413627..8d465e5322e7 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -223,7 +223,7 @@ enum tunable_id {
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
-	 * tunable_strings[] in net/core/ethtool.c
+	 * tunable_strings[] in net/ethtool/common.c
 	 */
 	__ETHTOOL_TUNABLE_COUNT,
 };
@@ -287,7 +287,7 @@ enum phy_tunable_id {
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

