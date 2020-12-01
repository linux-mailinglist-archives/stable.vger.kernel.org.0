Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4007A2CA40E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 14:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391124AbgLANkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 08:40:11 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13538 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391119AbgLANkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 08:40:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc647920000>; Tue, 01 Dec 2020 05:39:30 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 13:39:30 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Dec 2020 13:39:29 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/57] 4.19.161-rc1 review
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e8f9be2a279a4af89dfa58d104573d0a@HQMAIL109.nvidia.com>
Date:   Tue, 1 Dec 2020 13:39:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606829970; bh=oriWybGGPCrZHGKZzhlbPFWEZu48UfvtNNKUuOKCc6s=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Gp+xTVZoxQ+ceVFXp4DpidZeibeQXjA+QZzGVzHMRHj0pbJd38TMF3Yzf2XmlUu8o
         16r+amSmpBqEuW/B6Bo3TLuY7citSTo/exT6OoumLATIQG3kejHQe4OQwNi/YJmJP0
         9l91YXi9EpQKeOR9ixj51wsGzTK+0nmRcPKfClxYs6NF08iB6x/jGhRWPqPDtDTDjk
         ZSWScjRWxvqA4GPwOeHsmeIKPZrDdf7H/1eKCzzXFM6Ztr2+9whXz7rao92i9QU1zO
         uWyJXh8IHsNjFB20pc026wmhJdoFdE13y38w1A/yPJzjtA3ioFbuJqZRALh8KvQDEg
         a8RqXZhwzM+Hw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 01 Dec 2020 09:53:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.161 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    15 builds:	15 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.161-rc1-g8d3deb1adb93
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
