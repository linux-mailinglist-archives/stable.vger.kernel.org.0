Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67DF2EA519
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 07:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbhAEF77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 00:59:59 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40581 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbhAEF76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 00:59:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AE66E5C01A5;
        Tue,  5 Jan 2021 00:58:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 05 Jan 2021 00:58:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=vaVwo3J8xC5HYMsISk2N99Sp6kA
        YnhZb1Yjc1iaVLUs=; b=AJW8NF6gfoNzvdFUkOMhCAJGIkzHF/bcatBl1NU/iDc
        Gh8sFhKRmzFPvyONwrKQ/y8tWDvV7HyYYT2d9rqVzpTAL8WMCcfuwEHgqepbm7NI
        3OVWEmU3AXQlvOsZUdkLcCDtBZHUOoQy+180m9KDxEMvA+WOp17qNGGJWhfKDYbr
        RjpPKsD2tktF3PjmHv0bY+Suuje8Q5ccsYDou9eQky+/BkdxcrrooPsct23ZD+QZ
        DGAvlX3wZRyNlB60MCq1JIoTZ6RCRo9XCQ1V23J8tSTj45ufm59oXCE8+RMWdMBG
        smf/rlW9WC+ljTxwPWW3Zei8h5+hjUTC4upDvaS3GVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vaVwo3
        J8xC5HYMsISk2N99Sp6kAYnhZb1Yjc1iaVLUs=; b=E4bViENXuwqF/mQrGWiqW2
        aHHPnbl3kd6t1vHwFPpvjNRE1l2WkicGQOWz8VyyJFMtCnbVfFSpizOr29oUnpxq
        KSK4jaUIHfyBMEkvUKykmCu7aBfuKoVDAZbMZurXmSzQY/EqDHU0QVdBHjcWOjX+
        DneU/zENqBz2/JkN5IU+VKpZr9w1ATjBDV157xGk1pWD+FcCnyRAwo51l8URjckU
        toLPdWry84kJRopMk7f9Xt2k6tNAw/gtwYuWSSr3zy+UEwtcNwoxdXlVWsDci+V9
        5xBcxtml7YbJdtulxzziv2kII3pZxqXelHnSA9QOPIeOcZ+RIZ4CxG8n9GIq95+g
        ==
X-ME-Sender: <xms:GgD0X0CKTx_3ob5My7pGxxHYZbv82nJoXrY1GVJAYP6wHBc2qC5UDA>
    <xme:GgD0X2h5CQbDeXN9c8RD5ol408AYMygnLLu11PmzqgLdIUJ0KEGet_fHOEPXtxXAm
    surC5p9AI6FNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GgD0X3l5XCjPOEVefRf_mdMeHF8JvKemEQie-p0sCZG7Do4GgKbZHQ>
    <xmx:GgD0X6za8XK7EfKW-IXyHXCA6hAELQbZg3R90uNlGUOshfDxkQ2bFg>
    <xmx:GgD0X5RnRDZNseZCqfByckpNRkNK2BXxSg27K-dAyvjvjZxj555WEg>
    <xmx:HAD0X4H_s-KU7CX2KgCRSZoVIRlkAh9PTZICGI749Kq4XupvYPnyyg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46263240057;
        Tue,  5 Jan 2021 00:58:50 -0500 (EST)
Date:   Tue, 5 Jan 2021 06:58:48 +0100
From:   Greg KH <greg@kroah.com>
To:     David Rientjes <rientjes@google.com>
Cc:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Christoph Hellwig <hch@lst.de>, nsaenzjulienne@suse.de,
        geert@linux-m68k.org, sjhuang@iluvatar.ai
Subject: Re: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA
 allocations
Message-ID: <X/QAGHyUfBcsIChZ@kroah.com>
References: <20200925161916.204667-1-pgonda@google.com>
 <20201005130729.GD827657@kroah.com>
 <CAMkAt6qgbO4CqQVxLKU_Tf6bN3numdJHdkc-rck26V68+Y1j9Q@mail.gmail.com>
 <alpine.DEB.2.23.453.2010061100120.51232@chino.kir.corp.google.com>
 <X/MRdPz/POas6FFf@kroah.com>
 <ef6fed57-cbb7-ed8b-6925-cea0fd55df85@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef6fed57-cbb7-ed8b-6925-cea0fd55df85@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 02:37:00PM -0800, David Rientjes wrote:
> On Mon, 4 Jan 2021, Greg KH wrote:
> 
> > > The series of commits certainly expanded from my initial set that I asked 
> > > about in a thread with the subject "DMA API stable backports for AMD SEV" 
> > > on May 19.  Turns out that switching how DMA memory is allocated based on 
> > > various characteristics of the allocation and device is trickier than 
> > > originally thought :)  There were a number of fixes that were needed for 
> > > subtleties and cornercases that folks ran into, but were addressed and 
> > > have been merged by Linus.  I believe it's stable in upstream and that 
> > > we've been thorough in compiling a full set of changes that are required 
> > > for 5.4.
> > > 
> > > Note that without this series, all SEV-enabled guests will run into the 
> > > "sleeping function called from invalid context" issue in the vmalloc layer 
> > > that Peter cites when using certain drivers.  For such configurations, 
> > > there is no way to avoid the "BUG" messages in the guest kernel when using 
> > > AMD SEV unless this series is merged into an LTS kernel that the distros 
> > > will then pick up.
> > > 
> > > For my 13 patches in the 30 patch series, I fully stand by Peter's 
> > > backports and rationale for merge into 5.4 LTS.
> > 
> > Given that this "feature" has never worked in the 5.4 or older kernels,
> > why should this be backported there?  This isn't a bugfix from what I
> > can tell, is it?  And if so, what kernel version did work properly?
> > 
> 
> I think it can be considered a bug fix.
> 
> Today, if you boot an SEV encrypted guest running 5.4 and it requires 
> atomic DMA allocations, you'll get the "sleeping function called from 
> invalid context" bugs.  We see this in our Cloud because there is a 
> reliance on atomic allocations through the DMA API by the NVMe driver.  
> Likely nobody else has triggered this because they don't have such driver 
> dependencies.
> 
> No previous kernel version worked properly since SEV guest support was 
> introduced in 4.14.

So since this has never worked, it is not a regression that is being
fixed, but rather, a "new feature".  And because of that, if you want it
to work properly, please use a new kernel that has all of these major
changes in it.

> > And if someone really wants this new feature, why can't they just use a
> > newer kernel release?
> > 
> 
> This is more of a product question that I'll defer to Peter and he can 
> loop the necessary people in if required.

If you want to make a "product" of a new feature, using an old kernel
base, then yes, you have to backport this and you are on your own here.
That's just totally normal for all "products" that do not want to use
the latest kernel release.

> Since the SEV feature provides confidentiality for guest managed memory, 
> running an unmodified guest vs a guest modified to avoid these bugs by the 
> cloud provider is a very different experience from the perspective of the 
> customer trying to protect their data.
> 
> These customers are running standard distros that may be slow to upgrade 
> to new kernels released over the past few months.  We could certainly work 
> with the distros to backport this support directly to them on a 
> case-by-case basis, but the thought was to first attempt to fix this in 
> 5.4 stable for everybody and allow them to receive the fixes necessary for 
> running a non-buggy SEV encrypted guest that way vs multiple distros doing 
> the backport so they can run with SEV.

What distro that is based on 5.4 that follows the upstream stable trees
have not already included these patches in their releases?  And what
prevents them from using a newer kernel release entirely for this new
feature their customers are requesting?

thanks,

greg k-h
