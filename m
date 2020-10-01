Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D89028044D
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 18:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732670AbgJAQwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 12:52:24 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11948 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732016AbgJAQwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 12:52:24 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f76093b0000>; Thu, 01 Oct 2020 09:52:11 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 1 Oct
 2020 16:52:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 1 Oct 2020 16:52:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/119] 4.9.238-rc2 review
In-Reply-To: <20201001091034.685078175@linuxfoundation.org>
References: <20201001091034.685078175@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <dd714decd70f4f399d084ac26efc9e0c@HQMAIL107.nvidia.com>
Date:   Thu, 1 Oct 2020 16:52:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601571131; bh=0ZmOx45a3UnHjKYDfr+3fiauGLZ73bndGPAlBTLvsDM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=K3WgIfG+y07dKE5CiqbAsb6m5F+rwR706gt9gCYYOiOGv63NmNX6hra0eZNQIFFBC
         JhR6XhFVO43zPscCwQiMjfz65ktylI0qRj6ySLpZaltcjWcDOMnDxSbwHspGPxEs9H
         Uo6NKaMTGrN/wOfYDN86US6tg2UjcpWyaQ/hMHej3PvYGZaybLmixs2nGdj8yU3W4k
         ee0ZnBv4ROP81q3D1z997IubHMZMF+JSwRHkCSSMVYi1cgC2OSoabn5zkNzgFEljFL
         lDMEjy0XWtyc0JmmdT9aDMd08c+FJCeNT91ckcz8hkvZpmHUkRvLaQlXWuUvJKhXTS
         /v0PS3jrwFL4A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 01 Oct 2020 11:11:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.238 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Oct 2020 09:10:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.238-rc2.gz
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

Linux version:	4.9.238-rc2-gb2e11ef653db
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
