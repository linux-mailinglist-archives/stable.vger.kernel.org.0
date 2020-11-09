Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4522AB49E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgKIKTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:19:07 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57201 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:19:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4AE0A127B;
        Mon,  9 Nov 2020 05:19:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=s/qsySht1lZ9NDOoV5qxwwNqljC
        MtNT8sJkdgyDqpU4=; b=nOKRFt2ihnXqA240lHgtGQLLS9wsBTtqtFiRawERqWX
        v8egPNV85IQB4nyHZejIk2ZOoIn8TWP0CFeZe6X9r8oGutCZyFZeKvrzBTGJgpsy
        VQ4s6k2/oMXOOvc1tTP5pOZPJFNxVnE6hHGXmZzz89o6jK8ealGBFyKxxwwY8L7V
        6kA4waMO+0l6VVMExvhM6k4Hx5Alatf/bhL07OJc2h7eSvlaTxaKhAS7ef5ZE6t5
        ddAXdC53se+IfRNeY7ri/IRj+APktn6vkyqvNsbK+Omba//kfRvn3c8CV3MsEbmS
        RAzfk/2mt0fhspKp2Uir1ioVss1JX1u0VQDRUzd8BuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=s/qsyS
        ht1lZ9NDOoV5qxwwNqljCMtNT8sJkdgyDqpU4=; b=PHUniTN97f8DHxgTeSlpys
        i89jOBBx2/4PsQCntcE/ulbjr7lbXrfLMMSVojfGqHQ0dg3e4rxPSHuOq61C1mBr
        HAjbYW7x/elyFrqEG1GHCtnZ7nFkGn5Il0xHk5KkBQeJaClWtVpg8um9C8bvNK+e
        MfRc2FlPGoTfQynz+BQqvlTCdqz3mx5/SkKcjOSiICz/dx+JOrObZwdN3lUNNL/H
        uaeOaKk25Kc2HgZI9qCQ9bX7qNLw07rNkvAJiLEslKC2kx6XR5u5t5qeE24BDuUi
        2p9bWPJgPbT2J8fG6OI7clS+3a+5e+GLAYFfzhkil1LACb7hcg0ow2u6+yU/S1sQ
        ==
X-ME-Sender: <xms:mRepX6kJ9UZtcV3QSEbq92r3zwdsqS4cXG5xU3twsuSmT2C18r_rHQ>
    <xme:mRepXx0PxRp_pQTq1GIh6mtP5juv83CVPPICymgs26ZkLZJKyPle_RK7ucuDe7XRF
    B6BCA1GAN1lxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mRepX4rVl30r4FOKZeS1kLX93EvJwd_B-fjC6FoirYiquQALL4cyMA>
    <xmx:mRepX-lTm68SSUHrZGgl7h8EB5Es4mS-e2qF52HDFnTsMlf0b0tU0Q>
    <xmx:mRepX43Ulff7-vrWDzAk0IGlGf8w6NmlM6GgbWBkqCjR4aw-ASvDAA>
    <xmx:mRepX99ZcjkmBP2xYzmVYcTwPNijLYi_bqdXb_M0BCLHkUlasVb3aQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 416123063082;
        Mon,  9 Nov 2020 05:19:05 -0500 (EST)
Date:   Mon, 9 Nov 2020 11:20:06 +0100
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fork: fix copy_process(CLONE_PARENT) race with the
 exiting ->real_parent
Message-ID: <20201109102006.GA1238384@kroah.com>
References: <20201107064722.GA139215@arch-e3.localdomain>
 <CAHk-=whjyOuO-xwov7UWidBOkWyZv84TVA18hBb01V-hiML+yg@mail.gmail.com>
 <CAHk-=wgukcYn0xpqJ+Vda1Zw9wxPCxV0L_ZX6AmpgapT9Lp2mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgukcYn0xpqJ+Vda1Zw9wxPCxV0L_ZX6AmpgapT9Lp2mw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 08, 2020 at 11:56:48AM -0800, Linus Torvalds wrote:
> .. oh, and I suspect it should have been marked for stable.
> 
> I added Oleg's ack (implicit in an earlier thread), but didn't add a stable tag.
> 
> It's commit b4e00444cab4 ("fork: fix copy_process(CLONE_PARENT) race
> with the exiting ->real_parent") in my tree.
> 
> I'm not sure how serious it is. Yeah, the race can cause the wrong
> exit signal in theory, but I think you almost have to do it with
> cooperating processes, at which point you could have just done it
> intentionally in the first place.
> 
> But it does look like a real data race, and the fix looks small and
> obvious enough that I think it's stable material.

Now queued up to stable trees, thanks!

greg k-h
