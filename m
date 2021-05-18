Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF97387BC1
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244403AbhERO6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 10:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244348AbhERO6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 10:58:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F218B6100C;
        Tue, 18 May 2021 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621349834;
        bh=4fxx2HXwNHAVpzBwpFGc6wXm+lY7t6XPE2Zp5JNLarY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m+x+O/pY7hvgXQfBpu51drURwMI3kYrKxbn5alADGEN1S631Halzs5a8YYNQpCaGS
         drSivyLvEr6b2hc51AoRBigdddPYIPk1HYxvVfvBfSDC2NUMPNyo70FwdXGHt02v4r
         8gOb+bOj8/O2sZYw+is3uBn4/uDNFSuBAKnazTeI=
Date:   Tue, 18 May 2021 16:57:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rudi Heitbaum <rudi@heitbaum.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc2 review
Message-ID: <YKPVyMlb60qYL9O3@kroah.com>
References: <20210518135831.445321364@linuxfoundation.org>
 <20210518144257.GA41@e07e318d3c06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518144257.GA41@e07e318d3c06>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 02:43:02PM +0000, Rudi Heitbaum wrote:
> On Tue, May 18, 2021 at 03:59:03PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.12.5 release.
> > There are 363 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 20 May 2021 13:57:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On Tiger Lake x86_64 kernel:
> - tested ok.
> 
> Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
> -- 
> Rudi

Wonderful, thanks for testing and letting me know.

greg k-h
