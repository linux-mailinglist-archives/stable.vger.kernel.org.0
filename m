Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0110F27D27A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 17:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbgI2PPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 11:15:37 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2773 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgI2PPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 11:15:36 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f734f660000>; Tue, 29 Sep 2020 08:14:46 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 15:15:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 29 Sep 2020 15:15:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/166] 4.14.200-rc1 review
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9b98d5a27ab64aecb54ecb8d5ea222c3@HQMAIL109.nvidia.com>
Date:   Tue, 29 Sep 2020 15:15:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601392486; bh=onRAhWYuUERk8tVjLyc/Cg/3t8QU7xMQQVZd8fcV1ss=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=h4/NS2wLWqkBHaEuGoZVY89l/SvnNhwd6KYPO9axbg08YH1nk45//Qp/gY3GahM2j
         6HRxwFmKlJkAwVjgOcIVau0mZu1j9FdI/kQfK+EXN2Ig+MdyslkazWfp4wjhDveDpa
         f2eZPIt375PwlV3Ipw5aZW2GM9qtEH6CLW3mV9aS6qTs7cKxX7ls/KNBngC4cJd/n/
         +EYn+N5pQYJv08sozcpcisDsY0KCipoR8lJYoYWJwDbhooTjWJhftWnejXOvRDE19M
         QnEHBBJZ2scbGovUVvlpU+v6Dqssb41Kn9UTIPMmVBlpYNqkoBzIZEBjGRihF1DUjw
         4RRtssyS6aq/g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 12:58:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.200 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.200-rc1.gz
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

Linux version:	4.14.200-rc1-g7b80cb61f2b2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
