Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FA13A5EB3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 10:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhFNJAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 05:00:42 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41299 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232631AbhFNJAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 05:00:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 408A717A0;
        Mon, 14 Jun 2021 04:58:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 14 Jun 2021 04:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=eqzRPk4PvzfI3jSWAnTs+ZLAV4Z
        owzUtaUgohfDWldA=; b=tkzREJpAcBZ8CgEcvbPC3MeUuOMIbSUvArjj9qPre8y
        qzOxugq6rsSHozK+d7SUGOKNAaBbR/PEOvnKVB8PBXt5lhgvxLf53LBWKm1vsfgi
        pgvRH3n4Yfs+8xVPoX/vhhpMMR5oF7zddBv8ohGRZsOwjd15pMSO35VQ0p2AgQJM
        4aH/HWiZq6u641Q7dgh+CsXiTgEbZiHeyaXVVYNTaNKgMKYax+LWigWrWR2Iccml
        IIY6ui11ET/PIWAQjqKhW/mU0w9MqxA69defQvfdLmzLIf4ibcTrGiEZlnQ0zhav
        oyxH0ofzwS/WJXu+QbBCLg0eYFV6hiuo+N5JZOIGrlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eqzRPk
        4PvzfI3jSWAnTs+ZLAV4ZowzUtaUgohfDWldA=; b=NXK87kxUNrFEarBcyCxw+G
        iV2cR1GmYcT7OHOybvJtpPhD+XvZjahek97LaXGU8/C7GgAi+AXfjS7MOz+nwEZp
        xal0kTd4kl4/yPXbrP1fQ9zfXkSF6cuGzVbSWMd9sj6ci6RDpPaisCtgTSHkUSe/
        Ij3smn1cflDFY7hiG65z5fKcwUV408n3snNVSlyA/LOyw0ox/X+MoF9RKXhFPMn6
        n2n7VQiuHD/S9gsloKFAsPSOLgPQLaXdeu2NDM/jNR02PqZNknrxijkoX1/X+wXI
        Ba3McA4kf+AhG2XQLpSgdR9j8i3cibaBkBuBR8+7DgBzNBsy0lGaSP/mn+3PH2sg
        ==
X-ME-Sender: <xms:PBrHYJXKHlIlECwO3yPAjmgvX1kNahp2JPZ1vXdgQVqQKzh2uia1Hw>
    <xme:PBrHYJk7cOAwqpnKRbwj0L5Oi24zx9q9qqude-0D8gDQLD6u4qYwz8Iuoyde-MIKR
    L_FpeoVwyESyA>
X-ME-Received: <xmr:PBrHYFYuwftYjWuVQX6BbdFM6N3sUAPTrxVo_xN9I6YXoDbl6v39lzPnyk7qx4D0-o6Tkl-H6iCMxum8pl6NZ1qJcOj7HIbx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvhedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:PBrHYMVqDVHzNGBrfS2pxLrSW-8AhYu_Ceh50PXNQplk6fvbU33I1g>
    <xmx:PBrHYDk4gxD5HupBDbv5_D2685wKPFjoIqU2YoDmcPluOzDU48hQ_g>
    <xmx:PBrHYJfC1K-KSaf5szxTu2qObT3B_DTYT40hihkJbiwnpEnLURQz2w>
    <xmx:PBrHYBb_V25pm2YuKkNWze_v3XKrjg-T9q5VKSH3zUOu4Y_6yvxSNQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Jun 2021 04:58:36 -0400 (EDT)
Date:   Mon, 14 Jun 2021 10:58:33 +0200
From:   Greg KH <greg@kroah.com>
To:     Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN()
 in find_asymmetric_key()
Message-ID: <YMcaOXsMvkWhb5mg@kroah.com>
References: <20210525113628.2682248-1-andrew.zaborowski@intel.com>
 <YKzlTR1AzUigShtZ@kroah.com>
 <CAOq732LR9Wf44qiGESH4YCjkwkDezjiTfRz2G3y9G596HgYAHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOq732LR9Wf44qiGESH4YCjkwkDezjiTfRz2G3y9G596HgYAHg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 10:54:00AM +0200, Andrew Zaborowski wrote:
> Hi Greg,
> 
> On Tue, 25 May 2021 at 13:53, Greg KH <greg@kroah.com> wrote:
> > On Tue, May 25, 2021 at 01:36:27PM +0200, Andrew Zaborowski wrote:
> > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > >
> > > BUG_ON() should not be used in the kernel code, unless there are
> > > exceptional reasons to do so. Replace BUG_ON() with WARN() and
> > > return.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: b3811d36a3e7 ("KEYS: checking the input id parameters before finding asymmetric key")
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > ---
> > > No changes from original submission by Jarkko.
> > >
> > >  crypto/asymmetric_keys/asymmetric_type.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> > > index ad8af3d70ac..a00bed3e04d 100644
> > > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > > @@ -54,7 +54,10 @@ struct key *find_asymmetric_key(struct key *keyring,
> > >       char *req, *p;
> > >       int len;
> > >
> > > -     BUG_ON(!id_0 && !id_1);
> > > +     if (!id_0 && !id_1) {
> > > +             WARN(1, "All ID's are NULL\n");
> >
> > You still just rebooted a machine (panic-on-warn is commonly set).
> >
> > Please just handle this properly, print an error message with dev_err()
> > or pr_err() and move on, don't crash things.
> 
> Like Eric Biggers said, a panic is probably what you want here since
> this would be a basic bug, if you even want to check this.

Ok, then keep the BUG_ON(), no change needed.

> You can't
> be looking for a key if you don't have any of the identifiers.  There
> a 4 current callers, 2 that have checks right before the call and 2
> where this could be triggered by a bug in an ASN.1 parser or
> corruption.
> 
> What's the right way to get this change merged?  There's clearly no
> need to coordinate with whoever would merge 2/2 of the series.

Why do you need to change this if BUG_ON() is the correct thing to do
here?

thanks,

greg k-h
