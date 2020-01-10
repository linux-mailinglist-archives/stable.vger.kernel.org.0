Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B2E13741F
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 17:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgAJQyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 11:54:13 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:34133 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728543AbgAJQyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 11:54:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C90E67C6;
        Fri, 10 Jan 2020 11:54:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 10 Jan 2020 11:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=W9nzw/ak+edqRjjbpLyEa2XPoHR
        h/BnHaFu9YMjV5hw=; b=PoLpodryUFMte9qwWE/CFN2JX3KYh9HQgzQtai+rbZu
        iI+IArz4lbiV2uGay/Vx8zi9Cd1iRRkE9u/v75bQOK2takZlzFL7gfu7wV201Z34
        NRWo3K2DVq4DSEDKTWIywFwqWALs3Rq1huX/2CIt4LPB76QLvzyp8BKq7t4miMTm
        +6uRd5msXdA7r0aZwTr5gtP2Fbf9R9oHz3u3l3YNiVtKcHbkj8HXKPBPo6z+UYP8
        Xe3d5zmNUxx3kY4ZMo1d9SSTBpVFHiVhD/idSLvjlxBDuBZ9b0ugsAfZpzXBlWli
        XIbpYqOEUJF6y1N3jdlyz+bj6j/CB/l5nZB5akxdqyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=W9nzw/
        ak+edqRjjbpLyEa2XPoHRh/BnHaFu9YMjV5hw=; b=KBbxS7pWMNDqHu/OICxpIE
        GTGtc/1LyPlaptCR514wRDj8z9g8YrHHubhztUDW7sFOWi9YFMFnneQ+/+VPBIfg
        oxAgp+PhJRGRguWWGedk5AW4OoMNYU1wJrZ00ewYoWlyrwZePEKIJdab/XEe3+TD
        WqM1A/J50Iv0BYKrr0xQUM1//ifhPqGBvw8ZlXO0SK3X+MAA6cEtMtHIMnd/sPrc
        XlP9dPgTJ0TfQGMORl4SPJsGj+1TnxTyy5HpZPQ/smN3K/Lrv8Dh2/a31XQgZ22k
        qG/n9B26OOWS8b84+ULFGbp5WRNjbH5ntFr90/VQyimrReW4kme4US7uS9Lxv2+w
        ==
X-ME-Sender: <xms:MqwYXhFjGERM79w0i9b3cSZQqJa2Gtnrv6saiI3B6ylbWUFJMkvGlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeifedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:M6wYXqa3w1FhJh0yaW12lRwWKubATg2Gilh1ygg11ImMjGxzjFBmwQ>
    <xmx:M6wYXkQ7pV6-tZL6cER1rV4QP28pwsM-DsAkrDE5Kpx9JcK2bJF8cQ>
    <xmx:M6wYXgeyMXsQT_dYUy0T-gDNvzia8Yx4Rg9TcQsEK5WzOUn4JONLdg>
    <xmx:M6wYXrzdLVfHNQ9p7LF8ZfOhOpWOn0DdUXqYbznKBGBNoRO4dm5Vug>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADC5E30600A8;
        Fri, 10 Jan 2020 11:54:10 -0500 (EST)
Date:   Fri, 10 Jan 2020 17:54:04 +0100
From:   Greg KH <greg@kroah.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg59@google.com>, bugzilla@colorremedies.com
Subject: Re: [PATCH 3/3] tracing: Do not create directories if lockdown is in
 affect
Message-ID: <20200110165404.GA1837739@kroah.com>
References: <20191205020459.023316620@goodmis.org>
 <20191205020548.446051018@goodmis.org>
 <20200110163105.GA17434@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110163105.GA17434@home.goodmis.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 11:31:05AM -0500, Steven Rostedt wrote:
> I should have marked this for stable. The commit it fixes (see Fixes tag) is
> in 5.4, and it appears this has yet to make it to 5.4 yet.
> 
> -- Steve
> 
> 
> On Wed, Dec 04, 2019 at 09:05:02PM -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > If lockdown is disabling tracing on boot up, it prevents the tracing files
> > from even bering created. But when that happens, there's several places that
> > will give a warning that the files were not created as that is usually a
> > sign of a bug.
> > 
> > Add in strategic locations where a check is made to see if tracing is
> > disabled by lockdown, and if it is, do not go further, and fail silently
> > (but print that tracing is disabled by lockdown, without doing a WARN_ON()).
> > 
> > Cc: Matthew Garrett <mjg59@google.com>
> > Fixes: 17911ff38aa5 ("tracing: Add locked_down checks to the open calls of files created for tracefs")
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Relying only on the Fixes: tag to get things picked up by stable is a
sure way to get it on the "slow, and maybe eventually, hopefully, it
might make it into stable" path :)

I have over 1000 patches right now in that "bucket" that need to be
checked to see if they are relevant for stable backporting, just since
5.4 was released.  I have automated a lot of it, but still, they require
manual review.

I'll go queue this up now, as it's simplest just to ask us to take it
after it hits Linus's tree :)

thanks,

greg k-h
