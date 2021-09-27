Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E03E4192BD
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 13:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhI0LIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 07:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233943AbhI0LIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 07:08:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DB0760F6B;
        Mon, 27 Sep 2021 11:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632740801;
        bh=yBSQ87k95r3UITMnynR+jKPgnjdqETlEcxPoX3jA1D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qm3bDIpDLoH042MqjAc/J5m/A1t1qMCvxvkOCRy9MRCGQHgyoGHAvbKimxSvBwFes
         nn3dfnyEWzF1L1K7bJQfYEzQpa0elJ4s7wk84zpij2u01vZ/3KVSKPQbxgaRR/HDr9
         aFLI1vXNX/BlNi0NaLkijJyhMyyVsEKQnWgEPV3M=
Date:   Mon, 27 Sep 2021 13:06:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     kabel@kernel.org, lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Increase polling delay to
 1.5s while waiting" failed to apply to 5.10-stable tree
Message-ID: <YVGlvl0QH6HQnCrz@kroah.com>
References: <16317166872028@kroah.com>
 <20210915165243.xaviyv4pwdmk6vhi@pali>
 <20210925214639.3fnbfc5eovd5bzqg@pali>
 <YVBlSNYjASqDizPG@kroah.com>
 <20210926135536.a6g2vxbnporfevvc@pali>
 <YVB+tgg0Dzx/U+Gy@kroah.com>
 <20210926142608.24j5woctzbrfuiso@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210926142608.24j5woctzbrfuiso@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 26, 2021 at 04:26:08PM +0200, Pali Rohár wrote:
> On Sunday 26 September 2021 16:07:50 Greg KH wrote:
> > On Sun, Sep 26, 2021 at 03:55:36PM +0200, Pali Rohár wrote:
> > > On Sunday 26 September 2021 14:19:20 Greg KH wrote:
> > > > On Sat, Sep 25, 2021 at 11:46:39PM +0200, Pali Rohár wrote:
> > > > > On Wednesday 15 September 2021 18:52:43 Pali Rohár wrote:
> > > > > > On Wednesday 15 September 2021 16:38:07 gregkh@linuxfoundation.org wrote:
> > > > > > > The patch below does not apply to the 5.10-stable tree.
> > > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > > tree, then please email the backport, including the original git commit
> > > > > > > id to <stable@vger.kernel.org>.
> > > > > > 
> > > > > > Hello! Below is backport for 5.10 (and probably it should apply also for
> > > > > > older versions):
> > > > > 
> > > > > Hello Greg! Have you looked at this backport for 5.10?
> > > > 
> > > > Ick, I somehow missed this for 5.10.y, thanks for catching it.  I'll go
> > > > queue it up now.
> > > 
> > > Ok!
> > > 
> > > Now I'm checking other aardvark patches and I found out that following
> > > commits marked with Cc: stable tags are not included in 4.14 tree yet:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8ceeac307a79f68c0d0c72d6e48b82fa424204ec
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb461e2bc8b83b7eaca20cb2221e8b940f2189c
> > > 
> > > And this in 4.19 stable tree:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb461e2bc8b83b7eaca20cb2221e8b940f2189c
> > > 
> > > With merge.renamelimit = 24506 these commits applies cleanly for 4.14 /
> > > 4.19 stable trees. Could you look at it, why there are missing?
> > 
> > They are missing because I do not use renames when applying patches like
> > this (we use quilt for the patch queue).
> > 
> > If you can send the updated patches, I will be glad to queue them up.
> 
> Ok. Now I have sent them to stable list.

Thanks, all now queued up.

greg k-h
