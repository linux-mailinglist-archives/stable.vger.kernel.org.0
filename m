Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416C910C74A
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 11:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfK1K4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 05:56:03 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2609 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfK1K4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 05:56:02 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddfa7bb0001>; Thu, 28 Nov 2019 02:55:55 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 Nov 2019 02:56:02 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 Nov 2019 02:56:02 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 10:55:59 +0000
Subject: Re: [PATCH 4.9 000/151] 4.9.204-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191127203000.773542911@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <295e5845-b520-4d05-74b2-3c02904ce6d6@nvidia.com>
Date:   Thu, 28 Nov 2019 10:55:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574938555; bh=iDo6lrNeamck1m2E50sbvRPdSlzp3t6GM7ymoUGaHoA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=khZZPznu1Ai8/KGZGTH0DOLMKoGwyeXOdVNLNkDLfoM8kv3svvgHq6ZoQtl2kOeib
         nwV/EhL9lYcpqdoLrytj63uxqZadOhLMiN6EkYrb/COHoEsL5Ly17d3gZJOpuSxyQC
         ESI0zoOh/bw1KSlYzxUwBQ+shIXfObg63EoScUrcUDJgVseg2/0Rb6PM71jCSFbD9N
         KJigL64NY25UE2IuKu4n+uE470wyCvOgB34mgPoTk+IElXyOwopAe8t9sfC/2Tkkr+
         f8Qy6tOmgeMM9+HpCayvNoZ8tPWD3XcpdRFW6kPDvVJlQkVk/OqGEk/u0buY4PFO17
         Gqn+JAgCEuwFA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/11/2019 20:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.204 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.204-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.204-rc1-g3bbfc6b1c25b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
