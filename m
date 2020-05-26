Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676991E2716
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 18:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbgEZQcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 12:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388061AbgEZQcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 12:32:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916502073B;
        Tue, 26 May 2020 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590510759;
        bh=aH1fxzKkh8oPDxVH7mWTxxRoboBCqxnYW/72VwKzH5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C8HUlHTjOdQmagDAuTUKqO201Qq3KYFEEwj2yfxa6nAttPsk8i8j6Y3EIyqsHG6Xf
         uaoW31+bxcYnB7IUywcCG+uOyvURvdgqXbaB+EPJfnZzo1yMRWa3vjAj1zUw5KM7OR
         D1IUnpfdN6H5zVXeFabr5gbl9cS53KDljOIVzRyE=
Date:   Tue, 26 May 2020 18:32:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526163235.GA42137@kroah.com>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <20200526065618.GC2580410@kroah.com>
 <20200526154835.GW499505@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526154835.GW499505@tassilo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 08:48:35AM -0700, Andi Kleen wrote:
> On Tue, May 26, 2020 at 08:56:18AM +0200, Greg KH wrote:
> > On Mon, May 25, 2020 at 10:28:48PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Since there seem to be kernel modules floating around that set
> > > FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
> > > CR4 pinning just checks that bits are set, this also checks
> > > that the FSGSBASE bit is not set, and if it is clears it again.
> > 
> > So we are trying to "protect" ourselves from broken out-of-tree kernel
> > modules now?  
> 
> Well it's a specific case where we know they're opening a root hole
> unintentionally. This is just an pragmatic attempt to protect the users in the 
> short term.

Can't you just go and fix those out-of-tree kernel modules instead?
What's keeping you all from just doing that instead of trying to force
the kernel to play traffic cop?

thanks,

greg k-h
