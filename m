Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A2548CAB8
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 19:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbiALSMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 13:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356245AbiALSK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 13:10:58 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EB0C034001
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 10:10:57 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id q25so13344395edb.2
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 10:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DhSCFec3TdzZgoMmjiOtfrqEeP0ETxz+5Dx8yofaKqk=;
        b=ACYcmQYX22hOF9eHsSpz63wI3cG/WXMRlzAlN2whKAaJhPR9GPIxx9qzxyuqNMjA+7
         rZivP0MyhKT2m5OXVlrJzc4KyBRcDy7L36J2mi7wYToYCPNHQweiy7y/QtQh9y37tYtS
         Q95EMM11LnVKXAhQsE7YRBQZnsA8tqq/mJJvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DhSCFec3TdzZgoMmjiOtfrqEeP0ETxz+5Dx8yofaKqk=;
        b=waH97nJin0uemrJzbeWCiAW65S1N/LtnFj2vMhz5LkG0h0QcTxPRj9szRXZq+VRZWg
         HOm2oAEoyh948xdfdMzJzHKUI4m8PeVS8rJVyThzxfwqUQ7LbGVbj4jIoDX0QYAy7Uqf
         r7iltKrFveF+Zc4hS1PTmLnxO0NwUeHtaAKbfIh6V33FcMnLCSE8ZBNKdOpD02mk7BV4
         ZTImdtzTBYl/8lIO9kUFwfXH1Td+zQSYXoIpWxUkZkPHXhgZL0+HdFtxOYVsDkAZpQWc
         sBwvlHESw9TSioW6DZbpk0tJCRjOhW1v0JAvUt6TwYXIT68k+uFkFkL37UV1qwaXzgUx
         bxbA==
X-Gm-Message-State: AOAM530gtpSd4vJlbIeBB6tQtcUL2wVKO6pNEtxqj1lSXnWfYBJDJD0K
        i06r3DPVo/3S9pNBQWgXTnyXdJm9hq+HOU23Ork=
X-Google-Smtp-Source: ABdhPJzNSNVexniFYg7NkOvfWeNoKOBRMfqE3HXBH1ahZC8LiLX7fTnO+cYDY0N6JBUV3IsMRL8BpQ==
X-Received: by 2002:a50:f0da:: with SMTP id a26mr788916edm.37.1642011055472;
        Wed, 12 Jan 2022 10:10:55 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id p25sm197189edw.75.2022.01.12.10.10.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 10:10:55 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id c66so2184410wma.5
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 10:10:55 -0800 (PST)
X-Received: by 2002:a05:600c:4f13:: with SMTP id l19mr7775750wmq.152.1642010629913;
 Wed, 12 Jan 2022 10:03:49 -0800 (PST)
MIME-Version: 1.0
References: <20220111232309.1786347-1-surenb@google.com> <Yd6niK1gzKc5lIJ8@hirez.programming.kicks-ass.net>
In-Reply-To: <Yd6niK1gzKc5lIJ8@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 12 Jan 2022 10:03:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiNQD6o-REKoZv_5cHWrGmsT_KgduYCsLdLqbdHWUKcdw@mail.gmail.com>
Message-ID: <CAHk-=wiNQD6o-REKoZv_5cHWrGmsT_KgduYCsLdLqbdHWUKcdw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Eric Biggers <ebiggers@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 2:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Thanks, I'll go stick this in sched/urgent unless Linus picks it up
> himself.

I'll let it go through the proper channels, it's not like a few days
or whatever will make a difference.

               Linus
