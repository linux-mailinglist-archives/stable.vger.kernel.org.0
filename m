Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F098B6E9B8F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjDTSYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 14:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjDTSYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 14:24:31 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A23A40FE
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 11:24:30 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-517c57386f6so935157a12.2
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682015069; x=1684607069;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W2Q4iIjOWvyJFTvXo6EByLNSHrXgPTMrz47UjuX1XFA=;
        b=sUMWeJdlD5N8oAZ/A+H12d36PuymhXNTfcZuFiOc3bkEZoUUn5D8kWzrNLArJuoMx5
         4fGCDfscE9dHjinDCPRShcQ/DiFNkedbv2Z4VrcE1rlcl5uRRg/rzrRIjZMStodRKfcz
         +01PoJaqtKjKqWWlDoiK/BNJImIBXhumAXww8O2jTFdi27urJ+qxyKRHgWU1DZ3Pde63
         W3hfkLOeIAqS4wS2XS+/KKxKuEMBGi0AIrnF8u4+GO85UEe8zwkm5fQTYXviYnElQ6m3
         uaM3fqtOaoNGLEJdSSMKAYASq+3CldQROUmwxB0bxBjwSdwN8jS9Vu/vYl43gkbHP6Fq
         1xUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015069; x=1684607069;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W2Q4iIjOWvyJFTvXo6EByLNSHrXgPTMrz47UjuX1XFA=;
        b=QjIBqsNrlNAEB+DnJCkb726teVP3TFZmBenRkytoMGe8+JhK397ZHAQbEirJG8wxgT
         W56kyRTvJHy+GDhNN2AQp+n6r3yCvFK6b02cPVMBlL1O15EOi6nt236jV1agQAWCooUS
         ib3Kj28Zi3paDFsVXXfMTnJOLtfMmrN7Ol5nOofu2vGxvLhnb1AgEh3vB6PNQ0WoNXqH
         2nMHv+nt2Qj73UwwwL4GoWC+Q12XZDZfxsIJKIw2gtOpahpXu/XCsKR+A5EQ3vIXH7Pa
         4SFbOTnbDqLUtXC8s2S6nXZQwkZJvHeMuwMJjsZBbSuAOdzca0KJpaveXjq2r4nRTXL9
         7hqQ==
X-Gm-Message-State: AAQBX9fAfle5cTIwoEGyh3HAhqwcITdG3Yu46ZuUGpa6Lnyf/lBRZH2X
        UNQnugctez1+UAYggtenOnEH2WztVuMp46qOOwIswQ==
X-Google-Smtp-Source: AKy350ZHDZutJ5uEYOl/hvKn3fUhSa6Fnj8CRgHHHC7sw+tjdv82826lI/F0qrx4LZOQ12NVlEu7a/2luSMwkds1O5E=
X-Received: by 2002:a17:90a:bf10:b0:23e:fc9c:930 with SMTP id
 c16-20020a17090abf1000b0023efc9c0930mr2569162pjs.36.1682015069459; Thu, 20
 Apr 2023 11:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230417122943.2155502-1-anders.roxell@linaro.org> <2023041848-basil-plop-145c@gregkh>
In-Reply-To: <2023041848-basil-plop-145c@gregkh>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 20 Apr 2023 20:24:18 +0200
Message-ID: <CADYN=9L40BxnPiMAnCr=Ha4PPt2dWDO+anE9ev0sQPjbJyvBSQ@mail.gmail.com>
Subject: Re: [backport PATCH 0/2] stable v5.15, v5.10 and v5.4: fix perf build errors
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, acme@redhat.com, andres@anarazel.de,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023 at 11:04, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Apr 17, 2023 at 02:29:41PM +0200, Anders Roxell wrote:
> > Hi,
> >
> > I would like to see these patches backported. They are needed so perf
> > can be cross compiled with gcc on v5.15, v5.10 and v5.4.
> > I built it with tuxmake [1] here are two example commandlines:
> > tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 --kconfig defconfig perf
> > tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-12 --kconfig defconfig perf
> >
> > Tried to build perf with both gcc-11 and gcc-12.
> >
> > Patch 'tools perf: Fix compilation error with new binutils'
> > and 'tools build: Add feature test for init_disassemble_info API changes'
> > didn't apply cleanly, thats why I send these in a patchset.
> >
> > When apply 'tools build: Add feature test for
> > init_disassemble_info API changes' to 5.4 it will be a minor merge
> > conflict, do you want me to send this patch in two separate patches one
> > for 5.4 and another for v5.10?
> >
> > The sha for these two patches in mainline are.
> > cfd59ca91467 tools build: Add feature test for init_disassemble_info API changes
> > 83aa0120487e tools perf: Fix compilation error with new binutils
> >
> > The above patches solves these:
> > util/annotate.c: In function 'symbol__disassemble_bpf':
> > util/annotate.c:1729:9: error: too few arguments to function 'init_disassemble_info'
> >  1729 |         init_disassemble_info(&info, s,
> >       |         ^~~~~~~~~~~~~~~~~~~~~
> >
> >
> > Please apply these to v5.10 and v5.4
> > a45b3d692623 tools include: add dis-asm-compat.h to handle version differences
> > d08c84e01afa perf sched: Cast PTHREAD_STACK_MIN to int as it may turn into sysconf(__SC_THREAD_STACK>
> >
> > The above patches solves these:
> > /home/anders/src/kernel/stable-5.10/tools/include/linux/kernel.h:43:24: error: comparison of distinct pointer types lacks a cast [-Werror]
> >    43 |         (void) (&_max1 == &_max2);              \
> >       |                        ^~
> > builtin-sched.c:673:34: note: in expansion of macro 'max'
> >   673 |                         (size_t) max(16 * 1024, PTHREAD_STACK_MIN));
> >       |                                  ^~~
> >
> >
> > Please apply these to v5.15, v5.10 and v5.4
> > 8e8bf60a6754 perf build: Fixup disabling of -Wdeprecated-declarations for the python scripting engine
> > 4ee3c4da8b1b perf scripting python: Do not build fail on deprecation warnings
> > 63a4354ae75c perf scripting perl: Ignore some warnings to keep building with perl headers
>
> Can you please provide patch series of these upstream commits backported
> to the relevant branchs that you wish to see them in?  You have 2
> patches in this series without git commit ids, and I have no idea where
> to apply them, or not apply them...

Yes, apologies, I will get that fixed up.

>
> Or better yet, just use the latest version of perf as was pointed out,
> on these old kernel releases.

Makes sense, we can do this. Is this the preferred way going forward?

Cheers,
Anders
