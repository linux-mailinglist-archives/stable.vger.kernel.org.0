Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95329290686
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408323AbgJPNqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:46:52 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5545 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407452AbgJPNqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:46:51 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f89a41f0000>; Fri, 16 Oct 2020 06:46:07 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 16 Oct
 2020 13:46:51 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 16 Oct 2020 13:46:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/18] 4.14.202-rc1 review
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
References: <20201016090437.265805669@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a6617adfbddd43abafad98a0a72ba5bf@HQMAIL105.nvidia.com>
Date:   Fri, 16 Oct 2020 13:46:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602855967; bh=xbKIuVVOwW6lTWI5GAc9m89RSOpE/6W4fX8L/lOJYS0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=pFAWeLytGOsg4I44Ea30gdWcKxap94ShxmekH+UgO+CCLzLHv2UBZWSUYrCyOfdB4
         Xmi4V6BmMotPPpzv1n3WHzUexNu54GVPkl8JojlUCK8wV2q/+uGIH7GrCFNbfb++5e
         1VWTUjiCoJbyCbwVnWSXiG1ycilOU5XV9sywq8VfljRAh+I7WA7akSWF6cElhaUxgd
         9aRvUG7B5uRV1hCtRaM05QmdcHBvL5oo4WX/9n1booWwlH72pX+CbyaY/808r3X5+t
         i9MZOYNKQXwkyDt7jWeS5bq4yhr94vwPbH7xLBwnML5/r1pNWzTWhtj4rX1op+LGPP
         B7mh8GeMraS6Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 11:07:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.202 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.202-rc1.gz
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

Linux version:	4.14.202-rc1-g7d10bbd1a872
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
