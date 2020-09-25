Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB10279001
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 20:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgIYSBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 14:01:16 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12661 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgIYSBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 14:01:16 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6e303b0000>; Fri, 25 Sep 2020 11:00:27 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 25 Sep
 2020 18:01:15 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 25 Sep 2020 18:01:15 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/37] 4.19.148-rc1 review
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <852b022de2fb49c39d080a716b8dd5aa@HQMAIL105.nvidia.com>
Date:   Fri, 25 Sep 2020 18:01:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601056827; bh=4/AlR0YUCQLF1nAg2cZHQ+2aGUUGz/jyghYXzy3SD10=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=PdHcFmEiqvRsJ1l3/nk6FD/zZTKpZSmF5NNud2Mlk747FbKXWM0Y5MD+tKsq/ChtV
         Gb9LHZGu/tSZ/CVW8XRjHSloXLV/tB1CJlUC1R3p4WGSXSdVtywAI9Lgj8ctIpOS7/
         VqsfpBEpE6nZk0vu5m9902E7tvrezg9XJp+YqIfdIrr5K/4u3GOjOG7UAsD5EEhVsg
         TyGwtMcw610/2jdmWqOh+wj2GL4vhicw16MJXJGlBW+hsH+yT1W2hv5Gs0kJblYzzl
         0kb1kpoM77+qMH6XI+OhaMDETWJDWOjfK4IvXkOFzroUlpRukw1oxyXISA3fSuLwWQ
         19MiTzOQrCb9g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 14:48:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.148 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    14 builds:	14 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.148-rc1-g1e68f3302e6a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
