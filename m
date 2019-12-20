Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FAF127956
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 11:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfLTKaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 05:30:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2953 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 05:30:06 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfca2a30003>; Fri, 20 Dec 2019 02:29:55 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Dec 2019 02:30:05 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Dec 2019 02:30:05 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Dec
 2019 10:30:03 +0000
Subject: Re: [PATCH 4.19 00/47] 4.19.91-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191219182857.659088743@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <bc371118-a121-d10e-37ab-341e3e12c39c@nvidia.com>
Date:   Fri, 20 Dec 2019 10:30:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576837795; bh=ofK1+qFQorM0lt5mCHmQpFldPgqg6nsq2T+tVoJBLag=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=V6IFIpmZMnJi57xechjem5N8nQiGE3u6Ku4W7rInzhECuwmaZqQ1kiym865wBnZXe
         f+Koz3QyjBFJvFV9Swpy5qi9OV/adVbYSoMqy3TiEon/McM7Ru+LVqqOIPP7MCaMRY
         eFKS3DwdDcEtLQcJRggq3lz7g09ZCujvt916QHs3XZKBidElTc+th3Q2PyeeIbYTxc
         JYIFxuix7K+ux8Hr9ZkgDyYq83zn4OS5wBDD0DUATeAlgnNkdF+qHSN5FRXLXSwOmO
         tg3UhEV7eAZsbZ/cB4LX2baiOSlAU+ZbUQ25WCYTwgh3m/Bf56201IlkAHjyXkH81t
         fsxgHS8ezIN3A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 19/12/2019 18:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.91 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.91-rc1-g631e9861976d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
