Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CF02F19C3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbhAKPeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:34:01 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2768 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbhAKPeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:34:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc6fc00008>; Mon, 11 Jan 2021 07:33:20 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 15:33:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 15:33:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/45] 4.9.251-rc1 review
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b91668fd4a1748ce9d54d8093963746a@HQMAIL109.nvidia.com>
Date:   Mon, 11 Jan 2021 15:33:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610379200; bh=fVvaMuQNNNzV7nYMOOonixS2BqPTJfMdjulyTrbwiuo=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=lxEXS4Tj6MKC79Wx5+wc1eTStIpGehKW/Dhf5SgkzeFhzpBSE6HgUecMz+Y52Icn/
         f81ZnuyG7v5YT8z+pNbW1YzsvmBuT1XlYFoHqAu9r0lR1yoZDKDpgKIJtaveC00/rO
         jXDcajHZ+pQFcicnhfQoVi13MtPpR5DtJ0ByGBsxs7tpK2JNY+NyAT0wi3+KmlARLl
         GbihVPTjuqxtNrrKkc5C88kkS/lskBRngBuMbSI2SbbO7K9DjM3ijyR9qiFRqdIpha
         gYPag9YskQWvlKsjTspr6hEoTicq/65qsZgQMSJ399hp9H8gw3nZcoTFYDkejP43EK
         6VWNfjljMe9NA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 14:00:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.251 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.251-rc1.gz
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
    30 tests:	30 pass, 0 fail

Linux version:	4.9.251-rc1-g6d954ea12bd6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
