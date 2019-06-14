Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3239C45448
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 07:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFNFt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 01:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfFNFt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 01:49:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E26D2133D;
        Fri, 14 Jun 2019 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560491398;
        bh=8FZKmjjIHsaK6FVcJfX/UxPrDe3CrGRsgfcMftFdxbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nq0brZVoV1W9zecATxZJHukR1lPJuuDkWjwHA3aOHYVuYxk7R46w6tuJl2ttbELgq
         51ag/113kpandsVF4/v74KVJFPApg+XPB3sHTDXE62aF4RPrK2e3CM2p+7ANVU8qEq
         K1XhRigqevCm+a0WQtGg/7cNQJiwrYYUCFUCGDO4=
Date:   Fri, 14 Jun 2019 07:49:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
Message-ID: <20190614054956.GC27319@kroah.com>
References: <20190613075652.691765927@linuxfoundation.org>
 <91e6c918-5c9d-a036-c207-dea6091bf3fd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91e6c918-5c9d-a036-c207-dea6091bf3fd@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 06:44:40PM -0600, shuah wrote:
> On 6/13/19 2:31 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.10 release.
> > There are 155 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.10-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Great, thanks for testing and letting me know.

greg k-h
