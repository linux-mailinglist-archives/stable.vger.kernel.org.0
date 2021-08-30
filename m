Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E605A3FB931
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 17:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbhH3PoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 11:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbhH3PoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 11:44:04 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446C5C061575;
        Mon, 30 Aug 2021 08:43:10 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id l24so12024491qtj.4;
        Mon, 30 Aug 2021 08:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qfbtdb+OZHl1Y+ePywO/j6GEDa3WAf3Ch0sWKYBLjIs=;
        b=pYUKASFkCWIRVQ7+TYrFS1J8we9sD6tIIQOWnfbh9pTaRxEgu1LJZyveZqVeTgufLd
         YDpWc6pvCaSwJq5uBlkTfBjq+JSkyRMbQxXQcNM87KOdw05sIwCM/KgXWJ3D8DrOQ86B
         KgiaHbygL5nnhSRDZ6g48rTBKZ2YaOi9F6Lx0T8aSVDvrBRudv0HU5VRpHlq10fbt6YQ
         4TpgYmrM8frYaKkIdpDq5eM7JCmgVmAl62ToKkmQarxhd1LcnqN0PPoVaB8dAICuuapB
         xUf5KxBy/HaIguJqYIAGWs3uKpcYCxfNopg4+Pu8284/YlXrcTxGsUG5KfQ45KOOCDej
         MXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qfbtdb+OZHl1Y+ePywO/j6GEDa3WAf3Ch0sWKYBLjIs=;
        b=WgY54hItX90Dh19LpPqR9kqIr2nKfNIP8kWtfOj4+HstG34ZjERLJ0WsrtZkj0wYex
         JKRT2WIXvGznGW0W+HgDXgtENqxet5xMJZntwoNCrhXqXsNHmW0iop/FKtPe3ejS1EKL
         n3xXMhWHZpzLulMlSpG3fErpLuHQfRs/uAaLe4pcV+ot97t9SS073Iru+SxZ7I+V0vpf
         JJEN6Kxc6VCtcr6rJk6tkXEBvI8CcSr6H9VNviRrBw0FWZS6XQ3NV2tQC3i8FWwVUZVm
         CQSRxDv3QT6UoJ/gCXtuRUv9lxNUKMT5eZ2m2Edy5sGzIhrrXCyLb+aP872Mld7ifqNH
         XK9Q==
X-Gm-Message-State: AOAM531gE3oJOocE0Z9Q45/Bp3XEDq5XLLPbBk3fup0hY/MHMxLbTboH
        thTzRCqxwOuO+M7fH6ZiGClUg6zpU7U=
X-Google-Smtp-Source: ABdhPJzOaTYNlKUMMK6aDCdrmkUZGO7UsT2WbN8H4pCE1DEQP1ep5ZbNnTZ6bYeu2eopmwaVpWFUoQ==
X-Received: by 2002:a05:622a:c3:: with SMTP id p3mr21106858qtw.7.1630338189261;
        Mon, 30 Aug 2021 08:43:09 -0700 (PDT)
Received: from smtpclient.apple ([159.89.225.236])
        by smtp.gmail.com with ESMTPSA id v14sm11436552qkb.88.2021.08.30.08.43.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Aug 2021 08:43:08 -0700 (PDT)
From:   Yuri Lipnesh <yuri.lipnesh@gmail.com>
X-Google-Original-From: Yuri Lipnesh <Yuri.Lipnesh@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: System crash in netfilter  5.10.25
In-Reply-To: <5BABE543-DFBB-42C0-8CA8-74C80C5F4CC0@gmail.com>
Date:   Mon, 30 Aug 2021 11:43:07 -0400
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E6F18819-9148-4538-B58C-5189F8641E22@gmail.com>
References: <B37EABB8-355F-4A05-9BF3-1119D1E0470D@gmail.com>
 <20201130195857.GM2730@breakpoint.cc>
 <5BABE543-DFBB-42C0-8CA8-74C80C5F4CC0@gmail.com>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Florian,

I need assistance on this one. Our customer system 5.10.25-flatcar =
crashed with following trace

