Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864AD18040B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 17:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgCJQz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 12:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgCJQzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 12:55:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D545D20675;
        Tue, 10 Mar 2020 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583859355;
        bh=wEA89Y/i/pO8iZvIjVQ2KZgLccQomkZh1pTDz1tPk10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBDwhUDd+fMu377Urjwihg9jdUAvnykBi8q26nDuu+satceJEKD2oR7Kaxb1pOWcK
         zeM/NP4W/WGiB+HmRoWCfkKatpkhJxjBY1KjekUqVVFqC4kc96357ZW8hduVuBJlJN
         +S5elPBe+rPefLS9lk+jTRVnyAtRji/9UQ9KHYbU=
Date:   Tue, 10 Mar 2020 17:55:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     Thomas Voegtle <tv@lio96.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 62/88] x86/boot/compressed: Dont declare
 __force_order in kaslr_64.c
Message-ID: <20200310165552.GA3468294@kroah.com>
References: <20200310123606.543939933@linuxfoundation.org>
 <20200310123621.868809541@linuxfoundation.org>
 <alpine.LSU.2.21.2003101522120.20206@er-systems.de>
 <20200310150845.GA16975@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310150845.GA16975@zn.tnic>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 04:08:45PM +0100, Borislav Petkov wrote:
> On Tue, Mar 10, 2020 at 03:33:57PM +0100, Thomas Voegtle wrote:
> > This ends up for me in:
> > 
> > arch/x86/boot/compressed/pagetable.o: In function
> > `initialize_identity_maps':
> > pagetable.c:(.text+0x309): undefined reference to `__force_order'
> > arch/x86/boot/compressed/pagetable.o: In function `finalize_identity_maps':
> > pagetable.c:(.text+0x41a): undefined reference to `__force_order'
> > 
> > 
> > pgtable_64.c doesn't exist in v4.9 for x86.
> > 
> > So I guess it's not correct to remove __force_order from pagetable.c?
> 
> Yes, the second __force_order thing was added by
> 
> 08529078d8d9 ("x86/boot/compressed/64: Detect and handle 5-level paging at boot-time")
> 
> which is 4.14.
> 
> Greg, pls drop this patch from the 4.9 lineup.

Now dropped, thanks.

greg k-h
