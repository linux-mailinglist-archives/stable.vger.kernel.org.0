Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4282AAE69E
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbfIJJTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:19:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18513 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389420AbfIJJTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 05:19:44 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d776ab00000>; Tue, 10 Sep 2019 02:19:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Sep 2019 02:19:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Sep 2019 02:19:43 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Sep
 2019 09:19:40 +0000
Subject: Re: [PATCH 4.14 00/40] 4.14.143-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190908121114.260662089@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5f4ed3d8-8680-00b6-e3d0-19f8c828dab2@nvidia.com>
Date:   Tue, 10 Sep 2019 10:19:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568107184; bh=5IngZMOsYnJHGdMaiWBQqS9qP+RQw00npVJpXII6K+M=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Ay/lq56EoHOIlKm1eVkDuSS+95Yro5NV+8GhQ4REOQ5Ei5Jg4R89kB8pCjogdTtG7
         HBt8/XHT2o84ovKMJGSgkH4q1nLBT+Pw81FbAmesNZ3kuV7OkHvVVOkNRQPynyyYck
         lFIJ6QBkzH2pTRXVJ8KKkIoOYfCqKVDqLgAFGqOR8GKYyY6hOqHgvpDq0t2O2w59Iw
         9j6ffCdXImIXB5a+snyBdyou6kIzN5UUDbp51TQ5dEFiUKWGJjsznWA9/UxMadvW/r
         IrDFA0ORT6pVbN5wDwm5WoFuabbJe7H1ANreRNSQgBszbUOaKdYS1n2BrK52weD8SE
         Qrk35rKI9ioFw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/09/2019 13:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.143 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.143-rc1-g9ea9c62091b3
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
