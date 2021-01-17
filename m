Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B632F915A
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 09:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbhAQI1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 03:27:40 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59251 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728275AbhAQIXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 03:23:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6F0955C00AF;
        Sun, 17 Jan 2021 03:21:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 03:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=um908HLo7wPHXQgSbFewgHnuX8N
        EdhBtMa6sKQ9VEok=; b=nPldcQmzgWdUOj8S5j1x6BZW1iC0TpSP0+lU+wlhZyF
        xudX+Ndxz0B/ftPnTrSX16d4jZMc+2gGc8qsAhIbUYRj5sLud/S5xTYqoeBh1Pw/
        lKu6WpjBJowqogjQSvWeF5Vu7aNdXEH1FTB9JPPaEZlXE9IOHdwH0JqxoRXzrV4u
        L6arsxZMoT8Y3x6SRu89HCiZPl7ylp3hFaSLqQ/5R1UyfHt6XSW5gVm847jSRLgm
        +BhhMhS56XapAM/6YE7jjLL+pteFxGYdycqiZG/jSn+hAtff123+Fq127JLgS+hs
        MBBuVEyOgtMm1jWrxbEskNK+1NDG/LXf3p+3AZySzAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=um908H
        Lo7wPHXQgSbFewgHnuX8NEdhBtMa6sKQ9VEok=; b=OzhbZFKoPMDptvftYUubyv
        IALq8AvaCz8gH1xeIB8viLfkgScgnsZgM934tVzA9E4wvJJ+g8TpZODbm8KkEtYg
        BG+DZr4IGq/Ebr5JgYTU8b3OWEe1KHPB8YVwkARYacczSddU6mMtP8A5twOAEKzv
        BVQqzlOkpwdWbwy/ya4TpsFrhPelTGZnmukOynuA51OkKXXhXsgEX3zgkxV18PLd
        w0j42mjcNri8LEZHVUqIs4DSWivQr/L0el+uHmyBxs/6JFZJ4S+Eg9PjfTWmBTCt
        5fXDk905TzI4LpG3WbCVMPHvJubqqrnIDcnAdAuOcXo68z7Auds4p6PW/ZXgh0Gw
        ==
X-ME-Sender: <xms:nfMDYMaAVjXzcaALAF2SciUlMkXRYVVSyVJIfZAdwDQbg7n60ZZ_qQ>
    <xme:nfMDYHbUBCAUYS6Hna5GmbJ4a7u70kDGAJrJYjNpatC4htEz9lgJWlt0d0udNOjtT
    Wv08gsDwmoK1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdehgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefhvdfhle
    dvvedtfeevkeffhfefhfekgfeghefhveejleevveefhfefgedvveegteenucffohhmrghi
    nhepuggvsghirghnrdhorhhgpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrje
    egrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:nfMDYG_SGCHg2N9-f8AzDV3MBiHiDDDaVd-rBI-Nj35MWpb30skORw>
    <xmx:nfMDYGq_2Olwm9SjgxR5FGpCrG5crJ8kX1GmOA2s0KT4VQ-GQlrBWA>
    <xmx:nfMDYHqAPusJyHpJ1E03uUuLfyJlnJ_UUxoSxDBnHrgKX2Wb3KcnrQ>
    <xmx:nvMDYIejHX2XuWo0pKSGs_n1clx6yo6Vvi0YGFhObCwaQ2Pdjx8hFQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59A401080057;
        Sun, 17 Jan 2021 03:21:49 -0500 (EST)
Date:   Sun, 17 Jan 2021 09:21:46 +0100
From:   Greg KH <greg@kroah.com>
To:     menglong8.dong@gmail.com
Cc:     2225233704@qq.com, Menglong Dong <dong.menglong@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Wise <pabs3@bonedaddy.net>, Jakub Wilk <jwilk@jwilk.net>,
        Neil Horman <nhorman@tuxdriver.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] coredump: fix core_pattern parse error
Message-ID: <YAPzmuGEKw/iRIvF@kroah.com>
References: <20210117045228.118959-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210117045228.118959-1-dong.menglong@zte.com.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 17, 2021 at 12:52:28PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> 'format_corename()' will splite 'core_pattern' on spaces when it is in
> pipe mode, and take helper_argv[0] as the path to usermode executable.
> It works fine in most cases.
> 
> However, if there is a space between '|' and '/file/path', such as
> '| /usr/lib/systemd/systemd-coredump %P %u %g', then helper_argv[0] will
> be parsed as '', and users will get a 'Core dump to | disabled'.
> 
> It is not friendly to users, as the pattern above was valid previously.
> Fix this by ignoring the spaces between '|' and '/file/path'.
> 
> Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Wise <pabs3@bonedaddy.net>
> Cc: Jakub Wilk <jwilk@jwilk.net> [https://bugs.debian.org/924398]
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: <stable@vger.kernel.org>
> Link: https://lkml.kernel.org/r/5fb62870.1c69fb81.8ef5d.af76@mx.google.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  fs/coredump.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

What is the git commit id of this, and what stable trees do you want it
merged to?
