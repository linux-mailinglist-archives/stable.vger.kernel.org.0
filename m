Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3472F6D2640
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 18:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbjCaQyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 12:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjCaQx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 12:53:57 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FCE1EFE4
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 09:52:54 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bi9so29683180lfb.12
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680281573; x=1682873573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRqGjA4IFBSpXp+ilR/BAk1W8vT0JhFNe6v3C7wlzoo=;
        b=iGu2B9IotHWel6Gv85IfDHmIchNd4aW0ojCsJ7VnYnRa+9MecczZ9+5cJv8b3jW7ev
         PZMfkriPP13RxLuKDvARNTn2qTt42mS9FzQDrqpp+8Yd6MrazVA6gEUYnxXQh3GAW96e
         /k4WkALWmV8yTnzR8lJ7Ih3reb7oTWanoEu4y99Zh59JqpDa2cPjXCbfLXdF6fpGyjwn
         4EJtt94dvioyIJlNgmoh9EFRAH/Z0Q0vl8pXprHTNym2WPhHJMUYzquDCYm+Q8MvI4i9
         BqAor3JCRQ/LZRGRMwyQPlVFWTs0eJrfTOLgmdvsZr0MFZgEkcsyy0ZuwZT2bAPU0Tn4
         i6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281573; x=1682873573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KRqGjA4IFBSpXp+ilR/BAk1W8vT0JhFNe6v3C7wlzoo=;
        b=KYAqlfN1UEdd301b0TyI/FQ4owdKoNovMEQSLWsl7KYgVkCqc16gsi+gbGTZQdueMd
         eX/ELockYycgszdnfeAKd2zizPgVnjPXOjGVMF7nq4h5cqSjI0CvUBxORd2dQGHHUeBL
         p0EiPtK2D9uiGou0EpF5PFjD4I3QE0W+U5xbImbINSMFEtPWoAo+swrbZhgXB39T6shy
         7Y29k98wPgbmxOvz+ShpzQGUrAXSTB4+5C27wzYlWVsfm5qGyGmy8F6HYJm1B6Q5C2it
         Yra3ctgKPF/gPT8EpC8XLOmD5BfJ+EHTBTpvKyK/AtZizz0qaFhdVpKoUm4NZgKf2YYi
         /XQw==
X-Gm-Message-State: AAQBX9fdVIGR5PxFBZV7rrbaXacYxdeBdPzlSqR20YfnfYH8vUOXSNIg
        eje0MxE8zh7N4xcw4QpbVn90ro7l/yo9YJHIqXUjHw==
X-Google-Smtp-Source: AKy350ZDBdotJtsCIiTvfV4i36oUIym0exfSUykMqeFq2GnYu4xjZXuYqedJhRVqQCVhN8/MUcw2n83ZK2jY6xuaJMc=
X-Received: by 2002:ac2:4434:0:b0:4dc:807a:d140 with SMTP id
 w20-20020ac24434000000b004dc807ad140mr8163687lfl.10.1680281572661; Fri, 31
 Mar 2023 09:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230330155707.3106228-1-peterx@redhat.com> <20230330155707.3106228-2-peterx@redhat.com>
 <CAJHvVcgDZBi6pH0BD12sQ3T+7Kr9exX1QU3-YLTd1voYhVBN0w@mail.gmail.com> <ZCYMu5P2BJy/2z5t@x1n>
In-Reply-To: <ZCYMu5P2BJy/2z5t@x1n>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Fri, 31 Mar 2023 09:52:16 -0700
Message-ID: <CAJHvVcggL+s=WEGzwR8+QvWgZANiLut+DhmosKtAXZ1F2vtFAg@mail.gmail.com>
Subject: Re: [PATCH 01/29] Revert "userfaultfd: don't fail on unrecognized features"
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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

On Thu, Mar 30, 2023 at 3:27=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Thu, Mar 30, 2023 at 12:04:09PM -0700, Axel Rasmussen wrote:
> > On Thu, Mar 30, 2023 at 8:57=E2=80=AFAM Peter Xu <peterx@redhat.com> wr=
ote:
> > >
> > > This is a proposal to revert commit 914eedcb9ba0ff53c33808.
> > >
> > > I found this when writting a simple UFFDIO_API test to be the first u=
nit
> > > test in this set.  Two things breaks with the commit:
> > >
> > >   - UFFDIO_API check was lost and missing.  According to man page, th=
e
> > >   kernel should reject ioctl(UFFDIO_API) if uffdio_api.api !=3D 0xaa.=
  This
> > >   check is needed if the api version will be extended in the future, =
or
> > >   user app won't be able to identify which is a new kernel.
> >
> > 100% agreed, this was a mistake.
> >
> > >
> > >   - Feature flags checks were removed, which means UFFDIO_API with a
> > >   feature that does not exist will also succeed.  According to the ma=
n
> > >   page, we should (and it makes sense) to reject ioctl(UFFDIO_API) if
> > >   unknown features passed in.
> >
> > I still strongly disagree with reverting this part, my feeling is
> > still that doing so makes things more complicated for no reason.
> >
> > Re: David's point, it's clearly wrong to change semantics so a thing
> > that used to work now fails. But this instead makes it more permissive
> > - existing userspace programs continue to work as-is, but *also* one
> > can achieve the same thing more simply (combine probing +
> > configuration into one step). I don't see any problem with that,
> > generally.
> >
> > But, if David and others don't find my argument convincing, it isn't
> > the end of the world. It just means I have to go update my userspace
> > code to be a bit more complicated. :)
>
> I'd say it's fine if it's your own program that you can in full control
> easily. :) Sorry again for not noticing that earlier.
>
> There's one reason that we may consider keeping the behavior.  IMHO it is
> when there're major softwares that uses the "wrong" ABI (let's say so;
> because it's not following the man pages).  If you're aware any such majo=
r
> softwares (especially open sourced) will break due to this revert patch,
> please shoot.

Well, I did find one example, criu:
https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/uffd.c#L266
It doesn't do the two-step probing process, it looks to me like it
does what my patch was intending users to do:

It just asks for the requested features up-front, without any probing.
And then it returns the subset of features it *actually* got,
ostensibly so the caller can compare that vs. what it requested.

Then again, it looks like the caller doesn't *actually* compare the
features it got vs. what it asked for. I don't know enough about criu
to know if this is a bug, or if they actually just don't care.
https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/uffd.c#L312

>
> >
> > I also still think the man page is incorrect or at least incomplete no
> > matter what we do here; we should be sure to update it as a follow-up.
>
> So far it looks still fine if with this revert.  Maybe I overlooked
> somewhere?
>
> I'll add this into my todo, but with low priority.  If you have suggestio=
n
> already on how to improve the man page please do so before me!

My thinking is that it describes the bits and pieces, but doesn't
explicitly describe end-to-end how to configure a userfaultfd using
the two-step probing approach. (Or state that this is actually
*required*, unless you only want to set features=3D0 in any case.)

Maybe it will be easiest if I just send a patch myself with what I'm
thinking, and we can see what folks think. Always easier to just look
at a patch vs. talking about it in the abstract. :)

>
> --
> Peter Xu
>
