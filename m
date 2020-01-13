Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC449138BAF
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 07:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbgAMGLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 01:11:00 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:33103 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732572AbgAMGK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 01:10:59 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id B466334E;
        Mon, 13 Jan 2020 01:03:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 13 Jan 2020 01:03:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        9Z6VUqdqPXpLn669vPyb+CQZlzNvkMAwmc1OtG2A7bg=; b=FJ+hlWNWRyO3bUzQ
        mU6lJAlgm5zemUjvxDyxio74eo5D+xwnbYH2LR3wiVXN7+X3QP8oLYhOR9Lj+PBi
        sh8gfItBzv8n3ikWXB1ysNHwFp18y9/pciiyAMtzioUVg9HAVcmNogyvHy6iHFdV
        nl86jk8NYWaY9aiw4LdM/XMr0O1woaQQ1fDM2XtObjQmOlv4Z9bAR469U0NwpS1M
        hpJlSQsZw0MH7qKCI8T2SECdFolVjdVH/AMgmSC3yVb3xzHlo7rmAteq66rz4Z14
        sst4ZRSf0PLntYnaCS/nT72LO18TPS5XIzfE8gTkpbYG/xptt1+sFso4dL6Ht2L9
        GaWIDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=9Z6VUqdqPXpLn669vPyb+CQZlzNvkMAwmc1OtG2A7
        bg=; b=TSX7MS1vVDaVQxKh/S5NfhasA1b1ydZGUNqi6HAKn7HRHp+X6ihk0kIvn
        mh4HwNKXPWxk9hS/s4ul03Zc2vQPHiC9bvisxrIcFVi+F5Z4ZhXphu5MgBM7etNA
        b1idW+9xhYbDsjVxoBaJkZ1Wdq6hOn/Pv5dRGEfwd34VRrc0g10i6bu19kI5cav6
        0sWNVIUPT8e7IO9W3PAfC17d3/W86Ujch5zgyy8JzIwC5ntvZ50G4fG0D8kcDPz1
        0c0uNLFhFaGfziK2JvUQVhWT4B2VpQPx+70U2c4B5yFrenugrE5BKiMe2k+O/I7s
        0tkRAE8jI2GdmNt96T+IE/2tTWQcA==
X-ME-Sender: <xms:GwgcXpcMsfKuSdcdiHHMfprUEqTioGSNI86XT20OV2S1PHixb2oIgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiledgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucffohhmrghinhepghhith
    hhuhgsrdgtohhmnecukfhppeduudekrddvtdelrddujeehrddvheenucfrrghrrghmpehm
    rghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:GwgcXtmEUEamm_EPdfFMXSYx6yCXdt61le-aSJGuScRzDvO20fskNA>
    <xmx:GwgcXuynn2oCGOcsuIfkae_Fwq9BGSTnegqf11WrlWIUKBA9I9CZHQ>
    <xmx:GwgcXgwn1rHnm3qk6K7lr5nxaqpwqeeiG6glo60EYHI9yMrVLwHriA>
    <xmx:HAgcXrnLrLpulrqlFePddhNq9yVIM5Y8F6pN6HBMbNOy-QMohJs916rjgGY>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0BDED80061;
        Mon, 13 Jan 2020 01:03:02 -0500 (EST)
Message-ID: <58f9894e51a00ad2a4ac3d4122bf29e7cb6c0d54.camel@themaw.net>
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
Date:   Mon, 13 Jan 2020 14:03:00 +0800
In-Reply-To: <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
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
         <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-01-13 at 14:00 +0800, Ian Kent wrote:
> On Mon, 2020-01-13 at 03:54 +0000, Al Viro wrote:
> > On Mon, Jan 13, 2020 at 09:48:23AM +0800, Ian Kent wrote:
> > 
> > > I did try this patch and I was trying to work out why it didn't
> > > work. But thought I'd let you know what I saw.
> > > 
> > > Applying it to current Linus tree systemd stops at switch root.
> > > 
> > > Not sure what causes that, I couldn't see any reason for it.
> > 
> > Wait a minute...  So you are seeing problems early in the boot,
> > before any autofs ioctls might come into play?
> 
> I did, then I checked it booted without the patch, then tried
> building from scratch with the patch twice and same thing
> happened each time.
> 
> Looked like this, such as it is:
> [ OK ] Reached target Switch Root.
> [ OK ] Started Plymouth switch root service.
>        Starting Switch Root...
> 
> I don't have any evidence but thought it might be this:
> https://github.com/karelzak/util-linux/blob/master/sys-utils/switch_root.c

Oh wait, for systemd I was actually looking at:
https://github.com/systemd/systemd/blob/master/src/shared/switch-root.c

> 
> Mind you, that's not the actual systemd repo. either I probably
> need to look a lot deeper (and at the actual systemd repo) to
> work out what's actually being called.
> 
> > Sigh...  Guess I'll have to dig that Fedora KVM image out and
> > try to see what it's about... ;-/  Here comes a couple of hours
> > of build...

