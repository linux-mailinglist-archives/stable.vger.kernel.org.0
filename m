Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E064C1A78B2
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438583AbgDNKov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:44:51 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7542 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438573AbgDNKo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 06:44:29 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e9591c00000>; Tue, 14 Apr 2020 03:34:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 14 Apr 2020 03:36:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 14 Apr 2020 03:36:29 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:28 +0000
Received: from [10.26.73.15] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:25 +0000
Subject: Re: [PATCH 5.4 00/41] 5.4.32-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200411115504.124035693@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <134b42a3-4416-a1b7-17e6-30d12bd86a19@nvidia.com>
Date:   Tue, 14 Apr 2020 11:36:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1586860480; bh=QG2rljcM2sLsL8F9VXTqWo3wamoyesxEgxS6zC4YM08=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=CCAcLSqiOvjh+VYjekOWY+B6Regjp5YipholP/jKFXIRx751OaS/AzrbJlcS19wQL
         oa+N93Zgmd7L4hOuq0UFDPHSJFTcV6GWKKBB8/GYuxQ/ptvkHPKHV9CFv53fe2UUYk
         iH1aGh0RfgxNuVjq45o3AzoNWskx5lMWSjxEzA4GpL0FCMslD89wilj+QDTdpeuVc0
         tvuet5L4zqnU2VZZAv1llcla88ynVx82USqmu1gg1mkIq5euES17fGbM9WJLw4VjdZ
         8+DEVhBrC6OsVPmC0E4MSg+jdzwdKVw7VgMe0vIB3ct0t6Jl6ZrV0qbbJeSZ7Q8jxh
         7IQMjBT1z8cuA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/04/2020 13:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.32 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    24 boots:	24 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.4.32-rc1-gf163418797b9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
