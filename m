Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4A528A70
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387948AbfEWTOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387468AbfEWTO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:14:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D12217D7;
        Thu, 23 May 2019 19:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638868;
        bh=MJDx3NVKSGNVeTKAQU5Is+w+VaFezvqUHSFZbahXyHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1r74pPQN4Bw2vyb7q0FQ2uJ9vabUwn1F64bCozFoPfc6fmPOh2F+l5AMb2alUzkUM
         1znDXYN/EN1VTNXgmqaT/NW9TVcQz/A1lnGukklYJ4/9Bmqy2eQrd3ZQBhoGOtK/AW
         kncgvGR9QIkHmhvgv1fz1Nva9J+5FM2ft0OO2cQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 005/114] net/mlx4_core: Change the error print to info print
Date:   Thu, 23 May 2019 21:05:04 +0200
Message-Id: <20190523181731.994925501@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
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


