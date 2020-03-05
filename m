Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57D17ADF9
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 19:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgCESUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 13:20:10 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43557 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCESUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 13:20:09 -0500
Received: by mail-oi1-f194.google.com with SMTP id p125so6927932oif.10;
        Thu, 05 Mar 2020 10:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2sYXJQO6Yq9otqWKHOhi+UR9qlXpPMPoT6Si1fUA0Sk=;
        b=PMJEmZnUwXE3NOgvQUgOt2bjP55cluHYSc8rSdjGCzCbt1j3zTCwedZkvini9gvf8F
         tx9Jxt/qPLBQesudk+IiHEN8iIymNiycFyiV/oUmgYqqYhFSinRMpO6U5LZ0VIGZEm0W
         ZvqJ+QJp+P2tMObn+9ZY7CLkXMioDwTXkzxPQk3ZX6n/zNlt/klfO6bf7heSSSx4qA7w
         nyv3hyFOMo5Wv8KQdPaoEP2R3sMk+NCxVFgdWsNAffuH0P1qTzicxN0ROZKwiNeg3c+W
         N2KDH1cFJ6TqJzkWoAiBt0ppB5H0p79DUje7WDTyMzIz25GM1CSB/3pLhutXvNpvUCUr
         nwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sYXJQO6Yq9otqWKHOhi+UR9qlXpPMPoT6Si1fUA0Sk=;
        b=MszNaJbMjXHOOO2kq4nhGczPCnerooi3K6sCZVa4BeIgeurO8Va5vqVLapzmR+WplK
         4FUba42EPLzzmzGNGMty0sdsiMhlgaKv1D3nJdNIM6SkhBpsuI8X19/oS/eh/IsXjYLf
         HwzkYHQedtG+TBj6ITEpT9qqjXYBc4H/oGz6/4GhFhrw0QjAUP6+wJVwwQWLjof13Ij4
         OZUcMxhs7UsIB6BPVP/kZAxawrGM19X/vyN1vb3+8M5VVc6OkeRiSr6WuzAGzcBj9ocC
         Z+3QgNpk/SvxwgodkrfVncl/Ayoej8XPcxvSO9fjdvoMtaWDDfymtKD/OotAwlJWZ19/
         Nz4w==
X-Gm-Message-State: ANhLgQ3nQQ5OsG1h2/dzbrcNY2KOKATP7RY5KX9s4X7UX6vWGV/iyWoR
        roMRfX5onmKWwju6VtyBQgJw4PY01SOL58Bk/MQ=
X-Google-Smtp-Source: ADFU+vtribu1lE9gfwLSME7/yQEkndnVmVMFtDPMbjJTGDEAm13SV25Kute1R6cgk/Mf3g2E7xNxRXPhfT1drE0KbXk=
X-Received: by 2002:aca:170c:: with SMTP id j12mr271017oii.50.1583432408698;
 Thu, 05 Mar 2020 10:20:08 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
 <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
 <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
 <20200218182041.GB24185@bombadil.infradead.org> <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
 <20200218223325.GA143300@gmail.com> <CAHk-=wgKHFB9-XggwOmBCJde3V35Mw9g+vGnt0JGjfGbSgtWhQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgKHFB9-XggwOmBCJde3V35Mw9g+vGnt0JGjfGbSgtWhQ@mail.gmail.com>
From:   Andrei Vagin <avagin@gmail.com>
Date:   Thu, 5 Mar 2020 10:19:56 -0800
Message-ID: <CANaxB-xTTDcshttGnVMgDLm96CC8FYsQT4LpobvCWSQym2=8qA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Linus,

After this change, one more criu test became flaky. This is due to one
of corner cases, so I am not sure that we need to fix something in the
kernel. I have fixed this issue in the test. I am not sure that this
will affect any real applications.

Here is the reproducer:

#include <unistd.h>
#include <stdio.h>

int main()
{
    char buf[1<<20];
    int pid, p[2], ret;

    if (pipe(p) < 0)
        return 1;
    pid = fork();
    if (pid == 0) {
        close(p[1]);

        ret = read(p[0], buf, sizeof(buf));
        if (ret < 0)
            return 1;
        printf("read -> %d\n", ret);
        return 0;
    }
    close(p[0]);
    ret = write(p[1], buf, sizeof(buf));
    if (ret < 0)
        return 1;
    printf("write -> %d\n", ret);
    return 0;
}

Before this change:
[avagin@laptop fifo]$ uname -a
Linux laptop 5.3.7-200.fc30.x86_64 #1 SMP Fri Oct 18 20:13:59 UTC 2019
x86_64 x86_64 x86_64 GNU/Linux
[avagin@laptop fifo]$ strace -e read,write,pipe -f ./pipe_bigbuf
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260r\2\0\0\0\0\0"...,
832) = 832
read(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"...,
784) = 784
read(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0",
32) = 32
read(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0gZ\316<\240z\v\206=\360\37F\32{\t\204"...,
68) = 68
read(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"...,
784) = 784
read(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0",
32) = 32
read(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0gZ\316<\240z\v\206=\360\37F\32{\t\204"...,
68) = 68
pipe([3, 4])                            = 0
strace: Process 622350 attached
[pid 622349] write(4,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1048576 <unfinished ...>
[pid 622350] read(3,  <unfinished ...>
[pid 622349] <... write resumed> )      = 1048576
[pid 622350] <... read resumed>
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1048576) = 1048576
[pid 622349] write(1, "write -> 1048576\n", 17write -> 1048576
) = 17
[pid 622350] write(1, "read -> 1048576\n", 16read -> 1048576
) = 16
[pid 622349] +++ exited with 0 +++
+++ exited with 0 +++

After this change:
[root@fc24 ~]# strace -e read,write,pipe -f ./pipe_bigbuf
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260r\2\0\0\0\0\0"...,
832) = 832
read(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"...,
784) = 784
read(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0",
32) = 32
read(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0L\355\265_\4c\17r@ix\305q\26W\242"...,
68) = 68
read(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"...,
784) = 784
read(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0",
32) = 32
read(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0L\355\265_\4c\17r@ix\305q\26W\242"...,
68) = 68
pipe([3, 4])                            = 0
strace: Process 4946 attached
[pid  4945] write(4,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1048576 <unfinished ...>
[pid  4946] read(3,
"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1048576) = 65536
[pid  4946] write(1, "read -> 65536\n", 14read -> 65536
) = 14
[pid  4945] <... write resumed>)        = 131072
[pid  4946] +++ exited with 0 +++
--- SIGPIPE {si_signo=SIGPIPE, si_code=SI_USER, si_pid=4945, si_uid=0} ---
+++ killed by SIGPIPE +++

On Tue, Feb 18, 2020 at 3:03 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Feb 18, 2020 at 2:33 PM Andrei Vagin <avagin@gmail.com> wrote:
> >
> > I run CRIU tests on the kernel with both these patches. Everything work
> > as expected.
>
> Thanks. I've added your tested-by and pushed out the fix.
>
>            Linus
