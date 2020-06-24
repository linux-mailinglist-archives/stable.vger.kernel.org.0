Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0499206C03
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 07:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389025AbgFXFzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 01:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388280AbgFXFzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 01:55:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB63F2073E;
        Wed, 24 Jun 2020 05:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592978153;
        bh=37nW3OgQK4TbdoZYhP1roWMo9l/k28uOf4hvfP1xX5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cFNtZYZBIrrmHNhvZA8JKjEEIxJM+Ml7BlFv0iTYqmrvqWJKSwV1ua3XZqUiMdc8C
         PWELuLlQ29GKLq5cG5wsuckqcZPrBIZSKqbl8ZzeEcgeO+ciEdZAEPGYp1pARNHoeL
         KKhlPAphE7AVQCeKzV7XEfLPOVibc9YK4Nhn2Bk4=
Date:   Wed, 24 Jun 2020 07:55:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/314] 5.4.49-rc1 review
Message-ID: <20200624055552.GD684295@kroah.com>
References: <20200623195338.770401005@linuxfoundation.org>
 <20200624041421.GA2086018@ubuntu-n2-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624041421.GA2086018@ubuntu-n2-xlarge-x86>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 09:14:21PM -0700, Nathan Chancellor wrote:
> On Tue, Jun 23, 2020 at 09:53:15PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.49 release.
> > There are 314 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 25 Jun 2020 19:52:30 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.49-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> I ran this through my LLVM build tests and saw no regressions compared
> to 5.4.47.

Great, thanks for testing!

greg k-h
