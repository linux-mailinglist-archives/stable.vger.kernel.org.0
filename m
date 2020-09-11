Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84D92667C3
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgIKRut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:50:49 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3737 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgIKRus (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 13:50:48 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5bb86e0000>; Fri, 11 Sep 2020 10:48:30 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 10:50:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Sep 2020 10:50:47 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep
 2020 17:50:47 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 11 Sep 2020 17:50:47 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/62] 4.4.236-rc1 review
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <9f0be9d83b9d44e88f8379affbac4a9a@HQMAIL105.nvidia.com>
Date:   Fri, 11 Sep 2020 17:50:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599846510; bh=BslJYPZzUg86HAXWjDNXQKu7KFUuWGMnZqvTJ3jYD1c=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=r36s50BjvpeL5XVK6jGrzGb1PEFKPwgkyprCbtwDHWEU+PZhCJTIvzcfvLrQAtvvM
         v0AO/U4/yCnK/AbLI2WYcMfx8+hTqW+aAg6saB4KaRftPj9JLlDlUc1cuLx77NxhAy
         lW6n33MSKaJQfXuxXSKN/hW9tcrOINi2CofJZ5MvPKMHURV+1NxTZw92qgfpVDdZ5M
         YvXbKOluQuotKp/fWBoEIUVOASvjT8ScnTMQbfVU0fD4BIb9c61MZf3nP7SX2+kUR/
         hdBcPhJRPyujmth02h+hj8T8VeS6G/gk6uveHb0vhaANOP2fXdKA9WKxM2vKwowaB3
         /gUaQzDcWbGRQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Sep 2020 14:45:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.236 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.236-rc1.gz
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

Linux version:	4.4.236-rc1-g5a444641713b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
