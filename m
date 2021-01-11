Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12162F1EF6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbhAKTUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:20:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12453 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729848AbhAKTUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 14:20:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffca4bd0003>; Mon, 11 Jan 2021 11:19:25 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan
 2021 19:19:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 11 Jan 2021 19:19:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/144] 5.10.7-rc2 review
In-Reply-To: <20210111161510.602817176@linuxfoundation.org>
References: <20210111161510.602817176@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <003040e4e8514aec86f56badabcea893@HQMAIL111.nvidia.com>
Date:   Mon, 11 Jan 2021 19:19:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610392765; bh=eDY69QaiTGmJL+G1eVFzXI06l/o9oU/JWAHPWV5iBds=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=gFkc15OMz+QagHVZXHxiDw8ZdVtlz2nNlUxSVI2mLiQRAFkwhN3AfinNd5DF4ogju
         E5ki3ujn6G1oQmvbPaOM7WIhO98cOY099S8yA8apvqMiL77c0a84/GSJVPKT7QU3dp
         gbChrhPkSN7pSMVfJNwf5NZ5fzPfnx11oUSyL8wGJuuneljQHvRpNaWrZ5RsnKllou
         JqIbwzPJJGy9yAg/kNOrzZwLsw8jHsrQ/4zcwRQUHXbsuVoTnv7cVin+o2E7EwNPBE
         6UMb/A99ewetremwslW2BRRAk+4v4HJSHYuOC4tSDGvboERmmrKs9hkO9HE0NvLuQZ
         sCS82kR9199Dg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 17:15:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.7 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.10.7-rc2-g0ea94a3ff7f8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
