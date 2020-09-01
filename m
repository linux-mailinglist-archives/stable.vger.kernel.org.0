Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532D5259210
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgIAPCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:02:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60221 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728316AbgIAPCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 11:02:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C3145C0062;
        Tue,  1 Sep 2020 11:02:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 01 Sep 2020 11:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=O
        U08XTjJa5+kwHSuRa3g3Og6KoUvdBoGgCuw6EwoPKo=; b=KWRlGNm4MnEgsH2ho
        otSFGbCrCGBjR8bLaQ3tZ7r5bfDj1jAJT+xnrl1vdpjX0tQbl/qReZJ0mjjGluvw
        jc5I50jEgCmgCu/rEDSmFTYPDOaPTJFyQheGQE403pgI56elJ1TGSg1+7cKx9MCY
        Po1GLTgcb8qiUXIoTMH76t9JmLkLq3eVADk6lDgF6gAKIXTgqrUL9ubu7uFmFnOA
        iDUFZQR5Hm5GGEFmBkEgwxLh/pR9PAZcZ46Vyz3JZO/dSymFdIPcQu04gfBgWJCO
        9V72wW8b9KEQPGIPplrDR/QFBZmQMSu15AcaBm6tqOosEL5nMCMSl40/AIJK8GVx
        l2U1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=OU08XTjJa5+kwHSuRa3g3Og6KoUvdBoGgCuw6EwoP
        Ko=; b=nTWtf48xuqJBwmWnqppamF1Qvhw5vinUZFq51HEFQUO60iWghPgUcZppj
        IDa6L4mhcr3n2BcCdlB3Bmylme13CpvhFIw2VYNhQHlcQAPVG7EzzUECXnXDL+n0
        0Da86KVVBT3sN9g8Wz3R/ef/cpefBlQdhJhfaofZ0UyZrWtuPBIC8M+9Z7CAUsJn
        rrpHEU8u60UpXSaq7g0v6M1Ue9y43N1OmpvTg1JdFm4n3yXy3Cs42tHX6UKiIJ+h
        c/DA/+RU80cwohn2ozdRoMzC/IhjR2R7bVO6Fdcl8RqncBZMJxL9A5iZYILfQm/u
        45d2/MeovUIiWi9jn7Y7E4I98lwlA==
X-ME-Sender: <xms:lmJOX6wx05Q876hMBlyJiWRlML0lCgWLBlP9xP_CeQIwCOk3CdvdKw>
    <xme:lmJOX2TKElfBdA9c1v5dRS2t3jN26wN5A3CnfH4lkTjjslTs1wAtV3sgh3mTrnNEU
    w60D53PVFqPIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefjedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvdffgf
    euieeuhfehveehtefghedvfeegkeefveeujeeffedtteduteeihfehffdvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:l2JOX8VcZjizwD-RItV6AnI_Rrc8bQRzrGqPYUkTBEh-tkL8anbrGQ>
    <xmx:l2JOXwjqbZtHSRKuUnZxVd1jkcEqt3_5Op5iXISEn65EoMIEhxutfw>
    <xmx:l2JOX8CZs9nbCsyWfy-zMX0N3LM7xBc0w-8MX3hgoKtHxGjeI3fpiw>
    <xmx:l2JOX_MeMNLWklpgm6RsIvCOLrRTruwzYw05xp3eZ-I8o-R7C9J-5g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 318E73280060;
        Tue,  1 Sep 2020 11:02:46 -0400 (EDT)
Date:   Tue, 1 Sep 2020 17:03:14 +0200
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH stable v5.4 1/3] KVM: arm64: Add kvm_extable for
 vaxoricism code
Message-ID: <20200901150314.GA1317670@kroah.com>
References: <20200901094923.52486-1-andre.przywara@arm.com>
 <20200901094923.52486-2-andre.przywara@arm.com>
 <79d6944d383945608b685a2d0f9d9b2c@kernel.org>
 <746764b0-7d63-b154-df02-7ca64a36ffcd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <746764b0-7d63-b154-df02-7ca64a36ffcd@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 12:17:54PM +0100, André Przywara wrote:
> On 01/09/2020 12:12, Marc Zyngier wrote:
> > Hi Andre,
> > 
> > On 2020-09-01 10:49, Andre Przywara wrote:
> >> From: James Morse <james.morse@arm.com>
> >>
> >> commit e9ee186bb735bfc17fa81dbc9aebf268aee5b41e upstream.
> >>
> >> KVM has a one instruction window where it will allow an SError exception
> >> to be consumed by the hypervisor without treating it as a hypervisor bug.
> >> This is used to consume asynchronous external abort that were caused by
> >> the guest.
> >>
> >> As we are about to add another location that survives unexpected
> >> exceptions,
> >> generalise this code to make it behave like the host's extable.
> >>
> >> KVM's version has to be mapped to EL2 to be accessible on nVHE systems.
> >>
> >> The SError vaxorcism code is a one instruction window, so has two entries
> >> in the extable. Because the KVM code is copied for VHE and nVHE, we
> >> end up
> >> with four entries, half of which correspond with code that isn't mapped.
> >>
> >> Cc: <stable@vger.kernel.org> # 5.4.x
> >> Cc: Marc Zyngier <maz@kernel.org>
> >> Signed-off-by: James Morse <james.morse@arm.com>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > 
> > Can you make sure these patches do carry the sign-off chain as we have
> > in mainline? In particular, this is missing:
> > 
> >     Reviewed-by: Marc Zyngier <maz@kernel.org>
> >     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > You can add your own SoB after this.
> 
> Sure, I wasn't sure your review would apply to this version as well. I
> took the backports from James' kernel.org repo, where they were lacking
> any of those tags.
> So shall I copy all the tags from mainline to all backport versions?

Yes.

thanks,

greg k-h
