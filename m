Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D465E2BB108
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgKTQ4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:56:35 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17060 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730226AbgKTQ4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:56:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7f5470000>; Fri, 20 Nov 2020 08:56:39 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 16:56:34 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 20 Nov 2020 16:56:34 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4308b4d79929454a8efd424f43f3b8e3@HQMAIL109.nvidia.com>
Date:   Fri, 20 Nov 2020 16:56:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605891399; bh=7cOm+V8ry5xbsdXhw15sawOn35crijmvahWqIwZSbts=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=QY/VjLtEn8DITMf5lkcNGUWcU5SOJnijP0QzBHGyS6NvWxlQyg/3+Arx0TkSnGgQP
         zsbVpsUdEwVg6OSJ79rI2Ya0s+QJtB6Vr+eyST0WnE+SFy3+TBLc3uyXszDGlQwoOF
         TNPkPcCIBPjcEhG3o6IM21n9PxWLKXVc1nddK1iIb3Bv3lphFNeU4za8DJ6k/RMctS
         XmSyAGWQPCDfMuof5oyxuoTU0FK6B2WWp1YVWH2nc30wvgjXypETpw5pRp2XjM7FMi
         dPpxznDHrUSKeUpeXCxwjTBhwkeiePveusmV8e4QKRx6keIpeQGPUxW9KUF/OQwyL+
         laz58np8GZzPQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 12:03:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.10 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.9.10-rc1-g861b379f0883
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
