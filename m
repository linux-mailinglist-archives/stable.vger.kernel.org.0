Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3E032AEE4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhCCAHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:07:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16255 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241430AbhCBJXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 04:23:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e03930003>; Tue, 02 Mar 2021 01:21:23 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 09:21:22 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 09:21:22 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/175] 4.14.223-rc2 review
In-Reply-To: <20210301193533.081071873@linuxfoundation.org>
References: <20210301193533.081071873@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <dd655f3d061e45eba9245a7bba925acf@HQMAIL111.nvidia.com>
Date:   Tue, 2 Mar 2021 09:21:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614676883; bh=S83KJDjEfm0sDeUFnE9RwBo9Lmsqk+qvf9H4vS/UZW8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=T2FcHdLPEHjpg60sF3PDd7Mku829Zmd3FhZB0Yok9F3RaW+3OOGkLVELKZbdPgTDB
         PS+V/KWRD7gPTU31ZxAZsvrFsDvnExuQ5dGjO1DO6PGvAt4VuK1KQ3zIXLxCrgBeUd
         hU4bsslbk62e5MwiM1ofSxGJkKrm9GyzW4EdQcQWIm7+5/zbgUohKpJ9KG+ZFrL09f
         PYpgyewaSPQsKYeXJELxjUMaZJPOpi/BP9pnqITvuT5wHV24vxuW+CP3IqB62PGKHJ
         RogpRTJgcjborKsCzFDMmc3Noe6KWtwpDl4Xvl+JqeaJP5ffY1fkGXyyEO/UdgICCt
         3MMR1EdNWCt/Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Mar 2021 20:36:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.223 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.223-rc2.gz
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

Linux version:	4.14.223-rc2-gd172906dd3e2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
