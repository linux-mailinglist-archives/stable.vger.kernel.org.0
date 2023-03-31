Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476AA6D291B
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 22:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjCaUFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 16:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCaUFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 16:05:32 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D92135
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 13:05:31 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id c9so19953676lfb.1
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 13:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680293130; x=1682885130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhMkBqMOvsh1hs5NuN3XdIseTUJUxytQaVYnt3fGACo=;
        b=CKiFHrTcdNs+6RXLHaR0N4wjV3XmkpbLlpU2eTJg6eUxdnNesJSQL5gOC2c6nHDTU9
         gxpsA2oZSTp7IGANoD0B5g+0ZzZ9iAnw23wzwBevscy/ZndGTbcRlfzNhh/NaabzubS2
         s8TRR/mgxdeedBpBoRBHYqwATp78WJeMQ+L9EH82IBSkHdXQeWi3Ojp9WUBoyaeN1/OI
         b33WYYdIoa+Fs3vGUDO3Elh/Qgx30ZcW0g8oWIpWezYzFKuKSI3yKlf06k+1r37CTvQW
         V7Z4zh1PST/cFgqSkP7zVqpvLwW6b06orTGI1AfTA+k0QXQZcUsSvMjxGJwQX8FrlbrV
         J9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680293130; x=1682885130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhMkBqMOvsh1hs5NuN3XdIseTUJUxytQaVYnt3fGACo=;
        b=FlUT7jDDH220mSJnWnGM6dpCGMWRMhbGgKQA8wtXYUtSQB4By9VwqhRiGErCmeR0cF
         JlTEXnmEF/bsR6QKneBoJJljD45glC7zlEXEb9aQAMiDdif6Lw45iFojAvoA3XKWwz54
         QcLAyAnUsDyB7IKiU+NULE4eNtnQp2pMizVhUljo5mADM2WbVVOlUQaziG3kLNshY93n
         JG1YjJH6u0cLxR4UJsgszoivTrVPOYMH45wgBfP4E6pPgHJLEREyHuLZQGzqNSrWEyJe
         +dwWzmYFjUtOM5zGfADlN+qhey2umu3KBHpjM9+6jslf0dlN9GGWiKEG+GRflB+nfE7j
         TPGw==
X-Gm-Message-State: AAQBX9elsW5csIPuvNRdcWzgJf+HKhmNQS8u5OJsEe5XF71tT6k9BrFR
        rFnFwKMOO3ETs3tFZyAgjEbYZgI00RAFGp2VHzfGIg==
X-Google-Smtp-Source: AKy350ZzxL9raDUswX9rEq9TaPaTi0wrfS1d40b4KfnhPiA1zGs8nwTqdPTUKJa2azKoy8XydInoIfJUvcJs1iaagjg=
X-Received: by 2002:a05:6512:23a3:b0:4d8:86c2:75ea with SMTP id
 c35-20020a05651223a300b004d886c275eamr4951980lfv.3.1680293129654; Fri, 31 Mar
 2023 13:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230330155707.3106228-1-peterx@redhat.com> <20230330155707.3106228-2-peterx@redhat.com>
 <CAJHvVcgDZBi6pH0BD12sQ3T+7Kr9exX1QU3-YLTd1voYhVBN0w@mail.gmail.com>
 <ZCYMu5P2BJy/2z5t@x1n> <CAJHvVcggL+s=WEGzwR8+QvWgZANiLut+DhmosKtAXZ1F2vtFAg@mail.gmail.com>
 <CAJwJo6YrfDH5-Tdsbau-AevVUuqiDQE74se3XvenT20Fbrrcnw@mail.gmail.com>
