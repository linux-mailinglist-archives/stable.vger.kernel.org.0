Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E45E69D3EB
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 20:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjBTTMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 14:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjBTTMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 14:12:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311EF212AD
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFD46B80DC6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 19:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8950AC433AC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676920259;
        bh=HYj2JrNoOeQCfF/fA+CMso1srlcz6lsACttDPRCDH1c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QBSStRS19Ntd6ywZBG28lu434sDuhidjlN+csFk0l2Za8moi06UTXzpPZjAeY7RWj
         7293qhpkI8ipEUcdgZ7anF5MDsIaFSGObagZk+RJsO37amSQxmsPkFKnW093/VfPSJ
         v8+JEs2Bksj0OLFGAk4ejs+Av3jjg7IkToshnSnX76XEGwe/H8I2AcPhynrFT3DcoU
         x9wqw2nhovIyJobkhiVbCusY5rkJizNNymUEouKSg13Lp+KqwLlbWJ7SUWsOXCUbUz
         6eAGydBR2hFKn9pNTs8sjRKFLDVcG0m4WV+lPmDVAC56g+yimFNS1iTvVm2CPSZ/SK
         FD+BePJC8VL5w==
Received: by mail-ed1-f53.google.com with SMTP id ec43so7954186edb.8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:10:59 -0800 (PST)
X-Gm-Message-State: AO0yUKW0vxm+W7vmz6QOoyLXc1qIUWMdceJF+o6Zi3sG1HFWgtZQkSWr
        wU5kWU6ZJb4KZgiy9+sPRhoO0h7311O06b0tgnmPrg==
X-Google-Smtp-Source: AK7set9zPY8xCuDm9jXKfRySwPKynaiEx+hJXoG08HoUM5m1451XL+fCoduFnLrl05xe924cEzonfAjlJycpTN+F8GA=
X-Received: by 2002:a50:935b:0:b0:4ae:f648:950b with SMTP id
 n27-20020a50935b000000b004aef648950bmr1466871eda.7.1676920257643; Mon, 20 Feb
 2023 11:10:57 -0800 (PST)
MIME-Version: 1.0
References: <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble> <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble> <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
 <Y/O6Wr4BbtfhXrNt@zn.tnic> <CACYkzJ4jvOGGhuQ1HDzfpGS5vffg9X6hEcLC93QJBFqX+LxLVw@mail.gmail.com>
 <Y/PBSncEMTiO5scL@zn.tnic> <CACYkzJ5w_ey7aHxhGr-1gpQLPPtRAQLApHiJp_Kh0cOW4PTQkA@mail.gmail.com>
 <Y/PDqpwY3sF29PuM@zn.tnic>
In-Reply-To: <Y/PDqpwY3sF29PuM@zn.tnic>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 11:10:46 -0800
X-Gmail-Original-Message-ID: <CACYkzJ4jAqDfSvdbNqMbmnQW6eyFj4qtknW1Wq_mm0kHUjOYyA@mail.gmail.com>
Message-ID: <CACYkzJ4jAqDfSvdbNqMbmnQW6eyFj4qtknW1Wq_mm0kHUjOYyA@mail.gmail.com>
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 11:02 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Feb 20, 2023 at 10:56:38AM -0800, KP Singh wrote:
> > Sure, it looks like an omission to me, we wrote a POC on Skylake that
> > was able to do cross-thread training with the current set of
> > mitigations.
>
> Right.
>
> > STIBP with IBRS is still correct if spectre_v2=ibrs had really meant
> > IBRS everywhere,
>
> Yeah, IBRS everywhere got shot down as a no-no very early in the game,
> for apparent reasons.

As you said in the other thread, this needs to be documented both in
the code and the kernel documentation.

>
> > but just means KERNEL_IBRS, which means only kernel is protected,
> > userspace is still unprotected.
>
> Yes, that was always the intent with IBRS: enable on kernel entry and
> disable on exit.
>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
