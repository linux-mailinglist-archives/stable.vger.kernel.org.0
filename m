Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B09A1820C6
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgCKS1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgCKS13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 14:27:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660882072F;
        Wed, 11 Mar 2020 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583951249;
        bh=JLWjuj8B8lVUJKRqhwC4EOaviiNoOLpnA4UUmlfhk3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ElkI9DnO591Fg4rDQWDb6iaXgF4ksYb9QJrogIIQlYq5TFgIx2a8ap6e6DKWjTdEz
         e13MHlUugjxV838WCyHOx2diZYNA6rYdFOcdWb1GpN2YRDszXPJnvl0tPV2Vs713Ko
         JgIDFOOU0LbFbFDjOpb/YMGQ7Nm7Go9e89Vt08wM=
Date:   Wed, 11 Mar 2020 19:27:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/190] 5.5.9-rc2 review
Message-ID: <20200311182726.GA4021147@kroah.com>
References: <20200311181532.692464938@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311181532.692464938@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 07:19:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2020 18:14:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.

I got the request from some of the teams doing "automatic testing" that
it was hard to trigger their test runs when I did a -rc2 and -rc3 and so
on, as I was just responding to them "by hand".

So I tweaked my scripts a bit and now will send out these types of
automated emails for when I push out a new -rc for the stable releases.

For those that didn't know, there are a bunch of "X-KernelTest-" headers
in these emails, that should be enough to help trigger just about any
type of test systems out there.  If there's any info missing there, that
will help you out, please let me know.

thanks,

greg k-h
