Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008D21C446B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbgEDSHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732104AbgEDSHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:07:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74534207DD;
        Mon,  4 May 2020 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615632;
        bh=cjiA2aoQ7vAk0PIsUJfA2z0tb4C6nX3WRSRkZbu7TFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RP6oYUOaJ6Ija9ChTr0vMsq9sv3nvrRYuYY2u6dXEICqYj8ZNkh2YRQKpymdFeaBd
         UutHnBkGB8twA3XmFCZRoaNQcYbXnR8VuTbiI4R8AyV7aeJ0/CXLLMuRMBTlJUXcYR
         Mz4LUaajnNn4qz4hxGtvdNvhpM9vbcehEpdCDj20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5.6 60/73] iommu: Properly export iommu_group_get_for_dev()
Date:   Mon,  4 May 2020 19:58:03 +0200
Message-Id: <20200504165509.795667242@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit ae74c19faa7d7996e857e13165bd40fc4a285e0d upstream.

In commit a7ba5c3d008d ("drivers/iommu: Export core IOMMU API symbols to
permit modular drivers") a bunch of iommu symbols were exported, all
with _GPL markings except iommu_group_get_for_dev().  That export should
also be _GPL like the others.

Fixes: a7ba5c3d008d ("drivers/iommu: Export core IOMMU API symbols to permit modular drivers")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200430120120.2948448-1-gregkh@linuxfoundation.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1428,7 +1428,7 @@ struct iommu_group *iommu_group_get_for_
 
 	return group;
 }
-EXPORT_SYMBOL(iommu_group_get_for_dev);
+EXPORT_SYMBOL_GPL(iommu_group_get_for_dev);
 
 struct iommu_domain *iommu_group_default_domain(struct iommu_group *group)
 {


