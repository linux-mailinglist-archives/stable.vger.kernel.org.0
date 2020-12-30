Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578A72E77C1
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 11:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgL3K0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 05:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgL3K0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 05:26:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E9E207B2;
        Wed, 30 Dec 2020 10:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609323971;
        bh=hGqGLcdH1Rr5jaWsOzWuKS38BIQgE6fztYK8Has20IM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T4PHKCHkEawU6uR+wwb6NBsrbzds8VfW+SZwvDZuTHf1ylCUUtN3VkWl5dn3TD1VL
         lf6qU2N5Gc9du4hLr/ncHW5JToP0kve7nHxtaIuzIOsbXy8dXMgWKWTqIJun3Bxvxd
         d6aZsr1UNrPOnOanUhIzs0C3bAgXlc9sr+E67vJ8=
Date:   Wed, 30 Dec 2020 11:27:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/346] 4.19.164-rc1 review
Message-ID: <X+xWGTs8lkQepXfh@kroah.com>
References: <20201228124919.745526410@linuxfoundation.org>
 <20201230093840.GB5420@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230093840.GB5420@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 10:38:40AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.164 release.
> > There are 346 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.164-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing 2 of these and letting me know.

greg k-h
