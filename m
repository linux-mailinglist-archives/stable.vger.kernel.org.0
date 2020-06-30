Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE120F144
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 11:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgF3JNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 05:13:40 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10094 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgF3JNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 05:13:40 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efb01e10000>; Tue, 30 Jun 2020 02:12:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 30 Jun 2020 02:13:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 30 Jun 2020 02:13:39 -0700
Received: from [10.26.75.203] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 30 Jun
 2020 09:13:37 +0000
Subject: Re: [PATCH 4.9 000/191] 4.9.229-rc1 review
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9d3a7edb-b77a-7685-e7d1-429714b30f8e@nvidia.com>
Date:   Tue, 30 Jun 2020 10:13:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593508321; bh=LTu0wf4kct2AHfKcOO4pUOpznKhxD3WZP89FUpNgepk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=WlnvDMeGrfrnqhgvrOLHOV2QCPeNuoICKvOOr7h1Di26E75ZUcTfJ23G/SUpKT4wv
         luS6fRO0EcRDKWCODwZEQKhzF5kK7iHoYxsXR69FlCFj8goMCMVjpTi2LpnCaN2KxG
         5YuyhKaYhllEHsVqpZuE7UegbaJLD5m2D+5KLwbeO5vopue/GubwReEneq9kP0Mt2g
         EyKvv6lNvQ1dbtrMnGHc0cw/o1vaLrr4rstr16kZ9EC6sYvu7gGn9WMolPhIYNVauv
         UU3xzTdS6Eo9Zh7xCR3Dru3tLsT3T9XUoMAEcpApydc9xGMs4UDI8Llz4ZgUxkLQZF
         wwH3Y9tZaIFkw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/06/2020 16:36, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.9.229 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:40:00 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.9.y&id2=v4.9.228
> 
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> --
> Thanks,
> Sasha

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.229-rc1-g082e807235d7
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
