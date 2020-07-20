Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4D4225E7F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgGTMZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:25:34 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57573 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728460AbgGTMZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:25:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7488558049E;
        Mon, 20 Jul 2020 08:25:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=dLGJSUAjbZmETmpBoYPTeHolVjZ
        eTBb1EfdYZn6WZLI=; b=cuJf8xNm+C8kIeUT4ytwaat8oR2MOgJE6KzMIXUwljh
        W9WJmo44s6QgSKfRDyl1xWrlYgFetT8pFaE7lhyD1NqmGo9OytiomWRcwqfdNnUu
        giplNWfHMRzHHpiXmxuq0r65pJ1Q+HaVFybfh1Snp82uSljcjpXd1fTe6G7PXwM2
        vWdHPu/wGuN5sOmLVeo85BrQo8hbD1EpuQphhPGhirjkso+EcnjmxyMHEZvT/pBe
        iRZjTlGU9r1dEK6H9lZ6UcGS2uN8MFSMq8/8mq9BBmH77ylPvvWQxEcHQ4mDOIvg
        GWHCEuQ4FSbylEMbjeP0IGP+Kb06eM0qkdzq5n498cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dLGJSU
        AjbZmETmpBoYPTeHolVjZeTBb1EfdYZn6WZLI=; b=J2f71winLhYlRO5o87BYye
        6BJdUdIzCOvlkfyuUFKsLWXIlrCv7ROwb7LSnB8wB8TyjXkCU7S/y4zEV3A+/PjG
        zogCIGduK1iPmX0cakFsgbqXvkVRCiNT2tmz6+PrxzynoF/2FgH/VnlPLmBbTYtk
        f019o9s2u4O0peT3LuVIL6UUz412pFV2fdS5XP5Yq0UFV9MQ7mRxW3GEmuPhLKgH
        2QEp63ZVkAybmdBrqmSBJXanWMrTGNdduI8EcYPjMwR3+dU88xcm+hhguMuojEWm
        gtvobuR1ocRdJDYGSrlAhxQJBghS9N1LHSU/m/nlLxJpNpFz9RndLbTpcv9ypuNw
        ==
X-ME-Sender: <xms:Oo0VX1Vkiij6m4EIaSDYQv4mCgoloEm3UZDTaakHjh-RFGnAp8vU8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:Oo0VX1kyYxVfWFWj4T43aETeGO_voSefGYjNifPJAp5OktQIHcCTcA>
    <xmx:Oo0VXxa-5Mlv4_CoBqAz4OxSHMljZo4XH3GAe2AchSSGWuJSEOjTaQ>
    <xmx:Oo0VX4UfWA669ZnFoy2FLSSYAdnotLKtc_nVbcRt8KpUX-xlkVJULA>
    <xmx:O40VXx5YN6a5QyWRPbAuDUifbvdCfAobNGNbVMe7414N-AT9nt16eA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D69030600A3;
        Mon, 20 Jul 2020 08:25:30 -0400 (EDT)
Date:   Mon, 20 Jul 2020 14:25:41 +0200
From:   Greg KH <greg@kroah.com>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, valentin.schneider@arm.com,
        sashal@kernel.org
Subject: Re: [PATCH v4.19] sched/fair: handle case of task_h_load() returning
 0
Message-ID: <20200720122541.GA3147730@kroah.com>
References: <20200720083401.22164-1-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720083401.22164-1-vincent.guittot@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 10:34:01AM +0200, Vincent Guittot wrote:
> [ Upstream commit 01cfcde9c26d8555f0e6e9aea9d6049f87683998 ]
> 
> task_h_load() can return 0 in some situations like running stress-ng
> mmapfork, which forks thousands of threads, in a sched group on a 224 cores
> system. The load balance doesn't handle this correctly because
> env->imbalance never decreases and it will stop pulling tasks only after
> reaching loop_max, which can be equal to the number of running tasks of
> the cfs. Make sure that imbalance will be decreased by at least 1.
> 
> We can't simply ensure that task_h_load() returns at least one because it
> would imply to handle underflow in other places.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> [removed misfit part which was not implemented yet]
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: <stable@vger.kernel.org> # v4.19 v4.14 v4.9 v4.4
> cc: Sasha Levin <sashal@kernel.org>
> Link: https://lkml.kernel.org/r/20200710152426.16981-1-vincent.guittot@linaro.org
> ---
> 
> This patch also applies on v4.14.188 v4.9.230 and v4.4.230

Thanks for all of the backports, now queued up.

greg k-h
