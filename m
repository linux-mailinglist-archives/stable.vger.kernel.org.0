Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629A3498375
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbiAXPXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:23:20 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47537 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235210AbiAXPXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:23:19 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F8A35C0032;
        Mon, 24 Jan 2022 10:23:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 24 Jan 2022 10:23:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=5tVOxchoRlJQ9oVa38o8Q0ocBQpIb1lhZlmRVk
        exNP8=; b=CZtc6KQZabbwZn/VW2434m5/7jiDuK//V0ezoerup89k9a6Wdb0FcS
        qfQmjQseL5IxZwEwjgm52VoyxVDnXJO9YfyeUVUJQB7LyXHJvvIDPqhoNnwg05OW
        MHAXqWfJ7PW2muicmGzJ7xgaf9aOZ7Mvq70AnbtuHt+BHIN/49Ho501nHfz9OQWS
        H80mllMjpTwCG15mD9YAVKN2m05W2noPnnA2hmr69vJYXlBbbmIbvCscSbLiqmw+
        ygd1aJnFJ5DxE6xXKSsow4wogglHA5zsE4JhHFC+aWDd/pNOi/asBaHPGFL+2OdF
        Kds9d8BxJh3J0FS6DPXiEvX3q0L1EyAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5tVOxchoRlJQ9oVa3
        8o8Q0ocBQpIb1lhZlmRVkexNP8=; b=niMk8bEYw4a+qtmzbOWDsL5RaYRSlY7H6
        aaThzeIOWUFMN8eQwFuRJkFfd2/iQUzPP1GAoxDrODqhiBUFy1nNH34EbeIuNrue
        PosZG6J28p9wO8jiVGnuZxnsRvZOp2GAdNQmW+gdGoTIeA9W0bMPVbMypE8VUTlJ
        o1A6iToqMqxxFXz2H9xYTDio8q/K5vSnEby9F2CI9sWol4F4UZCCMI36GcbOqLue
        UlOuDuW3brIv5Wc2Jw3oseGupHEZC9A6/FQkl4sGQ79SmK+h9fcOgnZdhy/zF0wW
        de1GVVVQ+dz1ks1XaM4vXZ56nXXUCVkmyWbdwL20Z00o6pl7Qn+sA==
X-ME-Sender: <xms:Z8TuYeW-wnoT8XlEbkjSege-_ft6vRO5eDrObhxaouNLhFLdiCANFw>
    <xme:Z8TuYakhfxV-vzv-_IgP4rgxgqjJLouMwmWfPKDApbGt2PyE-PdFHL4CyNd8DNc6T
    t_s-B8qpgoq3A>
X-ME-Received: <xmr:Z8TuYSaDi-wea9WFnWS8TllP_o6aymfGT4kxakYGqwcSrLBlYYwSs2u_FraCgzudIZgdw7o_K5N_X5rM0dnfpbHTQoujxUkF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvdeigdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Z8TuYVVnJi_sx-AjbtHA-FDFpRxT_RrAQ3tNd7Xxkm2sCUg5kpfX8w>
    <xmx:Z8TuYYkh0MiDUwHGqTdkL8Kg0mnDXtU8uAsMcpUqXqtUnh67O6TNrw>
    <xmx:Z8TuYaf58bfmQTmiSFYgHHx4ljkVTTAy3nZ8fWf1z_vZhSYCjh3IdA>
    <xmx:Z8TuYZBplXmBaXXCArL2AFrxCdGn4nVSPQuo9uvwUbhaiQofIzC60g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Jan 2022 10:23:18 -0500 (EST)
Date:   Mon, 24 Jan 2022 16:23:17 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 4.14,4.19] mips,s390,sh,sparc: gup: Work around the "COW
 can break either way" issue
Message-ID: <Ye7EZaQh/nYk4Oz+@kroah.com>
References: <Ye7BluXgj+5i9VUb@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7BluXgj+5i9VUb@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 04:11:18PM +0100, Ben Hutchings wrote:
> In Linux 4.14 and 4.19 these architectures still have their own
> implementations of get_user_pages_fast().  These also need to force
> the write flag on when taking the fast path.
> 
> Fixes: 407faed92b4a ("gup: document and work around "COW can break either way" issue")
> Fixes: 5e24029791e8 ("gup: document and work around "COW can break either way" issue")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/mips/mm/gup.c  | 9 ++++++++-
>  arch/s390/mm/gup.c  | 9 ++++++++-
>  arch/sh/mm/gup.c    | 9 ++++++++-
>  arch/sparc/mm/gup.c | 9 ++++++++-
>  4 files changed, 32 insertions(+), 4 deletions(-)

Thanks, now queued up.

greg k-h