In-Reply-To: <CAJwJo6YrfDH5-Tdsbau-AevVUuqiDQE74se3XvenT20Fbrrcnw@mail.gmail.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Fri, 31 Mar 2023 13:04:53 -0700
Message-ID: <CAJHvVcgiLbACcCr1O4ng7vrxC1Sok_HXDuzbvnVyAaeqGfdwuw@mail.gmail.com>
Subject: Re: [PATCH 01/29] Revert "userfaultfd: don't fail on unrecognized features"
To:     Dmitry Safonov <0x7f454c46@gmail.com>
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
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 11:08=E2=80=AFAM Dmitry Safonov <0x7f454c46@gmail.c=
om> wrote:
>
> On Fri, 31 Mar 2023 at 17:52, Axel Rasmussen <axelrasmussen@google.com> w=
rote:
> >
> > On Thu, Mar 30, 2023 at 3:27=E2=80=AFPM Peter Xu <peterx@redhat.com> wr=
ote:
> > >
> > > On Thu, Mar 30, 2023 at 12:04:09PM -0700, Axel Rasmussen wrote:
> > > > On Thu, Mar 30, 2023 at 8:57=E2=80=AFAM Peter Xu <peterx@redhat.com=
> wrote:
> > > > >
> > > > > This is a proposal to revert commit 914eedcb9ba0ff53c33808.
> > > > >
> > > > > I found this when writting a simple UFFDIO_API test to be the fir=
st unit
> > > > > test in this set.  Two things breaks with the commit:
> > > > >
> > > > >   - UFFDIO_API check was lost and missing.  According to man page=
, the
> > > > >   kernel should reject ioctl(UFFDIO_API) if uffdio_api.api !=3D 0=
xaa.  This
> > > > >   check is needed if the api version will be extended in the futu=
re, or
> > > > >   user app won't be able to identify which is a new kernel.
> > > > >
> > > > >   - Feature flags checks were removed, which means UFFDIO_API wit=
h a
> > > > >   feature that does not exist will also succeed.  According to th=
e man
> > > > >   page, we should (and it makes sense) to reject ioctl(UFFDIO_API=
) if
> > > > >   unknown features passed in.
>
> If features/flags are not checked in kernel, and the kernel doesn't
> return an error on
> an unknown flag/error, that makes the syscall non-extendable, meaning
> that adding
> any new feature may break existing software, which doesn't sanitize
> them properly.
> https://lwn.net/Articles/588444/

I don't think the same problem applies here. In the case of syscalls,
the problem is the only way the kernel can communicate is by the
EINVAL return value. Without the check, if a call succeeds the caller
can't tell: was the flag supported + applied, or unrecognized +
ignored?

With UFFDIO_API (we aren't talking about userfaultfd(2) itself), when
you pass in a set of flags, we return the subset of flags which were
enabled, in addition to the return code. So via that mechanism, one is
"able to check whether it is running on a kernel where [userfaultfd]
supports [the feature]" as the article describes - the only difference
is, the caller must check the returned set of features, instead of
checking for an error code. I don't think it's exactly *how* userspace
can check that's important, but rather *that* it can check.

Another important difference: I have a hard time imagining a case
where adding a new feature could break userspace, even with my
approach, but let's say for the sake of argument one arises in the
future. Unlike normal syscalls, we have the UFFD_API version check, so
we have the option of incrementing that to separate users relying on
the old behavior, from users willing to deal with the new behavior.

(Syscalls can kind of replicate this by adding a new syscall, like
clone() vs clone2(), but I think that's messier than the API version
check being built-in to the API.)

>
> See a bunch of painful exercises from syscalls with numbers in the end:
> https://lwn.net/Articles/792628/
> To adding an additional setsockopt() because an old one didn't have
> sanity checks for flags:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D8917a777be3b
> (not the best example, as the new setsockopt() didn't check flags for
> sanity as well (sic!),
> but that's near the code I work on now)
>
> This is even documented nowadays:
> https://www.kernel.org/doc/html/latest/process/adding-syscalls.html#desig=
ning-the-api-planning-for-extension
>
> ...and everyone knows what happens when you blame userspace for breaking =
by
> not doing what you would have expected it to do:
> https://lkml.org/lkml/2012/12/23/75

100% agreed. :)

>
> [..]
> > > There's one reason that we may consider keeping the behavior.  IMHO i=
t is
> > > when there're major softwares that uses the "wrong" ABI (let's say so=
;
> > > because it's not following the man pages).  If you're aware any such =
major
> > > softwares (especially open sourced) will break due to this revert pat=
ch,
> > > please shoot.
> >
> > Well, I did find one example, criu:
> > https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/uffd.c#L2=
66
>
> Mike can speak better than me about uffd, but AFAICS, CRIU correctly dete=
cts
> features with kerneldat/kdat:
> https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/kerndat.c#L=
1235

Ah, right, this is the simplest case where no optional features are
asked for. So, it's not a great example; this particular case would
look the same regardless of what the kernel does.

>
> So, doing a sane thing in kernel shouldn't break CRIU (at least here).
>
> Thanks,
>              Dmitry
