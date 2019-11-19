Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E6A1021D0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 11:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKSKQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 05:16:55 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12002 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSKQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 05:16:55 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd3c1190000>; Tue, 19 Nov 2019 02:16:57 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 02:16:54 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 Nov 2019 02:16:54 -0800
Received: from [10.21.132.143] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 10:16:51 +0000
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191119050946.745015350@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a573d737-773b-1f94-d06f-b1d340b416ce@nvidia.com>
Date:   Tue, 19 Nov 2019 10:16:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574158617; bh=1efwVq9Q3t1oWH6RuKo5WTYSNhsT3VKL1rGqZZq2qJQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=EyQlMaKn6iIsXHJ3qAyjJGAnIzrNjTexYVKcSFT184GZegIuzwLT0c3wflPyx7caH
         vzFhqbLvsKVvV5EmNFXqDje958fBoA6gRkl+ufWZGNEm/eEbgIZdEohDor0Lk1LDey
         SLd70bGyk26pyTcWNN2EIdl87ZTUOArfaBt6iq+UouqIzZUVHCV7SKTmZsnMJCAlcg
         gfiEGuHzHNZ3Qj6b4AKKyr831kajB+DG5msZfthFSHN1jx24JZOwFfDrDx1LCC/IwZ
         MhTCtxo9EORWYpuBtzF9sUtwK9tFHQOJOoKYeIa7v1ex81DtT2fqyxOQ9Kd1KQ38ow
         9DjIF+lto7NIQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/11/2019 05:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.3:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.3.12-rc1-g9ebab9194d83
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
