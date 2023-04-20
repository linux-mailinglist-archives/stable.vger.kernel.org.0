Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EE76E9D44
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 22:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjDTUej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 16:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjDTUeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 16:34:25 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9235262
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 13:34:23 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-3ef36d814a5so934971cf.0
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 13:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682022863; x=1684614863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H7ELBBlYAp9rO9Iscqt7fxZUAahtXtENLaXXiWtioDA=;
        b=DKqDAwfBAn+vBoeYYY3K6MIAC02Z/W+xygtPJmTVD4lphx+jPOW/A83SXIPmZm5emZ
         oAb1jzqCRSoMOTW0dR5dOC9nWvYWrmS6dqqQuGZCBmFot1anSABZnPrdALANUEpy9qQT
         4BCCLeft3xxjBTMMrivGgh/fQ4RNMiZgxP/XzWaW+Sffi+E0D93c/o4biJGAm8gUzPdH
         yLoEDVQ9Kv4gXWrfJnsSenEbM9f8NhVFx1ZmjtaJ/Mjnv6cM7hmNjxKwxgFdGnl4CEcB
         BNRqhoW/dhvLAeXDdhRMm1/oeTngNpY8gVk4Hv5PU1JBWFHkuodkAONZCcshuSZtmN6d
         Bxew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682022863; x=1684614863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H7ELBBlYAp9rO9Iscqt7fxZUAahtXtENLaXXiWtioDA=;
        b=eyyDxEI3pkTloNzcqNbKUD5/x0J0zS33f9Y5/mAur0WJH/bIkS7yYfEtvNAJlRqUME
         QE0Uzlpd5NbJKL4dYyEBxEkrEmUfenNfEErUnuN39hnoquWGoNEaIWQi/+bmq3h3H32r
         l0j2Je5/dMiyRTyys7BJWR34r67M5JnjWZsnMRq94fymea6NfF4VNtsFof09fVGEnxq5
         l3uF+dyi95PMlAIIgOVpJVWihrg2qTTPHuuc83AiwAiszH/c/ATDLCIYwRXFHgZ45F/f
         K1hc0ppZYqw4XJubJKNIQWDKnaAJqiNexjUhHdemipV61MT3T01c8OIMcRZtuE1YWq40
         XgcA==
X-Gm-Message-State: AAQBX9fLPbhnu+S3ORV4cAMzUiuya+93WcJMzu8zKTBM2ayaEwdpj3WD
        mms1t55Fv1ujYZmK/dPwZPTzpIpBkjKgksCNdDrU4A==
X-Google-Smtp-Source: AKy350ZsIlfHd/IyYWDH6tgwdU06vkJ9Kjd5yBJB27Q69fc62PrktN7viBn61LSieyMWO4LC94wvoPKzHVdH9Gwvft4=
X-Received: by 2002:a05:622a:d5:b0:3e0:c2dd:fd29 with SMTP id
 p21-20020a05622a00d500b003e0c2ddfd29mr117317qtw.4.1682022862609; Thu, 20 Apr
 2023 13:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230417122943.2155502-1-anders.roxell@linaro.org>
 <2023041848-basil-plop-145c@gregkh> <CADYN=9L40BxnPiMAnCr=Ha4PPt2dWDO+anE9ev0sQPjbJyvBSQ@mail.gmail.com>
In-Reply-To: <CADYN=9L40BxnPiMAnCr=Ha4PPt2dWDO+anE9ev0sQPjbJyvBSQ@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 20 Apr 2023 13:34:08 -0700
Message-ID: <CAP-5=fVDQWshLtjXkqogOkhJT2z9aEFcpjY32pjQ6DbFrMy88Q@mail.gmail.com>
Subject: Re: [backport PATCH 0/2] stable v5.15, v5.10 and v5.4: fix perf build errors
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        acme@redhat.com, andres@anarazel.de, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 20, 2023 at 11:24=E2=80=AFAM Anders Roxell <anders.roxell@linar=
o.org> wrote:
>
> On Tue, 18 Apr 2023 at 11:04, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Apr 17, 2023 at 02:29:41PM +0200, Anders Roxell wrote:
> > > Hi,
> > >
> > > I would like to see these patches backported. They are needed so perf
> > > can be cross compiled with gcc on v5.15, v5.10 and v5.4.
> > > I built it with tuxmake [1] here are two example commandlines:
> > > tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 --kco=
nfig defconfig perf
> > > tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-12 --kc=
onfig defconfig perf
> > >
> > > Tried to build perf with both gcc-11 and gcc-12.
> > >
> > > Patch 'tools perf: Fix compilation error with new binutils'
> > > and 'tools build: Add feature test for init_disassemble_info API chan=
ges'
> > > didn't apply cleanly, thats why I send these in a patchset.
> > >
> > > When apply 'tools build: Add feature test for
> > > init_disassemble_info API changes' to 5.4 it will be a minor merge
> > > conflict, do you want me to send this patch in two separate patches o=
ne
> > > for 5.4 and another for v5.10?
> > >
> > > The sha for these two patches in mainline are.
> > > cfd59ca91467 tools build: Add feature test for init_disassemble_info =
API changes
> > > 83aa0120487e tools perf: Fix compilation error with new binutils
> > >
> > > The above patches solves these:
> > > util/annotate.c: In function 'symbol__disassemble_bpf':
> > > util/annotate.c:1729:9: error: too few arguments to function 'init_di=
sassemble_info'
> > >  1729 |         init_disassemble_info(&info, s,
> > >       |         ^~~~~~~~~~~~~~~~~~~~~
> > >
> > >
> > > Please apply these to v5.10 and v5.4
> > > a45b3d692623 tools include: add dis-asm-compat.h to handle version di=
fferences
> > > d08c84e01afa perf sched: Cast PTHREAD_STACK_MIN to int as it may turn=
 into sysconf(__SC_THREAD_STACK>
> > >
> > > The above patches solves these:
> > > /home/anders/src/kernel/stable-5.10/tools/include/linux/kernel.h:43:2=
4: error: comparison of distinct pointer types lacks a cast [-Werror]
> > >    43 |         (void) (&_max1 =3D=3D &_max2);              \
> > >       |                        ^~
> > > builtin-sched.c:673:34: note: in expansion of macro 'max'
> > >   673 |                         (size_t) max(16 * 1024, PTHREAD_STACK=
_MIN));
> > >       |                                  ^~~
> > >
> > >
> > > Please apply these to v5.15, v5.10 and v5.4
> > > 8e8bf60a6754 perf build: Fixup disabling of -Wdeprecated-declarations=
 for the python scripting engine
> > > 4ee3c4da8b1b perf scripting python: Do not build fail on deprecation =
warnings
> > > 63a4354ae75c perf scripting perl: Ignore some warnings to keep buildi=
ng with perl headers
> >
> > Can you please provide patch series of these upstream commits backporte=
d
> > to the relevant branchs that you wish to see them in?  You have 2
> > patches in this series without git commit ids, and I have no idea where
> > to apply them, or not apply them...
>
> Yes, apologies, I will get that fixed up.
>
> >
> > Or better yet, just use the latest version of perf as was pointed out,
> > on these old kernel releases.
>
> Makes sense, we can do this. Is this the preferred way going forward?

Fwiw, it definitely has my vote.

Thanks,
Ian

> Cheers,
> Anders
