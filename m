Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8840F143B
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 11:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfKFKqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 05:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfKFKqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 05:46:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C942173E;
        Wed,  6 Nov 2019 10:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573037172;
        bh=eSHpZGIiVicGJP+7/7raVfKihwjNw/PcaPaMQYJk17g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ows1ZmwXHRBv0/gH2ODL+rr5lSFHUc18PvPsVueEGK4qU6Fcn2f/0oYFuREn6xRGB
         7TTAJIJnUe4mUIng9mS51DjYpJ/y7W7SBwbT5+5ZBFLEOvBovrCVFlvqBhj00GgRRv
         fMsnnAcE1dOt8x7aQX8XlzMcyC5tDy3nTOWqxM5o=
Date:   Wed, 6 Nov 2019 11:46:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/163] 5.3.9-stable review
Message-ID: <20191106104609.GB2982490@kroah.com>
References: <20191104212140.046021995@linuxfoundation.org>
 <82ebb88b-6828-2c80-e4ac-891427e90f2a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82ebb88b-6828-2c80-e4ac-891427e90f2a@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 09:51:43AM -0700, shuah wrote:
> On 11/4/19 2:43 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.9 release.
> > There are 163 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
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
