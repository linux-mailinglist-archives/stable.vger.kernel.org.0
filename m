Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C92AE6AC
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731280AbfIJJU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:20:28 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3657 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfIJJU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 05:20:28 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d776adf0000>; Tue, 10 Sep 2019 02:20:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Sep 2019 02:20:27 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Sep 2019 02:20:27 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Sep
 2019 09:20:25 +0000
Subject: Re: [PATCH 5.2 00/94] 5.2.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190908121150.420989666@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <df670408-bb4b-de9f-13d7-f9d605747df9@nvidia.com>
Date:   Tue, 10 Sep 2019 10:20:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568107231; bh=BKsvLTIOrpgZyKDPVauh7e4uIUVLX2T9GTsVUgogrtg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=U8zU/NLaPGL3irNk/FDYCV7u3i2MPxR9AeKgwDZuhyiWP6Fn9Kg9AWLEjmtcoDWL/
         Tu5QJHYgzoGtPm2S8Kbhl1u+AiwEU+T7dFpvBjHPOc//RtIRf/svyS56F4yeTQPEKT
         GK1LMMXmtGh4Vac+5erT3F4+351bbG4Oam2PwmJ2bE5d3r3FyO3qdsXphunSxfAYt5
         3zL/gJd5TgLAq7PsaoOKCaE7vr5yzQr7peLsRMX68C1UlKVUzVQVLBCGwGC7P02KOI
         AeW/uadybSJLhu4BDknsdWB059bA2PxoVVn4TPTek1ZD3viRMgqIf/cfAMKta+jyCh
         gggYBsI83yd6w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/09/2019 13:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.14 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.2:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.2.14-rc1-g562387856c86
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
