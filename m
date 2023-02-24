Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7FD6A16C5
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 07:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBXGzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 01:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBXGzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 01:55:11 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CED15C9D;
        Thu, 23 Feb 2023 22:55:07 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PNLHV1wdXz4f3l8T;
        Fri, 24 Feb 2023 14:55:02 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
        by APP2 (Coremail) with SMTP id Syh0CgDHbOpEX_hjGaOlEA--.55954S2;
        Fri, 24 Feb 2023 14:55:04 +0800 (CST)
Subject: Re: Timestamps from the future (was: [PATCH 5.10] md: Flush workqueue
 md_rdev_misc_wq in md_alloc())
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, houtao1@huawei.com
References: <20230224065209.3170104-1-houtao@huaweicloud.com>
 <97a94478-7767-e2a9-a3da-85ae81f3ba5b@molgen.mpg.de>
From:   Hou Tao <houtao@huaweicloud.com>
Message-ID: <3b0fdf41-b2dc-5e73-0f93-00d8f2984152@huaweicloud.com>
Date:   Fri, 24 Feb 2023 14:55:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <97a94478-7767-e2a9-a3da-85ae81f3ba5b@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: Syh0CgDHbOpEX_hjGaOlEA--.55954S2
X-Coremail-Antispam: 1UD129KBjvdXoWrAFW7Kw4rGrykWr1DCw15Arb_yoWxGwc_Xw
        4DGryUWr4UJw48JFsFqw10gr15Jr4Ykrs8WF1rCF17Gryrtan5Gw1rGrn5Cr98GrW3Jr1x
        Ww1DJrsxJ3WFkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x07UWE__UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/24/2023 2:42 PM, Paul Menzel wrote:
> Dear Hou,
>
>
> Am 24.02.23 um 07:52 schrieb Hou Tao:
>
> […]
>
> Just a heads-up that the date/timestamp is from the future
>
>     Received: from huaweicloud.com (unknown [10.175.124.27])
>             by APP4 (Coremail) with SMTP id gCh0CgBXwLPzV_hjqVfcEA--.64482S4;
>             Fri, 24 Feb 2023 14:23:49 +0800 (CST)
>     […]
>     Date:   Fri, 24 Feb 2023 14:52:09 +0800
>
> Please check the time of your (development) system.
The time of our development server is incorrect. Will calibrate it.

Thanks.
>
>
> Kind regards,
>
> Paul

