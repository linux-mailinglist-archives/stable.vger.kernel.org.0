Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA32691B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 19:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfEVR3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 13:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfEVR3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 13:29:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021F620862;
        Wed, 22 May 2019 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558546187;
        bh=pFLnOg9YEhfdDechfOzbrye3GwwnpaSRL0DmTM/u4bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FjkMBC7Gp9YmSP1kgIVK3rA9aziHPaQQ4FygR/VxHh6xbw1zfI6Ez3ALfBRVIlfc4
         BnGUrO9EjZp4Z88W4K6fxPSDxO+ZwP7+SxJMpkNFseyTFjk8ZuYznRTIzLx9Cmrmcq
         K8/N2GItGHwm7hhMpeZSFxsebNtiCX0Cf3V6refA=
Date:   Wed, 22 May 2019 19:29:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, kafai@fb.com,
        syzkaller@googlegroups.com, weiwan@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipv6: prevent possible fib6 leaks" failed
 to apply to 4.14-stable tree
Message-ID: <20190522172945.GA25977@kroah.com>
References: <155854389617965@kroah.com>
 <84edd412-c07d-28be-1723-a4727ae2ea56@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84edd412-c07d-28be-1723-a4727ae2ea56@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 10:52:57AM -0600, David Ahern wrote:
> On 5/22/19 10:51 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> As I recall it only needs to go back to 4.17.

Thanks, but someone backported the commit mentioned in the Fixes line:
	Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")

to 4.14.y.  If it's really not relevant there, not a big deal, now
dropped.

thanks,

greg k-h
