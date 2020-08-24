Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C1A250723
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHXSJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:09:11 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5560 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHXSJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:09:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4401c60001>; Mon, 24 Aug 2020 11:07:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 11:09:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 11:09:01 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 18:09:00 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 18:09:00 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/39] 4.9.234-rc2 review
In-Reply-To: <20200824164720.742523552@linuxfoundation.org>
References: <20200824164720.742523552@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <51473c9710ac4715b18d9c26daaad953@HQMAIL105.nvidia.com>
Date:   Mon, 24 Aug 2020 18:09:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598292422; bh=qxJ6ZXIwL4be73kfu6DtQ9TWXfzQA7rIPd80Lat2/nM=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=ElmrzBuJoFDR3+uPYfmLFu1XBzCKBNxzy+YnMNjdqqpkPYDWIPK37HQdkzAJ1ct17
         oedseiHVqEhCgSR4w9UKLRnapCki+9FhOw/v9JCDlj2GRN5yk8NxO6nwip6KRu7WMQ
         zCt1xc318KVqT1CfMykLvFkC0jU47PAwKNjH5tOzi0XDpheA2LBpOckE2Qri7y+T8K
         SlKh2jGrwZ2LrRIFnGPRNY4qG7KzTKIyvtJ/X7EedqfClOkso57tBlUSXfAOuci6sq
         8FeQhmDiLooKz74XwP2MBiHXPUA002eowQ44y264tWCEnvAnS28XQqoTzBfBtK8Z9a
         PEKj8W3kGJkWg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 18:49:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.234 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.234-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.234-rc2-g306b4f399ede
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
