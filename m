Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3411E11C925
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfLLJae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbfLLJae (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:30:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73EE722527;
        Thu, 12 Dec 2019 09:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143033;
        bh=s0qY9t/hlZ/5iI+Wf7uj7AnfVTDo45ZB/RFGbHlgG0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YzfwQnf/tu5r2OsL8h3kxP2ZboSoKmurhHpHjejIc/a9/7WeoICjPty4fjyIEnFze
         Xar3yCj36ZNclUTbaEvWaSc8HOjT4+cxDpi1mDB8M/0uvy0vBrYFpgc+RDFmeXLq7D
         Zw2j7j2ZB2/wmwgLOiVYQVXiN16nZQ5A5oDov3qI=
Date:   Thu, 12 Dec 2019 10:30:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191212093031.GB1378792@kroah.com>
References: <20191211150221.153659747@linuxfoundation.org>
 <f753b0b9-dbed-c4f9-f530-a57c88b08634@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f753b0b9-dbed-c4f9-f530-a57c88b08634@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 09:13:06PM +0000, Jon Hunter wrote:
> 
> On 11/12/2019 15:04, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.16 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.3:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.3.16-rc1-g0b6bd9e91738
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing these and letting me know.

greg k-h
