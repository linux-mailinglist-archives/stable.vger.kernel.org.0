Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0439D6D3C
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 04:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfJOCfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 22:35:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726430AbfJOCfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 22:35:33 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1B0AF165A658E53FDD25;
        Tue, 15 Oct 2019 10:35:32 +0800 (CST)
Received: from [127.0.0.1] (10.177.219.49) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 10:35:30 +0800
Subject: Re: [PATCH v2] md: no longer compare spare disk superblock events in
 super_load
To:     Song Liu <liu.song.a23@gmail.com>
CC:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, <stable@vger.kernel.org>
References: <20190925055449.30091-1-yuyufen@huawei.com>
 <5bce906d-3493-982e-63b1-66d1b9813e1e@huawei.com>
 <CAPhsuW6BMA5RXo8JwWBLWNA9B6Kq0RfvG-vdkjrsNANybvrORQ@mail.gmail.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <3d1773d5-6923-8a26-3f1c-8b06a0c4d094@huawei.com>
Date:   Tue, 15 Oct 2019 10:35:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6BMA5RXo8JwWBLWNA9B6Kq0RfvG-vdkjrsNANybvrORQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.177.219.49]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2019/10/15 8:31, Song Liu wrote:
> On Fri, Oct 11, 2019 at 6:35 PM Yufen Yu <yuyufen@huawei.com> wrote:
>> ping
> Sorry for the late reply.
>
> The patch looks good over all. Please fix issues reported by
> ./scripts/checkpatch.pl
> and resubmit.

Sorry for forgetting to check the patch by checkpatch.pl.
And thanks a lot for your review and response.

Thanks,
Yufen

