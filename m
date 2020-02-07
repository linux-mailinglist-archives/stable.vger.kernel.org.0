Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05313155C32
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 17:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgBGQxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 11:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgBGQxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 11:53:22 -0500
Received: from oasis.local.home (unknown [12.174.139.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC0B020838;
        Fri,  7 Feb 2020 16:53:21 +0000 (UTC)
Date:   Fri, 7 Feb 2020 11:53:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, joel@joelfernandes.org,
        paulmck@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ftrace: Protect ftrace_graph_hash with
 ftrace_sync" failed to apply to 5.5-stable tree
Message-ID: <20200207115320.2949cf3c@oasis.local.home>
In-Reply-To: <20200207150728.GW31482@sasha-vm>
References: <15810705761598@kroah.com>
        <20200207082842.1ce4bf32@oasis.local.home>
        <20200207150728.GW31482@sasha-vm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 7 Feb 2020 10:07:28 -0500
Sasha Levin <sashal@kernel.org> wrote:

> I've ended up taking these additional commits, and queued everything for
> 5.5-4.14:
> 
> 16052dd5bdfa ("ftrace: Add comment to why rcu_dereference_sched() is open coded")
> 24a9729f8314 ("tracing: Annotate ftrace_graph_hash pointer with __rcu")
> fd0e6852c407 ("tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu")

Thanks Sasha!

-- Steve
