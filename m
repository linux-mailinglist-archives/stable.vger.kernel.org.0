Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00238119742
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfLJVb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:31:56 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36631 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbfLJVbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 16:31:53 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so474543pfb.3
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 13:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GwuPpgMwTPZEM+EqzujwY/bjr0hgFF4x3/rgCEqS8Mc=;
        b=f5WDsrWQ6ZRIQ/PxW73IwPJ17T1V0msim69wBlYUK+6b9M5fCKCNhn4N1DwWjk6bZ9
         LN84wH5MPyKwryNyUEjUyNs8d6mFs7KJ+1OIHdzWDQh4c/8/vMyWJqZTcScNH+Y7eSfF
         4FbDdrjVgmMk2Rp8xodWm7AOtyvz5sWiB/jsWttl39tyCosQcQJ+byG2mBBdoIw9UZF0
         waRRmF6h2lRTwMrBzjsb5lZ4kf0GdrVAT+eJzN6WY/Z2LAoO4htHd0JAWNn6B4x2oHrg
         mqV7BibZMhUAQx/BjgYgofyqs+GwBItobtMroXkJ8VotH30Hd/8TEkMNJZYyF3rHSewm
         Jtyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GwuPpgMwTPZEM+EqzujwY/bjr0hgFF4x3/rgCEqS8Mc=;
        b=Tn3adTEbNkYex/9t8Lbuf5NaUhgOjvqQbpGpAA/6knZUHi7glvpFghT+z3WvxD+7RB
         gaIGQoB9Mg5zaEBCuR1iYnSL11O5Q2VShRnhu5h0OVmTVYFnKGuhmMDqzUbjQOILeHP5
         06l2DudMcmuQdQUgJNk6RIk8J+9wHBKvXrBctqEPblgNBjtflwHn7ZNhF5R6oH4B5IC7
         2rGYoPSJWD3wgWjz07e+Or6FfxYuogCfKnz9BIjhddR/hHEAJJiP3ixKfOt+S63l3ort
         7mOMn8oONDcIQOQwTorGmBYJastVxotKPXAad+g+M30Jo4kzRaYcLDwRtOkIBBNQPUH7
         4K4Q==
X-Gm-Message-State: APjAAAXCo3e+Ew32EJJbwM15PddpNfwkXcPY1SEnODoxrCEdMH1wQaY0
        4xGYufTelvGNBOZ76Eu3I9imAkf4nohAnImpicg7CKYiP4+pyw==
X-Google-Smtp-Source: APXvYqzs9zHaXPpx5/fRmcbjTOsxQRvvH9Qr9I2jE5nXoJrZnej1b37eMSlm1mwwOPgmBS9e5vTq7NGxMlNDfngPnYg=
X-Received: by 2002:a63:597:: with SMTP id 145mr209239pgf.384.1576013512117;
 Tue, 10 Dec 2019 13:31:52 -0800 (PST)
MIME-Version: 1.0
References: <20191210212511.11392-1-sashal@kernel.org> <20191210212511.11392-19-sashal@kernel.org>
In-Reply-To: <20191210212511.11392-19-sashal@kernel.org>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Tue, 10 Dec 2019 13:31:40 -0800
Message-ID: <CAFd5g46bujW0XZeTwd1y2O1E2aeK_DayrES8zw_0zBF4Se0HpQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.3 019/292] objtool: add kunit_try_catch_throw to
 the noreturn list
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 1:25 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Brendan Higgins <brendanhiggins@google.com>
>
> [ Upstream commit 33adf80f5b52e3f7c55ad66ffcaaff93c6888aaa ]
>
> Fix the following warning seen on GCC 7.3:
>   kunit/test-test.o: warning: objtool: kunit_test_unsuccessful_try() falls through to next function kunit_test_catch()
>
> kunit_try_catch_throw is a function added in the following patch in this
> series; it allows KUnit, a unit testing framework for the kernel, to
> bail out of a broken test. As a consequence, it is a new __noreturn
> function that objtool thinks is broken (as seen above). So fix this
> warning by adding kunit_try_catch_throw to objtool's noreturn list.
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Link: https://www.spinics.net/lists/linux-kbuild/msg21708.html
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't think this change should be backported. This patch is to
ignore an erroneous warning introduced by KUnit; it serves no purpose
prior to the KUnit patches being merged.

Note: I have the same complaint for this rebase here:

https://lore.kernel.org/stable/CAFd5g45s-cGXp6at4kv+=8v3cuxfbXLPEOKGUfvJ6E+u1caHcA@mail.gmail.com/

> ---
>  tools/objtool/check.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 176f2f0840609..0c8e17f946cda 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -145,6 +145,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
>                 "usercopy_abort",
>                 "machine_real_restart",
>                 "rewind_stack_do_exit",
> +               "kunit_try_catch_throw",
>         };
>
>         if (!func)
> --
> 2.20.1
>
