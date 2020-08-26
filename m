Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613F625344D
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgHZQDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:03:43 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8636 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgHZQDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:03:41 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4687ca0000>; Wed, 26 Aug 2020 09:03:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 26 Aug 2020 09:03:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 26 Aug 2020 09:03:36 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 16:03:36 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 26 Aug 2020 16:03:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 00/15] 5.7.19-rc1 review
In-Reply-To: <20200826114849.295321031@linuxfoundation.org>
References: <20200826114849.295321031@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <c86fdd71f05e494f8a504d0bfcb0d71d@HQMAIL101.nvidia.com>
Date:   Wed, 26 Aug 2020 16:03:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598457802; bh=/ixQoFNrXtrpiIZkNF1sxpkGl2IZgZC68sEhYxS/EnE=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=CLg0UMpS8kHNCVDlx4Llo1Jdy+gUSoGu0cHIIa25LZaPkHxn2IvTPT016QYuGB/ct
         7V/FEX/JpNHGv9uLew0F6fwNeQ5Ky8nUqOqzCxEBRooHTii3pNW5Env0+MQAtdyia/
         4b/x8bdyzJR7pyuqyj02QBkwjMOZsfvJXBLIlRcl4cJq4y0NN+7UwRrnlpO3WLLdZ/
         dGYax/meQVtWyG4KvavKrAuDa6LUh6L6p0cP9kmIkMM8Qtup1YWQoFteAwpJXMDFyO
         nx5DzXmd3UHWItrvDZytCXMkG7C8WUXQerI8Y6QojnNoGesFk1SLYJB6gjfctxYwOv
         WSGeOkjjCyXzQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 14:02:28 +0200, Greg Kroah-Hartman wrote:
> -------------------
> Note, ok, this is really going to be the final 5.7.y kernel release.  I
> mean it this time....
> -------------------
> 
> This is the start of the stable review cycle for the 5.7.19 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Aug 2020 11:48:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.19-rc1.gz
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
    20 boots:	20 pass, 0 fail
    42 tests:	42 pass, 0 fail

Linux version:	5.7.19-rc1-g6ae4171ed2cd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
