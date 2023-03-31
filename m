Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4666D278D
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 20:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjCaSId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 14:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjCaSIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 14:08:32 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB0C133;
        Fri, 31 Mar 2023 11:08:31 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 72-20020a9d064e000000b006a2f108924cso817929otn.1;
        Fri, 31 Mar 2023 11:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680286111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3lL8ptrd/luySMEjAQve8KEssZBP6yJTIAyyXPQHgg=;
        b=TijtgZgJPoSAkrcF9V9ctcDVZf1Gr7uaoWdV1AaSjm/KZE5h4sYlBoiTiAt9zc1eCT
         bEzo5N3F1nEvBlji5hWX5MiJWmvZ4/j1AY1gk3EaP6GT+eGUy5iA1vfl34lH6syE08ih
         5m+fEYn4UId09hnyghSoIsBqnVREoKJ8cktxaK3unfkBnREtG+Tvg7W0FV9yFKoyTZ28
         7RspSMLiGq/E5fUE0YWIYczKAThUMo5PGLplYoO3wc0tbyvULkxXR5Wdd8hGWdjz9Ki/
         n8HzZzHwhI8BbETWOExrjzXGl+KiuUgdPOU4xcX+xg6NhdUtZvU71oUmjKhit4SAKBYP
         03KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680286111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3lL8ptrd/luySMEjAQve8KEssZBP6yJTIAyyXPQHgg=;
        b=PXzEbaWzswOO8Dn7YjaWq2iMZdVDrDPvbPIju6OJGqapmdLCwk0RN4NOSmMHcTEjTu
         LddJgE2fFYht/vZ5Gz+s8HRQbqc1BSyHf3ddgm4WR1n2BCXrmZmow2pwwVybiLVSAfx2
         kvuieix+Z8EHoa51Ba+aK25hcqqKuLWwXYfCpJ6RI4M9Y1vqRCdrkzSrddktNs/iTr2J
         ViCeWZKTe6KV96Pc/ZIdUGk0THvZskXLWCgOX2FKGSbmU37Ud1vBRpGrh/oUTz2yoAAL
         BNYRFR9Xlej0s2UXj8q2PVAiZJMoE8TRreWrJCevE1P3kSPrhHPSNUAXfLDHgjuedhv3
         mN3Q==
X-Gm-Message-State: AO0yUKUax8pCKXGn/pMxnumnPZXKe5S0lASIjkaZA66h0fXVWz6GUfx3
        SGzdfJV3woGIwd8MEwaeLiNwra536+3ExPyTFbE=
X-Google-Smtp-Source: AK7set981SrirQiFBWaZxlcKxBR0kBTYWv3oV3+6NxYBBpyhgoIO34kYohYYC30hWZ7ZG587NryXaQK1ELbmMLMxtPw=
X-Received: by 2002:a05:6830:86:b0:69f:2a7b:22b9 with SMTP id
 a6-20020a056830008600b0069f2a7b22b9mr8992270oto.0.1680286110928; Fri, 31 Mar
 2023 11:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230330155707.3106228-1-peterx@redhat.com> <20230330155707.3106228-2-peterx@redhat.com>
 <CAJHvVcgDZBi6pH0BD12sQ3T+7Kr9exX1QU3-YLTd1voYhVBN0w@mail.gmail.com>
 <ZCYMu5P2BJy/2z5t@x1n> <CAJHvVcggL+s=WEGzwR8+QvWgZANiLut+DhmosKtAXZ1F2vtFAg@mail.gmail.com>
In-Reply-To: <CAJHvVcggL+s=WEGzwR8+QvWgZANiLut+DhmosKtAXZ1F2vtFAg@mail.gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Date:   Fri, 31 Mar 2023 19:08:19 +0100
Message-ID: <CAJwJo6YrfDH5-Tdsbau-AevVUuqiDQE74se3XvenT20Fbrrcnw@mail.gmail.com>
Subject: Re: [PATCH 01/29] Revert "userfaultfd: don't fail on unrecognized features"
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 31 Mar 2023 at 17:52, Axel Rasmussen <axelrasmussen@google.com> wro=
te:
>
> On Thu, Mar 30, 2023 at 3:27=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Thu, Mar 30, 2023 at 12:04:09PM -0700, Axel Rasmussen wrote:
> > > On Thu, Mar 30, 2023 at 8:57=E2=80=AFAM Peter Xu <peterx@redhat.com> =
wrote:
> > > >
> > > > This is a proposal to revert commit 914eedcb9ba0ff53c33808.
> > > >
> > > > I found this when writting a simple UFFDIO_API test to be the first=
 unit
> > > > test in this set.  Two things breaks with the commit:
> > > >
> > > >   - UFFDIO_API check was lost and missing.  According to man page, =
the
> > > >   kernel should reject ioctl(UFFDIO_API) if uffdio_api.api !=3D 0xa=
a.  This
> > > >   check is needed if the api version will be extended in the future=
, or
> > > >   user app won't be able to identify which is a new kernel.
> > > >
> > > >   - Feature flags checks were removed, which means UFFDIO_API with =
a
> > > >   feature that does not exist will also succeed.  According to the =
man
> > > >   page, we should (and it makes sense) to reject ioctl(UFFDIO_API) =
if
> > > >   unknown features passed in.

If features/flags are not checked in kernel, and the kernel doesn't
return an error on
an unknown flag/error, that makes the syscall non-extendable, meaning
that adding
any new feature may break existing software, which doesn't sanitize
them properly.
https://lwn.net/Articles/588444/

See a bunch of painful exercises from syscalls with numbers in the end:
https://lwn.net/Articles/792628/
To adding an additional setsockopt() because an old one didn't have
sanity checks for flags:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8917a777be3b
(not the best example, as the new setsockopt() didn't check flags for
sanity as well (sic!),
but that's near the code I work on now)

This is even documented nowadays:
https://www.kernel.org/doc/html/latest/process/adding-syscalls.html#designi=
ng-the-api-planning-for-extension

...and everyone knows what happens when you blame userspace for breaking by
not doing what you would have expected it to do:
https://lkml.org/lkml/2012/12/23/75

[..]
> > There's one reason that we may consider keeping the behavior.  IMHO it =
is
> > when there're major softwares that uses the "wrong" ABI (let's say so;
> > because it's not following the man pages).  If you're aware any such ma=
jor
> > softwares (especially open sourced) will break due to this revert patch=
,
> > please shoot.
>
> Well, I did find one example, criu:
> https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/uffd.c#L266

Mike can speak better than me about uffd, but AFAICS, CRIU correctly detect=
s
features with kerneldat/kdat:
https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/kerndat.c#L12=
35

So, doing a sane thing in kernel shouldn't break CRIU (at least here).

Thanks,
             Dmitry
