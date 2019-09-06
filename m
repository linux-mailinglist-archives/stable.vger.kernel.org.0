Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A25CAB344
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 09:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389197AbfIFHg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 03:36:28 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9257 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfIFHg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 03:36:28 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d720c7c0000>; Fri, 06 Sep 2019 00:36:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 06 Sep 2019 00:36:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 06 Sep 2019 00:36:27 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Sep
 2019 07:36:24 +0000
Subject: Re: [PATCH 4.9 00/83] 4.9.191-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190904175303.488266791@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <638b9ce1-cc97-618e-c773-8e6146abe9dc@nvidia.com>
Date:   Fri, 6 Sep 2019 08:36:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1567755388; bh=k07LZH3jYgCyfyV+/4toHxVIUjjY5lwyTKMIEyqrtkI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZccFLYKR2jBCKII3sZF4BPqIfQ1vOpDrGkC7hN4VKry3cvXOH2deIXuEt4Y9z4zUN
         701kNiJQxuRo2wGGJGICysRrdW1UIjuE3CYltNOr1D99Q+Clc6/DGrGYJf+xgxlrOP
         Iyu5Djfda2D4CQWq8uQntbB7RYDbctgvB0UID7srteTd7K2Krn0hHILJvTjjrJbSFc
         SEz8RJYFTz0UZCmayhCbJdcjnKz9nBPCTRvnDjIocOqU7ko1YSS0O9Ah/jnFK3tVg5
         r62CaTugkScLC3u/if4x3dNeujAlunMdGQSduNQWmKbwr9SHVrrgPONrTuNyHFszqw
         oS5LVeza2sV/Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/09/2019 18:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.191 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.191-rc1-ga232f5b3e312
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
