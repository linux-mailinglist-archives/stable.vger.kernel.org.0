Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1DE3BCD14
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhGFLUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232546AbhGFLTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B98C61C92;
        Tue,  6 Jul 2021 11:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570215;
        bh=oufMQSq/HD270ct52SaTBS/clIfip/4ZbIOyx8NQw7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQBK8k+4ZgA45EkzNkgX2Adl4sxSDZFYLrY9vfDK+jNZxPIJMetFUrRIOyvtCCuwd
         CO8HfGIoofhpwXTKW0UabcFRKJ6stn0hCeqz2xBu+A7ILH7eVnT80cyAJqgjOAdwbz
         wMdGQ25porQwOpT7k/9SHHzBGLZlYG6Uc/9uhStbSmd1gPhbEKDW4+H0c9Vg45lVsK
         w4jvfLZa3ZW+FpwIXgr1V9/YHbQu5SnVsm0bIu0imARgdXkRAy5MG8gbehYcs6dQD2
         b+QMegP1SCYMuVO6VDvW1Ca9bfav2el+p3NNY5VhRQ7p36PMz8jRjnSuWSC+bA4b4i
         86dxvjPluA0Vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 124/189] net: fix mistake path for netdev_features_strings
Date:   Tue,  6 Jul 2021 07:13:04 -0400
Message-Id: <20210706111409.2058071-124-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index cfef6b08169a..67aa7134b301 100644
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

