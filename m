Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED84240E5D1
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhIPRPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350712AbhIPRMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A69161B52;
        Thu, 16 Sep 2021 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810304;
        bh=f8pBbr7HqnFL4jyxHyww6aECKwkv+rYhsDx2IJlqRfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgdCGziHQMd1T0IzT0N4In1JyqnFwfXpG1zqQyfVpJVo2p3ZMSxk6tGJAmAfB/fEv
         +1iVVn//Jeu/I7774wonkkT74Fz9Re0pfW3t339tCG3dnglkTyVewcXlvouaJ4Y+3W
         jrapqIA3Z6rEy1LNn/f8nvaYlgQVSMcaOqiXa6zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 090/432] vfio: Use config not menuconfig for VFIO_NOIOMMU
Date:   Thu, 16 Sep 2021 17:57:19 +0200
Message-Id: <20210916155813.832129707@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 67d0bf4efa16..e44bf736e2b2 100644
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



