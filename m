Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575F73BD2CE
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbhGFLkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237398AbhGFLgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AD8561CBE;
        Tue,  6 Jul 2021 11:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570842;
        bh=NYdkv1krDDvfASXYqmGKcEbFBMGcWOv8+irBhrGseyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxIY7jTMoQyKrjdHnOpaKdGpCFtuMbl/NMvcWyqW/4gH/gtqJzHxy5WZHo0L+AEEP
         HyN3vDaBe3o0/1ok43GnCv6NoSgmOLb4NiJjC2JfmymjkTahsiDwiP4z6vMO7kiKxn
         IOfa5YIBBaG9CcBe11mdaJ9xZ1hdmBdb1EMiiu6BH5U7phQsAXIiV+FQRJsQukjtiF
         rzIT1koc/LQ2liSuKC21wTF9dhuCCxx3EtHAg8Vl8/IFnO9VvaZluzTAVKbTb7arTX
         48+JdTVzyFVRqsvHJgkRVcNKZTgdAV8TFuyVFAW5VwAoxYDGywy2F1h+ZfzECsoZ30
         ZagmVxbn5bKNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 35/55] net: fix mistake path for netdev_features_strings
Date:   Tue,  6 Jul 2021 07:26:18 -0400
Message-Id: <20210706112638.2065023-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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
index 4c76fe2c8488..2a8105d204a9 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -88,7 +88,7 @@ enum {
 
 	/*
 	 * Add your fresh new feature above and remember to update
-	 * netdev_features_strings[] in net/core/ethtool.c and maybe
+	 * netdev_features_strings[] in net/ethtool/common.c and maybe
 	 * some feature mask #defines below. Please also describe it
 	 * in Documentation/networking/netdev-features.txt.
 	 */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index fc21d3726b59..35b11c246aeb 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -227,7 +227,7 @@ enum tunable_id {
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
-	 * tunable_strings[] in net/core/ethtool.c
+	 * tunable_strings[] in net/ethtool/common.c
 	 */
 	__ETHTOOL_TUNABLE_COUNT,
 };
@@ -261,7 +261,7 @@ enum phy_tunable_id {
 	ETHTOOL_PHY_DOWNSHIFT,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
-	 * phy_tunable_strings[] in net/core/ethtool.c
+	 * phy_tunable_strings[] in net/ethtool/common.c
 	 */
 	__ETHTOOL_PHY_TUNABLE_COUNT,
 };
-- 
2.30.2

