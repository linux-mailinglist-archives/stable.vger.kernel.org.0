Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26B68FBE3
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 09:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfHPHPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 03:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfHPHPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 03:15:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42892133F;
        Fri, 16 Aug 2019 07:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565939709;
        bh=LqH0gbd2FjHJicqwS1qhO3+BlnKDr3mzq24xGyzDLCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XWN+fR58ryy5bHN9uGGYICnVMGVCh9qRzIPRg6QZLnUuvUq9mCR+eLyfJiYRklBTd
         J0T3IqQs86IugpZE85FNjbYUOA93+enuL8PScnQRNF94GEFZEV3DEtQl/IaklI2t+l
         Sn8U9BagMB066j8E+ycO9xbYdw9qWBAf2Pi5my7o=
Date:   Fri, 16 Aug 2019 09:15:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.139-stable review
Message-ID: <20190816071506.GG1368@kroah.com>
References: <20190814165744.822314328@linuxfoundation.org>
 <c5b77555-a28e-ada8-c9e6-7d3c9d201327@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5b77555-a28e-ada8-c9e6-7d3c9d201327@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 08:37:33PM -0600, shuah wrote:
> On 8/14/19 11:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.139 release.
> > There are 69 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.139-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
