Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FEB278BAF
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 17:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgIYPAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 11:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgIYPAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 11:00:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BA920715;
        Fri, 25 Sep 2020 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601046040;
        bh=S9JIjhhb3MhwmUIqbslNAib7MB8BHJLitTeirDhzp04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cxfw6us0Sd7wQChjlDeSKRpNGI7SV9VduYZfovGOo5qIe6eKnSAc7lCJIETICq2Rk
         iNjeaOCyGgQIXDKtGruhYYER2Rb7R5jq/PPNSjnfAQhT0zyp8EC4K4xuodMvHbZwM/
         +R1J01/56uSvGFemHwwJdITpAByJkgiUwz8+csTM=
Date:   Fri, 25 Sep 2020 17:00:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series
 support
Message-ID: <20200925150054.GA3165387@kroah.com>
References: <20200921081022.6881-1-johan@kernel.org>
 <20200925144922.GA3113925@kroah.com>
 <20200925145331.GL24441@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925145331.GL24441@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 04:53:31PM +0200, Johan Hovold wrote:
> On Fri, Sep 25, 2020 at 04:49:22PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Sep 21, 2020 at 10:10:22AM +0200, Johan Hovold wrote:
> > > Add support for Whistler radio scanners TRX series, which have a union
> > > descriptor that designates a mass-storage interface as master. Handle
> > > that by generalising the NO_DATA_INTERFACE quirk to allow us to fall
> > > back to using the combined-interface detection.
> > > 
> > > Note that the NO_DATA_INTERFACE quirk was added by commit fd5054c169d2
> > > ("USB: cdc_acm: Fix oops when Droids MuIn LCD is connected") to handle a
> > > combined-interface-type device with a broken call-management descriptor
> > > by hardcoding the "data" interface number.
> > > 
> > > Link: https://lore.kernel.org/r/5f4ca4f8.1c69fb81.a4487.0f5f@mx.google.com
> > > Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > > Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > > 
> > > v2
> > >  - use the right class define in the device-id table (not subclass with
> > >    same value)
> > 
> > Is this independant of your other patch series for cdc-acm?
> 
> This one is superseded by the series, so please drop this patch. Sorry
> for not making that clear.

No worries, thanks for the quick response.  Now dropped.

greg k-h
