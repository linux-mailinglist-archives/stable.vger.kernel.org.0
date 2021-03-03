Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D71F32BC3A
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383292AbhCCNqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:46:17 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14293 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357410AbhCCKtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:49:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f569d0000>; Wed, 03 Mar 2021 01:27:57 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 09:27:56 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 09:27:56 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/92] 4.4.259-rc2 review
In-Reply-To: <20210302192525.276142994@linuxfoundation.org>
References: <20210302192525.276142994@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f6c3464df90b40f0a8621e7a1c3e0c0b@HQMAIL101.nvidia.com>
Date:   Wed, 3 Mar 2021 09:27:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614763678; bh=AIUrVoVAcxZF+BnWg6nzmnzhMjiuuM7Eb0qFyIyzk90=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=VYTElMAvN0/lZuYTsCY6yivy30ykHtVsPVHZ6rGKp37BMTqC0MGULh/4+VlNVgexV
         RBGJPiRgn4ZVi14bJUHbRslGder4Ij7GHhlnmM0vu1rLNS0KZCKeAa1zdig8vOjLWU
         KWvUamZ/6mOyyGLy43SPlKWyYuyHaBCaWKRrRI5KkmYloxtHVBoJyFUDtLQk4EzGYt
         xXXGGGmzamn6XZRMiX10FoRitYu7YZP8WAyvraBVhMjjGtXU+SqzxecdmsTtq4MT3W
         OomXvzKVj36jEp6mEH/khidqTgmvbmDYtwg3F5VSQphDgxYm4/GbDY6SEjz9UYlWYn
         ZaOK1aNdK6KSw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:27:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.259 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.259-rc2.gz
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

Linux version:	4.4.259-rc2-ga8379a8a874e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
