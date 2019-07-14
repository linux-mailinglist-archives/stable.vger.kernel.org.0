Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFCBB67F95
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfGNPJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 11:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbfGNPJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 11:09:34 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F2B92063F;
        Sun, 14 Jul 2019 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563116973;
        bh=bm9pEoqApX+qfkcBW1EqbTeake3cpyojbVnypkCIZzs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0eRUwZBYgVu2OLCbOTDh1MKwciFyHBtd8VCxW9LyL5hX9zdTvY4irReOkutgYDqGN
         jx2VGZACcSHrdEXXR4stGZTF2JkMoo4ULRTqQa9nxifkdWViBF3u77WAFTD3AkW4vC
         +94C+s3kNUg7ipIqG68DRzw76ooNnXv7Lv3nHex4=
Date:   Sun, 14 Jul 2019 16:09:08 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Wolfram Sang <wsa@the-dreams.de>
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, stable <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: gyroadc: fix uninitialized return code
Message-ID: <20190714160908.7443eca6@archlinux>
In-Reply-To: <20190704195557.GA1338@kunai>
References: <20190704113800.3299636-1-arnd@arndb.de>
        <20190704120756.GA1582@kunai>
        <CAMuHMdXDN60WWFerok1h05COdNNPZTMDCgKXejmQZMj9B6y5Cw@mail.gmail.com>
        <fc3b8b4e-fe0e-9573-124d-4b41efa409e4@gmail.com>
        <20190704195557.GA1338@kunai>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 4 Jul 2019 21:55:58 +0200
Wolfram Sang <wsa@the-dreams.de> wrote:

> > >> This is correct but missing that the above 'return ret' is broken, too.
> > >> ret is initialized but 0 in that case.  
> > > 
> > > Nice catch! Oh well, given enough eyeballs, ...  
> > 
> > I don't think ret is initialized, reg is, not ret .  
> 
> It is initialized for the broken 'return ret' *above* the one which gets
> rightfully fixed in this patch.
> 

Agreed, 2 broken cases and this is only fixing the second one.
I'm expecting a v2 of this patch which fixes them both, so 
won't apply this v1.

Thanks,

Jonathan
