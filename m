Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F1359BF40
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiHVMHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiHVMGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:06:44 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5143055F;
        Mon, 22 Aug 2022 05:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661169980;
        bh=hhrfKulgIvWnC29k0lTd5flxmJIeXghHePCBFVX3MSg=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=fy/jpVlBlBOE+JOCKZSCQfmVJf3HF8iochCZcjb53yOfQqDy+X4au1l9yG/WTsK07
         l3d5WCgA20hCqWxh4W+VpUulwweDWZ1JswcIBsrhiZB8OTMqts9OZXtzxVz8+IZgCl
         ViIj8rtP3KrJZ3Q9inU4zF8d11oa7qnqQ7a/Q+04=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M9nxt-1oVJFu464b-005p3D; Mon, 22
 Aug 2022 14:06:20 +0200
Message-ID: <c150cfb1-f719-6cd5-41ca-ca6ca23a4792@gmx.com>
Date:   Mon, 22 Aug 2022 20:06:15 +0800
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
 <YwM3DwvPIGkfE4Tu@kroah.com> <acc6051b-748f-4f06-63b3-919eb831217c@gmx.com>
 <YwNFxIouYoRo/wT+@kroah.com> <34793a7b-64e4-f1cb-b84e-5804b4f6fac3@gmx.com>
 <20220822115811.GE17080@1wt.eu>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
In-Reply-To: <20220822115811.GE17080@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NsbTg2Iway9vOeR2iqUbct9/YeyiOtQeRSeYJm5cw0TQCp6poRZ
 oQC7O7aVqzYsu6sC7gn2sKx1o0vjKKfp1PIZsbACJ1yvmER+GwfAmU+MzHl37Eft3o7w16F
 NRVCUaTBOkCfP6uFcp8y6r0da/BzTI8sU0aiHH80buVxXfjidOO5zw1vmhEF/3vxoFxxZVv
 oIMZFbD9Qm61NDItjHPrA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Q9ilmBReL2I=:C5smlabipydkaMl6KC6s7r
 k5Xe1Znp05bOz+gZUtOKRIbY2eQEAqcFpEJYjSwSmdRqp5Z7Kq8i5CZKHaqj2nhx14zKMb59G
 mLXgbwL5dnt12043384QA/Du9FuCadN1Vx+9QbnROVhivm5AYGfFIJA4e3fRva0IMQcEOeo4e
 3o9UFoE4rIhBQD7KvmzhPBbdnTqMhKg/Fq+IXhuspj4XDFa2imV/hyfvfs0CtT/98K0fAgPzI
 63EQazp8k8rVLXZM9vMwyxG/VeilxfDFqkhaQj6PI5L/7vcRKq8g3ngtAjlNxTUiNGDguOcV0
 5+xr1LTyubVDK8KDoO8VnryI/Rgw3lFDMKTpoL/vRrQC5zRXps29S+cKZLoF+eszWJELEh+ii
 uoBo7yBWf0eHPpsSSHf19nxVwI2UN72kbBybauXvtr9trGM3bvuUggugdQsU+QKXYVVhRlhm2
 3mM8UEfl840eBjSD21CiG4Q7OYrnp3lXjfJ0/TUELC6P54Fnb95njN7Oo6A+FDdVs+IMtaKp/
 HQ6i9WlrkzUdG64VMrUA5LtXXIMAe7eK+G7HHxin280JQulggxWwckAFUnVsAjicuVpisihND
 Rv3XcKxyJsYDsZ2uYH/1wt+iyuk/Qmoanaaf/n7BPb/yAuG2x7UxZnGmBy7BZsrpsznuGDkx8
 g8TeCyiJxDtSCTbY71+YyQaLvKiCmnhpd/Q9D/FpSI3AJkJXh05+9F3IAXgFlWdwtmLRRf875
 aF2tlxJaQm9dWiFTVl+CoVpZIZy/lV9BvZjkAr5cJ/k77twBxkQPhlKi4nhqvhAJKNkZHuhPJ
 RN6HQkFzgxkJ6xrTc/8Z6d230OF5+P8v0iHHGsViSneiXNlMRZh80ugpzrduKQ+IYg8ITM9f9
 x8cyP9iuFjC/F86pCTZWm5ft3iuE4/rh+y51YDbb1cubbNxUEkboaZ6C7Q14hIEpOVVH3voNY
 o6QKuJDaEK3UyeKZnM1SDemq0Il+uDpr/ri8MnRrC2/IKKTwx1ooYVw35Rx/StiK5petuxzmR
 zH4Dza6eTPRhzcSrpJRFoCqvsXMwuW0oQOfV4NNafqsqNc4kYUu0MpNJ/OK2QiurbMYlvX9t/
 K29agjHtv1vTV/s917uvq0bUSCGkSF7fNu5DNXOSBayTLfvV9BpMzqHRg==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 19:58, Willy Tarreau wrote:
> On Mon, Aug 22, 2022 at 07:43:18PM +0800, Qu Wenruo wrote:
>> Tried to compile gcc10 from AUR, which failed to compile.
>>
>>
>> Anyway, thanks to the advice from Willy, I got the pre-built crosstool
>> (gcc 7.5) set up, with some small tweaks like disabling
>> CONFIG_RANDOMIZE_BASE to workaround the RELOCS failure, it at least
>> compiles for v4.14.0.
>>
>> Although there is still warning from test_gen_len:
>>
>>   Warning: ffffffff818158cc:	0f ff e9             	ud0    %ecx,%ebp
>>   Warning: objdump says 3 bytes, but insn_get_length() says 2
>>   Warning: arch/x86/tools/test_get_len found difference at
>> <cpu_idle_poll>:ffffffff818159b0
>
> Strange, sounds like a binutils issue though I could be wrong.

I'm using CROSS_COMPILE=3D option, which should cover the objdump from the
prebuilt "x86_64-linux-objdump" from that precompiled 7.5 crosstool.

>
>> And unfortunately v4.14 still fails to boot, even with GCC 7.5, which
>> provides an almost perfect (except above wanrings) build.
>>
>> I also tried to reduce the CPUid, from host-passthru to qemu64, and
>> rebuild, no change (same test_get_len wanrings, same boot failure).
>>
>> No clue at all now, would try older debian in a VM then.
>
> I suggest that instead of switching distros you should rather first
> try 4.14.0 to verify if there was a regression affecting your system.

Already tried, the v4.14 above really means v4.14.0 (aka v4.14 tag
directly from upstream, not from stable).

And the latest v4.14.290 can not boot neither, even rebuilt using that
toolchain.

> And if so, then a bisect will certainly be welcome. If it still does
> not work, then maybe a different distro could help, though I doubt it.

Will try debian for now, or even try some older hardware if I could find..=
.

Thanks,
Qu

>
> Willy
