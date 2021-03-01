Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B09C32807C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhCAOP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236295AbhCAOPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 09:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09FB464D99;
        Mon,  1 Mar 2021 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614608064;
        bh=JREbB1QvPb3X017onxXJW7qUEv9h9WTPIO90cD3MfKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xMe1+/hXw/SoDnsuwup/88v8RpDjnN8RzPwlWTi1FJw1kET35vt1GJ+KMzaMF3JZc
         tX4qAIIDbBMQ08O+nNYVSCIb3QukkquuMRMY1VPKKU0cJdtMtzK/HzVjGktXzN5lpG
         QW6z85RwD1DGIxGOfrqWCT5R7/aU28DALiQr+GhA=
Date:   Mon, 1 Mar 2021 15:14:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        judy.chenhui@huawei.com, zhangjinhao2@huawei.com,
        tglx@linutronix.de
Subject: Re: [PATCH 4.4.257 0/1] Bugfix for ad4740ceccfb ("futex: Avoid
 violating the 10th rule of futex")
Message-ID: <YDz2vnloSGcHWS9b@kroah.com>
References: <20210222040618.2911498-1-zhengyejian1@huawei.com>
 <20210222084318.GA163314@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222084318.GA163314@dell>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 08:43:18AM +0000, Lee Jones wrote:
> On Mon, 22 Feb 2021, Zheng Yejian wrote:
> 
> > *** BLURB HERE ***
> 
> You need to replace this place-holder with your own description of the
> problem, how it's being solved and why this particular solution was
> selected.
> 
> > Peter Zijlstra (1):
> >   futex: Fix OWNER_DEAD fixup
> 
> To clarify, this *is* the right fix.  Thanks for taking the time.
> 
> >  kernel/futex.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> Reviewed-by: Lee Jones <lee.jones@linaro.org>

Now queued up, thanks.

greg k-h
