Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F61D328068
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhCAOMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:12:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32825 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236248AbhCAOLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 09:11:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1148D5C0115;
        Mon,  1 Mar 2021 09:10:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 09:10:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=N/A24Db+F1Q1cnAfdMcKK1KV5/z
        /iTsywaDJViMqvGs=; b=JrH+u/rX5F57P/tMlufihZR4mWm3UsEP3zW7M6ZXq2n
        ckpixXa2rdeV3Dx0koNGGSdfXf37YVyItTEBNojT7jExOkQei6HpuRru2R47UK4m
        Rpfeaby5VJC5NV+uXtj5jm1pgd2d27SSiTNcmcIePDWvutPAgTbRn5hoqPYasX7g
        9kCJZ2yZxgni7wq1cQEinatfmuFrjePL+lRrGDEFeXyrLX4EjGdzLH3xU7gsgdw0
        /Vd2y9A0vxQ3mx8eV4dCz5pfAQ4VBculMYeagXx5+QHLEClJeGYHh89accXvxr4E
        c4TYch1TXgQzUSghvsxcObnrTVrATyS5T4gc35Vffaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=N/A24D
        b+F1Q1cnAfdMcKK1KV5/z/iTsywaDJViMqvGs=; b=ouYFzZE2+NWgbRN13WOTUN
        zFDZQoNZuHkkv/pqBu81p0z8YO+MNpPVhjfcJ1xKjBM4FCp3oKk2AuoXVSx/CM3h
        3h67tyOffDvysAfnUFmESsfIGZ7Se8GOKAEFlERBtNfFFV4RXs8SI3NseqOH1/HK
        lYUxYx2jAhtz8hyDGeNEoCebB8U84gt4BTAyS9Tvwyoxp3m7SFOiqIr3d514OzFA
        p2Ydix/PML8bY5ylMMSNItGED9xVYVIwxNEJ3RUK/2WjNmfsMb/r5JW4JXNkw5Lm
        LIwE/XCYfB3vwAIVgWwjfz9qf7EaQqbpgpi2zpHok/G5D7jIlT9WNAASZiv8Nb2Q
        ==
X-ME-Sender: <xms:8fU8YGwMW_NPx7Clsr3bTfvKLnupVkgdwnnU94ZQoIQmwkXWWwNuZQ>
    <xme:8fU8YCRuc87sjaue7Ve_iO4AJEfkM9tvXHA0zLEalQ1NJ7vaj3NbLgHojzWqH73S8
    -IStaF1b-cXZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepleeltdelve
    duudefgfehleffhfevteevieeghfffudeuueegffevkeejgfdtveeunecuffhomhgrihhn
    pehlkhhmlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:8fU8YIWVqlToYlxqz_x4UvuUG9yIgyUvMJgSZEzy0JnTwJi2dm1x5A>
    <xmx:8fU8YMiTdsDEekE1zPWg03hOGVwa5VjHrwb3TuPdJcB9KBTg_o1TwA>
    <xmx:8fU8YIBg5mMWiEVgdKB4TCJgIhtO3o_g_I_EaPwZ7uEWw0whrElh0Q>
    <xmx:8vU8YB5QUSQtc_Vm1toVXEii_6J4XdWnjnCgQIiIdoMxWfh58H1nqw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E5F5240064;
        Mon,  1 Mar 2021 09:10:57 -0500 (EST)
Date:   Mon, 1 Mar 2021 15:10:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     stable <stable@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: Request to backport commit: d54ce6158e35 ("kgdb: fix to kill
 breakpoints on initmem after boot")
Message-ID: <YDz176xKljIfx6oZ@kroah.com>
References: <CAFA6WYMVsmjy5KMYwFcnXuuPJsNBcEY_DCV+wF0bA_umg-Ri3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYMVsmjy5KMYwFcnXuuPJsNBcEY_DCV+wF0bA_umg-Ri3A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 09:47:15AM +0530, Sumit Garg wrote:
> Hi,
> 
> Please help ot backport commit: d54ce6158e35 ("kgdb: fix to kill
> breakpoints on initmem after boot") to stable kernels. Below are
> comments from kgdb/kdb maintainer in this thread [1]:
> 
> "BTW this is not Cc:ed to stable and I do wonder if it crosses the
> threshold to be considered a fix rather than a feature. Normally I
> consider adding safety rails for kgdb to be a new feature but, in this
> case, the problem would easily ensnare an inexperienced developer who is
> doing nothing more than debugging their own driver (assuming they
> correctly marked their probe function as .init) so I think this weighs
> in favour of being a fix."
> 
> [1] https://lkml.org/lkml/2021/2/25/516

Now queued up to the 5.10 and 5.11 stable trees, thanks.

greg k-h
