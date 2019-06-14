Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA645A6A
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 12:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfFNK3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 06:29:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5922 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfFNK3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 06:29:49 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d03771c0000>; Fri, 14 Jun 2019 03:29:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 14 Jun 2019 03:29:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 14 Jun 2019 03:29:48 -0700
Received: from [10.26.11.12] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Jun
 2019 10:29:45 +0000
Subject: Re: [PATCH 4.19 000/118] 4.19.51-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20190613075643.642092651@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f3984fd7-e5f7-92c6-ecc6-d21e700ccb01@nvidia.com>
Date:   Fri, 14 Jun 2019 11:29:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560508189; bh=5D2yI8MYIL8SD8Q+3MVWw12CheDWJS6bgVRjT/j7ayM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nrh7mspP+NZyksoWs9d4lAUfgTX8ST/tW08C1t8tn6jZJZSy7N+4banAvpVtNcein
         oZ1yrn2pbwy2FTm3oLd3+r0pVwyDF+K796CiejCt6m8KW/McZMWhXvLMSDX/TTJdIv
         YeIZiBCI5HlURa4Xn+a85Fi7bURQshItXSJ6dsnVJIee6udBVUllJtMz8+ZzvVg34N
         qakM7XwMQP6qdcKy9eGRsvmJ/cPfluYTTTTTSaGcYb3+WknBhWuN1ayMPT5yHuZTmn
         ntqwK2tEuTviFu0D0xCsypo8+zdMsCid1HEBI5KCFoMm5o/VODJDBM57nk9vjadTgf
         1E7uOhMaVbEig==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/06/2019 09:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.51 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:44 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.51-rc2-gc6c7a311e997
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
