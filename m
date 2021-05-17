Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165EC38297C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhEQKJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236311AbhEQKJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 06:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A94F611CA;
        Mon, 17 May 2021 10:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621246096;
        bh=H+JrkyWsUNZKlicE1AkaK28gRrR9esXcKyacxduOLBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X2Ry/c3p+YJPkh38vK6xRI60ZIAeBj8jSThzllSgSI8rdOzQ59AOET6qoqdruqNQ+
         AcOU3py0tRDRKMxDcYf0RL7kCn9olJGK9krEoi929rHJI+ILWDgijMkzBggJ6ZFri5
         s2jruAClYKI59xfDaN6JVYu1OfJ9J1mEdbbsxRnA=
Date:   Mon, 17 May 2021 12:08:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] FDDI: defxx: Make MMIO the configuration
 default except for" failed to apply to 5.10-stable tree
Message-ID: <YKJAjqKnZuQiVbTD@kroah.com>
References: <162081180118299@kroah.com>
 <alpine.DEB.2.21.2105151906240.3032@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2105151906240.3032@angie.orcam.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 15, 2021 at 08:00:42PM +0200, Maciej W. Rozycki wrote:
> On Wed, 12 May 2021, gregkh@linuxfoundation.org wrote:
> 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
>  Hmm, I can see it's commit 8fa5a93a74fa and commit 8b2055c13731 in 
> queue/5.10 and linux-5.10.y respectively, so I guess it did apply after 
> all, right?  I've sent a version for 5.4-stable and earlier separately.

Yes it did, thanks!


greg k-h
