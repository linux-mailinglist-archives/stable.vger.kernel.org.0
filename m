Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4FD15F891
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgBNVRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgBNVRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:17:02 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C2ED217F4;
        Fri, 14 Feb 2020 21:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581715021;
        bh=BfealBM6LSQ9+L9BIzxBQnxqU7jdKmkvRz0UMK4kwHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zWX5D07Gb1jxpv4IXJ4BPqyHcvICOiP0zEImHLneuFL57tCUH73/fPJWhej4DucYg
         awalMAyOeCGpAcneB5unXDDY9Iljyv7abKcEfPLFBwj5kS/JPg8wlydlMu2IGXpiWu
         m3bJ+oCh4U293zdo/P2kRMjm7IWGxipSuRGgniU0=
Date:   Fri, 14 Feb 2020 15:41:56 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org,
        X86 ML <x86@kernel.org>, Yazen Ghannam <Yazen.Ghannam@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce/amd: Fix kobject lifetime
Message-ID: <20200214204156.GA4086224@kroah.com>
References: <20200214082801.13836-1-bp@alien8.de>
 <20200214083230.GA13395@zn.tnic>
 <20200214151727.GA3959278@kroah.com>
 <20200214201143.GQ13395@zn.tnic>
 <87a75kud8o.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a75kud8o.fsf@nanos.tec.linutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 09:26:31PM +0100, Thomas Gleixner wrote:
> Borislav Petkov <bp@alien8.de> writes:
> 
> > On Fri, Feb 14, 2020 at 07:17:27AM -0800, Greg KH wrote:
> >> Does not bother me at all, it's fine to see stuff come by that will end
> >> up in future trees, it's not noise at all.  So no need to suppress
> >> stable@vger if you don't want to.
> >
> > Ok, but what about your formletter which you send to people explaining
> > this is not how you should send a patch to stable?
> >
> > Like this, for example:
> >
> > https://lkml.kernel.org/r/20200116100925.GA157179@kroah.com
> 
> This once Cc'ed stable but lacked a Cc: stable tag in the changelog.

Exactly :)
