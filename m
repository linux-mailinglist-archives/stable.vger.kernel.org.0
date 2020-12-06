Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E614E2D0257
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 10:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgLFJ4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 04:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgLFJ4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 04:56:43 -0500
Date:   Sun, 6 Dec 2020 10:57:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607248563;
        bh=gWLtXKXDc/uHpHGFRfE0AA5v+E9L8YKrAc93yWwMpsQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=tkgeU7g1mwIqAMgW+vvgh7vM3wQKeQ6soUSnANYbVcjz4y4kzngSlunpS60b4Cmfa
         MtL/aqWKn1rZeAYnmWrbQ9UDpUnM5NfkK8SW9vRGWArOA3MwtDBSd7D6WmMjHh4Kur
         ZhXzJggiWJB/0e5X/1uWY2kzRJ1ZuGzHVkTVdr4w=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     bsegall@google.com, pauld@redhat.com, peterz@infradead.org,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <X8yq+7/dQADbrTTL@kroah.com>
References: <159041776924279@kroah.com>
 <20200525172709.GB7427@vingu-book>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525172709.GB7427@vingu-book>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 07:27:09PM +0200, Vincent Guittot wrote:
> Le lundi 25 mai 2020 à 16:42:49 (+0200), gregkh@linuxfoundation.org a écrit :
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This patch needs  commit
>     b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some more")
> to be applied first. But then, it will not apply. The backport is :
> 
> [ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream ]
> 
> Although not exactly identical, unthrottle_cfs_rq() and enqueue_task_fair()
> are quite close and follow the same sequence for enqueuing an entity in the
> cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern as
> enqueue_task_fair(). This fixes a problem already faced with the latter and
> add an optimization in the last for_each_sched_entity loop.
> 
> Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
> Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Phil Auld <pauld@redhat.com>
> Reviewed-by: Ben Segall <bsegall@google.com>
> Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guittot@linaro.org
> ---
>  kernel/sched/fair.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)

This patch doesn't apply to the 5.4.y tree at all.  Can someone please
provide a working backport?

thanks,

greg k-h
