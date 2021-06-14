Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007113A5E97
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 10:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhFNIwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 04:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232528AbhFNIwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 04:52:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B3BA600D3;
        Mon, 14 Jun 2021 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623660635;
        bh=jrLZzP/kHR0biRnlG5BqhPfDy8a9g2yjxHkTaJjvwt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wwj5QDLrRjzpp2Xjt7Dg/C7hjsHgsqv67S4PgyFJLE8FCydLqvR6yd5Dg6/dQq2od
         jDpKZ5fqISAbiwesXa/22M0Y+jtu61ltiN/rdVakOvMu2EKfISfF02sC/0DW8MepTa
         9RO0GhysTi0a6PWSra+aLkBll+yIEA4KSka5bWvM=
Date:   Mon, 14 Jun 2021 10:50:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     liangyan.peng@linux.alibaba.com, jnwang@linux.alibaba.com,
        mingo@redhat.com, wetp.zy@linux.alibaba.com,
        xlpang@linux.alibaba.com, yinbinbin@alibabacloud.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Correct the length check which
 causes memory" failed to apply to 5.10-stable tree
Message-ID: <YMcYWcBQjNkKur6k@kroah.com>
References: <162358538716087@kroah.com>
 <20210613205118.0848b3dc@rorschach.local.home>
 <20210613210336.25574811@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613210336.25574811@rorschach.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 13, 2021 at 09:03:36PM -0400, Steven Rostedt wrote:
> On Sun, 13 Jun 2021 20:51:18 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > The below works for 4.9 through 5.10. But will not work for 4.4.
> 
> And that's because the fix isn't applicable for 4.4 (saw another FAILED
> patch for 4.4, but it wasn't this one.) So this should apply to all the
> applicable backports.

Thanks, now queued up.

greg k-h
