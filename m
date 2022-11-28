Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F89D63B3E4
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 22:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiK1VFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 16:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbiK1VF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 16:05:29 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430AC2F661
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 13:05:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so7039565pjm.2
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 13:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:user-agent:message-id:in-reply-to:date:references
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BGX7hfaY8PrwSdh6wRnZ749ZbmsO0yV8MOm6wQ03sc4=;
        b=TilKPp5CJEIfWhZ9LVAUQiZSC+ziSOJTgYVKuAQKjuMVcpgMbmLURQUkMGMb4Hl6L0
         OQqilnXk++vwtHa+u8/WT3BRWFYZEgjSQp1hlZsfNXCQ5in/XaHz12gf+0CWYJ5vPiWq
         rbiCj9AjJnZWV3t6emouLRWVweVWWdXMxRYvR9IlA5DsMhKPRXyBFMPXoeoNxE0czNU8
         MT4a5qrqviEd4i0O3ONiKt6xCRU6edOfN/Q6wQOsonLWBOoAVOWiY/aHRJE0Fn1G/MDq
         Cuqs01FeSMZkj7tiqoXSrHiQwHO4IXOcxyKQYagxd77LAe0Eg+3zmmkuQrJNKkSrP/0N
         45qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:message-id:in-reply-to:date:references
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGX7hfaY8PrwSdh6wRnZ749ZbmsO0yV8MOm6wQ03sc4=;
        b=v//IovjcDnSdtq4xn4xC80w1cSu4r8+Mxl7qh/As34gc5DNDygdHZRqftKX5DlxQm4
         Z6dIe7+EkJByuICQWx3sS4CbF0d4cEjvaKPKa6zra8fYvpSXKVN2AkBLXl2WLqcGjLNB
         hr8cZEACdS987nD/wM7HY0wjGB6FxIsKILw+gp5/3ki1V+NbqqCzep9qDOmJrJQzEOl9
         JCUG+H/L+M6q3gWyEvaih/TB3FH5NiJzVWb4CpeFt7KLmYx3ErWzhoFT4pv3AreYTmm8
         CwjL3qs/7mmouYMqH787klxhLIjHpoK3RDTR/6qcJFPUGwbPRMP89iBI65Crjsdm8da1
         26Mw==
X-Gm-Message-State: ANoB5pkpzuuVq1qCGM2qfNbpcWkCPfLyyjpZvXRAvSp1bueriTL5UN+O
        voCF1UwGm2yXnZMU174AWQMNz9A3PG6ENQ==
X-Google-Smtp-Source: AA0mqf5PNM45SojwuPflvbtOOZ+EvyYJY3fzv4+yS5C5DMJ4DIaYlwzPCQ1/qBL9GhUxyLX7LoBE6Q==
X-Received: by 2002:a17:90a:5b09:b0:218:a0cd:5a99 with SMTP id o9-20020a17090a5b0900b00218a0cd5a99mr45221414pji.76.1669669519908;
        Mon, 28 Nov 2022 13:05:19 -0800 (PST)
Received: from bsegall-glaptop.localhost (c-67-188-112-16.hsd1.ca.comcast.net. [67.188.112.16])
        by smtp.gmail.com with ESMTPSA id 22-20020a621616000000b005624e2e0508sm8391748pfw.207.2022.11.28.13.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 13:05:18 -0800 (PST)
From:   Benjamin Segall <bsegall@google.com>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     <gregkh@linuxfoundation.org>, <shakeelb@google.com>,
        <viro@zeniv.linux.org.uk>, <mdecandia@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/2] Fix epoll issue in 5.4 kernels
References: <20221124001123.3248571-1-risbhat@amazon.com>
Date:   Mon, 28 Nov 2022 13:05:17 -0800
In-Reply-To: <20221124001123.3248571-1-risbhat@amazon.com> (Rishabh
        Bhatnagar's message of "Thu, 24 Nov 2022 00:11:21 +0000")
Message-ID: <xm26wn7en62a.fsf@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rishabh Bhatnagar <risbhat@amazon.com> writes:

> Hi Greg
> After upgrading to 5.4.211 we were started seeing some nodes getting
> stuck in our Kubernetes cluster. All nodes are running this kernel
> version. After taking a closer look it seems that runc was command getting
> stuck. Looking at the stack it appears the thread is stuck in epoll wait for
> sometime. 
> [<0>] do_syscall_64+0x48/0xf0
> [<0>] entry_SYSCALL_64_after_hwframe+0x5c/0xc1
> [<0>] ep_poll+0x48d/0x4e0
> [<0>] do_epoll_wait+0xab/0xc0
> [<0>] __x64_sys_epoll_pwait+0x4d/0xa0
> [<0>] do_syscall_64+0x48/0xf0
> [<0>] entry_SYSCALL_64_after_hwframe+0x5c/0xc1
> [<0>] futex_wait_queue_me+0xb6/0x110
> [<0>] futex_wait+0xe2/0x260
> [<0>] do_futex+0x372/0x4f0
> [<0>] __x64_sys_futex+0x134/0x180
> [<0>] do_syscall_64+0x48/0xf0
> [<0>] entry_SYSCALL_64_after_hwframe+0x5c/0xc1
>
> I noticed there are other discussions going on as well
> regarding this.
> https://lore.kernel.org/all/Y1pY2n6E1Xa58MXv@kroah.com/
> Reverting the below patch does fix the issue:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=cf2db24ec4b8e9d399005ececd6f6336916ab6fc
> We don't see this issue in latest upstream kernel or even latest 5.10
> stable tree. Looking at the patches that went in for 5.10 stable there's
> one that stands out that seems to be missing in 5.4.
> 289caf5d8f6c61c6d2b7fd752a7f483cd153f182 (epoll: check for events when removing
> a timed out thread from the wait queue)
>
> Backporting this patch to 5.4 we don't see the hangups anymore. Looks like
> this patch fixes time out scenarios which might cause missed wake ups.
> The other patch in the patch series also fixes a race and is needed for
> the second patch to apply.

Yes, this definitely makes sense to me; the aggressive removal was only
valid because the rest of the epoll machinery did plenty of extra
checking. And I didn't as carefully check the backports when I saw the
-stable emails.
