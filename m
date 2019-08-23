Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DE59A53E
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 04:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389091AbfHWCJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 22:09:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4821 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388508AbfHWCJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 22:09:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d5f4abe0000>; Thu, 22 Aug 2019 19:09:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 22 Aug 2019 19:09:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 22 Aug 2019 19:09:00 -0700
Received: from [10.2.172.208] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 23 Aug
 2019 02:08:59 +0000
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <c2bdb1c2-1651-d405-a7fd-3d77bd91f7b1@nvidia.com>
Date:   Fri, 23 Aug 2019 03:08:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1566526142; bh=LESCPHa8uCDYwP1a0Y191kdUGDMYbHp7qTrT6eu/rwo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=pVjf9ZpYctaZUF2Alv8yKPV6vAxhJ6Zwr4e08lde7clYZ7SlST8sBTaOuO48mBLoF
         +vh5bV+qSl3wbsGpaBaEnvKaniFQ9jzEECgvzCawhKrcNyC3NhPY3AhZuMQUJHgADK
         mIDK4uHKKmryQX6U9ZTiuLrIdjEE04piEvtWLWBH8B0bLnFiWH2GwBtwpFKd+G0EA6
         l8zb/B1pkebJ/6Y3y+6Mo8uTHtlHAeI2WvqA/QBYtB+tyq0TIUw5b7yL8cgk0QowPJ
         1tQvbAevVCcyc6Y7KV0KGoqgcC2BZ0uPfSaIXnCIZepbJkg2rwvgaLS5T63/E2FeQH
         Y+4EzWp8xIAlg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/08/2019 18:05, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.2.10 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> --
> Thanks,
> Sasha

All tests for Tegra are passing ...

Test results for stable-v5.2:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.2.10-rc1-gf5284fbdcd34
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
