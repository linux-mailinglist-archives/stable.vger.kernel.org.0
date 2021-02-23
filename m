Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9132E322BA7
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhBWNsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:48:07 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14225 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhBWNsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 08:48:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6035076c0000>; Tue, 23 Feb 2021 05:47:26 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 13:47:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Feb 2021 13:47:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/35] 4.4.258-rc1 review
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f43082ca10384b2083a3b513e7288c04@HQMAIL109.nvidia.com>
Date:   Tue, 23 Feb 2021 13:47:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614088046; bh=nrBAZMYNzqyO17MOlU/WegmhAzwoM+rhm5lRKWFLP5g=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=QDeSzpngBSIearGoGI+OQ18vdglU+irO4lB38CoRyCYj83jpM0rrg195KL30GwS6c
         fOMz8nqYufkl4ofgBju+uXwfmtcEhAVhMYABdz2uyu7zJv6PewHSWYCVmMiX8u/Uew
         MsGASjI2IktjrBcQts5kqai0Mm+AxHO9AxtvVTX+wEkIS53+mRCVHU1mWtz3n7X1j5
         4XJ77emeoAJEpO2cNtVoP1p+Ui7wZBbZs3mdMVaJB8a6nBNx9ZabhihMRqPqVXSUIG
         msflt1APUrp6gtja6d3xPYRh6+JaiGy2hOApjDjbE5bfa2MWyRyJbttAO7OSSG/Ijb
         irHtSvYhiufZQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 13:35:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.258 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.258-rc1.gz
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

Linux version:	4.4.258-rc1-gd947b6dcd5fc
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
