Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7C7273B1C
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 08:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgIVGqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 02:46:05 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18102 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgIVGqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 02:46:05 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f699d4f0000>; Mon, 21 Sep 2020 23:44:31 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 22 Sep
 2020 06:46:04 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 22 Sep 2020 06:46:04 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/70] 4.9.237-rc1 review
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <3c0d414923be4ba59467a9cc49e1283e@HQMAIL107.nvidia.com>
Date:   Tue, 22 Sep 2020 06:46:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600757071; bh=yRcszg0touOvKXtjXAc4qHVHyCqkxCqs8jWIW8HBOnw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=o92y8XWXrqrey+9CkeihwgVJJjUxNzEr7nFyZXoRGW3a7qb/AHiY8nG6FGdriP3ef
         f06d/+W+FLfS459ChJcos/YmjEqtFbv0Skl++4LGk0cv7mWmjWMGbNE7s8TePDVhkg
         6I0AcJHWQZqVCKXaCOXynHBqWY4nfjaKA81xGHSl0KLcD9rLrR/6jDHNZlPaPX1I53
         x4lSMPrtdSPqggKz1Tc3mpT2Br+vo8QDzJFIji0TLlfC6AvyVmuu7hpFzNwNsMJs/u
         +BHNnQgioejys5gaHmE36brGgokKO92NHsG4TDgf+hyl9/KDNre9BUkAMKtniLG2V4
         thTRM4+oa8luw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 18:27:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.237 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.237-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    27 tests:	27 pass, 0 fail

Linux version:	4.9.237-rc1-gb7aa672795fd
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
