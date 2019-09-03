Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14921A614C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfICGXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfICGXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 02:23:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EEF520882;
        Tue,  3 Sep 2019 06:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567491798;
        bh=nCe72QWYjPGF8OPBb0BqkMk7+mxrB98YWH0IG+rtYqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LLlvrdBCK3W//K3V2/wnEHadRmsXO3AtHDKZpCnYuWFOra6zgcaSF4nXnvrHJHnbi
         bTeFhLCo7B0ehyqA+Pqzygr7ehB6O0xqInVioguOVKWvUYMVt2QjoXVN9uVnyTUlV5
         cIl4waDn3iKxW5TGv5/D+T63cJrmjWtMKRBEBMk8=
Date:   Tue, 3 Sep 2019 08:23:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     me@sam.st, dsafonov@virtuozzo.com, mhiramat@kernel.org,
        oleg@redhat.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] uprobes/x86: Fix detection of 32-bit user
 mode" failed to apply to 4.14-stable tree
Message-ID: <20190903062315.GC16647@kroah.com>
References: <156745586914022@kroah.com>
 <20190903025347.GD5281@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903025347.GD5281@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 10:53:47PM -0400, Sasha Levin wrote:
> On Mon, Sep 02, 2019 at 10:24:29PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I've backported this for 4.14, 4.9, and 4.4:
> 
> - On 4.14 and 4.9 worked around missing e7ed9d9bd0375 ("uprobes/x86:
>   Emulate push insns for uprobe on x86").
> - On 4.4 worked around missing abfb9498ee132 ("x86/entry: Rename
>   is_{ia32,x32}_task() to in_{ia32,x32}_syscall()").

Thanks for doing this.

greg k-h
