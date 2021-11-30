Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED2C46305A
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbhK3J73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhK3J73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 04:59:29 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D371C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:56:10 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id s13so43135651wrb.3
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x+F7B2gXFodWAOUxS8alOD+HWeD33G1lK4M9A4gxp5w=;
        b=0287ShL4x0TwxfYJo4tlwP6/W5+FIkPaVFIQSgl2uymfNUufiPaMBCubfg54svc4fR
         Va+qtIuGtGUnyFHjwDDVTea8SlSY3RxQZ2NwykUW4J780dlLWd/C10VUnRi5fHtu1yDP
         SQ20c/Qi0YsZ1x6XmlDW03fGEsv7UjOu23IuvKSu9AeiJlA+aFGCoe21DoOeLzIwgqV0
         plCdIHGO4fS0YrxRAmpjh7Ld/DvOrv6VLKmuCexowi0070J51IqdDrPGBbgVDFFyDMn+
         IhdbKDjAuTbaU/6ypEYuxCMfJ7yEboMIvvE2F1hmFpeF/YswaaREZSo3cJcV4l/sSSoL
         r99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x+F7B2gXFodWAOUxS8alOD+HWeD33G1lK4M9A4gxp5w=;
        b=oCO5RFpEk2TBlrK+pfDJ0Oh3FuR6my2gy9xaAazkWXonu3zQnvSz7kL4LQg8+F/5/+
         3VMbwNyQkAxdc8OY6qA8t1qunFYAkzbPGefW+jFDG2GLRoRsaj0iNGgLdwrvK9Ly0Hab
         s3da6YjtX/CpakS/1N/JxGiKSv0APY6IeNRQVcG8BRKS++wJmAO2BeAc3u1tkTEq/x3p
         +O5haO27DSy4Bo+4o4A9DpWKQ2+a9DH2lvEzPG99YWTGZJ4fjh1Xjmmqb7XnA6SyXwbt
         ZkaIUuFrmB47NtdKtlp2358m/kalyiBSCmtn7kFVIXiNhWOvsED1RuxNRs9li8tSgsXA
         dnuA==
X-Gm-Message-State: AOAM533JJ9rKUhitBuUm/0ApDnzM6ghZzFeBt6UbLDC87dsqOuObjHcQ
        uSuJYZ0o06vD1I9wAoIeffTvip6lAH9+gQ==
X-Google-Smtp-Source: ABdhPJzR9GL134kkzYgU1y1ezq4se+RpDxkYkyvYih+UMflzFYIkcUp2q2ptuvyPdpHMGtRH1jSfwA==
X-Received: by 2002:a5d:4d51:: with SMTP id a17mr37307396wru.384.1638266168656;
        Tue, 30 Nov 2021 01:56:08 -0800 (PST)
Received: from ?IPV6:2003:d9:9706:4700:9438:3394:ac3b:1a31? (p200300d99706470094383394ac3b1a31.dip0.t-ipconnect.de. [2003:d9:9706:4700:9438:3394:ac3b:1a31])
        by smtp.googlemail.com with ESMTPSA id v6sm1735056wmh.8.2021.11.30.01.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 01:56:08 -0800 (PST)
Message-ID: <439aa09f-96e7-1bc6-1a4e-da5390d2aa8e@colorfullife.com>
Date:   Tue, 30 Nov 2021 10:56:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses
Content-Language: en-US
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
References: <163758370314212@kroah.com>
 <20211129194737.827232-1-alexander.mikhalitsyn@virtuozzo.com>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20211129194737.827232-1-alexander.mikhalitsyn@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/29/21 20:47, Alexander Mikhalitsyn wrote:
> For 4.14.y:
>
> Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")
>
> Currently, the exit_shm() function not designed to work properly when
> task->sysvshm.shm_clist holds shm objects from different IPC namespaces.
>
> This is a real pain when sysctl kernel.shm_rmid_forced = 1, because it
> leads to use-after-free (reproducer exists).
>
> This is an attempt to fix the problem by extending exit_shm mechanism to
> handle shm's destroy from several IPC ns'es.
>
> To achieve that we do several things:
>
> 1. add a namespace (non-refcounted) pointer to the struct shmid_kernel
>
> 2. during new shm object creation (newseg()/shmget syscall) we
>     initialize this pointer by current task IPC ns
>
> 3. exit_shm() fully reworked such that it traverses over all shp's in
>     task->sysvshm.shm_clist and gets IPC namespace not from current task
>     as it was before but from shp's object itself, then call
>     shm_destroy(shp, ns).
>
> Note: We need to be really careful here, because as it was said before
> (1), our pointer to IPC ns non-refcnt'ed.  To be on the safe side we
> using special helper get_ipc_ns_not_zero() which allows to get IPC ns
> refcounter only if IPC ns not in the "state of destruction".
>
> Q/A
>
> Q: Why can we access shp->ns memory using non-refcounted pointer?
> A: Because shp object lifetime is always shorther than IPC namespace
>     lifetime, so, if we get shp object from the task->sysvshm.shm_clist
>     while holding task_lock(task) nobody can steal our namespace.
>
> Q: Does this patch change semantics of unshare/setns/clone syscalls?
> A: No. It's just fixes non-covered case when process may leave IPC
>     namespace without getting task->sysvshm.shm_clist list cleaned up.
>
> Link: https://lkml.kernel.org/r/67bb03e5-f79c-1815-e2bf-949c67047418@colorfullife.com
> Link: https://lkml.kernel.org/r/20211109151501.4921-1-manfred@colorfullife.com
> Fixes: ab602f79915 ("shm: make exit_shm work proportional to task activity")
> Co-developed-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: Vasily Averin <vvs@virtuozzo.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>   include/linux/ipc_namespace.h |  15 +++
>   include/linux/sched/task.h    |   2 +-
>   include/linux/shm.h           |  13 ++-
>   ipc/shm.c                     | 176 +++++++++++++++++++++++++---------
>   4 files changed, 159 insertions(+), 47 deletions(-)

Tested ok: The crash is resolved, no observed degradations.


--

     Manfred

