Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA33A9621
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFPJbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 05:31:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10098 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhFPJbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 05:31:02 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4ftv6Zj7zZf8R;
        Wed, 16 Jun 2021 17:25:59 +0800 (CST)
Received: from dggpemm500009.china.huawei.com (7.185.36.225) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:28:55 +0800
Received: from [10.174.179.24] (10.174.179.24) by
 dggpemm500009.china.huawei.com (7.185.36.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:28:54 +0800
Subject: Re: Questions about backports of fixes for "CoW after fork() issue"
To:     Suren Baghdasaryan <surenb@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <f546c93e-0e36-03a1-fb08-67f46c83d2e7@huawei.com>
 <YMmfke61mTcPV4vB@kroah.com>
 <CAJuCfpG8p7AasufvqehNOLdoXw5ZQFuQhi6mhqPvA3GbPn1puQ@mail.gmail.com>
CC:     Vlastimil Babka <vbabka@suse.cz>, <stable@vger.kernel.org>,
        "Jann Horn," <jannh@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>
From:   Liu Shixin <liushixin2@huawei.com>
Message-ID: <add3f456-052e-6f40-2949-0685b563fdee@huawei.com>
Date:   Wed, 16 Jun 2021 17:28:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAJuCfpG8p7AasufvqehNOLdoXw5ZQFuQhi6mhqPvA3GbPn1puQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500009.china.huawei.com (7.185.36.225)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/6/16 15:11, Suren Baghdasaryan wrote:
> On Tue, Jun 15, 2021 at 11:52 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Wed, Jun 16, 2021 at 02:47:15PM +0800, Liu Shixin wrote:
>>> Hi, Suren,
>>>
>>> I read the previous discussion about fixing CVE-2020-29374 in stable 4.14 and 4.19 in
>>> <https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/>
>>>
>>> https://lore.kernel.org/linux-mm/20210401181741.168763-1-surenb@google.com/
>>>
>>> And the results of the discussion is that you backports of 17839856fd58 for 4.14 and
>>>
>>> 4.19 kernels.
>>>
>>> But the bug about dax and strace in the discussion has not been solved, right? I don't
>>>
>>> find a conclusion on this issue, am I missing something? Does this problem still exist in
>>>
>>> the stable 4.14 and 4.19 kernel?
> That is my understanding after discussions with Andrea but I did not
> verify that myself. As Greg pointed out, the best way would be to try
> it out.
> Thanks,
> Suren.
>
>> As the code is all there for you, can you just test them and see for
>> yourself?
>>
>> thanks,
>>
>> greg k-h
> .
>
Thank you both for replies. I have tested it in stable 4.19 kernel and the bug is existed as expected.

Thanks,
Liu Shixin
