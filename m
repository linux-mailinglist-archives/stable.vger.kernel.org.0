Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EBB139511
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 16:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMPmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 10:42:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9550 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 10:42:05 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1c8f970000>; Mon, 13 Jan 2020 07:41:11 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 13 Jan 2020 07:42:04 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 13 Jan 2020 07:42:04 -0800
Received: from [10.26.11.97] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 13 Jan
 2020 15:41:59 +0000
Subject: Re: [PATCH 4.4 00/59] 4.4.209-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200111094835.417654274@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fd992536-19c4-12ab-166e-2dd76a190c70@nvidia.com>
Date:   Mon, 13 Jan 2020 15:41:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578930071; bh=/cb+LW5V4BGKSwoExv9t+5tgaDgUsBAGjR+JC3FTmmY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZYhi/3+PS8paf9U1TB7vfVeJfHJfZK4Exd4UKcR1cGCRWpk32RCFt0aIwsLABGnmX
         wBo3kstghazrCE2u0yak41EAdAAs35nduhf0vhUi7mYGIYw6aW+C/jxRAtu7RooV3l
         rZ3PNr8XV/AvgSPJ4Wd9KS8n9+xLJd4YZ/OPjNxkFINhiPxMfpwGAmw2PV6x8Lx/YT
         6KcBtUtx1P20NjdV9mM7vXWcf0v7Goxo+pLiY9TZkRxpxD/hhfAr8pNiCNkfu8HroX
         xcD1Q8nUTZqDQqAwxNASiLMPAY3qhLG77r5sLC6xfgjQIZAucLv6htPNZAfaFeFhXL
         TQq57fbxQxWdA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/01/2020 09:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.209 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.4.209-rc1-gce8c9a6be3d9
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
