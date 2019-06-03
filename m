Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17F432D11
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfFCJok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:44:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51264 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfFCJoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 05:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q2baRfeYIW1LzbdDLxPmmxwix7nxDc4nwV4gsljzOGU=; b=c12RquJi+HOgoZMIpS1W2Yv/C
        n72Z9MzOuEpXhMsKLKMZswM7kyUP054Yr9FlMkswQ9Zo53HERhyBq7ThdqiyWliV2hQUGo1e4pTb0
        w+JYYsYYm+ws9xpkmkS00o7WWrKkSNdF/6n10L6YCCb1BeFojd/AAQRflW0hNBp/xyhaxWxDvD+fK
        LIGuFJWTOE9hFKrJb0Fph7cqxrilFlvpfBBBtLMpe67D1xanvj5Bpwmangq3DQiw8bdpiyd/vKCpj
        kwpA+eQM15TAjrfFCL1gGXthkOGVjw94HjR4smcGIo+nktSq7UFWXJR0X2t6hVze4tHvu5s12ANt3
        +Lgn4HGMQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXjVy-00024m-P6; Mon, 03 Jun 2019 09:44:27 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8ABCD20254810; Mon,  3 Jun 2019 11:44:25 +0200 (CEST)
Date:   Mon, 3 Jun 2019 11:44:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Gao Xiang <gaoxiang25@huawei.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Miao Xie <miaoxie@huawei.com>, koujilong@huawei.com
Subject: Re: [PATCH v2] sched/core: add __sched tag for io_schedule()
Message-ID: <20190603094425.GG3436@hirez.programming.kicks-ass.net>
References: <20190531082912.80724-1-gaoxiang25@huawei.com>
 <20190603091338.2695-1-gaoxiang25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603091338.2695-1-gaoxiang25@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 05:13:38PM +0800, Gao Xiang wrote:
> non-inline io_schedule() was introduced in
> commit 10ab56434f2f ("sched/core: Separate out io_schedule_prepare() and io_schedule_finish()")
> Keep in line with io_schedule_timeout, Otherwise
> "/proc/<pid>/wchan" will report io_schedule()
> rather than its callers when waiting io.
> 
> Reported-by: Jilong Kou <koujilong@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Fixes: 10ab56434f2f ("sched/core: Separate out io_schedule_prepare() and io_schedule_finish()")
> Cc: <stable@vger.kernel.org> # 4.11+
> Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

Thanks
