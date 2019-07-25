Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FC8756B6
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 20:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfGYSR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 14:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfGYSR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 14:17:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0790218F0;
        Thu, 25 Jul 2019 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564078648;
        bh=vNiBpexJOLkJT1OK/Ak0sReI/jvKicgb9jdfc1P7pcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQjyv/EZSZA8TQbBc4NDPOC0tKWA6ACRDtfWpMcPMkDQd0ZX5jJWLng/StuUxH1wW
         H+D8+HhTSEV914fFvltgpsYRV/PnZEfYSHB3mkEPvqtQxBi++ubu8Sd3VFGt+7EtXO
         ppEZfe6TjaZy26mca/ScRWxHCVIf7S9JV4+hygtU=
Date:   Thu, 25 Jul 2019 20:17:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190725181726.GB10098@kroah.com>
References: <20190724191735.096702571@linuxfoundation.org>
 <4a1e00d4-d952-c463-963f-0a26ba3976a2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a1e00d4-d952-c463-963f-0a26ba3976a2@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 10:04:43AM +0100, Jon Hunter wrote:
> 
> On 24/07/2019 20:14, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.3 release.
> > There are 413 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.3-rc1-gdb628fe0e67f
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Great, thanks for testing all of these and letting me know.

greg k-h
