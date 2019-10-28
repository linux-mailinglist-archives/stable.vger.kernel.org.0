Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA7B3E7B71
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 22:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbfJ1Vgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 17:36:49 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9876 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfJ1Vgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 17:36:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5db75f750000>; Mon, 28 Oct 2019 14:36:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 28 Oct 2019 14:36:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 28 Oct 2019 14:36:45 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Oct
 2019 21:36:45 +0000
Received: from [10.26.11.236] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 28 Oct
 2019 21:36:42 +0000
Subject: Re: [PATCH 4.4 00/41] 4.4.198-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191027203056.220821342@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0ac57510-da56-d87b-7ed0-0c4010e384b4@nvidia.com>
Date:   Mon, 28 Oct 2019 21:36:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572298613; bh=rPuMBcUQ67BHChG+YTwtHa7uHjj8N9iRCo285LPIyXo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=D5l8ZSzrc5GpemtaL8+WumFE+eERosPPQglV19+mEkK1/mOZjqBFpBjFmeO7UO2No
         L6qjTSfAYGR4QBK3FpCBE1YSrZnKuCXDG8i9P9adnBQCi5Jiko6Dvz5MapFYzc9aEL
         Y1qVdiUdWoe4lbK/DASU7V8LpCgSPe+oGl6f7HParISlxx4XjVKAWM94Qcst8zcw9v
         I7F4tTtSGSKLLhbNHu0pM7O+AAVcZ29gE+IBD2J5kAWHfsIWPi57huDBS2KYqCmo8v
         PKvwcmNWelwz0ro7GRsCul0XE/5fiiJOQ52TMFA1Su3JNJ5WmvBX+hcNC1scWVGxty
         9fkMuQJHASAeA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/10/2019 21:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.198 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.198-rc1.gz
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

Linux version:	4.4.198-rc1-gc9bcba7e439f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
