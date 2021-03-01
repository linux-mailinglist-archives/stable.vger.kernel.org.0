Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57582329034
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbhCAUDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242501AbhCATxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EFA3652E0;
        Mon,  1 Mar 2021 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621227;
        bh=w5o5FLlvgPbiXCH6avvyrccu7KGZ8pCYU6syZYNlnrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVRSeK/+HySDHfoprMxFkxGWXfmM/e0Cfn2/Uw54j1trzheMwvH3Qfkvxh9HTIcnQ
         DbnBqGJ22JW0/hJJd2oyuDgveeLXRToM9nl1wdaPhyCHF31bhaRHX4vRRXngIs9AEh
         hkvuDbkrw8m3EElyJsXR+R5h2jrcZd9Ps/t4sQwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 440/775] RDMA/hns: Disable RQ inline by default
Date:   Mon,  1 Mar 2021 17:10:08 +0100
Message-Id: <20210301161223.302786395@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index b8f6d5f706ddc..43ed927860569 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1883,7 +1883,6 @@ static void set_default_caps(struct hns_roce_dev *hr_dev)
 
 	caps->flags		= HNS_ROCE_CAP_FLAG_REREG_MR |
 				  HNS_ROCE_CAP_FLAG_ROCE_V1_V2 |
-				  HNS_ROCE_CAP_FLAG_RQ_INLINE |
 				  HNS_ROCE_CAP_FLAG_RECORD_DB |
 				  HNS_ROCE_CAP_FLAG_SQ_RECORD_DB;
 
-- 
2.27.0



