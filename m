Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9174411C1F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346191AbhITRGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345356AbhITRCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 399396142A;
        Mon, 20 Sep 2021 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156824;
        bh=24UC7PLWD6SrIAkbHqkpVeN/iLXT7yHpDVdXhvaZLfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkdc67byAlthoH9tqho7QJPvVLBMIBLOEYA193yeHUgql1/vZeWsp4sGIqIeLF/S9
         AuMz8crbdGB22SzEO9PottMfx1U7md5k7O9JAaLbs69PfWvWGy4x9GfSMBxo6pUJyK
         ny9FN350rluj5vUxKGmKWYxDaNMWoqdZPPcmT+sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 101/175] vfio: Use config not menuconfig for VFIO_NOIOMMU
Date:   Mon, 20 Sep 2021 18:42:30 +0200
Message-Id: <20210920163921.377658999@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index da6e2ce77495..e5156b348669 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -31,7 +31,7 @@ menuconfig VFIO
 
 	  If you don't know what to do here, say N.
 
-menuconfig VFIO_NOIOMMU
+config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
 	depends on VFIO
 	help
-- 
2.30.2



