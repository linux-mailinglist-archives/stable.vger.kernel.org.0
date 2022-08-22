Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F230459BEB7
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 13:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiHVLn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiHVLn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:43:28 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC4C9593;
        Mon, 22 Aug 2022 04:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661168602;
        bh=9WTSHYwgcajcDS+9v+8XJmgCDTnyb7zcXimtAd5K9GM=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=ZcQ3khUEriqu4PpCiA7didVvrJmIpi4MJo3tgSDjzWO4FTbhPVop4TE0oUPGRjtd6
         eveMMPZWmLRdvCf4oZgaCOn7UiPx7kRKFI/zn94VgBTxCTzdNiz3WtDBIBgLMl2piZ
         76TLBfeK5tOW5fP/ut0ITtKBbtBDThZ/oaCbpHMQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N49h5-1pPRlY2sPB-01055t; Mon, 22
 Aug 2022 13:43:22 +0200
Message-ID: <34793a7b-64e4-f1cb-b84e-5804b4f6fac3@gmx.com>
Date:   Mon, 22 Aug 2022 19:43:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com> <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com> <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
 <YwM3DwvPIGkfE4Tu@kroah.com> <acc6051b-748f-4f06-63b3-919eb831217c@gmx.com>
 <YwNFxIouYoRo/wT+@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
In-Reply-To: <YwNFxIouYoRo/wT+@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qc8DcoaNNOFQXy5IKiO/2mR8Xi537SsUE2vBAOwjnTLQiq9a9fZ
 6pROjFz6L0K81V7AxPMiBfKbLCo5hUnLrRhKEhm3TCbk2OugvnVUIISdvs9JWnN+XEcxqT7
 w/NDOutNnL/Au0X2ho4WVEoI8W2/9jL4YhoMq6cAmOFB+hwnpVZl7olx6iYxvNFiP4b6wo/
 q8x1AS/5RtkmbgKAkGKbA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8kZnDdMhhPE=:E6gt72wXOOr7W7XAKJAyna
 aujFNFtH8HjUEhC+i2fQbmZ48WA1zvInQ3JLst1gqzGk7mv99pe0/Xn+hDb+idxpfq/j42AiZ
 lQhfdfU+uzRt1g8KCaycMFB+y+mLJwW+FqGTsQOP8+k2JHnpPUS+9s6yy/rUo31oev1Ndx7d0
 CpXxa2s305etooJgVzMZ30JMVdIk6qSbbX106bU7RmlcmyOGEGwo1x/KWGpzgDkM3ABCsUuFG
 c7EKm9nisWkqx1XJSQMlchOJq66kkXJIPlhpBLJmxMFUr0iqSxHq1Mp/o/edev16wtOFqUlPY
 KUfoa1GeN+SznS4xch97OFhOeMrm4a87ALlvQLNsxV0qz2gCm+nlPj5495XsnruiFuGqt9B8d
 drd/agY/xjCBETWFahqsM/YJ9vIyjibqBphkNYkpp3HYAu52dS2EgA/vrXqgcL7ElfGLhf457
 s/SaU9fnK259wgl5cVUoMiBW/ASzD1mKnsrZDMHKQMztVHtOj9tiEh9AVSs1WWwsLiyalqoGC
 O03sXNQxUegckHFL49wxOAgNvIG8TgsTfoRqj2EUNg7EDXHHkIRdYhSnTQsLIYQj4ZVvHV8dA
 U1S8JVnAL8q1RvqZHYBRonvHadqUyou0Xob6mQlbSfPzlkUReYPV98Q+zUKTdB7qdPkMbTRkI
 UL0wi//9Zzk5Y4NzfR+ei590SG/C7YGnxtwPvgHSVxuTgJxTPBbYHaQifRDfXn8qdO5hmJLgG
 pC6DP6v9+HRca6y7uvrCRbetExgSi6QffZ4GDhgCwvsqYFFQTmcGEwlHvHRBivc8vXA/fWpr7
 +QLcIxObBy3r0xkhLf1dZ8ls9qT1lZigNWy5BEe8IqjlxNrbqO5Ferx2XqygZlW0HhlKDUmlM
 rovGPHyx7JH9qW46ArhkgMpdQ93Ynnl+QbwhLcl6Stu4HUMQZS8OlUlO9qn+bMUIOsH1hcaBh
 HZyLA7hXf8qRJTN/UZDk+GbM4shzChjfnd9L3pLyu0/wxCievUSkWyQN/vuNm1GLsKxdo0wTz
 okeKjI4BLlIbOg/yWeM0jqaowwHLbuOxdvB7v0PAfruFIT0MbLL2FpoFQjAm3SuZ7fLc1K0MM
 FsTe8X9oQELtGzIzHcO/ftBfEffo0D3s/b5wGmoWG/30iLLUmAtFhI02A==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 17:00, Greg KH wrote:
