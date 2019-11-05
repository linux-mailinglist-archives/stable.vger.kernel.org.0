Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF06EF0A43
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 00:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfKEXhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 18:37:09 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14904 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfKEXhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 18:37:08 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc2076b0000>; Tue, 05 Nov 2019 15:36:11 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 05 Nov 2019 15:37:08 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 05 Nov 2019 15:37:08 -0800
Received: from [10.26.11.93] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Nov
 2019 23:37:05 +0000
Subject: Re: [PATCH 4.9 00/62] 4.9.199-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191104211901.387893698@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a6e1d805-9fa1-d91e-a926-b622ce9522d7@nvidia.com>
Date:   Tue, 5 Nov 2019 23:37:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572996971; bh=l8Oc9pKpZdVoadwDGCTi1UoHamNMAHw9yUehG7ff5+M=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=jjh02ztPqzKSpU6wnko2/qR3WK79eSBD9+dbuHLdRpx8Aej88UpHUy7Pu0a0U2DGn
         FG6ngRBapGdhn/xzRUWY/EXA4GKrkz63GJ/NzmTF/favPmW8rKzZkUUu0xuQnTWad+
         ElFkiwbhmULjS+M8TLDKT+VwPmur6SCzhUO9pFS9rLk5uZ772aeuTvhGJGfO1Tbwnx
         HPCRijT9UcD73T48hFRPNW4IG9304cbfmSHZcQLxgPAkvkRadiDiC2SgIxSTSKcIM3
         NvPbsX6aj0STLihpQ9JO2havxAq0yAbReZYiD8MCEbahqKmpgHkzUnV2kXMphbK6g7
         5rOdEJfj4UUuA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/11/2019 21:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.199 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests for Tegra are passing ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.199-rc1-g4e59c9878a95
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
