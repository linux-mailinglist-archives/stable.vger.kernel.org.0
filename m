Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03C4A31AF
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 20:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbiA2Tu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 14:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiA2Tu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 14:50:56 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56625C061714;
        Sat, 29 Jan 2022 11:50:56 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o30-20020a05600c511e00b0034f4c3186f4so10739127wms.3;
        Sat, 29 Jan 2022 11:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VC+y47fc0hVL9V4PjkzouX9x6+OguQFNX6f/KIn/hrQ=;
        b=lfHop6jLMqTVHYuYklsvs3bSnroZ3GWsaVWgM5conAqbAYL1U1oYz8MtQxT3k2EFss
         XIbSX6E2N4C/sLedFFry7+lpwJGUFI+GFKoybG5zooD5DUiUnVdpJWGXida3qtrAeF/k
         eXATQIXIsJXpIIMb5yD+7JDw00gMYuq0H+Icf7vvyWso+rYLcB1O4WhskeyCbFNXBygA
         R/BLufy8P9E0jUoELXCB37EJwJ/Bh2tpH5wX4Nr81kom9BvP3VK0+QXoCQfL1RClv/2d
         5Qt+I/axgZK8jlbM29VXG3FBfpHYmme47y8dvcvVzuhxCIRoli1ycFyT28Q+Jgm+YtQC
         6SQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VC+y47fc0hVL9V4PjkzouX9x6+OguQFNX6f/KIn/hrQ=;
        b=38kF/fQ1FSFpD8t2aXxX1WcM+XPZaqCgn7c39AgCpZreErp5cip5eZZLlKPyehwEvP
         B1uLDleaszNou99d2u0jHjJPgnhPvVPBFwirsa7dH3LL07mj0Qf+4HOskv3oy9sDb4Ta
         4Xcw9LfJkOmt2bC78QjUrC1YjG0zZGJ84ngI+1zRZg05o5MNxKkpTlITI8s1EU+my3RM
         bDccu17I47MlX8eR4WD37g89MQRUe3MVxJJii9jcFXjr7FBOnG1bCbo70MW0H3EQ+INL
         fkoUlwhPMB3GfO4HJAa4c+pIVyUpb4eRMZJEc4zsrBz8XeX/fiU4/0piDnacLf3FPSvr
         3E1g==
X-Gm-Message-State: AOAM5316RkUDajy6LI7ZjwKBtht7Fe+mOo8IeG2lSz2kYzVbnJmPYwFH
        qcZUiCBwhLRfHtj+hCrSBchI6KgEUQKsS5W//OxT8ayp9Kc=
X-Google-Smtp-Source: ABdhPJyZVlpEoYoCo9Rb0C7Nk1ZnTf6ltuq2dVlxjJoCQzAimVrUrU3jZu+3QOuS3J4V/OhaPiGQ4C7f4F0675DDf0U=
X-Received: by 2002:a05:600c:348f:: with SMTP id a15mr20488003wmq.154.1643485854662;
 Sat, 29 Jan 2022 11:50:54 -0800 (PST)
MIME-Version: 1.0
References: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
 <cabdd567-6b8a-476b-ac45-e6ee170247f9@lockie.ca>
In-Reply-To: <cabdd567-6b8a-476b-ac45-e6ee170247f9@lockie.ca>
From:   Felipe Contreras <felipe.contreras@gmail.com>
Date:   Sat, 29 Jan 2022 13:50:43 -0600
Message-ID: <CAMP44s0+kOzePb7r6W6c2ok32iWNYOXiSQOV+Pmp0ij7tvgakg@mail.gmail.com>
Subject: Re: Regression in 5.16.3 with mt7921e
To:     James <bjlockie@lockie.ca>
Cc:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 1:12 PM James <bjlockie@lockie.ca> wrote:
>
> Does dmesg show anything?

It's hard to tell because it seems there are multiple conflating
issues. I booted into 5.16.3 again, and this time I experienced a
different problem, so far I've seen these two:

1. The device appears, but I'm unable to bring it up
2. The device doesn't even appear

For issue #2 I see this interesting error:

[    0.325945] Freeing initrd memory: 8768K
[    0.331968] ------------[ cut here ]------------
[    0.331969] WARNING: CPU: 4 PID: 1 at drivers/iommu/amd/init.c:839
amd_iommu_enable_interrupts+0x352/0x430
[    0.331975] Modules linked in:
[    0.331977] CPU: 4 PID: 1 Comm: swapper/0 Not tainted
5.16.3-arch1-1 #1 ca51a3fe35922d501638d513dc9548a2c4fed987
[    0.331980] Hardware name: ASUSTeK COMPUTER INC. ROG Zephyrus G14
GA401QM_GA401QM/GA401QM, BIOS GA401QM.410 12/13/2021
[    0.331980] RIP: 0010:amd_iommu_enable_interrupts+0x352/0x430
[    0.331982] Code: ff ff 48 8b 7b 18 89 04 24 e8 2a 3a ed ff 8b 04
24 e9 45 fd ff ff 0f 0b 48 8b 1b 48 81 fb 70 09 b6 99 0f 85 00 fd ff
ff eb 96 <0f> 0b 48 8b 1b 48 81 fb 70 09 b6 99 0f 85 ec fc ff ff eb 82
31 f6
[    0.331983] RSP: 0018:ffffa17a00087db8 EFLAGS: 00010246
[    0.331985] RAX: 0000000000000018 RBX: ffff89af0004b000 RCX: ffffa17a00100000
[    0.331986] RDX: 0000000000000000 RSI: ffffa17a00100000 RDI: 0000000000000000
[    0.331986] RBP: 0000000080000000 R08: 0000000000000000 R09: 0000000000000000
[    0.331987] R10: 0000000000000000 R11: 0000000000000000 R12: 000ffffffffffff8
[    0.331988] R13: 0800000000000000 R14: ffffa17a00087dc0 R15: ffff89af013323c0
[    0.331988] FS:  0000000000000000(0000) GS:ffff89b1de700000(0000)
knlGS:0000000000000000
[    0.331989] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.331990] CR2: 0000000000000000 CR3: 000000020a410000 CR4: 0000000000750ee0
[    0.331991] PKRU: 55555554
[    0.331991] Call Trace:
[    0.331992]  <TASK>
[    0.331995]  iommu_go_to_state+0x1164/0x1458
[    0.331999]  ? e820__memblock_setup+0x7d/0x7d
[    0.332002]  amd_iommu_init+0xf/0x29
[    0.332003]  pci_iommu_init+0x16/0x3f
[    0.332005]  do_one_initcall+0x57/0x220
[    0.332008]  kernel_init_freeable+0x1e8/0x242
[    0.332010]  ? rest_init+0xd0/0xd0
[    0.332013]  kernel_init+0x16/0x130
[    0.332014]  ret_from_fork+0x22/0x30
[    0.332016]  </TASK>
[    0.332018] ---[ end trace 99de2ba3e793f5cf ]---
[    0.332018] software IO TLB: tearing down default memory pool

Even more interesting is that I rebooted into 5.16.2 and the same
warning appeared, and the same issue happened: I didn't see the
driver. I turned off the laptop (as opposed to rebooting), and then
turned it on, and now the wireless works fine (in 5.16.2).

The reason I turn off the laptop is that I read in some forums that
turning off the computer and waiting 10 seconds makes the chip work
again (although that was for yet another issue, I've not experienced
lately, and it happened even in Windows).

Here's the whole dmesg: https://dpaste.org/0sj3

I'll try to disable the proprietary nvidia driver to see if there's
any difference.

-- 
Felipe Contreras
