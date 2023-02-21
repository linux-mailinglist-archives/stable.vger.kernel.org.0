Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303FE69E194
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 14:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjBUNpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 08:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjBUNo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 08:44:59 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C981CF7C
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 05:44:58 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9CAFF5C0187;
        Tue, 21 Feb 2023 08:44:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 21 Feb 2023 08:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1676987095; x=
        1677073495; bh=oidnbMEBUKmg8Yo1htr8dMCLeZGzv7JbhhXTqQMlQXk=; b=P
        bF8RFU0cH0kvv4AfORk6RL8qnbiuD8hqFl4ii8+musENDwWK24UEJ1Ml+85830XX
        p//r8GYoo8A2DNSPKy+evCtgNzrifeiLPu3cZVwtfnJOR3ITX9F3jxuLuBzZjdpr
        Lp27FyPREiOcVTYLG6xQOEF5bS3j7u6L78kA9Xpk6bQYFJ/YKY4ch4MRFX+g30Zi
        BcYFWHuVKo05KmV24MhcUXynUqo9f+LhA+6XLok8KFsreQYFNc//0niu96BVl2vT
        oR2liAlbY5HHWK1aIMlBddA9f23RRee/EWG4i/NSm8Sa7bQhpem9a+9gDzxk8lWz
        KLmxbOpSMVoo27qakcJUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1676987095; x=
        1677073495; bh=oidnbMEBUKmg8Yo1htr8dMCLeZGzv7JbhhXTqQMlQXk=; b=h
        rJ3QHVrmP/HF0G6asBwkgyhwfIhL8VNN6YML0JJKd2yIaWO+4ebT89SYDQNBt6FS
        /zxB3sp004aB30us2aqhe2O3K/NsIiwo1rNti2U3hGzXURpRESfLzdxgpIFpZUrO
        jo97YT7pxiiN1fcXLSKHozcLaeVe5gKprLuVVbWSp6uv5fqiXs+9vF9+mH89ypB5
        KXMhJhOxMkIv2uth3eIKQDYY1CqnFdp4uhbVhyT/n/p4CV0kAGV0T8G1UteoMG99
        Uq0r7l/FWEWQZgXwv3ybdJkO8Ysjx4+q6mfS/Fts7UgnPXaRrHzHv6sKszdMSJXB
        59LTXG1ltdXV/1DmxI5Ww==
X-ME-Sender: <xms:18r0Y7YBvZodbx2NrNV7UWIHGmLMj0VQvcSBDqhK9bAZsZHjGueVNg>
    <xme:18r0Y6ZawWH874vXZdOc1N3Kk93nGRN12A2ekwBxNI_x1rkG-A-_qU6QigUr12cKS
    lE-_Bh3paChsQ>
X-ME-Received: <xmr:18r0Y98ULdPoRBVMPfyPVNujtbYb0ODVrp43nidN69lWT8kKvzT2QnuzIq2mIq76SqauTCBs9YsLdxQXlJML2qoBx9GC4hq9M_5s0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudejjedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtugfgjgesth
    ekredttddtjeenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecuggftrfgrthhtvghrnhepgfekffeifeeiveekleetjedvtedvtdeludfgvdfhte
    ejjeeiudeltdefffefvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:18r0YxqpaU9NQ7XbQqLysm7F-ZNFAQk-7HBFmFC6itdLtLUwgbGvMA>
    <xmx:18r0Y2ogJmo5sDr6Xnym2S96PbgdUBekWglY4zKJMpnLVMcrKqvPVA>
    <xmx:18r0Y3Sl-cGfnXR8QtaGgr9W_b8Aj-hSYBY-PRAG5UNPCQ32o-d5CA>
    <xmx:18r0Y3dA5nUE9bWvjpENqQ21D1HfSflsDxeXLXcjCs1bHQzLEUYR0w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Feb 2023 08:44:54 -0500 (EST)
Date:   Tue, 21 Feb 2023 14:44:53 +0100
From:   Greg KH <greg@kroah.com>
To:     Srinivasarao Pathipati <quic_spathi@quicinc.com>
Cc:     stable@vger.kernel.org, gregkh@google.com,
        Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Subject: Re: [PATCH V1] rcu-tasks: Fix build error
Message-ID: <Y/TK1VLDsj2ziKNS@kroah.com>
References: <1676981002-27312-1-git-send-email-quic_spathi@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1676981002-27312-1-git-send-email-quic_spathi@quicinc.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 05:33:22PM +0530, Srinivasarao Pathipati wrote:
> From: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
> 
> Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
> fix below compilation error.
> This is applicable to only 5.10 kernels as code got modified
> in latest kernels.
> 
>  In file included from kernel/rcu/update.c:579:0:
>  kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
>   static void show_rcu_tasks_rude_gp_kthread(void) {}
> 
> Fixes: 8344496e8b49 ("rcu-tasks: Conditionally compile show_rcu_tasks_gp_kthreads()")
> Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
> ---
> v1->v2:

But the subject says "v1"?

confused,

greg k-h
