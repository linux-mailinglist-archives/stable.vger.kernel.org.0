Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6209422F2F1
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgG0OrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:47:12 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14501 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgG0OrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 10:47:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f1ee8e20000>; Mon, 27 Jul 2020 07:46:59 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 27 Jul 2020 07:47:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 27 Jul 2020 07:47:12 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Jul
 2020 14:47:12 +0000
Received: from [192.168.22.23] (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 27 Jul 2020 14:47:09 +0000
From:   Thierry Reding <treding@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/179] 5.7.11-rc1 review
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <8bd52f5eab274431925b82ee9c5f13c5@HQMAIL105.nvidia.com>
Date:   Mon, 27 Jul 2020 14:47:09 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1595861219; bh=mCe2jhBQ/C8mkrNSk9jzIjCd08de8/WFPU33RQbpgGw=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=XwSAeY0emLxMhdaemoOwVlOqWSMxsoh2QD/nILm+WFArtwBj0yTgoqXLS3O1WlFyS
         AG1nMI+D3zzaQZdeMEF+iAmo6IIUzy/kDAdCr4SfmcWPF3L584qY93kPGBcsujLLY/
         1foUrJDNCwmQ+GUqPDVckbkH8anSDVd+Es7Dklf+90uMoj7UQrah9XDuF1eCj0PHle
         PGvzu2jIfH55oUQNDCafdZbpNg4Le7anAEpWMXIPtzGvlTp7vo+0qjUrf77XzL7y28
         14Z22MU3cCLxyTRbkiskiVaPl8M8/59RaHEbAvThE4vhOwR0S4p3uZJe0GU8TeFu5w
         wKQcpxRkn157A==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jul 2020 16:02:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.11 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.11-rc1.gz
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

Linux version:	5.7.11-rc1-g5e6331d4c49c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Thierry
