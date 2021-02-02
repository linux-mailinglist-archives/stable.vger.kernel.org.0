Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4758D30CCFA
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhBBUYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:24:05 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4364 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhBBUV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 15:21:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019b43f0000>; Tue, 02 Feb 2021 12:21:19 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:21:19 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Feb 2021 20:21:19 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/37] 4.19.173-rc1 review
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
References: <20210202132942.915040339@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f5ab3900d7354058834afc8859c61591@HQMAIL107.nvidia.com>
Date:   Tue, 2 Feb 2021 20:21:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612297279; bh=xHgKqpmEYQ4VwsCmhZ6E/y4JnwO6dKFqT4tHj8Gc9rc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=E8ov9UrymW+Pv5sigN3HvC7Qajyz8jcWgh46RZW32wAHYdAWbqh/EIlJ/+jfAHELo
         cs4vwRtD9ydcQKI9qjXeze6HwEItBfiEMYYJk9/uVzPhD/ijcbEhR2ekpeEd6WqQtn
         QnuSFwrCyzx18Df1/BeBYbI67WX0qxRIBi6IjQedvJivPXhwPygHrNNbel5j3Itfke
         +/sgbtyCCOJthKh8Pl2GwKZ6rQWFwv8FrHjaRHT9S8tLlIrj2eecLqAC1zofhHR6en
         eUG1I+V4gusgBDA30fEebLLQBJ4YQG4EGOC8P2yl3S823N1UQBfZvYaJH7oWQM6cEk
         32UCpNvx5neaQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Feb 2021 14:38:43 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.173 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.173-rc1-g5230df3466ef
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
