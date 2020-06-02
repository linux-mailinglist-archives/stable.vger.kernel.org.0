Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13171EB3F9
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 05:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgFBDyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 23:54:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46658 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbgFBDyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 23:54:17 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 639A4D5D1D8B26E95453;
        Tue,  2 Jun 2020 11:54:15 +0800 (CST)
Received: from [10.174.151.115] (10.174.151.115) by smtp.huawei.com
 (10.3.19.202) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 2 Jun 2020
 11:54:05 +0800
Subject: Re: [PATCH v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, Gonglei <arei.gonglei@huawei.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Markus Elfring <Markus.Elfring@web.de>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200526031956.1897-3-longpeng2@huawei.com>
 <20200526141138.8410D207FB@mail.kernel.org>
 <20200531052126-mutt-send-email-mst@kernel.org>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <a0701427-92e2-5695-1b84-88d356253a76@huawei.com>
Date:   Tue, 2 Jun 2020 11:54:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200531052126-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/5/31 17:21, Michael S. Tsirkin wrote:
> On Tue, May 26, 2020 at 02:11:37PM +0000, Sasha Levin wrote:
>> <20200123101000.GB24255@Red>
>> References: <20200526031956.1897-3-longpeng2@huawei.com>
>> <20200123101000.GB24255@Red>
>>
>> Hi
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag
>> fixing commit: dbaf0624ffa5 ("crypto: add virtio-crypto driver").
>>
>> The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181.
>>
>> v5.6.14: Build OK!
>> v5.4.42: Failed to apply! Possible dependencies:
>>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
>>
>> v4.19.124: Failed to apply! Possible dependencies:
>>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
>>
>> v4.14.181: Failed to apply! Possible dependencies:
>>     500e6807ce93 ("crypto: virtio - implement missing support for output IVs")
>>     67189375bb3a ("crypto: virtio - convert to new crypto engine API")
>>     d0d859bb87ac ("crypto: virtio - Register an algo only if it's supported")
>>     e02b8b43f55a ("crypto: virtio - pr_err() strings should end with newlines")
>>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
> 
> Mike could you comment on backporting?
> 
Hi Michael,

I will send V3, so I will resolve these conflicts later. :)

>> -- 
>> Thanks
>> Sasha
> 
> .
> 
---
Regards,
Longpeng(Mike)
