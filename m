Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE824BC89
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgHTMst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:48:49 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10430 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbgHTMsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 08:48:39 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3e70e70002>; Thu, 20 Aug 2020 05:47:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 05:48:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 20 Aug 2020 05:48:34 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Aug
 2020 12:48:34 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Aug 2020 12:48:31 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/212] 4.9.233-rc1 review
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <1cd61da011944de09345e705ff585aab@HQMAIL105.nvidia.com>
Date:   Thu, 20 Aug 2020 12:48:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597927656; bh=GM+UqsETq20Ozg/sNb6nQORedVSWoHzj7Xk03X21+BE=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=qGmzQDSzDG9yB4NM+JpQIkFl7GOzz85S30auga+WbpXv7DeWe/74g79SCjfMlTSMO
         dqqoGvv0gCzIuBcjPCtVeCvcXhraT+yVT52sfxOi9bezMq7j8BlnBMstsQNNApNYBY
         VCKQSKcvbhBsBXlJzc+DroMRpprHMu0lIygAD+bwuKa80heN8Mc4FOgUc0ZatQZaX5
         RFkCSF4GxL1srBQHMFo5CgD1/Dzaxrbn6ZrVYBmCZwlJULt1PxZooF7dVHVQh3Hl/T
         iQZVqqzZngEKkHkOgQEERdPnohld736y+PTFuRvb7gMSWpMUcLp2bV2AwezhFYuYlM
         fZvhZDbKRGvqA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 11:19:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.233 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.233-rc1-g1a1baeef1d36
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
