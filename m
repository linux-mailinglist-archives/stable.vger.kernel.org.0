Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63D769D391
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjBTS7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbjBTS6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:58:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7037C7A90
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD37960F0E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE2FC43442
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676919411;
        bh=lTCizTZ15FWQrA5Ntik4wWqUB7fl2m6pIZg61NnKBWU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eXNrcNGusE42CZBxmMKGib4ORY4WaiEv+B+huZtmOWFTqKs1QsAoZ7IWUFnAiqOYS
         gPAb1RCL2H6XUF0SgkSIQ9IfZJtEkFF+dgE3Vrd8ciUETOHGO889x14xTVLy3TmUoD
         LAOCgKT9I56Mls5jzHMbiBBtNItHpeSp4Wu5LjLi5uN99jv/fRdG6cLf79YLPWKmsF
         ZMSdZr4DpIpPBa2ezR/R+id1Bcq5ZtNCFzjXZEuujQ+fp0htpQV9F5IVd0msfqy21c
         cYSu906o1DRqrQ9CGPk7M1OcS+DCg2j4kt+f7Tjr3OoCnTZZRBvEYmEk7m1hokdkgW
         6X+0rPtkgN84w==
Received: by mail-ed1-f50.google.com with SMTP id o12so8763372edb.9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:56:51 -0800 (PST)
X-Gm-Message-State: AO0yUKUZ1WaBVxGgTJYXQKKpXYpXnbpSq8YpuyWn2IInrDe0X9Q15w7c
        R7a1CWfcUoZNP87xSW+2B1wemTghI/3ArbfbwpKKhA==
X-Google-Smtp-Source: AK7set/2MSjXgU5EyveFZmm43dXQ9oyira8niteytdCUh+u3gB7C6T2JhVkPd5WmLDariERW0yxyk6MzcoNSokB2yTs=
X-Received: by 2002:a17:906:4a93:b0:88a:b103:212d with SMTP id
 x19-20020a1709064a9300b0088ab103212dmr4872440eju.15.1676919409403; Mon, 20
 Feb 2023 10:56:49 -0800 (PST)
MIME-Version: 1.0
References: <20230220120127.1975241-1-kpsingh@kernel.org> <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble> <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble> <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
 <Y/O6Wr4BbtfhXrNt@zn.tnic> <CACYkzJ4jvOGGhuQ1HDzfpGS5vffg9X6hEcLC93QJBFqX+LxLVw@mail.gmail.com>
 <Y/PBSncEMTiO5scL@zn.tnic>
In-Reply-To: <Y/PBSncEMTiO5scL@zn.tnic>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 10:56:38 -0800
X-Gmail-Original-Message-ID: <CACYkzJ5w_ey7aHxhGr-1gpQLPPtRAQLApHiJp_Kh0cOW4PTQkA@mail.gmail.com>
Message-ID: <CACYkzJ5w_ey7aHxhGr-1gpQLPPtRAQLApHiJp_Kh0cOW4PTQkA@mail.gmail.com>
Subject: Re: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2
 protection with KERNEL_IBRS
To:     Borislav Petkov <bp@alien8.de>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 10:52 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Feb 20, 2023 at 10:44:21AM -0800, KP Singh wrote:
> > No it cannot with IBRS which is really just KERNEL_IBRS enabled, we
>
> See my other reply. The intent is there to be able to do it. What needs
> to be figured out now is *why* we said no STIBP with IBRS? Was it an
> omission or was there some intent behind it.
>

Sure, it looks like an omission to me, we wrote a POC on Skylake that
was able to do cross-thread training with the current set of
mitigations.

STIBP with IBRS is still correct if spectre_v2=ibrs had really meant
IBRS everywhere, but just means KERNEL_IBRS, which means only kernel
is protected, userspace is still unprotected.

> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
