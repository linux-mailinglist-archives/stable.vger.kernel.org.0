Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE81C32923F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbhCAUmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241854AbhCAUeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:34:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA10B6023B;
        Mon,  1 Mar 2021 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614624787;
        bh=TsE3rILK64lmwY+ycjYeESSXSeefnz/0ltEwECCDkHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AIwIvdiHjCLUCApDOVU/mTembj00ySG/ZuE/7N/GAGMKakMQC4bMK5yNybAw5ITBA
         THUvwP3D0eELWOWPE7YZH472WdzcMff+cwghqYaTsPYvf3aPpR7tTtgx43wE9lz95l
         geM/v3DqKcE+ImfwUYC3Yr68OvBQZSoTfAX+21H8=
Date:   Mon, 1 Mar 2021 19:48:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Cong Wang ." <cong.wang@bytedance.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        stable@vger.kernel.org
Subject: Re: [Phishing Risk] [External] FAILED: patch "[PATCH] net_sched: fix
 RTNL deadlock again caused by request_module()" failed to apply to
 5.4-stable tree
Message-ID: <YD02/mC7BpCKIXub@kroah.com>
References: <161461457416034@kroah.com>
 <CAA68J_ZM-YhX+dWSw=JChPtQ-hQSJmSy_NZpD-pEWM+icVMuYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA68J_ZM-YhX+dWSw=JChPtQ-hQSJmSy_NZpD-pEWM+icVMuYg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 09:54:33AM -0800, Cong Wang . wrote:
> On Mon, Mar 1, 2021 at 8:02 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This patch is not suitable for -stable due to its large size.

The size here is fine:
 3 files changed, 79 insertions(+), 41 deletions(-)

Given that syzbot can trigger this, that means that humans can as well,
so why shouldn't we fix this?

thanks,

greg k-h

