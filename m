Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCDE28BFB4
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 20:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbgJLS1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 14:27:50 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18837 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387669AbgJLS1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 14:27:50 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f849feb0001>; Mon, 12 Oct 2020 11:26:51 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 18:27:49 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 12 Oct 2020 18:27:49 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/70] 4.14.201-rc1 review
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7d6ebb8feee947ae9fe9b672a3a0a152@HQMAIL111.nvidia.com>
Date:   Mon, 12 Oct 2020 18:27:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602527211; bh=6WiICgS0lzi9y7lYARiZEpXKemm5oN9DuLH82sfU0oM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=iFytBYXscpO6nagf/kAsRN+WMbcWsn6NpeCefeebC8PJQORX8Ch7aMTQodZJh0H8L
         DQqDBekcecv5CETH5d0JiF/8U2YpCnBE+nBLpBsXtklpZpi6HGZd98hcR7xhfTMwFp
         QO+nFh76QNQo4ZxaCU7GFh+cQn3W6V6bmLj3jwvV7bCjHxhWwYu2z2yyVjTqDPJ7d/
         kN139Dpof/gmjWFoWAOGHaIUs+xDXCwwq5dJQ/WIvuPSV9enU1pPldO3yyYIyDgzsN
         HpRVThb2R4kRxOqHVFnOVAl1mSNxGkZc1996fdiNqN2OF5IHNT0BUS8uIoKRqo5M9L
         A1bfwg9yUtXSg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 15:26:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.201 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.201-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.201-rc1-gaf37e8ff299b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
