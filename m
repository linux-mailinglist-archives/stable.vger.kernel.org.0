Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE36411FFD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353492AbhITRrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349177AbhITRpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D04D361B7D;
        Mon, 20 Sep 2021 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157809;
        bh=IJXmMi4lmu7gdq6d9FMZW0CwpdUgNeecZgwFTiNG7Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7JOy/upWrImZ/fY0Fe9MnfoS/pQ8uN7JZwsy2y3MlW7653yvzftvRir1ntDIHe6X
         8eFa7dtMr9cjm9yPClCz+tJjn79NJtyiKxwht6BQObmkdpAaXQ7Ga2cL5WNvhS8guA
         jMXAqFE/9aEjAozkQKHalM+zsoRPVOwiGtgEbozA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/293] vfio: Use config not menuconfig for VFIO_NOIOMMU
Date:   Mon, 20 Sep 2021 18:42:03 +0200
Message-Id: <20210920163938.799465667@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 26c22cfde5dd6e63f25c48458b0185dcb0fbb2fd ]

VFIO_NOIOMMU is supposed to be an element in the VFIO menu, not start
a new menu. Correct this copy-paste mistake.

Fixes: 03a76b60f8ba ("vfio: Include No-IOMMU mode")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/0-v1-3f0b685c3679+478-vfio_menuconfig_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index c84333eb5eb5..b7765271d0fb 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -29,7 +29,7 @@ menuconfig VFIO
 
 	  If you don't know what to do here, say N.
 
-menuconfig VFIO_NOIOMMU
+config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
 	depends on VFIO
 	help
-- 
2.30.2



