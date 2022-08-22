Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC659BB23
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiHVINM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiHVINL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:13:11 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9961001;
        Mon, 22 Aug 2022 01:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661155988;
        bh=VF47xpSy5FMXLFoHD4vWRnBzqe4OlQT5XGbK7tkpYXU=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=IVQw/rdTWqU73uPZgM+iIdgxTLOl++xT82L4OfB9UYPsnw0lKlNc+xOpoRLuT4Vdp
         H/5zYEWDEGOr/st/28+/t8Z3KMeE0XrWd650BAx26xzSpE0DLsCH8/OjiebSUdn0yg
         +XiMw+YtJ+hqyC6ZLsKaSS+KHu5mhoVf0qoDCK38=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MhD2Y-1p3Cmv0A5q-00eJ17; Mon, 22
 Aug 2022 10:13:08 +0200
Message-ID: <acc6051b-748f-4f06-63b3-919eb831217c@gmx.com>
Date:   Mon, 22 Aug 2022 16:13:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com> <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com> <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
 <YwM3DwvPIGkfE4Tu@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YwM3DwvPIGkfE4Tu@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sa08DhrSOFunKMqMAgmYyystR5b0QdhInYEnY/iilAcBcCRmr2O
 jULTD4n6NLrmyiBAHcczjIeXmmZyQQEEYMpjNLtb3WX3FsNCh21G++VRWgbYEL3tStNSTM9
 UxmyS3XTy2TxMjvjkp3MHhjyypzKX0n1od5cEx/mhrCoFioEHH+IQ/8Hyd482bazh50ZkOs
 WKW1E0ma9g1teivfwu3BA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7v3WyKqh90c=:vfXhF5ASvCGzNdxahB2n72
 LRcZIHkygQ2OHfY9TL5uMPjXFJcgmh4FgtaM+CqeqSeDBh4nGzHNjRl/qjoXCtFK8jAsy/tCC
 zgIs/D5uSHKMrW36u4g/Lsv3pDcH/0ER0ZT82VIMo3eVGcBZr5a1x3/eKcm3cA3Y5zOxlLtTC
 WRVk2//VvPhK9MOYe6/1XwHE40O4sIE2RrhR5t04yJLRZtniVlKnVPaVNuu1n6y70UYap59r/
 tZg4JSMDsaCc/VHllbL5PXt+xGfPQPKdGr76c8hAPdvq4miC1NTs9qo1Ut40GrbUdI4xRD9vQ
 lxUAjOtGC8O1euDaPPnJjN3ms/nFxkNdHIcBmX3ddE+FLCyCfpw0Ms1bLrRIFJlzxjK6CLZvW
 t6Zm6UTufgmZCYZ1/e//rzw3DWDU+7KFT7xOZXoIpkLxOe981HQ9cXkNYTxgZRSYGCRtQFKAN
 y0FJ9dC8iOvuXBY3x85f7e6LPcoian2xnIiJbfxPlBREeY2VGMuBXF2Ef5ktJlb5qYX+6clfm
 6o0La93oz+hbQ/+Aeb5RebE6tXaVpJndZ2qCE4T3Oun62GjgpTBHYpbF1NKEb+eHjwtcXbCZm
 XidrB6bmWwcQ8yxuhDq2zZpA8HwBE57wuvBIWGlVwYdSFdqZ/kIuIJmYTl6RcmBVb6B1U7pZ2
 FnHvfpJ5N2pJx+T2UslFJEqDVSQPkW/3sgV7WviVCCbE6ffi0JPGLrqyo7wfQMGh/T2zaKiQs
 pRL33l6HCvgnm6xYV8Ma1RT98BMb59AAvw+YaEh2TrKRNFrLEAW1Yfgg39v49/2sGtAcs1BgC
 kjbeZ+GF8/vPR5T8JYZ6e9sZC1i5ypfTOyjNy/EDaMs/dwLLx7hBjkmhRCJ6OHCZ0/GuBnUim
 ZnDfGZL89TWkkpbKl0x5D2Bm+8XvXicMj/vGSZDcTZhcRXiXmveZfWwcVENdzB4cT65YY9iT8
 aNCsM3AhDcRP7T6oaxoJ/FWtj0h8Ckm5PMv9F2qQsDYNVAbXo5TDbQic765Y/WMrJLSDhQhvy
 bv0msPgdcpZBeSXppWWLlpmeihOZCuBWF8chaYL6sc2ziJY7PU2W7hk2dtqy7Sr31rl9kkGoq
 S81hIZJWwvrWthoeX7x4MUv6bX2ZJDLWPvcvAjPTUtVuh0N6QaZt1EU7oqTe0pxsKZiuncabl
 peaxYYx6i9YSg6Uye69xXyUcNqXeqzFAEbCF7oBBwqodk9v6Gyg2NLxC++6BDuVlmgf0oemkJ
 lPiGP+eT2yoJZn4l1+gRG1C622VUpAS7g1oLsCd7Yywen8JCb0chf6/P2iU2qeekmINa8atdl
 7Rj7xICUyqs3mJBFfxCBN9g1RDXFuA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 15:58, Greg KH wrote:
