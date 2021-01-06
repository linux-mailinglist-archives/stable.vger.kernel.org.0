Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70E2EBF0A
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 14:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbhAFNpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 08:45:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbhAFNpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 08:45:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E870922B40;
        Wed,  6 Jan 2021 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609940672;
        bh=SzOY2Xyg40x/wYalPmWwEwm/jAZmFh6b493Z8dQdrns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EaDFNJHLbOIhWUQxrhByJQhs9/PlGwq/Y4IdD27NEWKXPc5PjZ4og+qkvkkBtjzBV
         MuDRZZvDmtIrIGfWuy9YUR9tWZi3Z/b1MDx66Fgk4PUZHxmJvYyjArTFOKkHawyxV5
         rEPVM6B5+IAcNbE80TLq6mEopXH1yfp2WcTTwZBw=
Date:   Wed, 6 Jan 2021 14:45:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
Message-ID: <X/W/DUTQOEB2dwgq@kroah.com>
References: <20210105090818.518271884@linuxfoundation.org>
 <6e2c8118-fa1a-1b56-a969-73501b002bcc@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e2c8118-fa1a-1b56-a969-73501b002bcc@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 04:29:44PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 1/5/21 3:28 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.165 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Great, thanks for testing them all and letting me know.

greg k-h