Aug 26 10:26:32.686733 amc-k8sdevsl01-worker-lx13 kernel: ------------[ =
cut here ]------------
Aug 26 10:26:32.686855 amc-k8sdevsl01-worker-lx13 kernel: refcount_t: =
underflow; use-after-free.
Aug 26 10:26:32.686877 amc-k8sdevsl01-worker-lx13 kernel: WARNING: CPU: =
4 PID: 2422635 at lib/refcount.c:28 refcount_warn_saturat>
Aug 26 10:26:32.686930 amc-k8sdevsl01-worker-lx13 kernel: Modules linked =
in: binfmt_misc nfnetlink_queue xt_NFQUEUE xt_multiport >
Aug 26 10:26:32.689906 amc-k8sdevsl01-worker-lx13 kernel:  =
dm_region_hash dm_log dm_mod
Aug 26 10:26:32.690398 amc-k8sdevsl01-worker-lx13 kernel: CPU: 4 PID: =
2422635 Comm: worker-1 Not tainted 5.10.25-flatcar #1
Aug 26 10:26:32.690526 amc-k8sdevsl01-worker-lx13 kernel: Hardware name: =
VMware, Inc. VMware Virtual Platform/440BX Desktop Refer>
Aug 26 10:26:32.691653 amc-k8sdevsl01-worker-lx13 kernel: RIP: =
0010:refcount_warn_saturate+0xa6/0xf0
Aug 26 10:26:32.691720 amc-k8sdevsl01-worker-lx13 kernel: Code: 05 3c 1d =
40 01 01 e8 81 46 38 00 0f 0b c3 80 3d 2a 1d 40 01 00 75>
Aug 26 10:26:32.691747 amc-k8sdevsl01-worker-lx13 kernel: RSP: =
0018:ffffa3a0c3627938 EFLAGS: 00010282
Aug 26 10:26:32.692385 amc-k8sdevsl01-worker-lx13 kernel: RAX: =
0000000000000000 RBX: ffff8c011b14fa00 RCX: 0000000000000027
Aug 26 10:26:32.692422 amc-k8sdevsl01-worker-lx13 kernel: RDX: =
0000000000000027 RSI: 00000000ffffdfff RDI: ffff8c045d918b08
Aug 26 10:26:32.692446 amc-k8sdevsl01-worker-lx13 kernel: RBP: =
ffff8c011b14fa00 R08: ffff8c045d918b00 R09: ffffa3a0c3627750
Aug 26 10:26:32.693526 amc-k8sdevsl01-worker-lx13 kernel: R10: =
0000000000000001 R11: 0000000000000001 R12: ffff8c011b14fa30
Aug 26 10:26:32.693584 amc-k8sdevsl01-worker-lx13 kernel: R13: =
0000000000000002 R14: ffff8bfda3b43180 R15: ffff8c00cddb3a00
Aug 26 10:26:32.693615 amc-k8sdevsl01-worker-lx13 kernel: FS:  =
00007ff7a2331b38(0000) GS:ffff8c045d900000(0000) knlGS:00000000000>
Aug 26 10:26:32.693649 amc-k8sdevsl01-worker-lx13 kernel: CS:  0010 DS: =
0000 ES: 0000 CR0: 0000000080050033
Aug 26 10:26:32.694304 amc-k8sdevsl01-worker-lx13 kernel: CR2: =
00007ff79ac17a28 CR3: 00000001ee34e003 CR4: 00000000007706e0
Aug 26 10:26:32.694334 amc-k8sdevsl01-worker-lx13 kernel: PKRU: 55555554
Aug 26 10:26:32.694351 amc-k8sdevsl01-worker-lx13 kernel: Call Trace:
Aug 26 10:26:32.694370 amc-k8sdevsl01-worker-lx13 kernel:  =
nf_queue_entry_release_refs+0x82/0xa0
Aug 26 10:26:32.695381 amc-k8sdevsl01-worker-lx13 kernel:  =
nf_reinject+0x6f/0x1a0
Aug 26 10:26:32.695404 amc-k8sdevsl01-worker-lx13 kernel:  =
0xffffffffc0857980
Aug 26 10:26:32.695425 amc-k8sdevsl01-worker-lx13 kernel:  =
nfnetlink_unicast+0x1f1/0x420 [nfnetlink]
Aug 26 10:26:32.695441 amc-k8sdevsl01-worker-lx13 kernel:  ? =
cred_has_capability+0x7f/0x120
Aug 26 10:26:32.695457 amc-k8sdevsl01-worker-lx13 kernel:  ? =
nfnetlink_unicast+0xa0/0x420 [nfnetlink]
Aug 26 10:26:32.695475 amc-k8sdevsl01-worker-lx13 kernel:  =
netlink_rcv_skb+0x50/0x100
Aug 26 10:26:32.696440 amc-k8sdevsl01-worker-lx13 kernel:  =
nfnetlink_subsys_register+0x789/0x869 [nfnetlink]
Aug 26 10:26:32.696465 amc-k8sdevsl01-worker-lx13 kernel:  =
netlink_unicast+0x191/0x230
Aug 26 10:26:32.696492 amc-k8sdevsl01-worker-lx13 kernel:  =
netlink_sendmsg+0x243/0x480
Aug 26 10:26:32.696513 amc-k8sdevsl01-worker-lx13 kernel:  =
sock_sendmsg+0x5e/0x60
Aug 26 10:26:32.696529 amc-k8sdevsl01-worker-lx13 kernel:  =
____sys_sendmsg+0x1f3/0x260
Aug 26 10:26:32.697288 amc-k8sdevsl01-worker-lx13 kernel:  ? =
copy_msghdr_from_user+0x5c/0x90
Aug 26 10:26:32.697309 amc-k8sdevsl01-worker-lx13 kernel:  ? =
_cond_resched+0x15/0x30
Aug 26 10:26:32.697329 amc-k8sdevsl01-worker-lx13 kernel:  =
___sys_sendmsg+0x81/0xc0
Aug 26 10:26:32.697348 amc-k8sdevsl01-worker-lx13 kernel:  ? =
do_lock_file_wait+0x6e/0xe0
Aug 26 10:26:32.697370 amc-k8sdevsl01-worker-lx13 kernel:  ? =
_cond_resched+0x15/0x30
Aug 26 10:26:32.698946 amc-k8sdevsl01-worker-lx13 kernel:  ? =
fcntl_setlk+0x1a5/0x2d0
Aug 26 10:26:32.698988 amc-k8sdevsl01-worker-lx13 kernel:  =
__sys_sendmsg+0x59/0xa0
Aug 26 10:26:32.699005 amc-k8sdevsl01-worker-lx13 kernel:  =
do_syscall_64+0x33/0x40
Aug 26 10:26:32.699020 amc-k8sdevsl01-worker-lx13 kernel:  =
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Aug 26 10:26:32.699039 amc-k8sdevsl01-worker-lx13 kernel: RIP: =
0033:0x7ff7ab1283ad
Aug 26 10:26:32.699071 amc-k8sdevsl01-worker-lx13 kernel: Code: c3 8b 07 =
85 c0 75 24 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2>
Aug 26 10:26:32.699090 amc-k8sdevsl01-worker-lx13 kernel: RSP: =
002b:00007ff7a232f9f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
Aug 26 10:26:32.699505 amc-k8sdevsl01-worker-lx13 kernel: RAX: =
ffffffffffffffda RBX: 00007ff7a2331b38 RCX: 00007ff7ab1283ad
Aug 26 10:26:32.699534 amc-k8sdevsl01-worker-lx13 kernel: RDX: =
0000000000000000 RSI: 00007ff7a232fa48 RDI: 0000000000000078
Aug 26 10:26:09.088408 amc-k8sdevsl01-worker-lx13 kernel: SELinux:  =
Class xdp_socket not defined in policy.

