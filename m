Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132EF24FB2B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHXKRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 06:17:07 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1196 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgHXKRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 06:17:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4393590000>; Mon, 24 Aug 2020 03:15:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 03:16:54 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 24 Aug 2020 03:16:54 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 10:16:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 24 Aug 2020 10:16:49 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/107] 5.4.61-rc1 review
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <77c54096d0a34f8da06219caddc87400@HQMAIL107.nvidia.com>
Date:   Mon, 24 Aug 2020 10:16:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598264153; bh=L/wvA1hJmo+UtvEIh8Yp8TS6Ue9/jojCdSLP1OCABVQ=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=kYgbZEMwgW93aRn50REBC5xNu2SPj+pkoWXeKisyrl0jZhF5wyKJ9BOQ3JywNT3zH
         nooR1uZ9dwB+gLmFJGuNpP71fg+k5SLAnCcnnZ1oni9j3jIkeUXqpfWCQbq2oQ7C+f
         eaKif9uw0tJo6N5DGGhYzAR6gvZEBjLInv6q/PYh4vKEZKUJ2cR3AJh9FAxMjdBAz6
         mSB3C+4840rH20iSp4h2+Q+K5ZGjk8hJu5uunSIX/d7qZNct0zxBNzmmQELFIXIa/D
         lkNHAdp65WKjT985Mc2pHa/ii5pTHdaOkBAeJnUvXyR4D+/7mU5mq6Eta5+G8/bQ9a
         xBQ+FzIkX+yBQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 10:29:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.61 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.61-rc1.gz
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

Linux version:	5.4.61-rc1-g302fb8173830
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
