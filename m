Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1425283DBB
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 19:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgJERun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 13:50:43 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19187 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgJERun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 13:50:43 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7b5cbc0002>; Mon, 05 Oct 2020 10:49:48 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 5 Oct
 2020 17:50:42 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 5 Oct 2020 17:50:42 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/57] 5.4.70-rc1 review
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <41d353d67d62453eb8ea252fca604faf@HQMAIL105.nvidia.com>
Date:   Mon, 5 Oct 2020 17:50:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601920189; bh=y3cdRdZmp+FRSr7GjxZezPKwkJpEhKFDneFmrEN8ToM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=VSusiTBi8jcIg/xyhfDCUghQGrO/WiNeNREiRU8urr3u5EfV9487xuYuFans8Pr8Z
         mbU/SFUR86L35C04qO14DTLNUxww9XKFEeibFCJiEJXUqQGsgxTg4ov5kgtAqPOE+K
         +b75Qa6dRWrvtcLT+FTJ6/dqYNzicEa6mqv4rh+c7EX2HjUwtCOEjPhFdB+PVC8CR5
         1YJ2tRiSVz02qGEs4f/yZKiQYJ8MQD21xAVCubZBze2CuXDVrz6NQo64IUJTTt8aYU
         NRs9z1kp78RrXLQV8ArFAOQLrRZwktx9zjXwuMTZcCxhQgjcULbpxwfb5uDFvZ1SVh
         9RDri4s3LZs9g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Oct 2020 17:26:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.70 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.70-rc1-g7b199c4db17f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
