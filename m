Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D6F1095B1
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 23:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfKYWp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 17:45:27 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9919 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYWp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 17:45:26 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddc59880000>; Mon, 25 Nov 2019 14:45:28 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 Nov 2019 14:45:25 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 Nov 2019 14:45:25 -0800
Received: from [10.26.11.207] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 22:45:22 +0000
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
 <20191122133931.GA2033651@kroah.com> <20191122134131.GA2050590@kroah.com>
 <20191122134627.GB2050590@kroah.com>
 <9f976044-2dbc-6c19-11e7-210cd7ab35ea@nvidia.com>
 <a5d68f07-5f9a-2809-404d-bcd8ca593d70@roeck-us.net>
 <7edc9531-347e-9ac7-2583-5efb49acffdb@nvidia.com>
 <20191125094116.GA2340170@kroah.com>
 <a6830303-ff96-f7df-b504-ab226aefddca@nvidia.com>
 <20191125160305.GD2683321@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <013aa2b3-9a68-6227-36bc-093d03547fce@nvidia.com>
Date:   Mon, 25 Nov 2019 22:45:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125160305.GD2683321@kroah.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574721928; bh=/jzytWjKLuYpdZNdb1F0PaN/rMy1Z9oILVLNNnY+7N4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=HhXajJ5m4zrGBoHBAJC1hmi7W2UGQYz+jJZ8LUNVVB7RxV0F+KxMK8wQ8nLS810+J
         SSUo7N0qL5tzBv69eIPImJ5JZc9TxmaKC2fpLUCBr6hG7a0CpZctIXSeCdx2YoSegT
         YOZhWKh5eVvsXGkZNeBG0zsuLJwrgO1az9+XY8beO+8W423n1DLRwlbB+wzEaktPFK
         mAIxib0qc9qWRtwfeFAdVZV1hks1acE6fN+Sx892JHjrpDCPSQZBXUyEwq9W053H67
         md8vqbcGTEVEpMo7rMX4XFb2jaymXEGsg/dx38yo7TdoV66nqiU+qbuIEQ+yQd/IL2
         b8FqeI1AnunGQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 25/11/2019 16:03, Greg Kroah-Hartman wrote:
> On Mon, Nov 25, 2019 at 01:22:58PM +0000, Jon Hunter wrote:
>>
>> On 25/11/2019 09:41, Greg Kroah-Hartman wrote:
>>> On Sun, Nov 24, 2019 at 08:31:46PM +0000, Jon Hunter wrote:
>>>>
>>>> On 23/11/2019 15:46, Guenter Roeck wrote:
>>>>> On 11/22/19 6:48 AM, Jon Hunter wrote:
>>>>>
>>>>> [ ... ]
>>>>>
>>>>>> Error: arch/arm/boot/dts/omap5-board-common.dtsi:636.1-6 Label or pa=
th
>>>>>> dwc3 not found
>>>>>> FATAL ERROR: Syntax error parsing input tree
>>>>>> scripts/Makefile.lib:293: recipe for target
>>>>>> 'arch/arm/boot/dts/omap5-igep0050.dtb' failed
>>>>>> make[1]: *** [arch/arm/boot/dts/omap5-igep0050.dtb] Error 1
>>>>>> arch/arm/Makefile:338: recipe for target 'dtbs' failed
>>>>>> make: *** [dtbs] Error 2
>>>>>>
>>>>>>
>>>>>> This is caused by the following commit ...
>>>>>>
>>>>>> commit d0abc07b3d752cbe2a8d315f662c53c772caed0f
>>>>>> Author: H. Nikolaus Schaller <hns@goldelico.com>
>>>>>> Date:=C2=A0=C2=A0 Fri Sep 28 17:54:00 2018 +0200
>>>>>>
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ARM: dts: omap5: enable OTG role for DWC3 c=
ontroller
>>>>>>
>>>>>
>>>>> On top of the breakage caused by this patch, I would also argue
>>>>> that it is not a bug fix and should not have been included
>>>>> in the first place.
>>>>>
>>>>> The dwc3 label was added with commit 4c387984618fe ("ARM: dts: omap5:
>>>>> Add l4 interconnect hierarchy and ti-sysc data"). Given the size of
>>>>> that patch, I highly doubt that a backport to 4.4 would work.
>>>
>>> Good catch, I have now dropped both of these patches and pushed out a
>>> -rc3
>>>
>>>> FYI ... I am still seeing a build failure because of this with -rc2 ..=
.
>>>
>>> Can you see if -rc3 is also giving you problems?
>>
>> Better, but I appear to be seeing some random suspend failures with this
>> now on one board. I will try to bisect this.
>>
>> Test results for stable-v4.4:
>>     6 builds:	6 pass, 0 fail
>>     12 boots:	12 pass, 0 fail
>>     19 tests:	18 pass, 1 fail
>>
>> Linux version:	4.4.203-rc3-g2576206c30b5
>> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>>                 tegra30-cardhu-a04
>=20
> Odd.  If you find anything interesting, please let me know.

Yes will do. Bisect has not found anything yet, so will keeping looking
to see if this is a false-positive or not.

Cheers Jon

--=20
nvpublic
