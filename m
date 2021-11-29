Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF06461508
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 13:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244925AbhK2Mac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 07:30:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34590 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbhK2M2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 07:28:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B676131C
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B20C53FCB;
        Mon, 29 Nov 2021 12:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638188714;
        bh=vVGXvjPDMi84to5KYib8TrTlpofQ/6VLMri24F/PIhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2Ny2mM+6L78B/lw0pJBcBtnRNgBs6wFuXpd5/YgczUShLRRmxrOH+P0VEL+oVqUa
         8a5673geUU9QV4scX2y9DbO6ZbjqWq/2ezEWtz21dpjobM6w1QcMrw0VsboF6+dfde
         BTX9qG3oTpqzwpMzzLw6760QcOhGez/+nZ0T5A4o=
Date:   Mon, 29 Nov 2021 13:25:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: Patches for stable 5.10 kernel
Message-ID: <YaTGp3Tl1ZYvDaSt@kroah.com>
References: <59ff38c4-8355-ecf6-040d-1234320a806b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ff38c4-8355-ecf6-040d-1234320a806b@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 08:19:18AM +0100, Juergen Gross wrote:
> Hi Greg,
> 
> could you please add the following upstream patches to the stable 5.10
> kernel (I'll send separate mails for the older stable kernels as some
> of the patches don't apply for those)? They are hardening Xen PV
> frontends against attacks from related backends.
> 
> Qubes-OS has asked for those patches to be added to stable, too.
> 
> 629a5d87e26fe96b ("xen: sync include/xen/interface/io/ring.h with Xen's
> newest version")
> 71b66243f9898d0e ("xen/blkfront: read response from backend only once")
> 8f5a695d99000fc3 ("xen/blkfront: don't take local copy of a request from the
> ring page")
> b94e4b147fd1992a ("xen/blkfront: don't trust the backend response data
> blindly")
> 8446066bf8c1f9f7 ("xen/netfront: read response from backend only once")
> 162081ec33c2686a ("xen/netfront: don't read data from request on the ring
> page")
> 21631d2d741a64a0 ("xen/netfront: disentangle tx_skb_freelist")
> a884daa61a7d9165 ("xen/netfront: don't trust the backend response data
> blindly")
> e679004dec37566f ("tty: hvc: replace BUG_ON() with negative return value")
> 

All now queued up, thanks.

But people should be moving to the 5.15 kernel by now and not sticking
with 5.10 anymore for stuff like this.

greg k-h
