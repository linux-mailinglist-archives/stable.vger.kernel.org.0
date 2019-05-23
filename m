Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE0F2877F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389310AbfEWTUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388308AbfEWTUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0595205ED;
        Thu, 23 May 2019 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639202;
        bh=MJDx3NVKSGNVeTKAQU5Is+w+VaFezvqUHSFZbahXyHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR0LyqITWsPSfXK4Vsj+HsS/g3IhjLjnVDDXchesztPrFo+Bgkg4WjloO6pdWQfkp
         oMZkTKhyx6BjylHVe7Yr2IEHIdNLYZRCM/HkqDKBYLnKRwE039QJ3PbX6SyaTpLvBc
         EqKzmgE5XC5JXKRNMH+B1yE9ez1kaBH2t5HRGXpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 005/139] net/mlx4_core: Change the error print to info print
Date:   Thu, 23 May 2019 21:04:53 +0200
Message-Id: <20190523181720.940880617@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 00f9fec48157f3734e52130a119846e67a12314b ]

The error print within mlx4_flow_steer_promisc_add() should
be a info print.

Fixes: 592e49dda812 ('net/mlx4: Implement promiscuous mode with device managed flow-steering')
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -1492,7 +1492,7 @@ int mlx4_flow_steer_promisc_add(struct m
 	rule.port = port;
 	rule.qpn = qpn;
 	INIT_LIST_HEAD(&rule.list);
-	mlx4_err(dev, "going promisc on %x\n", port);
+	mlx4_info(dev, "going promisc on %x\n", port);
 
 	return  mlx4_flow_attach(dev, &rule, regid_p);
 }


