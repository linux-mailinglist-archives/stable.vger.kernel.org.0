Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9910D11CDFB
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 14:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfLLNPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 08:15:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1025 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729400AbfLLNPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 08:15:30 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df23d6a0000>; Thu, 12 Dec 2019 05:15:22 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 12 Dec 2019 05:15:29 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 12 Dec 2019 05:15:29 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Dec
 2019 13:15:27 +0000
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191212100524.GC1470066@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <6cf4afbe-4fa3-6bbd-4090-ff9764c4fce1@nvidia.com>
Date:   Thu, 12 Dec 2019 13:15:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191212100524.GC1470066@kroah.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576156523; bh=7Al3QjP99DvXMm1hd3/NVJputCG/Ntlw35+vloFH3dw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ino7v40jBwo5JgJ08zzBUMeDDZmvXjUkhV0a6jSn8lUqSiKCjEq2DCMheSvb2djef
         +fZFn3nNIeMVsPMxyS4K74L+77OdqiS0BP5A9eT1mBFeT3Kow+HC3TOKYv/y9Y05qo
         nc4sxnxaG3ELv9by6c2Q7PkPOyi7LCSZRYJdaTo1huR5tU5cjAJS7BBS45Y30oAoyR
         UDgWJBGJGXNsrLwc5rjO1Ijoewaza/EypjRrQ4tdxKam6riQGi7pQOoSlU443dlFBd
         FtP/veyZIMdBJHuw0+bzQvSRT5kf2KgrNIsTWbSwny2S06Rf7TOOd8KKMVXW4dTH9f
         v26zOLPZCIG9A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/12/2019 10:05, Greg Kroah-Hartman wrote:
> On Wed, Dec 11, 2019 at 04:02:42PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.89 release.
>> There are 243 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
> 
> I have pushed out -rc2 with a bunch of fixes for existing issues, and
> some new fixes:
>  	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc2.gz
> 


All tests are passing for Tegra ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.89-rc2-gb71ac9dfc6f0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
