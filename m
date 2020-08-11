Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FF324229C
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 00:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgHKWok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 18:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKWok (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 18:44:40 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39558C06174A;
        Tue, 11 Aug 2020 15:44:40 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id d14so392836qke.13;
        Tue, 11 Aug 2020 15:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mBWFL754Vrf9Z7Daog4EE5sGqx+K5IQ8vwyomqlrRJI=;
        b=o5zaAhUqJ327OLvq3xcwTet2QBz6ptIqJGec9dThZqe3JHu2oKH0X7u2NrqYUdeBax
         klJu3caL1SBP6UtY/8JTsip/amL/Dd/nR08uXZ7IHsPeqpRibuIPB07bgAYU7mrFPFFx
         aoA+QOndg6Hf3G/O7EiWIHGMnikSTAoCXcxSk1FS40VE1SFsLABW1bVL+JBcKs8q3CJh
         hnCWvvQ/o7wBBWP6Md4fSDms4XSWXAw+LV0FwLkH7F3bt98K5vOSLCxC3lCZfqjNMVAE
         Xpfa8N0fYnPu19IYfTFd7lLmkqZttlKzZogGjVvaxaGKp91RSlMCMdDa9rj+PBhpG+pB
         T2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mBWFL754Vrf9Z7Daog4EE5sGqx+K5IQ8vwyomqlrRJI=;
        b=ePj9ThDcoOtOkPSRt/lEMQxbdnv2M/S+fDVaBKycI5/D3q6vhnZ1E76yR79Zz5lY9W
         hQ7mfQ4gqic7C3vlPM9ZO0yngxHOG7TUTJHib03Dh1m7Q9FYpGw1lPVd1lgst/J8qbKr
         7KkzOgI1kEXTFVAIQTP+4TOR0ocHawa4kEbC49+pbMpmTbmE+IsOox1FjsKWxuAxlTBP
         K7aLIEOzs29alKpeioimNqsdwoSJTiVE++u1zJqXR30qAaN4Gj70OeMf1R8GYf7kUHMk
         XWC7H5nEjmEx6Bh3oFyAgs/qYMoy+z3vO5PHiIed3dItpAieJemqGvbeqr4muwdHzZ/Z
         Oq5A==
X-Gm-Message-State: AOAM5309HlVoWEMJ8zkNy7BHI5Pr4MYYAYul3ABxZiSl/oXOf82ft/uc
        OFv5ypqKuIlVQfiaYjVz4cE=
X-Google-Smtp-Source: ABdhPJxjGu75IPfS2IomHQ7bSZpXSQRBtxedTIEW4Me9v0itws5ygKikEp8UeompN5IHShWq633kBA==
X-Received: by 2002:a37:556:: with SMTP id 83mr3379743qkf.208.1597185879356;
        Tue, 11 Aug 2020 15:44:39 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id i7sm256301qkb.131.2020.08.11.15.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 15:44:38 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 11 Aug 2020 18:44:36 -0400
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/boot/compressed: Disable relocation relaxation for
 non-pie link
Message-ID: <20200811224436.GA1302731@rani.riverdale.lan>
References: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
 <20200811173655.1162093-1-nivedita@alum.mit.edu>
 <CAKwvOdnjLfQ0fWsrFYDJ2O+qFAfEFnTEEnW-aHrPha8G3_WTrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKwvOdnjLfQ0fWsrFYDJ2O+qFAfEFnTEEnW-aHrPha8G3_WTrg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 10:58:40AM -0700, Nick Desaulniers wrote:
> > Cc: stable@vger.kernel.org # 4.19.x
> 
> Thanks Arvind, good write up.  Just curious about this stable tag, how
> come you picked 4.19?  I can see boot failures in our CI for x86+LLD
> back to 4.9.  Can we amend that tag to use `# 4.9`? I'd be happy to
> help submit backports should they fail to apply cleanly.
> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/builds/179237488
> 

4.19 renamed LDFLAGS to KBUILD_LDFLAGS. For 4.4, 4.9 and 4.14 the patch
needs to be modified, KBUILD_LDFLAGS -> LDFLAGS, so I figured we should
submit backports separately. For 4.19 onwards, it should apply without
changes I think.

Thanks.
