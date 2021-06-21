Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB803AEC98
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFUPju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFUPjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 11:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 815C161059;
        Mon, 21 Jun 2021 15:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624289854;
        bh=6g7udVM3Rn6pNWUL3uONkZmWZ5UwgZNkX688o2ivi48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EKGU7+r6Z1M2XdB8u1WjyZD1ZsRYJNWZUb2K4eyxGsfssJWN5Z+ugCZ8GjcsgjHqS
         FoY52LPbzz2uMrQ97gQLum0zrTur3qPgLDF+3gfpimv5a8AnUyAuVUIZMvff3BpoTW
         0d8RxzziU4+oDMOiBeV2Y4RyFzg/sX8VE2Viq0RI=
Date:   Mon, 21 Jun 2021 17:37:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Do not stop recording cmdlines
 when tracing is off" failed to apply to 4.9-stable tree
Message-ID: <YNCyOzrssbHrgeiv@kroah.com>
References: <1624272059104109@kroah.com>
 <20210621112249.0e15c939@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621112249.0e15c939@oasis.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 11:22:49AM -0400, Steven Rostedt wrote:
> On Mon, 21 Jun 2021 12:40:59 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.9-stable tree.
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
> 
> The following should work for both 4.4 and 4.9

Now applied, thanks.

greg k-h
