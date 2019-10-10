Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7818CD20CB
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 08:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfJJGaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 02:30:15 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38023 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfJJGaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 02:30:14 -0400
Received: by mail-lj1-f195.google.com with SMTP id b20so4960312ljj.5
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 23:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NRnuIfztTNO3AIqVjuc+XejgBq4Ztmyi6n5SNmCiflw=;
        b=YbtZKOEBdVyMPqRo+Qj6vquGKu6Vx63muTNAUe8+dhAMv1PnB40irbHH1En24ocjoh
         ReXocT+kqm6iA/lUSOuZYF70kdfqB/6dcK+yVjyxKKz2a7xSaEm/i/kr4bUQ/Oxw45rd
         Wo7KIKdyUmrvryKvAIiFLceRIg630Z49doXeKKPPjX18RIyg6MBu4LzlSZibRXbpmtwq
         f0ko+xb/Sm/Oln7gY+Ei7qSf2ILWvTqbkE9sDXo0oOidBHWtBmr61yfdlafLvt3sSsmd
         4R3Mai6n98wNMX9zOV3RlmPewLHNvd35MZIjYN6EHvXQ9XD0HPG+m/Ye1aN8VjpQHyWK
         BKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NRnuIfztTNO3AIqVjuc+XejgBq4Ztmyi6n5SNmCiflw=;
        b=azaUQKZh2bCmZEgsr+X+8UOVDawmHm1/qcrl8RYOcynL6j8lp5OP6dEi9Dn2BsnYHJ
         l0KxM09a15cKpCH+6dlZXbldO6e6SSR8hyqCyopsofbB91iHtZta1gbmuAfLIHAtcann
         6t8afSXWi+aAuJYcbmOQTgECFovbiA+3S/koYgnkHHI3cddWDI5Fj5JoZB6A/TR48J8Q
         l20o3eprPKtNgPO2HcGkRH295yyGn2Ao+TultB+pnJ6VDy56V8Ee4teGqFba4EcrhRZi
         /TMD+h1jQDhz+3YfUnKeZx23m/VfNEXr+j8p5dBt08/BftbEelTufL7WkBg+Uud3HWqT
         BZZw==
X-Gm-Message-State: APjAAAWOOS+RtIQWbmiBKmJl1YfmdosCNqiNHkro2hoBLYefI7etqZHu
        o8ebO/3uoEC6ch4ZcIHaH4GlB1afUSBM86Autln9Zw==
X-Google-Smtp-Source: APXvYqxIF+mZqUBv51aL3VWmEZs8wEUmiBlNCbnRYhizzDqDb6wIdQxO0iEqei36NK5K4hcFm5RmbtXuXOzQAGFI/jI=
X-Received: by 2002:a2e:8602:: with SMTP id a2mr5316988lji.20.1570689012418;
 Wed, 09 Oct 2019 23:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <cki.F2FC419F40.7K0EACX2QA@redhat.com> <20191009224437.GY1396@sasha-vm>
 <20191010010952.suo6opzifh5y37gm@redhat.com>
In-Reply-To: <20191010010952.suo6opzifh5y37gm@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Oct 2019 12:00:01 +0530
Message-ID: <CA+G9fYsKqnev+Ayu8-p8AY-4cxLJv-zTx4s-A9hxxB83R4Pejg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBTdGFibGUgcXVldWU6IHF1ZXVlLTUuMw==?=
To:     Don Zickus <dzickus@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Zhaojuan Guo <zguo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Oct 2019 at 06:40, Don Zickus <dzickus@redhat.com> wrote:
>
> On Wed, Oct 09, 2019 at 06:44:37PM -0400, Sasha Levin wrote:
> > On Wed, Oct 09, 2019 at 06:11:40PM -0400, CKI Project wrote:
> > >
> > > Hello,
> > >
> > > We ran automated tests on a patchset that was proposed for merging in=
to this
> > > kernel tree. The patches were applied to:
> > >
> > >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux.git
> > >            Commit: 52020d3f6633 - Linux 5.3.5
> > >
> > > The results of these automated tests are provided below.
> > >
> > >    Overall result: FAILED (see details below)
> > >             Merge: OK
> > >           Compile: OK
> > >             Tests: FAILED
> > >
> > > All kernel binaries, config files, and logs are available for downloa=
d here:
> > >
> > >  https://artifacts.cki-project.org/pipelines/214657
> > >
> > > One or more kernel tests failed:
> > >
> > >    x86_64:
> > >      =E2=9D=8C Boot test
> > >      =E2=9D=8C Boot test
> > >      =E2=9D=8C Boot test
> > >      =E2=9D=8C Boot test
> >
> > Hm, I looked here:
> >
> > https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_1_B=
oot_test_dmesg.log
> >
> > and here:
> >
> > https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_2_B=
oot_test_dmesg.log
> >
> > but both look sane. What am I missing?
>
> I don't believe you are.  I looked at the raw beaker jobs and the x86_64
> machines passed and another set is still queued.  There is an aarch64
> machine that failed to boot.
>
> Unfortunately, I am skeptical of this result too but I would wait for the
> CKI team to triage this.

On the quick look i see

x86_64: Host 3 failed to do any testing.
Is it an infrastructure problem ?

- Naresh
