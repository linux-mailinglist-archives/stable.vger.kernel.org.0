Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CCA2E7A7F
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgL3Plk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:41:40 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41133 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726533AbgL3Plk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 10:41:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DDA835C0050;
        Wed, 30 Dec 2020 10:40:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 30 Dec 2020 10:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TUh6I4m1JvbyJsLFtp/BvpmkKzt
        UH2S21H/iXrSq0fM=; b=fC2b8kuGxkYN25j38l4T1hM7YfsaWsYYnMdSd3YzAxh
        E+oK9iXfq7gSmAr0jUL9mXRC7ifw/CTSpgvS4ezzfuXC8B0W2kie/oF+Zpz5j2LC
        8fPuWEKibQWRTGIDU8FCJwbZa3erXonHicXVqU87mn3t3powtNWag+OG4KH7CmaS
        1Agl2p/ncBC7u4zOmvTsbse6j3vjaNSZpoOQf1txMc/az9zZGvIvpwmMPeef3ygz
        6mSa2pdf4cvAMMiLjwtH4SMZnsIj0GA0AUWL8qFaXKMRWLlE8cNVImC/iJC/j9S+
        Ht6Ed2l+m2mlxx7lHzcLA2oyin7xwkSFblLYPviypAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TUh6I4
        m1JvbyJsLFtp/BvpmkKztUH2S21H/iXrSq0fM=; b=HDUL2fOmiQDsI4ICwphH0r
        DuJBTY23LWvMzlF5ovC+UXhajqxYu4Z2FrS3t0BPOCa+/6FcUX3T8zZdFdoknMZ6
        ZeY0HRMsHAnYVbOCIhs/DrisKleu7Jg4jVilcgYYDs5IwevNLCXgzg6MgXfQV3aY
        OFRn4nmiYav9USHAn6yYl9uv5IRHl+QqY1WHUXi4urzVodcBYJ87hp7AZPm41ZvD
        rZOpA2tVKSX3tnSqrYsrm2SvLOHzvQssJGokWyUP3jpm+LYLRJxG7vmc6N086c5u
        r2FFwLYGC5ZnR2N5e4XeLE5eFZ4XBapQd7Qs6LBkW7NW5bEPPKDdTrJNteJbhTwA
        ==
X-ME-Sender: <xms:hZ_sXwHJUNPS0i4kHsH_QK8k8dgXc3pLL1vaMxUXpp2s82YD9luk_w>
    <xme:hZ_sX5WX3gDMQll5DiZPlFwVNLWpqS7IMzzU9uXKxQ_JFchrNjAzqFc_KkvN1QKm1
    NonB2jU2s3ALw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:hZ_sX6LAskXaoKj4_vWCT_zBHoHsqIVU9VuHXVjL3p8DruujsfiIEA>
    <xmx:hZ_sXyH9aJw6NwnByZ266ILSTOuNylj6hEioPI-tJ_M__RuydFP9zQ>
    <xmx:hZ_sX2UxzyBJ03q7cqxEpEqYIHQhZLCIAPWhepxWG-T4GIS2R-kXuA>
    <xmx:hZ_sX1SfwLxtUsOueKFlLfxpnBexUpfVVeCxIrRkMMn5OSmMOaD37Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF6AE24005B;
        Wed, 30 Dec 2020 10:40:52 -0500 (EST)
Date:   Wed, 30 Dec 2020 16:42:15 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 4.19 0/4] fscrypt: prevent creating duplicate encrypted
 filenames
Message-ID: <X+yf12YbaUciBwwf@kroah.com>
References: <20201228191211.138300-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228191211.138300-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 11:12:07AM -0800, Eric Biggers wrote:
> Backport four commits from v5.11-rc1.  I resolved conflicts in the first
> two.
> 
> Eric Biggers (4):
>   fscrypt: add fscrypt_is_nokey_name()
>   ext4: prevent creating duplicate encrypted filenames
>   f2fs: prevent creating duplicate encrypted filenames
>   ubifs: prevent creating duplicate encrypted filenames
> 
>  fs/crypto/hooks.c               | 10 +++++-----
>  fs/ext4/namei.c                 |  3 +++
>  fs/f2fs/f2fs.h                  |  2 ++
>  fs/ubifs/dir.c                  | 17 +++++++++++++----
>  include/linux/fscrypt_notsupp.h |  5 +++++
>  include/linux/fscrypt_supp.h    | 29 +++++++++++++++++++++++++++++
>  6 files changed, 57 insertions(+), 9 deletions(-)
> 
> -- 
> 2.29.2
> 

All now queued up, thanks.

greg k-h
