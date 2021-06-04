Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C5539B4E8
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 10:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhFDIe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 04:34:56 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:34537 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhFDIez (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 04:34:55 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 2FB4B10FD;
        Fri,  4 Jun 2021 04:33:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 04 Jun 2021 04:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=0QaX15AhSJWfHsnr5gihB3yVDuh
        8b9trAJVDVBkiUD4=; b=CnkrDlNGkGa4MOf2Cy06uaBzfIbQe7fGKLCuRMAGOi1
        n/iQBiw/FoYn/spSiV5q01C4jk+qfBhD8KvHHfvAlczcbcOgnddxWwrJTf02tbBf
        F1o+LC7edEtdOAjDfxL2sbObcArkCRl4O67uYtFkwmNULRCKbbV7VX9q3zyzqU4N
        oHzG14bnUgMPMJJ7acQqP70B4y/hHDZs80UvKbB2e4K2AXdZJF0qBW55A4VLyZjT
        oH7/8XZwc8FSXKU3CdxFt+J3yLWfi23B1XdWTPPXhXdGTinu+gJakGFiF53uBLLi
        02OlyFztYOsWt7G6aZdzBDoOf3oGft5z9nkp+KZl2HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0QaX15
        AhSJWfHsnr5gihB3yVDuh8b9trAJVDVBkiUD4=; b=G2rVdkeh8vMSGKkpyvbRJt
        5g3hydXtZI85c0lsB9xcDuc1M1HPQQ6F1EmAww/hE8x0nDodsLDrYl5bR+KIp2Ht
        h3TOTJdqCEuz3A2lR711pWzw10nEcRSvEh0D7nOKZz0sSaqb8f3qObGU/Gyx/g9k
        eJpcIIALi9p4nMm/AnoNP8pAfj+1fhJ9JrpM0iQn+zCvKxTCKInURsDhCDxkkscK
        vRue5NBD5qkOFVBD+1FBlqUBhTHAWjhJZD1M1Y2LiuMFPkLrQVQ6gsYgK1BpPDCI
        3aDTPQ1KYQD/pCaAwZYl2JYhTC+xRXPjiieHEDoB94dOqxZWPCJqQYkgXNMllnfQ
        ==
X-ME-Sender: <xms:QuW5YBMFfkAZpEeNW-Y9EAviOKSYjtxM7_J6HQ5i4fss82b3Ls66hA>
    <xme:QuW5YD9XsR3aV32Vx29taDVe7KJYazGG_SkEoEfs4wVkVl12NDfxCD_cBB6ehIsQb
    LG0trTl7Ah3oQ>
X-ME-Received: <xmr:QuW5YAQYWQBZ3fwBNvuGrVaWi_F6OVh6sa0-zGGObjPK7KQH_7MynB_gcbvtn9xgp8DbkLW1sXXEQiAm-pwdy5NCNztoop7r>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtuddgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:QuW5YNs9FhIFWoLNTZAMkssAER8XpFd1neOO87s5ONtSB60jIjgZeA>
    <xmx:QuW5YJfcMtvh1Jk2wNEsocJBuzr4bKgz1SNVnL7f94yzqLLPd5Le1w>
    <xmx:QuW5YJ0y8tRQTawilnv76UEWNBGYXis9TxNUUi4X19VxDTAlNbZAqw>
    <xmx:Q-W5YP-HI2XWXwWtpg-fcB6Mde4_azUEyCWDEeRLhhGZtERNLbWFJLxgBoY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Jun 2021 04:33:06 -0400 (EDT)
Date:   Fri, 4 Jun 2021 10:33:03 +0200
From:   Greg KH <greg@kroah.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Jaegeuk Kim' <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Daniel Rosenberg <drosen@google.com>,
        Chao Yu <chao@kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Message-ID: <YLnlPxfCVJD+p6/a@kroah.com>
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-3-drosen@google.com>
 <YLlj+h4RiT6FvyK6@sol.localdomain>
 <YLmv5Ykb3QUzDOlL@google.com>
 <4f56f2781fac4b8bac1a78b0fecc318d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f56f2781fac4b8bac1a78b0fecc318d@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 08:27:32AM +0000, David Laight wrote:
> From: Jaegeuk Kim
> > Sent: 04 June 2021 05:45
> ...
> > > > @@ -161,6 +161,9 @@ static ssize_t features_show(struct f2fs_attr *a,
> > > >  	if (f2fs_sb_has_compression(sbi))
> > > >  		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > > >  				len ? ", " : "", "compression");
> > > > +	if (f2fs_sb_has_casefold(sbi) && f2fs_sb_has_encrypt(sbi))
> > > > +		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > > > +				len ? ", " : "", "encrypted_casefold");
> > > >  	len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > > >  				len ? ", " : "", "pin_file");
> > > >  	len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
> 
> Looking at that pattern, why don't you just append "tag, "
> each time and then replace the final ", " with "\n" at the end.

Again PLEASE NO!

This is not how sysfs is supposed to work and do not perpetuate this
mess in any way.

greg k-h
