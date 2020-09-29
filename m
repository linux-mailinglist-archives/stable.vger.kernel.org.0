Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4E727D547
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgI2R7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 13:59:38 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6263 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI2R7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 13:59:38 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7375a50000>; Tue, 29 Sep 2020 10:57:57 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 17:59:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 29 Sep 2020 17:59:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/244] 4.19.149-rc2 review
In-Reply-To: <20200929142826.951084251@linuxfoundation.org>
References: <20200929142826.951084251@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <45634f2f22be48ddb158e496920c145e@HQMAIL109.nvidia.com>
Date:   Tue, 29 Sep 2020 17:59:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601402277; bh=YpbQkOl3UJEnpo/FcR5sZa0JAzfUyvvOeSXH8Xp80yE=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=K87pwVvyGZyt52M3R9o4C8L2J2QWzzu+joYtF4VeWFNx53hsdBHGxbyzVq2hxkqTb
         mW/qLkM97D/YmbchDQFNIxu6UXDV/b+BH/Ot8s1lUVHeyMG6BSAWhlEmwdD4KuCvac
         pVhZndwQnaNKWI/Vu3Y1ZY6R24fpvES6SgMqWaLKg1DngrTpPSCPKQj9rQ0MW7TTZO
         eVs/GsC6fb8SiyWyd4C8H+0LG89uUMVNpZ+h9kElPsUImvkcG5ykdwBgNpntX5tEB4
         BfiRgf4Sf9h2LUGEf8VpBqTZdz3w0wlbXA8YYUWYozzJoKnqgPc+nVy6J0x95fHFZt
         BnvLAg8OFOHXA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 16:29:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.149 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 14:27:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc2.gz
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

Linux version:	4.19.149-rc2-g78ef55ba27c3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
