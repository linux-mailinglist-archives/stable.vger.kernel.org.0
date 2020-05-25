Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3DE1E11FE
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgEYPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:44:29 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54937 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725969AbgEYPo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 11:44:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AA2A35C03D0;
        Mon, 25 May 2020 11:44:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 25 May 2020 11:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=t
        alFN8qHzxZ4aGkJvVaIRM1aA8IJ0n3ETuqUhDSiG/0=; b=MbtvqRcbN5pQhRbV+
        XD3lRYlz9XWTTJFhJCMrOl4GNTvdH/0qgVeSAkSFjrZy76jDwpe59HEy0C0x/yxQ
        negkRmokBfMLhbt9Zh/ODWWFvVncAO3OW9zmtoycwDSd+edsx0wsL3n5JvFDkxLF
        aEij9L1PDUMEvBY3veN/Fv1ftmXfDibBahs9s+gBcR/pO9Cb0n1FfEOgl1y5qFWI
        iqmpjJIxQ3BD7Krw4/ItE6XOnjRTbsyO7m576F5uSuM3NkToHuRYCRXl4V29JrhR
        Xf13cz3IXUxQ9s5xJNqNKTsgFaiiilR+bseTOSAmVm5bJxnE4xFcLhB/0WPJExqH
        uCzAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=talFN8qHzxZ4aGkJvVaIRM1aA8IJ0n3ETuqUhDSiG
        /0=; b=RitIT9CJSV9PV7Ln12KvFGGfu5h6I7NckZuS/Pev9CtR3782M4zbdBj1m
        XfXgaYqXRTyH0pt80dfZdihRyhzrouy6UK3cyRDSexsakvnFpiu5/JVUcW0g1zHW
        moCyt3Es0szKqpB2SjH8TGe92htmyeB86JfJH3UWDWti1TIWD5cbfA9A7e6L4JeQ
        VTj0U+36kRJB50fbgJo75LG92LwcT6yyzz4kEGbpy27m4RBWBNcvgcZdC3Hssv3U
        asQ6ZS4ByssGvPl28P9cPYOeaz0xHetLBRXdsjU6Y39ETcUBdSxhoF+1v3lWO5mM
        5+3DyuC1No4jfCa2w7xvVZHVKIw7Q==
X-ME-Sender: <xms:2-fLXkVxkAY9NF5_MLTiDuHB6ltWKjQA9Jypr9S3snarMW9CVMPBUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuue
    dvhfetveefgfefgfejffeutedvteduhfffkeejvdeuffehgeejvefgleevnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghdprghmrgiiohhnrgifshdrtghomhenucfkphepkeefrd
    ekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2-fLXolU1hq-lkwmUv6_5fIeExh9GQPB0E_AdVJ0iqxYW1KI-vTYEA>
    <xmx:2-fLXoZs4bD6EOrfAaOZI812-1dcVf8fYrA2440Pqy0vXVemDtddcw>
    <xmx:2-fLXjUF51sirzJwfYUD0HMeTs7GiB90DmcrOQ5qGkL6jhlAAWH29w>
    <xmx:2-fLXoQvs1LohMOfequR2XCWsRfHnwleuZ3iBCStiDLW5xrvQvSJvQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3BBBB306656B;
        Mon, 25 May 2020 11:44:27 -0400 (EDT)
Date:   Mon, 25 May 2020 17:44:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.6.14-79935d9.cki (stable-queue)
Message-ID: <20200525154425.GB1016976@kroah.com>
References: <cki.09562F3C51.NRM7O0HL2X@redhat.com>
 <1238663306.24257335.1590420227156.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238663306.24257335.1590420227156.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 11:23:47AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "CKI Project" <cki-project@redhat.com>
> > To: "Linux Stable maillist" <stable@vger.kernel.org>
> > Sent: Monday, May 25, 2020 5:22:14 PM
> > Subject: ❌ FAIL: Test report for kernel 5.6.14-79935d9.cki (stable-queue)
> > 
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: 79935d99370b - x86/unwind/orc: Fix
> >             unwind_get_return_address_ptr() for inactive tasks
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/05/25/580491
> > 
> > We attempted to compile the kernel for multiple architectures, but the
> > compile
> > failed on one or more architectures:
> > 
> >            aarch64: FAILED (see build-aarch64.log.xz attachment)
> > 
> 
> Hi,
> 
> this looks like a bug in the revert.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.6&id=1d69ec1bac630983a00b62f155503c53559b3c14
> 
> attempts to revert the following commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.6&id=5caf6102e32ead7ed5d21b5309c1a4a7d70e6a9f
> 
> but the bus.c changes are not reverted, only bus.h.

Yeah, that's not right, it should not be applied to the tree at that
point in time.  I'll go drop it now, thanks.

greg k-h
