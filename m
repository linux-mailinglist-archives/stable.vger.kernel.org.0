Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D902F39E6
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406683AbhALTS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406399AbhALTS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 14:18:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F1F72311F;
        Tue, 12 Jan 2021 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610479096;
        bh=dvZst0Zbi/iJmusfsxHaHIbvx26mGxRklnLHETVUqM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SQFpVO467S+ei4BjNQVPftwXr9NeTZxoKzilVWFLdNxZ5+xSHKYa3I8qMZleTazzh
         FigrwsiU+YzMt6qS+8NEcAaeR1SAJ3UmAA+h2GC7jOjqaUOy+IZidKgwhWQRvTi9KB
         m46jNRGyAb/LT0zS8betVed503k8PLYva6/LaC8g=
Date:   Tue, 12 Jan 2021 20:19:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/144] 5.10.7-rc2 review
Message-ID: <X/32PELDNdlXM/AO@kroah.com>
References: <20210111161510.602817176@linuxfoundation.org>
 <86231e8d-f3f4-9f02-e436-761f93b881d7@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86231e8d-f3f4-9f02-e436-761f93b881d7@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 04:38:19PM -0700, Shuah Khan wrote:
> On 1/11/21 9:15 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.7 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.7-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing a bunch of these and letting me know.

greg k-h
