Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3ED322CB4
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhBWOrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:47:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8508 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhBWOrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:47:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603515650000>; Tue, 23 Feb 2021 06:47:01 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 14:47:00 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Feb 2021 14:47:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/13] 5.4.100-rc1 review
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
References: <20210222121013.583922436@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8bf31a259854471a8c448905f47ebcb1@HQMAIL105.nvidia.com>
Date:   Tue, 23 Feb 2021 14:47:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614091621; bh=AxrKOpoBYM4qDNQwsmAX+A/hT6CSc0tcopQVCggtSN0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=EgzAaQgIMTO2lQLRxpomkohF9xERtIq/CgqfgiThd4muoMx9bgMsoHB67qLP22kOX
         h/7eA3Ts0pC+lKOT3p7Xl6EZ9nk6uSlR5sytdVg5PnTmjHS9v/UoeTPUvC51tkcP3W
         zQ0WFqy7+sItUwKD2Ankop92bTU3IpgPkZ1XYhFkVH79KW273tIRiBa1/OYEPjabxz
         B9YtDmfMfc6TsS/Rw84whXmCkr4XkYpdZLBZCfFZLz7tLfkcrmmTW+oxgXvhruopKx
         DHKkahoOvQFIGQMHW2jgtqta4EDjFgAC+TwGk1K5YZNvUetkrvpVenltTxdYbaFeU2
         1vCsngmfG10EQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 13:13:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.100 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    57 tests:	56 pass, 1 fail

Linux version:	5.4.100-rc1-gb467dd44a81c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra210-p2371-2180: tegra-audio-hda-playback.sh


Jon
