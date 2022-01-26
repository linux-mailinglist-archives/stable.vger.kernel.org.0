Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E00B49D0CA
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 18:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbiAZRch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 12:32:37 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:46939 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbiAZRch (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 12:32:37 -0500
Received: from [192.168.100.1] ([82.142.25.174]) by mrelayeu.kundenserver.de
 (mreue012 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1MjxW4-1mWspV3dLE-00kQMA; Wed, 26 Jan 2022 18:32:10 +0100
Message-ID: <e4e1995c-4fc2-96b7-c732-93aa67207802@vivier.eu>
Date:   Wed, 26 Jan 2022 18:32:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: fr
To:     Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        John Stultz <john.stultz@linaro.org>, stable@vger.kernel.org
References: <20220121200738.2577697-1-laurent@vivier.eu>
 <20220121200738.2577697-3-laurent@vivier.eu> <YfFPjOEELiTWr2uj@kroah.com>
From:   Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH v12 2/5] tty: goldfish: introduce
 gf_ioread32()/gf_iowrite32()
In-Reply-To: <YfFPjOEELiTWr2uj@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XvNu/dge3CNEYzBbvj4dsSiUzfG9ERgw/LyTB6b0Aj5yx6+KZ9M
 QGo8y1Km5kIVpSrPgBY0y6SzagwYAtktnB9GjfykwLFwRi9tZQVpxJ/BnwfUOfBmFpGBIkg
 cDPFukPmaZ1y9tua0fQ3T6PWrxQW36ZmPU4d0O3wbqDvUsIN2QVlZNqHOi/+3TAWAHnJAkN
 IjKh9Z5r4mvZQ046C54nA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IUz2wLhHtK4=:YErz34dKXUUdhaRFFUq59Y
 uZ1krhP53qYSUmIzN/tcOXPkwWZ0LLwMu1OnckCFNi6IIeme5aShQRQGwrYn2g8692/Ln2qCr
 ypxE48BAfl5F/s47vkP+E5TAF291m1LB5YH9r1Kw9DlOxkGhSLFt8yBPLP4uEaeIpDYLZB1+V
 XSJ0O18w5g4NcRwSdEJiu0MdpZ0csxqvFt4br1QLqAqKscd1Vb6G3upYMtJXPxy+ZPv4QIyOd
 JAHd8fWgL1721LCPI8C2bIEKt3qSDdSiki21FRXeiaSljk9VWnrfCGi56jqtaZxdfDwgZ4k4U
 nTK1y/sccw/C1mk1YlhXrTsC4tjK5Nqf9W8vkb8u6/KDJIkRtcquMfyJgCwjidMPGpXfUFIl0
 KMrqJxwv3EAFIhUb8/QzmO0sSnNC3DVtluwYeIBQOjkUFpXQALToV8uPpX6878B0Yq/deBnkk
 lcfyTrSzyh9ygeLQIQsJ8UgG78nC4m0ixTWyM6UeT0YsZrLcCq8pGiL3X/q845lDJcJpriEkt
 pQRcHA7R5gaMDtcYG8A20FHAnVO/h/xfUXnP2imKAQo45PByF+YTwkDq2umrD3eth2o4qCdnL
 bAN44TFcq+XWvsfadMQofaXA/L4TjwGnWDZU/8Z4rdK+TtNAwR+FqhH/1HC0u8ghaq2T+ZZXS
 CnnEAo74CA35cOMfMbEJLQiXYUAFB+xRQ3ww9XkX76tEs2QhbB3Lg2QrPN9BL1j8kFCs=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 26/01/2022 à 14:41, Greg KH a écrit :
> On Fri, Jan 21, 2022 at 09:07:35PM +0100, Laurent Vivier wrote:
>> Revert
>> commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> 
> Why?
> 
>> and define gf_ioread32()/gf_iowrite32() to be able to use accessors
>> defined by the architecture.
> 
> What does this do?
> 
>>
>> Cc: stable@vger.kernel.org # v5.11+
>> Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
>> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
>> ---
>>   drivers/tty/goldfish.c   | 20 ++++++++++----------
>>   include/linux/goldfish.h | 15 +++++++++++----
>>   2 files changed, 21 insertions(+), 14 deletions(-)
...
>> -- 
>> 2.34.1
>>
> 
> This feels like a step backwards.  Why keep this level of indirection
> for no good reason?
> 

It was proposed by Arnd on my previous iteration of the series when I wanted to update goldfish-rtc 
in the same way:

https://lore.kernel.org/all/CAK8P3a1H6-sd_+FqnOq0Zhj=L51EWuW5VCcYeTENcp3+PkTC4Q@mail.gmail.com/

Keeping __raw_XXX() functions works on most of the cases except if the current CPU endianness can 
differ from the architecture one (like a ppc64le kernel (little-endian) running a ppc64 machine 
(big-endian)).

The best solution would be to update QEMU to set the device as a little-endian one, but google 
didn't merge its implemention in upstream QEMU and this would break all other OSes using goldfish 
devices on big-endian architectures.

Thanks,
Laurent
