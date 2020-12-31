Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915B82E7EE9
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 10:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgLaJRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 04:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgLaJRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 04:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B4220735;
        Thu, 31 Dec 2020 09:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609406190;
        bh=jYv9bj1C++Nt9GBYAwyoWSZ9/8vAc6P/OPbX4raZgy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TlrSiQkWfxEnddNmjq9GQ9a4A0sb4UV78KP3nFW/7neDlydh1qUx3FcpEQGL4GsXm
         krD9tmGSY5E8+74Iez+MXiIaQZYj8T2kA3CSC7g264jqn1psakI3SjW5CiHy3OBQUB
         cXN4xde4aXZeiSAupuuglGVtRdfWweCIvZ7Vw3t0=
Date:   Thu, 31 Dec 2020 10:17:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/2] backports for slab-out-of-bounds issue in ip6_xmit()
Message-ID: <X+2XQ1JRPSeKLtkK@kroah.com>
References: <20201230193323.2133009-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230193323.2133009-1-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 11:33:21AM -0800, Suren Baghdasaryan wrote:
> We received a slab-out-of-bounds report in ip6_xmit() for KASAN build on 4.9
> kernel. The patches that fix this issue have been backported to to stable 4.14
> and one of them even to 3.16 but 4.9 stable branch does not include them.
> Backport to linux-4.9.y required trivial merge conflict resolution. They
> cleanly apply to linux-stable linux-4.9.y branch tagged v4.9.249.
> 
> Paolo Abeni (2):
>   net: ipv6: keep sk status consistent after datagram connect failure
>   l2tp: fix races with ipv4-mapped ipv6 addresses
> 
>  net/ipv6/datagram.c  | 21 +++++++++++++++++----
>  net/l2tp/l2tp_core.c | 38 ++++++++++++++++++--------------------
>  net/l2tp/l2tp_core.h |  3 ---
>  3 files changed, 35 insertions(+), 27 deletions(-)

Nit, you forgot to sign-off on these patches that you forwarded on.
Next time remember to do that as you did "touch" them :)

I'll go queue them up now.

thanks,

greg k-h
