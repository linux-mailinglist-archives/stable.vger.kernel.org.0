Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E269326BEF5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgIPIQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:16:41 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3122 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgIPIQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 04:16:40 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f61c9b50000>; Wed, 16 Sep 2020 01:15:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 01:16:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 16 Sep 2020 01:16:37 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Sep
 2020 08:16:37 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 16 Sep 2020 08:16:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/78] 4.19.146-rc1 review
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <a78d663db6bb44198e11c2b7a695c069@HQMAIL105.nvidia.com>
Date:   Wed, 16 Sep 2020 08:16:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600244149; bh=KwZBScbn6qGvF4RHdDgIgzDxVH/GMAXAkFeq5+KRCqw=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=GQ74YQHOZ2ASdOVfLM9K5e1pghCeYa1TmczSapai3c5+Nk5kpPSMyQBmo1o5DkIWx
         NNS5XjME1+340yd6YypHhpUHqDcKgsIJCiE2NkacU4pVkTsZr+9bU6V0Dwf423aGPZ
         9grSOOJGRU/0Q3j8xw5t7Kb4mAq6/n76skQtvla69Lwe+lXmlE9vLh7XHAbq3/9FQT
         rgZ5VEkj9hTQgYhBBVIJO4tlUV2HiNk9JN3Nz/m8fF409iCllPxMZoai3YNwh42msX
         jxy1rM58S2gsF+mojQ/koGpEcWpzW7EWikFtlo/Gm9hp/blaV136hs7jspSFATcI5A
         nsqSCL2Y6SasA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Sep 2020 16:12:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.146 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.146-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    14 builds:	14 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.146-rc1-ge92f22c53d42
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
