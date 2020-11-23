Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0347F2C048E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 12:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgKWLaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 06:30:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgKWLaT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 06:30:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE2120738;
        Mon, 23 Nov 2020 11:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606131019;
        bh=S74ErAM6y2Gm6X7nT5HlbUHx7ha8pcbLfjO44ZcTAMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mQYomtWdUGcrUCja6gmGLWSMy6BBV48vteuKRxNuurLcEJusFCoblc5JnH78rx1TM
         AlJPLpvhmiATobFHEpDQ1/25bOBRsylXntz6K73Fiha6SvFAtao7UmFQCL/bZG9HgY
         O0cmD7h3KzsPE0Bwt9oL58NrXQWt31Ds63IT+Sic=
Date:   Mon, 23 Nov 2020 12:31:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     yu.c.chen@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/microcode/intel: Check patch
 signature before saving" failed to apply to 4.9-stable tree
Message-ID: <X7udkZ67JN89UW5N@kroah.com>
References: <16061247634917@kroah.com>
 <20201123105030.GE29678@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123105030.GE29678@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 11:50:30AM +0100, Borislav Petkov wrote:
> On Mon, Nov 23, 2020 at 10:46:03AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> ---
> From: Chen Yu <yu.c.chen@intel.com>
> Date: Fri, 13 Nov 2020 09:59:23 +0800
> Subject: [PATCH] x86/microcode/intel: Check patch signature before saving
>  microcode for early loading
> 
> Commit 1a371e67dc77125736cc56d3a0893f06b75855b6 upstream.

This, and the 4.4.y backport, now queued up, thanks.

greg k-h