> On Mon, Aug 22, 2022 at 04:13:03PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/8/22 15:58, Greg KH wrote:
>>> On Mon, Aug 22, 2022 at 03:49:51PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2022/8/22 15:33, Greg KH wrote:
>>>>> On Mon, Aug 22, 2022 at 03:24:53PM +0800, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> On 2022/8/22 14:25, Greg KH wrote:
>>>>>>> On Mon, Aug 22, 2022 at 09:15:59AM +0800, Qu Wenruo wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> When backporting some btrfs specific patches to all LTS kernels, =
I found
>>>>>>>> v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
>>>>>>>> (edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).
>>>>>>>>
>>>>>>>> While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.=
x,
>>>>>>>> 5.18.x, 5.19.x) can boot without a hipccup.
>>>>>>>>
>>>>>>>> I tried the following configs, but none of them can even provide =
an
>>>>>>>> early output:
>>>>>>>>
>>>>>>>> - CONFIG_X86_VERBOSE_BOOTUP
>>>>>>>> - CONFIG_EARLY_PRINTK
>>>>>>>> - CONFIG_EARLY_PRINTK_EFI
>>>>>>>>
>>>>>>>> Is this a known bug or something new?
>>>>>>>
>>>>>>> Has this ever worked properly on this very old kernel tree?  If so=
, can
>>>>>>> you use 'git bisect' to find the offending commit?
>>>>>>
>>>>>> Unfortunately the initial v4.14 from upstream can not even be compi=
led.
>>>>>
>>>>> Really?  Try using an older version of gcc and you should be fine.  =
It
>>>>> did build properly back in 2017 when it was released :)
>>>>
>>>> Yeah, I'm pretty sure my toolchain is too new for v4.14.0. But my dis=
tro
>>>> only provides the latest and mostly upstream packages.
>>>>
>>>> It may be a even worse disaster to find a way to rollback to older
>>>> toolchains using my distro...
>>>>
>>>> Also my hardware may not be well suited for older kernels either.
>>>> (Zen 3 CPU used here)
>>>>
>>>> In fact, I even find it hard just to locate a v4.14.x tag that can co=
mpile.
>>>> After some bisection between v4.14.x tags, only v4.14.268 and newer t=
ags
>>>> can even be compiled using latest toolchain.
>>>> (But still tons of warning, and tons of objdump warnings against
>>>> insn_get_length()).
>>>>
>>>> I'm not sure what's the normal practice for backports to such old bra=
nch.
>>>>
>>>> Do you stable guys keep dedicated VMs loaded with older distro just f=
or
>>>> these old branches?
>>>
>>> I don't, that's why those kernels can be built with newer versions of
>>> gcc.
>>>
>>> Your distro should have a version of gcc-10 or gcc-9 that can be
>>> installed, right?
>>
>> This may sounds like a meme, but I'm really using Archlinux for my VM
>> and host, and it doesn't provide older GCC at all.
>
> Archlinux does provide older gcc versions, that's what I use.
>
> It still supports gcc11 in the main repo, and there is gcc10 in AUR as
> well as gcc9.  Try those!

Thanks a lot, didn't even notice the gcc11 in official repos.

Tried to compile gcc10 from AUR, which failed to compile.


Anyway, thanks to the advice from Willy, I got the pre-built crosstool
(gcc 7.5) set up, with some small tweaks like disabling
CONFIG_RANDOMIZE_BASE to workaround the RELOCS failure, it at least
compiles for v4.14.0.

Although there is still warning from test_gen_len:

  Warning: ffffffff818158cc:	0f ff e9             	ud0    %ecx,%ebp
  Warning: objdump says 3 bytes, but insn_get_length() says 2
  Warning: arch/x86/tools/test_get_len found difference at
<cpu_idle_poll>:ffffffff818159b0

And unfortunately v4.14 still fails to boot, even with GCC 7.5, which
provides an almost perfect (except above wanrings) build.

I also tried to reduce the CPUid, from host-passthru to qemu64, and
rebuild, no change (same test_get_len wanrings, same boot failure).

No clue at all now, would try older debian in a VM then.

If no change, a time period correct host maybe my next try...

Thanks,
Qu
>
> good luck!
>
> greg k-h
