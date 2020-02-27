Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80ACB172827
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 19:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgB0SxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 13:53:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6650 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbgB0SxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 13:53:06 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e5810030000>; Thu, 27 Feb 2020 10:52:52 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Feb 2020 10:53:05 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Feb 2020 10:53:05 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 18:53:03 +0000
Subject: Re: [PATCH 5.5 000/150] 5.5.7-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200227132232.815448360@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7cb3b57b-6a56-7b64-c572-a6f77e7f43b4@nvidia.com>
Date:   Thu, 27 Feb 2020 18:53:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582829572; bh=FUuRWQ+ZAjr3PRoBA6HUOIVC7YOZL1nva5EGzZ8Lw5E=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MmdAEJEEMvouv7pQuNbycrHnDM4YtIyRlZ1QSM5Gtnp8ZTKvefUwo4TQRDNDWN1L0
         TP4tDDCMkBjGAgTodkHJouC1agkhumNDOglma4QRVcNAfGyBRGh2VwofkaeBSmHJLc
         1FPsT4gKML/snp7B8jXmKQhFymkpdujtBRmbr0mAk6G3jlcPHO13t/PS8SYwSZaPhb
         1KAcRF5iVYOINi0RIInRRlxrQYysWv8O4KK/brW3HXLPSjAN3Rwh/hI7knTA8KVCsG
         gBvHJcmKCRxSOE7d/UmbB8HXnQdD0gBVskuMTJToAptrBDoI6wjDA+fJMH96iiygiO
         A5uSwWGMU4bNQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/02/2020 13:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.7 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.5:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.5.7-rc1-g986ea77a7c44
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
