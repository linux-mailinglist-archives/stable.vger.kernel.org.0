Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B649F44D7B1
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 14:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhKKOAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 09:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhKKOAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 09:00:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677C6610A0;
        Thu, 11 Nov 2021 13:57:16 +0000 (UTC)
Date:   Thu, 11 Nov 2021 08:57:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com,
        Alexey Makhalov <amakhalov@vmware.com>,
        Deep Shah <sdeep@vmware.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com, vithampi@vmware.com,
        linux-kernel@vger.kernel.org, namit@vmware.com, joe@perches.com,
        kuba@kernel.org
Subject: Re: [PATCH v3 1/3] MAINTAINERS: Update maintainers for paravirt ops
 and VMware hypervisor interface
Message-ID: <20211111085714.57f8cd3f@gandalf.local.home>
In-Reply-To: <YYy9P7Rjg9hntmm3@kroah.com>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
        <163657487268.84207.5604596767569015608.stgit@srivatsa-dev>
        <YYy9P7Rjg9hntmm3@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Nov 2021 07:50:39 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> > Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > Acked-by: Alexey Makhalov <amakhalov@vmware.com>
> > Acked-by: Deep Shah <sdeep@vmware.com>
> > Acked-by: Juergen Gross <jgross@suse.com>
> > Cc: stable@vger.kernel.org  
> 
> Why are MAINTAINERS updates needed for stable?  That's not normal :(

Probably not needed, but does it hurt?  And who's normal?

-- Steve
