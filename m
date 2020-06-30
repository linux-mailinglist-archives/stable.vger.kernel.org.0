Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1189C20F16D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 11:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgF3JUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 05:20:32 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1168 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgF3JUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 05:20:31 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efb03ae0000>; Tue, 30 Jun 2020 02:19:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 30 Jun 2020 02:20:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 30 Jun 2020 02:20:31 -0700
Received: from [10.26.75.203] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 30 Jun
 2020 09:20:28 +0000
Subject: Re: [PATCH 4.14 00/78] 4.14.186-rc1 review
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <90a6431c-db16-08bd-4e1b-e23b0d9961a3@nvidia.com>
Date:   Tue, 30 Jun 2020 10:20:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593508782; bh=gLyyXB6z9jO0ZeKepoSp8g8i3vQ+9fUEXPT7UE8Eo1E=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cGzM/m8OhpEYV8PBbU1C5Is40cEDasAAV3/srMxkdfXp4EDCg/EXfvZaILncASqIw
         G4G7xk89f7o2KszU1T46ZDy6iWAGGSpruKaWJZ68iGXP4cIW5TXiKn8OnQtSyqe/gz
         xPDle5gKQeifsM4sk9Ekrzs3VZ9GEWRz6J8KwYsINM8hxL7GK3xnr9eVWbRt8NpbJs
         YPa5GmGm7Vs+cu8pZx3iGiicmrZO+t/wYEbiigyP4BsgRqE7+B1DrAjUIEwog8yJnI
         d9PM8K/HUVx6J6OyMsEWM/GX5wLvwU1nxKE6Q74b9wXbM9KOuu7Q8E88HPrstWhOsP
         bF9sNsSixkplQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/06/2020 16:36, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:38:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.14.y&id2=v4.14.185
> 
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> --
> Thanks,
> Sasha

Something does not seem right here. I believe that Greg released
4.14.186 last week [0] and now the makefile is showing 4.14.187-rc1 [1].
So maybe the subject and above are a typo? Anyway, for 4.14.187-rc1 ...

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.187-rc1-g27e703aa31e4
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

[0]
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/tag/?h=v4.14.186
[1]
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/tree/Makefile?h=linux-4.14.y

-- 
nvpublic
