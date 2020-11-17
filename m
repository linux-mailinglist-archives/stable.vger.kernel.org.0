Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79E92B6E11
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 20:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgKQTJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 14:09:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17759 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQTJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 14:09:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb41fdf0002>; Tue, 17 Nov 2020 11:09:19 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 19:09:28 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Nov 2020 19:09:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/85] 4.14.207-rc1 review
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e70da481147c46c08ddfccacb158ff02@HQMAIL111.nvidia.com>
Date:   Tue, 17 Nov 2020 19:09:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605640159; bh=JKmLEfGAbprD5vkbqDF6ysSQuz7rlSWslKy8XfQeY6c=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=QrrzGkvspOG/1KicXLDKY0Uat/KOhCLAlhM06i04We8arRRbbKVZkJpZPxUMW+pcI
         h0CCsWKmSu5q7qnM7uabIIlUdqpb+ESSJiUjj619w5jcUb07GkZrnVCog32OWacwrt
         ECsvlLtZFyJW0DpS7/Cek2wNQd7fwDFBTUuGA+VkYuom9MPqIc54SR2JS899BxqILM
         O6hFrSqNcW12N2Y+73kNBt1PyD334KKaOBkJOzqgJBhLM0y5iyHOfJ073AEOfsbw/K
         iXd0rBTMI6AwaZjF1ha1hyF8bYVcDbxv4sO7lQnQ2g+OIrq6PHPRcWKqM7DMCoT+ZM
         eNKwU2QYndavg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 14:04:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.207 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.207-rc1.gz
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
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.14.207-rc1-gabaf3bc53e47
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
