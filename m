Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238DA2C73D9
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbgK1Vtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733054AbgK1TFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 14:05:15 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA36C0617A7;
        Fri, 27 Nov 2020 21:42:02 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id a19so6394918ilm.3;
        Fri, 27 Nov 2020 21:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Qxtp28coeWS4b5rgC0mMS+gMgp8Rl0hEEaw+rpx/Ns=;
        b=n5e2LltHRMTQAqMmhvrgLau7U720jXp/YutqyQ2bTj5pSZVJ1UrQHOoRJbdk18gyym
         cHEiKYE/LSL2/32ZS1g/dSadvb3AISMd5oTPmoHWszd0+mVNpE5Z7rVD7jZNIqrjJaAG
         t0cHWKjnbcsbkR9yV/bKZvxWxJBpgteFA8V3SzL0WYdU5qZGmyzn1NExz8VcpsjGchKh
         BUli2WyUKUZ+aSqIU4f5Di1XVh8BcOSTU40KuEkT22ejCta74XmS1nvncRIubKNxegq1
         9wDw8ia4FbsnJ48DZ/xL7ToO5uC0MQEBwMnueW1iguu4JXKRUuqLOEaBmqf0ZqXoIUmw
         OWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Qxtp28coeWS4b5rgC0mMS+gMgp8Rl0hEEaw+rpx/Ns=;
        b=VqPAU6/obRgl45nAG90M8Zhyp8lZ8giLekr1JBlLohstiIcBkby9LcIS8dsbP0URDc
         V2VoMH7dtFpE3uz51BG5OfVEPJObvHGHf4zq2i5XFety8OixoKtr2XkwQr4cyPiazTWq
         lIMoS3BTx8KLXt5YtEswWNOPksfKv9b/EUFBNsxOmSjHuUuf5+vtBWPbTw337xDm8JsM
         odx+CfR0eykiAtjAjtAsEwF0lV599KFtdkieppQ5Q4XcB6LIb0MbwJPoENlm3GJx8TKT
         ED0fDr3E20VFwWgNqxA3ZUEf+LGXbVYvzdN4/M3IAW5wbyZMvFCd74316dRdUiwKfRvs
         L/sg==
X-Gm-Message-State: AOAM531UaMrxapXtfn0tCLNWOvWH6hWKSIXY2Kkp0MxdS7e24CKHb16f
        v3f5yMa/FDVdHRrY0FHqdm8=
X-Google-Smtp-Source: ABdhPJyShpcvoMZPt32zH2yzmZsaK8lLL2r1aFJEKJgpmDqRZMyRKO6ZrVRSl5ZKIUKTugfy/Q2TQw==
X-Received: by 2002:a92:5b08:: with SMTP id p8mr865045ilb.39.1606542121849;
        Fri, 27 Nov 2020 21:42:01 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id m2sm6298562ilj.24.2020.11.27.21.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 21:42:00 -0800 (PST)
Date:   Fri, 27 Nov 2020 22:41:58 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        x86@vger.kernel.org
Subject: Re: [stable 4.9] PANIC: double fault, error_code: 0x0 - clang boot
 failed on x86_64
Message-ID: <20201128054158.GA3146127@ubuntu-m3-large-x86>
References: <CA+G9fYt0qHxUty2qt7_9_YTOZamdtknhddbsi5gc3PDy0PvZ5A@mail.gmail.com>
 <X79NpRIqAHEp2Lym@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X79NpRIqAHEp2Lym@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 07:39:33AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Nov 26, 2020 at 10:14:43AM +0530, Naresh Kamboju wrote:
