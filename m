Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE0B3B6A6A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbhF1V3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238235AbhF1V2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 17:28:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7E5C061226
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:25:02 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l8so14233011wry.13
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8CzmINE22J/G6oVXJn2tquSuDRBXIFlauL/4uoAgoHs=;
        b=lyqBKzasDq96bY5XfOEADr7rY9KHPA1VTcKzqD5DnyKuSqFtPWRLniZy0UxG39f/8q
         yTL7mTUpjCGG04xnPIVUwC6/FD7aH4X5shQeihBvkwvpkSVeHHCKkrSVyYJj8QOVl3hm
         vjBGoDUg/dwjiUDzuoIGyibQWeCeMVRZSjJD4BQycO56/zPNdxydP9tGaT6mOG/74IQB
         KYEuU10fPgRR5GG31MMpsPzvufdTxoalF2vM8jMfDkUKBmgizU20yYvcDw+VTJFuDjBN
         xuwSJ2xnPLUNpQqBnnrNvXWEFNYJx3NWPJrxv/skSfFe2V+ke/1SYGqiD+fdl9IwUk+l
         IVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8CzmINE22J/G6oVXJn2tquSuDRBXIFlauL/4uoAgoHs=;
        b=M1qdYER88xgJKoOx/+HKSo9RYFNTlMaqlLq1L+riAL8qMARcSYt3WEH6441DBEOvwY
         qvN6LGemcK01s6VPn7WLf/qIh4qOqJlOMf8UjERdVxYrb/vL6VqdzH56UyzujB94sWOa
         gaBDyimR4+OiVqyvaJvCKqS9VpAD2FmoFbixapnyZ52u4T9KNE5Qy69cjrO64uMaqwHD
         l1mg8zCw4eo+ieunWn9NfOsTmxjt9g6Ap34lsuQaOXQK5lqX+q/V7CtMP7Lu17sRSNd0
         JlrrHQRUDlRNzG7Jy5fpTpLVUsddnHDsomJRXYe3EaFHbq4c3uDjtYkK0mi7ZmyK3IsC
         yalA==
X-Gm-Message-State: AOAM5301rf4MavD7jyFItP/ZiQGuTlgun9fxmX9WRh6Sp3/JTE0yApQy
        fixhKEFMTkLgGvL21LVaJ0o=
X-Google-Smtp-Source: ABdhPJytxEqhy4CFQ7NjArUiD/EqJE024k6ZwPVw3KnxFP/h0Am+rsB1GG65nqrbZLSJPkqZSUnowg==
X-Received: by 2002:adf:c511:: with SMTP id q17mr18331941wrf.60.1624915501154;
        Mon, 28 Jun 2021 14:25:01 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id q5sm2060332wrx.57.2021.06.28.14.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 14:25:00 -0700 (PDT)
Date:   Mon, 28 Jun 2021 22:24:59 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mbloch@nvidia.com, jgg@nvidia.com, leonro@nvidia.com,
        maorg@nvidia.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] RDMA/mlx5: Block FDB rules when not in
 switchdev mode" failed to apply to 5.10-stable tree
Message-ID: <YNo+Kyd8bbGB6uAM@debian>
References: <1623589674120109@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXRJj+EPxd/jPNhf"
Content-Disposition: inline
In-Reply-To: <1623589674120109@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXRJj+EPxd/jPNhf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jun 13, 2021 at 03:07:54PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--OXRJj+EPxd/jPNhf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-RDMA-mlx5-Block-FDB-rules-when-not-in-switchdev-mode.patch"

From 5e9bf770efa4c52953454b983cfdcd5ebc3d003d Mon Sep 17 00:00:00 2001
From: Mark Bloch <mbloch@nvidia.com>
Date: Mon, 7 Jun 2021 11:03:12 +0300
Subject: [PATCH] RDMA/mlx5: Block FDB rules when not in switchdev mode

commit edc0b0bccc9c80d9a44d3002dcca94984b25e7cf upstream.

Allow creating FDB steering rules only when in switchdev mode.

The only software model where a userspace application can manipulate
FDB entries is when it manages the eswitch. This is only possible in
switchdev mode where we expose a single RDMA device with representors
for all the vports that are connected to the eswitch.

Fixes: 52438be44112 ("RDMA/mlx5: Allow inserting a steering rule to the FDB")
Link: https://lore.kernel.org/r/e928ae7c58d07f104716a2a8d730963d1bd01204.1623052923.git.leonro@nvidia.com
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[sudip: use old mlx5_eswitch_mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/infiniband/hw/mlx5/fs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 13d50b178166..b3391ecedda7 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2136,6 +2136,13 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (err)
 		goto end;
 
+	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    mlx5_eswitch_mode(dev->mdev->priv.eswitch) !=
+			      MLX5_ESWITCH_OFFLOADS) {
+		err = -EINVAL;
+		goto end;
+	}
+
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	atomic_set(&obj->usecnt, 0);
-- 
2.30.2


--OXRJj+EPxd/jPNhf--
