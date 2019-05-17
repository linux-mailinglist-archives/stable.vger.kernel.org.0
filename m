Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5155021A0F
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfEQOwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 10:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728968AbfEQOwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 10:52:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B7762168B;
        Fri, 17 May 2019 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558104757;
        bh=GWPQahVBLc9oCB8wTxBcTd3TyO8Alw8wwia+iCLmYwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XzPSRxhuJeAU0NHHV0zUbVzWRB26FRuJ/3AltD4zUgMHCwRuVLwCoWXsvnh/f1M/o
         zor7FnbIyNhmgAh76jLylIBoBb9qObAWRu4IZRSyEVun2kZ4aIagQw1TQQ6FAUkjC5
         deQwi1Z9KDUB+G5K/cvajvAYivqjJKJjCFCC0Jv4=
Date:   Fri, 17 May 2019 16:52:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/35] crypto: ccree: features and bug fixes for 5.2
Message-ID: <20190517145235.GB10613@kroah.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
 <CAOtvUMd9WUZAFgTqVH0U2ZZp8bbHXNg9Ae_ZFvGKJTSKNct8JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMd9WUZAFgTqVH0U2ZZp8bbHXNg9Ae_ZFvGKJTSKNct8JA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 21, 2019 at 11:52:55AM +0300, Gilad Ben-Yossef wrote:
> On Thu, Apr 18, 2019 at 4:39 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> >
> > A set of new features, mostly support for CryptoCell 713
> > features including protected keys, security disable mode and
> > new HW revision indetification interface alongside many bug fixes.
> 
> FYI,
> 
> A port of those patches from this patch series which have been marked
> for stable is available at
> https://github.com/gby/linux/tree/4.19-ccree

Hm, all I seem to need are 2 patches that failed to apply.  Can you just
provide backports for them?

thanks,

greg k-h
