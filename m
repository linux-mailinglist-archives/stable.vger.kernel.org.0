Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526E71F4F44
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 09:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgFJHiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 03:38:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5800 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726081AbgFJHiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 03:38:24 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 58D9ED38125299FBE705;
        Wed, 10 Jun 2020 15:38:21 +0800 (CST)
Received: from [10.174.151.115] (10.174.151.115) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 10 Jun
 2020 15:38:20 +0800
Subject: Re: [PATCH v3 1/3] crypto: virtio: Fix src/dst scatterlist
 calculation in __virtio_crypto_skcipher_do_req()
To:     Sasha Levin <sashal@kernel.org>, <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200605141045.821A820663@mail.kernel.org>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <6a5b32cc-f6db-c3f6-7ae7-cf51b2893162@huawei.com>
Date:   Wed, 10 Jun 2020 15:38:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200605141045.821A820663@mail.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/6/5 22:10, Sasha Levin wrote:
> <20200123101000.GB24255@Red>
> References: <20200602070501.2023-2-longpeng2@huawei.com>
> <20200123101000.GB24255@Red>
> 
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: dbaf0624ffa5 ("crypto: add virtio-crypto driver").
> 
> The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182.
> 
> v5.6.15: Build OK!
> v5.4.43: Failed to apply! Possible dependencies:
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> v4.19.125: Failed to apply! Possible dependencies:
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> v4.14.182: Failed to apply! Possible dependencies:
>     500e6807ce93 ("crypto: virtio - implement missing support for output IVs")
>     67189375bb3a ("crypto: virtio - convert to new crypto engine API")
>     d0d859bb87ac ("crypto: virtio - Register an algo only if it's supported")
>     e02b8b43f55a ("crypto: virtio - pr_err() strings should end with newlines")
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
I've tried to adapt my patch to these stable tree, but it seems there're some
other bugs. so I think the best way to resolve these conflicts is to apply the
dependent patches detected.

If we apply these dependent patches, then the conflicts of other two patches:
 crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req
 crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req
will also be gone.

---
Regards,
Longpeng(Mike)
