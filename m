Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D4B141E2C
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgASN2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgASN2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 08:28:16 -0500
Received: from localhost (unknown [84.241.197.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F272053B;
        Sun, 19 Jan 2020 13:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579440495;
        bh=nvAre70wOdY3sLAD40GwTa3vY5f50vzWLmhparXnoi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RilBkiyAZe8b9059GqCS8KVCrB+pNMzdX1/8yq09SNsgzNcZiPc+j5KsvxEhJk1VL
         YpXLBKLgEb75/LRNg52PCjYbofqK+vahIrfBJe79s6eaCNHOfNjphhBhK7W7VMyGT4
         uqfVm52fAsjFGDTaRz6lB0KP6/5REaNkDu0KAN/M=
Date:   Sun, 19 Jan 2020 14:28:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Vince Weaver <vincent.weaver@maine.edu>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        stable kernel team <stable@vger.kernel.org>
Subject: Re: [PATCH, v5.4] perf: Correctly handle failed perf_get_aux_event()
Message-ID: <20200119132811.GA159416@kroah.com>
References: <alpine.DEB.2.21.2001021349390.11372@macbook-air>
 <alpine.DEB.2.21.2001021418590.11372@macbook-air>
 <20200106120338.GC9630@lakrids.cambridge.arm.com>
 <alpine.DEB.2.21.2001061307460.24675@macbook-air>
 <alpine.DEB.2.21.2001161144590.29041@macbook-air>
 <20200118180529.GA70028@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118180529.GA70028@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 18, 2020 at 07:05:29PM +0100, Ingo Molnar wrote:
> 
> * Vince Weaver <vincent.weaver@maine.edu> wrote:
> 
> > On Mon, 6 Jan 2020, Vince Weaver wrote:
> > 
> > > On Mon, 6 Jan 2020, Mark Rutland wrote:
> > > 
> > > > On Thu, Jan 02, 2020 at 02:22:47PM -0500, Vince Weaver wrote:
> > > > > On Thu, 2 Jan 2020, Vince Weaver wrote:
> > > > > 
> > > > Vince, does the below (untested) patch work for you?
> > > 
> > > 
> > > yes, this patch fixes things for me.
> > > 
> > > Tested-by: Vince Weaver <vincent.weaver@maine.edu>
> > > 
> > 
> > is this patch going to make it upstream?  It's a fairly major correctness 
> > bug with perf_event_open().
> 
> I just sent it to Linus.
> 
> In hindsight this should have been marked Cc: stable for v5.4 - we should 
> forward it to Greg once Linus has pulled it:
> 
>    da9ec3d3dd0f: ("perf: Correctly handle failed perf_get_aux_event()")
> 
> 
> Note that in the v5.4 cherry-pick there's a conflict due to interaction 
> with another recent commit - I've attached the ported fix against v5.4, 
> but have only test built it.

Thanks for the backport, now queued up.

greg k-h
