Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693BC5A136
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfF1Qme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 12:42:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37827 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1Qme (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 12:42:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id g15so929071pgi.4
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W/aFd5UEl23fiMZiuBzixsVgjS8CX6xWvzats3nk/SM=;
        b=En/Au1k4K9ohv2CO+TfW1Y7cVPt1yOOwRsH4H9n0bykZsszUDhfTXt/rspiV6/gqAD
         GVN8Quj908TNKwb/odPPurb3eqN4utoU3G/Luj5uG4q1hNwykTUbQMVEcVYUMTq6K46e
         u1bdpFxAcLFT6kA9zdaM9LfPqle3IZaf6xc4SBtsHMzWD1aFOxIiJ8d5jrMN6kZtNMrA
         826RWt+jnsgEMhfvaKBwwqtShhHFRrWSIQvcEzXoz1Qsnt6UEO3P+MmVEee3+OrHo3dA
         RHYuM6ykpJ9a+Y7aD9guYEE52jbJCVtJqjAS7tN9YAA/qw4I46MgQruRi/siD1+rBdVX
         Qaag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W/aFd5UEl23fiMZiuBzixsVgjS8CX6xWvzats3nk/SM=;
        b=GLedWzMz9jXXm0lOgFLht68xPc7GRwV1aCHABi2JxRjwvbvtdP1cTTmMGLnyU0kYfW
         UT90FJwOxcwbOX1/hjiLqtLBxEGYL+MaPbnsEu3ADrRmrxOeqE+BxwLKPngaz7U+zY8D
         ekuXzEbbJzUzo1qLNoV9rCjggtFR+Duadvzqj8tcNTaY8aH7ujNX/EuxowAVWTq27Vrd
         t0QdHgT+5rwFuLHH/e621doeXl0/cIkpwMEW+KmHclt+1CiLo7w5z6gP9VILE8zS9j+r
         mr1tntDJro8jwbWzMoJ0tPrnRNprmPWYyGIcLQ+dIrzN1Q7+h1nePpQxtfULKONpeGzF
         PAYg==
X-Gm-Message-State: APjAAAVVWcgvJwGVCAjE9iitZA9YHpeAgrY2Fe+hOMyB01t6POlaA3F7
        BldRorD4Ic+Qr871uaoEg14OBNBBaVrLIg4c7UzFS+w1YhzWLg==
X-Google-Smtp-Source: APXvYqzXrxJNASXSoPv0JWIIQXcSVg944iiXOjyCw3p5x8Y7hfuN2nCmLGfmuGeN8dG5E/q+IvZkaAAiEJSYkHsRYQ0=
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr14506978pjq.134.1561740153034;
 Fri, 28 Jun 2019 09:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <54a67814-1c9a-14c9-3a7d-947b08369514@cybernetics.com>
In-Reply-To: <54a67814-1c9a-14c9-3a7d-947b08369514@cybernetics.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 28 Jun 2019 09:42:21 -0700
Message-ID: <CAKwvOdncNyL27A8y0Cq-md1ub9r2RdzBcb7ZrmmmyqLBxKvSfQ@mail.gmail.com>
Subject: Re: Regression: cannot compile kernel 4.14 with old gcc
To:     Tony Battersby <tonyb@cybernetics.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 8:53 AM Tony Battersby <tonyb@cybernetics.com> wrot=
e:
>
> Old versions of gcc cannot compile 4.14 since 4.14.113:
>
> ./include/asm-generic/fixmap.h:37: error: implicit declaration of functio=
n =E2=80=98__builtin_unreachable=E2=80=99
>
> The stable commit that caused the problem is 82017e26e515 ("compiler.h:
> update definition of unreachable()") (upstream commit fe0640eb30b7).
> Reverting the commit fixes the problem.
>
> Kernel 4.17 dropped support for older versions of gcc in upstream commit
> cafa0010cd51 ("Raise the minimum required gcc version to 4.6").  This
> was not backported to 4.14 since that would go against the stable kernel
> rules.
>
> Upstream commit 815f0ddb346c ("include/linux/compiler*.h: make
> compiler-*.h mutually exclusive") was a fix for cafa0010cd51.  This was
> not backported to 4.14.
>
> Upstream commit fe0640eb30b7 ("compiler.h: update definition of
> unreachable()") was a fix for 815f0ddb346c.  This is the commit that was
> backported to 4.14.  But it only fixed a problem introduced in the other
> commits, and without those commits, it ends up introducing a problem
> instead of fixing one.  So I recommend reverting that patch in 4.14,
> which will enable old gcc to compile 4.14 again.  If I understand
> correctly, I believe that clang will still be able to compile 4.14 with
> the patch reverted, although I haven't tried to compile with clang.
>
> The problematic commit is not present in 4.9.x, 4.4.x, 3.18.x, or 3.16.x.

$ make CC=3Dclang -j71 arch/x86/mm/fault.o
produces no objtool warning with upstream commit fe0640eb30b7 reverted.

x86 defconfig w/ Clang also have no issue with that reverted on 4.14.y.

Revert away.

Greg, Sasha,
Do you need a patch file for that, or can you please push a
$ cd linux-stable
$ git checkout 4.14.y
$ git revert 82017e26e51596ee577171a33f357377ec6513b5
--=20
Thanks,
~Nick Desaulniers
