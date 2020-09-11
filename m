Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA8C2665BF
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgIKRMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:12:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9739 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgIKRKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 13:10:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5baf7c0000>; Fri, 11 Sep 2020 10:10:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 10:10:33 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Sep 2020 10:10:33 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Sep
 2020 17:10:33 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 11 Sep 2020 17:10:33 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 0/8] 4.19.145-rc1 review
In-Reply-To: <20200911125421.695645838@linuxfoundation.org>
References: <20200911125421.695645838@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <c73376187b04442fb857914588ba95ea@HQMAIL105.nvidia.com>
Date:   Fri, 11 Sep 2020 17:10:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599844220; bh=Q1PKR+xMnhd2gTVTVQLTF4LTOjL5EJCEi5SoEa3b2l8=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=aKe8guYB6nmTp4v29xZS16F33ViBIwQ5uGI9ESN/wMYnMrSv9LvOxMNvdj47bPn4j
         xhO6gmr+h9xAgjToJtZEIZQ/PSk9dsVB50dGJTWLnPaEuBXTOl5w92T5PkejRwC9cP
         6BSncw806eNEsocSct4Y8yhYDMAWrX4s3AvQz3GzIj8mSSE2cpqFI0INAxa5yUq8zh
         WkpyXXJttQlUcogG3nruRZIC1/BrzyTlkVQGgmTi60irFYs/0NbrMmWj+ElIoZpmpo
         HkPpgZICNO44T/fx1cw6vJIIiF6R96l98rBZzD/NUn1J70dkB9PFHNWjViDdNqQYlv
         DcnfnpJHxn7Nw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Sep 2020 14:54:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.145 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:54:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    14 builds:	14 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.145-rc1-gdc4669f837af
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
