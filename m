Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB1327F55
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhCANWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:22:01 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45053 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235387AbhCANWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:22:00 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 43EA05C00C2;
        Mon,  1 Mar 2021 08:21:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Mar 2021 08:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=rhXaCrKGBrwKHgr4ALQuoS3wuzW
        8zZ5ehlsEWxHaNhA=; b=BkJABv/UN0FesDTDJ375bWUXO3ZJDTRQBTdPgj6wMm4
        dQkr3/DWyRSVUWZ/vffzW3Xy0TzWwdHYchsTRCEVElBAwgd7mt5xCzUFdWf4uGrJ
        U3uRrOUCysVt4ZhqTxZ2eUbmBkvwEQgJ+/OSLOK69o/NpaCpft4tMEdtUSrAzgmj
        kX6IJyiXm/J0lWb4T92z6D8ilGaHV4cXWCZMQTUG6r56uyGdi6vqhX48/98RG8Sk
        XffXAMZGODUbgrymtIFFnUhWayBbsxCmPvTT314jNM1gMlfy0EXOLrlg80q+QM00
        6LuLkcmI8iRn01SXNFBFN0mBdgSnhfQX0i/891HCaYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rhXaCr
        KGBrwKHgr4ALQuoS3wuzW8zZ5ehlsEWxHaNhA=; b=NxpqRKOpbDfQ8GbIn+h41L
        TdrRSO5j9g+5E16q2RElredigI1eoVx+Zmfy5VJ0Wj25E23otkwT9tF/W/sdZ50Z
        7InNXg75QOjMG6GZ865BpQ9R7dEUcg95nAYF7G8j/rk+iFfzVFBpiOl/QDbKWaTA
        IRCYB1YPEZ+5gRQsItcyC6KZbXpy22g2IsVX3ho2xgeLIMgLLVnXqvNtQEnpcJCJ
        TZ55CuTBXwPr6yLxromS3cu54yx5af+NSTNQf1hxiqi7zYc+WAzmWErf+KsMIfpz
        8cCxXZB/8EPwnYiuEiSbieijqxrVYyy/z7D4ACzyMy4NjS1imSCQ88iu27lf+prw
        ==
X-ME-Sender: <xms:Seo8YCwG31WgI0sxk7i6cmiVEBF01zEiWcPHVQg4n9ooBw5PNC914A>
    <xme:Seo8YMNwSh4oXOhzAdK-zr4ZMPWjuR-UdIhFJdr9aXvY__cq2MMCM4wWWdTLz4NMj
    qGWLH4g0JQP8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Seo8YGp2NsxXdcSbKdH5j12O87rU5iaQkifnn7mHT_f4LQIsXPQ23Q>
    <xmx:Seo8YNEBD0A-0yrOQtdS8pLrpptsAl9tHyDWdaQfkpn6em4AgHOqJw>
    <xmx:Seo8YLr7npAroytpOdWbOCCyGEcQnIi0eOKrj_6ssenjFqLeOYIKag>
    <xmx:Suo8YIdtGGfGVtPheP9anTG-Svk-w5QZAi6RGWo0FMgI1IhZSWW4ew>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E25D1080064;
        Mon,  1 Mar 2021 08:21:13 -0500 (EST)
Date:   Mon, 1 Mar 2021 14:21:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "J. Avila" <elavila@google.com>,
        kernel test robot <oliver.sang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] printk: avoid prb_first_valid_seq() where possible
Message-ID: <YDzqR2u3c3lC8YWv@kroah.com>
References: <20210211173152.1629-1-john.ogness@linutronix.de>
 <YDTEls/iLBQEtTTn@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDTEls/iLBQEtTTn@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 10:02:14AM +0100, Petr Mladek wrote:
> On Thu 2021-02-11 18:37:52, John Ogness wrote:
> > If message sizes average larger than expected (more than 32
> > characters), the data_ring will wrap before the desc_ring. Once the
> > data_ring wraps, it will start invalidating descriptors. These
> > invalid descriptors hang around until they are eventually recycled
> > when the desc_ring wraps. Readers do not care about invalid
> > descriptors, but they still need to iterate past them. If the
> > average message size is much larger than 32 characters, then there
> > will be many invalid descriptors preceding the valid descriptors.
> > 
> > The function prb_first_valid_seq() always begins at the oldest
> > descriptor and searches for the first valid descriptor. This can
> > be rather expensive for the above scenario. And, in fact, because
> > of its heavy usage in /dev/kmsg, there have been reports of long
> > delays and even RCU stalls.
> > 
> > For code that does not need to search from the oldest record,
> > replace prb_first_valid_seq() usage with prb_read_valid_*()
> > functions, which provide a start sequence number to search from.
> > 
> > Fixes: 896fbe20b4e2333fb55 ("printk: use the lockless ringbuffer")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Reported-by: J. Avila <elavila@google.com>
> > Signed-off-by: John Ogness <john.ogness@linutronix.de>
> 
> Could you please push this fix into the stable releases
> based on 5.10 and 5.11, please?
> 
> The patch fixes a visible performance regression. It has
> landed in the mainline as the commit
> 13791c80b0cdf54d92fc542 ("printk: avoid prb_first_valid_seq() where
> possible").
> 
> It should apply cleanly.

Already queued up, thanks.

greg k-h
