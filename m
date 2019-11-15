Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3415BFDF50
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 14:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfKONvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 08:51:01 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6825 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfKONvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 08:51:01 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcead470001>; Fri, 15 Nov 2019 05:51:03 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 15 Nov 2019 05:51:00 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 15 Nov 2019 05:51:00 -0800
Received: from [10.26.11.193] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Nov
 2019 13:50:58 +0000
Subject: Re: [PATCH 4.9 00/31] 4.9.202-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191115062009.813108457@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <be8b3704-c780-ceaf-7775-3d1f21db6224@nvidia.com>
Date:   Fri, 15 Nov 2019 13:50:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573825863; bh=aUrQPL6eraMSEBMlhb7JLkVtckeCFIm+Q1PjgB7rlek=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BA392bhJB53AgRQ+GEwy1k2jYDNWymc2BkBFDtdoVlzPF/Dx906AbZ61PLcgp5I15
         JFgpaIq3PjHLmfMCu3LjAWT4b/8fSGuyS9XG+sGUDXJkamAIXxT3LKdXGoUT5Wo+Ml
         4CpvvQQVaPOGZlOZ9cSRS1/bStLT9zfHzcBRI9ImZlX5OvuZ4CqmIVkYi17VRqKhyx
         R4+cgU1kxniQYQ3n/PYLf5xAcEiR4T7e34/7mNfzgoCFG6rTNCq/rsalg/O5QYlIdI
         opNobAr2FDO3HfixGMeb+DWNu/YXFe8WBy27lDaJ9J/VWKucDJrRJUyt8Bj3LVNx5s
         +bNAQQgK15TJA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/11/2019 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.202 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2019 06:18:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.202-rc1-gd7f83e4f45e8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
