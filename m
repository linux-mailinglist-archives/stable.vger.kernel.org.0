Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37073D59CC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 14:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhGZMKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 08:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234031AbhGZMKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 08:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B309260560;
        Mon, 26 Jul 2021 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627303871;
        bh=5E31iuk26z3xG7FaPXGyEmUs2Yq4JU4Vl5rNE3gN+I0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G8qYYB1CoZnXPdsJi1brORsjNTFguRjgw9Nqxyw7+t7/ylrKUVwavl7D0tZh+rfk3
         C/E04r9S64j3tdHiquTobqJWCRvQT5hIJG4pgfewPz6Y+S5qRd48GNd1pJdHzPgaYK
         Xl9KJwdUHZxZLa0npcKM0vsegyK5jy9SbRbsF6q4=
Date:   Mon, 26 Jul 2021 14:51:08 +0200
From:   "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>,
        USB list <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH for 4.14] xhci: add xhci_get_virt_ep() helper
Message-ID: <YP6vvN5WyOi4R2TR@kroah.com>
References: <3c42fbd4599a4a3e8b065418592973d9@SVR-IES-MBX-03.mgc.mentorg.com>
 <YP6IzGT6gZNgudI6@kroah.com>
 <9eb2f4a413eb40609f91daf52436cc7b@SVR-IES-MBX-03.mgc.mentorg.com>
 <YP6LkanQfzipHdOR@kroah.com>
 <bfeab6efc5b84cf38aa1c5436d9ce18b@SVR-IES-MBX-03.mgc.mentorg.com>
 <871r7luup8.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871r7luup8.fsf@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 03:26:59PM +0300, Felipe Balbi wrote:
> 
> Hi,
> 
> Schmid, Carsten <Carsten_Schmid@mentor.com> writes:
> >>> May I attach the patches as a file, generated with "git format-patch" meanwhile?
> >>> I fear that I'm not allowed to use "git send-mail".
> >>
> >> For backports for the stable tree, yes, I can handle attachments just fine, you are not the only company with that problem :)
> >>
> > please find the patches attached.
> > 0001-xhci-add-xhci_get_virt_sp-helper.patch.4 for 4.14 and 4.19
> > 0001-xhci-add-xhci_get_virt_sp-helper.patch.5 for 5.4 and 5.10
> >
> > Applied and compiled, not tested.
> > Added Cc: stable@vger.kernel.org in both patches.
> 
> Unfortunately, attachments will not do. You need to send the patches
> themselves as the email. The easiest way is to configure (and rely) on
> `git send-email', then it will do the right thing for you.

For stable patches, I can take these as attachments, especially given
just how b0rked mentor.com's email system currently is :(

thanks,

greg k-h
