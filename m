Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076C747FBFE
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 11:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhL0Kzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 05:55:47 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:41587 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232508AbhL0Kzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 05:55:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D45E1320024A;
        Mon, 27 Dec 2021 05:55:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 27 Dec 2021 05:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=woJJdr1OmGOAY4PNXjv6MLEjydc
        btdZv/KDv9EBLYfw=; b=XgDpNE7NmWYbh2IYgCiyN6ko8FV7fSeBmkjyPr4IM9i
        EBA9hn60Ll1F68JNdmqALbKM+sxIDgRX8k0InuTBAPCc9DVXf9HmgvKiaa+uSP7A
        +PEnh21fMah2If5zcpl9S0BZAKEG19y0TrylTPghgCqCbfKWJ04uyDFFnY8AY9lC
        umJYrbXW4SflmFgmfoO9XcksNHHBTgddOF5V9EJSU2HFFrJ6vJmUpuu+cC1uzYmq
        5uT3sChgP2TUldXO36BBxngm0aqFwS2OptnHr6WtJgX8hGHtWePnf56SooFy9O/V
        Ae44S+xmtcczZo4Lgv5A3/XO09u5bCb3dM/1+5Vim1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=woJJdr
        1OmGOAY4PNXjv6MLEjydcbtdZv/KDv9EBLYfw=; b=gwGN687rpJ1LgvzmK+sM6b
        wrIr8abLp1I81Pi6Eb2qEmYdqIimAYUOA3ObCnKKix9vKzwUTS+eL46gZ6bL6410
        s4L8IhNizq4JR/XTcqwHfzQrmxjaw9d/4xIJovuHkxwgJMLrraLwFMjXotFZGY+G
        8Y3pKo9FShG5xbpBsJQzjGlAMIRKsilJAkNgRqTGrryCcAIaVdEDzvjrD6Z8sDmd
        yrggQzc8TJQMmkeKbbz/+kKbrNesAPpoV+vB589+ABXtbFuJok+23U0w2QyNxnGL
        5vja1WSIltCUuXwN/sdgX2jmBeNA1K5K07VW1gbrS13J3c2HXNXIVuIB5SdNqdWg
        ==
X-ME-Sender: <xms:sZvJYVykmNEF83DcbeD2pw8r9Gnvag0i36kTRZ69kH9yotK913Kj3Q>
    <xme:sZvJYVS_bvYbGcmVdzPkpfu8RAvRj8yPAS2fy82B0oUiJHKakzWBxbGz5osBaFpKS
    8qjNpJ6iTurUQ>
X-ME-Received: <xmr:sZvJYfVG3Z3SHHER95bjwVHTHqGJTk4OUlW67sL0EEH8mP40gO_hr80LvUVGfbw55K8qJHLQ-JIxXTt1LGqjNsjdYdd6nE62>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddujedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:sZvJYXjAtinIIPBuQUqz-ioUdrBoE8QGyI3tg_RmeysjM1zV5KoWrQ>
    <xmx:sZvJYXCHn67fJG-GGR2mXd1zyNie329wKcy5sE29HqfAC6qwHiIiag>
    <xmx:sZvJYQLnwSn2XBPhwKL9DYQHfjmlFMlPEix2NX4jMYNX3ALq1c_8JA>
    <xmx:sZvJYaMSqneRHGWRpVSdnhYbg5c0WW5CaHfaX4srnCmKziZQYvj7Eg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Dec 2021 05:55:44 -0500 (EST)
Date:   Mon, 27 Dec 2021 11:55:41 +0100
From:   Greg KH <greg@kroah.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: 5.15.y backporting request
Message-ID: <YcmbrST1APpGlvxo@kroah.com>
References: <YcmMPjXU36oiVTfo@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcmMPjXU36oiVTfo@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 10:49:50AM +0100, Borislav Petkov wrote:
> Hi stable folks and happy holidays!
> 
> Can you please backport two patches to the 5.15 line by doing:
> 
> git cherry-pick fbe618399854
> git cherry-pick 2f5b3514c33f
> 
> in that order. They apply cleanly ontop of 5.15.11.
> 
> The first one is a revert and the second one is the better fix. I
> would've done the usual cc:stable thing but sending human-typed mail is
> a lot better - it feels like sending physical letters back in the day. :-)

Both now queued up, thanks.

greg k-h
