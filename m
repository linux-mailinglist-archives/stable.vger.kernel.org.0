Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7CF4418E8
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhKAJww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhKAJut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D1361250;
        Mon,  1 Nov 2021 09:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759136;
        bh=S8Zl3YGuya6BPwQcEh8yn7Kgqhm1xbSXvm1AfuYOwZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5qMtY7E5li+Es7U6hm+cQTuJstj41zX/iAAhYycTBTsL9qTQTASFThA57IpPFXq+
         9jvh8yinqYKRHfVhC6FQ6XpjXBZwd3SKAPxOO+7mMnu+t7A0bz6HMixDqdOSYhL/+9
         snR5L1wHj3ciRwN/EbmG8XtFYvNOCdxicQ0//sNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 109/125] net: hns3: add more string spaces for dumping packets number of queue info in debugfs
Date:   Mon,  1 Nov 2021 10:18:02 +0100
Message-Id: <20211101082553.738114391@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 6754614a787cbcbf87bae8a75619c24a33ea6791 ]

As the width of packets number registers is 32 bits, they needs at most
10 characters for decimal data printing, but now the string spaces is not
enough, so this patch fixes it.

Fixes: e44c495d95e ("net: hns3: refactor queue info of debugfs")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 80461ab0ce9e..ce2fc283fe5c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -463,7 +463,7 @@ static const struct hns3_dbg_item rx_queue_info_items[] = {
 	{ "TAIL", 2 },
 	{ "HEAD", 2 },
 	{ "FBDNUM", 2 },
-	{ "PKTNUM", 2 },
+	{ "PKTNUM", 5 },
 	{ "COPYBREAK", 2 },
 	{ "RING_EN", 2 },
 	{ "RX_RING_EN", 2 },
@@ -566,7 +566,7 @@ static const struct hns3_dbg_item tx_queue_info_items[] = {
 	{ "HEAD", 2 },
 	{ "FBDNUM", 2 },
 	{ "OFFSET", 2 },
-	{ "PKTNUM", 2 },
+	{ "PKTNUM", 5 },
 	{ "RING_EN", 2 },
 	{ "TX_RING_EN", 2 },
 	{ "BASE_ADDR", 10 },
-- 
2.33.0



