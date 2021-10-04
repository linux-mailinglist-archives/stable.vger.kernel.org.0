Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398F2420ED2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhJDN24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236807AbhJDN04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADBE361B03;
        Mon,  4 Oct 2021 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353111;
        bh=n1iMFi3qYPp87o4hpS9JNJE+tU12TEkyUSgPj85JqEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/fxAOVri1WBLDF246SnpdPmlE1iiG4P+nhsKGPL+4cLwkxvPkfj1ydGDkRSd1vfz
         gkHtbo3D9ULdisw5LAbUvqwU0SZIBknihRdpnuMPJ7ESX6/riKQ5VbmfVnM+QnBfU9
         P1BqZYpCTqvHNSEomjSePnnvqg00jTjQRL87zcxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 60/93] net: hns3: fix prototype warning
Date:   Mon,  4 Oct 2021 14:52:58 +0200
Message-Id: <20211004125036.550832349@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit a1e144d7dc3c55aa4d451e3a23cd8f34cd65ee01 ]

Correct a report warning in hns3_ethtool.c

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c0aa3be0cdfb..0aee100902ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -301,7 +301,7 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 }
 
 /**
- * hns3_nic_self_test - self test
+ * hns3_self_test - self test
  * @ndev: net device
  * @eth_test: test cmd
  * @data: test result
-- 
2.33.0



