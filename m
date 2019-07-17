Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DC96C242
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 22:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfGQUm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 16:42:29 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37329 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbfGQUm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 16:42:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7E6C13AA;
        Wed, 17 Jul 2019 16:42:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 17 Jul 2019 16:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=t
        MvzxsLxKx/Wuka8VMZJB4FbDzq0r3OPlqLKujKMeEM=; b=WXUNSFtTlLgAizUxR
        2y/Ar7USRDHM7tQ3I/rgm15RizvV3QNPTyd4wsRvFHQ2zUU+gbTcMd7wUOD2vGEo
        zttiqArSd2NBktHY1rcMA3RE6ItQH0wbruYfbjRdjY7E8SRFOoWzTFlAllIZ2mmS
        TM5dROFRjkLhsU4BM/+g9M7bkveIQBWNiWd64WvsVRyro6lNyY6opy4QLwAaT8bS
        rAr182FExPOnGAXImLCbQK+3Pp6be8mYGY8i5Ti1RYMrWTn61Ikn05LQMsDDqLtJ
        z213cizqHyOCDhBZQ8SbS/eiNjhrWTb0lslZzk9uqUQTW63vwzcEKxZjyW7XvDIA
        4OxJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=tMvzxsLxKx/Wuka8VMZJB4FbDzq0r3OPlqLKujKMe
        EM=; b=HhelpdlFQifxnDZ7QmB3C+zxNmKi+Lv7ADUS1SA1ZA2sTmAxRCI2VMv/J
        iN8m1zhxPy3h7U5MKfx452XK7IUeJCB+mssi/UpkPlIlSF4S6uxxV3n023NNQKQL
        ZysqCWg1ITNfadDuDqW+xXqXoOiE6AxNTwvIvGoNvD5Rzksab18yCnIzFZEAxK1m
        fC0UreOIfNikLeaifNcbkqtZXmSYthW9y4F9G/c38KUp3LuNyQw9rEkaQHxAWLyq
        WJlVfWPCvoPVpMGTLkSy4mNhYYedDL5N1Fz0uI72KzOjCz79BJBXFztk3Ivj0CRY
        OUN1uC4tEo/LEwWkd1WN9Sp/8Xncg==
X-ME-Sender: <xms:MogvXd_8pkTpHeh7iCwOqnL5wH0vl7ALwqbd73rYelXtGfArmZAcXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrieefgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjfgesth
    ekredttderjeenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtgho
    mheqnecukfhppeduudefrdduheejrddvudejrdehtdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:MogvXRbHWEsDh6bKZ6PhmB_B_jrsSCkocW1nLc29BU9fww73Ajsffg>
    <xmx:MogvXWoOa9ZMCilGowkrVWYS4XtDGH8qtUi3s8cZo5a2owvATQQEog>
    <xmx:MogvXdSijqdBgN3-iuI42sVuXaFEIb0P2OUgVjFi7ujiCACJAFJJ5g>
    <xmx:M4gvXSB7crntY_RPLu-qsYVnQ7QGg4CvOcd0GeQofF_wUrNRQkgckA>
Received: from localhost (unknown [113.157.217.50])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D3738005A;
        Wed, 17 Jul 2019 16:42:25 -0400 (EDT)
Date:   Thu, 18 Jul 2019 05:42:23 +0900
From:   Greg KH <greg@kroah.com>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@google.com, groeck@chromium.org,
        pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH v4.4.y] KVM: x86: protect KVM_CREATE_PIT/KVM_CREATE_PIT2
 with kvm->lock
