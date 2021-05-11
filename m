Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D60C37A412
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 11:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhEKJzM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 May 2021 05:55:12 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5099 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhEKJzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 05:55:11 -0400
Received: from dggeml713-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FfY912jvlzYgPT;
        Tue, 11 May 2021 17:51:33 +0800 (CST)
Received: from dggpemm100008.china.huawei.com (7.185.36.125) by
 dggeml713-chm.china.huawei.com (10.3.17.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 11 May 2021 17:54:00 +0800
Received: from dggpeml500016.china.huawei.com (7.185.36.70) by
 dggpemm100008.china.huawei.com (7.185.36.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 11 May 2021 17:54:00 +0800
Received: from dggpeml500016.china.huawei.com ([7.185.36.70]) by
 dggpeml500016.china.huawei.com ([7.185.36.70]) with mapi id 15.01.2176.012;
 Tue, 11 May 2021 17:54:00 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Jason Wang" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 0/3] crypto: virtio: Fix three  issues                   
Thread-Topic: [PATCH v3 0/3] crypto: virtio: Fix three  issues                   
Thread-Index: AQHXRkk0w4OU06xmfEyPSVletHG+xareB7SA
Date:   Tue, 11 May 2021 09:54:00 +0000
Message-ID: <4bd6e679041046a58d18e84f0ce33d26@huawei.com>
References: <20210511093654.596-1-longpeng2@huawei.com>
In-Reply-To: <20210511093654.596-1-longpeng2@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

misoperation, sorry for that, please ignore.

> -----Original Message-----
> From: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> Sent: Tuesday, May 11, 2021 5:37 PM
> To: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> <longpeng2@huawei.com>
> Cc: Gonglei (Arei) <arei.gonglei@huawei.com>; Herbert Xu
> <herbert@gondor.apana.org.au>; Michael S. Tsirkin <mst@redhat.com>; Jason
> Wang <jasowang@redhat.com>; David S. Miller <davem@davemloft.net>;
> virtualization@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> Subject: [PATCH v3 0/3] crypto: virtio: Fix three issues
> 
> Patch 1 & 2: fix two crash issues, Link: https://lkml.org/lkml/2020/1/23/205
> Patch 3: fix another functional issue
> 
> Changes since v2:
>  - put another bugfix together
> 
> Changes since v1:
>  - remove some redundant checks [Jason]
>  - normalize the commit message [Markus]
> 
> Cc: Gonglei <arei.gonglei@huawei.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: virtualization@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> 
> Longpeng(Mike) (3):
>   crypto: virtio: Fix src/dst scatterlist calculation in
>     __virtio_crypto_skcipher_do_req()
>   crypto: virtio: Fix use-after-free in
>     virtio_crypto_skcipher_finalize_req()
>   crypto: virtio: Fix dest length calculation in
>     __virtio_crypto_skcipher_do_req()
> 
>  drivers/crypto/virtio/virtio_crypto_algs.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> --
> 1.8.3.1

