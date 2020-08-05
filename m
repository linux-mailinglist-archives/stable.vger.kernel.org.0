Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6583F23D069
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHETs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:48:26 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17862 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgHETsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 15:48:23 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2b0ca40000>; Wed, 05 Aug 2020 12:46:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 05 Aug 2020 12:48:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 05 Aug 2020 12:48:23 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Aug
 2020 19:48:23 +0000
Received: from [127.0.1.1] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Aug 2020 19:48:15 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 0/8] 4.14.193-rc1 review
In-Reply-To: <20200805153507.005753845@linuxfoundation.org>
References: <20200805153507.005753845@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <0cd9e08356fe47ba8f3542411afce6ac@HQMAIL107.nvidia.com>
Date:   Wed, 5 Aug 2020 19:48:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596656804; bh=rK0I5ND/1OHxVi73SaFzoC2RHgKUAtovTWzdQvuD8M0=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=VcjPxVIOuHu72eSsp6egvhraT4c8cwD8CnQhxIUaoIfffYEZ2gBncEPQPksIZPwEi
         IJPo4grukEtqycYGpA9Iv+LPf1B6xKHRr6hFPbtrgIlc62VHAHR2yOK3d8QSp0JDYz
         R236mwvAJKqmFOtxLmG7vD+XoZzGY3a1Ds0d3Vu6hZQlF/pXSMTDxiNfPm3IMkDdas
         TDr9JaMJNxVb+Tr6wSbHsCGyMPkiDal4VioH/Cvg4aO/SlpTup+BnRd3YVvVqmqadk
         qUZ9FT8JuXHNn6sIzaRzf0SEhrVOXbnN5u0JzTqBpdFNtiy8VaFz/fbvnTW+wKhGt4
         WayXMtUTRm2lg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 05 Aug 2020 17:53:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.193 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.193-rc1.gz
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
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.193-rc1-ge8ffd3efac22
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Jon
