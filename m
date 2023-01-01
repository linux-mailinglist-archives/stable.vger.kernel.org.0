Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC765A990
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 11:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjAAKMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 05:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjAAKMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 05:12:30 -0500
Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E7F2DF7
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 02:12:28 -0800 (PST)
Date:   Sun, 01 Jan 2023 10:12:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.kalamlacki.eu;
        s=protonmail2; t=1672567945; x=1672827145;
        bh=dyynCzP9RuINtFBa6SR0eI8VCSq3NSEnFM9dlvdeb/w=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=uT/u8Gv+jP/sg6Sgsg0bYuOCpTw2lLBYU0gVNbIe+9gByMVHVK8cLSPHT99a/kbQQ
         eRulicNT711FHny5CXLrT3sXJ1igBsv6bR7jTMnrocr6zJqtRj9aAgwOawBc77RsJM
         p8OgMJPaOD39Nl33FemVT/xgt2zYij0TstaepPkxZt25bPb19MaKgjhmv2T2xs+Dkb
         I+hRxPAX738qA0ZmSgViDYklo9o/LahuCEfO0axKODkIO1Fxs8sdAPNRLHTDXQ/TGe
         A7WlOojy4bHz66JYgYQMxwdEH+lD3UTJHuahTAYBq9ANMl5Oo6o6bZUHmpaOq4DcAG
         wL2GIAM1QxPow==
To:     Willy Tarreau <w@1wt.eu>
From:   =?utf-8?Q?=C5=81ukasz_Kalam=C5=82acki?= <lukasz@pm.kalamlacki.eu>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <36e196c7-849f-bcda-4dbc-da9c0c492bbd@pm.kalamlacki.eu>
In-Reply-To: <20230101100518.GA21587@1wt.eu>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu> <20230101065337.GA20539@1wt.eu> <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu> <Y7FIo0Eup6TKswTA@kroah.com> <187e8f10-2b73-3a18-d9ad-48b2d84bd6b9@pm.kalamlacki.eu> <20230101100518.GA21587@1wt.eu>
Feedback-ID: 42407704:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1.01.2023 11:05, Willy Tarreau wrote:
> On Sun, Jan 01, 2023 at 09:01:22AM +0000, Lukasz Kalamlacki wrote:
>> On 1.01.2023 09:47, Greg KH wrote:
>>> On Sun, Jan 01, 2023 at 08:14:12AM +0000, Lukasz Kalamlacki wrote:
>>>> On 1.01.2023 07:53, Willy Tarreau wrote:
>>>>> On Sat, Dec 31, 2022 at 04:58:51PM +0000, Lukasz Kalamlacki wrote:
>>>>>> Hey,
>>>>>>
>>>>>>
>>>>>> Do you have an issue compiling 6.1.2 linux kernel?
>>>>>>
>>>>>> I cannot compile it.
>>>>> For me it compiles and boots. You'll need to share your config and er=
ror
>>>>> report if you want to get some help.
>>>>>
>>>>> Willy
>>>> I was trying to compile on Debian Bullseye where default gcc is versio=
n
>>>> 10, when I upgraded gcc to version 12 from sid repo i Was able to
>>>> compile too. On stable Debian without addition during compile
>>>> "segmentation fault" occurs at the compilation of cx8-i2c.c file. You
>>>> can try on kvm or virtualbox this compilation.
>>> Sounds like a gcc bug you should be notifying the gcc developers about.
>>>
>>> good luck!
>>>
>>> greg k-h
>> To be precise I have this on gcc 10 in Debian:
>>
>>
>> during GIMPLE pass: fre
>> drivers/media/pci/cx18/cx18-i2c.c: In function 'init_cx18_i2c':
>> drivers/media/pci/cx18/cx18-i2c.c:300:1: internal compiler error:
>> Segmentation fault
>>   =C2=A0 300 | }
> As Greg said it's definitely a compiler bug, so it will interest Gcc
> developers, or your distro's gcc package maintainers in case it's not
> up to date. There are toolchains available on kernel.org here:
>
>     https://mirrors.edge.kernel.org/pub/tools/crosstool/
>
> The laest 10.x available is 10.4. If it works with this one it may indica=
te
> that your package is lacking some recent fixes, so it might be a question
> for your distro's gcc package maintainers. If it fails it indicates a bug
> not yet fixed in gcc and your distro maintainers won't be of any help her=
e,
> you'll have to report it to the gcc devs instead.
>
> Note that they'll very likely ask about a reproducer (and most likely you=
r
> config). But a quick test for me with this driver built as a module on
> x86_64 with gcc-10.4 from kernel.org doesn't show any problem:
>
>    $ make CROSS_COMPILE=3D/f/tc/nolibc/gcc-10.4.0-nolibc/x86_64-linux/bin=
/x86_64-linux- drivers/media/pci/cx18/cx18-i2c.o
>    (...)
>      CC [M]  drivers/media/pci/cx18/cx18-i2c.o
>    $ ll drivers/media/pci/cx18/cx18-i2c.o
>    -rw-rw-r-- 1 willy users 33920 Jan  1 11:00 drivers/media/pci/cx18/cx1=
8-i2c.o
>
> Hoping this helps,
> Willy


Allright, my kernel config is available here:
https://kalamlacki.eu/KERNELS/kconfig-6.1

Compilation on 11th gen i5 core cpu using command:

make -j 9 bindeb-pkg


Best,

=C5=81ukasz


