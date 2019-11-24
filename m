Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7EA1084F1
	for <lists+stable@lfdr.de>; Sun, 24 Nov 2019 21:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKXUbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 15:31:51 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16532 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfKXUbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 15:31:51 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddae8b10000>; Sun, 24 Nov 2019 12:31:45 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sun, 24 Nov 2019 12:31:50 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sun, 24 Nov 2019 12:31:50 -0800
Received: from [10.26.11.72] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 24 Nov
 2019 20:31:48 +0000
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <ben.hutchings@codethink.co.uk>,
        <lkft-triage@lists.linaro.org>, <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
 <20191122133931.GA2033651@kroah.com> <20191122134131.GA2050590@kroah.com>
 <20191122134627.GB2050590@kroah.com>
 <9f976044-2dbc-6c19-11e7-210cd7ab35ea@nvidia.com>
 <a5d68f07-5f9a-2809-404d-bcd8ca593d70@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7edc9531-347e-9ac7-2583-5efb49acffdb@nvidia.com>
Date:   Sun, 24 Nov 2019 20:31:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a5d68f07-5f9a-2809-404d-bcd8ca593d70@roeck-us.net>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574627505; bh=00RRY3NaEJ+g/qehFKv0amPP36sLphWXusYUYs+gDpA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nYZ/N/gvrod1y9ak8zagU6vP3NjfW17eLBEl9WyXCjGPKS554H0nJ6caP6AwRytBb
         c94UB12i42wof58w//PupvHdlAPQc1I/eZztaBO5x80ykrvJijn0559SZn9zVVwewF
         woF85np56xaK6ZFtxpHhHQJ4c7t4FkA708oqREPhMATjs4EKRoUKTu2z9dKqMDDJ0M
         Lv8pBQbviLwjkoOrSd/Y6YxL0Us4Raw/bPBh6olPkIwoQvL/vJNM0Z0JGtejtlM4Fa
         wTZ3RdvhOve4aAHsWnOsMhOEqJ3kSpPp6ldDdMICuFnUEciHMToWRAfgxBw0a/rGJC
         rhu4uAtaAeCKg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/11/2019 15:46, Guenter Roeck wrote:
> On 11/22/19 6:48 AM, Jon Hunter wrote:
>=20
> [ ... ]
>=20
>> Error: arch/arm/boot/dts/omap5-board-common.dtsi:636.1-6 Label or path
>> dwc3 not found
>> FATAL ERROR: Syntax error parsing input tree
>> scripts/Makefile.lib:293: recipe for target
>> 'arch/arm/boot/dts/omap5-igep0050.dtb' failed
>> make[1]: *** [arch/arm/boot/dts/omap5-igep0050.dtb] Error 1
>> arch/arm/Makefile:338: recipe for target 'dtbs' failed
>> make: *** [dtbs] Error 2
>>
>>
>> This is caused by the following commit ...
>>
>> commit d0abc07b3d752cbe2a8d315f662c53c772caed0f
>> Author: H. Nikolaus Schaller <hns@goldelico.com>
>> Date:=C2=A0=C2=A0 Fri Sep 28 17:54:00 2018 +0200
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 ARM: dts: omap5: enable OTG role for DWC3 contr=
oller
>>
>=20
> On top of the breakage caused by this patch, I would also argue
> that it is not a bug fix and should not have been included
> in the first place.
>=20
> The dwc3 label was added with commit 4c387984618fe ("ARM: dts: omap5:
> Add l4 interconnect hierarchy and ti-sysc data"). Given the size of
> that patch, I highly doubt that a backport to 4.4 would work.

FYI ... I am still seeing a build failure because of this with -rc2 ...

Test results for stable-v4.4:
    6 builds:	3 pass, 3 fail
    6 boots:	6 pass, 0 fail
    11 tests:	11 pass, 0 fail

Linux version:	4.4.203-rc2-gdbaac4c54573
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

--=20
nvpublic
