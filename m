Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3CD379354
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 18:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhEJQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 12:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhEJQFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 12:05:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C671611CA;
        Mon, 10 May 2021 16:04:47 +0000 (UTC)
Date:   Mon, 10 May 2021 12:04:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Map all PIDs to command lines"
 failed to apply to 4.9-stable tree
Message-ID: <20210510120445.55926bfe@gandalf.local.home>
In-Reply-To: <16206366172647@kroah.com>
References: <16206366172647@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 10:50:17 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 

Looks like the following two commits also need to be backported, and then
this one should apply fine. The two commits do fix the code, so there
should be no issues backporting them:

  eaf260ac04d9b4cf9f458d5c97555bfff2da526e
  ("tracing: Treat recording comm for idle task as a success")


  e09e28671cda63e6308b31798b997639120e2a21
  ("tracing: Use strlcpy() instead of strcpy() in __trace_find_cmdline()")

After backporting the above two, I was able to apply and test this patch to
both 4.9 and 4.4.

-- Steve

