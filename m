Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C19147DD3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389028AbgAXKDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:39166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388265AbgAXKDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:03:25 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15E11214DB;
        Fri, 24 Jan 2020 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860204;
        bh=2gLoL4rxof/UHV1wgyhkh9ljj0IUj1fXQyfEo7OIhRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2ynNE2Kt6cmRHrX+zwiX3PiCYjs6CU1aQWKdD5kd9DeHENKNGn+PT1ibNj5cqPQr
         5cArITaBUeEcbrR06fKXWaeUJyHoH5mVt6JjCfJjTVHy+NCs+/+QdwPkSQqD5hxHBX
         ctS9O/ndTPdcOk6HOeh+PX7LpnwB2oh7KlK34ppA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 266/343] net/mlx5: Fix mlx5_ifc_query_lag_out_bits
Date:   Fri, 24 Jan 2020 10:31:24 +0100
Message-Id: <20200124092954.972723244@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit ea77388b02270b0af8dc57f668f311235ea068f0 ]

Remove the "reserved_at_40" field to match the device specification.

Fixes: 84df61ebc69b ("net/mlx5: Add HW interfaces used by LAG")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1d793d86d55fa..6ffa181598e61 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8671,8 +8671,6 @@ struct mlx5_ifc_query_lag_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x40];
-
 	struct mlx5_ifc_lagc_bits ctx;
 };
 
-- 
2.20.1



