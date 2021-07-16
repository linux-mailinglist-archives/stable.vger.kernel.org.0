Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509A33CBBA3
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhGPSIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:08:02 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50931 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230476AbhGPSIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 14:08:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1F01C3200909;
        Fri, 16 Jul 2021 14:05:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 16 Jul 2021 14:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=m6FoQuXdOVWN9azOdi+KXGb4bQg
        PJaWnq9ZIAqbXgfs=; b=PfWZU5FQy4v+ABLf7N37JKZjy0w4LyW/ALfWOpPJLpn
        jiVDmRp1YpB9/H1jr5B4POf4IWp7Q0bcmSyobbNQQOnOOIwdRC1VdLW4cSpZH25t
        dGBJZvz/TEO4jpD4nfSgVWoV06tFuYbG9g3RcZhuhcNP204VSVlUiH/7qUu9fws1
        hqrIArI8aZuJBwSTq+9O+Py8+NxKKvBGOrJLby5FHejWUbTaKN0wOGNkZM67RSty
        fOgYHaY0pyoEiPfh2hlDyrB5OAtFV7cXtVg/LZlpqrU7VI9heZZxY6vq6KlWwQG8
        rI9yOoUnOWbCU901NAxdE2NQO9J6yOC89Nf8hXD3dcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=m6FoQu
        XdOVWN9azOdi+KXGb4bQgPJaWnq9ZIAqbXgfs=; b=fEpJArM/zOPl2smcT05AbA
        hMKd7Ozf4F9E3qViaf7avWuO8IUoQhikTWp17WMKdgrPF/MZKCm4sPSt7eEXr1Ht
        rg3QHp48CB/xjsWIG9g5QEcIgzCZ0EyN5vBN8vk9AiY3UMc+ipnxt98jh9cx50Cd
        j8K6OnyIsQlflNXIYpcS99SQm77mDWLGKTx7MdXXp2yRlqq2W2PlUfxRyACkfNp4
        n3+7cVANCXqJc7jUN5e2Z5qvBejgFqhSNnR34eRRLwqbO+k+JYYVpCwVkx7hXxu7
        7nEH4Z3Tvisq+Q6evJQtpxAwgY3Imr5a4ks9D97BlhjnQgdptk+kKm8sSIFiKLTA
        ==
X-ME-Sender: <xms:UcrxYDeav0UQdbZwze_V9OCwAQWriYH-uqvyJNxzqyDfq9R2d7Jxqg>
    <xme:UcrxYJMvzPv25K3rjmOdTKv8Z34f4XHl-WaVuYCP6LXUb428udP9oaOiyZm1GsdK5
    mUhy6m0xhnECg>
X-ME-Received: <xmr:UcrxYMirkvXDjLox9uiTbZ29pSjqFEzqWIJBL3qhlKfeECR6uj6SmRVQiK7Ox89XSHOHw9hxbzwpPK9Y5h1tQHab8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeiudegff
    dukeejjeehvefhuddtueegudfftdeufefgheeihfduteduueetudelgeenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgpdgrmhgriihonhgrfihsrdgtohhmnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhm
X-ME-Proxy: <xmx:UcrxYE9ADGdig5kbYSDphyrmDlvfpvFJTAEz8ogPoXBe9JgowxMBeA>
    <xmx:UcrxYPsfFun2je2qfbhZKbCjh1iVyBSNM5jdIKsXgBPZ8Hb7hz1oGQ>
    <xmx:UcrxYDG8ccWnpiNIlEblB13CofItdVHkXLnc-qUQEvHIwiFR02fRvA>
    <xmx:UcrxYDj7M2GmjVTFPwTOYdvEn0k7mXtKWZslVGk_DmzKpAmX-wggDw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jul 2021 14:05:05 -0400 (EDT)
Date:   Fri, 16 Jul 2021 20:05:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.13.2 (stable-queue, ee00910f)
Message-ID: <YPHKT9BFB18PjO8h@kroah.com>
References: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com>
 <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
 <YPBw8SQ/oQQXfguv@kroah.com>
 <CAFxkdArnhDFD4rH4__DU0tKxxBd_3s4vGRVeXpZuunxU1u=m6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdArnhDFD4rH4__DU0tKxxBd_3s4vGRVeXpZuunxU1u=m6Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 03:30:32PM -0500, Justin Forbes wrote:
> On Thu, Jul 15, 2021 at 12:31 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Jul 15, 2021 at 02:51:15PM +0200, Veronika Kabatova wrote:
> > > On Thu, Jul 15, 2021 at 2:50 PM CKI Project <cki-project@redhat.com> wrote:
> > > >
> > > >
> > > > Hello,
> > > >
> > > > We ran automated tests on a recent commit from this kernel tree:
> > > >
> > > >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > >             Commit: ee00910f75ff - powerpc/powernv/vas: Release reference to tgid during window close
> > > >
> > > > The results of these automated tests are provided below.
> > > >
> > > >     Overall result: FAILED (see details below)
> > > >              Merge: OK
> > > >            Compile: FAILED
> > > >
> > > > All kernel binaries, config files, and logs are available for download here:
> > > >
> > > >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/07/15/337656806
> > > >
> > > > We attempted to compile the kernel for multiple architectures, but the compile
> > > > failed on one or more architectures:
> > > >
> > > >            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> > > >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> > > >
> > >
> > > Hi, looks to be introduced by
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.13&id=07d407cc1259634b3334dd47519ecd64e6818617
> >
> > Are you sure?  I fixed a different build bug in that area a few hours
> > ago, if you rebuild the tree it should be resolved.
> >
> > If not, please let me know.
> >
> 
> Seeing the same issue here, there is nothing new in the tree.

Ok, see it now, dropped the offending patch.

thanks,

greg k-h