> On Mon, Aug 22, 2022 at 03:49:51PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/8/22 15:33, Greg KH wrote:
>>> On Mon, Aug 22, 2022 at 03:24:53PM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2022/8/22 14:25, Greg KH wrote:
>>>>> On Mon, Aug 22, 2022 at 09:15:59AM +0800, Qu Wenruo wrote:
>>>>>> Hi,
>>>>>>
>>>>>> When backporting some btrfs specific patches to all LTS kernels, I =
found
>>>>>> v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
>>>>>> (edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).
>>>>>>
>>>>>> While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.x,
>>>>>> 5.18.x, 5.19.x) can boot without a hipccup.
>>>>>>
>>>>>> I tried the following configs, but none of them can even provide an
>>>>>> early output:
>>>>>>
>>>>>> - CONFIG_X86_VERBOSE_BOOTUP
>>>>>> - CONFIG_EARLY_PRINTK
>>>>>> - CONFIG_EARLY_PRINTK_EFI
>>>>>>
>>>>>> Is this a known bug or something new?
>>>>>
>>>>> Has this ever worked properly on this very old kernel tree?  If so, =
can
>>>>> you use 'git bisect' to find the offending commit?
>>>>
>>>> Unfortunately the initial v4.14 from upstream can not even be compile=
d.
>>>
>>> Really?  Try using an older version of gcc and you should be fine.  It
>>> did build properly back in 2017 when it was released :)
>>
>> Yeah, I'm pretty sure my toolchain is too new for v4.14.0. But my distr=
o
>> only provides the latest and mostly upstream packages.
>>
>> It may be a even worse disaster to find a way to rollback to older
>> toolchains using my distro...
>>
>> Also my hardware may not be well suited for older kernels either.
>> (Zen 3 CPU used here)
>>
>> In fact, I even find it hard just to locate a v4.14.x tag that can comp=
ile.
>> After some bisection between v4.14.x tags, only v4.14.268 and newer tag=
s
>> can even be compiled using latest toolchain.
>> (But still tons of warning, and tons of objdump warnings against
>> insn_get_length()).
>>
>> I'm not sure what's the normal practice for backports to such old branc=
h.
>>
>> Do you stable guys keep dedicated VMs loaded with older distro just for
>> these old branches?
>
> I don't, that's why those kernels can be built with newer versions of
> gcc.
>
> Your distro should have a version of gcc-10 or gcc-9 that can be
> installed, right?

This may sounds like a meme, but I'm really using Archlinux for my VM
and host, and it doesn't provide older GCC at all.

>  Or maybe use the gcc versions on kernel.org that only
> work for kernel builds?
>
>> If so, any recommendation on those kinda retro distro?
>
> Try installing an old version of Debian, or better yet, use a distro
> that provides old versions of gcc :)

I guess that's the only way to go.

Thanks for all the advice,
Qu

>
> good luck!
>
> greg k-h
