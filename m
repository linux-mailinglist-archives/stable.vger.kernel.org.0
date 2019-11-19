Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB4101890
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKSFZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:25:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbfKSFZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:25:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAAED21783;
        Tue, 19 Nov 2019 05:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141124;
        bh=OqJpgqnNucTIjc1sie5sJ+o2au5E86wgHQZUsNmr+LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glxXgbDf1Isc3xtPvRERvWPSZmGjKIugZUedT+1Uk/VNS2Qr0/bKriC85tlVlxZM5
         Nv4kWcCdh7eo3BPjt2r6/xj6x2fjKK4FrEyk97n+n+Ac1JY5DgIAeZossB6ApA7Jde
         P8F1dDecAp3es2yaVoWMCRe+aQcxR+pelu88aNag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/422] remoteproc/davinci: Use %zx for formating size_t
Date:   Tue, 19 Nov 2019 06:14:08 +0100
Message-Id: <20191119051403.137683234@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 1e28dbbeced6152b9ea7c417ff8cef3f7dcf0f19 ]

da8xx_rproc_mem size is of type size_t, so use %zx to format the debug
print of it to avoid a compile warning.

Acked-by: Suman Anna <s-anna@ti.com>
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/da8xx_remoteproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/da8xx_remoteproc.c b/drivers/remoteproc/da8xx_remoteproc.c
index e230bef71be1c..d200334577f68 100644
--- a/drivers/remoteproc/da8xx_remoteproc.c
+++ b/drivers/remoteproc/da8xx_remoteproc.c
@@ -226,7 +226,7 @@ static int da8xx_rproc_get_internal_memories(struct platform_device *pdev,
 				res->start & DA8XX_RPROC_LOCAL_ADDRESS_MASK;
 		drproc->mem[i].size = resource_size(res);
 
-		dev_dbg(dev, "memory %8s: bus addr %pa size 0x%x va %p da 0x%x\n",
+		dev_dbg(dev, "memory %8s: bus addr %pa size 0x%zx va %p da 0x%x\n",
 			mem_names[i], &drproc->mem[i].bus_addr,
 			drproc->mem[i].size, drproc->mem[i].cpu_addr,
 			drproc->mem[i].dev_addr);
-- 
2.20.1



