Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E25F9289
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 15:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfKLOaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 09:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbfKLOaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 09:30:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E25C222CA;
        Tue, 12 Nov 2019 14:30:11 +0000 (UTC)
Date:   Tue, 12 Nov 2019 09:30:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH stable 4.4] tracing: Have trace_buffer_unlock_commit()
 call the _regs version with NULL
Message-ID: <20191112093010.380d3f3e@gandalf.local.home>
In-Reply-To: <20191112061850.71600-1-wangkefeng.wang@huawei.com>
References: <20191112061850.71600-1-wangkefeng.wang@huawei.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Nov 2019 14:18:50 +0800
Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Commit 33fddff24d05d71f97722cb7deec4964d39d10dc upstream
> 
> There's no real difference between trace_buffer_unlock_commit() and
> trace_buffer_unlock_commit_regs() except that the former passes NULL to
> ftrace_stack_trace() instead of regs. Have the former be a static inline of
> the latter which passes NULL for regs.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> [backport: modify trace_buffer_unlock_commit() in include/linux/trace_events.h]
> Fixes: c5e0535fe67b ("tracing: Skip more functions when doing stack tracing of events")
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

I'm not against this backport, but I'd like to know more why you feel
this is a stable fix. Just to get a better backtrace? Can you show some
examples of the issue you have and how this fixes it?

Thanks!

-- Steve
