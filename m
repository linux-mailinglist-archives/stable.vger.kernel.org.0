Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB219AA9E
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 13:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgDALSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 07:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732150AbgDALSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 07:18:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212BD206E9;
        Wed,  1 Apr 2020 11:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585739925;
        bh=sYBeYzQQ4hfKuB0dBhCd6enF1aFyI2NQI0caO8q7VE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e13ePXmJYdal5tuhVDXMd7BZprXIsrO0LCHM28pDaCKfYRgMw9k/KiPHA83HHC/n2
         VD3eaSllUzsX166M8EyPGmN2DQqtVVBf2Duw4GLB6t9U88ZCTF9Yu5EDdKaWYsp1iu
         6iU0DDuwPxwmMlL8mLJgUxcAvH4S9oVA+DbYkQxk=
Date:   Wed, 1 Apr 2020 13:18:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Woody Suwalski <terraluna977@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200401111843.GC2144013@kroah.com>
References: <20200331085308.098696461@linuxfoundation.org>
 <6cdfe0e5-408f-2d88-cb08-c7675d78637c@gmail.com>
 <20200401055152.GA1903194@kroah.com>
 <20200401055309.GA1903746@kroah.com>
 <2e853806-264d-cf74-4298-146900ab32a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e853806-264d-cf74-4298-146900ab32a1@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 07:06:47AM -0400, Woody Suwalski wrote:
> Greg Kroah-Hartman wrote:
> > On Wed, Apr 01, 2020 at 07:51:52AM +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Mar 31, 2020 at 11:06:16PM -0400, Woody Suwalski wrote:
> > > > Greg Kroah-Hartman wrote:
> > > > I think you have missed the
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240
> > > It should come in soon, in another release or so, when the next set of
> > > networking patches get sent to me.
> > And also didn't hit Linus's tree until after this set of -rc patches
> > went out, so it's not like I missed it or anything :)
> > 
> > thanks,
> > 
> > greg k-h
> My bad. It was supposed to be: I think that that patch should be considered
> soon...

It will be, give us a chance.  I know the normal problem of "the only
drivers that matter are the ones I use" applies here, but luckily I
don't use that driver :)

thanks,

greg k-h
