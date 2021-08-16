Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA503ED089
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhHPIuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234025AbhHPIuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 777F261B30;
        Mon, 16 Aug 2021 08:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629103792;
        bh=u4EsUZR5sTm5h7E6N0yNCgwY3NIzpQx8mNnm1uC8cmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qxfPAkf0aeJzygP6r8PJ9epy47NXb1O6qnxNtChCMsHpv9BCBP2uoXZbesrLVUGmp
         MExolDa0DnqynsRtQr8ueAS/23U529+P4usip05bdRiwd/gk7K7nqnqe00Np84eJ+w
         fNXT4rG57Jyvbr1GzTW5UKcli7LtYOFAJfpHZg3E=
Date:   Mon, 16 Aug 2021 10:49:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 5.10 12/19] vboxsf: Make vboxsf_dir_create() return the
 handle for the created file
Message-ID: <YRomrk0se9NKg/0y@kroah.com>
References: <20210813150522.623322501@linuxfoundation.org>
 <20210813150523.032839314@linuxfoundation.org>
 <20210813193158.GA21328@duo.ucw.cz>
 <26feedff-0fb4-01db-c809-81c932336b47@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26feedff-0fb4-01db-c809-81c932336b47@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 15, 2021 at 03:57:24PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 8/13/21 9:31 PM, Pavel Machek wrote:
> > Hi!
> > 
> >> commit ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 upstream
> >>
> >> Make vboxsf_dir_create() optionally return the vboxsf-handle for
> >> the created file. This is a preparation patch for adding atomic_open
> >> support.
> > 
> > Follow up commits using this functionality are in 5.13 but not in
> > 5.10, so I believe we don't need this in 5.10, either?
> > 
> > (Plus someone familiar with the code should check if we need "vboxsf:
> > Honor excl flag to the dir-inode create op" in 5.10; it may have same
> > problem).
> 
> Actually those follow up commits fix an actual bug, so I was expecting
> the person who did the backport to also submit the rest of the set.
> 
> FWIW having these patches in but not the cannot hurt.
> 
> Hopefully the rest applies cleanly, I don't know.
> 
> To be clear I'm talking about also adding the following to patches
> to 5.10.y:
> 
> 02f840f90764 ("vboxsf: Add vboxsf_[create|release]_sf_handle() helpers")
> 52dfd86aa568 ("vboxsf: Add support for the atomic_open directory-inode op")
> 
> I have no idea of these will apply cleanly.

They do, now queued up, thanks.

greg k-h
