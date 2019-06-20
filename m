Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43E24D005
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfFTOH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 10:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbfFTOH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 10:07:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02BCC20679;
        Thu, 20 Jun 2019 14:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561039677;
        bh=RLfDCQj8K73tn7XVe6xvrqpIPPfI9HpAQniOrHih8jI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jExcuJKyZIdBiIm5kIwl6MLois9WztXJbJmE58LFlfCmHfSWCGVHQzd5KVmLopTFl
         KSADCw3nM8cLHtVdWaOCWN7FXZbqxf0YQgM4gLCyVIIE2E6740TECRjO9FQ5phuzz4
         4hHhSrZMa3MlcByBGLUdafK3NMUpkxG78DbbabfI=
Date:   Thu, 20 Jun 2019 16:07:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, herbert@gondor.apana.org.au,
        davem@davemloft.net, stable <stable@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>
Subject: Re: crypto: crypto4xx - properly set IV after de- and encrypt breaks
 kernel 4.4
Message-ID: <20190620140755.GC7117@kroah.com>
References: <9d744c3b-d4ff-b84b-527b-fc050794499b@hauke-m.de>
 <4226536.PGTo7a8ESG@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4226536.PGTo7a8ESG@debian64>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 02:07:27PM +0200, Christian Lamparter wrote:
> On Thursday, June 20, 2019 11:36:50 AM CEST Hauke Mehrtens wrote:
> > Hi,
> > 
> > The patch "crypto: crypto4xx - properly set IV after de- and encrypt"
> > causes a compile error on kernel 4.4.
> 
> 3.18 as well.
> > 
> > When I revert this commit it compiles for me again:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=e9a60ab1609a7d975922adad1bf9c46ac6954584
> > 
> > I do not have hardware to test if it is really working.
> 
> I have a few APM821XX. But please note drivers without
> 
> commit b66c685a482117d4e9ee987d252ca673689a5302
> Author: Christian Lamparter <chunkeey@gmail.com>
> Date:   Fri Dec 22 21:18:36 2017 +0100
> 
>     crypto: crypto4xx - support Revision B parts
> 
> don't work on those and I do have my doubts that 460EX
> series (and older) would either. I also don't believe that
> the inital driver as it was submitted would have worked.
> >From what I've seen in their SDK, they patched the testmgr
> at the time to either disable tests or provided their own...
> so, might as well revert these patches for 4.4 and 3.18.

Now reverted from both, thanks.

greg k-h
