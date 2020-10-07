Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0314F286566
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 19:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgJGREM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 13:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGREL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 13:04:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F22C20782;
        Wed,  7 Oct 2020 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602090250;
        bh=FuUW/FmbyBjl1EcKJWXCNhtAfXeLXju0PFDi0Ve94Sc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i4Cz02VdQE9YAq0yWr58CLe4rEooiN7IHQH9plPxkX9UfLrZIua8f7vKzMeM9MjuF
         5nf0qDrhZjBSodnUPabnYan9CbD1wJU3m1JfEMuweOYyGGzlIOpxt3OrPKQImucyUQ
         fBTUEOCfO7MVAnmpgIoSc7N2IodZIhb1XC55gCE4=
Date:   Wed, 7 Oct 2020 19:04:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Request for inclusion for 5.4-stable
Message-ID: <20201007170456.GA86482@kroah.com>
References: <690b1e06-742d-6b1f-2f09-83edcc562d95@kernel.dk>
 <20201007164417.GA50479@kroah.com>
 <3e741883-678e-a539-0e6d-6fd681fb5c50@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e741883-678e-a539-0e6d-6fd681fb5c50@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 10:45:26AM -0600, Jens Axboe wrote:
> On 10/7/20 10:44 AM, Greg KH wrote:
> > On Wed, Oct 07, 2020 at 09:36:23AM -0600, Jens Axboe wrote:
> >> Hi,
> >>
> >> Can you queue up this series for 5.4-stable? It fixes some issues
> >> with an earlier patch that was queued up for 5.4-stable.
> > 
> > These aren't upstream, right?
> > 
> > Are they a special 5.4-only stuff?
> 
> Right, we had to make some 5.4 specific changes to fix various cases,
> hence these are only applicable to 5.4 as they are fixes for that fix...
> 
> > And I need a signed-off-by: from you at the very least :)
> 
> Oops for sure, here's an updated one :-)

That works, now queued up, thanks!

greg k-h
