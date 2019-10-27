Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7EDE647C
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfJ0RXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:23:06 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39887 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727667AbfJ0RXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 13:23:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 848B322196;
        Sun, 27 Oct 2019 13:23:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 13:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Yq3aIb0UL528sovC97xaUUSKGf5
        yKdSEI8He5l9nOEs=; b=LL5IycF3YbADbW7UzzinrqQv0h1Ufs6KX03wTQc6MfZ
        KNM1nXbSpYyX04BbjwoInfGmf7R+uVzZF+QHwVOMGuYp9TfHER8QZgE76AJHp3Qe
        r0NqrE6TgeBYtN/5sqerk0fHeMYxABlWr3Ppxva555tkh7M+OpCQ7Cmackl6pL03
        Sipygv/WSBYGNnQ3pPDPeuXBoxN62ZHwkS2J9GDnf+IHvs7AAhM0xc6QkEEsD0sU
        NVI+9C9NaxZR58LEXWoWiBAlQrs1Sm9ITPfTlvjoTOFGE2OKgMhdbs6n5TrbO7Ca
        VBPXX4fSdLEs9/6bWVSej4SdUwM+YEsefTuXzg8Ps4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Yq3aIb
        0UL528sovC97xaUUSKGf5yKdSEI8He5l9nOEs=; b=Sy2QZvm5M2akr0HNFTY84y
        lFVTYYmP6czgZwcMpRs5rKLohEL6c071iYYcYmfANbySG3NP49eF+2rCSEnYcMQb
        iOwan/5X+TXPJNR4IkGmHnstgOU0FkunlvUCM15keMLePyVaNuTkKG+Q+TDxJTG2
        m4sd1nDhXncrdUFchaDIMZRGayqY7Z2aUgmj+xSDZ5x2AmKKrKbANU7bwDNEIh5P
        OZkQXi4zZYqdTCDdbDxVpt38a9app8OWP7eduW6ar7TeHnbWz6d2b0RR11RHsn/r
        /cogIxxqsoV9YCESETJG2gJPW29mU/ZEBTbP0AkndQM+ym+dqb/v9gzFsQB+CE5Q
        ==
X-ME-Sender: <xms:edK1XYJV10_OdOMxsB5MhWtL6vNa_kdwnK_ReoJbBBxRdgE7GJ-EJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeejjedrudehkedrhedtrd
    dutddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:edK1XRekR-kMF-fZZVOhVBV5TCsuJ3IXBdc1QtlttAaWDKq6xPan_g>
    <xmx:edK1Xf9Wl07I43s5w-AGo9rkrH2TQe1c1SG18dK3xWjXAWtOxJcOSA>
    <xmx:edK1XWpD3VJ4AOkGBR-S6Zz9ofKCh73QrNni82Ht9IH59hSwQPDuEg>
    <xmx:edK1XQElRH1oCpgfjgnIroW8N5sm0QBXYqsOJ5QT4V7SIqvN9OhCBg>
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2317280061;
        Sun, 27 Oct 2019 13:23:05 -0400 (EDT)
Date:   Sun, 27 Oct 2019 16:58:35 +0100
From:   Greg KH <greg@kroah.com>
To:     "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: stable/4.14.y: kvm: vmx: Basic APIC virtualization controls have
 three settings
Message-ID: <20191027155835.GA2311304@kroah.com>
References: <17bb312d55c6a00e27941e12cf4898fac2d2cb14.camel@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17bb312d55c6a00e27941e12cf4898fac2d2cb14.camel@amazon.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 05:24:44PM +0000, Jitindar SIngh, Suraj wrote:
> The following patch fixes a bug where the guest is still able to access
> the apic registers via mmio once the apic has been disabled.
> 
> 8d860bbeedef kvm: vmx: Basic APIC virtualization controls have three
> settings
> 
> This causes the x86/apic kvm-unit-test to fail when run on a host
> missing this patch.
> 
> Without:
> FAIL: apic_disable: *0xfee00030: 50014
> FAIL: apic_disable: CR8: f
> PASS: apic_disable: CR8: f
> FAIL: apic_disable: *0xfee00080: f0
> With:
> PASS: apic_disable: *0xfee00030: ffffffff
> PASS: apic_disable: CR8: 0
> PASS: apic_disable: CR8: f
> PASS: apic_disable: *0xfee00080: ffffffff
> 
> This patch has been upstream as of v4.18.
> 
> This patch has 3 dependencies which introduce no functional
> change, however they add context which allows the patch listed above to
> apply cleanly.
> 
> c2ba05ccfde2 KVM: X86: introduce invalidate_gpa argument to tlb flush
> 588716494258 kvm: vmx: Introduce lapic_mode enumeration
> a468f2dbf921 kvm: apic: Flush TLB after APIC mode/address change if
> VPIDs are in use
> 
> This patch series should be applied against 4.14.y

Now queued up, thanks.

greg k-h
