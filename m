Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1812C23D6C5
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 08:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgHFGYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 02:24:34 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3042 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgHFGYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 02:24:34 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2ba1ed0002>; Wed, 05 Aug 2020 23:23:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 23:24:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Aug 2020 23:24:31 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 6 Aug
 2020 06:24:31 +0000
Received: from [127.0.1.1] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 6 Aug 2020 06:24:28 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
In-Reply-To: <20200805195916.183355405@linuxfoundation.org>
References: <20200805195916.183355405@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <fb74b2c119a047e2933b5d375f0fe703@HQMAIL101.nvidia.com>
Date:   Thu, 6 Aug 2020 06:24:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596695021; bh=i0ZywK+lSqNkDxG6NKQmq/JmVropILoT9472TFbw3oU=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=Wa8Z1bjluYJFy7NuNei8Am5pDwa6D1GinhdljqwE8fqZxYL/unHsXUXStw8oiwG2/
         1eabzY+l4S4HQDPYPcmvSk+pVE4KG5+wiQtB8st23vv6ln78VQIHjV+Eh+QJSiTIqu
         d4TiO2CoBC+NzjbERQCgfboFAlJdS6hMnBaia3gnpaIurBSxGxwvbEdZ5Iz72cz4bN
         hcMpOaNC1WCcxzsLz7+v/cCvCbdzBBvrqVXWEnOdUh19hd8LNV0nEhTnHxrZM2VO6e
         andkReBp8JKprqyKc+PDpCZ7JbZa6boKFf6nGFXLFBnEYwUEFllJCp7Q8PV9Ksbrhe
         Ag9ezvAKhinCw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 Aug 2020 21:59:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.14 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.7:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.7.14-rc2-g0ceaad177e51
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Jon
