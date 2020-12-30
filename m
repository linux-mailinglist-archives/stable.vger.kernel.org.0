Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174552E7A63
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgL3PgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:36:16 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54061 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725853AbgL3PgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 10:36:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 930D45C0125;
        Wed, 30 Dec 2020 10:35:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 30 Dec 2020 10:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=VDxH+2SxwyzX+PKZoRXB2IBcX97
        d4RhjBs6yzJZFgQk=; b=PLf5n8j1aZ3AxFR4pH7/houJu+8zJrcIsGqs4RYol++
        c9yTH6Vvi8P6lnQ+1jegU0yMdTfjbTxjaE09BKR/EBNu2DNvP0jAuo6AFFk1Z7qz
        Qmz17W1jGJXWkeqB/0Qx+8MOoE8munyYSWblGzGFmkATZqEm7cWBTSOF7LDUmDlP
        s+1/geOXuUwBUQyW8BqrorirgxMXjeQ7DRIWZFH5IDIcy1SIne/J1gIjjtD0e28E
        NqhxQLa4mC3JNURcFy8fbHBwiiYkMTphR61fUtR9tipHVt4/iapNhUfPLbEeF/JM
        tbp2Vncwho4Pm110jGnUUkHO8OH+1l9xgkjIpvPUbuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VDxH+2
        SxwyzX+PKZoRXB2IBcX97d4RhjBs6yzJZFgQk=; b=WtvpN4zG3ONS7xxGrA3DIX
        /K66gZ8uP3QoW7///lwT+K65IIl+HPfIRESAV3DsE69ETpjYyHeT8aRCz3VDwoYq
        XcCQQF6xOLtZFoqGuwCmgBhnRuSyFhbgE7ZEzWSAU6n5guFVcXMU6ED8Geb3Y0X1
        hkOOHU5ivXdSdqG/7EI2p5C1VUGQ4ULG0CpUlYxHn8V0ifIvR3ihktz78YMsSUqo
        +WvmMSO1weSJJAXcTtia+MJAUGDywqrBHY7xXYhSN6pDtajl1qpK7bhR24IcEIvk
        yztG8AnZB1mYGY3G6n5TaZOyRviFSEHrQobsvK4Nj3LFnJIDp8fx6pOndpaa9HXQ
        ==
X-ME-Sender: <xms:QZ7sX2QhsxO3m7pnTWuK7Eb4WMn5jEK5Ck3JuTJ8EhiuESOU2FPfOQ>
    <xme:QZ7sX7wraxtQ-CxqLG2B9GgO8lrqDMC9pm4qW-_AVgOz7MHzizDlpVhuqAm9i6ITp
    hy9uGOBLE8qng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:QZ7sXz3fnEby9k3rnTzlzWw1odbEj2ZFQ02Ueyhqmqv6lZoYbSQWEg>
    <xmx:QZ7sXyBHe_g2lQnJY7oQL3Ctb8Z6zfcYBGjaW3j5XHua_6ZaMt8mLw>
    <xmx:QZ7sX_jMJxxmoSjxLgp3dFFXX-Yf5tdFq3f9of4BxgNTiLKfIpxpbA>
    <xmx:QZ7sX_LG_dd0N02pJM-VnZS4SL5oz9JqjBz83TkMVOCbZFmd8jauWQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D4CF240062;
        Wed, 30 Dec 2020 10:35:28 -0500 (EST)
Date:   Wed, 30 Dec 2020 16:36:56 +0100
From:   Greg KH <greg@kroah.com>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     stable@vger.kernel.org, surajjs@amazon.com
Subject: Re: [PATCH 4.14 1/3] mm: memcontrol: eliminate raw access to stat
 and event counters
Message-ID: <X+yemM4+iT9vvfTL@kroah.com>
References: <20201229023342.GA24991@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229023342.GA24991@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 02:33:42AM +0000, Shaoying Xu wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> commit c9019e9bf42e66d028d70d2da6206cad4dd9250d upstream
> 
> Replace all raw 'this_cpu_' modifications of the stat and event per-cpu
> counters with API functions such as mod_memcg_state().
> 
> This makes the code easier to read, but is also in preparation for the
> next patch, which changes the per-cpu implementation of those counters.
> 
> Link: http://lkml.kernel.org/r/20171103153336.24044-1-hannes@cmpxchg.org
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
> ---
>  include/linux/memcontrol.h | 31 +++++++++++++++---------
>  mm/memcontrol.c            | 59 ++++++++++++++++++++--------------------------
>  2 files changed, 45 insertions(+), 45 deletions(-)

All now queued up, thanks.

greg k-h
