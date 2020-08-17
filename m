Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CC9247860
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 22:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgHQUzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 16:55:24 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8619 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHQUzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 16:55:23 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3aeeae0000>; Mon, 17 Aug 2020 13:55:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 17 Aug 2020 13:55:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 17 Aug 2020 13:55:23 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 17 Aug
 2020 20:55:23 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 17 Aug 2020 20:55:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/393] 5.7.16-rc1 review
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <efb925d365e14308a4d5206af5304d47@HQMAIL105.nvidia.com>
Date:   Mon, 17 Aug 2020 20:55:20 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597697710; bh=jB2ZgI2Wc3w+qhlfgOjpBFK/VWGKTPQuQKJTCHYIT0k=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=ZGeP/FG5wNg7vSZ905hzFAMFk+yZQMxC6Fyyf3ZUkaJspwcAihPIiLEhtZBPT550d
         MYpuK9kiz+7QGnAHRCULP5YaHoZ2eKsYkhiiDeCsbCR0U+ONfNgI9m6aw9jWXMYaUe
         eYoaptfzS/RO65jg5mSZEp5oL8Cjw+vm07iI2tHvBtrV1JyUWF+dDMVqeos0FFHtwk
         lcivHHStMCojixhFngPPDnZNVVlbrkt4io17ljYIodBMJtwDmwcOsrn2p1ikdmC1ZD
         oh+CQaQQOMPaH8PdFNFr76XzeeFhKeHRUJVYrWUP0wIF7ZeB9DFGbXNFGJ43upsXG0
         t6KSEICpmbrHA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Aug 2020 17:10:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.16 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.7:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.7.16-rc1-g833b53db2607
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
