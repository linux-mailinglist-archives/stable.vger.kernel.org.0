Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30509519C70
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 11:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbiEDKAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 06:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiEDKAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 06:00:02 -0400
X-Greylist: delayed 312 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 May 2022 02:56:26 PDT
Received: from mout.web.de (mout.web.de [217.72.192.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDA926AFB
        for <stable@vger.kernel.org>; Wed,  4 May 2022 02:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1651658180;
        bh=ZkA/TzJkzPFND/cjdbPCrR54id8koA5o5avgtJ0N4OI=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Z/gzZZ23TO51KU/zwvP57J6/Ndxqa+y0M5G6xQ4is9oCKLaEg2eb7cU1aL1I2hkAs
         bHk7TW7nRGk4M7ClY5pNfE0p9wDfTAdp8Fz8aIwxHS6CpWw6ocnqcouTHPoUE9sRnQ
         Ng1szo5xkd7TBuLkTZRfquz9mdJFDEa4WNlsujK0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from uruz.dynato.kyma ([79.245.218.86]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N4eGT-1nvugk49ep-011loc; Wed, 04
 May 2022 11:51:02 +0200
Received: from [127.0.0.1]
        by uruz.dynato.kyma with esmtp (Exim 4.95)
        (envelope-from <jvpeetz@web.de>)
        id 1nmBev-0006dx-Oa;
        Wed, 04 May 2022 11:51:01 +0200
Message-ID: <7196aaa0-12a2-14c1-9abc-fa9b3fea5d7b@web.de>
Date:   Wed, 4 May 2022 11:51:01 +0200
MIME-Version: 1.0
Subject: Re: Linux 5.17.5
Content-Language: en-US
To:     JoergRoedel <joro@8bytes.org>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de> <Ym+oOjFrkdju5H6X@8bytes.org>
 <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de> <YnI2QYZ1GqmORC10@8bytes.org>
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
In-Reply-To: <YnI2QYZ1GqmORC10@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:y56njEDD4R/c2Iq6W/DXhsAvw39y/jkPqcZCKE9fxsA7pzSmGNZ
 uun7PW37n0tyAAdhe+JAdHW3HpmOL4hAqPBwXqPLf0lunJ4l6GjRkbylf5gtc6Kt8FN9vMn
 pe+LRDAQXxl/fLYiSIaDStCCnYDL1vtswhHm15Ok2xjbvFSt13uSv5ND1sNfH2hJWcLGYBd
 HZqP44GnJVf9lVda5zJIQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LzK534GdDrQ=:ZnjiwifGelc/7BCmcKU0tj
 XVyWu0NsxCRl0YZMEswtl8zH850sZlc5YUWB3TPzIzwYuZVTkBK2eBG73xPATdI6x/I519U7I
 AR7gZ61y+C0ZiKxGOWmDHPQRX6F7oHWpx9BWtSk3qWmJ40ejLTm/fMl5CJHPDUNPn97Du3yqm
 mX25C2PSVq7rTfjvjt4DbKPfSeQLeSTMZXOT+bkG3t74WDTMhT6LimE9SlTtnpd23eyo5awef
 i/sx1ASk01+hof1qpen7nbQfmtIQDuy5rwB2qDYr92EDQzw5tQyL9+m6QTBm2NzFD3cO1u+KL
 VyrQ/a0FKZ0LmDXI3i4jrKH8nImOuPPpeMqK7c9Wrfwgx3N/UFLzO5PQErxt/ReTIUwkY3ERI
 DTUQR70Lr8cWLqP/r7srnq7xV+zfxDEW0PBXgP5wcbdUC/QcUFUotruGDsjm+RqANzHhAkBJE
 u4zl2QGS3QFISoItnS2Ne8yTwynp82iJUDemkR4Zeca9fwS8JXMPVIw+r3q5BbEdS7VF0X8xQ
 S27So1D/vk6TO9VBfl7W6yF1xLmOfsUan6sH/SD1ZT86WamsYLB+DKsKDJ5+bxbfuxBUWLus4
 kxMbQ3oUsDnBS940jRUhL68c4HdFpWuDD0Hi8jy2UkMAItdr47qzqSHjvEXtKfC3Ay5JSq9Cn
 8hF78TRERLJS6bKOnfOMKuSn99ccbKS2izaSZ0pvHsjci2048HRSkaiEEz6aTsPs/J24C2Ke2
 /fawG43vK/yZhWT2whfIFbD7lmTvvL6nhVNNomecVmsoSTy4WXhBXOlSKsrjHaDHqAxCLmbgv
 ffyR0tgs+sgowT11ZK0FhviloSZIEskuguJlSEWWk3tzt2o0ZUyCSxZP62iq8sRGX12PlvFy+
 zKTOeXtCQk33RJkg7MLeareJunyIL+cskbHC1kxEDD2EnERXaUViB8AcbQh78qs5QTen7SYOZ
 N+4E1GMEbkz9UjerGeXaQ+1XHjCxHPUpxJb1XybTP7058O4JBy5Xzb7tv+mB4KKUIf/NySDRt
 H5zXuwNw1keB8tlix3IndELgvhpaCaD3ls/n9rX4n5L0iThlgLlSa7LnbDckWHJbCq3xMqNWC
 50+9v7HoEQTCxM=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joerg,

how embarrassing. Indeed, somehow my patching didn't work. But I'll better=
 it
today :-) and report back.

The Mainboard of this machine is
  Micro-Star International Co., Ltd. MS-7C94/MAG B550M MORTAR (MS-7C94), B=
IOS
1.94 09/23/2021

and the CPU is

Vendor ID:               AuthenticAMD
   Model name:            AMD Ryzen 7 5700G with Radeon Graphics
     CPU family:          25
     Model:               80
     Thread(s) per core:  2
     Core(s) per socket:  8
     Socket(s):           1
     Stepping:            0

Regards,
J=C3=B6rg.

JoergRoedel wrote on 04/05/2022 10:16:
> Hi J=C3=B6rg,
>
> On Tue, May 03, 2022 at 12:17:40AM +0200, J=C3=B6rg-Volker Peetz wrote:
>> May  2 21:50:27 xxx kernel: WARNING: CPU: 0 PID: 1 at
>> drivers/iommu/amd/init.c:851 amd_iommu_enable_interrupts+0x312/0x3f0
>
> Are you sure you tested the right kernel? My patch removes that warning,
> so it can't trigger anymore. It also adds a new warning, but in
> different file and line.
>
>> In 'kern.log' I also found this:
>>
>> May  2 21:53:27 xxx kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* =
ring gfx
>> timeout, signaled seq=3D16, emitted seq=3D17
>
> GPU errors, hard to say what triggered this. Can you please send me your
> exact MB and CPU model? There is a chance this is firmware-related.
>
> Besides that I learned that on some systems this warning only triggers
> on resume. So increasing the timeout seems to be the only viable fix.
> Can you please try the attached diff? It also prints the time it took to
> enable the GA log.
>
> Regards,
>
> 	Joerg

