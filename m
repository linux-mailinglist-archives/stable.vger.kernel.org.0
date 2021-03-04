Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4310332D46F
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhCDNq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235304AbhCDNqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:46:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED54564F39;
        Thu,  4 Mar 2021 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614865526;
        bh=jwFv0wSQ0L7MAiuzXv6ggUdm3HGGf4+h2qpKP//GV+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jikx43X+fhtj9SFToQQOzab5e+3VmFkQ9jvK1KeZO8RUDZFsUavxR2n3CuX7I9UGt
         rrwkZav4vxEba2q2+SAc0ZEi+Zhc7BEF3+WFdaVUHlIAgKTtqWtqPr1HWoi/Cogkk+
         3HdCv1z9Y9N1vrFNJqFLemGa+y3jStzucvWjFxjo=
Date:   Thu, 4 Mar 2021 14:45:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     songmuchun@bytedance.com, sergey.senozhatsky@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] printk: fix deadlock when kernel panic"
 failed to apply to 4.9-stable tree
Message-ID: <YEDkdEdiBd4PIqmh@kroah.com>
References: <1614604832185174@kroah.com>
 <YD4NP2ffit64F/kB@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD4NP2ffit64F/kB@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 11:02:39AM +0100, Petr Mladek wrote:
> On Mon 2021-03-01 14:20:32, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Please, find below the backport for stable-4.9:

Now queued up, thanks.

greg k-h
