Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C41E59BE3B
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 13:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiHVLJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiHVLJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:09:08 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE21A33E28;
        Mon, 22 Aug 2022 04:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661166445;
        bh=EuJxpwGW0kCugTdVp6i68Y2ET4g43DToAA8wC2D/R9I=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=d0BpwRlHZBoGxfuGd+9gR2HxSGzpf7d3gkxIKLPvwMhMef8WNjPEiGRRRlk61PI9O
         OC8t6qoDDR5kP+9eY7Uu7/Xb+6ZUvPPR74/MGmJqhv0eCL/BPe6m3cMOF8wmZwNae6
         LSvjxL52OrIZ9Ga0SfVBJYII5/BjUcjveR673dZE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MD9XF-1oYZaP0Vhx-0097DU; Mon, 22
 Aug 2022 13:07:24 +0200
Message-ID: <9aa83875-0a05-6b28-b4df-4071ba8ee343@gmx.com>
Date:   Mon, 22 Aug 2022 19:07:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
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
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
In-Reply-To: <20220822083044.GC17080@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jWPvej0a40zHz8DlCmHr7AlmcK/R5vwa89aDPsLwwWdX22f54+P
 Af4xer/hyzXOaWtJwtX3zI1DOVMDap9dP+o+8PItJr5VZmrVhKq39HQfZKedzM0Dc+8Wl9E
 CO7/PdBHX9XDQua3A9IiBypYqGfyrePLUPxwBwQC4sSMIR8wB9sg46CY+eivCaLzUVadFe6
 jYL4a96hnK/dIhsDir4CA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fhXrvUu250M=:X/DS/ITfEIdrL8bPByhVlR
 m9yhoSSJoUImyHOStY74la41aAD/APodgWvCCPIpbitayHAcpg6SxKAw/TZ37UlEmHkOHuwNo
 36bLP1aEmj1fFHCbRvSck65ARA51qW7eK37EXcSrKFmlRQxPK86dkHiG/GlmAUmQs8ynvQVFE
 mpIQ97ynJgxk7G26m+QpbGp6XnAcysT34HKF7jonOACpVz+QliVzmujkKsEuPqaDAnaHkNp7Q
 T4LXpsvAYvMfJHlqbskTeFBcncFmhW+1t3/bXHatT0g1PgYPHfZKlemsZlLV1A8A64wxT2961
 R2ulyfK8cFdjTx35iCWRedcZhN3oo+nSRMAuv9x/2do+PdHCTADL+9oG+t1urMwwUaPTAwQ6u
 aJDcCzKnh4vGRF7KuNJRu4WEZ3vrmOF26lNGP+v24g/f93sswP4+sQPBiPv4UNtRQ6EEGA4vY
 pQyMh6tSRKSzKlQ473uyw0UjcTkesIdhggkTFpMpKjU6kmZOgh3MwUv5zTPhDi83vn1zg7LYj
 mXRJhh3rINH2CI59fa86T8NRdcdktQz7B4Xco8rgo1dotnuQxsRyq7OGxSo2cavVgKJW0zUSR
 0bsp8SlzVCcKf8m3xf2ucRhnswTHaYrZNgP4eS1Y9TTbhhIFYbTB+7aV8lzj3VDdffDpmrjrt
 ZWYhJV/DmrNrfbj9So0qJwACTT/xsNvhdR4I8D709ivBQBBEBQ1+Gm0RtAvh8KMzOais+FiSy
 7f36Z1j+cTHNpySzc4flo1Hqp1A4+cTVcw4dNs//2qreIvrbFVoe4bY1fiD6fYMKt5UflRaFM
 NPSYdmaJqFYkVTooqGI1j2bIc5IKOYGfNhIil/ydnszf5SDN6w7EGPRSTOw8gk2RIIlqbAEEm
 dsk9dG84zB29Yu8VFdx5WM5XedKaf8h4We9K0AI13JcYtotlGOvxjn9Ef+bzVp7J9zyrD5IvU
 2hHonGYoyQtNjZnKvOdDHZWoCwYL2XqEFekuek/tXD+XtjRlXDXs/V+Xl0s+VIPwL0soYlnQW
 oDIpFmU7ce4Bt5AUbJD1npvm6tLsVCJmUVbaIvmjgs5Z8kulSXKOWovS36gZ1IYAyU190+ok/
 1TNeQXRwJL5wa6TIPdFmWa+jqXRgrC/uvoTf4EJwblixzlBNf/+FgFH4g==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 16:30, Willy Tarreau wrote:
> On Mon, Aug 22, 2022 at 04:19:49PM +0800, Qu Wenruo wrote:
>>> Regardless, if you need an older compiler, just use these ones:
>>>
>>>      https://mirrors.edge.kernel.org/pub/tools/crosstool/
>>>
>>> They go back to 4.9.4 for x86, you'll surely find the right one for yo=
ur
>>> usage. I've long used 4.7.4 for kernels up to 4.9 and 6.5 for 4.19 and
>>> above, so something within that area will surely match your needs.
>>
>> BTW, it would be way more awesome if the page can provide some hint on
>> the initial release date of the compilers.
>>
>> It would help a lot of choose the toolchain then.
>
> It wouldn't help, if you look closely, you'll notice that in the "other
> releases" section you have the most recent version of each of them. That
> does not preclude the existence of the branch earlier. For example gcc-9
> was released in 2019 and 9.5 was emitted 3 years later. That's quite an
> amplitude that doesn't help.

Maybe I'm totally wrong, but if GCC10.1 is released May 2020, and even
10.4 is released 2022, then shouldn't we expect the kernel releases
around 2020 can be compiled for all GCC 10.x releases?

Thus the initial release date should be a good enough hint for most cases.

If go this method, for v4.14 I guess I should go gcc 7.x, as gcc 7.1 is
released May 2017, even the latest 7.5 is released 2019.

Or is my uneducated guess completely wrong?

Thanks,
Qu

>
> Willy
