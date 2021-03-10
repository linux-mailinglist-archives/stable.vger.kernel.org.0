Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51DE333C06
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhCJMCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232650AbhCJMCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 07:02:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD80F64FD7;
        Wed, 10 Mar 2021 12:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615377737;
        bh=/eEinG3KxIZMrWrXYSrji41H6Uu/4J7UuAOlOdWiTj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cLgPQkud3EZJAvUe8zTGtf9xZy75Cp1zn83QLkvBV1FE4dLkX1gt9C37RBEjyt/7X
         r/oiUJHp50bjwh3fChkvKQ+OH2E18j3d2DWsLtfJTPDVmAxMkUQRrgL/tDbpebk4fF
         on4e+Ug7qQTiNR6ytW+d0cJR7xRRfpMzSogQO8gA=
Date:   Wed, 10 Mar 2021 13:02:14 +0100
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
Message-ID: <YEi1RgPgwfT7qHQM@kroah.com>
References: <875z419ihk.fsf@toke.dk>
 <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
 <2656681.1610542679@warthog.procyon.org.uk>
 <87sg6yqich.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sg6yqich.fsf@toke.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 06:13:02PM +0100, Toke Høiland-Jørgensen wrote:
> David Howells <dhowells@redhat.com> writes:
> 
> > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> >> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> 
> >> and also, if you like:
> >> 
> >> Tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >
> > Thanks!
> 
> Any chance of that patch getting into -stable anytime soon? Would be
> nice to have working WiFi without having to compile my own kernels ;)

What ever happened to this patch?  I can't seem to find it in Linus's
tree anywhere :(

thanks,

greg k-h
