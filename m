Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4933B222
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCOMIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230142AbhCOMH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 08:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 492A464E27;
        Mon, 15 Mar 2021 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615810076;
        bh=+UjJckQjWriZ1B6VVWueYRdQH/YSy1cULoyhhX7jdpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w099lT/GaS7+7lwl13vyWY8l5SQ95TYQWPb2GL0GZf3p5j0wJ1EXuRGeVARBaiY07
         /6JZOwU9Ddvy3hVNBIOBRFLYxt+CzdkVvK+RsMuOxfh3NRaqRYldlFBq98QJryQQtG
         mC249GcDSj1/wk7ywNf2Y9Ndl6iqzWAf0xU3eCCs=
Date:   Mon, 15 Mar 2021 13:07:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
Message-ID: <YE9OGk/iLq5kW7zo@kroah.com>
References: <875z419ihk.fsf@toke.dk>
 <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
 <2656681.1610542679@warthog.procyon.org.uk>
 <87sg6yqich.fsf@toke.dk>
 <YEi1RgPgwfT7qHQM@kroah.com>
 <87czw0pu2j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87czw0pu2j.fsf@toke.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 11:52:52AM +0100, Toke Høiland-Jørgensen wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > On Mon, Jan 18, 2021 at 06:13:02PM +0100, Toke Høiland-Jørgensen wrote:
> >> David Howells <dhowells@redhat.com> writes:
> >> 
> >> > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> >
> >> >> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> >> 
> >> >> and also, if you like:
> >> >> 
> >> >> Tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> >
> >> > Thanks!
> >> 
> >> Any chance of that patch getting into -stable anytime soon? Would be
> >> nice to have working WiFi without having to compile my own kernels ;)
> >
> > What ever happened to this patch?  I can't seem to find it in Linus's
> > tree anywhere :(
> 
> This was a matter of crossed streams: Tianjia had already submitted an
> identical fix, which went in as:
> 
> 7178a107f5ea ("X.509: Fix crash caused by NULL pointer")
> 
> And that has made it into -stable, so all is well as far as I'm
> concerned. Sorry for the confusion!

No worries, thanks for letting me know.

greg k-h
