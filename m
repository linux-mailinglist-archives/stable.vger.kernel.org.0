Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C53290684
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408363AbgJPNqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:46:51 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17283 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408323AbgJPNqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:46:51 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f89a43e0000>; Fri, 16 Oct 2020 06:46:38 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 13:46:50 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 16 Oct 2020 13:46:50 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/16] 4.4.240-rc1 review
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c524458837da434e9baaac2ca47a3444@HQMAIL109.nvidia.com>
Date:   Fri, 16 Oct 2020 13:46:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602855998; bh=n1IRHLNKLVa3GHBv6pfqSvpuNvKl362GQ9kFIUhzlNA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=mHUS0PIZ/MDgIYSgG2o5xLKrTk8FH4673MrJAF0zsDYXbl7QPOHc+0zHB+rFpy5ch
         CY2mbO7b0EY33PxlZahNMbrWdtpOB0Cmsry626Qgk7t2MAEWuYCw5StPD9x8pjQnpJ
         cn648bls0NBHWeJhgpuoP2GkENFFkDblcXck7OaLz9go1lfUEvkTA5f4MSg6NnmUIB
         KE1SKpAb37J+zjsejAoIy0ir28NCy2lpKtfC5Zi3EnVwibpLWIgyKX8BH+o1mWx5ST
         78qkadstDoIhQNW24Whli+RnkzTtWtFQXpk98HfBwdX5FKv1bJcVInYkrUuWhod/1g
         5GhpT4HrjnICg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 11:06:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.240-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    28 tests:	28 pass, 0 fail

Linux version:	4.4.240-rc1-ga37fadd41628
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
