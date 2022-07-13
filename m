Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74FF5736C8
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiGMNDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiGMNDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:03:20 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E58226F
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:03:17 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r76so10735327iod.10
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rDKiIEBiJkD3wii1WeUC6W7Tfb9Ha6NHPyBcXqQXFzo=;
        b=bmxQ8QZvSNH/RUaxaCA4+Y7aR0hqilUjcWXANUsDBUtdoaoSJ7hilTe8pQwcbt8Iyw
         4w+gknVfgYl+zh9JTx1FVTbypYnza62sRWjEsv2XJRd+T9ijwAR7Od9GMFBPZ4OMExlF
         lR9zAJlY2xRbhvlEKXAal0XMQNQ2CnMh8tcjGpcmQI6uZtrjJaDlKgscH+iBgw5z7bgL
         LWYw0jgh/Q7xLFHLfn+ZQ4y15uK0k9QlUDrXP6cI+yDGyd74X8ohxmGaDIKAHWsQvZaz
         hxxQvKt9a9Ak2CNaxAhBigijE9aRr8aZ6F2K2bmDxIHbixeI/zvC/KWBGBPXiA7LAFs0
         sD6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rDKiIEBiJkD3wii1WeUC6W7Tfb9Ha6NHPyBcXqQXFzo=;
        b=WUvotf+IdzsC4uhWkiIB/z4v+9gt/0tas8SCk2v7BQLim4CRJQAhIE+pnD0XUUDOmD
         z8HH8zM2H23b7r8xL103GoCr6Qp1lPtrF9T5QytUThpYqoUD1wjDYn1n0Fkrokjl3oAg
         9ZotzMcQG/aiuomd8FcBRuU8sarBl4b+qdQSejhZWGqRD0C8GtzdknG5HI9aRT63XTNM
         ivr1Jj7Nf198NNFxtqDqhc/5zX+VVCEXHXK0r4OzfZxd6H6lujFb/7lZA4VjFWtVfbsD
         xBdtXZCZVHNygdZMrFX1VtWpdMMhZkdAcUPBC7BYPKm3oN1CTNkR1tITWn4SmzWF27/j
         igyQ==
X-Gm-Message-State: AJIora/IaPArSvRx7bJm0clrtGNhgwvgI1WZiPH7SZ6Aqq54prn9wkHU
        HvppLDKHO2/cPmzYBZ1CukrJfVXAxvqiKCc1HUuiOA==
X-Google-Smtp-Source: AGRyM1sxpSMZ9dqgbdpZSzcjbfJOvUnpCwfLUU55sKoo/gZEeVb5n3gcaNc+ZsS+5AOpIkr8Lr3gidPYymL89Ml2xIY=
X-Received: by 2002:a05:6638:272c:b0:33f:6fe4:b76f with SMTP id
 m44-20020a056638272c00b0033f6fe4b76fmr1794998jav.284.1657717395274; Wed, 13
 Jul 2022 06:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183246.394947160@linuxfoundation.org> <6acd1cd0-25aa-eb9c-4176-49f623f79301@gmail.com>
 <CA+G9fYsBFy65-Y1Yo_Zr_bJWGV6QYhMaEhyaShOG+qoOD7pu+w@mail.gmail.com>
In-Reply-To: <CA+G9fYsBFy65-Y1Yo_Zr_bJWGV6QYhMaEhyaShOG+qoOD7pu+w@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Jul 2022 18:33:04 +0530
Message-ID: <CA+G9fYsAUpE4jrdSG7u2cx8Hftvxm7cyMP_pgYq26nQKuUH90A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/130] 5.10.131-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 Jul 2022 at 15:05, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Wed, 13 Jul 2022 at 04:45, Florian Fainelli <f.fainelli@gmail.com> wro=
te:
> >
> > On 7/12/22 11:37, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.131 release=
.
> > > There are 130 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.131-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on x86_64.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Kernel panic noticed on x86 while running kvm-unit-tests.
  - https://lkft.validation.linaro.org/scheduler/job/5280665#L1696

TESTNAME=3Demulator TIMEOUT=3D90s ACCEL=3D ./x86/run x86/emulator.flat -smp=
 1
