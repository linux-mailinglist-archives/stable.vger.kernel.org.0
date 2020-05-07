Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED001C9E78
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 00:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEGW3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 18:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgEGW3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 18:29:48 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7724C05BD09
        for <stable@vger.kernel.org>; Thu,  7 May 2020 15:29:48 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ms17so3292630pjb.0
        for <stable@vger.kernel.org>; Thu, 07 May 2020 15:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XBVohqdeB+6SWxRGmmFJuyeMSq6V5Fxg2K5EHMfRPbg=;
        b=SVUtOgJ/cbUQqk9bkdROMWL4W5JPsDsiMZDZf8AsZ1frUJ8JhyuudTUE8rWn529fjt
         zBBBhj1sr+5Ac5H+SEfGbO6TcoE3arpFO1nWFhp/k5r9b0JIc3JY5ADF0/roHkioIe8w
         5kiQJQkIUWgxXIQADgZFJyqwB4E/hAKXXyBYpT8twbgfwkNGMUnAV3pChZC9RXia55oa
         biM+bv7h3CAtQj81S3lvq6TpHuMIIqGfdYCkWhpm7CDU9idd7SWS6Jp2DqPT2v1C6PMx
         o8FjWzNlv6hP4GhvRpSu5UD3x1e6dQlLc2qO4LBvMIqUGS+AV5eapsn2T9JAr9hgmaDS
         yN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XBVohqdeB+6SWxRGmmFJuyeMSq6V5Fxg2K5EHMfRPbg=;
        b=SOwHTLv5zdFqoRTltB1u9AZinPVAevrUqtA0n/B+nGM/Zf4CzKu1iVgIE/aX7ghHPp
         9ojzff1OmGovz2dO7SSEAv20owwAy1wU0ZmbTvges8xunHg0w0hmyDIkaE4OJwqEPuVa
         wL5bwiIs2zBo34x37W7FAI6SZtcOBL/ZRzsDYfjawXJ2L9P1ewxpGRqYxxoi0C8D5QDw
         mC2KEzeLiq2h7BYBrNdkRQexLucpsXqO/Pakda9MVJQdfibehiYIxZHOCnaxyGdy6KaQ
         0ogDiB4vPdb7kKUtZPSSZe9dlf+wdtr0zi3G+qnxprfbQal63VMXuYdE4lP8oCL+oTal
         UOkg==
X-Gm-Message-State: AGi0PuYBoXGcqtyYHIoyR3AhsUB/1LTVXHgdDqI078UgCT6KlVHRYutJ
        aUCANNhXqt8HA0H07oK81BdiEqEJlf0BXaBsnvIEag==
X-Google-Smtp-Source: APiQypKkkPDq8z2qnwoJ0+Jzr4hD+NCrW6kDegAy6Pbin9Bdru3LFkaT4ibhl5aa9Qv/zb+4Fu+Kcej8KUECq9VfwFU=
X-Received: by 2002:a17:90a:6d03:: with SMTP id z3mr2573417pjj.32.1588890587535;
 Thu, 07 May 2020 15:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com> <20200507113422.GA3762@hirez.programming.kicks-ass.net>
 <CAMzpN2hXUYvLuTA63N56ef4DEzyWXt_uVVq6PV0r8YQT-YN42g@mail.gmail.com> <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com>
In-Reply-To: <CAKwvOd=a3MR7osKBpbq=d41ieo7G9FtOp5Kok5por1P5ZS9s4g@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 7 May 2020 15:29:35 -0700
Message-ID: <CAKwvOd=Ogbp0oVgmF2B9cePjyWnvLLFRSp2EnaonA-ZFN3K7Dg@mail.gmail.com>
Subject: Re: [PATCH] x86: bitops: fix build regression
To:     Brian Gerst <brgerst@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 7, 2020 at 12:19 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, May 7, 2020 at 7:00 AM Brian Gerst <brgerst@gmail.com> wrote:
> >
> > This change will make sparse happy and allow these cleanups:
> > #define CONST_MASK(nr)                 ((u8)1 << ((nr) & 7))
>
> yep, this is more elegant, IMO.  Will send a v3 later with this
> change.  Looking at the uses of CONST_MASK, I noticed
> arch_change_bit() currently has the (u8) cast from commit
> 838e8bb71dc0c ("x86: Implement change_bit with immediate operand as
> "lock xorb""), so that instance can get cleaned up with the above
> suggestion.

Oh, we need the cast to be the final operation.  The binary AND and
XOR in 2 of the 3 uses of CONST_MASK implicitly promote the operands
of the binary operand to int, so the type of the evaluated
subexpression is int.
https://wiki.sei.cmu.edu/confluence/display/c/EXP14-C.+Beware+of+integer+promotion+when+performing+bitwise+operations+on+integer+types+smaller+than+int
So I think this version (v2) is most precise fix, and would be better
than defining more macros or (worse) using metaprogramming.
-- 
Thanks,
~Nick Desaulniers
