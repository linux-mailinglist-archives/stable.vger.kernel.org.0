Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5071B2E9568
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbhADNAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 08:00:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44367 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbhADNAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 08:00:17 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AA0E5C00F3;
        Mon,  4 Jan 2021 07:59:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 04 Jan 2021 07:59:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=SGDnnCt0uFTHOCWQ0LWPQYmStfb
        uZROYTvcicN80T3A=; b=LWS7aA5Xw7GukcoE3nTpGKYpJ5EPifOCGqYGedCqNcE
        gb8EE7EjdVl9zJsceO3vr2FeVrJ4D6qqJ45qhmH3ZeI9g+MNzHml4i0T/W4tF2lX
        ufEzTzqHmeW9FIt39t9AFMHQ/xUOq6HqRzyP93z6egrFVPq7rwpJfvLQy2abGpnr
        Z4PxevNPCle0zZ9zLq4X2qJOavkdkK5Rej/JSGEnPiI+CBzO+kdE/EuZTJgb1u5q
        QrwrTsXE4O2G3JUC8yPp6im8ALIVH2c50e5qENP5r3oXzPBmSPKr2YoFkz3gxOlp
        xdLJUXVJQuk0M3GzglVXcGlQ3JAjUFBndBtbvu/5brw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SGDnnC
        t0uFTHOCWQ0LWPQYmStfbuZROYTvcicN80T3A=; b=JPdVZ8EBYnV+2Z+gNzLEEJ
        OZpNpliMIDozSzoPGWEbxa+xj3h3PXtBsRt6G3VmD00KgtKn+cwlXro2gKPKNieK
        OHTCxv6OXVMe4Io6MDUn+60RUta2zO/GlTyCs+ipEkKgE9P1rXchIQ/Ctlqn5lQH
        7r+Sql10YLlk3zeP28QoopWay59cxEXBG/RqE1WOMr1Reaa5SwGTM8HfXjnIXTm1
        4489CpHxSBxTIIOT9OowJ7RdEigAzeG/0fR9GTuCyP0R7TbCIz8l7XTXHM2pansw
        PqC6B9EHFwCKKxtWgACX72cVBNkrTOrz+VPu1jH8OaqKWDBrhfc2XFHNQ+9yvmzg
        ==
X-ME-Sender: <xms:HRHzX3YA52wvuLW_LucLWilpUOtFo4vjkQph9neo_INA_Mjw3aiK2w>
    <xme:HRHzX0NErYIx_evx2Mr1wdDDea3TaOLaMU2IxEMcCKW0WSCkTNMCMFlJf0-kWCP2Z
    ZJasrWAPZfdJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeffedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:HRHzX0Z4HwTkCaoj27ZcjihQs68LB2-V0AyUK-lIh21-Qqthg0df6g>
    <xmx:HRHzX61nk-p3rEpwIjN8A3aVVywvEUlNk1Wt3b2o8CMbwaahU-1qKA>
    <xmx:HRHzXyemT3H4zAuGHn-kEeZ2b18ItimfEZY12W9Y47zEY8A25NSLmw>
    <xmx:HxHzX1VGtqgiD1sWGAn0OwgL85WTX4VK1OgaUbiGTIuCZue87N-DZQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 698C024005A;
        Mon,  4 Jan 2021 07:59:09 -0500 (EST)
Date:   Mon, 4 Jan 2021 14:00:36 +0100
From:   Greg KH <greg@kroah.com>
To:     David Rientjes <rientjes@google.com>
Cc:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Christoph Hellwig <hch@lst.de>, nsaenzjulienne@suse.de,
        geert@linux-m68k.org, sjhuang@iluvatar.ai
Subject: Re: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA
 allocations
Message-ID: <X/MRdPz/POas6FFf@kroah.com>
References: <20200925161916.204667-1-pgonda@google.com>
 <20201005130729.GD827657@kroah.com>
 <CAMkAt6qgbO4CqQVxLKU_Tf6bN3numdJHdkc-rck26V68+Y1j9Q@mail.gmail.com>
 <alpine.DEB.2.23.453.2010061100120.51232@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2010061100120.51232@chino.kir.corp.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 11:10:41AM -0700, David Rientjes wrote:
> Thanks Peter.
> 
> The series of commits certainly expanded from my initial set that I asked 
> about in a thread with the subject "DMA API stable backports for AMD SEV" 
> on May 19.  Turns out that switching how DMA memory is allocated based on 
> various characteristics of the allocation and device is trickier than 
> originally thought :)  There were a number of fixes that were needed for 
> subtleties and cornercases that folks ran into, but were addressed and 
> have been merged by Linus.  I believe it's stable in upstream and that 
> we've been thorough in compiling a full set of changes that are required 
> for 5.4.
> 
> Note that without this series, all SEV-enabled guests will run into the 
> "sleeping function called from invalid context" issue in the vmalloc layer 
> that Peter cites when using certain drivers.  For such configurations, 
> there is no way to avoid the "BUG" messages in the guest kernel when using 
> AMD SEV unless this series is merged into an LTS kernel that the distros 
> will then pick up.
> 
> For my 13 patches in the 30 patch series, I fully stand by Peter's 
> backports and rationale for merge into 5.4 LTS.

Given that this "feature" has never worked in the 5.4 or older kernels,
why should this be backported there?  This isn't a bugfix from what I
can tell, is it?  And if so, what kernel version did work properly?

And if someone really wants this new feature, why can't they just use a
newer kernel release?

thanks,

greg k-h
