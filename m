Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C142A2129
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 20:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgKATvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 14:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgKATvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 14:51:14 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5E3C0617A6;
        Sun,  1 Nov 2020 11:51:14 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id b18so9793617qkc.9;
        Sun, 01 Nov 2020 11:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rP4RExhHTYjlWl4BZb+1QvcI7StDkyRruWGLjrqa6uc=;
        b=YChnSI6Tw2pTGusfkNu7VS+a4Sx5U3iM0cPnYqIXOLKnhRtCIjpUDiNiveLgYPLuvl
         sCi4LmvSUnMOt/Ufkwba60ysz0m6Mga0Fg5ehiBXb1cDz2vukAgUdK4kUbyr/FydI0C0
         1iVOZkpLZZYeTB7akP2q4qS8EdmPAqmBsqbkwugc4tOaJZXHZUbA4kJFRI+7uROwR/zu
         feIg0PeS+Mr8gKH+kHggh749aW1IeH640fvEd8KrjPzMOiOyWe2EK1xbjR3lubFYouMY
         J6t9XtrlU3OcA4e4DBFnboplMDoSbEdJRKD/N4h7aMGbd1kIeUt2MzF21/vRUkBHRQ3N
         PfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rP4RExhHTYjlWl4BZb+1QvcI7StDkyRruWGLjrqa6uc=;
        b=acqLNuSEhQByM6ouVdwq76Ayix30bUtE4cB1VUhcq9HEQtIYNUbm8U7J80v7Nyl6yD
         NQlIW64Mt/qlAs1BMIrQvRpkwo0ycHbjFd6rsYPwiIRXLzdTvbt2kT1+rFruMHTZVo+h
         V9m/75XTevvqTJxnUPDXBWo8kaiHy2eQ0gN7KYtQRVWfp41oZxNI0iEWy/P8+Lkzijrc
         p+4Kai7PnRjj3RcHx8mBVsoGJbE8m3pjTRU7j8YiH1RwVBqvnfcUVtdqh7c6Osly0HOK
         Fr1dy+fzpQGNf2Dxi1zezt3qZKR3Esjjxoe42ueHOz1yPnwKncVgEmCJaBO5pAabBRVl
         O+Tw==
X-Gm-Message-State: AOAM532jpFTqf4okHmvdcN9SUl0TDJiPkpGWcQW2FlPWYuKk89M/GCjp
        gpzgwDg2hw8gTFO9MFA8h90=
X-Google-Smtp-Source: ABdhPJx+ifDmpgyyLCcnlEBQbmbvy6OCcXunBnW7zvX3xJcgaACeRGp7YQaxJi3Cyf3ExpE47GXSgw==
X-Received: by 2002:a05:620a:15b1:: with SMTP id f17mr11400784qkk.54.1604260273055;
        Sun, 01 Nov 2020 11:51:13 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id t8sm6576061qtb.97.2020.11.01.11.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 11:51:12 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sun, 1 Nov 2020 14:51:10 -0500
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        kernel test robot <lkp@intel.com>,
        linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Message-ID: <20201101195110.GA1751707@rani.riverdale.lan>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
 <20201101173835.GC27442@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201101173835.GC27442@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 01, 2020 at 05:38:35PM +0000, Matthew Wilcox wrote:
> On Sun, Nov 01, 2020 at 12:31:05PM -0500, Arvind Sankar wrote:
> > Commit
> >   b9de06783f01 ("compiler.h: fix barrier_data() on clang")
> > moved the definition of barrier() into compiler.h.
> 
> That's not a real commit ID.  It only exists in linux-next and
> will expire after a few weeks.
> 
> The right way to fix a patch in Andrew's tree is to send an email
> asking him to apply it as a -fix patch.  As part of Andrew's submission
> process, he folds all the -fix patches into the parent patch and it
> shows up pristine in Linus' tree.

Ok. So I still send it as a separate patch and he does the folding, or
should I send a revised patch that replaces the original one?

> 
> > This causes build failures at least on alpha, because there are files
> > that rely on barrier() being defined via the implicit include of
> > compiler_types.h.
> 
> That seems like a bug that should be fixed rather than reverting this
> part of the patch?
> 

I thought about that, but barrier() is used in a large number of places,
so reverting seemed like the safer approach, in case more errors like
this cropped up. I don't know if it's a bug, as it was defined in
compiler_types.h before my original patch, I'm not sure if there's a
reason only compiler_types.h rather than compiler.h is implicitly
included via the Makefile.

Cc'ing Masahiro Yamada in case he has comments on that part.

Thanks.
