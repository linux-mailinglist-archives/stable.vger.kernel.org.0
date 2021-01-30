Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C559D3094AA
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 12:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhA3LNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 06:13:34 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13268 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhA3LNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 06:13:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60153f350000>; Sat, 30 Jan 2021 03:12:53 -0800
Received: from [10.26.74.139] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 11:12:50 +0000
Subject: Re: [PATCH 4.9 00/30] 4.9.254-rc1 review
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20210129105910.583037839@linuxfoundation.org>
 <7002f2eaccbe4822ace69408bdf67448@HQMAIL105.nvidia.com>
Message-ID: <f39129e5-6d38-6c33-f31e-cf15e4c0399d@nvidia.com>
Date:   Sat, 30 Jan 2021 11:12:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7002f2eaccbe4822ace69408bdf67448@HQMAIL105.nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612005173; bh=wbKKSPFv7rGHUAFgEhp4QjkXiqJiuFWXorSO27ViRdY=;
        h=Subject:From:To:CC:References:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=kBpBumaTtce3C8abkoyXARWV69eQXZvdNTyEWdpLaKCqtqG70HL6xT3GkwPHve4qZ
         l93quEGwnxCPUPWVdO4nZSd8g3k9TxeEawouAEXPICdbokciDSdAXmOGB/kJzmyF9K
         qfJSdJe/XcnzDLvvc1kLhS8gILRAAAM8gTt7ira9hDaejlLhPMDTnhpNfMCQYiPbkP
         fEMKG/QK/phi6sSamL1BvKRcmj9QGD6H+4uJcC9fSdG0Ydvo6eII0Qu+PF+GEL+iEu
         JfxFVmHTAPx1s/yN/Wti/qcS1nVrOLL74GJAm/HCPab+n0iQDcPXVPKps2wDGDkvzc
         eQjS2VFPw3Kzw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/01/2021 19:08, Jon Hunter wrote:
> On Fri, 29 Jan 2021 12:06:36 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.254 release.
>> There are 30 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.254-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v4.9:
>     8 builds:	8 pass, 0 fail
>     16 boots:	16 pass, 0 fail
>     30 tests:	30 pass, 0 fail
> 
> Linux version:	4.9.254-rc1-g1aa322729224
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Jon


For some reason I don't appear to be receiving the 'review' request
emails. We have a script that checks for them on lore.kernel.org/lkml
but I don't seem to find them there either ...

https://lore.kernel.org/lkml/?q=%5BPATCH+4.14+00%2F50%5D+4.14.218-rc1+review

https://lore.kernel.org/lkml/?q=%5BPATCH+4.19+00%2F26%5D+4.19.172-rc1+review

I thought it was our mail server but then I would have thought I would
see them on lore. I often see a delay but they usually arrive within a day.

Cheers
Jon
 --
nvpublic
