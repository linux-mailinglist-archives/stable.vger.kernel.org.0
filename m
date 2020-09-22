Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B493273B1B
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 08:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgIVGqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 02:46:05 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12114 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgIVGqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 02:46:05 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f699d7f0000>; Mon, 21 Sep 2020 23:45:19 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 22 Sep
 2020 06:46:05 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 22 Sep 2020 06:46:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/94] 4.14.199-rc1 review
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1270ee6331d84da98ccbfe52c9cd79fb@HQMAIL111.nvidia.com>
Date:   Tue, 22 Sep 2020 06:46:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600757119; bh=ny3fDgAeZiIllzzbOAq/iH+IunHBrsgcXcC1L7JbINs=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=a7PfzrkynMJuVWS+fRfaySo5C8XUTeL0qi1SEusAA03xay8Td3DkpQ7MDRwrjKWsQ
         r8vxok0gIArZ+dgoildSCCS2yJ4eJQThlIfwfXNo4mb2iDl51Lf1HhxJqiItH437eL
         mR2kpV3of3CqAJzZSwqIFb5/NLP8Sz7wv8cQCsFMhTqgCbB2uTf0myDgUmkO5e7ybi
         Zcam7mJamHd6/YTmZiQVniLF3VovT/cQECy15kuJp86oKH+NNWqNHaTL+oGdTK399M
         s56HIVO5pwa1Iom+W9y4KSf7zmN/gzQkN6K4gvx/7faikUMkLHFgsObRDa+rgq1iYe
         XSH9hM+MZkCsA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Sep 2020 18:26:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.199 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.199-rc1.gz
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

Linux version:	4.14.199-rc1-gfbc0d5c8464b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
