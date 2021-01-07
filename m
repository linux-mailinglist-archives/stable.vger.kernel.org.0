Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933AA2EE6B6
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 21:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbhAGUVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 15:21:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11510 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbhAGUVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 15:21:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff76d100000>; Thu, 07 Jan 2021 12:20:32 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 20:20:32 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 20:20:32 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/20] 4.4.250-rc2 review
In-Reply-To: <20210107143049.179580814@linuxfoundation.org>
References: <20210107143049.179580814@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <314641e4a3d1494aa564637f8478fa7a@HQMAIL107.nvidia.com>
Date:   Thu, 7 Jan 2021 20:20:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610050832; bh=lhukQ1C9OCGOYGQ341F2XoRMABXyp4c/AazbcUniYE0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=UM0e7HzVWOal4F02O5CjnDZ7xZ5bXflF3G7H/QhzP06+d9+wA1bwngx7scaX8T4tb
         mnBJ6nlQi/zsyNlRHYkVlKkjJxCmYKNNSvkVs8s0KOvDp1PpjvkLboCGrkw/hTZf4Q
         dzCI41ZHhTFkS0e17bt0zTXE9YSNea90mMSvD8+7aTa41qmS9opAwm6GM1zQRM8gHO
         Zs5NSikMrn1zdJriucnvRdI05gNcICL+PW5kEQv6QJsLBlmg4tzRMbTzOliqrFxy/W
         3EekZMpx00DFwWqkrLnwfMWa12a39Wwxz/dYEewCpJEH7+xM0b7TP3o+w7aCe9Kwpw
         KN5oI1z5g8Ezw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 07 Jan 2021 15:31:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.250 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.250-rc2.gz
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

Linux version:	4.4.250-rc2-g5d125190fbcb
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
