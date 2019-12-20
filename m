Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A0127949
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 11:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLTK3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 05:29:05 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17493 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbfLTK3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 05:29:05 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfca2650000>; Fri, 20 Dec 2019 02:28:54 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 20 Dec 2019 02:29:04 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 20 Dec 2019 02:29:04 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Dec
 2019 10:29:01 +0000
Subject: Re: [PATCH 4.4 000/162] 4.4.207-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191219183150.477687052@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ce023201-39da-2b48-dd1c-f3ab277b7433@nvidia.com>
Date:   Fri, 20 Dec 2019 10:28:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576837734; bh=c7nLJoBLQoeHk/qBhhobIclk62p4MVYlNFSJ9Xri8/4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=AhKhhRhXePdE1/j0r6dRG78QXmnIPjci1AqJlG1OKyqS2URelv19D1NOlZOp9rpqZ
         AgRyC+Az6NQwU9H7LuZq1SrmmpnDo31irenMrYD6+xpLQw7Rd7Yaca2eJcPxe1UTLr
         3HsAGykEkPc+XTl94tvVhvjMKMcmnhUvOfHMA6O7asRpINBFT1N7alCpmi6PEbiHC4
         Km59asAYXLAcEjFf1eqvfAZLorAxGtN/NUgKM8ir51kmDKqsJxgNLBGM6DrxEddIMj
         w8+0o0nzaFEl+6wgajZE+5ua5UNyrlzPoABZY5DGpYX6r+xt5C/TbTXaXOZtfI1PJ0
         EzJhYWb2hEmdA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/12/2019 18:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.207 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.207-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.207-rc1-g9fe78e96326d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
