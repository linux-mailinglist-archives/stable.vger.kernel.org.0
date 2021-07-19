Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4153CDDFE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345148AbhGSPBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344412AbhGSO7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D27A260551;
        Mon, 19 Jul 2021 15:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709206;
        bh=NYdkv1krDDvfASXYqmGKcEbFBMGcWOv8+irBhrGseyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRNRuapE/OPvDtDM6xL4u/xNxc/GJBdi1RQ99BSBLVXfhAoI4TspiqdfMSfwsZlfz
         5ZJujs80Icy/0s/xCFP7ddus1uWnOtwcRD8EDOSnMucjMRdauSuNef3gpIJBqWWPJU
         G94O3FAMVeVJUwneyq9BxjD6fihFGZmsUM4myIZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 258/421] net: fix mistake path for netdev_features_strings
Date:   Mon, 19 Jul 2021 16:51:09 +0200
Message-Id: <20210719144955.339703482@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



