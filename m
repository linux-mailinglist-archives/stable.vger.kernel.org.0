Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8AF429792
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 21:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhJKTdB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 11 Oct 2021 15:33:01 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:48223 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbhJKTdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 15:33:01 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mg6qO-1nF7ee22RS-00haXR; Mon, 11 Oct 2021 21:30:58 +0200
Received: by mail-wr1-f44.google.com with SMTP id k7so59347121wrd.13;
        Mon, 11 Oct 2021 12:30:58 -0700 (PDT)
X-Gm-Message-State: AOAM530C/yMkK3RSNAphupHfzMAmQX7th8GtKkD8PRzRuh05bni93STJ
        tWf5CTm6O181/drXKxmYS3LVF/zGg/BlYRC54Ok=
X-Google-Smtp-Source: ABdhPJwcQxnL9T+TV2wMdxUlHIwU3SOujQV7rBjgQ4DIIC9hK0k7a7KHDrcmx/pY7AVYRFhw6lDYLfOeEoaaOibETc8=
X-Received: by 2002:adf:e292:: with SMTP id v18mr2836477wri.369.1633980658161;
 Mon, 11 Oct 2021 12:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134517.833565002@linuxfoundation.org> <CA+G9fYutz0ZgJ=rrg8=Fd7vh9c7G-SJfF2YoH5wZyGzUHu4Dqw@mail.gmail.com>
In-Reply-To: <CA+G9fYutz0ZgJ=rrg8=Fd7vh9c7G-SJfF2YoH5wZyGzUHu4Dqw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 11 Oct 2021 21:30:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3WYDbLm40OEMDcDfBJWRqfaWLvVQu4eD8W=UEjkBrpUw@mail.gmail.com>
Message-ID: <CAK8P3a3WYDbLm40OEMDcDfBJWRqfaWLvVQu4eD8W=UEjkBrpUw@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:ifwz+T8NPRruzddV4zw4V6SEJxh40ZJrWIe39UNSkUhiKz6piiy
 iFlwxQwY1gOwdp/moFlNAHFpvAco3aaZQoUcRvqsTgJYdLNoCl8K4Kte3HN3azoa2f+Z6Gj
 TjW2Ja15Tupt/jIsOenrCIA+uzRnqtYvRdpgmWYJpXaXdP6n2TiXwJl1/+7CqopeDRm2UrD
 gAjXzTgLkCwpkXlMjCmVA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S7LYVrpapiA=:N2MBF1K1Ojk/ASMz9nvxSP
 ZqubP2Zh86XmI59VoMiwovVcFU0q0H2G+mKPlzveHI5axBfWOBV0cAqxESYUBdxfCVYkQ8J0q
 gVXVVdmtrM6ZkQza6d+wyW68fpg8sMWKKDhRhvNZlX4/vL8+Thpxysq5tQKLg2dGoA70bxiBh
 Mvzxld8/YkKZVfqYQIk8BCFOL1coJbsQF3Xfsd5qKox6lRI7J1stqkxfZlYQ3zS0drlhyr+Gb
 T5b1hWwc0HyZ7lkRWrOcShw863NgSaw6eub2Y0Db4YuRnYkqN3taj51t1IQyI5paFYkeQBmrE
 q0Vadmc8JVqtk8ZngqN3PN7jsJ4J5BIV3pREUSwNZHXygW/uridstFXDALUUchwoX/OcbF5aX
 vbQeyS9EYJIf0ccbc1tlgsyuh+Q7i2QlD/WAsWMmK3oEnP+mXxGWikJjN+QI7Li1HAiNoZNYS
 FZB1kH5c+4uUPDPz94fNsca0tlh1Z5xe6oHACjJVmvTFxmJzp69QO7bOv+26LECJxY77CL+Je
 evF37D+hGmus83PBOQ68HqOMv//8JixgpNKrRdqW6eH4HaTDuBCIIRiVAi8kovo/UYK/auGtK
 CKi8X94QElEtKPqx48HGbgWvZBeYKTeqZKQ7z1XQjucskv8xArXaATh6AO4nsR6WlunxCSC6v
 b1upCUP5qUOo3GIUiN1FGfoZd4kmPTTlsSJpQbu2lPSd8EyABZ1/Y295VPmrfiZRQXJV1ExUA
 PURvTC/UqHl1S3ShpdI4opud89n608PEWiCS+w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 8:35 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
