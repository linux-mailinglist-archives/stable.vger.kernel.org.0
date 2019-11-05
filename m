Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE5EF70F
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 09:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbfKEIQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 03:16:01 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43323 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387639AbfKEIQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 03:16:01 -0500
Received: by mail-lj1-f196.google.com with SMTP id y23so9802865ljh.10
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 00:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9PE5ouoWToMS+mwA3EDpcIsd/9al4QElUM1Ce2gyEPM=;
        b=cU4KindEikOsdXWsu0bmnLwbsZtqhuMGHCv55ydbFm4wMUlWeCey6OdGYPxNpCSaiK
         CLDBS2vz7YK39g0auSwvXg6TysJ4JEWtq2/B5BbTm7X3KdCavbetj/LWT8d0/0fGqzvQ
         MiA8A7BxLuAFqJR5t2JGBOk6+NpQXhXOwQho3Z3HICX9YA6xFVX6tGrQTnTEcBIYm3y7
         Cwod9ib/sa/chOUinc/Cs0fvi++pzOP5LIYubrlOOMCtwBJL0kLVLQBhJHp+912uYAdY
         feINJwfxE9UaMSHG4pkA85qRYb3jXlic7KUqLw0peUE5Hz5mkUhC1pTLEbsOeYRc0osw
         SpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9PE5ouoWToMS+mwA3EDpcIsd/9al4QElUM1Ce2gyEPM=;
        b=DYCIhhSpAVGqigsL09GaYvKGEab5rCIatNTaqdnDG+AaVxs7Pf9/9viU/rn3ZQusPO
         eROVRNGFDXgk0Z+QhKlzyalUdNn8i5I6To2jSTV4yoOvlSLTQmNeXYMUuKr+90zEJ015
         83UISqUMJ+WyGWWu+Cl6VpwbAkDxOhnaEKPYwb6M4fjLx9d0NHVXj31Z4q+9HZDd+BLW
         BL5MziXKfA26rPmDcv7Iz10AonHAVPEuJdxX5+ssT0RDTtwP40rHXXH/vt7+2Teo0nba
         Ft2NVZTsR/4gNX4+X/r+Gu3k9Qc0OfVnl8CkCP53hmKgylKcfc0YX9J94mFIJOolHFwg
         ip+A==
X-Gm-Message-State: APjAAAW4gmvVIF0Gdt+GoeJp3WwXS4UZHuF/dkmaJs096hCJVNaii8fw
        0chc3HnNAhCLlEPfcpq/ZI8BojT3ZnBOixbyaDJjxApqggs=
X-Google-Smtp-Source: APXvYqyIG4u/WuPuzsb3pMykd4O1ysiCBG3U4gHZ9RHF0gAB1XQyhK+Xdbw0qtV+ncib7AE+M5K39okMij99wfynKis=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr1818566ljq.20.1572941756829;
 Tue, 05 Nov 2019 00:15:56 -0800 (PST)
MIME-Version: 1.0
References: <cki.A892DA5512.ND6HCOM1TZ@redhat.com> <20191105063743.GA2581953@kroah.com>
In-Reply-To: <20191105063743.GA2581953@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Nov 2019 13:45:45 +0530
Message-ID: <CA+G9fYuYhp8Z0eJzEcdrH3ujj+VvH4x1LR0B=2qzLFD43Hn04w@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBTdGFibGUgcXVldWU6IHF1ZXVlLTUuMw==?=
To:     Greg KH <greg@kroah.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Nov 2019 at 12:17, Greg KH <greg@kroah.com> wrote:
>
> On Tue, Nov 05, 2019 at 01:14:35AM -0000, CKI Project wrote:
> >
> > Hello,
> >
> > We ran automated tests on a patchset that was proposed for merging into=
 this
> > kernel tree. The patches were applied to:

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 95180e47e77a - Linux 5.3.8


We grabbed the 026bccdee83f commit of the stable queue repository.

We then merged the patchset with `git am`:
<trim>
  blackhole_netdev-fix-syzkaller-reported-issue.patch
This patch merged in this process testing. Is this the one caused this
boot failure ?

