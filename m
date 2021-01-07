Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F242EE6BA
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 21:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbhAGUVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 15:21:22 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9933 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbhAGUVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 15:21:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff76d1a0000>; Thu, 07 Jan 2021 12:20:42 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 20:20:42 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 20:20:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/20] 5.10.6-rc1 review
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a9a73fda0e4647138b0054fe03f20546@HQMAIL107.nvidia.com>
Date:   Thu, 7 Jan 2021 20:20:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610050842; bh=flNt6VD7OL4l9M7dKF8gf6llmGi9L7hOfolvBI7vgqs=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Sd/ygE7Q786ipy5Fff/mMeiIFc0TmKeLST+B1NdstNTFxLBwPYT6Y2ZULjR+TeP/g
         crfT5GZ/trtZDGzsdGBbxhKv9xFWS1eEtXqGoaLGa+zVzCO/quPajN8PdtgEzrK1PI
         ELoO1vPl1QBRlOyTdRxSRIE9Uj1ztQKoEiGjzXt/J6xGabeIt4EE/eHdTVCFwwtyR4
         Qgm0TNGXDWyOYF8da7e/fiqs3Vje629jnQSotsP8NZTsOrhUrKRrtC0onC0ipN9I0B
         0QAc1l2SzGtOPFSECAeeCbDVnuG5Ouct6EUxV99EmeJ9Sxk84febBZq0QPJCHAp8pC
         lTgqlcF7Arfmw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 07 Jan 2021 15:33:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.6 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.10.6-rc1-g208f314c03c5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
