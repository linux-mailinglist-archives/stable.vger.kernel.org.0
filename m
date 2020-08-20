Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3201424C324
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 18:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgHTQNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 12:13:47 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15563 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgHTQNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 12:13:45 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3ea0c60001>; Thu, 20 Aug 2020 09:11:50 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 09:13:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 20 Aug 2020 09:13:45 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Aug
 2020 16:13:44 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 20 Aug 2020 16:13:44 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/226] 4.14.194-rc2 review
In-Reply-To: <20200820135009.684062405@linuxfoundation.org>
References: <20200820135009.684062405@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <e6143a996033461ba87fdff596ac4989@HQMAIL105.nvidia.com>
Date:   Thu, 20 Aug 2020 16:13:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597939910; bh=hcxpEMyNzCya5Nim0v+FbyRJJcAj/g/AcZ+c0/sm0Gk=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=EfJz4/qrDsBDBYIV9T5UJawGZWrpqqniPVGd/tELopysEXMLxSnpXoQ8utSS+KWd2
         V71GU0wDL/TSxm5WRXJNoruxcWVMQ0w3E4TQms1IaVtyw9ezOgl9ZFuG7eRfpsmfYF
         kll8OzOcpwLtu16rYURqZlnXZ9RFmgv6R6MUtWcj1Kn1C88X24M9rNaiVzE9x5BbvB
         8EcW9/P1NLxf0Kr82V7QyCu/odmSXN5Gh7YYO1bDXx3RXWbKYp7BYvvQ4I5JQCb1pr
         B4ZKyOhDPBEge/d40sNtNzvc3nD/vv9LAkDzO6MeOwbzB05tmD0jE2Z4Qnc58S4whF
         Tk8cYGXBdrp8A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 15:51:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.194 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 13:49:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.194-rc2.gz
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

Linux version:	4.14.194-rc2-g6c7d4935a4ff
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
