Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2F25D459
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 11:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgIDJLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 05:11:32 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57581 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729950AbgIDJLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 05:11:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 63AD05C011B;
        Fri,  4 Sep 2020 05:11:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 04 Sep 2020 05:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=s5gk5YFkeaPQ3bX+HOeg0ubey+b
        iZjiNj4OPkfU0458=; b=XVHksBg33s+hGrQa/+llqkI4o9zuzgQOvHCNrgKGbzr
        CB7PhDI3NMi7zYC/Bzb7cTFmeL2UhAa/miEPVd1iYtVkwhBhbSqYfBkcc9oAuqfj
        riCXpthbd/sSsDIuVZKUow4Rk9f8sxlMzjSnxqsRx6C6xrgxgc4geLhyhey06HQO
        D2eYKXwSek+rra9qo1CfObnY45rbIeGReqVfzDCqAVJnvL4xaL8j8z9x+cLWPGe+
        Jx58m/1TWl5UgXgU3kFrB4qk5jUoaW+YaJ7jMhprMC6vNw6jWXB4eqnSYJr0Qlbe
        mRc3/r5xNMygXgu0qOeS6h7GO7sPF3GAf3fnmPcmzDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=s5gk5Y
        FkeaPQ3bX+HOeg0ubey+biZjiNj4OPkfU0458=; b=NQwjyEigza+rV79vWPkeGk
        JrIWb0+F6+6vMv5SiARh/HXA/Y3eCC1BtkkjlqMVcK6mMZUL9QXdvAfUoHCQXcnO
        k3r2LXnftK+xEAOkVkUH0OepjWMzLBH/cV33gW05Tkx9cNuWIDmeeJgs2KnmMpNu
        DN7GdcA+7lFK6SySYPTegpU+XGjTo446oGJpSgWfyoVJ/r/VdG5IpJc3C19ozAW8
        VnHi9KzlZtpzZ+g6H3l982CZxeEg+5051tSwiURlfFdHUKMtiL9tbtbDC756yntE
        yHepblO34G9+w8uYbQIIWGoMktp00xOO/t4VfrYA1UuDPQzvrEZlsz6S1e9QI91A
        ==
X-ME-Sender: <xms:wwRSX9bAJPeYrQbVywf6GE_1eU9pWimsuKIuGvkz9DoDgJxAy9OOCw>
    <xme:wwRSX0Z7JOH9AjcZ6Eycc5sZGBXxrn3XIqer6PPQi8gcVqMzyQBoV4KeYTYlPsfiC
    1TwGUfcugMSNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegfedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wwRSX_-4MfN_mExR_NqXZXrGfkKe0_S-N9y4H-EdnpCVIR69dckrfA>
    <xmx:wwRSX7pKWCocZC1DGhT-n53wiljW900q40bYXXxwxaaYJ8kACQesJw>
    <xmx:wwRSX4qxdsb_hSD4_4dZBipvNSFJdRzZsKO1MFBe_IQlZenNA7pvZQ>
    <xmx:wwRSX_2lTmmIPz-NydXTiT80nX6wVRTvd-e8ozYGuhdE1e9zdhtXoQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB0B3328005D;
        Fri,  4 Sep 2020 05:11:30 -0400 (EDT)
Date:   Fri, 4 Sep 2020 11:11:50 +0200
From:   Greg KH <greg@kroah.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH stable v5.8 v2 0/2] KVM: arm64: Fix AT instruction
 handling
Message-ID: <20200904091150.GA2536101@kroah.com>
References: <20200902092904.122477-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902092904.122477-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 10:29:02AM +0100, Andre Przywara wrote:
> Changes from v1:
> - (Re-)adding Marc's review tags from upstream. Differences to the
>   original patches are trivial for 2/2, and straight-forward for 1/2.
> - Fix spelling of vaxorcism
> -------------

Now queued up, thanks.

greg k-h
