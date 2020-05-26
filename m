Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26D1E1868
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgEZAWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgEZAWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 20:22:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B3920657;
        Tue, 26 May 2020 00:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590452525;
        bh=fFvjXYDsqvalZi6RiC4ekRHKKkP2UHb24A4yZnCS8eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uw3oXshCzrnbJXWz9l7YW+kh4A9YIqEpib0ZSw/O/4vEnZNMzYKUzeKIjvSm439/M
         1nJHWt/uG2aF+M/xR4KI+Y+e84j8/+JekuJoO0+q+g5DwchCrp3m6AityVvHL6v1qn
         EH7CvoXg/hgwxmsodioyfDF7VeqdvprEorYwvWn8=
Date:   Mon, 25 May 2020 20:22:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     gregkh@linuxfoundation.org, bsegall@google.com, pauld@redhat.com,
        peterz@infradead.org, zohooouoto@zoho.com.cn,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <20200526002203.GF33628@sasha-vm>
References: <159041776924279@kroah.com>
 <20200525172709.GB7427@vingu-book>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525172709.GB7427@vingu-book>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 07:27:09PM +0200, Vincent Guittot wrote:
>Le lundi 25 mai 2020 à 16:42:49 (+0200), gregkh@linuxfoundation.org a écrit :
>>
>> The patch below does not apply to the 5.4-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>This patch needs  commit
>    b34cb07dde7c ("sched/fair: Fix enqueue_task_fair() warning some more")
>to be applied first. But then, it will not apply. The backport is :
>
>[ Upstream commit 39f23ce07b9355d05a64ae303ce20d1c4b92b957 upstream ]
>
>Although not exactly identical, unthrottle_cfs_rq() and enqueue_task_fair()
>are quite close and follow the same sequence for enqueuing an entity in the
>cfs hierarchy. Modify unthrottle_cfs_rq() to use the same pattern as
>enqueue_task_fair(). This fixes a problem already faced with the latter and
>add an optimization in the last for_each_sched_entity loop.
>
>Fixes: fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
>Reported-by Tao Zhou <zohooouoto@zoho.com.cn>
>Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>Reviewed-by: Phil Auld <pauld@redhat.com>
>Reviewed-by: Ben Segall <bsegall@google.com>
>Link: https://lkml.kernel.org/r/20200513135528.4742-1-vincent.guittot@linaro.org

Peter, could you review/ack the backport please? It's very different
from the upstream version.

-- 
Thanks,
Sasha
