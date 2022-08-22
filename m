Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8243C59BA9D
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbiHVHuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiHVHt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:49:59 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF52165B3;
        Mon, 22 Aug 2022 00:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661154595;
        bh=OU34lRpO/1OTDjZ9Diuvg5jc+I14siphOEscXix5Otk=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=V+lcO0VqLmjQGTx03pqc3q7B/6LGyJ4CETKflXzSBuBXD6Uh/Zk1U6jbwD46eRAmC
         d1TF6oyqzoyVyqD/FWoqs5mlLU9sJiANtf5yDG8r02llJ7iQynPa0DpKyuq8DtT1ni
         2DEJC/f7CsU0x6VQzldWzG3bQ2rf0HSnVwF5ri1k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MD9XF-1oYWVH2NFp-0097IY; Mon, 22
 Aug 2022 09:49:55 +0200
Message-ID: <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
Date:   Mon, 22 Aug 2022 15:49:51 +0800
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
 <YwMxRAfrrsPE6sNI@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
In-Reply-To: <YwMxRAfrrsPE6sNI@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CnIpYoLCgBjfRiNPGj4hRiKW6uk13KaR20i+1Yhg/1MIpBe9iQa
 xVNH0d3Pzb8D4PHfTZEsx2d7kn7FEuOIdAOCO8TJFRd89FpuQyWT+3t0F59sYaeTpsFvFGz
 jbNHh4KnGgsFUknPeNjigbydyGiwkzm6lK+LItqPHmVcAh9PLUsEMuzZ8YxB6Ca5iGHlGs5
 3JLmfMEXifuSnptogNGpg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kJmpDuL2TRA=:OnAi3T5f1Cid4aWffjfNVy
 +76gGuuScHi18HHkaEZmvWxZzbnTjuKbvY6M+8oH1dVAdDJprEcCk27hx6vzov1EMdSV54Wlk
 C4MeHttatZZR+zLffJbIL8DOnpAn3PRk3XRHBWXZNl/8JmwnWznC0AgVxpheSCMUC+OaXTVTY
 tjdrYCqzGWeOMvaBN+hUXSYQjEI382LErPSOtih1KFdLpE27yrnBU/zP0kCGM5Z32E4/Iac4K
 nez7TgxU48GepAIvJRemSl8y4RfMMts64Qm1//qBsl1CqjBl4pu3DZssx8ADUAtA9y2wSQ7oy
 kBzVsnGknG3nz7sCYGIQeDyu8kzNk2GlQCBk8AlYghsJK1XP9II2CzE3jugwRAs+eQVi5AEiq
 O3lovvQkaeW2wQ6/SSRddrMnSci5L4bkScosg/01eRZ3VpiKKq18a98CWGgMphEjBgvyfaDZA
 LdkawV+Y4m6fbkzbhjL0PQGzwcWwD5Kh8QkRAHVb9hK076QXPnrhi6mzQUZ7+X4xFBx6iYHWP
 3Xlyp7tbJvT3H+/0DAr+uZagw0mwFxLDcnZ1zudC5J+Ye6fLh3o12PvUbMea0jze1jQxUyi6T
 H6ZKwrPNPSfr4ww5O2tZ/+eo6/C14R0fxTnCgHlfQ469B7Sd4dysLXPn/jkGbCESkIjaR5kJy
 SbprgqF+Nfg4R5juP48Fq2KhmVgPsYZVp4ZcQvuDCrjPhfJG6HeLN/humqak+6Cb2jtm5kNRc
 XerO0d4E7VRRqs1LEIpqb5REsxKkq3L/lktilKsUvi+ziA8v8wbkLOZ4pbxplbJNcWCB1C6qA
 2kQ2a5qWlT3ZYyyxZGfWAymWzj2OY77mgtem93duB7neaGptdHE5kxF1ifNmKxF1/Itursmea
 BtUakmplDc0UhslpaCVxFgi6mDD/8MRTYXA24axirXCRZv1Js6bVP63pt0RbkAMWfjouxsLDY
 1A8h0dWlLGf5BY4ZgSysT+w7A5LJUVaifXiO68vroJWFHccYAADdcs6bXimqTpiKeHWamarxt
 xU8En9L0rxWZvLY3+wZeDhLivKKP3wGQZtpMSw4oN2g5VVNDYRRCwjzzJNOLO+wKIHNxV2c4n
 xfd10OIXysbWap1ZB6pTDDMSj2Hkx0qiYnfZ7zPbOu5FA/AKt2GEEcoCg==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 15:33, Greg KH wrote:
> On Mon, Aug 22, 2022 at 03:24:53PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/8/22 14:25, Greg KH wrote:
>>> On Mon, Aug 22, 2022 at 09:15:59AM +0800, Qu Wenruo wrote:
>>>> Hi,
>>>>
>>>> When backporting some btrfs specific patches to all LTS kernels, I fo=
und
>>>> v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
>>>> (edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).
>>>>
>>>> While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.x,
>>>> 5.18.x, 5.19.x) can boot without a hipccup.
>>>>
>>>> I tried the following configs, but none of them can even provide an
>>>> early output:
>>>>
>>>> - CONFIG_X86_VERBOSE_BOOTUP
>>>> - CONFIG_EARLY_PRINTK
>>>> - CONFIG_EARLY_PRINTK_EFI
>>>>
>>>> Is this a known bug or something new?
>>>
>>> Has this ever worked properly on this very old kernel tree?  If so, ca=
n
>>> you use 'git bisect' to find the offending commit?
>>
>> Unfortunately the initial v4.14 from upstream can not even be compiled.
>
> Really?  Try using an older version of gcc and you should be fine.  It
> did build properly back in 2017 when it was released :)

Yeah, I'm pretty sure my toolchain is too new for v4.14.0. But my distro
only provides the latest and mostly upstream packages.

It may be a even worse disaster to find a way to rollback to older
toolchains using my distro...

Also my hardware may not be well suited for older kernels either.
(Zen 3 CPU used here)

In fact, I even find it hard just to locate a v4.14.x tag that can compile=
.
After some bisection between v4.14.x tags, only v4.14.268 and newer tags
can even be compiled using latest toolchain.
(But still tons of warning, and tons of objdump warnings against
insn_get_length()).

I'm not sure what's the normal practice for backports to such old branch.

Do you stable guys keep dedicated VMs loaded with older distro just for
these old branches?
If so, any recommendation on those kinda retro distro?

Thanks,
Qu

>
> thanks,
>
> greg k-h