>
> Results from Linaro’s test farm.
> Regression found on arm x15 device.
>
> metadata:
>   git branch: linux-5.14.y
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git commit: d98305d056b808dd938d2ae6bfd0e3ccac00a106
>   git describe: v5.14.11-152-gd98305d056b8
>   make_kernelversion: 5.14.12-rc1
>   kernel-config: https://builds.tuxbuild.com/1zMbwi83MvhJdKpC0LTvxvIh1Fb/config
>
> Crash log,
> [    0.000000] Linux version 5.14.12-rc1 (tuxmake@tuxmake)
> (arm-linux-gnueabihf-gcc (Debian 11.1.0-1) 11.1.0, GNU ld (GNU
> Binutils for Debian) 2.36.90.20210705) #1 SMP @1633961260
> [    0.000000] CPU: ARMv7 Processor [412fc0f2] revision 2 (ARMv7), cr=10c5387d
> <trim>
> [    5.403076] Kernel panic - not syncing: stack-protector: Kernel
> stack is corrupted in: __lock_acquire+0x2520/0x326c
> [    5.413574] CPU: 0 PID: 6 Comm: kworker/0:0H Not tainted 5.14.12-rc1 #1
> [    5.420227] Hardware name: Generic DRA74X (Flattened Device Tree)
> [    5.426361] Backtrace:
> [    5.428863] [<c153b5e8>] (dump_backtrace) from [<c153b9a8>]
> (show_stack+0x20/0x24)
> [    5.436492]  r7:c2109acc r6:00000080 r5:c1c3c52c r4:60000193
> [    5.442169] [<c153b988>] (show_stack) from [<c1542cf8>]
> (dump_stack_lvl+0x60/0x78)
> [    5.449798] [<c1542c98>] (dump_stack_lvl) from [<c1542d28>]
> (dump_stack+0x18/0x1c)
> [    5.457427]  r7:c2109acc r6:c1c1d4ac r5:00000000 r4:c23a1aa8
> [    5.463104] [<c1542d10>] (dump_stack) from [<c153c800>] (panic+0x13c/0x370)
> [    5.470123] [<c153c6c4>] (panic) from [<c1555854>]
> (lockdep_hardirqs_on+0x0/0x1d0)
> [    5.477752]  r3:c28033d0 r2:a519091a r1:c03dc7ec r0:c1c1d4ac
> [    5.483428]  r7:c2109acc
> [    5.485992] [<c1555838>] (__stack_chk_fail) from [<c03dc7ec>]
> (__lock_acquire+0x2520/0x326c)
> [    5.494476] [<c03da2cc>] (__lock_acquire) from [<c03ddfe0>]
> (lock_acquire+0x140/0x414)
> [    5.502471]  r10:60000193 r9:00000080 r8:2ca87000 r7:c31c4128
> r6:c20935e0 r5:c20935e0
> [    5.510345]  r4:c31c4000
> [    5.512878] [<c03ddea0>] (lock_acquire) from [<c03a2e1c>]
> (account_system_index_time+0xf0/0x284)
> [    5.521728]  r10:c31c4000 r9:eeb1fa40 r8:eeb1a4f0 r7:00000002
> r6:c321db80 r5:00000000
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Full test log link,
> https://lkft.validation.linaro.org/scheduler/job/3719571#L2392
>
> zImage:
> https://builds.tuxbuild.com/1zMbwi83MvhJdKpC0LTvxvIh1Fb/zImage
>
> Build link,
> https://builds.tuxbuild.com/1zMbwi83MvhJdKpC0LTvxvIh1Fb/

It looks like a really long backtrace, and there is something about stack
corruption, so I wonder if the stack is actually overflowing here. Can
you see if the same thing happens with Ard's vmap-stack branch from [1]
or if that shows a different output?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm-vmap-stacks

         Arnd
