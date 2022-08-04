Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B99589B10
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 13:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiHDLcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 07:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiHDLb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 07:31:59 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936915A3C1;
        Thu,  4 Aug 2022 04:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1659612708;
        bh=gjD6K96oHF7G3P+LBp2zycGaCQGZtASsL1I+z8dl2Gg=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=XFLOc3MY+7UEXsook/hO63fATz5tl7PQBOy2Df9bzglDeMoDtt9wn19t143G0/epi
         N5/aBPlV3T0/mBun6Mh/KktCnpd5nD+boVwBv6OQwbrk2AkqeGLFIJlLrqPrC9W+Gh
         Rd+m/Xb0WDVJI0ML3QwSgvPWcZPfO/i6xkPadw0s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MatRT-1nhCBs2Igd-00cPfV; Thu, 04
 Aug 2022 13:31:48 +0200
Message-ID: <b4d94c25-9b1e-8756-9963-2868cf554588@gmx.com>
Date:   Thu, 4 Aug 2022 19:31:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH STABLE 5.10 5.15 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Content-Language: en-US
To:     Wang Yugui <wangyugui@e16-tech.com>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1659596446.git.wqu@suse.com>
 <20220804182554.303B.409509F4@e16-tech.com>
 <df125230-2ee7-7b55-815e-d209bbdbcb1b@gmx.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <df125230-2ee7-7b55-815e-d209bbdbcb1b@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vbcqcwn3NE7tGerHMWwuIzN9/A+LBA+VSxkPG3E+ijaTxTCcoh6
 zKFXHd94yHFDjuHkyo6sUXGNZG2R6rPi9cXj4L1K3ggN/gLIP7BZ40Z76AzUQ0ngvwitPWq
 u1JsNPDP+kTgvWOJSZncyzMXv74QREVq1MNlRstmFXiEbEFqQ1ntrqKiDoRbsH40epwuuwa
 kgf2A6q9jaHHZTCXlOxLg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:TTwYiJGBsHw=:j5eKYhQK4XeOx3djZHhh/2
 ahWMogDLhGgnNd18BV34n2AU/BAyfDktametHsLr0CUv6iSftmDdb9Qu2qEFK4Ji6CttU2re3
 PmU7+g1PNEn2YAAfaBjOm+A+4BgS8NqgO2Mo5dz46G75FNgu6QNrWd+93bqaNBi+pOTfYojHB
 T2gTMkdaLB1WcOGkDQ01Hg8OQ0BsDq38obYuM8dygUn9enS3H0YqQUiqdNdfqJ1z2SKl6gy1g
 lkZIrDv7BrPaD+OFYy8AaulWblEYpJhynIFX9bOsAuOT+93iCRdqNqYWBwfqb2SRg4BhFsHBN
 NcZWzsh4BmoIaaeFMCPwR9mhPQdL0oF6S7n3jIz4hhohy1fZk5zGxevVKWQyjZzt0gV/08Pxt
 rUmYCu9hRqSML6RpMJOtIZpxxD+K0HYMOGnkPJ6EMSLcI0XfyzT2br2ou8YL40O5HvMmxkfrg
 G/+cDLUZjmL/wzjdt7v9P4FRxe2aXqmTBoRDDgf1Mw+tuJKwOHogtamjRZB775oCzr/U4RSiI
 IH5tJZ5LAJXlD6KU3vquS53+EZpd9Kg0VbI+otXpQWOAOmHwjqm5yEN04n4cqwIst8X9zRB4e
 yKrUmbZIi24gr3z4WjivtALeJue079R7Pqzmbjv7QWPcTrAw30rK8P0M62FMiDOSeWA9WAzwM
 nOc6LilDEP2tiyIT1tih/KawGritFF0GCpsY3W5RUKJVYFXE4jfWi5OnfvIRUkoh6EyH7U0h4
 0UMc0LgXmEC0ZXIkyGGd0OI8/E25SzU88yiXbPDi6BEnUB8GNkebV5xO7kTT+oMZq+M03qpy7
 Qj2zbBeit9xvIdqQbejnvmHeG+diHx39TCPSCr3sYXgVcHoGGf9tC5YDkz9X+qXycoTP6n8UD
 153Sm/Rwjv9pKymJQIclRCPSpItcqDJcee/p6kjBuDovO2FpygFe4HTyi4tR65lTa8ttyEFra
 nIkz2B2tSB9exZ7SyfL4AsPM+kT1bmt5mkyLuMKh/uPfV1vjcxy/rnJBbnn+epcnh9jS40Q7E
 lJE0amdXVPlzJw4l+1ZEV3K9D1Ii+kacVlcO9I0hNhH50BW+laOPN+E2tZ2mWO7qCU2IcFXF0
 lcO5e0zjiLnMNWH5NRkp7R4dNnf9Ws2Z8/uOjJSTNdMFg2ToyMPypFgCw==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/4 19:26, Qu Wenruo wrote:
