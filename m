Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADDD2305B
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbfETJaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730966AbfETJaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 05:30:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9557320675;
        Mon, 20 May 2019 09:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558344611;
        bh=5Ih4ArUAWK//Nx2oUT0KcJI/at5Zl82NJS59rQmq708=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h7HLue19It3sE0XIVt6GtgiE9KZ2l5YsIdaLSMqP9udJvHgM1W/3D2zY7CLEJ59gS
         qPKXq5wbOocvjHpSxckWlgpcp4KmkMWWpHaFn+yFq41YKgtBHcNZGYy2pWcSjLuMIo
         bvcHMothVb+eikfwlgUSqoqp+36a4/20aU94Sd4Q=
Date:   Mon, 20 May 2019 11:30:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/35] crypto: ccree: features and bug fixes for 5.2
Message-ID: <20190520093008.GA4476@kroah.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
 <CAOtvUMd9WUZAFgTqVH0U2ZZp8bbHXNg9Ae_ZFvGKJTSKNct8JA@mail.gmail.com>
 <20190517145235.GB10613@kroah.com>
 <CAOtvUMc++UtTP3fvXofuJA4JpdT86s5gbSx6WRtDK=sWnuUZrg@mail.gmail.com>
 <CAOtvUMcfXHv0UxytEEdGJG5LM-SfyyVHbnbE0RNALMfBD1zuEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMcfXHv0UxytEEdGJG5LM-SfyyVHbnbE0RNALMfBD1zuEQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 19, 2019 at 11:28:05AM +0300, Gilad Ben-Yossef wrote:
> On Sat, May 18, 2019 at 10:36 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> >
> > Hi
> >
> > On Fri, May 17, 2019 at 5:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sun, Apr 21, 2019 at 11:52:55AM +0300, Gilad Ben-Yossef wrote:
> > > > On Thu, Apr 18, 2019 at 4:39 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > > > >
> > > > > A set of new features, mostly support for CryptoCell 713
> > > > > features including protected keys, security disable mode and
> > > > > new HW revision indetification interface alongside many bug fixes.
> > > >
> > > > FYI,
> > > >
> > > > A port of those patches from this patch series which have been marked
> > > > for stable is available at
> > > > https://github.com/gby/linux/tree/4.19-ccree
> > >
> > > Hm, all I seem to need are 2 patches that failed to apply.  Can you just
> > > provide backports for them?
> >
> > Sure, I'll send them early next week.
> 
> hm...  I've just fetched the latest from
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git,
> rebased that branch against the linux-4.19.y branch and it all went
> smooth.
> 
> What am I'm missing? is there some other tree I should be doing this on?

I do not know, can you just send the 2 patches that I said failed for
me?  Those are the only ones that I need here.

I can't use random github trees, sorry, let's stick to email for patches
please.

thanks,

greg k-h
