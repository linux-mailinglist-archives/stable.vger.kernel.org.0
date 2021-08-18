Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD973EFE30
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbhHRHuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237962AbhHRHuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 506476108D;
        Wed, 18 Aug 2021 07:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629272977;
        bh=1aHxR5EU/PhtrJMurL/pCjhdF8phYYiJrB8jb9NT/LY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ceu+QsdpWEKC89Vkj4aKWwcYtGctTq80KsZywjiSyCndLtN3blnszkKYoPoPiQqrU
         qWy1eN/WiUTXe02ufZbJSMCwCyE7l8mg2RcEg9mUI8JGmRV4U1pebninuU+Ylh6Wei
         lT2mpeK/88eMxs39jGJK9UVYGMWPWZRF9vtv/MMw=
Date:   Wed, 18 Aug 2021 09:49:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Make init_fpstate correct with
 optimized XSAVE" failed to apply to 5.4-stable tree
Message-ID: <YRy7j6d0dsz2PbBk@kroah.com>
References: <162480390420065@kroah.com>
 <YRvFIWWdRIg53m3Z@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRvFIWWdRIg53m3Z@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 04:18:09PM +0200, Borislav Petkov wrote:
> On Sun, Jun 27, 2021 at 04:25:04PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Ontop of 5.4.141:

Thanks for all of the backports, now queued up.

greg k-h
