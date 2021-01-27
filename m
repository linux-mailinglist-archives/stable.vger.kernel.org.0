Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57108305725
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 10:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhA0Jlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 04:41:37 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60825 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhA0JkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 04:40:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5FD6B499;
        Wed, 27 Jan 2021 04:38:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 27 Jan 2021 04:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=eG+zq7v+gLI7XOa4rrspPeY9nhn
        cigoujY489dDssjQ=; b=QqCDrTDI9XLmxXe9sWa05HVO3QbjZDo1UnbL/VBh8XQ
        lt5PyxGvj6YzmsqdomkNV/REdtrrp3xdug2d5LD9ZlYqA74OgagZo2MY3HbvdyJQ
        Bgn2SkI6LCe2oXnMmm9Z9pVzFsEMwH2m9UJcu96XX/Y9V4bjO4A+nSKROPUUolLU
        7WMoomoch1WhlBJYi8g2qWw4pBYe+p+R5WFmjzpvQTPz+7lGSTNsYsHobXbD4WRV
        awtWfWacOiRDQ3OtulCko9WB7UGNz00lWWj0Uz2tlmVSdivzJ0e4dWDWyaz155Ra
        FxS2AQ219xzvAetiPQ1s/5VPcULhgkYhl++DYsk5Clg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eG+zq7
        v+gLI7XOa4rrspPeY9nhncigoujY489dDssjQ=; b=jddtmPNEqtfN1H4QP5JZHl
        F1q2gU3BiBd5iMmT60WTxjGH8+fEJHHRInGmdzAIS4En2wIut2CQGogaxF7McfSr
        /59bivHaZWTcUOUK8ozr4EWwkpaRWyGh+Ai9/LL4bcvE/IFrKhdO/PqnyeVStQfY
        x8+2/ffCnw0ajpoCb+4k9AHMSJ3AjIxZhksXnqdwA3RqPVb/yRljrY6iwiLxrU1e
        aH/1FOzWw39z6Lrn2RjDrPl7e5AK/rCK2gO+5/YrtRZoEZ+zId/G3UNJCFKVooSt
        fsD+8HeJ8QA2kKBA1p2muwRLdCbAcGsxSnsX8K6JHizpLroULvod0Z5+tTizFzmg
        ==
X-ME-Sender: <xms:sDQRYFvnpH106XbRKlnhrcyLLeZSEpnHUlINSRMdDVwmCM5QT0JVzQ>
    <xme:sDQRYOdf7CD10cLW1WnapdnB-Ibok-9OBLTD3V_i28xWlqrIkAeottzm7whMeHP7Z
    itEiQYQRbIayA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sDQRYIy3IhW6iNpP8vlCRBrk8pz2o4GFLTVI6MQ0gX3sfS_JeQhx3w>
    <xmx:sDQRYMNaoxLY27nrttK9oXMMoA8EZZpwQczm_1P5sL6nTPHNf4sopw>
    <xmx:sDQRYF-bILWdx9TswFDTDwkuuNAJ-Vd3fF7RiPm8Pxf2O95qiyj7mw>
    <xmx:sTQRYAaXFtQPjyL9lscV4aQgY9XozB3Lg9EvsfFYX1LmwcVGYiADTQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 29B4824005E;
        Wed, 27 Jan 2021 04:38:56 -0500 (EST)
Date:   Wed, 27 Jan 2021 10:38:53 +0100
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        stable <stable@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 5.11-rc5
Message-ID: <YBE0rYEf6Uc6HbK8@kroah.com>
References: <CAHk-=wgmJ0q1URHrOb-2iCOdZ8gYybiH6LY2Gq7cosXu6kxAnA@mail.gmail.com>
 <161160687463.28991.354987542182281928@build.alporthouse.com>
 <CAHk-=wh23BXwBwBgPmt9h2EJztnzKKf=qr5r=B0Hr6BGgZ-QDA@mail.gmail.com>
 <20210125213348.GB196782@linux.ibm.com>
 <161161117911.29150.13853544418926100149@build.alporthouse.com>
 <20210126162440.GC196782@linux.ibm.com>
 <CAHk-=wgKbFUUhkRKvh4SHQcsUyG_kraLOTBLHUhc4GQ58ANBEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgKbFUUhkRKvh4SHQcsUyG_kraLOTBLHUhc4GQ58ANBEw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 10:45:10AM -0800, Linus Torvalds wrote:
> On Tue, Jan 26, 2021 at 8:25 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
> >
> > On Mon, Jan 25, 2021 at 09:46:19PM +0000, Chris Wilson wrote:
> > >
> > > CI does confirm that the revert of d3921cb8be29 brings the machines back
> > > to life.
> >
> > I still cannot see what could possibly go wrong, so let's revert
> > d3921cb8be29 for now and I'll continue to work with Chris to debug this.
> 
> Ok, reverted in my tree.
> 
> And added stable to the cc, so that they know not to pick up that
> commit d3921cb8be29, despite it being marked for stable.

I've dropped it from the 5.10.y queue now, thanks for letting me know.

greg k-h
