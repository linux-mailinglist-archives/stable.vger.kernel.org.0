Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680EB3B6A6D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhF1Vai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbhF1VaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 17:30:02 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59849C06114D
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:26:28 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id p8-20020a7bcc880000b02901dbb595a9f1so953769wma.2
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 14:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ui5LwDqe36oZepEmMCehlJ7iM8m12iad1EaOX0VKCQw=;
        b=dTDHmZ1kXXEHLyd/7iTK3ei6SJ+SxTITR7T7fiJHcOMGm9vOgR34A9uKaVR8+eSxDN
         MpG7YDEen8jA2TSW4ePhU75RYKxwa5WxlLajO1HyWcGF7YdvCtTidU1ZAYeKVLF3rG3q
         lzETqiV59uqeE+uEvqpwzR7Mop6FwmD4fYd9QK73zlTP/TDYKAsInetXo52YMY3c/esz
         MAHllHNf2EGwEmt1QDOrBE1FtyyqOHMWgeIXVaVpwIGbXch06OR7Zt7F6qnv5VudsI4P
         djGn/CCED0lWXh7PW2wO7VOGjax9zybw0QgosQq8HSqJvAH4qlxRCcOs9JfbU1c0E6VO
         UQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ui5LwDqe36oZepEmMCehlJ7iM8m12iad1EaOX0VKCQw=;
        b=rdkwvv9D0aCrNbh5c60MljraC8xntBQ2lOGV5lmPA5prymN6AWUDJV74UAiqBTgNYC
         1oe6nNjFIZEan/9Vw9dzTzzYwT00X1nR1fbc+euhy+2OJM0gTaWwxdot5gMK2TN2Kxrv
         z5JctITa59IBB+GYZI78+ZkqZF3qUR48jIPu/xjVRUUnc2HsfNRV/hK1bC7WrwGr4R1m
         l6wCNX6oUAu81zwF03HD6BTyxPhtoh8QErswSkEyN76wQV1PlYHs9RYM0K1nFE6SQy1G
         9UKjJJdOxUxOmh1EVYdww8bC4K8qOCZMkXJgIkOg2bQ5sJQoSCI7K/h9cFL+6XE0+nn4
         voGA==
X-Gm-Message-State: AOAM5301lhUchr8gwl1eG4PV7BH1MqA9lp7A5IrOldCULwcfPXjTW/W1
        FPYOIasnYqgcJE7o7DZ2YbI=
X-Google-Smtp-Source: ABdhPJy4i+VFniwT5xbm9J7fyaFH/HnFipi+PmEhAhuhTH8ep55BdXRAb6ygNiFP8t3P8ARLzihcZQ==
X-Received: by 2002:a1c:80d6:: with SMTP id b205mr899365wmd.178.1624915586913;
        Mon, 28 Jun 2021 14:26:26 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id o11sm14332436wmq.1.2021.06.28.14.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 14:26:26 -0700 (PDT)
Date:   Mon, 28 Jun 2021 22:26:24 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mbloch@nvidia.com, jgg@nvidia.com, leonro@nvidia.com,
        maorg@nvidia.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] RDMA/mlx5: Block FDB rules when not in
 switchdev mode" failed to apply to 5.4-stable tree
Message-ID: <YNo+gN6wsXXy9DjX@debian>
References: <162358893110067@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6KOhrSPBlQ5PUvTm"
Content-Disposition: inline
In-Reply-To: <162358893110067@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6KOhrSPBlQ5PUvTm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jun 13, 2021 at 02:55:31PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--6KOhrSPBlQ5PUvTm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-RDMA-mlx5-Block-FDB-rules-when-not-in-switchdev-mode.patch"

From 6c68435634bb5608e5ac4a215c8feb0c77c707ce Mon Sep 17 00:00:00 2001
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
[sudip: manually backport to old file]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/infiniband/hw/mlx5/flow.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index b198ff10cde9..fddefb29efd7 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -13,6 +13,7 @@
 #include <rdma/ib_umem.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/eswitch.h>
 #include "mlx5_ib.h"
 
 #define UVERBS_MODULE_NAME mlx5_ib
@@ -316,6 +317,13 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
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


--6KOhrSPBlQ5PUvTm--
