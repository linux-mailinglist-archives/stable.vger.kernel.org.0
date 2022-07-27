Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2885F5821D2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 10:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiG0IN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 04:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiG0IN5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 04:13:57 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E394504A;
        Wed, 27 Jul 2022 01:13:56 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7605E3200981;
        Wed, 27 Jul 2022 04:13:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 27 Jul 2022 04:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1658909632; x=1658996032; bh=6QTxVv2iC0
        pk9zW4dBnCA9xZfB5VkaI9NiFDPiaXtHg=; b=vQsgXhFv6elVdoPHuZnDMdt0qd
        DZFv+3P2hZyyiOnnFj27y/dGOz+5e7sC6AO2r2m2iavi6sf1sO2IkwwypE9BZNvP
        axo+GH0KOSouJvsF1bxKxvXaaPe7wVcBKyneQJnftekdKkpI+PWsVtsP8AdNDqOa
        j4YOw1Dp4v6BsUrnqzcC7saUs0pc1RNoLOPVUqS6qBpXGoCkGvyZIiPsS/bCABik
        Jbp7bAubFmKAb1rYDAZwWzBxImpH8ZgE8dqZrJGE2vibUoFlLEZuZO2aw/VtOsRV
        HAP6nmJ3TOWi6zCMdEON2UeES9OeZOWCVw6r70iL+5iid6gOmew6m0vo4Oxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1658909632; x=1658996032; bh=6QTxVv2iC0pk9zW4dBnCA9xZfB5V
        kaI9NiFDPiaXtHg=; b=V4ezr5dhPcWOK6ROhT86Mup9OpvkZEOMbCUB8X6aVG2T
        kFoxY8boB6+dxjR9MlS3nktK+gNz26vg1Dj9IOslVm0HzXzXXQXAK2o1iFl58t+s
        mVZTpb8+a9NG1rrvb0tGCzfN0BCQzfg0d65WtRyeR8E1WEf8TlSLRjcRqWJO6O+d
        uTS/hZXOk9AbEArjwVyCG0Pzg7tUc3r+PD7yJdm9G/d6CebwbOBArfu3ZSr2xtCf
        X0dm7w0h6VvE4ng4NlQX8KK0RoIDs2SSCTb/SDjxgRYHE050Y6+bHnc7CuDzs9YN
        KaBqRvOivnUfY0dZdMz4E8YiXGl9C2xbUsS1ZjzTbA==
X-ME-Sender: <xms:v_PgYkNeo8tv5clmnRrp0V5uv1yCpe2Vj4P3K_Ol65KTDJIGdVBW0Q>
    <xme:v_PgYq9w-cJcow0XCmwCVZpOGwT-_frwTflhsTWkF1NE02Z1jtE0kK5qBUBqlisAX
    ttTXG3FI6TDeA>
X-ME-Received: <xmr:v_PgYrSMJrqc3PIwUTkz97J5lsiDkoEvJvM3hzfEfJNgQFx4nr_c7udhP04B8RKYSqTUCo3h3Kv9eem0TeiwBO9-GoYbTzV4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdduvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:v_PgYssMp_ct5VP1VoMnxCao7dCIz_46g9eddzcSHw-9Kv53GDwrbA>
    <xmx:v_PgYseYBpmhoOT8s0X0Vxqof_7HjXLDiyh6ulFZr15JN7ZpEXU0WA>
    <xmx:v_PgYg1zbP83Fd32HD4XfdZc12i4oAPcAPHt6EaOrfxi15vnA95pxg>
    <xmx:wPPgYvv_EJNpGSq0U61IQkHKozqQr6Ss9oWYxF5R497V0Vup3wRGWg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Jul 2022 04:13:51 -0400 (EDT)
Date:   Wed, 27 Jul 2022 10:13:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19] perf/core: Fix data race between
 perf_event_set_output() and perf_mmap_close()
Message-ID: <YuDzvXC6vdnSwNHp@kroah.com>
References: <20220726013356.88395-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726013356.88395-1-yangjihong1@huawei.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 09:33:56AM +0800, Yang Jihong wrote:
> commit 68e3c69803dada336893640110cb87221bb01dcf upstream.
> 
> Yang Jihing reported a race between perf_event_set_output() and
> perf_mmap_close():
> 
>         CPU1                                    CPU2
> 
>         perf_mmap_close(e2)
>           if (atomic_dec_and_test(&e2->rb->mmap_count)) // 1 - > 0
>             detach_rest = true
> 
>                                                 ioctl(e1, IOC_SET_OUTPUT, e2)
>                                                   perf_event_set_output(e1, e2)
> 
>           ...
>           list_for_each_entry_rcu(e, &e2->rb->event_list, rb_entry)
>             ring_buffer_attach(e, NULL);
>             // e1 isn't yet added and
>             // therefore not detached
> 
>                                                     ring_buffer_attach(e1, e2->rb)
>                                                       list_add_rcu(&e1->rb_entry,
>                                                                    &e2->rb->event_list)
> 
> After this; e1 is attached to an unmapped rb and a subsequent
> perf_mmap() will loop forever more:
> 
>         again:
>                 mutex_lock(&e->mmap_mutex);
>                 if (event->rb) {
>                         ...
>                         if (!atomic_inc_not_zero(&e->rb->mmap_count)) {
>                                 ...
>                                 mutex_unlock(&e->mmap_mutex);
>                                 goto again;
>                         }
>                 }
> 
> The loop in perf_mmap_close() holds e2->mmap_mutex, while the attach
> in perf_event_set_output() holds e1->mmap_mutex. As such there is no
> serialization to avoid this race.
> 
> Change perf_event_set_output() to take both e1->mmap_mutex and
> e2->mmap_mutex to alleviate that problem. Additionally, have the loop
> in perf_mmap() detach the rb directly, this avoids having to wait for
> the concurrent perf_mmap_close() to get around to doing it to make
> progress.
> 
> Fixes: 9bb5d40cd93c ("perf: Fix mmap() accounting hole")
> Reported-by: Yang Jihong <yangjihong1@huawei.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Tested-by: Yang Jihong <yangjihong1@huawei.com>
> Link: https://lkml.kernel.org/r/YsQ3jm2GR38SW7uD@worktop.programming.kicks-ass.net
> [YJH: backport to 4.19: adjusted context]
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>  kernel/events/core.c | 45 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)

Sasha already queued this up, thanks.

greg k-h
