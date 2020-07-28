Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7C7230C87
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 16:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgG1Of3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 10:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730449AbgG1Of3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 10:35:29 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0076CC061794
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 07:35:28 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l1so20944896ioh.5
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 07:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wE63hykpdOWCKf+hJ+uo4tJ4NmzeI9PTAqJH7wvSMlc=;
        b=LhfgIFjPN1Zt6pM27TDwc0D9sQ3LgHFulpPO2SX5S88mG/mDfs8otJIYAkvnkswxld
         9pGQRB5MX9+c/pNc/D2jvjcUfkcaX+O+bWMi/ZdZWSGCZgEcirUgpaGCBHTTFwLDeXxm
         blFwenzn7yqD2djWtvbrpRZs6R2NA61KUwTMx0D/r9/j+IuKq9D9CivCPsM5HlRumsun
         8SeaeatA922UsvA+t5ljvF60Q6rxHuH9aAmjAJ5nqq0yc8rdtO4PxA+a9Y5/pkBdStPf
         L/JGt34i7DNkTsg+8boIo3khF5Q26aC+wBgUC+PHLlS8m0uSQi46IDgH+/15eUls3L+F
         tp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wE63hykpdOWCKf+hJ+uo4tJ4NmzeI9PTAqJH7wvSMlc=;
        b=l2Dwtg3sIe5iGOkZR2xoqEyR5DZNmGGIhooKx+94URFUkYmnI3S9FJynOZ2T+Medvw
         MMiNMBjQaocuo0K9hCLGk950V3AymeccvRFyM3hLvdcVCa1PXfq3vgk1XF5FpoM9zaeE
         7JHb1zcpbIrZ4H4MnAUP27MMtQf41CTzgkMYy51ytmkZXa/sn3z3GPlwXUeqAp8DSj5P
         5u0q99edlYrUHxKt016nkgjn8T4DhJvPV8AsZCOX7vpjGS9qvrpjuYZ48gsUP1J2VBNr
         2M70u12ZHifasRNtCAuaJoXkHBYPcZw1wR/Z9r/NyVjoDbzOSuKyOqPXhIYVUjErf2XS
         PgaA==
X-Gm-Message-State: AOAM531UJ3LTJqzY0NyRXLNL4KTuXi72Irt/sSVQYYz2flOEsv4SjG/5
        bDltUis3EpFBXEfzlBY14XXQmDYGSMEa3T5VvW6eZA==
X-Google-Smtp-Source: ABdhPJy2WEagQVK01W1PoJL3TtsswctQA4jC85OF1eYxNmME8rZTNY5/2CM7uNz/FDIzfpS1C5VvpAW+f52j5jGXddQ=
X-Received: by 2002:a05:6638:134a:: with SMTP id u10mr6463616jad.35.1595946928305;
 Tue, 28 Jul 2020 07:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200727134914.312934924@linuxfoundation.org> <CA+G9fYvBRONMYwX36Hcju4JA5TwstkT2Afyuy2DB1zQcBcc1CA@mail.gmail.com>
 <CAMZfGtVV-u7K+Z0vFLkoKv1UOTfk=a9+r_6G4PYfGLywwnkm3Q@mail.gmail.com>
In-Reply-To: <CAMZfGtVV-u7K+Z0vFLkoKv1UOTfk=a9+r_6G4PYfGLywwnkm3Q@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Jul 2020 20:05:16 +0530
Message-ID: <CA+G9fYs__nNa-090Cm8j_EPYGRfh+y+VTX3ZqR_W1Jcu2suNEQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 4.19 00/86] 4.19.135-rc1 review
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-mm <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, lkft-triage@lists.linaro.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Jul 2020 at 18:33, Muchun Song <songmuchun@bytedance.com> wrote:
>
> Thanks for your test. I have reviewed the patch:
>
> [PATCH 4.19 76/86] mm: memcg/slab: fix memory leak at non-root
> kmem_cache destroy
>
> There is a backport problem and I have pointed out the problem in that email.

Thanks for your suggestions on the other email thread.
I have made changes as you said and boot test pass on x86 now.

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 9c5eb4b08fc3..65bc49f19504 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -842,9 +842,7 @@ static int shutdown_memcg_caches(struct kmem_cache *s)

 static void memcg_set_kmem_cache_dying(struct kmem_cache *s)
 {
-       mutex_lock(&slab_mutex);
        s->memcg_params.dying = true;
-       mutex_unlock(&slab_mutex);
 }

 static void flush_memcg_workqueue(struct kmem_cache *s)

- Naresh
