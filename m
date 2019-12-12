Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2369D11CC14
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 12:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbfLLLTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 06:19:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15830 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728722AbfLLLTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 06:19:52 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df222500000>; Thu, 12 Dec 2019 03:19:44 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 12 Dec 2019 03:19:51 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 12 Dec 2019 03:19:51 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Dec
 2019 11:19:48 +0000
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191211150339.185439726@linuxfoundation.org>
 <7b43a504-160f-e793-99b2-bcb79d331b6a@nvidia.com>
 <8de7c018-32c7-f46e-4c43-ea3a70378a14@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <892c8078-6db4-d821-43fd-cacf09ca26b9@nvidia.com>
Date:   Thu, 12 Dec 2019 11:19:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <8de7c018-32c7-f46e-4c43-ea3a70378a14@roeck-us.net>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576149584; bh=+AfDW9ORdIXJCM0WDuhqoJWQ1Cb1LoHKsESwe9yzTJs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=fmsAJ85hmBfIoNIrB37Mpne0ALpWuhLh36TGBQIgnvlIUGt1tB3CR413a2TQHBN+H
         vkKACDbeap+G+Shdsio6EbFskVUsbXGoYDWO+s7r6qmRAVkaQev6brFJJwiS+d8IPZ
         Px5ipvfBZsTytTOh/2fqPztw8m3jWFQdApMQM/HgfsaKM4aZVyUuWAIF73lfxwMCfC
         cqvqoHaQ4LCi6viEw+xpHVXLQ6HiGwq8sbXE3CzwhhT+aajFi02PdzMdR3jP1sEuTK
         nr6lqq/TLjbym+gvT9kTvuLyRKmEbSyOL0jz32gZXWguctdkVf7ksCz9KSTqcrk/jP
         wnU3lwvDo684g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/12/2019 01:40, Guenter Roeck wrote:
> On 12/11/19 1:36 PM, Jon Hunter wrote:
>>
>> On 11/12/2019 15:02, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.89 release.
>>> There are 243 patches in this series, all will be posted as a response
>>> to this one.=C2=A0 If anyone has any issues with these being applied, p=
lease
>>> let me know.
>>>
>>> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> =C2=A0=C2=A0=C2=A0=C2=A0https://www.kernel.org/pub/linux/kernel/v4.x/st=
able-review/patch-4.19.89-rc1.gz
>>>
>>> or in the git tree and branch at:
>>> =C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pub/scm/linux/kernel/git/s=
table/linux-stable-rc.git
>>> linux-4.19.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>
>> ...
>>
>>> Linus Walleij <linus.walleij@linaro.org>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 gpio: OF: Parse MMC-specific CD and WP propert=
ies
>>
>> The above change is causing intermittent failures on Tegra30 eMMC.
>> Reverting this change on top of the 4.19.89-rc1 fixes the problem.
>>
>=20
> Thanks for tracking that down. I see boot failures for arm:vexpress-a9
> when trying to boot from mmc.
>=20
> I dimly recall that this was a problem before. Ah yes ... commit
> 89a5e15bcba8
> ("gpio/mmc/of: Respect polarity in the device tree") fixes the above
> commit.
> Can you give it a try ?

Thanks. I did try this and I can confirm that it does indeed work,
although does not apply cleanly.

Cheers
Jon

--=20
nvpublic