> >
> > The results of these automated tests are provided below.
> >
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> >     x86_64:
> >     ppc64le:
> >     aarch64:
> >      =E2=9D=8C Boot test
>
> Looks like something wrong on your end?

Looks like this is yesterday's report.
The reason for boot failure is kernel warning and Kernel panic.
---
[    3.345163] ------------[ cut here ]------------
[    3.349762] remove_proc_entry: removing non-empty directory
'net/dev_snmp6', leaking at least 'lo'
[    3.358707] WARNING: CPU: 1 PID: 1 at fs/proc/generic.c:682
remove_proc_entry+0x178/0x1b0
[    3.366846] Modules linked in:
[    3.369887] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.3.8-db0655e.cki =
#1
[    3.376727] Hardware name: AmpereComputing(R) Mustang/Mustang, BIOS
0ACDY027 12/12/2018
[    3.384693] pstate: 60400005 (nZCv daif +PAN -UAO)
[    3.389460] pc : remove_proc_entry+0x178/0x1b0
[    3.393880] lr : remove_proc_entry+0x178/0x1b0
[    3.398300] sp : ffff000010073c00
[    3.401596] x29: ffff000010073c00 x28: 0000000000000000
[    3.406882] x27: 0000000000000000 x26: ffff0000118d8d98
[    3.412166] x25: ffff0000118da6d0 x24: ffff000010073cf0
[    3.417451] x23: ffff0000118cb4d0 x22: ffff8003f9034480
[    3.422735] x21: ffff8003f903452b x20: ffff8003e378fe2b
[    3.428019] x19: ffff8003e378fd80 x18: 0000000000000000
[    3.433303] x17: 0000000000000000 x16: 0000000000000000
[    3.438587] x15: 0000000000000010 x14: 0720072007200720
[    3.443871] x13: 0720072007200720 x12: 0720072007200720
[    3.449157] x11: 0720072007200720 x10: 0720072007200720
[    3.454441] x9 : 0720072007200720 x8 : 0000000000000108
[    3.459725] x7 : 0720072007200720 x6 : ffff8003fa42ef00
[    3.465010] x5 : ffff00001060e730 x4 : 0000000000000000
[    3.470295] x3 : 0000000000000000 x2 : 00000000ffffffff
[    3.475579] x1 : ffff000011756020 x0 : 0000000000000056
[    3.480864] Call trace:
[    3.483297]  remove_proc_entry+0x178/0x1b0
[    3.487374]  ipv6_proc_exit_net+0x38/0x58
[    3.491364]  ops_exit_list.isra.0+0x4c/0x80
[    3.495526]  unregister_pernet_operations+0x10c/0x158
[    3.500551]  unregister_pernet_subsys+0x34/0x48
[    3.505059]  ipv6_misc_proc_exit+0x1c/0x28
[    3.509135]  inet6_init+0x2d0/0x368
[    3.512607]  do_one_initcall+0x3c/0x1f0
[    3.516423]  kernel_init_freeable+0x2c0/0x36c
[    3.520759]  kernel_init+0x18/0x110
[    3.524229]  ret_from_fork+0x10/0x18
[    3.527788] ---[ end trace ed38075058598339 ]---
---
[    8.988011] systemd-journald[306]: Received SIGTERM from PID 1 (systemd)=
.
[    9.123622] printk: systemd: 20 output lines suppressed due to ratelimit=
ing
[   10.617369] SELinux:  policy capability network_peer_controls=3D1
[   10.623293] SELinux:  policy capability open_perms=3D1
[   10.628233] SELinux:  policy capability extended_socket_class=3D1
[   10.634127] SELinux:  policy capability always_check_network=3D0
[   10.639931] SELinux:  policy capability cgroup_seclabel=3D1
[   10.645306] SELinux:  policy capability nnp_nosuid_transition=3D1
[   10.723011] Unable to handle kernel paging request at virtual
address fffe00002225e9f8
[   10.730896] Mem abort info:
[   10.733680]   ESR =3D 0x96000044
[   10.736719]   Exception class =3D DABT (current EL), IL =3D 32 bits
[   10.742608]   SET =3D 0, FnV =3D 0
[   10.745650]   EA =3D 0, S1PTW =3D 0
[   10.748774] Data abort info:
[   10.751638]   ISV =3D 0, ISS =3D 0x00000044
[   10.755456]   CM =3D 0, WnR =3D 1
[   10.758407] [fffe00002225e9f8] address between user and kernel address r=
anges
[   10.765513] Internal error: Oops: 96000044 [#1] SMP
[   10.770367] Modules linked in: xfs libcrc32c sdhci_of_arasan
sdhci_pltfm i2c_xgene_slimpro sdhci gpio_dwapb cqhci xhci_plat_hcd
gpio_xgene_sb gpio_keys
[   10.783874] CPU: 4 PID: 1 Comm: systemd Tainted: G        W
5.3.8-db0655e.cki #1
[   10.791924] Hardware name: AmpereComputing(R) Mustang/Mustang, BIOS
0ACDY027 12/12/2018
[   10.799889] pstate: 00400005 (nzcv daif +PAN -UAO)
[   10.804662] pc : queued_spin_lock_slowpath+0x240/0x2d8
[   10.809778] lr : __fib6_clean_all+0xc8/0x100
[   10.814025] sp : ffff000010073be0
[   10.817321] x29: ffff000010073be0 x28: ffff8003e37db01c
[   10.822606] x27: 0000000000000000 x26: 0000000000000000
[   10.827892] x25: 0000000000000000 x24: 0000000000000002
[   10.833177] x23: 0000000000000000 x22: ffff000010b20938
[   10.838462] x21: ffff0000118cb5c0 x20: 00000000ffff8003
[   10.843747] x19: ffff8003e37db01c x18: 0000000000000000
[   10.849031] x17: 00000000ffff8003 x16: 00000000ffff8003
[   10.854316] x15: ffffffffffffffff x14: ffffffffffffff00
[   10.859601] x13: ffffffffffffffff x12: 0000000000000001
[   10.864886] x11: ffff000010f3f670 x10: 00000000000019b0
[   10.870171] x9 : ffff0000100739a0 x8 : ffff000010f4c988
[   10.875456] x7 : 0000000000000000 x6 : ffff8003fc273040
[   10.880740] x5 : 0000000000140000 x4 : ffff8003fc273040
[   10.886025] x3 : ffff000011312040 x2 : ffff000011312070
[   10.891310] x1 : ffff000011312070 x0 : ffff8003fc273048
[   10.896595] Call trace:
[   10.899029]  queued_spin_lock_slowpath+0x240/0x2d8
[   10.903796]  __fib6_clean_all+0xc8/0x100
[   10.907698]  fib6_flush_trees+0x38/0x48
[   10.911515]  security_load_policy+0x29c/0x5e8
[   10.915850]  sel_write_load+0x10c/0x200
[   10.919667]  __vfs_write+0x48/0x90
[   10.923050]  vfs_write+0xac/0x1b8
[   10.926347]  ksys_write+0x64/0xe0
[   10.929644]  __arm64_sys_write+0x24/0x30
[   10.933547]  el0_svc_common.constprop.0+0x74/0x168
[   10.938314]  el0_svc_handler+0x34/0x90
[   10.942044]  el0_svc+0x8/0xc
[   10.944913] Code: 910020c0 8b020062 f861d908 aa0203e1 (f8286826)
[   10.950983] ---[ end trace ed3807505859833b ]---
[   10.955577] Kernel panic - not syncing: Fatal exception in interrupt
[   10.961899] SMP: stopping secondary CPUs
[   10.965803] Kernel Offset: disabled
[   10.969273] CPU features: 0x0000,20802000
[   10.973262] Memory Limit: none
[   10.976302] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

ref:
https://artifacts.cki-project.org/pipelines/263687/logs/aarch64_host_1_cons=
ole.log
https://artifacts.cki-project.org/pipelines/263687/logs/x86_64_host_5_conso=
le.log
https://artifacts.cki-project.org/pipelines/263687/logs/ppc64le_host_1_cons=
ole.log

- Naresh
