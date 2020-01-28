Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B5914B0E6
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 09:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgA1Iev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 03:34:51 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43667 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgA1Iev (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 03:34:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so13746875ljm.10
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 00:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=xvGB2v6CHXoUt14se+C5rBjRHFXzeXIrIKsbnYhW42k=;
        b=VmfEviRqV316qMRoN1mznVasLL3iApmDd3AXC8j78nAxBHZ3cd1Y/lWKGaoxClFuvR
         dLKdxJDq5VH6sZWbJ5LyGK5PI62T7tuT2S9NFBIxVltNq8L1zmKs5Jb0z1SLQ3K6eA7o
         lOHOWLmdZyD0lIY8zX1K/PKyDlx/mKg9K2qPF2fSeoksIyM0G42W4qjvCp1rEPvlcct+
         aOHFsmd7ZUsIVClVSv8dHcqo2uUrQnSILcUqwgE9PIZgw63dc7LYkmvVOYLppqNBvE/C
         Ir5h3eiargf8lqjeFtuDbqvdVHV1F31nyT4l4xsl4mnAsUP987nGy0ER44M7dpnykIwb
         BSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=xvGB2v6CHXoUt14se+C5rBjRHFXzeXIrIKsbnYhW42k=;
        b=hiyQOBBE2EFvEBBhZEI70OrJxDpzWdQvmsjI/JjiRfoshphADsteecPUGOJJF5wauD
         AFhqpHCwR+Rl0y7/VK7XKSKb4iU0cQC2bseNNnaQbki3NqTugYBXKwUtf+97g12C0TbQ
         L0VyBLa9nPIaKHL8+16Xg7srV68cI55PoC96MJVvL/K35ms/440BY9hh8rgq7InAWokD
         HW6KGjp7jlwII+WiX5d8wMt5EA7dHpdrFKSAZPKRXkR5QU6gO/b8RzPc7nXRs3C2vA4L
         95Evaj0w3kAw220gb8hIZLZokVrJqonfnnWtsGygvqMvArGCOnKIyt50KplKXktPTI26
         7PYw==
X-Gm-Message-State: APjAAAWVK51gTBWIFnJ7xBzWFwBD+RATTpwyuegIJkcJAVbunze8fq3U
        l3yPZE4fCwIXo5FFp+H3byRTcbwZukVsSQ==
X-Google-Smtp-Source: APXvYqz62+VE5ef8ilu6bwHrmjV4xqTlP5nr8gM3Frkz6n2L0NABLLw3EBnZqowfSbu4GM5srbXSKQ==
X-Received: by 2002:a2e:b4ef:: with SMTP id s15mr13289335ljm.20.1580200487678;
        Tue, 28 Jan 2020 00:34:47 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id x29sm11635664lfg.45.2020.01.28.00.34.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 00:34:47 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, lukas.bulwahn@gmail.com,
        syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com,
        <stable-commits@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net-sysfs: Fix reference count leak" has been added to the 4.4-stable tree
References: <15801383121217@kroah.com>
Date:   Tue, 28 Jan 2020 10:34:46 +0200
In-Reply-To: <15801383121217@kroah.com> (gregkh@linuxfoundation.org's message
        of "Mon, 27 Jan 2020 16:18:32 +0100")
Message-ID: <878sls2d3t.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<gregkh@linuxfoundation.org> writes:

> This is a note to let you know that I've just added the patch titled
>
>     net-sysfs: Fix reference count leak
>
> to the 4.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>
> The filename of the patch is:
>      net-sysfs-fix-reference-count-leak.patch
> and it can be found in the queue-4.4 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

This patch shouldn't be taken into 4.4 or 4.9 stable branches. Memory
leak it's fixing doesn't exist in 4.4 or 4.9. It's introduced by these two
patches which are not merged into 4.4 or 4.9 branches:

commit e331c9066901dfe40bea4647521b86e9fb9901bb
Author: YueHaibing <yuehaibing@huawei.com>
Date:   Tue Mar 19 10:16:53 2019 +0800

    net-sysfs: call dev_hold if kobject_init_and_add success
=20=20=20=20
    [ Upstream commit a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e ]
=20=20=20=20
    In netdev_queue_add_kobject and rx_queue_add_kobject,
    if sysfs_create_group failed, kobject_put will call
    netdev_queue_release to decrease dev refcont, however
    dev_hold has not be called. So we will see this while
    unregistering dev:
=20=20=20=20
    unregister_netdevice: waiting for bcsh0 to become free. Usage count =3D=
 -1
=20=20=20=20
    Reported-by: Hulk Robot <hulkci@huawei.com>
    Fixes: d0d668371679 ("net: don't decrement kobj reference count on init=
 fail
ure")
    Signed-off-by: YueHaibing <yuehaibing@huawei.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d0d6683716791b2a2761a1bb025c613eb73da6c3
Author: stephen hemminger <stephen@networkplumber.org>
Date:   Fri Aug 18 13:46:19 2017 -0700

    net: don't decrement kobj reference count on init failure
=20=20=20=20
    If kobject_init_and_add failed, then the failure path would
    decrement the reference count of the queue kobject whose reference
    count was already zero.
=20=20=20=20
    Fixes: 114cf5802165 ("bql: Byte queue limits")
    Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

>
>
> From foo@baz Mon 27 Jan 2020 04:14:17 PM CET
> From: Jouni Hogander <jouni.hogander@unikie.com>
> Date: Mon, 20 Jan 2020 09:51:03 +0200
> Subject: net-sysfs: Fix reference count leak
>
> From: Jouni Hogander <jouni.hogander@unikie.com>
>
> [ Upstream commit cb626bf566eb4433318d35681286c494f04fedcc ]
>
> Netdev_register_kobject is calling device_initialize. In case of error
> reference taken by device_initialize is not given up.
>
> Drivers are supposed to call free_netdev in case of error. In non-error
> case the last reference is given up there and device release sequence
> is triggered. In error case this reference is kept and the release
> sequence is never started.
>
> Fix this by setting reg_state as NETREG_UNREGISTERED if registering
> fails.
>
> This is the rootcause for couple of memory leaks reported by Syzkaller:
>
> BUG: memory leak unreferenced object 0xffff8880675ca008 (size 256):
>   comm "netdev_register", pid 281, jiffies 4294696663 (age 6.808s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>   backtrace:
>     [<0000000058ca4711>] kmem_cache_alloc_trace+0x167/0x280
>     [<000000002340019b>] device_add+0x882/0x1750
>     [<000000001d588c3a>] netdev_register_kobject+0x128/0x380
>     [<0000000011ef5535>] register_netdevice+0xa1b/0xf00
>     [<000000007fcf1c99>] __tun_chr_ioctl+0x20d5/0x3dd0
>     [<000000006a5b7b2b>] tun_chr_ioctl+0x2f/0x40
>     [<00000000f30f834a>] do_vfs_ioctl+0x1c7/0x1510
>     [<00000000fba062ea>] ksys_ioctl+0x99/0xb0
>     [<00000000b1c1b8d2>] __x64_sys_ioctl+0x78/0xb0
>     [<00000000984cabb9>] do_syscall_64+0x16f/0x580
>     [<000000000bde033d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<00000000e6ca2d9f>] 0xffffffffffffffff
>
> BUG: memory leak
> unreferenced object 0xffff8880668ba588 (size 8):
>   comm "kobject_set_nam", pid 286, jiffies 4294725297 (age 9.871s)
>   hex dump (first 8 bytes):
>     6e 72 30 00 cc be df 2b                          nr0....+
>   backtrace:
>     [<00000000a322332a>] __kmalloc_track_caller+0x16e/0x290
>     [<00000000236fd26b>] kstrdup+0x3e/0x70
>     [<00000000dd4a2815>] kstrdup_const+0x3e/0x50
>     [<0000000049a377fc>] kvasprintf_const+0x10e/0x160
>     [<00000000627fc711>] kobject_set_name_vargs+0x5b/0x140
>     [<0000000019eeab06>] dev_set_name+0xc0/0xf0
>     [<0000000069cb12bc>] netdev_register_kobject+0xc8/0x320
>     [<00000000f2e83732>] register_netdevice+0xa1b/0xf00
>     [<000000009e1f57cc>] __tun_chr_ioctl+0x20d5/0x3dd0
>     [<000000009c560784>] tun_chr_ioctl+0x2f/0x40
>     [<000000000d759e02>] do_vfs_ioctl+0x1c7/0x1510
>     [<00000000351d7c31>] ksys_ioctl+0x99/0xb0
>     [<000000008390040a>] __x64_sys_ioctl+0x78/0xb0
>     [<0000000052d196b7>] do_syscall_64+0x16f/0x580
>     [<0000000019af9236>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<00000000bc384531>] 0xffffffffffffffff
>
> v3 -> v4:
>   Set reg_state to NETREG_UNREGISTERED if registering fails
>
> v2 -> v3:
> * Replaced BUG_ON with WARN_ON in free_netdev and netdev_release
>
> v1 -> v2:
> * Relying on driver calling free_netdev rather than calling
>   put_device directly in error path
>
> Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
> Cc: David Miller <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/core/dev.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6806,8 +6806,10 @@ int register_netdevice(struct net_device
>  		goto err_uninit;
>=20=20
>  	ret =3D netdev_register_kobject(dev);
> -	if (ret)
> +	if (ret) {
> +		dev->reg_state =3D NETREG_UNREGISTERED;
>  		goto err_uninit;
> +	}
>  	dev->reg_state =3D NETREG_REGISTERED;
>=20=20
>  	__netdev_update_features(dev);
>
>
> Patches currently in stable-queue which might be from jouni.hogander@unik=
ie.com are
>
> queue-4.4/net-sysfs-fix-reference-count-leak.patch

BR,

Jouni H=C3=B6gander
