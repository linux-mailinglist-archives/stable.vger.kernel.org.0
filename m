Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0051D7ACC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgERONN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:13:13 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42519 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726907AbgERONM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 10:13:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5DC5B5C00E7;
        Mon, 18 May 2020 10:13:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 10:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=l
        TiLsK+U4dypRGvxSSjsUgf2lfqxSO6N+hxi8kKGses=; b=BEPVsUhUklZGRQ4VT
        1M2UXwS9vJ16L1vtH+pRqpkiCbPDwjyeQeV8CGpwgDWp+/4fpXuCp7rc3tbGvps+
        K6EtiDITask7gYgjksDLxc4xraPFgbYy44UiYoTdxUjpofGx7gTAZsxCPx7LfDdH
        tKXeu+WWiEAAafC7ZDQ0sLghn82gQ2zX26MZ3f8zvLbKbIO8m/Ww7J/NbM+oRg2A
        rOOedsscRoKfpjLvhEA1phc/p8sI3C8JILQlwMcnv+dgy24UdsOfsK0sMOTG4aR4
        huYO1glF0fN7qh6JxDpFsvmNACeZCtTWM5JPDCu3s+/6t8yWHsSibamd2QpxMj36
        Q7Otw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=lTiLsK+U4dypRGvxSSjsUgf2lfqxSO6N+hxi8kKGs
        es=; b=354ksZ/N83pUH8emmJ54aqNng/mqZ1RFB2IDjm5fKVICVyUNagBKxtHDu
        R6V8uX9NrnQ+Rq2YhKOUvGg8aztXKCylj81EvplLyIwjlB9vZ9QLpDHS9Pgxqtkc
        JBoeJzGiiQCLWGeFuOhA/FNL/zXuYHNUk7FN8WGbwZLnBoRM06VgKJ4L5tr/wnqu
        tI2SJ5D9hIHFZtN7vBMYZwZNXnw1KzAWXGYOc5eIOp3yTkmFZ5FGpuoXWv70F+3Q
        9UBbRLUs5IIiqf+hqwZDO/8bqtArdhs0hDx+yfxjSLbEHu5sI7Hrck7AJaYRm1j6
        HQI1WauplBU010N39P7EU9Dm4NziQ==
X-ME-Sender: <xms:9pfCXpfGcWWvCU74dpye20iQWmBj-fIjbV7viK7EMbauon7yjKOUsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuue
    dvhfetveefgfefgfejffeutedvteduhfffkeejvdeuffehgeejvefgleevnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghdprghmrgiiohhnrgifshdrtghomhenucfkphepkeefrd
    ekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:9pfCXnNUB7dJ2O4RHcKCxwURsqLK2F7Ok1UEjITUS0AAldNOLhwT_g>
    <xmx:9pfCXiifYg-oQQ-r0LrJMj0U6iMG60APOt0Nk6QHLfNUGHBe1D7cOg>
    <xmx:9pfCXi8gv9XfROFBDGmV1Qa400ByguXhNKipzTC98cXqBjEAMFdF7g>
    <xmx:95fCXmViwjXhov-DN1CuCFKv8hk3TRqwQ1l8BlRsdrMuBoCmGO2PvA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8599130663CF;
        Mon, 18 May 2020 10:13:10 -0400 (EDT)
Date:   Mon, 18 May 2020 16:13:08 +0200
From:   Greg KH <greg@kroah.com>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.6.13-3f0cc50.cki (stable-queue)
Message-ID: <20200518141308.GA1675843@kroah.com>
References: <cki.1A49C7CD82.EYM9JXWA38@redhat.com>
 <89124b8f-c77f-5601-9e4f-8abce7e7050f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89124b8f-c77f-5601-9e4f-8abce7e7050f@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 10:00:39AM -0400, Rachel Sibley wrote:
> 
> 
> On 5/18/20 9:58 AM, CKI Project wrote:
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >              Commit: 3f0cc50b2470 - net: broadcom: Select BROADCOM_PHY for BCMGENET
> > 
> > The results of these automated tests are provided below.
> > 
> >      Overall result: FAILED (see details below)
> >               Merge: OK
> >             Compile: OK
> >               Tests: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >    https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/05/16/570411
> > 
> > One or more kernel tests failed:
> > 
> >      s390x:
> >       ❌ LTP
> > 
> >      aarch64:
> >       ❌ LTP
> > 
> >      x86_64:
> >       ❌ LTP
> 
> Hi! Looks like fanotify09 is still failing as we're missing the following commits:
> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/05/16/570411/LTP/aarch64_1_ltp_syscalls.fail.log
> 
>     23	HINT: You _MAY_ be missing kernel fixes, see:
>     24	
>     25	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=54a307ba8d3c
>     26	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b469e7e47c8a
>     27	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=55bf882c7f13

Nice if someone would have told us that last commit was needed for
stable kernels :(

{sigh}

I'll go queue it up now...

greg k-h
