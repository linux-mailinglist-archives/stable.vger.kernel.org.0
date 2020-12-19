Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344152DEEC4
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgLSMfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:35:37 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:37513 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbgLSMfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 07:35:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0212C611;
        Sat, 19 Dec 2020 07:34:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 19 Dec 2020 07:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=hnrKJF9nCsAFEOLacZqGkvhRP4r
        9R9StTVLweHpHeAk=; b=1+YLnSjTXYFCW4MZa1CA6PhIxoeSIX2mJpdZYVU3JPl
        kpc1+pDwGYxBgQuTBUWDzEVSgoq612rRPqm0Q9BKIWEnO8iuuQ09Y9pY0HYosGM/
        vIlLKhGS4B0L0/6CFLZriHJz74uB947mwQT1JKlbMWvRl4t+GSgmaMOgM+WnAh/B
        oWj4Lrer7G7v8q77Tl/KqJsuwe5eZd4s7MQWASIZHRFSxr6yLzfOvqBK30hfS4qg
        BbeTpXIL27SSTsbB8BJIAR3xy8O9MqR3lFFFlF79JEIxcqx4NCWJo9P7lAYCMLeM
        +A0rheo8jSqSGTOhV6wl43yOyUR/cjnZu+ZNm3rF2FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hnrKJF
        9nCsAFEOLacZqGkvhRP4r9R9StTVLweHpHeAk=; b=TGPBaQ7ScUmClxEawiUH0Y
        IjIdbYeAXrT3t8mCZdlEdiK2DiU1VoJmmw5thcR0iref13HFXilB0wzFbiN03T4B
        Ed7/79BUCHtiBo59nBMlC+w+olBA/Dfb4EhmzCFZ9l9TfEv9e76bSK4Nug1H7bqB
        +gT6j1hbGaKJKBYSBUGTF9B/BPV09+F979eNTrxg686kbsfohCgwAYmw0U9GuedC
        L8d4P2ezi4y+VNPLju1LOm17q+j+rvw56Gkr/HnG0Y43AryXSWETcozEQTAQ80YJ
        ldQwRuV/8q96nLz0jbbOVq1/6PR2xiSefadXl5gLk2J+2kCwL+kSe6Rq7l2biHfg
        ==
X-ME-Sender: <xms:aPPdX7NSL26NyujxdjzUXZPhJU8KcL_kuh5FLiruX8s_0KP9i1x6Yg>
    <xme:aPPdX18kbS15TXO2oCdcnvKfjnjH4lFGGbgLm5juztLO-nIWbfPz8PuQAKcJte_tt
    Ay6QQlgf9gTgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudelkedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:aPPdX6QuGkfvAA-HTbm7vrghisOE3YBg1nToCFNTt29u6tHUfSglow>
    <xmx:aPPdX_ufIEgWN_mS6nqHfDud2sQl4lB_UJ2LYicTHftYLUU54gTkIw>
    <xmx:aPPdXzdkR2cJL5FCOqzaCnME3DQHwF-siVGUKnjO2ZFhKsTK5BiX4g>
    <xmx:afPdX1uEdHDY3IKYc5NNRPAT2SurNUC_K-qSuNwJUdkk_YRjKLUTHA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A2D91080059;
        Sat, 19 Dec 2020 07:34:48 -0500 (EST)
Date:   Sat, 19 Dec 2020 13:36:09 +0100
From:   Greg KH <greg@kroah.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half
Message-ID: <X93zudCcewJp8n5S@kroah.com>
References: <1607955408254166@kroah.com>
 <8bf9d5caf338d705744764c60256ace1d3f1d252.1608168540.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf9d5caf338d705744764c60256ace1d3f1d252.1608168540.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 17, 2020 at 02:46:13PM +0100, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> cleaned up the computation of MMIO generation SPTE masks, however it
> introduced a bug how the upper part was encoded:
> SPTE bits 52-61 were supposed to contain bits 10-19 of the current
> generation number, however a missing shift encoded bits 1-10 there instead
> (mostly duplicating the lower part of the encoded generation number that
> then consisted of bits 1-9).
> 
> In the meantime, the upper part was shrunk by one bit and moved by
> subsequent commits to become an upper half of the encoded generation number
> (bits 9-17 of bits 0-17 encoded in a SPTE).
> 
> In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
> has changed the SPTE bit range assigned to encode the generation number and
> the total number of bits encoded but did not update them in the comment
> attached to their defines, nor in the KVM MMU doc.
> Let's do it here, too, since it is too trivial thing to warrant a separate
> commit.
> 
> This is a backport of the upstream commit for 5.4.x stable series, which
> has KVM docs still in a raw text format and the x86 KVM MMU isn't yet split
> into separate files under "mmu" directory.
> Other than that, it's a straightforward port.
> 
> Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [Reorganize macros so that everything is computed from the bit ranges. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> (cherry picked from commit 34c0f6f2695a2db81e09a3ab7bdb2853f45d4d3d)
> Cc: stable@vger.kernel.org # 5.4.x
> ---
>  Documentation/virt/kvm/mmu.txt |  2 +-
>  arch/x86/kvm/mmu.c             | 29 ++++++++++++++++++++---------
>  2 files changed, 21 insertions(+), 10 deletions(-)

Thanks for both backports!

greg k-h
