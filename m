Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B648E2452FB
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgHOV5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729006AbgHOVwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:52:09 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60371C0F26DD
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 10:46:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f24so13213985ejx.6
        for <stable@vger.kernel.org>; Sat, 15 Aug 2020 10:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=eywfHkN6w/lFhgBNnTwkJBsdX/9WXxuaVVWtUYroxDA=;
        b=mDAVm44j8IfXoVl4RDa9PGE6NNsD9+Pt5YOpK2bsf1QVZdAzXgjUQYiFMT8M25pOs+
         2LDYzqZp6USzieTOesV0U4DQBKlPCvIJLNTUuHGkUcrqqq0t4nxlmZMwY3fallheqBfC
         ymgRdiwmb6QRoGYzpYdoG9RvibnaXlREHWVI2NNbefiCz5y99Kh01a7FAkvDiTnWtHLP
         dd/+bdmmsynxdDXAqrwXBSpwAeBhbKr0SEHWvPfUifSr2Jl9aVpRwuTToJWcGwDQV8fm
         ICbIyM/3wVWnAd1cOCvtzizit8nbfstUj0I/BTlIGdVE5GTizvHxi1c8Q88HQbobvTH9
         ycMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition;
        bh=eywfHkN6w/lFhgBNnTwkJBsdX/9WXxuaVVWtUYroxDA=;
        b=BDcUqCoNGj5PEIGc0gdFy5dRxbYHnrzNVjkFtwkOpDhPZxFM0tqnaiP0XseMub82Wi
         fhp8kEK9h3OUDBM7Sbnrxs8UreG2xnmXBde0yB484iLlQGkVkaqriVns6SpT/ZRfRzzv
         K/f+DQ10nD32izxWJt3sULtHMWaFL5RstNs1Gg7OqDlrbJwAz33jIVJhmokfDaXYQwgx
         8ucSmlAf3quXVmObCK8YXnmqYbVBrFGZdE6iYG6wKyJzmIxbuTkvieiISE7nQPK3Dnvq
         n0LsotBIYw8KyR7pg4aZLpKlHPsQDyOt0VfziwjfoNM+h2Itz1d6v6UgbSKDF9E9iDK6
         hZcw==
X-Gm-Message-State: AOAM532sXKSZqzsBsDdWMA33wkLrqwh5CPJmCpbSN6MuUAkoMERXjShA
        0iJcodpWcnIjUgQvIQYr3f1lUb0iFsI=
X-Google-Smtp-Source: ABdhPJxCXWv0LJXOc2HR8JhtkiPevCTLfNTQUep7agFc+lPzCtatwOtvDP8zWkvvg0Q0IpUCD1EtuQ==
X-Received: by 2002:a17:906:b157:: with SMTP id bt23mr8298084ejb.354.1597513603428;
        Sat, 15 Aug 2020 10:46:43 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id t18sm9577563edr.79.2020.08.15.10.46.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 10:46:42 -0700 (PDT)
Date:   Sat, 15 Aug 2020 19:46:40 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     stable kernel team <stable@vger.kernel.org>
Subject: [edumazet@google.com: Re: [PATCH] x86/fsgsbase/64: Fix NULL deref in
 86_fsgsbase_read_task]
Message-ID: <20200815174640.GA2718256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


hi Greg,

Please apply upstream 8ab49526b53d to all stable kernels containing 
07e1d88adaae, which should be v4.20 and higher stable kernels.

Thanks,

	Ingo

----- Forwarded message from Eric Dumazet <edumazet@google.com> -----

Date: Sat, 15 Aug 2020 10:38:58 -0700
From: Eric Dumazet <edumazet@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, Jann Horn <jannh@google.com>, syzbot <syzkaller@googlegroups.com>, Andy Lutomirski <luto@kernel.org>, "Chang S . Bae" <chang.seok.bae@intel.com>, Andy Lutomirski <luto@amacapital.net>,
	Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Denys Vlasenko <dvlasenk@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Markus T Metzger
	<markus.t.metzger@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Rik van Riel <riel@surriel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task

On Sat, Aug 15, 2020 at 4:48 AM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Eric Dumazet <edumazet@google.com> wrote:
>
> > syzbot found its way in 86_fsgsbase_read_task() [1]
> >
> > Fix is to make sure ldt pointer is not NULL.
>
> Thanks for this fix. Linus has picked it up (inclusive the typos to
> the x86_fsgsbase_read_task() function name ;-), it's now upstream
> under:
>
>   8ab49526b53d: ("x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task")
>
> By the fixes tag it looks like this should probably be backported all
> the way back to ~v4.20 or so?

This is absolutely right, sorry about the lack of a stable tag.

Most of my patches usually land into David Miller trees, where the
stable tag is not welcomed.
We use  Fixes: tags to convey the exact information needed for stable backports.

Thanks.

----- End forwarded message -----
