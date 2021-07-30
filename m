Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DE53DB758
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbhG3KqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 06:46:01 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49051 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238395AbhG3KqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 06:46:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 031443200941;
        Fri, 30 Jul 2021 06:45:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 30 Jul 2021 06:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3Ryv1JmOe1JkjEOUvtOGERn7k97
        vo8ZTRSlnzLdjKbA=; b=Yi/XeteNq/glhHLodGtfAGRyAilW/mRkYpJNcQVBv75
        DzywqWGL1vGHrB1QFKIWli1EPSvE8TuwbKfCExvXH66H+POFzDBYFVsn8OZjizsD
        cNlZc6SnXPJ7C5RzSQ+yf8lVFMkTrPD9KEz/WOcgROfZmgBC2OM840GX4aVYBanv
        gZYZYGsepaZ6mBcqCPooXjAByIOcnJm3GCyz8kXuPbKIR3olZFTQSfcPXE5EBXI/
        qJqCvaz2qSwq3Gs9q1T8xml2UXePRTSWQMbMj37P5AnOlzr+tNtjw+h6GHugIV/7
        wlIA3GWUtHK6/D7hJxa7lT5kl7PM6tqTO3nREcYftxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3Ryv1J
        mOe1JkjEOUvtOGERn7k97vo8ZTRSlnzLdjKbA=; b=s27cdZcLQI7TTpg77cbUUI
        H35LueB4/X1UXqFAK+4IGQESIr47f/T6aKLHB0e4NEfw3qu6VXF58bZew+pigw4U
        3pxbCRezLfw8Gq5v4FaVZwHETr+1LTQ9qCVTNNX7/dOrPKcAeO0iuDFEibIUB0Rj
        PGo4nJLZupsXUa8ESqGq9Z48Aww6vZ+xQlz9bFgAaE+Nio+ZjWOawmWxcGnZWRnx
        7PU5LLNr98TMfnQ4wnK8hZdR605TV9G//AGRc+yIQAqmQ5VB8yAOlcppE+ouGV3M
        R8Th3iQEBt4PsW987ZCaLjcRE+MIKeSFuwXhMljNrRPL5rMELoo6Doo30QFMqvag
        ==
X-ME-Sender: <xms:Y9gDYSOu63WpmJyB7oQrjZYrsaeIczax6tHRd4U93WVztlP-NJd4DA>
    <xme:Y9gDYQ-zBh5dzFbNqeggzUuYbRdI6NJ90MVskvickH9GaZfvQYrCtsOYhp0njVmmk
    JnvdIiW7WtNdA>
X-ME-Received: <xmr:Y9gDYZQP7thxJsx41PJjiT0J-xJIgOXIiZtZsgGEA21W74EiyU5YdciVkss6s8qHgSfLJZYgrRLoJflR7jSuyCfXFI7XLRac>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheehgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Y9gDYSsGrzi2ohcbEWXS6z84t56SHYcSLPlMCkLZWoX9UC2ZsYRqPQ>
    <xmx:Y9gDYacG-JcQLduxQWUpIgAHL_rPaJ0N2cwpPXnEdf1hDVuJHOd6rw>
    <xmx:Y9gDYW17b_8jIb1Tpp2o0SbXYdzs6I4nWiSd_4hAvrlBO7PYfu0beQ>
    <xmx:Y9gDYZ6qm5IoSde4iwAT3MNLbxTLH-pS-AcyiFY03jx-oyvZS5aM7w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Jul 2021 06:45:54 -0400 (EDT)
Date:   Fri, 30 Jul 2021 12:45:52 +0200
From:   Greg KH <greg@kroah.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 4.19 0/2] Backport fixes for 3226b158e67c
Message-ID: <YQPYYCIbKhpCL9Vp@kroah.com>
References: <20210729184427.3202526-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729184427.3202526-1-matthieu.baerts@tessares.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 08:44:25PM +0200, Matthieu Baerts wrote:
> Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
> introduces a ~10% performance drop when using virtio-net drivers.
> 
> This commit has been backported to v4.19 in commit 669c0b5782fb and this
> performance drop is also visible there.
> Here at Tessares, we can also notice this drop with the MPTCP fork [1]
> on top of the v4.19 kernel.
> 
> Eric Dumazet already fixed this issue a few months ago, see
> commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head").
> 
> Unfortunately, this patch has not been backported to < v5.4 because it
> caused issues [2]. Indeed, after having backported it, the kernel failed
> to compile because one commit was missing, see
> commit 503d539a6e41 ("virtio_net: Add XDP meta data support"). However,
> this missing commit has been added in 4.19.186 but probably because
> there were still some opened discussions [3] around
> commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head"),
> the latter has not been backported at all in v4.19.
> 
> A cherry-pick of this patch without any modification is proposed here.
> It has been validated: it fixes the original issue on v4.19 as well.
> 
> Please note that there is also a fix for the fix, see
> commit 38ec4944b593 ("gro: ensure frag0 meets IP header alignment").
> 
> This second fix has also not been backported because it caused issues as
> well [4]. Here, it was due to a conflict but also a compilation error
> when the conflict has been resolved. Please refer to patch 2/2 for more
> details.
> 
> One last note: these two patches have also been backported and validated
> on a v4.14 release. A second series is going to be sent.
> It looks like it could be interesting to backport these two patches to
> v4.9 and v4.4 as well but unfortunately, the backport of these two
> patches fails with conflicts and I don't have any setup to validate the
> performance drop and fix with v4.9 and v4.4 kernels.

Both sets of series now queued up, thanks!

greg k-h
