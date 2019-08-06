Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB94C83898
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbfHFSaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:30:23 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14456 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbfHFSaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 14:30:22 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d49c73f0000>; Tue, 06 Aug 2019 11:30:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 06 Aug 2019 11:30:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 06 Aug 2019 11:30:22 -0700
Received: from [10.21.132.143] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Aug
 2019 18:30:19 +0000
Subject: Re: [PATCH 4.19 00/74] 4.19.65-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190805124935.819068648@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <cc9a3031-d6c5-8614-a16d-f85d3a992420@nvidia.com>
Date:   Tue, 6 Aug 2019 19:30:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565116223; bh=TMcaAh4Kjk+Xlq6AdbgMK+rHGlH/ogP9FS6VQw45pp0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bJcCKIkNGrwtTNRv927XmgE+419YCm6dTBgDSIGN5/UILXUZqmuUVq55LhQOuT9da
         nuqdu2xLPj04aglHAC0T7ws72rcEF4p36aakr9sOom+N0lWUBiTtacon1Ump3NUR5Y
         1AV2X8j+zzfuORt8mWkObNWUcqlMtoK7Z2Pcchza3GCcxns9VI20Flte2wIiDMUDvb
         y7DtlUyAsNJBpPqI6SOyOgs7xuYP8GIiN4kiVNEjc9vIuVyHyToYH9ga0PycIDcidw
         gK9XRVuQdrkJGIHceVg4Eer12/eMF+3p3ddjl3LD+nQw9+ae0XmEYyUbwbwZE//G3R
         jRvyPfRzvZhoA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05/08/2019 14:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.65 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.65-rc1-ge2fa6c5f11d5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
