Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E8229068A
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408412AbgJPNqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:46:53 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17296 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408380AbgJPNqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:46:53 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f89a4400000>; Fri, 16 Oct 2020 06:46:40 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 13:46:52 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 16 Oct 2020 13:46:52 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/22] 5.4.72-rc1 review
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <115ada3269ae4b87ba43bf91e7d13f7b@HQMAIL105.nvidia.com>
Date:   Fri, 16 Oct 2020 13:46:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602856000; bh=3eiaOkwdXdu1+n+XgnAZf/kXU6yoKov6jbuiNghbEXM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=lH++XWk8XfThu1yC5FA/AMqm1qiYNguDlgZmvnDUV7sj4SOiQGFXzyBfDq6778ag6
         zAlwEcGnkGNXhNWW0j7lElkVHKK0dS75XgupHspPw/g0Ax2gDdRsWimI9ZFqyzF9Vd
         yYsVgyRuCy/6auNAm+VRXWRAoPVzMzkWSZJF1WPtWBg3u/84dNqaqR4HmFQsFK/3aT
         xE8oJGPHRlu2QTWF++WsntvShhf71+yEPJFIKkZPx7KY2qtMTYauB0oQc3G0W2ar//
         /Z2Z2UFq49uNupcWwnOS2TftsOWSPWOecG47kNfiirRwWq/ZxKwt2PopSiOOFR/fw1
         Gosfndbt4IqfA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 11:07:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.72 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.72-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.72-rc1-ga3f8c7f24ee0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
