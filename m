Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16535377D95
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhEJIC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230105AbhEJIC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 04:02:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862C3611AB;
        Mon, 10 May 2021 08:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620633683;
        bh=eGimWpKPX1r9H64hZDHPBmLIdh9Mn5cTP8ntaSHyIKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k4fnAliLBGoE+iTWo2tQXWXDmWUreD8zTLCfO2aCfx4FWRh264IRDVZGiDIxSw/ap
         plQ7rgQ6bydktGER7pOfT0f+pcegOlLWIQ4Howowc7lr3R42wInsnHPYoJZorFRUNo
         xaypjocM92shZ2/aL/18Ok2LO5YRLUwa4cHTrNSc=
Date:   Mon, 10 May 2021 10:01:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ftrace: Handle commands when closing
 set_ftrace_filter file" failed to apply to 4.14-stable tree
Message-ID: <YJjoUNSoSpejN6kv@kroah.com>
References: <16203954739926@kroah.com>
 <20210507151935.36821d46@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507151935.36821d46@gandalf.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 03:19:35PM -0400, Steven Rostedt wrote:
> On Fri, 07 May 2021 15:51:13 +0200
> <gregkh@linuxfoundation.org> wrote:
> 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Below is the patch that works for 4.14. I'm currently working on a fix for
> 4.9 and 4.4 as this does not apply to them.

All backports now queued up, thanks!

greg k-h
