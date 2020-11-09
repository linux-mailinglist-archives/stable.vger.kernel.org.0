Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F13A2AC01A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgKIPlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:41:37 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17948 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729174AbgKIPlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:41:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa963340005>; Mon, 09 Nov 2020 07:41:40 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Nov
 2020 15:41:36 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 9 Nov 2020 15:41:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/48] 4.14.205-rc1 review
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b7646dfc53f64509be2bdfead517f8f6@HQMAIL109.nvidia.com>
Date:   Mon, 9 Nov 2020 15:41:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604936500; bh=MoiGd/pSomG81noma6Ww0KlgdwleMpj09IIWXQzyIrs=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=SYOscsVhfSs8u23mSu8biN+br8rBCP9drJFElr0Gp+kIKi//rpOwnhGL01C36KaNs
         9e52cHdbAv/Mn1LXieOa+WZJ+o0JgX6D8ddhk6b4vqLR+X3O3vFI658ueuEIMvZieu
         w/pmOJib0IUx0qSFnxVRX6Y/h81hO7cMWstzuTA8TIIsjpXWL2zF/XEajDF5zXv1rC
         kPkR0Medxxp9TAYviQh5blLUZSsQuY5Ejy1f/eYsCZHpMtMJ/1DYS/yD3dNR1KIYAl
         /ER7T4bGj/BZPe7Tvr+5AZEmuleOdFguBfaQNXRDnFnALh8Cdk7IS+6ddJ7CaXByDY
         Nc/XcqFk9fzYg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 09 Nov 2020 13:55:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.205 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.205-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.14.205-rc1-g0c03e845a8b9
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
