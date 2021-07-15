Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011813CA5F0
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhGOSpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236166AbhGOSpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 687AC613CA;
        Thu, 15 Jul 2021 18:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374548;
        bh=p0xEP71v2pVTXpsAnPOnIZadJ9WCWIox2A3wpKBA9TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpnWgeihpXbdriwnQpi/oAjXuUiIguRJZoVTNLEA1uKrOsphu/y+jPz7HN+Nnu8ZG
         e8Lqt2xX6oRsTac+eyTmT4Htd/YoQYoNc1R694iGlMcBKu/Nf8nx2pnGlxkWFUSKml
         aGoKyS63AliJ/y6s6LrwNKUfmaGdO/QwY9Nx0XN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/122] net: fix mistake path for netdev_features_strings
Date:   Thu, 15 Jul 2021 20:38:13 +0200
Message-Id: <20210715182500.651274299@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
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



