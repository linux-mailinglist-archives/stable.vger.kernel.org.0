Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC821A157A
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 21:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDGTC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 15:02:57 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10465 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgDGTC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 15:02:57 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e8cce2b0000>; Tue, 07 Apr 2020 12:02:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 07 Apr 2020 12:02:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 07 Apr 2020 12:02:56 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Apr
 2020 19:02:56 +0000
Received: from [10.26.73.75] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Apr 2020
 19:02:24 +0000
Subject: Re: [PATCH 5.4 00/38] 5.4.31-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200407154755.973323425@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <af3af99e-c86d-7cb4-3f9b-76ee20880101@nvidia.com>
Date:   Tue, 7 Apr 2020 20:02:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407154755.973323425@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1586286123; bh=+lpOgaURlFw6DZNJWlrCXeJ+HPILFxHI/OCMY13Mr6Q=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=lD+Ucvcn4Xi0RalRRwAlrUttwo+iNhPOB6CiDIzbGwx402yM7AzW5HecYLci7G+Xo
         kZiB+lz9sDu9yPfVtP2gMI80Zar7fpTci1Hrlh9oVIPz2OTB4Ze2BVhLQEjvHeZNUr
         CU57z9w+CPxlQrkVz3FrOmk02BuascShBRJC8h/OhSAjgnsefvhpf8/MhPV471K0sm
         IAjKDe5E30Moz278Dz9n9rfen3AaKFW1INVRdg6RzJeXhWNM+cdQ2bshoukX4jCJgz
         TWDEDUQm+hIL5Hh5mBAIJSI8p3SIitk8PspElRQsN0gEBGUFy7jCm7YQN6/Lk9U9dg
         qPiaCgb2oO1gw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/04/2020 17:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.31 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.31-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    24 boots:	24 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.4.31-rc2-g23c04177b89f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
