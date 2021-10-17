Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7614309EF
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 17:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhJQPGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 11:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237285AbhJQPGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 11:06:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7689460E0C;
        Sun, 17 Oct 2021 15:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634483078;
        bh=EbBTYJcLkH/85C9leqg5jvqhRTMYbFXbPjvCQTbQNuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SsplXRX9uvg8UlsSxjcgUJ01NzagICRNkPizw6MUcC29PnIuP8jDJR2ARhyLOvuZl
         mQ9E4vnelLNdn9yimCsbAPEO65tYp3iTfgTX1W15h1Cm0HfZzlnx42kida+2CDbI2M
         CCPBfmd36lpU1OR2Ue35VTk5BKpChazuYk4Nx+eA=
Date:   Sun, 17 Oct 2021 17:04:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     james.morse@arm.com, reinette.chatre@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/resctrl: Free the ctrlval arrays
 when" failed to apply to 5.14-stable tree
Message-ID: <YWw7hF5nJFcI77Er@kroah.com>
References: <163393835419833@kroah.com>
 <YWcZoRc37rhOm3iA@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWcZoRc37rhOm3iA@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 07:38:41PM +0200, Borislav Petkov wrote:
> Hi,
> 
> On Mon, Oct 11, 2021 at 09:45:54AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 64e87d4bd3201bf8a4685083ee4daf5c0d001452 Mon Sep 17 00:00:00 2001
> > From: James Morse <james.morse@arm.com>
> > Date: Fri, 17 Sep 2021 16:59:58 +0000
> > Subject: [PATCH] x86/resctrl: Free the ctrlval arrays when
> >  domain_setup_mon_state() fails
> 
> here's a backport against 5.14. It applies on all except 4.19. That one
> needs only a file rename, see second patch below.

Now queued up, thanks.

greg k-h
