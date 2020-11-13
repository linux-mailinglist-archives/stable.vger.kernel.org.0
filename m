Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773252B14B3
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 04:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgKMD2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 22:28:54 -0500
Received: from mail.loongson.cn ([114.242.206.163]:57886 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgKMD2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 22:28:54 -0500
Received: from [10.130.0.88] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxr9Nk_a1fWzMNAA--.28806S3;
        Fri, 13 Nov 2020 11:28:37 +0800 (CST)
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
 <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
 <20201111145240.lok3q5g3pgcvknqr@mobilestation>
 <4625868b-f845-2f03-c3f2-fc3ff1ccf63d@flygoat.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
From:   Jinyang He <hejinyang@loongson.cn>
Message-ID: <4a73a75f-a3b2-7ba1-d8a1-a46f5c20e734@loongson.cn>
Date:   Fri, 13 Nov 2020 11:28:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <4625868b-f845-2f03-c3f2-fc3ff1ccf63d@flygoat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dxr9Nk_a1fWzMNAA--.28806S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr18ZFWDtr45GF13AFWxCrg_yoW8GFWkpr
        4UKF1IkF4DCr12v348Aws7uayFyan7AFW3KrZ3G3s8ZwsxZr92gFWI9a1Y9r90qFnYqw1j
        qF48tasaqa18ZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvSb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjc
        xK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JV
        WxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG
        8wCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2
        jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43
        ZEXa7IU01a0PUUUUU==
X-CM-SenderInfo: pkhmx0p1dqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Jiaxun,

On 11/13/2020 10:30 AM, Jiaxun Yang wrote:
> Hi all,
>
> 在 2020/11/11 22:52, Serge Semin 写道:
>> Hello Alexander
>>
>> On Tue, Nov 10, 2020 at 11:29:50AM +0100, Alexander Sverdlin wrote:
>> 2) The check_kernel_sections_mem() method can be removed. But it
>> should be done carefully. We at least need to try to find all the
>> platforms, which rely on its functionality.
> It have been more than 10 years since introducing this this check, but
> I believe there must be a reason at the time.
>
> Also currently we have some unmaintained platform and it's impossible
> to test on them for us.
>
> For Cavium's issue, I believe removing the page rounding can help.
> I'd suggest keep this method but remove the rounding part, also
> leave a warning or kernel taint when out of boundary kernel image
> is detected.
>
> Thanks.
>
> - Jiaxun
>
I found the first submission.
Commit: d3ff93380232 (mips: Make sure kernel memory is in iomem)
As I thought, this check is related to kdump. More directly, it is
related to the "mem=" parameter. Kexec-tools provide a "mem=" parameter
to limit the kernel location in kdump. But sometimes the memory may be not
enough and this check gives a way to ensure the capture kernel can
start rightly. Although "mem=" is not in kexec-tools now, I thought
it is also useful if someone use "mem=" to do other things.

Thanks,
Jinyang

>>
>> -Sergey
>>
>>> -- 
>>> Best regards,
>>> Alexander Sverdlin.

