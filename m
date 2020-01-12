Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CDA1386C2
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 15:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbgALOCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 09:02:23 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59229 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732953AbgALOCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 09:02:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7951B21FF3;
        Sun, 12 Jan 2020 09:02:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 12 Jan 2020 09:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=NJHVvAW6H45CORrSOrRuKfIQ+gp
        hAzjARjRdpy0mtZU=; b=ofuU86puPMAxtQzA1HSo5IrkN3wwdhjS1hZYNjCYcof
        LCGwJyy9qDOYYqZOJ94o+MriK+60V/vqf4Ga1N6aiJajuhe+I32/mgQF/jbQZptN
        MNj00JiTuUMTv3dyuFjMxJBcARFZFmRJcCZt7VGiSpzVIB37D7RdNjdM/sbm/3t6
        KCU6WLd0gzPP5IX3VUhbWGAITGu5SQW8QF4jFvnAawK9f8sjqTKKhL02Kyu64/q6
        +s4lzIjvq6UnmI7n588vgHHUxJ0gobmPVL+dc9Dxs9pr5PdiTG0OtT4DGKnnldv7
        6HSq+wyP83zeUn07R7aHfxgFF4Q3gu4SHtI9neg9ARg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NJHVvA
        W6H45CORrSOrRuKfIQ+gphAzjARjRdpy0mtZU=; b=cYzxR5UWGSFLtYh27kOQii
        6R4dp5H2kabSo57qlG6K031/ON7fEXKaNMaxEo9d0RwbHTeajqdAWcRL4hbmhGnH
        Eaxxh+b7PJEFvLz+4FkUqkgWHPlNnWQvF/MctRjYYIeCdoLqI0EJ0h0oBTaVtUcs
        vq7r+JiRovKZANDjhIDf+LgfanLEk57xYZZcC5vEyhAzIWAnKYbXse9HKJiR+qzg
        c3IiHclubyHj8LUkB5Twh9HiFahBnnM9AbNcaW+AvkdarS1SFBuRPUkGVB0dRvGa
        rDsaHNayn+hVqz00+CkZ5JSiHOv4fPUcz4qqAxq3udz5W/89pKgTRXJPChRMLzPQ
        ==
X-ME-Sender: <xms:7CYbXmgzj8tYjkQk0VeFa8mG-T7FRCoynFDPPpdcccZ-2uvUTA7uLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeikedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:7CYbXmWBMQngVZt3grB6kqf6PLtAQAG6bcHL8_HvrT0sQpHnD1gb5A>
    <xmx:7CYbXlCQuXf3rWRW9Cl4YYqk8V3VIKDWvKQSridujQr1Bg2Wq8DFCA>
    <xmx:7CYbXqkXDzt0C2SVctkFJeWJBKj_Pl7droBrJJ7ET4feQlu-OTOZVQ>
    <xmx:7SYbXlDY7op9ooJpZqIncmA_Y9SaQ6p0yhj0y3Xt794nNmUtUagnJg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6ABE880062;
        Sun, 12 Jan 2020 09:02:20 -0500 (EST)
Date:   Sun, 12 Jan 2020 15:02:18 +0100
From:   Greg KH <greg@kroah.com>
To:     Jari Ruusu <jari.ruusu@gmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Fix built-in early-load Intel microcode alignment
Message-ID: <20200112140218.GA902610@kroah.com>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <CACMCwJ+FE8yD10VF07ci6tTqiBA8aBejKQT0EwyayQQOrLGUKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMCwJ+FE8yD10VF07ci6tTqiBA8aBejKQT0EwyayQQOrLGUKQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 12, 2020 at 03:03:44PM +0200, Jari Ruusu wrote:
> On 1/12/20, Jari Ruusu <jari.ruusu@gmail.com> wrote:
> > Intel Software Developer's Manual, volume 3, chapter 9.11.6 says:
> > "Note that the microcode update must be aligned on a 16-byte
> > boundary and the size of the microcode update must be 1-KByte
> > granular"
> >
> > When early-load Intel microcode is loaded from initramfs,
> > userspace tool 'iucode_tool' has already 16-byte aligned those
> > microcode bits in that initramfs image. Image that was created
> > something like this:
> >
> >  iucode_tool --write-earlyfw=FOO.cpio microcode-files...
> >
> > However, when early-load Intel microcode is loaded from built-in
> > firmware BLOB using CONFIG_EXTRA_FIRMWARE= kernel config option,
> > that 16-byte alignment is not guaranteed.
> >
> > Fix this by forcing all built-in firmware BLOBs to 16-byte
> > alignment.
> 
> Backport of "Fix built-in early-load Intel microcode alignment"
> for linux-4.19 and older stable kernels.

Any hint as to what that git commit id is?

thanks,

greg k-h
