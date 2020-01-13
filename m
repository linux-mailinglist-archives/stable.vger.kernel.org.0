Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E45F138B9A
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 07:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgAMGF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 01:05:59 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:52561 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbgAMGF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 01:05:58 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 01:05:58 EST
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 7D7396A6;
        Mon, 13 Jan 2020 01:00:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 13 Jan 2020 01:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        P8DhK8ltRJH7uYyzmEkUgfSyp/2vnpQjSfGyqb1nic0=; b=ZZUKSO/eTQMdBTbp
        HwxYMmt5tQQXo9lQ68s/ozcY3kw2lmk0BK8HuO8G28NY5us6DWQrzZrdKrrYSKEZ
        raViLEKQ+wuKAHbVdEA7pe8mSeQricDisxvaq0vr4ZdY4vBgAQuvxus7Xj2v1icm
        qmZ1Gfu5HPGU0/ZEAvB1wN8tQe4tDHms6lZrWSz9LlPOYgI76UhtHt1faOQ7JOLu
        nZYieX/RBOpmrAo7w7jJd9UBZTRpORyMXmuR32Buo1RhOuRJjqhjTv8l1BeKQtEX
        JtHpRz+h13YCmoFaKivCVk2xVN2w9Gl23M4wxIEy8AurSOCsI4QF8IFhTUGRQQPl
        bT28CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=P8DhK8ltRJH7uYyzmEkUgfSyp/2vnpQjSfGyqb1ni
        c0=; b=PKtgL8O965o7BZB7yToXfSyN/QrXVnmtMhuDAckJbnw2QLJ1781zumeoS
        Kg19K4ra6jcO3vYE71aH+AMsGiOizSK29/sAOX5eVugJLDf+JgHESEmayhVovMKK
        oTocikkRAaEuEo5Kp9KyPaBppHBBsiJ3zI/baro9dFWr/CI7Ze60zESzYs61djLI
        R4qeND0+/h0TP87tYSSU2LF3EA33xMr0j8GSADl+NLgYxDXNU7Lyxp0R5Y1XOXPx
        pdMMERFQ9vD81VIbvmXAkshoPQpXAViz8hiStMVZO45OPjMHYnqk7DMLAbfW4ELs
        RLWwC7HXldqNyfo7k1e2jRINGJPxQ==
X-ME-Sender: <xms:hAccXtQe9N0U2D21iCeMFUPr552x_0IruXA1oAo-qyMjpWTzn28xOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucffohhmrghinhepghhith
    hhuhgsrdgtohhmnecukfhppeduudekrddvtdelrddujeehrddvheenucfrrghrrghmpehm
    rghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:hAccXvDikIat0APaVAnruEZ5hJJ4LeAt_mTc1PmEW6-K7XJJpcE4Rg>
    <xmx:hAccXouQscriB9WR8k4h8-wYSx7VDpMV5kgaM8GMcWwqpiI1n_8X9A>
    <xmx:hAccXmuJ9Rq8dqE8EEt9jcXP2bApKhO1FL_S3JqK8HS6RIoQOn_j4A>
    <xmx:hQccXlBL9iw23cs5OVqLct57YHOCh1SqXFT1kFEthWob7JJcH05RLmMyQY0>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC6AA8005A;
        Mon, 13 Jan 2020 01:00:31 -0500 (EST)
Message-ID: <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 13 Jan 2020 14:00:28 +0800
In-Reply-To: <20200113035407.GQ8904@ZenIV.linux.org.uk>
References: <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
         <20200101004324.GA11269@ZenIV.linux.org.uk>
         <20200101005446.GH4203@ZenIV.linux.org.uk>
         <20200101030815.GA17593@ZenIV.linux.org.uk>
         <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
         <20200101234009.GB8904@ZenIV.linux.org.uk>
         <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
         <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200110231945.GL8904@ZenIV.linux.org.uk>
         <aea0bc800b6a1e547ca1944738ff9db4379098ba.camel@themaw.net>
         <20200113035407.GQ8904@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-01-13 at 03:54 +0000, Al Viro wrote:
> On Mon, Jan 13, 2020 at 09:48:23AM +0800, Ian Kent wrote:
> 
> > I did try this patch and I was trying to work out why it didn't
> > work. But thought I'd let you know what I saw.
> > 
> > Applying it to current Linus tree systemd stops at switch root.
> > 
> > Not sure what causes that, I couldn't see any reason for it.
> 
> Wait a minute...  So you are seeing problems early in the boot,
> before any autofs ioctls might come into play?

I did, then I checked it booted without the patch, then tried
building from scratch with the patch twice and same thing
happened each time.

Looked like this, such as it is:
[ OK ] Reached target Switch Root.
[ OK ] Started Plymouth switch root service.
       Starting Switch Root...

I don't have any evidence but thought it might be this:
https://github.com/karelzak/util-linux/blob/master/sys-utils/switch_root.c

Mind you, that's not the actual systemd repo. either I probably
need to look a lot deeper (and at the actual systemd repo) to
work out what's actually being called.

> 
> Sigh...  Guess I'll have to dig that Fedora KVM image out and
> try to see what it's about... ;-/  Here comes a couple of hours
> of build...

