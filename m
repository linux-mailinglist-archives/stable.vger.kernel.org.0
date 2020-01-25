Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8690114953B
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 12:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAYL1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 06:27:15 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12016 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgAYL1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 06:27:15 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2c25e30000>; Sat, 25 Jan 2020 03:26:28 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 25 Jan 2020 03:27:14 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 25 Jan 2020 03:27:14 -0800
Received: from [10.26.11.150] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 25 Jan
 2020 11:27:11 +0000
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <shuah@kernel.org>,
        <patches@kernelci.org>, <ben.hutchings@codethink.co.uk>,
        <lkft-triage@lists.linaro.org>, <stable@vger.kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124235537.GB3467@roeck-us.net>
 <cd504bb5-44b1-415b-edc7-21ee69e9d1fa@nvidia.com>
 <f634b705-a561-33ee-0b6f-e3f5c1164b38@roeck-us.net>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5cd2fc9a-e77b-89e5-a752-f3e17615c3d3@nvidia.com>
Date:   Sat, 25 Jan 2020 11:27:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f634b705-a561-33ee-0b6f-e3f5c1164b38@roeck-us.net>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579951588; bh=UbGH0wYqwHOi6cUko4B3d4ba7MgU1urGnUdIbx79At4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YryjmoVRCeJCkG2eHnAzsuVVFWvYAI5IQSv78VK2w8Tdmwfmu3n1QaNzqOx8n6Rro
         sPRqCvZI7ySTUTq0yF608a2HufDLjYOJfUMkn4LPa1DSYrYaaIzFxHesIsEMUT+jJg
         JtTzKK2vNn+ZlAA7NHnvuqVq+Aw+B2jf+YtTFn6FFO3Qebjk9XxfIn44mTHlVk2h3p
         ipstYAESbXkNw0rPqOMrsMKlWxwIaKh6boVc2ajYSpqCWypIkwAdAcpYjTHawa7nS/
         hXuv2ATt1uyPSCBvzidKxzOhUXzuBy2aHN6XRab2a6ueSpb2Cr+c6VelVliKEGDRaY
         jpKrGRs+9iGgw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 25/01/2020 09:25, Guenter Roeck wrote:
> On 1/25/20 12:24 AM, Jon Hunter wrote:
>> Hi Guenter,
>>
>> On 24/01/2020 23:55, Guenter Roeck wrote:
>>> On Fri, Jan 24, 2020 at 10:22:50AM +0100, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 4.19.99 release.
>>>> There are 639 patches in this series, all will be posted as a response
>>>> to this one.=C2=A0 If anyone has any issues with these being applied, =
please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> For v4.19.98-638-g24832ad2c623:
>>
>> This does not appear to be the correct tag/version for this review.
>>
>=20
> It is the tip of v4.19.y.queue in my test system.
>=20
> $ git describe local-stable/linux-4.19.y.queue
> v4.19.98-638-g24832ad2c623
>=20
> and the tip of the stable-queue repository as of right now.
>=20
> $ git describe stable-queue/linux-4.19.y
> v4.19.98-638-g24832ad2c623
> $ git remote -v | grep stable-queue
> stable-queue=C2=A0=C2=A0=C2=A0
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> (fetch)
> stable-queue=C2=A0=C2=A0=C2=A0
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> (push)
>=20
> What is wrong with it ?

Ah you are right, there is nothing wrong now I look at the git describe
output. At first glance I thought the tag was not correct.

Sorry for the noise.

Jon

--=20
nvpublic