>
>
> On 2022/8/4 18:25, Wang Yugui wrote:
>> Hi,
>>
>> xfstest btrfs/158 trigged a panic after these 2 patches are applied.
>>
>> btrfs-158-dmesg.txt
>> =C2=A0=C2=A0=C2=A0=C2=A0dmesg output when panic
>> btrfs-158-dmesg-decoded.txt
>> =C2=A0=C2=A0=C2=A0=C2=A0dmesg output decoded by decode_stacktrace.sh
>> =C2=A0=C2=A0=C2=A0=C2=A0and some source code is added too.
>>
>> reproduce rate:
>> =C2=A0=C2=A0=C2=A0=C2=A0not 100%, but 2 times here.
>>
>> xfstest=C2=A0 './check -g scrub' seem higher rate=C2=A0 than
>> './check test/btrfs/158' to reproduce this problem .
>
> Also reproduced here running that in a loop.
>
>>
>> linux kernel: 5.15.59 with some local backport patches too.
>
> Got the reason pinned down, missing one dependency.
>
> The code triggering the crash is "const u32 sectorsize =3D
> fs_info->sectorsize", and @fs_info is from bioc.
>
> But bioc initialization doesn't ensure every bioc has its fs_info
> initialized.
>
> That is only ensured by commit 731ccf15c952 ("btrfs: make sure
> btrfs_io_context::fs_info is always initialized").

Wait, it can be done without that dependency, just use old
btrfs_raid_bio::fs_info.

Thanks,
Qu

>
> So I have also need to backport that patch.
>
> Weirdly, I ran my tests with "-g raid -g replace -g scrub" but didn't
> trigger this on even older branches.
>
> I'll do more tests to make sure it doesn't cause problems.
>
> Thanks,
> Qu
>
>
>>
>> Best Regards
>> Wang Yugui (wangyugui@e16-tech.com)
>> 2022/08/04
>>
>>> Hi Greg and Sasha,
>>>
>>> This two patches are backports for v5.15 and v5.10 (for v5.10 conflict=
s
>>> can be auto resolved) stable branches.
>>>
>>> (For older branches from v4.9 to v5.4, due to some naming change,
>>> although the patches can be applied with auto-resolve, they won't
>>> compile).
>>>
>>> These two patches are reducing the chance of destructive RMW cycle,
>>> where btrfs can use corrupted data to generate new P/Q, thus making so=
me
>>> repairable data unrepairable.
>>>
>>> Those patches are more important than what I initially thought, thus
>>> unfortunately they are not CCed to stable by themselves.
>>>
>>> Furthermore due to recent refactors/renames, there are quite some memb=
er
>>> change related to those patches, thus have to be manually backported.
>>>
>>>
>>> One of the fastest way to verify the behavior is the existing btrfs/12=
5
>>> test case from fstests. (not in auto group AFAIK).
>>>
>>> Qu Wenruo (2):
>>> =C2=A0=C2=A0 btrfs: only write the sectors in the vertical stripe whic=
h has data
>>> =C2=A0=C2=A0=C2=A0=C2=A0 stripes
>>> =C2=A0=C2=A0 btrfs: raid56: don't trust any cached sector in
>>> =C2=A0=C2=A0=C2=A0=C2=A0 __raid56_parity_recover()
>>>
>>> =C2=A0 fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++----=
-------
>>> =C2=A0 1 file changed, 57 insertions(+), 17 deletions(-)
>>>
>>> --
>>> 2.37.0
>>
