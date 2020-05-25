Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930801E1211
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388791AbgEYPtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388739AbgEYPtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 11:49:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7CB2207CB;
        Mon, 25 May 2020 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590421761;
        bh=sQXiF0OEnXLA2pXY3Fqnfzxfl71OFgTSHALtyqCsB40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fK286YYOEdx26SkHTS5fCrVoPv1oZYo3eJgeVKGaD4RaZ6xjwp/FiuB9ZeqJiOqAq
         rAMY1tGa4f5wYqRH9Ha2hYSuVrvlqUYISQXC2TwciUCwJh5GF8RgSL/T1QxfIO4dyD
         NldS0wWw0HpjbQqfra5YfyRCM1pIBkaQEudr1SMI=
Date:   Mon, 25 May 2020 17:49:18 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Phil Auld <pauld@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "# v4 . 16+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix enqueue_task_fair()
 warning some more" failed to apply to 5.6-stable tree
Message-ID: <20200525154918.GB1039448@kroah.com>
References: <1590417756152233@kroah.com>
 <CAKfTPtCdYVG3KbE4RixXYMEv=yQNu5zMutS7bTk4dAHqSxhs7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCdYVG3KbE4RixXYMEv=yQNu5zMutS7bTk4dAHqSxhs7A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 05:41:36PM +0200, Vincent Guittot wrote:
> On Mon, 25 May 2020 at 16:42, <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.6-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This patch applies on top of
> commit 6d4d22468dae ("sched/fair: Reorder enqueue/dequeue_task_fair path")

That applies, but:

> commit 5ab297bab984 ("sched/fair: Fix reordering of
> enqueue/dequeue_task_fair()")

That one does not.

Can you make a backported patch series of these that I can apply easily?

thanks,

greg k-h
