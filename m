Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7512A66B008
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 09:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjAOIzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 03:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjAOIzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 03:55:40 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B6D76AB
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 00:55:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vm8so61581294ejc.2
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 00:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=prWPhVnVFJki+pRqERFubMXJOExa5pQRkGt5Dtr4PRk=;
        b=WH7SNYBaVH1TBQ9i0newLbrCh6GG57BhcMkMUyjIbDo9q4LDNBI1bod8p4zq5oZXKV
         41ERpc9KIET9GBTQz7ABi+z8iwLzzCDuZDxqVKAvMIZcb5utSx2XRq25+ByDrUD30PFE
         Qm+G4fD1gPG790COLDfn8urgXRJ5pYgAB/veuyJxhXM+0yU+Aik7chaNcoBE6B8MW/vq
         gWxt3m8I0DneVuqPUMX+FGfqohQgPIjtid9OGm6wyK4bLEVhpvQYgCa6vXuSZxP+/dUH
         pyU/ZxUtT16v6jNtQx3f6ZSxgERG/l+2jeMSD1TYfUzSBp8YtjeUTpxPlarrEX2jVEcb
         EbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=prWPhVnVFJki+pRqERFubMXJOExa5pQRkGt5Dtr4PRk=;
        b=g0WfVaUJdIN6NyG4UppDg0dLtv2sOIlLocfyY+GhpKVOzszsq63de0XlktgzfcVSjp
         E2blVv/SXdX3qDZmKDpnHTM4S3eU0mmvThnwV9/cP6VUjt3KfaDBDWqnAqkoW0ePrOat
         qVvWLwALhu79wQik5rPyna3feM2esKuxPo2xn/KvAjSHnq08nsqgIJ2W6+V5JYbCRG5v
         li/5hzim+4ctB07Cq7xa+0dXRUW7+qdTGc/3KDqFBBpKonvXWyRQjZumUh8Cwa/P7rVo
         P4x8YMG7JJhk04U17asi2UXwUMDtUgM7mBY9oCwFNqRwdFClnsxER5lJ9o8voZYKuzet
         fphw==
X-Gm-Message-State: AFqh2kr9dOmsNotE2EXQ/qjqFoKdDkW7hj+DsfgowB4GBlA2y1kzG0Ux
        LpmfjjPKzjJuT+1JhNKqCl2lQucPPlI=
X-Google-Smtp-Source: AMrXdXtTATwfDcNQWRzWphf/lTNxwZDsf4IVF/C4+0CbdRfW+XdA0OS3Q6Aoxfil+GPpG4UyDH2zNA==
X-Received: by 2002:a17:907:9054:b0:86e:acae:9852 with SMTP id az20-20020a170907905400b0086eacae9852mr2400444ejc.35.1673772936998;
        Sun, 15 Jan 2023 00:55:36 -0800 (PST)
Received: from gmail.com (1F2EF7EB.nat.pool.telekom.hu. [31.46.247.235])
        by smtp.gmail.com with ESMTPSA id ov38-20020a170906fc2600b0084d4733c428sm8027603ejb.88.2023.01.15.00.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 00:55:35 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Sun, 15 Jan 2023 09:55:30 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Waiman Long <longman@redhat.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        peterz@infradead.org, wangbiao3@xiaomi.com
Subject: Re: FAILED: patch "[PATCH] sched/core: Fix use-after-free bug in
 dup_user_cpus_ptr()" failed to apply to 6.1-stable tree
Message-ID: <Y8O/go30PWPwLwIs@gmail.com>
References: <167368999799102@kroah.com>
 <fea9d850-4942-3457-0e14-573763e891a4@redhat.com>
 <881dc653-a6b4-6fea-542d-e06d79d011e5@redhat.com>
 <41a01c47-ebf6-49c5-45f0-5d03a2a3b805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41a01c47-ebf6-49c5-45f0-5d03a2a3b805@redhat.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Waiman Long <longman@redhat.com> wrote:

> 
> On 1/14/23 14:33, Waiman Long wrote:
> > On 1/14/23 14:28, Waiman Long wrote:
> > > On 1/14/23 04:53, gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 6.1-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > Possible dependencies:
> > > > 
> > > > 87ca4f9efbd7 ("sched/core: Fix use-after-free bug in
> > > > dup_user_cpus_ptr()")
> > > > 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
> > > > 713a2e21a513 ("sched: Introduce affinity_context")
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > ------------------ original commit in Linus's tree ------------------
> > > > 
> > > >  From 87ca4f9efbd7cc649ff43b87970888f2812945b8 Mon Sep 17 00:00:00 2001
> > > > From: Waiman Long <longman@redhat.com>
> > > > Date: Fri, 30 Dec 2022 23:11:19 -0500
> > > > Subject: [PATCH] sched/core: Fix use-after-free bug in
> > > > dup_user_cpus_ptr()
> > > > MIME-Version: 1.0
> > > > Content-Type: text/plain; charset=UTF-8
> > > > Content-Transfer-Encoding: 8bit
> > > > 
> > > > Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
> > > > restricted on asymmetric systems"), the setting and clearing of
> > > > user_cpus_ptr are done under pi_lock for arm64 architecture. However,
> > > > dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
> > > > protection. Since sched_setaffinity() can be invoked from another
> > > > process, the process being modified may be undergoing fork() at
> > > > the same time.  When racing with the clearing of user_cpus_ptr in
> > > > __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
> > > > possibly double-free in arm64 kernel.
> > > > 
> > > > Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
> > > > cpumask") fixes this problem as user_cpus_ptr, once set, will never
> > > > be cleared in a task's lifetime. However, this bug was re-introduced
> > > > in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
> > > > do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
> > > > do_set_cpus_allowed(). This time, it will affect all arches.
> > > > 
> > > > Fix this bug by always clearing the user_cpus_ptr of the newly
> > > > cloned/forked task before the copying process starts and check the
> > > > user_cpus_ptr state of the source task under pi_lock.
> > > > 
> > > > Note to stable, this patch won't be applicable to stable releases.
> > > > Just copy the new dup_user_cpus_ptr() function over.
> > > 
> > > I have a note here about what to do when backporting to stable. Just
> > > copy the new function over will be fine.
> > 
> > That will be before the application of the subsequent patch which will
> > modify it in a way for suitable for stable. I can send out a separate
> > stable patch for that later today.
> 
> The attached patch will apply to linux-6.1.y as well as linux-5.15.y.

Thanks!

Acked-by: Ingo Molnar <mingo@kernel.org>


	Ingo
