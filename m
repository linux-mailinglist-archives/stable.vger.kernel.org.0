Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC9359BF1F
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiHVL7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiHVL7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:59:43 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FC82409B;
        Mon, 22 Aug 2022 04:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661169559;
        bh=55muDY/ySML+7EMD98wouKtWDQPnhZsyR2VnvOweULg=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=kE87WRRkeVHJ/AH2I3Pk666R+8W0sNBXS3BfVooHZhCYDobfNDwPCsUUrBqAOHVYd
         R+Xifr3xdXEG0pDnEOPZ1ElirfGuSx/xneHAhLKpuM7ojInoxTVA8oSW7zHHxy/AhO
         t7OPT3Y0oblG0PGif40+8B9jvAkP1qOir29LTp/c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MqJmF-1pBmmD1Q5T-00nNJX; Mon, 22
 Aug 2022 13:59:18 +0200
Message-ID: <a002f2a6-7c5f-c8f1-f331-7f1ca47132f9@gmx.com>
Date:   Mon, 22 Aug 2022 19:59:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Content-Language: en-US
To:     Willy Tarreau <w@1wt.eu>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com> <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com> <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
 <20220822080456.GB17080@1wt.eu>
 <4c42af33-dc05-315a-87d9-be0747a74df4@gmx.com>
 <20220822083044.GC17080@1wt.eu>
 <9aa83875-0a05-6b28-b4df-4071ba8ee343@gmx.com>
 <20220822115326.GD17080@1wt.eu>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220822115326.GD17080@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eIlOP7EvzP5ueZ1cEazO+3tjXliFXEve5LYT4WlWFKv2M2wae6i
 KRM34pNWnQM9bJprT4j4WL38c/B/VepQbB2p224NMOiBUeWviuVFjisDSg+PNKOhDgzaX1J
 DhNnEv8kISY/6srMavgVNj/qFe3+By6iKYrZ+BGWksqKoru6FH6T8wCsPQlNn7vNq7waPMb
 ZVbgPgl/rh8hdyhi4OLgw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5WG29oMkM7I=:WgGbrlNFXNhi7sufw9qC9q
 PmFhODQZ65E0Tf8ZaGg7uUKKIDAyiV6NyLTEposwG5JnapLkIkF331q1mCsDBh0DRKgVfRXC8
 4aoQbbj+5njDFg+PhdC5NfGatOAOQFgeL8zv910jRysthRmGML9e55yBEBF4Vu1yqIuksiMz7
 okDONN3NEIJWfWWzQb4OvBneJJ7kHcUm3BvbEZ1K39+WEC3QC/CkcPXLPRvTivfsZaH+rDCNE
 yObJfJZYCB9j/uuYa0Brla1AjnTp+X6edX/0llJ9LJJ9DwKWuW+82VZOI0OSy9aObw/Pv9GSc
 2ubhRFHuxp5KJg2kdN3sFLIEtuLfBgBg4O+Yuap25dAbnCi+OUqHyZjW41sJG+B6uCpoWJbGl
 j74+sNdUJABDsZHjXYAFshUWQbJvjm2kL8EKCUPuegmHZHgve4zI1SYHx3XUlXHvtDqYZ6tuL
 xi76jlvLUIsKKIUUWuW12YjDkAXnRwvL/meGJbd7CDOUW0IMjJnPOQ2T4brsDDzuDEl5XnEv8
 tpFZlOOEv30LBQ+21REFdaFrHCZT5Ww2FpLinDqOVT7FmBP/W+BmN89A6UjkQsiPim5IrXrqJ
 +Zfwvqsg5TXKP/jpk04Xc9el+Pyq3VuVa/O7hyrFDSrrNRBTBWAbuFoWP4ufFqY7X8W/vNL14
 vdAMx1fR4G0GZMPsSmDBEmjXbv4OGEbem30bFUqOLgBqXdPtMKeWhmSh9Bx9iuQifQ4KxGm2u
 tGpCMx/FiIhIdx83J4Rdl8tIK2CUa5Jqq+LCpnH714Cq8ktpfKu1CYUKf0IP0qS59XRT1xN0A
 zyJa3RMDKFnjMx/y6a4N8yuPx/XXrIt28MJ+64z2rp+O+Ky7Y5J7ju2pWHHK/sd820yq1UvGx
 DTsQ6ef2e8+ic/C0ovFYGrxxfd+hEh2umWnn0nlbsf5ALkXX23nnXypnGRikqCASPBNhWdEi+
 lanAUoo5R1BT9oKzwx3X50mj/iUDFoVX08LD+ykfDv/pDvKtt/A/jTOPmTGLW8edIdL6HfErZ
 JtyfWE4CvHx84p/hkEf5y4WMzgneVpKNnRw3YYec21ob0UmlnGqZKa+FxPNakfq2gy5oJoDR0
 1lPN5A5l8QUPi7v97kIgRblibEmaCjgbn39vfUA4IVJevLm7ydIPPCpvg==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 19:53, Willy Tarreau wrote:
> On Mon, Aug 22, 2022 at 07:07:19PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/8/22 16:30, Willy Tarreau wrote:
>>> On Mon, Aug 22, 2022 at 04:19:49PM +0800, Qu Wenruo wrote:
>>>>> Regardless, if you need an older compiler, just use these ones:
>>>>>
>>>>>       https://mirrors.edge.kernel.org/pub/tools/crosstool/
>>>>>
>>>>> They go back to 4.9.4 for x86, you'll surely find the right one for =
your
>>>>> usage. I've long used 4.7.4 for kernels up to 4.9 and 6.5 for 4.19 a=
nd
>>>>> above, so something within that area will surely match your needs.
>>>>
>>>> BTW, it would be way more awesome if the page can provide some hint o=
n
>>>> the initial release date of the compilers.
>>>>
>>>> It would help a lot of choose the toolchain then.
>>>
>>> It wouldn't help, if you look closely, you'll notice that in the "othe=
r
>>> releases" section you have the most recent version of each of them. Th=
at
>>> does not preclude the existence of the branch earlier. For example gcc=
-9
>>> was released in 2019 and 9.5 was emitted 3 years later. That's quite a=
n
>>> amplitude that doesn't help.
>>
>> Maybe I'm totally wrong, but if GCC10.1 is released May 2020, and even
>> 10.4 is released 2022, then shouldn't we expect the kernel releases
>> around 2020 can be compiled for all GCC 10.x releases?
>>
>> Thus the initial release date should be a good enough hint for most cas=
es.
>
> If you speak about initial release, yes that should generally be a valid
> assumption.
>
>> If go this method, for v4.14 I guess I should go gcc 7.x, as gcc 7.1 is
>> released May 2017, even the latest 7.5 is released 2019.
>
> Then it should definitely work. But I think you're spending way too much
> time comparing dates and discussing on the subject. By the time it took
> to check these dates, you could already have downloaded one such compile=
r
> and built a kernel to verify it did build correctly ;-)

That's completely true.

Except the fact that, even with time period correct tool chain (gcc
7.5), the compiled v4.14.x kernel (tried both 4.14.0 and latest
4.14.290), neither can boot nor cause any early boot message to pop up. :(

Anyway, thank you very much for the toolchain part, it would definitely
help for my future adventure related to stable kernels (looking at tons
of v4.12 related branches with sad face).

Thanks,
Qu

>
> Willy
