Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4C37BBB5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 13:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhELLZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 07:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELLZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 07:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620818673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t96WYaMfr/ZXM0Bax4XVL4Bo9DZ8cl5O8ICxHP3JqQ0=;
        b=euv+JcU84+yggVOpnKyD56vMTQ1be2NU+IYPwDAtRlOyC8j7srpUybR/1tplK2CGfuOHUq
        6qqH7m9+5HR+gfw3GHtmIF7jGN4fh3IdgbwEVHjiaZbRiRcKasazuzgvCzwad1IJlVExvK
        M8+iBR5k+e/orQYBPKoDQj6xsk7Dzp0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-8GX9f7PMNo22aPtWnQNqtQ-1; Wed, 12 May 2021 07:24:31 -0400
X-MC-Unique: 8GX9f7PMNo22aPtWnQNqtQ-1
Received: by mail-lj1-f197.google.com with SMTP id b35-20020a2ebc230000b02900e586a5ceaeso9828291ljf.13
        for <stable@vger.kernel.org>; Wed, 12 May 2021 04:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t96WYaMfr/ZXM0Bax4XVL4Bo9DZ8cl5O8ICxHP3JqQ0=;
        b=DTf0jbP0HVvXneJv586lZAvXV2nlbaFAIwTgMohEHCoxZegdhqfaIzHh9qshJ4Sa2f
         7RJXAfJZ764BWwMDNZGjM2T0hIOasU48i0y30/0Gud7AxxTScS9Nd5bFqd0NTYpIvRKg
         2+Wdp2yLCNS9XEWLmMeMGjAQCFRxjUV9+VNFcn/ejcAbtEVQqT4ZwPuNzYt6YZlfPpNp
         yu0KuvNs1d8JsJrIRvd64QQa4gqT1RXNJwXrYwqANuFWW/kuTEP9oLlRKRb1R+29MkT2
         ziW4nLLzqS8O5F5QPGSuD4kA/p8kZh+13hMNBkvY4TPQQsLtfPm5E+WC9a1sFklA3mKz
         nXbw==
X-Gm-Message-State: AOAM533DPOOPHf+zqSHWyOnUW8rj1Q4ClO7NqgbAAh/dgX3+nQdAVacV
        71T2xw7LrQpfB3k223+V+YavG+t08U7dopHRKwLye5PSnwRLTcdG0UhkGEqNCmEzSnGievq2jHs
        zVEdrN6+xc0piKOSEXi/f2xTbPieLI8H6
X-Received: by 2002:ac2:5e6e:: with SMTP id a14mr23707919lfr.201.1620818670216;
        Wed, 12 May 2021 04:24:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykwlwy3hliqhK37xtgHA7tHLZRc1whbSnwvi2MPVcC0HwLdR3TX9FLrk37jdqZocSWkQ3P06/ZLehdo+9ZcIE=
X-Received: by 2002:ac2:5e6e:: with SMTP id a14mr23707899lfr.201.1620818670041;
 Wed, 12 May 2021 04:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <cki.30AF028A01.OS9TECV9G1@redhat.com> <YJstva9S9qPO+2F3@sashalap>
 <CA+tGwnnyDVtoNy=_CVTjpEpxw7B2omPLGvq50LYYwd4htgvxMg@mail.gmail.com> <CAJxqp2-KA+VPS59hKsN9z-ysZdo1Edv52vfnHYsXioO-CqeXcg@mail.gmail.com>
In-Reply-To: <CAJxqp2-KA+VPS59hKsN9z-ysZdo1Edv52vfnHYsXioO-CqeXcg@mail.gmail.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Wed, 12 May 2021 13:23:53 +0200
Message-ID: <CA+tGwnmBG-XXKP478x7woFbWaeRNhdCBOL1gmOhg+9-yq3sVFw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E11=2E19_=28stable?=
        =?UTF-8?Q?=2Dqueue=2C_beb6df0c=29?=
To:     Jianwen Ji <jiji@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        CKI Project <cki-project@redhat.com>,
        skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jianlin Shi <jishi@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 12:55 PM Jianwen Ji <jiji@redhat.com> wrote:
>
>
>
> On Wed, May 12, 2021 at 6:17 PM Veronika Kabatova <vkabatov@redhat.com> w=
rote:
>>
>> On Wed, May 12, 2021 at 3:22 AM Sasha Levin <sashal@kernel.org> wrote:
>> >
>> > On Tue, May 11, 2021 at 09:43:50PM -0000, CKI Project wrote:
>> > >
>> > >Hello,
>> > >
>> > >We ran automated tests on a recent commit from this kernel tree:
>> > >
>> > >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/s=
table/linux-stable-rc.git
>> > >            Commit: beb6df0ce94f - thermal/core/fair share: Lock the =
thermal zone while looping over instances
>> > >
>> > >The results of these automated tests are provided below.
>> > >
>> > >    Overall result: FAILED (see details below)
>> > >             Merge: OK
>> > >           Compile: OK
>> > >             Tests: FAILED
>> > >
>> > >All kernel binaries, config files, and logs are available for downloa=
d here:
>> > >
>> > >  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.ht=
ml?prefix=3Ddatawarehouse-public/2021/05/11/300944713
>> > >
>> > >One or more kernel tests failed:
>> > >
>> > >    s390x:
>> > >     =E2=9D=8C Networking tunnel: geneve basic test
>> > >
>> > >    ppc64le:
>> > >     =E2=9D=8C LTP
>> > >     =E2=9D=8C Networking tunnel: geneve basic test
>> > >
>> > >    aarch64:
>> > >     =E2=9D=8C Networking tunnel: geneve basic test
>> > >
>> > >    x86_64:
>> > >     =E2=9D=8C Networking tunnel: geneve basic test
>> >
>> > CKI folks, looks like there was a gap between 5.11.16 and now, and ide=
a
>> > if the reported issue here is new in the 5.11.19 -rc, or something tha=
t
>> > regressed earlier?
>> >
>>
>> Hi Sasha,
>>
>> this is a bug we've previously reported here:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D210569
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D210569 should have been fix=
ed upstream.
>
> I think the current bug we have is https://bugzilla.kernel.org/show_bug.c=
gi?id=3D212749.
>

Thanks for correction Jianwen! The logs look very similar so our
result database treated the two issues as the same. According to
this BZ comments, it was not yet fixed in mainline, is that correct?

Veronika

>>
>>
>>
>> This is an older bug we've been seeing for a while and thus the
>> report should not have been sent. Apologies for that - we fixed
>> some permission issues with reporting yesterday and it must
>> have uncovered an underlying bug. This is the only list that hits
>> the problem. We'll look into that reason right away.
>>
>> Veronika
>>
>> > --
>> > Thanks,
>> > Sasha
>> >
>>
>
>
> --
>
> Jianwen Ji
>
> He/Him
>
> Quality Engineering
>
> Red Hat Beijing
>
> T: +86-10-62608073

