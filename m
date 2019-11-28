Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C23E10C6EB
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 11:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfK1KmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 05:42:05 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18397 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfK1KmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 05:42:05 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddfa4800007>; Thu, 28 Nov 2019 02:42:08 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 Nov 2019 02:42:04 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 Nov 2019 02:42:04 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 10:42:02 +0000
Subject: Re: [PATCH 5.4 00/66] 5.4.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191127202632.536277063@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <772b6606-f65c-371f-ec74-e78aba55f798@nvidia.com>
Date:   Thu, 28 Nov 2019 10:42:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574937728; bh=6I4zkpj5fqtewDd5jpLo35/AtSqfDrdezQcnaQiCaDk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FPFVGvrX1IFD8dQd4GH3i1FQiPDn53xmGx50Xa/1rHBmEJ3/C58KBqXIxKe8/atBP
         jVBl32GMU5hFNm0h+y0OoI2PDWSjtEmQOfOz0Ru4fEcNgZoE8pkeMjuSoMlwFsmi0D
         e+3+TRs2pEKOpRN5/4KxhmK70Q82ul+UDA/ORVoNZLWTgtpQA0Gw6uYDELSwUHqe5k
         1Vs5jxO+i3PTR+1ZWyMDGUPw12TUsLInGW5vxfCECw+4a3Z01GnitcagYWOScnvK/+
         ynLEaUhabg0UucRLZWXBR68MOZiIN2JB97zt/i3WrS1ptrOjqS/auDUQ5c4Vygnn2p
         cmj0qjLlhrQGw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/11/2019 20:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.1 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Here are the test results for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	37 pass, 1 fail

Linux version:	5.4.1-rc1-gd6453d6b0c57
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

We are seeing 1 failure for Tegra194, but this is not a new failure this
is present in v5.4 and it is a kernel warnings failure that has been
fixed for v5.5 by the following commits.

This one has been merged for v5.5 ...

commit c745da8d4320c49e54662c0a8f7cb6b8204f44c4
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Fri Oct 11 09:34:59 2019 +0100

    mailbox: tegra: Fix superfluous IRQ error message

This one has not been merged for v5.5 yet ...

commit d440538e5f219900a9fc9d96fd10727b4d2b3c48
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Wed Sep 25 15:12:28 2019 +0100

    arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator

If you like I can let you know once the above is merged so we can merge
for linux-5.4.y.

Cheers
Jon

-- 
nvpublic
