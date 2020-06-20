Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5263202303
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 11:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgFTJvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 05:51:51 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9299 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgFTJvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 05:51:51 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eeddc2a0000>; Sat, 20 Jun 2020 02:51:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 20 Jun 2020 02:51:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 20 Jun 2020 02:51:51 -0700
Received: from [10.26.73.131] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 20 Jun
 2020 09:51:48 +0000
Subject: Re: [PATCH 5.4 000/259] 5.4.48-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200620082215.905874302@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <cac54002-b853-0df9-fb9a-5ee34e6d2a1d@nvidia.com>
Date:   Sat, 20 Jun 2020 10:51:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200620082215.905874302@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1592646698; bh=SlTfTymiV6U0lyV6O6PYllM1zWkdB3/07piBa8Ker60=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=loTISAakK/TCAauuw7eIkxlsYr5Y6EkOSl8PmuSmS0bUP2KYtv4vfOTRPupYZgevG
         FN8qXjWqmYGRqxS9IFTjub9I6XDFRKO7m8PdM6dySqN7FigJFc7whHwHmq+5zBm+6u
         KXeJU2BrMaUPufGiuuiAy0/5xcR8gqxOB6HD58vWBTYhkJ2+dzjPpsH896pbMMQ5TP
         uyek1AqJBUv0CfOuhFU5dYAfxQ93elK6PMIZCPvxt+deXH1lCsYDBmfwsJkBD25dwb
         2zZOjIgHQ/28kJWMItM1sFmIgZWNY3Iw78oZJh8Ez468uV8C0JnaMvl/00jdXGOcgQ
         ifAaLILycPwcA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/06/2020 09:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.48 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 22 Jun 2020 08:21:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.48-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.48-rc2-ga9a8b229b188
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
