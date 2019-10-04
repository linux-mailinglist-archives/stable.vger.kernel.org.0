Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7831CB513
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 09:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbfJDHhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 03:37:03 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9850 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfJDHhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 03:37:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d96f6a60000>; Fri, 04 Oct 2019 00:37:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 04 Oct 2019 00:37:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 04 Oct 2019 00:37:02 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct
 2019 07:37:01 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Oct 2019
 07:36:59 +0000
Subject: Re: [PATCH 4.4 00/99] 4.4.195-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191003154252.297991283@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <29e84d6a-74cf-de04-3ef6-0d00d5e0b29a@nvidia.com>
Date:   Fri, 4 Oct 2019 08:36:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570174630; bh=e2ZeAMuAs2zIb6A8vITaFooZ5JAtj0QG5I/gb2vQzrc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=PR2yUROawJB6oWGoCr1kUU34ZyWO4ht0/f+Jgf1iEHCnV+IrIpP3T6KaiKuIga4mM
         gK+0Eca8+C0wZPoi09P0Pwju8kKLyRqQSgW3JrGkO9yanBmZXY8a2LilgphwxoMx9i
         ryc4GLyPSQ8b4OxnH0bC+0bvdddGMQnPpA6OF+wkFC2A5kvBUbTwozMIX5MmdmnsLU
         IaED9i9QzM/IdJCWA23gTADY13/ga3zMEimCsNEgPIhyc+9fjrF5ols9XEEE6HuoP2
         BzjhKAGQmZ37w4pDDfYzEHcCbfSZ+KuAAytdczYAYIIldTPRI8AvkdQZCJ+SgBV5Uu
         YwhRqH5amugeg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/10/2019 16:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.195 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.195-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.195-rc1-g9a8d8139a7e5
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
