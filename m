Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFD23CEDD
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgHETIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:08:07 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14552 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgHES5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 14:57:41 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2aff1e0000>; Wed, 05 Aug 2020 11:49:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 11:50:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 11:50:42 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Aug
 2020 18:50:41 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Aug 2020 18:50:38 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/9] 5.4.57-rc1 review
In-Reply-To: <20200805153507.053638231@linuxfoundation.org>
References: <20200805153507.053638231@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <da75b06809a6409a88ad8543eb87e9b0@HQMAIL105.nvidia.com>
Date:   Wed, 5 Aug 2020 18:50:38 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596653342; bh=94hhJZwb/Ay8pfbhWJu8asqDyzfuJowQHyicHnqcsXg=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=WSb8FfZpUtSOF3uXAitN8vJid8N/G8VxpYEyF0XSu5inbP8IycK0kLaTjDbZO+Bqx
         28a+QvrHzu6BvbPhFxK5JO0rtGtE3Ecm9v7OUMKpCw7I9mzZMF+Mmx6JweNeNOpWGS
         cUOZ22Cxn65VidZLm6DKRBzMWM1h01tbP8oUb0OOPO74oCbmw2m9eLAV3CSBLme5AB
         k0Pcx/O0hbxToPRiqlrypl7Nee3RVEU3LMVFevGZR1a0u+PP3CWeamz/tVG1Nkbfic
         9kDryfcCI/+dXt3OexS7EBJAhy5igaKlZD5kxxQYG5FgrSXQUpFu1lNL2g/NDqBC1u
         ihbYR7yPVYNSQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 Aug 2020 17:52:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.57 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.57-rc1-g1c4819817cd8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
