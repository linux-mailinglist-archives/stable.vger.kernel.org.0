Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C3B37BA2E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhELKSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:18:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230018AbhELKSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:18:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620814649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D429t2w9YJ0puIC3m9D0CyZQmXk0O9M+aYd9BZTVAME=;
        b=Im1hMnRjTG9HzyIExS/L+jzart5qsiWjTY+deIv9Nndetb22YoyAYt88EqXPWcoJAjyRpc
        0fVpOll7Q4rE4VK1AKT3ej0Qm9TU8Lyze/f/f/BRDzE+LylzQyjKmk2QFbSUMuDISluMW6
        ZG/+Ud8svkdtR6rMNQ2/YxL1lwb6IOk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97---kUSfgSNfGJK2jsfSaIiw-1; Wed, 12 May 2021 06:17:25 -0400
X-MC-Unique: --kUSfgSNfGJK2jsfSaIiw-1
Received: by mail-lj1-f200.google.com with SMTP id v15-20020a2e7a0f0000b02900da3de76cfdso12311490ljc.22
        for <stable@vger.kernel.org>; Wed, 12 May 2021 03:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D429t2w9YJ0puIC3m9D0CyZQmXk0O9M+aYd9BZTVAME=;
        b=kdxuykVRfwg3sbDwBUti+iDvVLvyCPcU0S3GgAebJmGmPNEMrqIWDS0V6J91QcLSCi
         Ed06IVbsH9xIAiKGz0Jayfe9Mkyn+brIzO3o5h9894whaf7CIar4SeAvoLv25V9VvCz9
         qJk1SQlN077A4jQxQpIEU4imCYluVfaoM292XMPKv6OGYnmzxPTHDHIIrSsqmap4uuV+
         cNO5qrR9lqx9i+lNS2itU2nz8SHi+zIn8rWoAfu9t9rtMLfeXuHnzefrPO6DnkyELor1
         esiLQd7GmXUU8BXoLK149/nxvTrgc6Nfl8IDXpe5W/k9Covk3bTaLPnrmzq9N1gZe/oH
         r/DQ==
X-Gm-Message-State: AOAM531ByWnCPiOkCnHN92jP95j5BT4yEslU4Y9OoyEjr2OqdpqWRPI2
        Y9pcmVmBIfa6Y40ZygAkFVIfiD9CJdtAKxwEeRbLnzX7q/DSbvR6CEL154NvhYehMdkTO4MZ9cm
        tpNQi+V2duIkNy1O9ybJlJh6HvFNTzcgU
X-Received: by 2002:a2e:b5d6:: with SMTP id g22mr28699685ljn.423.1620814644345;
        Wed, 12 May 2021 03:17:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwb0gljd5JEA7og8U/TAkNdPWdr76vdZlx6/sjcbw5uBkPc3lh1XMzpogYnBrJIYg2N/6qTcvBmyEa63k2mbc=
X-Received: by 2002:a2e:b5d6:: with SMTP id g22mr28699676ljn.423.1620814644180;
 Wed, 12 May 2021 03:17:24 -0700 (PDT)
MIME-Version: 1.0
References: <cki.30AF028A01.OS9TECV9G1@redhat.com> <YJstva9S9qPO+2F3@sashalap>
In-Reply-To: <YJstva9S9qPO+2F3@sashalap>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Wed, 12 May 2021 12:16:48 +0200
Message-ID: <CA+tGwnnyDVtoNy=_CVTjpEpxw7B2omPLGvq50LYYwd4htgvxMg@mail.gmail.com>
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

On Wed, May 12, 2021 at 3:22 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, May 11, 2021 at 09:43:50PM -0000, CKI Project wrote:
> >
> >Hello,
> >
> >We ran automated tests on a recent commit from this kernel tree:
> >
> >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux-stable-rc.git
> >            Commit: beb6df0ce94f - thermal/core/fair share: Lock the the=
rmal zone while looping over instances
> >
> >The results of these automated tests are provided below.
> >
> >    Overall result: FAILED (see details below)
> >             Merge: OK
> >           Compile: OK
> >             Tests: FAILED
> >
> >All kernel binaries, config files, and logs are available for download h=
ere:
> >
> >  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?=
prefix=3Ddatawarehouse-public/2021/05/11/300944713
> >
> >One or more kernel tests failed:
> >
> >    s390x:
> >     =E2=9D=8C Networking tunnel: geneve basic test
> >
> >    ppc64le:
> >     =E2=9D=8C LTP
> >     =E2=9D=8C Networking tunnel: geneve basic test
> >
> >    aarch64:
> >     =E2=9D=8C Networking tunnel: geneve basic test
> >
> >    x86_64:
> >     =E2=9D=8C Networking tunnel: geneve basic test
>
> CKI folks, looks like there was a gap between 5.11.16 and now, and idea
> if the reported issue here is new in the 5.11.19 -rc, or something that
> regressed earlier?
>

Hi Sasha,

this is a bug we've previously reported here:

https://bugzilla.kernel.org/show_bug.cgi?id=3D210569

This is an older bug we've been seeing for a while and thus the
report should not have been sent. Apologies for that - we fixed
some permission issues with reporting yesterday and it must
have uncovered an underlying bug. This is the only list that hits
the problem. We'll look into that reason right away.

Veronika

> --
> Thanks,
> Sasha
>

