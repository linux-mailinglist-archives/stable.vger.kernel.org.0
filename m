Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0C2CDBAD
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 18:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgLCRBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 12:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgLCRBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 12:01:36 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5E5C061A4F;
        Thu,  3 Dec 2020 09:00:56 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id r6so1846358qtm.3;
        Thu, 03 Dec 2020 09:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GdHUQunYWche6JVZ0WkgjTcpeGuLwTNi9V4QDSPzOb8=;
        b=Q2BOXGPmgK5Eic1csNF+YiPqxM6JcWmkhrAnXPqXTIyAUdF1qbJYbmRmlXil+Pz9Vk
         rO5VE72bFYoayixp7IBdRWAxKu8PMCBgqtmA2A6zZNp/uslNOo5QLzg8RLWRNIeVcwno
         a8qQdP5ZCGXgEskh5tndUL5uawtq8llrHTOizvWm2/DAYaUlz5eoXOnK4HZeC7b3Chz7
         2CnUl/wYfQqlFrbw5ShwrZuTde2LgryyjZbfVVskrdHjUlC5Zw2+0iQ1PYZGnrF4OmfG
         zaskPljNYjONXNMR1f6w3mVjvDfhonnaDW9Omk2KUk5v/rSus/g9QrVstApDZSqxMi5i
         L8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GdHUQunYWche6JVZ0WkgjTcpeGuLwTNi9V4QDSPzOb8=;
        b=NKedkvjKDC8rypBMAiAp8qkmm/rALpZ/opoPmhkqzeV+Sy2gZofVUlfGlMj+I00Y9I
         uvwcEmNxxwgOH8nQrNYw3EuOVNu5ZlOzA05g3FpMZbIo51mYY24h2ZLJb5avEzvkTGRU
         IN7iXE2IOmsfg1r05o8k43/Zoz3YQUoUJhYlFOJRN/yMxYCyKF83Yw+jLNFeQqpxLpkN
         aQg4q/UwwLqGJ4b6I7k7m2ek/pey+eIqXXsfdA1lBEmrDaMuNf4deGuVtCvKXM5jihMV
         MSGwiTKVh/HRHms7mNlN62uulDPpqszvZywkB8siUDemouYrY0BMg/sTN685rHrn7Lh5
         nDdA==
X-Gm-Message-State: AOAM530baogGBSuDOdVGFbFFWUk8i8dRqgz7vjZc1QDZxc5R0c3Z+6s9
        TF3+e6zQs/Wv4QDoKU38DT1vLODggVo=
X-Google-Smtp-Source: ABdhPJyjZGRyAm0Fr7E5Bqi9tzhWwd0D1q/UNP4Y89CqgJw73YmS7tvriFt3gho/DjR+CEDcxvz2FA==
X-Received: by 2002:ac8:2a45:: with SMTP id l5mr4082930qtl.153.1607014854492;
        Thu, 03 Dec 2020 09:00:54 -0800 (PST)
Received: from [10.254.248.56] ([159.89.225.236])
        by smtp.gmail.com with ESMTPSA id x2sm1622453qtw.3.2020.12.03.09.00.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:00:52 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: System crash on Ubuntu 18, in netlink code when using iptables /
 netfilter
From:   Yuri Lipnesh <yuri.lipnesh@gmail.com>
In-Reply-To: <20201130195857.GM2730@breakpoint.cc>
Date:   Thu, 3 Dec 2020 12:00:51 -0500
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5BABE543-DFBB-42C0-8CA8-74C80C5F4CC0@gmail.com>
References: <B37EABB8-355F-4A05-9BF3-1119D1E0470D@gmail.com>
 <20201130195857.GM2730@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Seems that upgrade to Linux 5.7 solved the problem, we will run more =
tests.
Thank you,
Yuri=20

> On Nov 30, 2020, at 2:58 PM, Florian Westphal <fw@strlen.de> wrote:
>=20
> Yuri Lipnesh <yuri.lipnesh@gmail.com> wrote:
>> Linux system crashed
>>=20
>> [    0.000000] Linux version 5.4.0-54-generic =
(buildd@lcy01-amd64-008) (gcc version 7.5.0 (Ubuntu =
7.5.0-3ubuntu1~18.04)) #60~18.04.1-Ubuntu SMP Fri Nov 6 17:25:16 UTC =
2020 (Ubuntu 5.4.0-54.60~18.04.1-generic 5.4.65)
>> [    0.000000] Command line: =
BOOT_IMAGE=3D/boot/vmlinuz-5.4.0-54-generic =
root=3DUUID=3D11885fd3-b840-4c9b-a500-532c73ac952a ro =
find_preseed=3D/preseed.cfg auto noprompt priority=3Dcritical =
locale=3Den_US quiet crashkernel=3D512M-:192M
>>=20
>> =E2=80=A6
>> [  156.321147] TCP: eth0: Driver has suspect GRO implementation, TCP =
performance may be compromised.
>> [  177.519159] general protection fault: 0000 [#1] SMP PTI
>> [  177.519737] CPU: 5 PID: 18484 Comm: worker-1 Kdump: loaded Not =
tainted 5.4.0-54-generic #60~18.04.1-Ubuntu
>> [  177.519742] Hardware name: VMware, Inc. VMware Virtual =
Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
>> [  177.519814] RIP: 0010:dev_hard_start_xmit+0x38/0x200
>> [  177.519827] Code: 55 41 54 53 48 83 ec 20 48 85 ff 48 89 55 c8 48 =
89 4d b8 0f 84 c1 01 00 00 48 8d 86 90 00 00 00 48 89 fb 49 89 f4 48 89 =
45 c0 <4c> 8b 2b 48 c7 c0 d0 f2 04 8f 48 c7 03 00 00 00 00 48 8b 00 4d =
85
>> [  177.519829] RSP: 0018:ffffbc6d0609b5e8 EFLAGS: 00010286
>> [  177.519833] RAX: 0000000000000000 RBX: dead000000000100 RCX: =
ffff95cf4bcfe800
>> [  177.519835] RDX: 0000000000000000 RSI: ffff95cf4bcfe800 RDI: =
0000000000000286
>> [  177.519837] RBP: ffffbc6d0609b630 R08: ffff95cf6a190ec8 R09: =
ffff95cf4a2f7438
>> [  177.519839] R10: ffffbc6d0609b6d0 R11: ffff95cf49d4d180 R12: =
ffff95cf51a5f000
>> [  177.519841] R13: dead000000000100 R14: 000000000000009c R15: =
ffff95d02996b400
>> [  177.519844] FS:  00007ff394cdfb20(0000) GS:ffff95d035d40000(0000) =
knlGS:0000000000000000
>> [  177.519846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  177.519848] CR2: 00007fb4a9c2d000 CR3: 00000001049fa004 CR4: =
00000000003606e0
>> [  177.519908] Call Trace:
>> [  177.519917]  __dev_queue_xmit+0x719/0x920
>> [  177.519930]  ? ctnetlink_conntrack_event+0x8c/0x5e0 =
[nf_conntrack_netlink]
>=20
> Can you reproduce this on 5.7 or later, or with following patches
> backported to 5.4.y?
>=20
> dd3cc111f2e3220ddc9c4ab17f13dc97759b5163
> 119e52e664c57d5f7c0174dc2b3a296b1e40591d
> af370ab36fcd19f04e3408c402608e7e56e6f188
> 28f715b9e6dd7cbf07c2aea913fea7c87a56a3b5
>=20
> The series fixed nfqueue reference counting.