> > Linaro recently started building and testing with stable branches with clang.
> > Stable 4.9 branch kernel built with clang 10 boot crashed on x86 and qemu_x86.
> > We do not have base line results to compare with.
> > 
> > steps to build and boot:
> > # build kernel with tuxmake
> > # sudo pip3 install -U tuxmake
> > # tuxmake --runtime docker --target-arch x86 --toolchain clang-10
> > --kconfig defconfig --kconfig-add
> > https://builds.tuxbuild.com/1kgtX7QEDmhvj6OfbZBdlGaEple/config
> > # boot qemu_x86_64
> > # /usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic -net
> > nic,model=virtio,macaddr=DE:AD:BE:EF:66:14 -net tap -m 1024 -monitor
> > none -kernel kernel/bzImage --append "root=/dev/sda  rootwait
> > console=ttyS0,115200" -hda
> > rootfs/rpb-console-image-lkft-intel-corei7-64-20201022181159-3085.rootfs.ext4
> > -m 4096 -smp 4 -nographic
> > 
> > Crash log:
> > ---------------
> > [   14.121499] Freeing unused kernel memory: 1896K
> > [   14.126962] random: fast init done
> > [   14.206005] PANIC: double fault, error_code: 0x0
> > [   14.210633] CPU: 1 PID: 1 Comm: systemd Not tainted 4.9.246-rc1 #2
> > [   14.216809] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> > 2.2 05/23/2018
> > [   14.224196] task: ffff88026e2c0000 task.stack: ffffc90000020000
> > [   14.230105] RIP: 0010:[<ffffffff8117ec2b>]  [<ffffffff8117ec2b>]
> > proc_dostring+0x13b/0x1e0
> > [   14.238374] RSP: 0018:000000000000000c  EFLAGS: 00010297
> > [   14.243676] RAX: 00005638939fb850 RBX: 000000000000000c RCX: 00005638939fb850
> > [   14.250799] RDX: 000000000000000c RSI: 0000000000000000 RDI: 000000000000007f
> > [   14.257925] RBP: ffffc90000023d98 R08: ffffc90000023ef8 R09: 00005638939fb850
> > [   14.265049] R10: 0000000000000000 R11: ffffffff8117f9e0 R12: ffffffff82479cf0
> > [   14.272171] R13: ffffc90000023ef8 R14: ffffc90000023dd8 R15: 000000000000007f
> > [   14.279298] FS:  00007f57fbce8840(0000) GS:ffff880277880000(0000)
> > knlGS:0000000000000000
> > [   14.287384] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   14.293120] CR2: fffffffffffffff8 CR3: 000000026d58a000 CR4: 0000000000360670
> > [   14.300243] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   14.307368] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [   14.314491] Stack:
> > [   14.316504] Call Trace:
> > [   14.318955] Code: c3 49 8b 10 31 f6 48 01 da 49 89 10 49 83 3e 00
> > 74 49 41 83 c7 ff 49 63 ff 4c 89 c9 0f 1f 40 00 48 39 fe 73 36 48 89
> > c8 48 89 dc <e8> b0 9d 3a 00 85 c0 0f 85 8c 00 00 00 84 d2 74 1f 80 fa
> > 0a 74
> > [   14.338906] Kernel panic - not syncing: Machine halted.
> > [   14.344123] CPU: 1 PID: 1 Comm: systemd Not tainted 4.9.246-rc1 #2
> > [   14.350291] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> > 2.2 05/23/2018
> > [   14.357677]  ffff880277888e80 ffffffff81518ae9 ffff880277888e98
> > ffffffff82971a10
> > [   14.365129]  000000000000000f 0000000000000000 0000000000000086
> > ffffffff820c5d57
> > [   14.372584]  ffff880277888f08 ffffffff81175736 0000003000000008
> > ffff880277888f18
> > [   14.380038] Call Trace:
> > [   14.382481]  <#DF> [   14.384406]  [<ffffffff81518ae9>] dump_stack+0xa9/0x100
> > [   14.389641]  [<ffffffff81175736>] panic+0xe6/0x2a0
> > [   14.394432]  [<ffffffff810c9911>] df_debug+0x31/0x40
> > [   14.399389]  [<ffffffff81096312>] do_double_fault+0x102/0x140
> > [   14.405128]  [<ffffffff81ccc987>] double_fault+0x27/0x30
> > [   14.410440]  [<ffffffff8117f9e0>] ? proc_put_long+0xc0/0xc0
> > [   14.416004]  [<ffffffff8117ec2b>] ? proc_dostring+0x13b/0x1e0
> > [   14.421739]  <EOE> [   14.423703] Kernel Offset: disabled
> > [   14.427209] ---[ end Kernel panic - not syncing: Machine halted.
> > 
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > 
> > full test log,
> > https://lkft.validation.linaro.org/scheduler/job/1978901#L916
> > https://lkft.validation.linaro.org/scheduler/job/1980839#L578
> 
> Is the mainline 4.9 tree supposed to work with clang?  I didn't think
> that upstream effort started until 4.19 or so.
> 
> thanks,
> 
> greg k-h
> 

We have been building and boot testing the mainline 4.9 tree for quite
some time. This issue appears to be exposed by the rootfs that Linaro is
using for testing; ours is incredibly simple (prints the version string
then shuts down, there is no systemd or complex init).

Some initial notes, I am not sure how much time I will have to look at
this in the near future:

1. This does not happen with the same configuration file on
   linux-4.14.y.

2. This happens with the latest version of clang on linux-4.9.y.

3. Bisecting v4.9 to v4.14 will be rather difficult because clang
   support was backported to 4.9 somewhere in the 130s.

There could be a clang backport missing or a bug was unintentionally
fixed somewhere else.

Cheers,
Nathan
