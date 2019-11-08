Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D190F5690
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390875AbfKHTJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387473AbfKHTJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 165C920673;
        Fri,  8 Nov 2019 19:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240171;
        bh=OXmoZ/TWD6LZqVx1L4vvIYRknEyGU+4n20yrJlDuKC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6kVIkRXDonK1t93AxZxW1XbHfcUBjbx7inn28Bh+N99FgPARB8VjyUgtcijV4glW
         ts2DTyBJLe6I+3LOIjL6vtKnM4YMWkGfilyPVNjmswbHLx7JV+rXzOBKilQHxgrVo9
         5Qb1qStqU/Ubvr3MfQfqlK/o1fP/tHDf5LI/wP6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 111/140] net/mlx5e: Remove incorrect match criteria assignment line
Date:   Fri,  8 Nov 2019 19:50:39 +0100
Message-Id: <20191108174911.851934326@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit 752d3dc06d6936d5a357a18b6b51d91c7e134e88 ]

Driver have function, which enable match criteria for misc parameters
in dependence of eswitch capabilities.

Fixes: 4f5d1beadc10 ("Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -285,7 +285,6 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_es
 
 	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
 
-	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
 	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 


