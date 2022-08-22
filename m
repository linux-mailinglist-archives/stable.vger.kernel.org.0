Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A314A59BA31
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiHVHZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiHVHZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:25:20 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C512A243;
        Mon, 22 Aug 2022 00:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661153098;
        bh=++bx+FIr/OJ8Ma7DWnnidJKg8gGmATCR+MLXDTDjB7o=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=dwBdNXeMQEe3XNFKy8GeDuaJ+uT/G3UKIPTrSqiNqamt3/5oU+HgIvdUvoSm2RyTT
         t5SLdXclKkbWavyW9bY72kE1CfsNywqC+4w4qd28AUUA8rDx7VT1mMzhBM5L8FRveW
         iPd6MrnDaWPyO2WvczrO7h5Gmp5xt4NTGVxcGVHQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MCsUC-1oYnFJ0gd6-008pLx; Mon, 22
 Aug 2022 09:24:57 +0200
Message-ID: <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
Date:   Mon, 22 Aug 2022 15:24:53 +0800
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
 <YwMhXX6OhROLZ/LR@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YwMhXX6OhROLZ/LR@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Pvs5NuqGKX357tY1B+Cjpx2O8DVXYlGmkX/e91DFFh3+ZeSahql
 Ofo4NJ+hLkV5y4fECV8KWRw08N9EhYQKihuyjWDKSPFMoydVJMHdF2fxxNHza4+vX4BPAYu
 1+DTnP41OJ+ZqPyZwXqe7Zi+F+p8knltDSBOuZ5RJGk+MAVXaROtHZ5/D7VVXpXubA+3ASt
 EwXYnibS1Noksc7/oeP4Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BlCUppmJbYY=:PMEhlSE4Bwuice/SATKWJZ
 0+WkC3TAelS5kpVct3UgaGXay0QHvPHMgbqZ0d6PPB7QPAW+eyfGzZ7e+TENioMNp/43IwQ7f
 FOxxp28o7eg11KzTp0AoZJyQ8ch+QEWeAWpA9R+NixOYThfeTRtfYb10xPxSv8348Cf6q+JZj
 ioFdhEY7mY1fYNRvU2KN27Phk7mgVj0hfxyCzOCy4c8t6+QKX+3OoHbvEn3Z4n4BjXIaTKsXs
 IQjRnLAUMWUN77OPL5rw7D5jmc04yH67vupJtCEtd+vVqiyxp++epMLcY52l68GJtikdUluV4
 N5b3WrgYk92pP02t3XhCidWJhulwIcRuOeVlJdcc+8ffl1vJBx8tUMCILEmMWQhml/6J6wYee
 I9ngtx1DVDJawj1UPatGWw+9kCNDZ+O/pclGKRWBZONGwrpXEf1uadtPHYCCTNoGTS7J/jxDc
 gmSXqQ6GVxN4hZrxouBykKU3w42bJNFNZF3En3rU87B9HewnrzzQBxt2FBwEenz0ED6FXENLE
 tkeTTJA7/CiKPFeji7h4aUpou/Xg1ikoU7EDvmqJrlSa+W/XAKOiNOI6HwCG3wjBKQZthtEMP
 /+E3pfsdLlvw2xGg6SuIi3AX3qgSu4RxpXWvQS9V0EypGNBD9kSmceCuOpnf56M6Kncu27YfN
 V9FYEZzdFLgW85Xl6d+B/V0Ijh5Uzqbts8GpgYZTZeSE83ROZIujaZJkSIcqvt0FjtxyEiFcj
 7oArtLqpXaAu1rwnz0nTLgm9APYYTfAU1MBX9vPTg/63eyTUTemg80qt3NIq3Dx0XvLnoV4i7
 S6Nix+qztrIDZovmHb9WGMWWRnlwwOdFLsfCs8IJ4igVvV6jPDCNwOkO+pbscJgcuCTdK1ZXP
 QeGSglXMP6HhQ5T9N6evQJmUyZpmzKniO4YOf2Wo+dmhYJd2HW3FIx3r7DNGuf+ad5SwCuoXI
 2LGaHP+L77mlfLVztjO0hVbKJVcQNImhSqSHw5Z/KsloOVrNH3nezXkxjjqlVBzSt3HhAyh/d
 0MSSrFxsFL9o0hUZnqo+kCfyOCRBB2o+JGrWiXbr4GcRyrcJoZr6tBWAYUv0/3N3VkwNeVlBB
 wALrYvRXk2kuko16x+dlsbxr4An1jfKCATvaDcEKKVXbVMcbVUJIzXrAw==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/22 14:25, Greg KH wrote:
> On Mon, Aug 22, 2022 at 09:15:59AM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> When backporting some btrfs specific patches to all LTS kernels, I foun=
d
>> v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
>> (edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).
>>
>> While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.x,
>> 5.18.x, 5.19.x) can boot without a hipccup.
>>
>> I tried the following configs, but none of them can even provide an
>> early output:
>>
>> - CONFIG_X86_VERBOSE_BOOTUP
>> - CONFIG_EARLY_PRINTK
>> - CONFIG_EARLY_PRINTK_EFI
>>
>> Is this a known bug or something new?
>
> Has this ever worked properly on this very old kernel tree?  If so, can
> you use 'git bisect' to find the offending commit?

Unfortunately the initial v4.14 from upstream can not even be compiled.

I'll try some more recent v4.14.x tags to see if I can get a working
release to do the bisect.

Thanks,
Qu

>
> thanks,
>
> greg k-h
