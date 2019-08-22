Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC19A3F4
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfHVXit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHVXis (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 19:38:48 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A188621848;
        Thu, 22 Aug 2019 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566517127;
        bh=ITNFY1BlYLCzTwOHLm2S2nQdiT2eZatinPQGLa5g+Sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O0o7UwKYKklXR/jKKK0FAlAwfnUpzLvehLMMLFfLLhKiv9tlkog2vCr8BVDG9AY3K
         ibp/4boiS0DOZCvXnMHaXiem5fmlp9v9kxBxJPAE0RSVXH7MJD0aLkhiNAjJezCrk7
         ptGqxAKN++IjZoLFkDAHUTiJyPW+8tN/ECHUYqjQ=
Date:   Thu, 22 Aug 2019 16:38:47 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190822233847.GB24034@kroah.com>
References: <20190822170811.13303-1-sashal@kernel.org>
 <20190822172619.GA22458@kroah.com>
 <20190823000527.0ea91c6b@mir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823000527.0ea91c6b@mir>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 12:05:27AM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2019-08-22, Greg KH wrote:
> > On Thu, Aug 22, 2019 at 01:05:56PM -0400, Sasha Levin wrote:
> > >
> > > This is the start of the stable review cycle for the 5.2.10 release.
> [...]
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.10-rc1.gz
>                                                    ^v5.x
> [...]
> > If anyone notices anything that we messed up, please let us know.
> 
> It might be down to kernel.org mirroring, but the patch file doesn't
> seem to be available yet (404), both in the wrong location listed
> above - and the expected one under
> 
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
> or
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.xz
> 
> The v4.x based patches can be found just fine:
> 
> https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.190-rc1.gz
> https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.190-rc1.gz
> https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.140-rc1.gz
> https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.68-rc1.gz

Ah, no, it's not a mirroring problem, Sasha and I didn't know if anyone
was actually using the patch files anymore, so it was simpler to do a
release without them to see what happens. :)

Do you rely on these, or can you use the -rc git tree or the quilt
series?  If you do rely on them, we will work to fix this, it just
involves some scripting that we didn't get done this morning.

thanks,

greg k-h
