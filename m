Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B23268F68A
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjBHSE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjBHSE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:04:57 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E42530CF
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 10:04:32 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id sa10so22762706ejc.9
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 10:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o2JJ1Ee32hzIiRwEE/z4UpbV3JncQtbQL6qzEOH/xcw=;
        b=oGMMmYh4GkhTX0eNkyArCY6BqW0VDFr1Kr7e2SS9bF4awixZHelJSp+hS3Y675NKyv
         7WToDTwrYVIshTFAv0oRAWjywd1yycWgTlOFWjV6HiFNXpUeRq9x2uFbNdrZbnNGiw2T
         d+on5n3MUTrinBoN4ycNqccuzk6QUOk7ZGVtXcIm0A1pmbtdDbw+rTaMeQ5mPqMlb1ta
         m5phSMCmSJYbb6CAdCPgJAZG2eUZbhqlycdK1rvYjHt9kFcKvMc7tfdMJvEr1UWZCYlL
         828yZKtyNDqbAR1eiItaby0ew+FUeAFxXrqaRIf9wkvKgTyv2MHuz8jNLT8UgwSTs755
         XDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o2JJ1Ee32hzIiRwEE/z4UpbV3JncQtbQL6qzEOH/xcw=;
        b=N1k7Tbz5p5FrVHRHNWY4zQ8FWweO0ESYraIxNXzBECfRfd8zJigBws+k8AJKGXz9dd
         kPHFea6yGIc5D5xCPVZW8qCZ8n+CuRPVL2ONdXW/IEinrjkLDhuDcSkmbkhHP1343Rgy
         hTvDcNIsZY+2JGXBONi0RP1SdeSCwU6r/R+Hi93exuhgZUzEbRvy7AZS3A67BH/ow74L
         M+QxQMDRm8PhVGs0My8CvBANlVsRTYotxuLnnoHhk7W3P7nrSWmv2webhx1N+MFp2cAC
         Dplu0ZToYo1W2FYEt9lZ45750rdg81uLT3JrXXO65S32OwgF6q/GUYJNxdBfPNS1d5v4
         BHFg==
X-Gm-Message-State: AO0yUKXc4jBVMJZBJ8kON7hZVm5fVrDeLDp5NMXKWjoCtoGczY412NRx
        qBTYTMxg8jzZnNJ5XiveXpVrQZHQwpdQfisowN/8
X-Google-Smtp-Source: AK7set/U+12GtAsfcKzD0M3TSL32ji0RZ/tnZtOfMOCEijGlqV7ApAv4stR7at0qeOETNwX3hFK0EmuNR5tP8WJ8UDY=
X-Received: by 2002:a17:906:7f8c:b0:88d:3f80:d57d with SMTP id
 f12-20020a1709067f8c00b0088d3f80d57dmr1507150ejr.302.1675879470272; Wed, 08
 Feb 2023 10:04:30 -0800 (PST)
MIME-Version: 1.0
References: <20230208065133.220589-1-ebiggers@kernel.org> <Y+Oyi1eZqKtqbL40@dev-arch.thelio-3990X>
In-Reply-To: <Y+Oyi1eZqKtqbL40@dev-arch.thelio-3990X>
From:   Bill Wendling <morbo@google.com>
Date:   Wed, 8 Feb 2023 10:04:13 -0800
Message-ID: <CAGG=3QW_uRuL_WPHbHOWs0zKROxfcgJvvY-id1XaTbNGx-sD=w@mail.gmail.com>
Subject: Re: [PATCH] randstruct: disable Clang 15 support
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 8, 2023 at 6:32 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Tue, Feb 07, 2023 at 10:51:33PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > The randstruct support released in Clang 15 is unsafe to use due to a
> > bug that can cause miscompilations: "-frandomize-layout-seed
> > inconsistently randomizes all-function-pointers structs"
> > (https://github.com/llvm/llvm-project/issues/60349).  It has been fixed
> > on the Clang 16 release branch, so add a Clang version check.
> >
> > Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
>
Reviewed-by: Bill Wendling <morbo@google.com>

> > ---
> >  security/Kconfig.hardening | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> > index 53baa95cb644f..0f295961e7736 100644
> > --- a/security/Kconfig.hardening
> > +++ b/security/Kconfig.hardening
> > @@ -281,6 +281,9 @@ endmenu
> >
> >  config CC_HAS_RANDSTRUCT
> >       def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
> > +     # Randstruct was first added in Clang 15, but it isn't safe to use until
> > +     # Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
> > +     depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
> >
> >  choice
> >       prompt "Randomize layout of sensitive kernel structures"
> >
> > base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
> > --
> > 2.39.1
> >
> >