[   62.210623] APIC base relocation is unsupported by KVM
[  104.645616] kvm: emulating exchange as write
[  104.656718] int3: 0000 [#1] SMP PTI
[  104.656719] CPU: 1 PID: 3785 Comm: qemu-system-x86 Not tainted
5.10.131-rc2 #1
[  104.656719] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  104.656720] RIP: 0010:xaddw_ax_dx+0x9/0x10
[  104.656720] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
cc cc
[  104.656720] RSP: 0018:ffffb823431c7d00 EFLAGS: 00000206
[  104.656721] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 00000000000=
00000
[  104.656721] RDX: 0000000076543210 RSI: ffffffff91a4d4d0 RDI: 00000000000=
00204
[  104.656722] RBP: ffffb823431c7d08 R08: ffff9a578cbaddf0 R09: 00000000000=
00002
[  104.656722] R10: ffff9a578cbaddf0 R11: 0000000000000000 R12: ffff9a578cb=
addf0
[  104.656722] R13: ffffffff92e08040 R14: 0000000000000000 R15: 00000000000=
00000
[  104.656723] FS:  00007f3f3f53c700(0000) GS:ffff9a58afa80000(0000)
knlGS:0000000000000000
[  104.656723] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  104.656723] CR2: 0000000000000000 CR3: 00000001068b6003 CR4: 00000000003=
726e0
[  104.656724] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  104.656724] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  104.656724] Call Trace:
[  104.656724]  ? fastop+0x5a/0xa0
[  104.656725]  x86_emulate_insn+0x7c9/0xf20
[  104.656725]  x86_emulate_instruction+0x2ec/0x7b0
[  104.656725]  ? __local_bh_enable_ip+0x48/0x80
[  104.656725]  complete_emulated_mmio+0x238/0x310
[  104.656726]  kvm_arch_vcpu_ioctl_run+0x1799/0x1980
[  104.656726]  ? vfs_writev+0xcb/0x140
[  104.656726]  kvm_vcpu_ioctl+0x243/0x5e0
[  104.656726]  ? selinux_file_ioctl+0xae/0x140
[  104.656727]  ? selinux_file_ioctl+0xae/0x140
[  104.656727]  __x64_sys_ioctl+0x92/0xd0
[  104.656727]  do_syscall_64+0x35/0x50
[  104.656727]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[  104.656728] RIP: 0033:0x7f3f40ec68f7
[  104.656728] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
01 48
[  104.656729] RSP: 002b:00007f3f3f53ba28 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  104.656729] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f3f40e=
c68f7
[  104.656729] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000=
0000f
[  104.656730] RBP: 00005624bc6bdaa0 R08: 00005624ba47c450 R09: 00000000fff=
fffff
[  104.656730] R10: 00000000000ff000 R11: 0000000000000246 R12: 00000000000=
00000
[  104.656730] R13: 00007f3f431f6000 R14: 0000000000000006 R15: 00005624bc6=
bdaa0
[  104.656731] Modules linked in: x86_pkg_temp_thermal
[  104.900206] ---[ end trace 51088e5987576a23 ]---
[  104.900206] RIP: 0010:xaddw_ax_dx+0x9/0x10
[  104.900207] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
cc cc
[  104.900207] RSP: 0018:ffffb823431c7d00 EFLAGS: 00000206
[  104.900207] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 00000000000=
00000
[  104.900208] RDX: 0000000076543210 RSI: ffffffff91a4d4d0 RDI: 00000000000=
00204
[  104.900208] RBP: ffffb823431c7d08 R08: ffff9a578cbaddf0 R09: 00000000000=
00002
[  104.900208] R10: ffff9a578cbaddf0 R11: 0000000000000000 R12: ffff9a578cb=
addf0
[  104.900209] R13: ffffffff92e08040 R14: 0000000000000000 R15: 00000000000=
00000
[  104.900209] FS:  00007f3f3f53c700(0000) GS:ffff9a58afa80000(0000)
knlGS:0000000000000000
[  104.900209] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  104.900210] CR2: 0000000000000000 CR3: 00000001068b6003 CR4: 00000000003=
726e0
[  104.900210] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  104.900210] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  104.900211] Kernel panic - not syncing: Fatal exception in interrupt
[  104.900250] Kernel Offset: 0x10a00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)


--
Linaro LKFT
https://lkft.linaro.org
