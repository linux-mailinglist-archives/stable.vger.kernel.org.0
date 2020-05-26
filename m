Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876751E1E72
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 11:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgEZJYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 05:24:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728758AbgEZJYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 05:24:14 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 03A374E93101BAE2F0CA;
        Tue, 26 May 2020 17:24:11 +0800 (CST)
Received: from [10.174.151.115] (10.174.151.115) by smtp.huawei.com
 (10.3.19.206) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 26 May
 2020 17:24:04 +0800
Subject: Re: [v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
To:     Markus Elfring <Markus.Elfring@web.de>,
        <linux-crypto@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Corentin Labbe <clabbe@baylibre.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200526031956.1897-1-longpeng2@huawei.com>
 <20200526031956.1897-3-longpeng2@huawei.com>
 <0248e0f6-7648-f08d-afa2-170ad2e724b7@web.de>
 <03d3387f-c886-4fb9-e6f2-9ff8dc6bb80a@huawei.com>
 <8aab4c6b-7d41-7767-4945-e8af1dec902b@web.de>
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Message-ID: <321c79df-6397-bbf1-0047-b0b10e5af353@huawei.com>
Date:   Tue, 26 May 2020 17:24:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8aab4c6b-7d41-7767-4945-e8af1dec902b@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/5/26 17:01, Markus Elfring wrote:
>>>> … Thus release specific resources before
>>>
>>> Is there a need to improve also this information another bit?
>>>
>> You mean the last two paragraph is redundant ?
> 
> No.
> 
> I became curious if you would like to choose a more helpful information
> according to the wording “specific resources”.
> 
> Regards,
> Markus
> 
Hi Markus,

I respect your work, but please let us to focus on the code itself. I think
experts in this area know what these patches want to solve after look at the code.

I hope experts in the thread could review the code when you free, thanks :)

---
Regards,
Longpeng(Mike)
