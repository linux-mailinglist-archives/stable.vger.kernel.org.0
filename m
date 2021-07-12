Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4AA3C5D82
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhGLNna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:43:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234216AbhGLNn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 09:43:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626097241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CxEBUBhY9L+AtYdeHpYkNAkWfDNcEYoqR3VuaL3uooQ=;
        b=gvYtbx9roCsP7Lgwokx913J7uViUQdpx2s1Gi0vSHBpFk/gt3ALxl+IFeDdnyaLvkCDOyY
        n96mwo/M9DZfNX+/rqDSSxEmOoX35FxmRc+P2ZgWRZAu7TAvFQUhuHehJnT1UXztqibbnt
        DD3NqBgaRFy1mRvT1yLpaGjMrJj68gc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-HYPr8KnJNp2JwXw0ZCavIQ-1; Mon, 12 Jul 2021 09:40:39 -0400
X-MC-Unique: HYPr8KnJNp2JwXw0ZCavIQ-1
Received: by mail-lj1-f197.google.com with SMTP id y10-20020a05651c154ab02901337d2c58f3so7042327ljp.9
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 06:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CxEBUBhY9L+AtYdeHpYkNAkWfDNcEYoqR3VuaL3uooQ=;
        b=i7W5WQ4HX9yJEtJ1GplOuYBoAK5FdI2RQ8VTMpcySgehAj3uzpYqNvTqooxgEkCCTo
         MiW2huPlY1h0Uhjf8D4Yw4ag66PY0U1lnpfXu9gf+GkjpLdGEEuXtPibQ824NKy59311
         5/R1GetAhS6wGAYvPP4SDWe+l0QeH2TUiBADp3xS+dNECgLmZWZTgoUxQa4e4lODLfaD
         /8JIr6WMMh4kjxYVYYz/mbchncBSiZ4+A15Ej53MQwZwhCvXJclOGNF7syzABXfTfqt1
         InzfrO+/366IqcG3ygRSexy5mBmOnq/y0kGR2WyWfoQM8/2bL+PbBiobB5Wgz6HVrGJe
         q6Ug==
X-Gm-Message-State: AOAM531W4qFfXwQBZtSFcJXFhNDYKMTa3iDHsxxaEq8ATZssQTFv6QNs
        2FZoYAkrfpZzVJ30ieOrtk/0zZGHP4eHGFC2i5Vt2zU/TXsZ6C5xtXbS1IIYr2ADm2mK4pCyVhl
        uTXobTxGigB40OO0XPW6qnuTJ6VgC2zaV
X-Received: by 2002:a05:651c:111b:: with SMTP id d27mr41608685ljo.387.1626097238052;
        Mon, 12 Jul 2021 06:40:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytLlMFzH8YeWxE2GjkFp2A2nbwxCCe+NWk46Ht8XPvBSzx0liyRDRQQL6GiNPkJQOFSpcvRaoIUxlNW6ALjAE=
X-Received: by 2002:a05:651c:111b:: with SMTP id d27mr41608670ljo.387.1626097237851;
 Mon, 12 Jul 2021 06:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <cki.4B06E639A0.ME3EXCXRTW@redhat.com>
In-Reply-To: <cki.4B06E639A0.ME3EXCXRTW@redhat.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Mon, 12 Jul 2021 15:40:01 +0200
Message-ID: <CA+tGwnkjpwHE6=5MxFRnHSZ6=LYN_uiJQhTOP1oTr2rqhSiTyg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E12=2E16_=28stable?=
        =?UTF-8?Q?=2Dqueue=2C_e2aabcec=29?=
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 3:37 PM CKI Project <cki-project@redhat.com> wrote:
>
>
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux-stable-rc.git
>             Commit: e2aabcece18e - powerpc/preempt: Don't touch the idle =
task's preempt_count during hotplug
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?p=
refix=3Ddatawarehouse-public/2021/07/12/335283844
>
> We attempted to compile the kernel for multiple architectures, but the co=
mpile
> failed on one or more architectures:
>
>             x86_64: FAILED (see build-x86_64.log.xz attachment)

00:07:45 sound/soc/intel/boards/sof_sdw.c:200:41: error: implicit
declaration of function =E2=80=98SOF_BT_OFFLOAD_SSP=E2=80=99
[-Werror=3Dimplicit-function-declaration]
00:07:45   200 |                                         SOF_BT_OFFLOAD_SSP=
(2) |
00:07:45       |                                         ^~~~~~~~~~~~~~~~~~
00:07:45 sound/soc/intel/boards/sof_sdw.c:201:41: error:
=E2=80=98SOF_SSP_BT_OFFLOAD_PRESENT=E2=80=99 undeclared here (not in a func=
tion)
00:07:45   201 |
SOF_SSP_BT_OFFLOAD_PRESENT),
00:07:45       |
^~~~~~~~~~~~~~~~~~~~~~~~~~
00:07:45 cc1: some warnings being treated as errors
00:07:45 make[6]: *** [scripts/Makefile.build:272:
sound/soc/intel/boards/sof_sdw.o] Error 1
00:07:45 make[5]: *** [scripts/Makefile.build:515:
sound/soc/intel/boards] Error 2
00:07:45 make[4]: *** [scripts/Makefile.build:515: sound/soc/intel] Error 2
00:07:45 make[3]: *** [scripts/Makefile.build:515: sound/soc] Error 2
00:07:45 make[2]: *** [Makefile:1859: sound] Error 2


Hi, this looks to be introduced by

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dqueue/5.12&id=3D514524d8977c5eca653e739fa580862f027e2b37


Veronika

>
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this mes=
sage.
>
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more effec=
tive.
>
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> _________________________________________________________________________=
_____
>
> Compile testing
> ---------------
>
> We compiled the kernel for 4 architectures:
>
>     aarch64:
>       make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>     ppc64le:
>       make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>     s390x:
>       make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>     x86_64:
>       make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>

