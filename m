Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9287370B3A
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 13:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhEBLIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 07:08:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59025 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229676AbhEBLIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 May 2021 07:08:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B052C5C0139;
        Sun,  2 May 2021 07:07:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 02 May 2021 07:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=WskG/OD6iDGM3tGuVuHnDVnPhSz
        HnoKfmrpeNdwCzlA=; b=dwspbK951drYhLhUPzplAdCyEBbw/GjYinHyKIT6OEO
        FmsNpqdMJx4lttBPW3pbouapYLxhcqQ1sHhmlr+chEje+bVmeS3vHqRl8iao0ZSE
        E6/S8+YyA/SZUQrpsTRtoY4OJATRTgjQI8QbL+UBrTuYxzMVX4aw9b4Z3r+e+HU2
        K28x0a5Q0cQczPNMCboF4hkvnpvPN0QNncnQgwGvA1lc5SBUK53BrfcVw0VyQ5Vg
        JEspFrODZwCOD0MDvWr9QsdzhZJCjKoelQhU3/fnSirDZoa3si4lMEjtEu1Qyi99
        lDjpu/r383BUBhJI3q+jQv9frM9A2/2cFwN7wDxpolw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WskG/O
        D6iDGM3tGuVuHnDVnPhSzHnoKfmrpeNdwCzlA=; b=fB1ZpLARnxb0q/3EAa72MK
        e4L0/boZieVzFshTlotI9tRq6JJ1ABBvBRRnftZ8qgjeAsn+qVjzTPbK79IVI2RZ
        9k17ZK3SF6mYkeEVeKJPfzeDY7obwPxAa9DPW9Afny3ztxYbard26ViPC5HG712c
        m7X947YKTZYbY8PA+/OCmW7l6ZWssuEKR5jxhKEvlg4Fu88NiW4C8esE2X8nqFdJ
        gSL+kcr2VmFUdxlYCqEhsummyS3kCwl84FoOSK64ondvOxPnAJLGp/jgOmE7hILi
        RfaxinGqlvTfjqFNjnuG0x2EZtip2GlyYUloxUkPhwH6rzaXtiCB+frBj9l3W7ww
        ==
X-ME-Sender: <xms:BIiOYGHBEVGUOYBB8zfVUfY34Bu-f9PCRdb4Ed7HGwxgjKCPQkEIYw>
    <xme:BIiOYHWYriO28C0TcmL3WK6_ZgwzQaT-m_n7of50i9SQMpX1qOpDc1ZGbe264AJzv
    XekZtqIbqKOiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefuddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:BIiOYAJgjAct-T6L1dKCbOqiUwiRo-je9b5iGs1QF9vxy62lH5cfSg>
    <xmx:BIiOYAEZwtdKj8YJREZ8zjmSWtDg28k3aDvebWFZ3OPcg6Jnua3GCg>
    <xmx:BIiOYMVPS2cfwVaBzkCbjbiWDcGz3m4hDWODxtbgSmNEL1f4NrKjDQ>
    <xmx:BIiOYGcKR6ragtr6ToVnryfomHEnBczOZntaorCxS_mX5EnhsRW-Wg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 07:07:48 -0400 (EDT)
Date:   Sun, 2 May 2021 13:07:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org, samjonas@amazon.com
Subject: Re: [PATCH 4.14 0/2] fix BPF backports
Message-ID: <YI6IAifGT+uieF+g@kroah.com>
References: <20210501180506.19154-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210501180506.19154-1-fllinden@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 01, 2021 at 06:05:04PM +0000, Frank van der Linden wrote:
> These are the first two patches in https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/
> 
> I will re-send the rest of that series as soon as the other bpf backports
> hit the 4.19 branch.
> 
> This fixes errors in earlier bpf 4.14 backports. The verifier fix was
> sent in earlier to bpf@ by Sam, and acked. I added the selftests
> fix.

Both of these here now queued up, thanks.

greg k-h
