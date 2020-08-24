Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8501F24FB2C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHXKRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 06:17:10 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1209 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHXKRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 06:17:03 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f43935a0001>; Mon, 24 Aug 2020 03:15:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 24 Aug 2020 03:16:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 24 Aug 2020 03:16:56 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 24 Aug
 2020 10:16:55 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 24 Aug 2020 10:16:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/124] 5.7.18-rc1 review
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
X-NVConfidentiality: public
MIME-Version: 1.0
Message-ID: <3bfa6330fd20416ca6cb8d4dd52b04cf@HQMAIL105.nvidia.com>
Date:   Mon, 24 Aug 2020 10:16:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598264154; bh=PwePFXUMiCksCf9q0ZKrl/HtCAeADHS+UYLUs1Ap8a8=;
        h=X-PGP-Universal:From:To:CC:Subject:In-Reply-To:References:
         X-NVConfidentiality:MIME-Version:Message-ID:Date:Content-Type:
         Content-Transfer-Encoding;
        b=B5Lcw8+o5Igghg19qk+K6KPBuoZ6LomCWyXWHMzYkKdaZvNZCGgsKvUgReQ2RO5b2
         JIsLE5obem/wnP+iQey0arSOloYywEYw3VE0YpLDVqR6TMnh5fjhBu2duQfxuNBKhs
         tRoUP6L6npbmI7orc1Vb4jD2RSD6vriLf+jf4FExNi6fin9EihcsNGVVVzuZCE1z4B
         LTH9FUov/Bw9M/ZtzQgHOd+fZ029KbycwowRkZGA2UJ2EVCAMnkItahQgIcXR8jbFW
         NERnxkvw5Ko4TYE3N05ZT7I7GN4RgXqnR5r8obiBDqyk86TgD/VyERK83+HXurUaym
         sDwVRHJQLSQSA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 10:28:54 +0200, Greg Kroah-Hartman wrote:
> -----------------------
> NOTE, this is going to be the LAST 5.7.y kernel release, please move to
> the 5.8.y tree at this point of time.  After this one, this branch will
> be end-of-life.
> -----------------------
> 
> This is the start of the stable review cycle for the 5.7.18 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.18-rc1.gz
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

Linux version:	5.7.18-rc1-g3e9e863143a3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
