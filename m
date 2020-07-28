Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA05230A8C
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 14:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgG1MqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 08:46:02 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13155 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729618AbgG1MqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 08:46:02 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f201daf0000>; Tue, 28 Jul 2020 05:44:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 28 Jul 2020 05:46:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 28 Jul 2020 05:46:01 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 28 Jul
 2020 12:46:01 +0000
Received: from [192.168.22.23] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 28 Jul 2020 12:45:59 +0000
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/64] 4.14.190-rc1 review
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <94da9cadf5864318a50834a143d70261@HQMAIL105.nvidia.com>
Date:   Tue, 28 Jul 2020 12:45:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1595940271; bh=ZVqYX6khN5oNBWEl8P0bFZcpPb1+F77g4TXgcngWpKA=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=E0Wm7Q7MzP/JwDrRa2VnXj+aKwbHNWaKCzTMRCHENMHonuCLY/rIMo9NIgFtD1NnN
         l4S3nglI3mhpDkzXL96YveNrTRyebiErlus7+Rq/Lr6TzeCOMmZljjsXkQhzSup7eL
         hln/atof58JfqXBTCbedCS4DguIZsvcnT4yhsCnK0eU9e2CrETj1cglAI8fax3krT7
         pWzDONqoPeYkfXdQzIQx6tLZ0CCojUant2jlinQQ50MNEnMa5lkYQHDHBmBzDnqtB9
         D18zs3TiVnHDTbjrpfmAz5Dz7vvcgqgTx9HACmTslghZxyxcSPZfAMjkoXUI1UHtUh
         WdxAXlrrdDK0Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jul 2020 16:03:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.190 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.190-rc1.gz
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

Linux version:	4.14.190-rc1-gf238f865e754
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry
