Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E8314AA14
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 19:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgA0Svt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 13:51:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgA0Svt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 13:51:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FCFC21739;
        Mon, 27 Jan 2020 18:51:48 +0000 (UTC)
Date:   Mon, 27 Jan 2020 13:51:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tom Zanussi <zanussi@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Fix histogram code when
 expression has same var as" failed to apply to 4.19-stable tree
Message-ID: <20200127135147.5c1ae6d1@gandalf.local.home>
In-Reply-To: <1580150181.5072.5.camel@kernel.org>
References: <15801394743854@kroah.com>
        <1580150181.5072.5.camel@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jan 2020 12:36:21 -0600
Tom Zanussi <zanussi@kernel.org> wrote:

> Hi Steve,
> 
> For 4.19, this patch applies if these patches are applied first:
> 
> commit 656fe2ba85e81d00e4447bf77b8da2be3c47acb2
> Author: Tom Zanussi <tom.zanussi@linux.intel.com>
> Date:   Tue Dec 18 14:33:24 2018 -0600
> 
>     tracing: Use hist trigger's var_ref array to destroy var_refs
> 
> commit de40f033d4e84e843d6a12266e3869015ea9097c
> Author: Tom Zanussi <tom.zanussi@linux.intel.com>
> Date:   Tue Dec 18 14:33:23 2018 -0600
> 
>     tracing: Remove open-coding of hist trigger var_ref management
> 
> After applying all 3 to 4.19, I built and ran the ftrace/trigger
> selftests and didn't see any problems.
> 

Thanks, I was cherry-picking parts of those changes, but it wasn't
fixing the issue itself. Let me just backport both of them in full and
see if that works.

-- Steve
