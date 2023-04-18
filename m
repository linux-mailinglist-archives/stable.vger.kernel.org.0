Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F406E6DF1
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbjDRVRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjDRVRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:17:41 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7DF4486;
        Tue, 18 Apr 2023 14:17:37 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63d4595d60fso2623875b3a.0;
        Tue, 18 Apr 2023 14:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681852657; x=1684444657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AAA8aF4mPhqZHmK0u9kEbgZQGABsloO4vU4l0+3ra0=;
        b=j3Bk+v+sINhDJWw6DAtfQph4Yd3/H5dW7iRnjIpah/WI7LNLLSJPAL1xSCY/ZSMqM0
         14hyHS2k2AjGO8BQ08ztYleEG9Y3SBF/twJj/RdCgR9ibqHXoqL6EIlpoOKm+gyt8Q21
         XYUPtWHqjYGshkv5TN3v1ijaJaN/s5Bu327n+stk4Xr3+RA9vYioOafjKxuE9Q2kvyOZ
         7epwgOh1L6q5q/OUAlMiSdXHwYZdyYaNTKVVbxz2Og1Yk3mmRWdRb6DCsGu1JcuZoxLs
         DZsWfLe6yxvOPULq3HyxwBpo9qMAoJkXpnJvr8g+b86jKrSO0oOcUDfWcjDpa/5olpis
         /WsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681852657; x=1684444657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3AAA8aF4mPhqZHmK0u9kEbgZQGABsloO4vU4l0+3ra0=;
        b=E4oOC8zZ0Gm9g82GuTv4sNU6Gn67cPJ400StfppxmBZbhhBktUKWtY4fcSwiitUYGI
         CGxRVpMi5ys2QAKpaP1Bg24md9O8GdFxJeJhE/nY593nZI+59NmgpJGwDEYdsbsc2TB3
         uu27Yz6fx1nMJdJWX3EqabfhvVAq8grauJYZyPP747FggNByPIgzN+yKkxNf0KGhWJOc
         AMBiAy95WQnmbvWYkltj6Y/JgBxcw212GexDSQTAQMh7JdY5HJM3DQnzcc2CwQxhFLZS
         3SPIGZQuiaDieyEuKo6MX9tsDYemNu2IZND/rv1hqeRVQuJWaAX+fIrjj9rNigit5mGr
         zMCQ==
X-Gm-Message-State: AAQBX9eM0zlFVKQfSjUWApGCFwIrDS1NQuqzbjv1+b+9T6nrOlJWtxnS
        MUEYEv4xNGSYMnUHkHWznpyGWMdvxooFymx8PMQ=
X-Google-Smtp-Source: AKy350bxfvQxTEytHY3k/XpJ/XH4P+vmZCbAvIoB937ALJAy27cfuEtTE1AYj32bq5k7Off6H5gFg5cz4kVb3vXzPXE=
X-Received: by 2002:a17:90a:c095:b0:247:4e73:cbdd with SMTP id
 o21-20020a17090ac09500b002474e73cbddmr174896pjs.9.1681852656654; Tue, 18 Apr
 2023 14:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220203182641.824731-1-shy828301@gmail.com> <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
 <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com> <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
 <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com>
 <efab25ef-c29c-3671-5f26-060bba76d481@suse.cz> <CAHbLzkomXCwabFrNaNyuGBozmindHqVD0ki4n75XJ2V8Uw=9rw@mail.gmail.com>
 <5618f454-7a88-0443-59e7-df9780e9fa50@redhat.com> <CAHbLzkp16tAzFRnM3BUnspnR-qR2JG3c9TqaNq3YHxy9u5ZC6w@mail.gmail.com>
 <67d3e5e1-57be-590d-f925-47b49442a67e@google.com>
In-Reply-To: <67d3e5e1-57be-590d-f925-47b49442a67e@google.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Tue, 18 Apr 2023 14:17:24 -0700
Message-ID: <CAHbLzko3Ho-K8Ur-C1iXdPqBFX2i2SKRMm3QOARUfVovPACXGQ@mail.gmail.com>
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     David Rientjes <rientjes@google.com>
Cc:     willemb@google.com, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 13, 2023 at 4:58=E2=80=AFPM David Rientjes <rientjes@google.com=
> wrote:
>
> On Mon, 3 Apr 2023, Yang Shi wrote:
>
> > On Mon, Apr 3, 2023 at 12:30=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> > >
> > > On 24.03.23 21:12, Yang Shi wrote:
> > > > On Fri, Mar 24, 2023 at 4:25=E2=80=AFAM Vlastimil Babka <vbabka@sus=
e.cz> wrote:
> > > >>
> > > >> On 3/23/23 21:45, Yang Shi wrote:
> > > >>> On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Vlastimil Babka <vbabka@s=
use.cz> wrote:
> > > >>>
> > > >>> Out of curiosity, is there any public link for this CVE? Google s=
earch
> > > >>> can't find it.
> > > >>
> > > >> Only this one is live so far, AFAIK
> > > >>
> > > >> https://bugzilla.redhat.com/show_bug.cgi?id=3D2180936
> > > >
> > > > Thank you.
> > >
> > > There is now
> > >
> > > https://access.redhat.com/security/cve/cve-2023-1582
> >
> > Thank you.
> >
>
> Hi Yang,
>
> commit 24d7275ce2791829953ed4e72f68277ceb2571c6
> Author: Yang Shi <shy828301@gmail.com>
> Date:   Fri Feb 11 16:32:26 2022 -0800
>
>     fs/proc: task_mmu.c: don't read mapcount for migration entry
>
> is backported to 5.10 stable but not to 5.4 or earlier stable trees.  The
> commit advertises to fix a commit from 4.5.
>
> Do we need stable backports for earlier trees or are they not affected?

IIRC, it is needed. But I can't remember why it wasn't. Maybe just
because the patch failed to apply to those trees and needs to backport
the patch manually.

>
> Thanks!
