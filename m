Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B215E245388
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgHOWC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 18:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgHOVvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:51:22 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DC2C0F26DA;
        Sat, 15 Aug 2020 10:38:56 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 184so10515065wmb.0;
        Sat, 15 Aug 2020 10:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=LTlBc86WBxHYhS5cpIEYsiz5cslHCacREpSctlHSwVw=;
        b=UKX2g9LyaGrYYaTOc8OpvojSuSFUeF7Fh8iTOZLf1s2NTTXNJxApmwzhIAxx7t86pp
         Qt6siL1UBFSvdUyrmTzxHt4gqmTVcyiJWjbvQI+CJioJTuX7PVX/JkBH/Gxy+wIhkQk8
         pkIR6wGdKhfAVbGuBcweVa1lsaxVYXrBh3mbCCD3QqVlTCp1dv+9GLVUUhRQxjiWEv+n
         l5AZ3Om8DNwYLKcgBbvAWLI5M0ooGBsnWFj2WxBsIe7qTZO+Gfwg/mU+Rf8+5M5QLvtU
         1pbDm+MP16aUw1SjyAHD4H6zL0ur4qJpwPM2bR6wsStICxlopuJUUfKzrB1RsL3G26jI
         kFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=LTlBc86WBxHYhS5cpIEYsiz5cslHCacREpSctlHSwVw=;
        b=K1hLzpZ1Mts+t0QM1ZEGNVpUOI2OveAu5CZtCwESKqAk/Xf4UynUjKMdDGrbd9EMQb
         uJubhKlZisK/X7xPrAjxShoCa85zX10T8b7c6/heTuIDoTd+foRTVbQ57N/5n5pnqdw1
         7m/mf/bE6/L44GfK7TQ740LE1IMRneAFE1NZffU3FzBTpPd2YG3TPI/iqfD/1ha3zUfJ
         9xVoj7kURigt58KNKkcLGTc0Sf2lwqw/XdWp3qAmDKe67+K+i7vF6PhmMTdqm+wf2F6u
         3uJzwrZDrAFgUjl/ihxEY/7aXl3/x4R525FxBAnCjClchonlSwSozoDjeF7XIXomzi/P
         6MzQ==
X-Gm-Message-State: AOAM5300GDxhH+K2+VaorSOm4LpsX9a223A079f5ARpIEl8xGNtRoY43
        woQv3nAN0MCMnfereBkpyaE=
X-Google-Smtp-Source: ABdhPJwa8fsBDCGcfSMqc/NcOe5scc7jwJeJxRKtujpEJRSIhOQSdZrzLLH0yblNZ3OtpkhaDz03+w==
X-Received: by 2002:a7b:c40b:: with SMTP id k11mr7526072wmi.107.1597513134116;
        Sat, 15 Aug 2020 10:38:54 -0700 (PDT)
Received: from [100.64.193.196] ([147.229.117.43])
        by smtp.gmail.com with ESMTPSA id 68sm23075592wra.39.2020.08.15.10.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 10:38:53 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?D=C3=A1vid_Bolvansk=C3=BD?= <david.bolvansky@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] lib/string.c: implement stpcpy
Date:   Sat, 15 Aug 2020 19:38:52 +0200
Message-Id: <672236FE-769D-48F0-AAAD-FB9630BB2FA9@gmail.com>
References: <202008150921.B70721A359@keescook>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Joe Perches <joe@perches.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Daniel Axtens <dja@axtens.net>, Ingo Molnar <mingo@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
In-Reply-To: <202008150921.B70721A359@keescook>
To:     Kees Cook <keescook@chromium.org>
X-Mailer: iPhone Mail (17F75)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yeah, sprintf calls should be replaced with something safer.

> D=C5=88a 15. 8. 2020 o 18:34 u=C5=BE=C3=ADvate=C4=BE Kees Cook <keescook@c=
hromium.org> nap=C3=ADsal:
>=20
> =EF=BB=BFOn Fri, Aug 14, 2020 at 07:09:44PM -0700, Nick Desaulniers wrote:=

>> LLVM implemented a recent "libcall optimization" that lowers calls to
>> `sprintf(dest, "%s", str)` where the return value is used to
>> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
>> in parsing format strings.  Calling `sprintf` with overlapping arguments
>> was clarified in ISO C99 and POSIX.1-2001 to be undefined behavior.
>>=20
>> `stpcpy` is just like `strcpy` except it returns the pointer to the new
>> tail of `dest`. This allows you to chain multiple calls to `stpcpy` in
>> one statement.
>=20
> O_O What?
>=20
> No; this is a _terrible_ API: there is no bounds checking, there are no
> buffer sizes. Anything using the example sprintf() pattern is _already_
> wrong and must be removed from the kernel. (Yes, I realize that the
> kernel is *filled* with this bad assumption that "I'll never write more
> than PAGE_SIZE bytes to this buffer", but that's both theoretically
> wrong ("640k is enough for anybody") and has been known to be wrong in
> practice too (e.g. when suddenly your writing routine is reachable by
> splice(2) and you may not have a PAGE_SIZE buffer).
>=20
> But we cannot _add_ another dangerous string API. We're already in a
> terrible mess trying to remove strcpy[1], strlcpy[2], and strncpy[3]. This=

> needs to be addressed up by removing the unbounded sprintf() uses. (And
> to do so without introducing bugs related to using snprintf() when
> scnprintf() is expected[4].)
>=20
> -Kees
>=20
> [1] https://github.com/KSPP/linux/issues/88
> [2] https://github.com/KSPP/linux/issues/89
> [3] https://github.com/KSPP/linux/issues/90
> [4] https://lore.kernel.org/lkml/20200810092100.GA42813@2f5448a72a42/
>=20
> --=20
> Kees Cook
