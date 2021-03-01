Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF0328E23
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhCATYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241275AbhCATSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C943164D9F;
        Mon,  1 Mar 2021 17:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619221;
        bh=0Bj6jkepFvalWN4bbnXrH3BtdvbFGpqRk8uahqSJUhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5bG60P+I4MA17cdV6EkDJYYaxXo6Z0esaJ+JM6SNyRnVSxhNWB9l00dEcr5E54xV
         j+wKzAOPNVkc/FqnDNrvXSfGLWS/q0k0UC1r2RYh+7PiVdRa5OGF+feW+dwbf5Pl7S
         8pOuTuZJgSR6gmc+9L3MhsXqSzvNg3KGrC/wrR1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/663] RDMA/hns: Disable RQ inline by default
Date:   Mon,  1 Mar 2021 17:10:07 +0100
Message-Id: <20210301161159.616073308@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 7373de9adb19aebed2781d3fdde576533d626d7a ]

This feature should only be enabled by querying capability from firmware.

Fixes: ba6bb7e97421 ("RDMA/hns: Add interfaces to get pf capabilities from firmware")
Link: https://lore.kernel.org/r/1612517974-31867-5-git-send-email-liweihang@huawei.com
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5c29c7d8c50e6..69621e84986d7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1847,7 +1847,6 @@ static void set_default_caps(struct hns_roce_dev *hr_dev)
 
 	caps->flags		= HNS_ROCE_CAP_FLAG_REREG_MR |
 				  HNS_ROCE_CAP_FLAG_ROCE_V1_V2 |
-				  HNS_ROCE_CAP_FLAG_RQ_INLINE |
 				  HNS_ROCE_CAP_FLAG_RECORD_DB |
 				  HNS_ROCE_CAP_FLAG_SQ_RECORD_DB;
 
-- 
2.27.0



