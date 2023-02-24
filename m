Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9546A22AD
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 21:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBXUBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 15:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjBXUBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 15:01:10 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C89231C2
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:01:01 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id i34so1725147eda.7
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CycpbGYPVV7t0eKpbJzs8In3XpyKLfsIf6xBO+wlbU0=;
        b=Wa4InpbaYI/Bgwr0JgNYDgEz2pEKz09JbCGGPcgDYXzpyBOGYuQn1jTnf+awYVY5TG
         gLywfm0HGhJKHLdeJ3zH0UpPwFVP5ktSE8crVmyIP4jjR+qM9Jcb7GYS8UNVaOy8QiDJ
         1JiA2yPy0NMZBsUoU6blsiasOsEWPmL6hnlHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CycpbGYPVV7t0eKpbJzs8In3XpyKLfsIf6xBO+wlbU0=;
        b=3SMW4dt5dG9fzcWUIW2hobdr7VAKWao+vFgzfP79ncnYVphPMl0bfw9HrZuh97gAvf
         Lo2LZH5aFtvGJAzBrEKo3K7h5D6o9BxnQTNB1h7Bny7yNYRyMgMYDGeUjgq2ShvFy3+V
         GjyhZw+XvMEJKpPHDn50XuvrgoCk296xE6rQCM1dRNhLsPVDlWiR77fy44ZZQy5resV1
         ad/dbWOlxbRGJ/tOCVb16urEuORLCe4y81FFPVKBMw1GGS7VHl8tealPxOri7gKardS/
         6d+D3fn3muQB+99QOMt4Bi97yJ0Rk4bkxXfL/1i0J4PFT2qNVCWKhed7+RXaIo13d/d1
         VtTQ==
X-Gm-Message-State: AO0yUKUwOpSJmMhjqcFKoqEbFoxfbZfDefhEluAKpvCD6r4nd7AHV0jR
        UbfAEaI1Y9AnClahxFzozdtjXnNUjm416DSGqNbN+Q==
X-Google-Smtp-Source: AK7set+Rq2C4JkJ2vpDs98WCRtuMTNB6ypdiDtU0sH+zyiV0lc02jfRjnndkmC/t5iv/EBK5GXb1Ag==
X-Received: by 2002:a17:907:393:b0:8b1:7aaa:4c25 with SMTP id ss19-20020a170907039300b008b17aaa4c25mr27745779ejb.29.1677268859264;
        Fri, 24 Feb 2023 12:00:59 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id n15-20020a5099cf000000b004aef147add6sm96907edb.47.2023.02.24.12.00.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 12:00:58 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id h16so1659551edz.10
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:00:58 -0800 (PST)
X-Received: by 2002:a50:aa9e:0:b0:4ac:b616:4ba9 with SMTP id
 q30-20020a50aa9e000000b004acb6164ba9mr8016701edc.5.1677268858123; Fri, 24 Feb
 2023 12:00:58 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
 <20230224113247.07a660eb44198499314a9e96@linux-foundation.org>
In-Reply-To: <20230224113247.07a660eb44198499314a9e96@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 12:00:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj-+PTUfu9NsdDt3p7tLXbUH-KJPBz+r4wHX075fydEOQ@mail.gmail.com>
Message-ID: <CAHk-=wj-+PTUfu9NsdDt3p7tLXbUH-KJPBz+r4wHX075fydEOQ@mail.gmail.com>
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Jim Meyering <meyering@fb.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>, patches@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 11:32 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Can we use git instead of diff?  I tried once, but it didn't work -
> perhaps because it didn't like doing stuff outside a git repo.

Just using "git diff" does work *but* I would strongly suggest using
"--no-index" as in

    git diff --no-index -- path1 path2

because without the "--no-index" you will find that "git diff" will
use heuristics to decide what it is you want to do.

So if you do just

    git diff path1 path2

and both of those paths are *inside* a git directory, then git thinks
that "oh, you want to see the diff of those two paths against the
current git index", and does something *very* different from showing
the diff between those two paths.

And I suspect that is the exact reason you *thought* it didn't work,
but now that you tried it in a new test-directory, it did work for
you.

With the "--no-index", the ambiguity of "do you want a diff against
git state, or the files against each other" goes away

Just to give another example of this:

 (a) when I'm in my kernel tree, I can do

      $ git diff .config /etc/kernel-config

and it will show me the diff between the two files, because while my
".config" file is inside the repository, "/etc/kernel-config" is
clearly not, so I get that "diff between two files" behavior.

 (b) but then if I do a conceptually similar

    $ git diff .config arch/x86/configs/x86_64_defconfig

then git will see that both paths *are* inside the repository, and
think I'm doing a diff vs the git index state, and since I have no
changes wrt any checked in state in any paths that match, it will show
no diff at all.

So if I actually want to see the file diff between those two paths, I have to do

    $ git diff --no-index .config arch/x86/configs/x86_64_defconfig

to clarify what it is that I want.

Also note that "git diff" is *not* a replacement for the 'diff' binary
from diffutils in general.

Doing a 'git diff' will *only* generate the extended git unified
diffs. There's no support for any other diff format, and while there
is overlap in the command line switches, there's a lot of differences
too.

So "git diff" is very much a "you can use it as a replacement for
plain 'diff', but only in very specific circumstances" thing.

                 Linus