Is there a fix available for that crash?

Thank you,
Yuri


> On Dec 3, 2020, at 12:00 PM, Yuri Lipnesh <yuri.lipnesh@gmail.com> =
wrote:
>=20
> Seems that upgrade to Linux 5.7 solved the problem, we will run more =
tests.
> Thank you,
> Yuri=20
>=20
>> On Nov 30, 2020, at 2:58 PM, Florian Westphal <fw@strlen.de> wrote:
>>=20
>> Yuri Lipnesh <yuri.lipnesh@gmail.com> wrote:
>>> Linux system crashed
>>>=20
>>> [    0.000000] Linux version 5.4.0-54-generic =
(buildd@lcy01-amd64-008) (gcc version 7.5.0 (Ubuntu =
7.5.0-3ubuntu1~18.04)) #60~18.04.1-Ubuntu SMP Fri Nov 6 17:25:16 UTC =
2020 (Ubuntu 5.4.0-54.60~18.04.1-generic 5.4.65)
>>> [    0.000000] Command line: =
BOOT_IMAGE=3D/boot/vmlinuz-5.4.0-54-generic =
root=3DUUID=3D11885fd3-b840-4c9b-a500-532c73ac952a ro =
find_preseed=3D/preseed.cfg auto noprompt priority=3Dcritical =
locale=3Den_US quiet crashkernel=3D512M-:192M
>>>=20
>>> =E2=80=A6
>>> [  156.321147] TCP: eth0: Driver has suspect GRO implementation, TCP =
performance may be compromised.
>>> [  177.519159] general protection fault: 0000 [#1] SMP PTI
>>> [  177.519737] CPU: 5 PID: 18484 Comm: worker-1 Kdump: loaded Not =
tainted 5.4.0-54-generic #60~18.04.1-Ubuntu
>>> [  177.519742] Hardware name: VMware, Inc. VMware Virtual =
Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
>>> [  177.519814] RIP: 0010:dev_hard_start_xmit+0x38/0x200
>>> [  177.519827] Code: 55 41 54 53 48 83 ec 20 48 85 ff 48 89 55 c8 48 =
89 4d b8 0f 84 c1 01 00 00 48 8d 86 90 00 00 00 48 89 fb 49 89 f4 48 89 =
45 c0 <4c> 8b 2b 48 c7 c0 d0 f2 04 8f 48 c7 03 00 00 00 00 48 8b 00 4d =
85
>>> [  177.519829] RSP: 0018:ffffbc6d0609b5e8 EFLAGS: 00010286
>>> [  177.519833] RAX: 0000000000000000 RBX: dead000000000100 RCX: =
ffff95cf4bcfe800
>>> [  177.519835] RDX: 0000000000000000 RSI: ffff95cf4bcfe800 RDI: =
0000000000000286
>>> [  177.519837] RBP: ffffbc6d0609b630 R08: ffff95cf6a190ec8 R09: =
ffff95cf4a2f7438
>>> [  177.519839] R10: ffffbc6d0609b6d0 R11: ffff95cf49d4d180 R12: =
ffff95cf51a5f000
>>> [  177.519841] R13: dead000000000100 R14: 000000000000009c R15: =
ffff95d02996b400
>>> [  177.519844] FS:  00007ff394cdfb20(0000) GS:ffff95d035d40000(0000) =
knlGS:0000000000000000
>>> [  177.519846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  177.519848] CR2: 00007fb4a9c2d000 CR3: 00000001049fa004 CR4: =
00000000003606e0
>>> [  177.519908] Call Trace:
>>> [  177.519917]  __dev_queue_xmit+0x719/0x920
>>> [  177.519930]  ? ctnetlink_conntrack_event+0x8c/0x5e0 =
[nf_conntrack_netlink]
>>=20
>> Can you reproduce this on 5.7 or later, or with following patches
>> backported to 5.4.y?
>>=20
>> dd3cc111f2e3220ddc9c4ab17f13dc97759b5163
>> 119e52e664c57d5f7c0174dc2b3a296b1e40591d
>> af370ab36fcd19f04e3408c402608e7e56e6f188
>> 28f715b9e6dd7cbf07c2aea913fea7c87a56a3b5
>>=20
>> The series fixed nfqueue reference counting.
>=20

