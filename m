Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC61223D210
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgHEUIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:08:40 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5595 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgHEQce (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:32:34 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2ad57f0001>; Wed, 05 Aug 2020 08:51:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 08:52:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 08:52:17 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Aug
 2020 15:52:17 +0000
Received: from [127.0.1.1] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Aug 2020 15:52:08 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/86] 5.4.56-rc3 review
In-Reply-To: <20200804085225.402560650@linuxfoundation.org>
References: <20200804085225.402560650@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <efd7e42499764fe5aa4242316e6d83bd@HQMAIL107.nvidia.com>
Date:   Wed, 5 Aug 2020 15:52:08 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596642688; bh=attfFQzfqWtAY+0kRxsEgEK/RqLVKg1BG1c4/dMXoHk=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=V1cn/VmJXonkxu9bdB3LcBAj3o7YyvjP8GLFXX7veMTKP0UydTxdf5hd8qKYYIJF3
         kHdOGb8FxD54OS3uwPcewKCH5qV//aCGRYSBchKghs/rZsO/A8aP2Lbp7klHfHgSjn
         kJ4g2B8dnpWaCNWPG3wo4tMTKIpFrXXNY71qV3SleTQ6Ka2CBZVnK0raLxSli0t4Mw
         GXpoSPAikR+Lez0r/pMTR+PjRWDO5Bu2zKj4v3+XArnKjAyguW738cZwzEKG6yEW8P
         iiotrfnWZdZsV0t0Vs+S/5CXRLPuGi8k3wJok1fu0xrdXvZ4PEXOIgywqvF8c+Lz7a
         qYQByTsEnRa7Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 04 Aug 2020 10:53:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.56 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.56-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.56-rc3-g47b594b8993f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
