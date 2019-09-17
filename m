Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C1B4A97
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfIQJev convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 17 Sep 2019 05:34:51 -0400
Received: from smtpbgeu1.qq.com ([52.59.177.22]:54182 "EHLO smtpbgeu1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfIQJeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 05:34:50 -0400
X-QQ-mid: bizesmtp18t1568712881txwjnsga
Received: from [192.168.142.168] (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 17 Sep 2019 17:34:27 +0800 (CST)
X-QQ-SSF: 00400000000000R0YS90000D0000000
X-QQ-FEAT: 8B8Qf6pKBE4LQyqDf+4LV1Lt7vh3J4kB5d3e0/bdRHOxz2dJwLYtEgX6ijcP4
        vL2FwiSXHfKtA4wq2JdIut/KDa6xzpQnIHRek0G7+tuzhKvWeaXHrKNgmXiZMm049VtTSjR
        Ore9O5WSUlf4WuBdC89Unvs3C+V9fvCm+sV7MzG+ZjPL5TZcxRld15k0rjl978uzE3UDyg7
        TmdZqci7bLUBG3JNnQz+t/6WibNEY5grGc3R34p9rWu6k0jDXsQeOYamIPfOR/Jo5ZtZsNi
        ztnLWdKk7y5YTsJUQe8i1hSmo2snZHqbZd5A6I2bY3WgjjbFVganIVP08emyvgv2jwxyAQB
        4wI1BndUOHOtFz57bRO/q73yC2YSjcGy1UEd3sx
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 3/4] CVE-2018-20855: IB/mlx5: Fix leaking stack memory to
 userspace
From:   Jackie Liu <liuyun01@kylinos.cn>
In-Reply-To: <1568712761-11089-3-git-send-email-liuyun01@kylinos.cn>
Date:   Tue, 17 Sep 2019 17:34:40 +0800
Cc:     nh <nh@kylinos.cn>, Jason Gunthorpe <jgg@mellanox.com>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <025DCFF3-79C4-43F0-9041-B05EE4E2958A@kylinos.cn>
References: <1568712761-11089-1-git-send-email-liuyun01@kylinos.cn>
 <1568712761-11089-3-git-send-email-liuyun01@kylinos.cn>
To:     =?gb2312?B?zfXn+Q==?= <wangqi@kylinos.cn>
X-Mailer: Apple Mail (2.3445.104.11)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign1
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> 在 2019年9月17日，17:32，Jackie Liu <liuyun01@kylinos.cn> 写道：
> 
> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> mlx5_ib_create_qp_resp was never initialized and only the first 4 bytes
> were written.
> 
> Fixes: 41d902cb7c32 ("RDMA/mlx5: Fix definition of mlx5_ib_create_qp_resp")
> Cc: <stable@vger.kernel.org>
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
> drivers/infiniband/hw/mlx5/qp.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index cfcfbb6..359d41e 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -861,7 +861,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
> {
> 	struct mlx5_ib_resources *devr = &dev->devr;
> 	struct mlx5_core_dev *mdev = dev->mdev;
> -	struct mlx5_ib_create_qp_resp resp;
> +	struct mlx5_ib_create_qp_resp resp = {};
> 	struct mlx5_create_qp_mbox_in *in;
> 	struct mlx5_ib_create_qp ucmd;
> 	int inlen = sizeof(*in);
> -- 
> 2.7.4
> 

Sorry for noise, please ignore.

--
BR, Jackie Liu



