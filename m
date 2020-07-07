Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700D4216E18
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgGGNxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:53:20 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46685 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbgGGNxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 09:53:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E0175C012B;
        Tue,  7 Jul 2020 09:53:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 07 Jul 2020 09:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=3
        UWNYCaL9LaAOAG1e2hZ4XzUP1ZLzA8EqrEQkH2mItA=; b=jEwr6QVUEbShP/qOi
        WFnjx/erF+pC9Isqc2FHgotVZbduKANhBP6QxmbsKxsHqH1jjii0DvoiYrn/zGBV
        aEzhmgf2pGeFW5RISS3433kVFLzM8EjX3fPiSiDnlO4qloHrvt3MK2mqdSGR1rPU
        beOO59Iy/fVILYVIog+wUpHik3wygGnS+eAJMymFlkSx0BWOTuEI6BYkQtveRdqw
        JUC1tZlhlTBfyzJdTIQ7tZjmLpNFPvsmHsxe/HnB1gE3O5qdD3j/sQ9Ef9k3SzZ5
        UEsNcSussBMhIQBQFUjKDGy1wTmADCWdWVVgkv4QB02j7WlaMdWWCGllLuL+4Gyf
        M5C9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=3UWNYCaL9LaAOAG1e2hZ4XzUP1ZLzA8EqrEQkH2mI
        tA=; b=jpE8oxuUvGi0XFOHvtqV4rVjzjOijRW/OOHMdVYJg2xcA/+ufVri7puUQ
        Lg5WOTPbFkzIIG8RL3VLIo/RuBIYoJooHtzcrP/E93SASV6IBWZfZfefJmj20uXK
        aa9gokx5j0Hm3jSMtD/66WNE91YqZQISX7dumWGNVYXe9GSO09W2OwCivkV4ITH3
        G1yQkM+BxltJUgU4OAYG6RkSqK5AfI9ge+jcdDt5OzJQ1ZupOQAh1tdyBcBmciUT
        nv0Uuw+3vW59w6W6LVpPRSAVldQkHWSMQz9cT2gzbGU6JqpUWBRQhVesGEMLHCwr
        rmQWnYkdQ4MGHJG83kxgXL/GRWq0g==
X-ME-Sender: <xms:T34EXw5hukEwcuuiKYynB1GheeVIVjfFx4ws8lhCIpEkARgEXmLtBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueeuvd
    fhteevfefgfefgjeffueetvdetudfhffekjedvueffheegjeevgfelveenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgpdgrmhgriihonhgrfihsrdgtohhmnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T34EXx4DbFSSjBhomJguJ4eRhwbmNcalSaGsgsBssnyAA_hnr5kF1w>
    <xmx:T34EX_ef0tdo2q4WMlvEQU7jMO-mjea3R4anAujE9TdV3PSzf4cdtA>
    <xmx:T34EX1Jy_Q6MmIvRx3_uRreQ7b8gxnU60g9eAwWkbjJbeOOqCYdPTg>
    <xmx:T34EX7k79nxuqZI2UMIe0AHGtNn-v6_F0bvmPf6GDpwwD1WCv11KtA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B88283060067;
        Tue,  7 Jul 2020 09:53:18 -0400 (EDT)
Date:   Tue, 7 Jul 2020 15:53:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.7.7-3df5764.cki (stable-queue)
Message-ID: <20200707135317.GA4063740@kroah.com>
References: <cki.F7C2FD0653.HR5I5NSB1Z@redhat.com>
 <797274823.1395373.1594128138075.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <797274823.1395373.1594128138075.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 09:22:18AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "CKI Project" <cki-project@redhat.com>
> > To: "Linux Stable maillist" <stable@vger.kernel.org>
> > Sent: Tuesday, July 7, 2020 3:20:30 PM
> > Subject: ❌ FAIL: Test report for kernel 5.7.7-3df5764.cki (stable-queue)
> > 
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: 3df5764655da - Revert "ALSA: usb-audio: Improve frames
> >             size computation"
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/07/07/609686
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
> this seems to be caused by
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.7&id=4773ae0e5c3738779b50e7cb73bf3443b3c84343

Was already dropped, you are fast :)
