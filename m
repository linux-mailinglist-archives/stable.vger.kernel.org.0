Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A84412189
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358389AbhITSG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357042AbhITSCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B42960724;
        Mon, 20 Sep 2021 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158195;
        bh=JTiJ3Q3fzfU6kaUZkZcHRz0g2+ncquoX769DCbGqaGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZz5Drq5F5UWllgKL34pVSRxc8zM+0x+4wf8I0g2FXgkraWDYWTSz++/eLYt6Fm2a
         EQ9hyF+xTV0dCYYq/+BmpTw5wrcY0QbomRmG+0h0SQkt+wFKY743L3FZ++hfjrj9Rc
         EQ33q8QPH2g9VumOIpYf8RruD1Bs+2NXxeOnfEqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/260] vfio: Use config not menuconfig for VFIO_NOIOMMU
Date:   Mon, 20 Sep 2021 18:41:01 +0200
Message-Id: <20210920163932.578895079@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 503ed2f3fbb5..65743de8aad1 100644
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



