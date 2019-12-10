Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20446119651
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfLJV0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:26:08 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36122 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbfLJV0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 16:26:07 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so8847059pgc.3
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 13:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3CtzH8AoZNRV0QZPYFHChpbwIUEtjX+HfgVaCPCW0A=;
        b=Yi+iiwyyrF3IYMCCzCBjiPMce2oqIFmM0Xe7X7HraruPyvvuHKlt27cS/SnnCG2hw5
         5oMQEsLdEizNsGATmWxJhL17P3CrGayxm5W6xXSUB9EsGKO5L0am6CiDgj66illqeJZA
         mDtWxaOARAr9pxMLBrmpZpISvGD8xa5dWuokcVoxjObx10YcKt+BDYQhHqE+C2qf5niv
         Nno9unu53nGCKBKa1MXv8G8TdFv596C1aMr9ssWcEuAq7ilHnxw5AbBy5b+gb7LNfQN0
         T01Apo8Ke1kZwbHByG6dz+/NN02QV/h33F2cVGpfGCLBXPVAYhXnqgwZ+s8+XwGLaPYv
         IwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3CtzH8AoZNRV0QZPYFHChpbwIUEtjX+HfgVaCPCW0A=;
        b=qkasWVldoWyrWWl6seHWIxhogYIfs8c55Kwhp+0ejLyqzWO7/VPXB3Y+CdxGED1xKm
         1V7gqjfeSe8JUwk4SfPQDFYomaE2eaZMoNfqtXa2YO/gqCuXoBjIj+CQCHOZuqC59qFN
         zInBgnXAenREcbHkglpBxUrGbmb8fr9s8rTurVoULW4v3V+LXNZbe73UArPbphKJIyLW
         BXng1kKxI8ob1k19QDej2Sip1kyRPd/pMZouLUT2WWYV0ptIFleA8TGH4OwLzwxNnT6/
         yZUWlJ+BdL9VaRbL3Z2DdruL1R2gHueBtcB+9qxjxfppidXh1FtPo2p607Ld9LfHsBOz
         2bqg==
X-Gm-Message-State: APjAAAWPjvEyA7q/eYyM9IJLYa1zoohCPRQa2t7jK5N6B6EY0LpxqUxY
        yEgUmn38JbVmBb0YemynhW1XyBB+fo5lbPmSvIqqLA==
X-Google-Smtp-Source: APXvYqxpquTI2AjFI2FJW7H/UjW477l0ZNP57sYRhalkJYdVRDhwtSnkXMVoH2DkQcUGAGX7ywj1awJ0Yv6fEh5hpRI=
X-Received: by 2002:a63:480f:: with SMTP id v15mr162738pga.201.1576013166051;
 Tue, 10 Dec 2019 13:26:06 -0800 (PST)
MIME-Version: 1.0
References: <20191210210402.8367-1-sashal@kernel.org> <20191210210402.8367-25-sashal@kernel.org>
In-Reply-To: <20191210210402.8367-25-sashal@kernel.org>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Tue, 10 Dec 2019 13:25:54 -0800
Message-ID: <CAFd5g45s-cGXp6at4kv+=8v3cuxfbXLPEOKGUfvJ6E+u1caHcA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 025/350] objtool: add kunit_try_catch_throw to
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

On Tue, Dec 10, 2019 at 1:04 PM Sasha Levin <sashal@kernel.org> wrote:
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

> ---
>  tools/objtool/check.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 044c9a3cb2472..543c068096b12 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -144,6 +144,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
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