Message-ID: <20190717204223.GA11555@kroah.com>
References: <20190717203501.240981-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190717203501.240981-1-zsm@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 01:35:01PM -0700, Zubin Mithra wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> commit 250715a6171a076748be8ab88b274e72f0cfb435 upstream.
> 
> The syzkaller folks reported a NULL pointer dereference that seems
> to be cause by a race between KVM_CREATE_IRQCHIP and KVM_CREATE_PIT2.
> The former takes kvm->lock (except when registering the devices,
> which needs kvm->slots_lock); the latter takes kvm->slots_lock only.
> Change KVM_CREATE_PIT2 to follow the same model as KVM_CREATE_IRQCHIP.
> 
> Testcase:
> 
>     #include <pthread.h>
>     #include <linux/kvm.h>
>     #include <fcntl.h>
>     #include <sys/ioctl.h>
>     #include <stdint.h>
>     #include <string.h>
>     #include <stdlib.h>
>     #include <sys/syscall.h>
>     #include <unistd.h>
> 
>     long r[23];
> 
>     void* thr1(void* arg)
>     {
>         struct kvm_pit_config pitcfg = { .flags = 4 };
>         switch ((long)arg) {
>         case 0: r[2]  = open("/dev/kvm", O_RDONLY|O_ASYNC);    break;
>         case 1: r[3]  = ioctl(r[2], KVM_CREATE_VM, 0);         break;
>         case 2: r[4]  = ioctl(r[3], KVM_CREATE_IRQCHIP, 0);    break;
>         case 3: r[22] = ioctl(r[3], KVM_CREATE_PIT2, &pitcfg); break;
>         }
>         return 0;
>     }
> 
>     int main(int argc, char **argv)
>     {
>         long i;
>         pthread_t th[4];
> 
>         memset(r, -1, sizeof(r));
>         for (i = 0; i < 4; i++) {
>             pthread_create(&th[i], 0, thr, (void*)i);
>             if (argc > 1 && rand()%2) usleep(rand()%1000);
>         }
>         usleep(20000);
>         return 0;
>     }
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Zubin Mithra <zsm@google.com>
> ---
> Notes:
> * Syzkaller triggered a GPF in kvm_pic_clear_all with the following stacktrace
> when fuzzing a 4.4 kernel.
> Call Trace:
>  [<ffffffff81270a07>] lock_acquire+0x294/0x2f3 kernel/locking/lockdep.c:3592
>  [<ffffffff832bd6f7>] __raw_spin_lock include/linux/spinlock_api_smp.h:144 [inline]
>  [<ffffffff832bd6f7>] _raw_spin_lock+0x2f/0x3e kernel/locking/spinlock.c:151
>  [<ffffffff81084dce>] spin_lock include/linux/spinlock.h:302 [inline]
>  [<ffffffff81084dce>] pic_lock arch/x86/kvm/i8259.c:45 [inline]
>  [<ffffffff81084dce>] kvm_pic_clear_all+0x33/0x5b arch/x86/kvm/i8259.c:213
>  [<ffffffff810968fb>] kvm_free_irq_source_id+0xc8/0xde arch/x86/kvm/irq_comm.c:197
>  [<ffffffff810926bb>] kvm_create_pit+0x24e/0x5c5 arch/x86/kvm/i8254.c:713
>  [<ffffffff8103aabf>] kvm_arch_vm_ioctl+0x592/0x17db arch/x86/kvm/x86.c:3858
>  [<ffffffff81013cb4>] kvm_vm_ioctl+0xb7d/0xbfa arch/x86/kvm/../../../virt/kvm/kvm_main.c:2959
>  [<ffffffff8149dc2e>] vfs_ioctl fs/ioctl.c:43 [inline]
>  [<ffffffff8149dc2e>] do_vfs_ioctl+0xcb0/0xd0f fs/ioctl.c:630
>  [<ffffffff8149dcfe>] SYSC_ioctl fs/ioctl.c:645 [inline]
>  [<ffffffff8149dcfe>] SyS_ioctl+0x71/0xad fs/ioctl.c:636
>  [<ffffffff832be2fa>] entry_SYSCALL_64_fastpath+0x31/0xb3
> 
> * This patch resolves a conflict that arises in arch/x86/kvm/i8254.c:kvm_create_pit()
> 
> * This commit is present in linux-4.9.y
> 
> * Tests run: Chrome OS tryjobs, Syzkaller reproducer

Now queued up, thanks.

greg k-h
