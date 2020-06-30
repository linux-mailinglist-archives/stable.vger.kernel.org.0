Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC1120F150
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 11:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgF3JOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 05:14:48 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10188 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729866AbgF3JOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 05:14:47 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efb02240003>; Tue, 30 Jun 2020 02:13:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 30 Jun 2020 02:14:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 30 Jun 2020 02:14:47 -0700
Received: from [10.26.75.203] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 30 Jun
 2020 09:14:44 +0000
Subject: Re: [PATCH 4.19 000/131] 4.19.131-rc1 review
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <75018b0b-90a5-f69a-a170-d201074e8208@nvidia.com>
Date:   Tue, 30 Jun 2020 10:14:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593508388; bh=fFCksa1+8mFyliE/o5IQnSV/qxBrN3iLDWjoin3nWWg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hJc7cg/BYFbsgwStRtUDPTuQAlUAt3cJ7DgYdzYzIIm1oDKicdsoJuRRWH4+CbLsN
         AwPZpGSersGorQ41b9uvaOLBNOqPZ5amx6idpWvdUkNBO2Av3f07QnOftCkLQr/mBc
         t6URRzPp1OAE/5943dttD9biX8mgTmaIc/jBH868c0+ehz21XmOy0RqbKwIuf0AWKJ
         ++5ms5N++Kgv7TrSpg+L3MdKPmDuUss8HxkrnVnUrevVsGcrzxfHb5bIkMDgL7ffos
         DtTgSJfM/N0RTxC82aDQNlouUQr2Vwx/xmon7RXd3vWw3/YOHyFSPwNiNx+WqGtY8e
         nQP7tyvMvXpEw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/06/2020 16:32, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.131 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:34:57 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.19.y&id2=v4.19.130
> 
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> --
> Thanks,
> Sasha

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.131-rc1-gd77d34fc4818
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
