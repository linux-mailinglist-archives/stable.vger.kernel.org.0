Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7567424304D
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 23:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHLVBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 17:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgHLVBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:41 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2029B207F7;
        Wed, 12 Aug 2020 21:01:41 +0000 (UTC)
Date:   Wed, 12 Aug 2020 17:01:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.7 5.8] tracing: Move pipe reference to trace array
 instead of current_tracer
Message-ID: <20200812170139.638961e1@oasis.local.home>
In-Reply-To: <20200812165854.142bcfb0@oasis.local.home>
References: <20200812205259.229041-1-dann.frazier@canonical.com>
        <20200812165854.142bcfb0@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Aug 2020 16:58:54 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > This is marked as "Fixes" but is more of a clean up than a true fix.
> > Backport if you want, but its not critical.  
> 
> A note to stable maintainers. I originally thought this was just a
> clean up, but it was then found that it actually does fix a bug.

I cut out the explanation in the email:

> This addresses an issue we've seen with users trying to change
> current_tracer when they happen to have rasdaemon installed.
> rasdaemon uses the trace_pipe interface at runtime, which therefore
> blocks changing the current tracer. But of course, unless
> you know about rasdaemon internals, it isn't exactly an obvious
> failure mode.
> 
> Conflict in __remove_instance() was due to a change in reference counter
>  semantics introduced later in v5.5 via commit 288797871473
>  "tracing: Adding new functions for kernel access to Ftrace instances".
> Resolved by leaving the first test in the if statement as it was in v5.4.

-- Steve
