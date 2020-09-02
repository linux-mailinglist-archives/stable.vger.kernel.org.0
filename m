Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758DB25A6DF
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIBHg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIBHg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 03:36:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DDF3207EA;
        Wed,  2 Sep 2020 07:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599032216;
        bh=UDYaPWY1oS3KWoU/8ARko6bgUSNf6ai7JxlKBzaoMlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5R/Ho1E6MREUe5fjYWmIoFjRcgGtDcdecaBREcVjCqXcBsJ1lLHkzAYcNutGZ4SD
         dTls0LY/Tne61QllzoY5Or+ugKESsyQzi7WtbtQbwW5jNN3AEIiQRbKg/Tq0R6gaiB
         jut2t1ndFZISC8r7+oQi+BUpTyfW1XhkLJzWpEOY=
Date:   Wed, 2 Sep 2020 09:37:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/62] 4.4.235-rc1 review
Message-ID: <20200902073722.GD1610179@kroah.com>
References: <20200901150920.697676718@linuxfoundation.org>
 <76622586-3742-692a-c9de-994ac21c5257@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76622586-3742-692a-c9de-994ac21c5257@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 11:58:21AM -0700, Guenter Roeck wrote:
> On 9/1/20 8:09 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.235 release.
> > There are 62 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building powerpc:defconfig ... failed
> --------------
> Error log:
> arch/powerpc/perf/core-book3s.c: In function ‘record_and_restart’:
> arch/powerpc/perf/core-book3s.c:2045:7: error: implicit declaration of function ‘perf_event_account_interrupt’; did you mean ‘perf_event_interrupt’? [-Werror=implicit-function-declaration]
>    if (perf_event_account_interrupt(event))
> 
> Caused by commit 91d6f90ac6d5 ("powerpc/perf: Fix soft lockups due
> to missed interrupt accounting"). perf_event_account_interrupt()
> does not exist in v4.4.y.

Ah, good catch.  Sasha, I thought your builder would have got this one?

Anyway, now dropped, I'll push out a -rc2 for this as well soon.

thanks,

greg k-h
