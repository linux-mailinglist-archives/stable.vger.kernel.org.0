Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30C6AB98F
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 10:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCFJTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 04:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCFJTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 04:19:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D2321944;
        Mon,  6 Mar 2023 01:19:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FB4660B24;
        Mon,  6 Mar 2023 09:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B546C433EF;
        Mon,  6 Mar 2023 09:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678094373;
        bh=9s/ueQ0rHu2KZhrMnIPYJ7KNkqBgjGsNBO9lojJJQWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HIy+UEBb8S65c/nwtuMZaEWubApEV08eL2u6iNXrm5+aKOAKtLttCs7KxhBvR92/N
         IIGL/fG64gcUFueH7mbiWGxhAMjbB22oZmPAA2RrgLLAgv/4bmgU9XnfAd5mb1BcRY
         WCeFcHXULGVRkj0RuWftrWD/UHi15NrdR9MqUsjI=
Date:   Mon, 6 Mar 2023 10:19:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhang Qiao <zhangqiao22@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
Subject: Re: Patch "sched/fair: sanitize vruntime of entity being placed" has
 been added to the 4.14-stable tree
Message-ID: <ZAWwIrMQ2EUikr6t@kroah.com>
References: <20230305040248.1787312-1-sashal@kernel.org>
 <cf0108ec-d949-a5ab-7367-f358b6685873@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf0108ec-d949-a5ab-7367-f358b6685873@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 04:31:57PM +0800, Zhang Qiao wrote:
> 
> 
> 在 2023/3/5 12:02, Sasha Levin 写道:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     sched/fair: sanitize vruntime of entity being placed
> > 
> > to the 4.14-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      sched-fair-sanitize-vruntime-of-entity-being-placed.patch
> > and it can be found in the queue-4.14 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > 
> > commit 38247e1de3305a6ef644404ac818bc6129440eae
> 
> Hi,
> This patch has significant impact on the hackbench.throughput [1].
> Please don't backport this patch.
> 
> [1] https://lore.kernel.org/lkml/202302211553.9738f304-yujie.liu@intel.com/T/#u

This link says it made hackbench.throughput faster, not slower, so why
would we NOT want it?

confused,

greg k-h
