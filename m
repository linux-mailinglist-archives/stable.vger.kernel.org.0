Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2107D4A645
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 18:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfFRQJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 12:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbfFRQJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 12:09:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922F420B1F;
        Tue, 18 Jun 2019 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560874167;
        bh=luz2BG80Y7diNtNrxV0pl4BDT0sJKnNE1Rh6oQiOskc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHExTccndL3g9yvf1aFsUsmy6w937hKr4vVwO3iW/6NLN9+mNTLgmz0BbGA54nEDS
         nTGu102GOSGmKjV9R2okDNlefYtveT9DJjkGpmrqjEV8rofrvxJaWLTtwJiJ1V5d0e
         Cd4m9lnvu2JPwZt/tPRx/QThA8YFP2jBqGXYq3GU=
Date:   Tue, 18 Jun 2019 18:09:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/115] 5.1.12-stable review
Message-ID: <20190618160924.GD27611@kroah.com>
References: <20190617210759.929316339@linuxfoundation.org>
 <716d3e71-3ae0-709a-4705-db4c3c5ff3f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <716d3e71-3ae0-709a-4705-db4c3c5ff3f9@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 07:37:45AM -0600, shuah wrote:
> On 6/17/19 3:08 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.12 release.
> > There are 115 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.12-rc1.gz
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

Thanks for testing these and letting me know.

greg k-h
