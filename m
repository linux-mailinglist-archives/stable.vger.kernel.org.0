Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A87B30A47E
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhBAJii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232623AbhBAJii (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 04:38:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F9F64EAB;
        Mon,  1 Feb 2021 09:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612172277;
        bh=Q3tWwyAgRUVK7tAtYTrgw3yQXMbg3rYN1vHD1xdk6iA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsl5NZ6widTHlGNgNnBifG1pGRijjymBxBpCqQpDIVxqGb23doDTEhCBOG2bUNtjz
         VdzEaLRW8mUPW+n+NalCoWQk1Q/FjxKPg57fzyPCrSGvJhlQiaZnYgpAG59eKmC3kz
         eR87we6y6M/EkjOCH6jBsi5/jAqAQPW5GaekxgCQ=
Date:   Mon, 1 Feb 2021 10:37:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     Thomas Backlund <tmb@tmb.nu>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, torvic9@mailbox.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: linux-5.10.11 build failure
Message-ID: <YBfL8s138/HvX5Sb@kroah.com>
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
 <9617db49-cf67-3b48-1b31-3bcd34cf3e1a@googlemail.com>
 <20210128160015.phaovyou2m2fgcpi@treble>
 <YBPfQXSrz+P3TOZf@kroah.com>
 <f9f8e2c9-3690-52f3-8d96-4f2b735dd6bd@googlemail.com>
 <YBPtAYK1Nj/WpiTo@kroah.com>
 <20210129151423.rsyubljbrzxicleq@treble>
 <064cf941-e7cb-e939-2bd1-f0dc2850cda7@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <064cf941-e7cb-e939-2bd1-f0dc2850cda7@googlemail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 08:59:09AM +0000, Chris Clayton wrote:
> Hi Greg,
> 
> On 29/01/2021 15:14, Josh Poimboeuf wrote:
> > On Fri, Jan 29, 2021 at 12:09:53PM +0100, Greg Kroah-Hartman wrote:
> >> On Fri, Jan 29, 2021 at 11:03:26AM +0000, Chris Clayton wrote:
> >>>
> >>>
> >>> On 29/01/2021 10:11, Greg Kroah-Hartman wrote:
> >>>> On Thu, Jan 28, 2021 at 10:00:15AM -0600, Josh Poimboeuf wrote:
> ...
> >>>>
> >>>> It is in Linus's tree now :)
> >>>>
> >>>> Now grabbed.
> >>>>
> >>>
> >>> Are you sure, Greg? I don't see the patch in Linus' tree at
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git. Nor do is see it in your stable queue at
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/. For clarity, I've attached the patch which
> >>> fixes problem I reported and is currently sat in https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git As I
> >>> understand it, the patch is scheduled to be included in a pull request to Linus this weekend in time for -rc6.
> >>>
> >>> In fact, I did a pull from Linus' tree a few minutes ago and the build failed in the way I reported in this thread. I
> >>> added the patch and the build now succeeds.
> >>
> >> Ok, sorry, no, I grabbed 1d489151e9f9 ("objtool: Don't fail on missing
> >> symbol table") which is what Josh asked me to take.  I got that confused
> >> here.
> > 
> > I'm probably responsible for that confusion, I got mixed up myself.
> > It'll be a good idea to take both anyway.
> > 
> 
> The patch is now in Linus' tree at 5e6dca82bcaa49348f9e5fcb48df4881f6d6c4ae

Thanks, now queued up.

greg k-h
