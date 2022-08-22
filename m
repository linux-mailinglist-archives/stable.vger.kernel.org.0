Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65ABE59BB3D
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbiHVIUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiHVIUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:20:18 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875B81EAF8;
        Mon, 22 Aug 2022 01:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661156394;
        bh=oiwA1zgV4w9lXHIksAJ9fEf2oEdi2urzdwuD2s8uYaw=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=DrFEypzdgHBBjlJMJcZ4/7qZwKFfnSjsL7WH9iZMQdofHyELeIAZwhZ+satOoChre
         N8716Y/VEl0++jxzvQFd82jryrYH0s0LRAy5GgVeBYXmH65mgG1j741e5rVhsTj+UB
         ikenmpgRD/h7gBI4muOXcS76vRwPb2cWsB9hCLBQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MTiPl-1otUIe0o6n-00U45U; Mon, 22
 Aug 2022 10:19:54 +0200
Message-ID: <4c42af33-dc05-315a-87d9-be0747a74df4@gmx.com>
Date:   Mon, 22 Aug 2022 16:19:49 +0800
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
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220822080456.GB17080@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:izlLQSna+6slNPoEw8Xfs35Mfte2/o3TebxKsezXSd36johbDVE
 Bg0kA7Csd2uTWS1tlERVenoDxKOUkRL7KqpUPQaHk7d4z2pj5rof1bMs6eZ/mOQxGOsAS/2
 qLz5s7CwlwgXD3sWZX9HYjpJQc0YGGYm9n4e24yrceDHc4yQTbdDBOL1+FWuKQIJ4Vvsdc7
 9a+dq+VM0BpC/VikpaWQQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ibKqMWTVe/I=:U/SWRDw6M8N8u1siJyWI/6
 KIwa8Mj+QW92GX7fy7blxIATs1e9cTtTQe2VWE8HLLXsy+8uQHIeEbgpjqe3gH5HBRCnW7AMJ
 qHKRfAVWenhG5vLsVbXKRlr6VDGeor6m8XhNdoMoudQJNlZu3Fkvf3fZlJYF2P7jdZ6q/1GBR
 wvG1vmwyVDwCSLsE67DK3ztLt4dBNgXCIHzFj0OIloNq37KfFuHXOa/bz+bL1oMZh/uICFFpV
 FB/k++snyloDq+JnfyV9kH5/HFXrkcF+0JUBQsvrCjEDLfNuXszR3GgmhqAfbd2d5wxHtHybT
 SM6n+rFG4q+XLW+dmqBLkelOmgQPtpB83yr0J25v+doPI6im0vpYQEq871LWc97DFWxa+WAgv
 vVEZeG7jNCsfZ0/wx+eEsVJbLPaxklLquWFQisHlwLCkpIc3fCrLLHA04zCX8Na8Sktw0grrM
 arSfHEFl6/6ZQoAfoX4hCjpismWR6ZEdCZWGpqgfh/3ETq0mzxfJegehJhHwsPy3/oi2o3mF6
 tJrBoJjF4WEYqu0anQHFTNR7QHsdEqQOUYYTiyQKahQHzWTm5/rWCWdZNStV+qSv95UXwQ4YP
 6nzOwiPOSfjBit6iLQBxIxqvJV/Gms2A5Itf9twumchcn4Jxjr0ff40rIwPQJgwVkuDH9iDMj
 RyK/olCGgD7LnOHx/SAf/aXZw4fCB9sG/3BQyQ8uvI1XZ1j8K98YFUwqY2Q9CIFlMvnNfhxgr
 Tw9HPhNAE4xhIUOZoKr70XiAFfl0xNLBK3roM0U0OitqubKxcQJx2+DRrwkEnAFLmzyiCFEiT
 VerHRS+7yPHCMEOcNONYvT/qylWawp/QVFYNYWvOmLlQbsIyLIvfcgvzVvi0oVz6Y2vCfSCo7
 YptwIv6JfBBL6Tvv5pdh8UEJJjXVGk12Xs94FDG4oNN7+ZRaMglO9KVhLyelSL35SFI58D/GX
 npde9B6k+q7neDS8w7em+WitEVDJSVlMXZBS4nkxIdX1bjLT3YF2liBghmIn6AKjX7kKNVopb
 kBEOkZSaKoJJyEE+XcW9V08YPXkLeHJ7fB5qUV/NAu4iFmaVG4lUMlNt2EXCve93E9ymY7Tw3
 OyoJ3QuxFs4aXRMaDatz0Nrjhx+MwZhNS9C50+/g+3Y3D/IXDz1LuSCXQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 16:04, Willy Tarreau wrote:
> On Mon, Aug 22, 2022 at 03:49:51PM +0800, Qu Wenruo wrote:
>> Yeah, I'm pretty sure my toolchain is too new for v4.14.0. But my distr=
o
>> only provides the latest and mostly upstream packages.
>
> Then there's something odd in your use case. Old kernels are aimed at
> those who need to have systems on which nothing changes. It's particular=
ly
> strange to be stuck in the past for the kernel but to continually upgrad=
e
> userland. Most often it's the opposite that's seen.

Yep, that's my bad, just too lazy to get a time-period correct distro,
or learn other package management tools from other distros.

>
> Regardless, if you need an older compiler, just use these ones:
>
>     https://mirrors.edge.kernel.org/pub/tools/crosstool/
>
> They go back to 4.9.4 for x86, you'll surely find the right one for your
> usage. I've long used 4.7.4 for kernels up to 4.9 and 6.5 for 4.19 and
> above, so something within that area will surely match your needs.

BTW, it would be way more awesome if the page can provide some hint on
the initial release date of the compilers.

It would help a lot of choose the toolchain then.

>
>> It may be a even worse disaster to find a way to rollback to older
>> toolchains using my distro...
>
> No, using a prebuilt toolchain like those above is quite trivial and
> it will avoid messing up with your local packages. That's the best
> solution I can recommend.

Thanks for all the info, it really helps a lot,
Qu

>
> Willy
