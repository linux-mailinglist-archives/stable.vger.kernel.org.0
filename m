Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367CD3CD73E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhGSOOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:14:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241165AbhGSOOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 10:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626706515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xWvk2iO+qHDD55WmI8XTNIwZwQaJsk4hSxwFsF8T05I=;
        b=F7jO9lRfK+xryoQVjWEPCrCUAFsLM/gGkdf9Zl/rznbngCy3I0b2Qp9fHhXcNv6SxvvmaN
        fEnwAtH4PiDRr7OpGaW3uVqSPfvnCM38fSEZ1R1ffqbjtassmunCkh4KqR34NfkoB1YuTv
        axS0xMRyF+gEmwg6ZTUVcbZxMWfTjeU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-pTnNJwxIOTaRoz9z2VWA4A-1; Mon, 19 Jul 2021 10:55:13 -0400
X-MC-Unique: pTnNJwxIOTaRoz9z2VWA4A-1
Received: by mail-lj1-f200.google.com with SMTP id a5-20020a2e7f050000b0290192ede80275so6998434ljd.12
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 07:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xWvk2iO+qHDD55WmI8XTNIwZwQaJsk4hSxwFsF8T05I=;
        b=Sz2PX+UA3V5DbUekty5t2kKhYQgIgrYLGKiEmQqeI7BkoJlFv8BdCkccCmwBoqMy75
         EMMJhdQ7tCRiKmIQrbKHXxBCs+dYPWSdy6kKmO/PHWS5HP6pILUybfaNT5nO0W95wWX7
         ZT6wiBZXm/tRTBgZSQ/hrVUMxEK+zTFht4HB8iVaZCVL37oLKmih0yQuOtSe1BMG9lTI
         zbRwFxBw+EJcXr9RD0iCw2SVITCz9nbLF25mF7u0T8xlx7NtbLxVHDTTZyaEPb2ltDkV
         toBDYHusYmm+qcdHQnmT9QqlULEp62pV64/ZQbCCea0Dy26VuvmBcMvRcoAceU4oMIJH
         rN6g==
X-Gm-Message-State: AOAM532ZOTXXhfYyztjFqLSfmyjwA8HWCZOD68OS3T5B8EI+F4OGAEAE
        jl00ErCkKRTcdJeMQoYRa5cR6PiG2eY7jMqd1wqHMq5zv/8ck7WVXJVohUk+90+ixRFs5XaMh9c
        RPhrrynDNY8Eh/4i9MEAgzRQkoM1Rs3nh
X-Received: by 2002:a2e:7e09:: with SMTP id z9mr22515667ljc.340.1626706512345;
        Mon, 19 Jul 2021 07:55:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9yNGNmNbgVjG3xh9W7Eiq2gyMA4XB0UlYnK7Q+10stBtUa8gzP1G6zO0YlZLbxLqxgMPtnxtniC90QbQYvOg=
X-Received: by 2002:a2e:7e09:: with SMTP id z9mr22515654ljc.340.1626706512149;
 Mon, 19 Jul 2021 07:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <cki.4B06E639A0.ME3EXCXRTW@redhat.com> <CA+tGwnkjpwHE6=5MxFRnHSZ6=LYN_uiJQhTOP1oTr2rqhSiTyg@mail.gmail.com>
 <YOyPn2MPRWjI3BnN@kroah.com>
In-Reply-To: <YOyPn2MPRWjI3BnN@kroah.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Mon, 19 Jul 2021 16:54:36 +0200
Message-ID: <CA+tGwn=trnVtDiUjHhvDJPMDNoXMnFc359ECSv39F_AB0++j+w@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E12=2E16_=28stable?=
        =?UTF-8?Q?=2Dqueue=2C_e2aabcec=29?=
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 8:53 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jul 12, 2021 at 03:40:01PM +0200, Veronika Kabatova wrote:
> > On Mon, Jul 12, 2021 at 3:37 PM CKI Project <cki-project@redhat.com> wr=
ote:
> > >
> > >
> > > Hello,
> > >
> > > We ran automated tests on a recent commit from this kernel tree:
> > >
> > >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/s=
table/linux-stable-rc.git
> > >             Commit: e2aabcece18e - powerpc/preempt: Don't touch the i=
dle task's preempt_count during hotplug
> > >
> > > The results of these automated tests are provided below.
> > >
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: FAILED
> > >
> > > All kernel binaries, config files, and logs are available for downloa=
d here:
> > >
> > >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.ht=
ml?prefix=3Ddatawarehouse-public/2021/07/12/335283844
> > >
> > > We attempted to compile the kernel for multiple architectures, but th=
e compile
> > > failed on one or more architectures:
> > >
> > >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> >
> > 00:07:45 sound/soc/intel/boards/sof_sdw.c:200:41: error: implicit
> > declaration of function =E2=80=98SOF_BT_OFFLOAD_SSP=E2=80=99
> > [-Werror=3Dimplicit-function-declaration]
> > 00:07:45   200 |                                         SOF_BT_OFFLOAD=
_SSP(2) |
> > 00:07:45       |                                         ^~~~~~~~~~~~~~=
~~~~
> > 00:07:45 sound/soc/intel/boards/sof_sdw.c:201:41: error:
> > =E2=80=98SOF_SSP_BT_OFFLOAD_PRESENT=E2=80=99 undeclared here (not in a =
function)
> > 00:07:45   201 |
> > SOF_SSP_BT_OFFLOAD_PRESENT),
> > 00:07:45       |
> > ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > 00:07:45 cc1: some warnings being treated as errors
> > 00:07:45 make[6]: *** [scripts/Makefile.build:272:
> > sound/soc/intel/boards/sof_sdw.o] Error 1
> > 00:07:45 make[5]: *** [scripts/Makefile.build:515:
> > sound/soc/intel/boards] Error 2
> > 00:07:45 make[4]: *** [scripts/Makefile.build:515: sound/soc/intel] Err=
or 2
> > 00:07:45 make[3]: *** [scripts/Makefile.build:515: sound/soc] Error 2
> > 00:07:45 make[2]: *** [Makefile:1859: sound] Error 2
> >
> >
> > Hi, this looks to be introduced by
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/commit/?h=3Dqueue/5.12&id=3D514524d8977c5eca653e739fa580862f027e2b37
> >
>
> Thanks, offending patches now dropped from all queues.

Hi,

it looks like the patch sneaked back into the release and queue
for 5.13, we're seeing this compile error again:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.13&id=3D1da8a7c09a8cbb265e88ab16645353005352bf51
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dlinux-5.13.y&id=3Dfe01a34f7e0a0e6b1814b650bab20facac703122

Veronika

>
> greg k-h
>

