Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A8FA0D59
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 00:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfH1WQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 18:16:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35053 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfH1WQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 18:16:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id d85so675316pfd.2
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 15:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cI7lPiUMiKomeyCUPJV8+wea36GrOdMvUW16YwohpL4=;
        b=jXn6+gJpaxbVNRJosKVFyJhneE9YA5zZwsY8f08DrvC0jdN8yLLcVGCWMK2MI3asR4
         mR/w63vTs01x2zv23z7+ENGGZQxl5lP0L7IswMDFJOeF+PfFa5XufKp3POnqA+d+T6gY
         iU+oHtm3aswQz2vouOHL+N524tw8/MB11zHdlBgBdRzuAh47R8nLGjf1MN97LAs8TJRe
         t/WglKh0C6Rjvv9Re03vW31Joo/EvEeqi4mSkOvC7ypSmqITd1jZJvKuBnm7iaOIvEcf
         ItToIAbDhJ7/bc4XNow2l99yUWnAB+lmrvfN0Ccw9w/MiRJ2uXkTq0B2GJ7+NypqqmIG
         MYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cI7lPiUMiKomeyCUPJV8+wea36GrOdMvUW16YwohpL4=;
        b=bapZnmIqpWvJkr3RLTELKTLC1mHUwqrINUiKs/RhuvcWKjNQ+ppWpf+2StsPWujGxU
         tCSktlcm8q/ED8Gi2qFFn8r/lAw8fFr2HNV76Q3Kh3yv56Wj4LohfcapfLIdFxOTFVXn
         nf4WwCAdN3BMBVJLU15yqLSWca4xaU5DY9oLflJRkbMiI26hSXwbEwvxPx5aeBAGtzRy
         V8uZbYOG/4S51uv5nqGmfPJRuDTTWegGXXiDLDHaUY2QFXCiLXCvqRtzGAIukU3G7dWt
         KHeGjMiTHH1uNt87OdFIqlazawMkeC43esTn+wUZbu9Et8pfIVMzBfyPHKvOmCYoA0u0
         ONtw==
X-Gm-Message-State: APjAAAUv0Y4AUBtJt0QsxgluNmooPIb46/Dcs1HEGzXJ3mWRusEBDhPf
        iy9WkzdBjtUVMg1AnyDnKVtWbBMB/oCEX1pCkuVm3Ltu1pA=
X-Google-Smtp-Source: APXvYqzuyqHfthUYWwSiGUlecSwGfmshq015FiqdVWTRGOTXZRuEO4B0tLgZTFnI+YVgOwfSzB5KTyCLaEyT79V8AoY=
X-Received: by 2002:a65:690b:: with SMTP id s11mr3546456pgq.10.1567030590292;
 Wed, 28 Aug 2019 15:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190812023214.107817-1-natechancellor@gmail.com>
 <878srdv206.fsf@mpe.ellerman.id.au> <20190828175322.GA121833@archlinux-threadripper>
 <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com> <20190828184529.GC127646@archlinux-threadripper>
In-Reply-To: <20190828184529.GC127646@archlinux-threadripper>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 28 Aug 2019 15:16:19 -0700
Message-ID: <CAKwvOd=wdscd7smcKZk40zD_n1OUVkhYYd7ZnoK8r1Y+pkvYVg@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 11:45 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Wed, Aug 28, 2019 at 11:01:14AM -0700, Nick Desaulniers wrote:
> > On Wed, Aug 28, 2019 at 10:53 AM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > Yes, I don't think this would be unreasonable. Are you referring to the
> > > cc-disable-warning flags or the -fno-builtin flags? I personally think
> > > the -fno-builtin flags convey to clang what the kernel is intending to
> > > do better than disabling the warnings outright.
> >
> > The `-f` family of flags have dire implications for codegen, I'd
> > really prefer we think long and hard before adding/removing them to
> > suppress warnings.  I don't think it's a solution for this particular
> > problem.
>
> I am fine with whatever approach gets this warning fixed to the
> maintainer's satisfaction...
>
> However, I think that -fno-builtin-* would be appropriate here because
> we are providing our own setjmp implementation, meaning clang should not
> be trying to do anything with the builtin implementation like building a
> declaration for it.

That's a good reason IMO.  IIRC, the -fno-builtin-* flags don't warn
if * is some unrecognized value, so -fno-builtin-setjmp may not
actually do anything, and you may need to scan the source (of clang or
llvm).

-- 
Thanks,
~Nick Desaulniers
