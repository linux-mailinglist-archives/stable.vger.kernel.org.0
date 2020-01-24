Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B661481A5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391097AbgAXLVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390482AbgAXLVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:39 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C853206D4;
        Fri, 24 Jan 2020 11:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864899;
        bh=kLbLYvgpjUmzYqazPB/FtGEwIj5t2l6eKOHjxntnehU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7FYUREcwgpJlzN5HlYPIOxCG8kF+SGP8D0SEBLYSY72z24kydxWrOVgqdF1QXXB0
         px4ShVMY+SfcNI+1onRbWOmhekKW9ZUEwqufyoGekv0KPAD+aBU2OENAw+a+n8v9rT
         1h66cwgvZ5YZyLLXnqLtoxxNCrIz+0UkqTQYXOiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 396/639] iommu: Add missing new line for dma type
Date:   Fri, 24 Jan 2020 10:29:26 +0100
Message-Id: <20200124093136.532707211@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 24f307d8abf79486dd3c1b645037df7d91602aaa ]

So that all types are printed in the same format.

Fixes: c52c72d3dee81 ("iommu: Add sysfs attribyte for domain type")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ee25ec22778ef..b82bec4224b91 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -317,7 +317,7 @@ static ssize_t iommu_group_show_type(struct iommu_group *group,
 			type = "unmanaged\n";
 			break;
 		case IOMMU_DOMAIN_DMA:
-			type = "DMA";
+			type = "DMA\n";
 			break;
 		}
 	}
-- 
2.20.1



