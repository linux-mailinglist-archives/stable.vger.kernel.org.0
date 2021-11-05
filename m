Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3884463BA
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 14:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhKENE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 09:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231844AbhKENE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 09:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C9EC61244;
        Fri,  5 Nov 2021 13:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636117307;
        bh=+iixnyf7MJNhvqf9F2NimPiFdRUEFFWHVFvENpXmyNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tIuEyzUGr+11KSiAd5QLkrbU+zLI8RcI813tAqdgnIe5QM25OQM8Ocae2fpmfPkNf
         9R9ZozGHI91OOM7LEVT0qSMhktCAYiQQmta9qgkeXpo8tl38vJEG1BXt+xOBQVDowM
         PXZomPJ5GJA5M99FTPtSopNly+6EQ1Bm5c4ZbJnE=
Date:   Fri, 5 Nov 2021 14:01:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/12] 5.15.1-rc1 review
Message-ID: <YYUrOBubzGisk055@kroah.com>
References: <20211104141159.551636584@linuxfoundation.org>
 <78c3c647-c98c-dab6-28bd-67d057c08ae7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78c3c647-c98c-dab6-28bd-67d057c08ae7@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 05, 2021 at 11:30:43AM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 04/11/2021 14:12, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.1 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP response") was
> pulled in late for v5.15 and this unfortunately broke HDA audio support for
> Tegra194. We are working on a fix for this and so the below failure is
> expected. For now we can ignore the below failures and I will figure out how
> we fix this.

Should that commit just be reverted?  Wouldn't that be the "correct"
thing to do right now and then work on fixing this properly later?

Is this being discussed anywhere so that the regression bot can track
it?

thanks,

greg k-h
