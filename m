Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFCC2E9F57
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 22:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbhADVKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 16:10:16 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19891 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhADVKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 16:10:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff384100000>; Mon, 04 Jan 2021 13:09:36 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 21:09:35 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 4 Jan 2021 21:09:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/47] 5.4.87-rc1 review
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <4103e42887994cb3aba1b4b44a5c2327@HQMAIL109.nvidia.com>
Date:   Mon, 4 Jan 2021 21:09:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609794576; bh=AQz5ab7Irv0TnEMRenVp5IqDPJQ/kU/QCwM7OJZu3tg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=IrPTBl5G3s4cYpSuLLrjLBRUgpJtB3XTR6gnvcj9dxB3usBhoqkaLxrfSdBeNy7MN
         brwdHC0Fdn55opm2sMJQInsowAivIViG5Pj/5qjIOyC69l+0lgHYqyHBBzxdq59GRl
         eIFnf0pFM7Qx1W84KWwUa8vNji3Nci+g/YL9ls4tZ9Wogh5/Z6GDNekNtGl1jzXa6n
         t3RDitVqiIyzyVuK85UV7OmhE3SVoBGmZFmj5mm6Ik0/yV993mofpuVOQUefrn05AK
         iLCxvC/bTBhDI3OKcJohZjEnltublxVZx/0egLNuRjOgajIt6XSRVBz44+CsPgFhq1
         oMDZgX3E/ga8w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 04 Jan 2021 16:56:59 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.87 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.87-rc1-g01678c93fa9e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
