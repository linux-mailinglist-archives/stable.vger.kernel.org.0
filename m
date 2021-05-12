Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1BE37BD90
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 15:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhELNBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 09:01:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230293AbhELNBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 09:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620824425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TBG1NTcVcwltL4R0K7sm83iWFDXBBOCQ3oeHmt21sgc=;
        b=X0lMWoQW/xV+9thukE2RGKB/k30KxKyTAz8UIwL4UD7LusXOqbIzH/W1k1JOo2fDpVW/SJ
        7MlyjhxsMTV5srXR9/M/8TmYvNp5g6F9b3oX2WApyVTfEj8+pcZYyzMvda22h7J/ksXV/z
        bdlfAY8RB7WsXNRwxJ9FsEIdPAuNB4Q=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-irswjAxrNYqcKhqHzwnWuQ-1; Wed, 12 May 2021 09:00:23 -0400
X-MC-Unique: irswjAxrNYqcKhqHzwnWuQ-1
Received: by mail-lj1-f199.google.com with SMTP id x26-20020a2e9c9a0000b02900eaf62d380eso6370011lji.2
        for <stable@vger.kernel.org>; Wed, 12 May 2021 06:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TBG1NTcVcwltL4R0K7sm83iWFDXBBOCQ3oeHmt21sgc=;
        b=Bdd0LhRehzX1SuAI8s+i/WrM3bSPsBVGXToFtgFGsmPSTBTFsHx1PekVh6eQZOiBoZ
         arQZUKIVD0YnHKPkbrAaMWFt1kCGTwecwb4BI1NANJ0wlDXEK7ujtR8lJcjYMWnIPxTz
         1bmO46nI66gyBwkIU85HWqsYjSuGYyBqSvEid7bx2rGz7FWR2mJ/C7nlkwXrkD2sTRfp
         QdULe7vASMl3E0LfihFXHJZ0ytwixCYaHRI3L4NFJYHxLkEYFMhnvIcVwb7kspUrBBAu
         RRz6QAjhbJohOZQvwsU6AKvjGpjqzcmbMnB5teqF2PXcr1CitEpH5LEub+ibhsAtEtkY
         VjCA==
X-Gm-Message-State: AOAM533g65z0PSE8gojtWxufdOj5hs49M+xJ0Nm6aqtcaMI1w66d46qm
        C0LHkHhp4/n0NLttO6plAJ+5ANVrs0XrZZVz4aBtza5CitmaIrgn35/HPY2fQ7U5tTNNgND8L7M
        t7DWOKvwNEHxI8DOj5AwOkuh4Ttn3cDGW
X-Received: by 2002:a2e:9782:: with SMTP id y2mr28103001lji.303.1620824420431;
        Wed, 12 May 2021 06:00:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOLgMtTkqJdpzU0gYsViRsGM65R71xr667Db4EmwyIaj+nFbLFKlHTKJ3ZLLFTAEIwMlE1spIWfXTtzZo7API=
X-Received: by 2002:a2e:9782:: with SMTP id y2mr28102992lji.303.1620824420233;
 Wed, 12 May 2021 06:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <cki.30AF028A01.OS9TECV9G1@redhat.com> <YJstva9S9qPO+2F3@sashalap> <CA+tGwnnyDVtoNy=_CVTjpEpxw7B2omPLGvq50LYYwd4htgvxMg@mail.gmail.com>
In-Reply-To: <CA+tGwnnyDVtoNy=_CVTjpEpxw7B2omPLGvq50LYYwd4htgvxMg@mail.gmail.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Wed, 12 May 2021 14:59:44 +0200
Message-ID: <CA+tGwnk=2dAYq1PVjthRL8nsNkJbg6fKWFCojK2JrPo-rvYJCQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E11=2E19_=28stable?=
        =?UTF-8?Q?=2Dqueue=2C_beb6df0c=29?=
To:     Sasha Levin <sashal@kernel.org>
Cc:     CKI Project <cki-project@redhat.com>,
        skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jianlin Shi <jishi@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 12:16 PM Veronika Kabatova <vkabatov@redhat.com> wr=
ote:
>
> On Wed, May 12, 2021 at 3:22 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Tue, May 11, 2021 at 09:43:50PM -0000, CKI Project wrote:
> > >
> > >Hello,
> > >
> > >We ran automated tests on a recent commit from this kernel tree:
> > >
> > >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git
> > >            Commit: beb6df0ce94f - thermal/core/fair share: Lock the t=
hermal zone while looping over instances
> > >
> > >The results of these automated tests are provided below.
> > >
> > >    Overall result: FAILED (see details below)
> > >             Merge: OK
> > >           Compile: OK
> > >             Tests: FAILED
> > >
> > >All kernel binaries, config files, and logs are available for download=
 here:
> > >
> > >  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.htm=
l?prefix=3Ddatawarehouse-public/2021/05/11/300944713
> > >
> > >One or more kernel tests failed:
> > >
> > >    s390x:
> > >     =E2=9D=8C Networking tunnel: geneve basic test
> > >
> > >    ppc64le:
> > >     =E2=9D=8C LTP
> > >     =E2=9D=8C Networking tunnel: geneve basic test
> > >
> > >    aarch64:
> > >     =E2=9D=8C Networking tunnel: geneve basic test
> > >
> > >    x86_64:
> > >     =E2=9D=8C Networking tunnel: geneve basic test
> >
> > CKI folks, looks like there was a gap between 5.11.16 and now, and idea
> > if the reported issue here is new in the 5.11.19 -rc, or something that
> > regressed earlier?
> >
>
> Hi Sasha,
>
> this is a bug we've previously reported here:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D210569
>
> This is an older bug we've been seeing for a while and thus the
> report should not have been sent. Apologies for that - we fixed
> some permission issues with reporting yesterday and it must
> have uncovered an underlying bug. This is the only list that hits
> the problem. We'll look into that reason right away.
>

The reporting bug is fixed now. However, there's ~10 pipelines still
running (they were triggered before the fix was in place) that will
likely hit the same networking bug. Let me know if I should cancel
those runs or if I should keep them running in case any new
failures are picked up.

> Veronika
>
> > --
> > Thanks,
> > Sasha
> >

