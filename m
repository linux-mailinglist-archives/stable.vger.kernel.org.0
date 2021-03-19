Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32E1341A74
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 11:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhCSKug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 06:50:36 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47945 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhCSKuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 06:50:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1220B1639;
        Fri, 19 Mar 2021 06:50:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Mar 2021 06:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=QzvdjvAmIqDmQGf66bdPmw8tacU
        Yhz/pv5/OWl1FaJ8=; b=ml7XYbbEYKpJWBWeapsoPBn9cKpjYg9EYaauc5a8B7n
        YkEXEiZ0wNO1ohSylL3aA+1aaBWvmECwu1ZBvqvb3uNlJjLhjsh7t16b+6mWMOCR
        v7OBLyGs9aWDWVGusTGDJaOSftQq78Z/OO06nj19fAbA2WTG0GPu45gu9zfhPu6l
        vRR3AEUUPg3rHpWu7+lcZY2YXmGcUNI6IbRmToEEZxEhrStNCyZaDSqTd73AHo92
        sP7D8ZK7ErHf7H0g0HtQETM4vQ/a3UFLxtxlvZw8T7ZhmKSf1PYFEmOW3T3euFQm
        gZyVJMN62WfI6cdzA9bMAOWux4p1mNaGTbMydYuK7vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Qzvdjv
        AmIqDmQGf66bdPmw8tacUYhz/pv5/OWl1FaJ8=; b=I42+Ijb1hn/2rOFx0vMaWW
        46CiDVN0qYT0VLnl67SpwnS0ZXAEOUJUufFXYkvSLh6Q7a59Lt3Np70wbfLtxhaf
        dtz12Ka6HfKIDaoHFp269VYOdbFV+nbs14R4d5yhuhCn/EUYMR+dpLB7cFSCWgu4
        n3y6xN9cd5eePppu/wotyMi93bAyK3IHksdQEq/hLCN0vL+LW/2G8b3VDH8d5s/3
        8Q1KlsEo7WdhkQsxyYDbBp/3xM0mfbNmedCHsV0WgUW3kQP4LBoSjNV+5MF2nZqv
        rHQQCXgF30uSpIoLteW1hRE2qmyqNhUx2IDAhIdEIpEciwcy25Qc/lcvULdHrj4A
        ==
X-ME-Sender: <xms:4IFUYNyWYmuJCbE-r-gAZWaLKowCuyk8o_Jhfj-rjv6QQr424cyl_Q>
    <xme:4IFUYNT_SW81kfl7F1VDa-fStW20_6FlPaCUGou8QgZBuZ9DCQI2wWtbnr-iK0vjG
    FcuB8YngvgA8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefkedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4IFUYHW9KoXOJ6bc-Jf7fLJD66eYujzuEuJLwP7Kq7Go2idkq0RLbw>
    <xmx:4IFUYPg0KXyPBxt2NtCziIBmT_PtQ7kTGFeImxHzpqgK1eVSu272vA>
    <xmx:4IFUYPAhBgSk3LcWV9iAPIlxf6Diutp0aFTG_tfM38iXRI8QaLYhXw>
    <xmx:4YFUYK_CtxgM9PFHE9GOZjcmdUBPAgeLlmX5c9x5ruVkSc6_nPa0jg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D5B3240057;
        Fri, 19 Mar 2021 06:50:08 -0400 (EDT)
Date:   Fri, 19 Mar 2021 11:50:06 +0100
From:   Greg KH <greg@kroah.com>
To:     Thomas Backlund <tmb@tmb.nu>
Cc:     Sasha Levin <sashal@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: stable request
Message-ID: <YFSB3iLXC/DDtN1U@kroah.com>
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu>
 <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu>
 <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
 <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
 <YFNPiHAvEwDpGLrv@sashalap>
 <a39ebdf9-c7c3-990f-3d9d-81f138e55d94@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a39ebdf9-c7c3-990f-3d9d-81f138e55d94@tmb.nu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 07:35:44AM +0000, Thomas Backlund wrote:
> Den 18-03-2021 kl. 15:03, skrev Sasha Levin:
> >
> > On Tue, Mar 16, 2021 at 01:35:40PM +0100, Ard Biesheuvel wrote:
> >> On Tue, 16 Mar 2021 at 13:28, Thomas Backlund <tmb@tmb.nu> wrote:
> >>>
> >>>
> >>> Den 16.3.2021 kl. 14:15, skrev Thomas Backlund:
> >>>>
> >>>> Den 16.3.2021 kl. 12:17, skrev Ard Biesheuvel:
> >>>>> On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
> >>>>>> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
> >>>>>>> Please consider backporting commit
> >>>>>>>
> >>>>>>> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> >>>>>>> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
> 
> 
> >
> > Queued up for 5.10 and 5.11.
> >
> 
> I dont see:
> 86ad60a65f29 ("crypto: x86/aes-ni-xts - use direct calls to and 4-way
> stride")
> 
> in 5.11 queue.

Now added by me, Sasha might have forgotten to push his queue...

thanks,

greg k-h
