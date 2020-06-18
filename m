Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480451FF930
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgFRQ05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730775AbgFRQ05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 12:26:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C8E2080D;
        Thu, 18 Jun 2020 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592497616;
        bh=JUvjOEtKPccywAXDdqXylR0BOaLwuObYGlo4iVtYLog=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=LE9GQb5fScnvwbp4zrVcKvhhSuLL/rqlQb0izgOFSLfcNklwxJg5f+MfIrMt+IXT8
         jITom3JYqQiE0LhPjBQCVvcRUaxyQo6SQKAiKGvrrJE1mYdv1mdrwRE6xOGf0r8X0S
         bIuPAq2/GuvVAwafRs8U4MWmmDqvaGenEyqurv6Q=
Date:   Thu, 18 Jun 2020 18:26:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     pasha.tatashin@soleen.com, akpm@linux-foundation.org,
        dan.j.williams@intel.com, daniel.m.jordan@oracle.com,
        david@redhat.com, jmorris@namei.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, pankaj.gupta.linux@gmail.com, sashal@kernel.org,
        shile.zhang@linux.alibaba.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, yiwei@redhat.com
Subject: Re: FAILED: patch "[PATCH] mm: call cond_resched() from
 deferred_init_memmap()" failed to apply to 5.7-stable tree
Message-ID: <20200618162649.GA250996@kroah.com>
References: <15924957437531@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15924957437531@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 05:55:43PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Oops, I applied things out of order, I've queued this and the 5.4
version up, but 4.19 doesn't apply as the dependant patch does not
apply.

thanks

greg k-h
