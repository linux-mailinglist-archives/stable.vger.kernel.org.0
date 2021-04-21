Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4651C366D37
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhDUNwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237169AbhDUNwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA38560720;
        Wed, 21 Apr 2021 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619013122;
        bh=M1NxN6ccTM92wlA49g8YyafcO0paq+D/K0FB7+Bfcfs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D4AyrJIhWpEPoe+REwS/KgnyuOhTaCLzy8QD7sLeqwn9wXju37lWnfMNcSGZG4cU5
         hCfOVKt15TXl3sJ761X2n6B8pBZT5V+mM4qQNBIYnhgjZJktYyTTGJjCk8vx2ZT3oG
         tN4ntIj2yvHOwv8Z3jgShtQajlELJgp/+70e+QmE=
Date:   Wed, 21 Apr 2021 15:51:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenwen Wang <wang6495@umn.edu>
Subject: Re: [PATCH 081/190] Revert "tracing: Fix a memory leak by early
 error exit in trace_pid_write()"
Message-ID: <YIAt/0Fb0QjpNubP@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-82-gregkh@linuxfoundation.org>
 <20210421092919.2576ce8d@gandalf.local.home>
 <20210421093343.2c52786a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421093343.2c52786a@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 09:33:43AM -0400, Steven Rostedt wrote:
> On Wed, 21 Apr 2021 09:29:19 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> Just to clear up any confusion about my tag above. It was a second review
> of the original patch, not for the revert.

Fair enough, I'll handle it, thanks!

greg k-h
