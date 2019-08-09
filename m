Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F9587A45
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfHIMgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 08:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406662AbfHIMgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 08:36:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FFC208C3;
        Fri,  9 Aug 2019 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565354200;
        bh=OVNyItc5np5bzQSMG2diKyJkWKZ56U+a0uudUsnoIW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yRi8uY3YtszUDgZ9Ao6I0sAEiUb9pwaoMZY7vMDaXuHcs6mzQskVQ+NgwolB0UDVi
         5tyQS+wswQeoBGL4Q650dkQm8vktcOvZqwDFCEfDnMN3Et8EGaj0EaiQSMk88lRLjy
         Bv1Fmg6d8okgh0ysleEzdEDSlZnB+j+YSZ6Ll41M=
Date:   Fri, 9 Aug 2019 14:36:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable <stable@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Grand Schemozzle, 4.9 backport
Message-ID: <20190809123638.GA27652@kroah.com>
References: <1fcba38ae50cb4e740839c825fb2eb96b3c54956.camel@decadent.org.uk>
 <20190809084444.GA9820@kroah.com>
 <2df1e3caea566bcfd0338734f1cea6083264d597.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2df1e3caea566bcfd0338734f1cea6083264d597.camel@decadent.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 12:46:37PM +0100, Ben Hutchings wrote:
> On Fri, 2019-08-09 at 10:44 +0200, Greg Kroah-Hartman wrote:
> > On Fri, Aug 09, 2019 at 01:05:28AM +0100, Ben Hutchings wrote:
> > > Here's a lightly tested backport of the Spectre v1 swapgs
> > > mitigation,
> > > for 4.9.
> > 
> > Hm, you backported 64dbc122b20f ("x86/entry/64: Use JMP instead of
> > JMPQ") which is not in 4.14.y,
> 
> For 4.14, it was apparently folded into the backport of
> "x86/speculation: Prepare entry code for Spectre v1 swapgs
> mitigations".

Ah, sneaky :(

> > yet you did not backport 4c92057661a3
> > ("Documentation: Add swapgs description to the Spectre v1
> > documentation") which should go to this kernel too, right?
> 
> That touches a file that doesn't exist.  We'd first need a backport of
> commit 6e88559470f5 "Documentation: Add section about CPU
> vulnerabilities for Spectre".

Ok, that makes sense.

Let me go queue both of these series now, thank you so much for these.

Also, I would like to formally apologize that you had to do this work on
no notice at all.  I, and others, have been asking Intel to allow you to
be involved in this type of thing for many many many months.  Despite
their assurance of "we got this", the obviously did not follow through
at all, and you and all Debian users suffered as a result.

thanks,

greg k-h
