Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A144E527C23
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 04:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239480AbiEPCro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 22:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiEPCrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 22:47:43 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1EB14093
        for <stable@vger.kernel.org>; Sun, 15 May 2022 19:47:40 -0700 (PDT)
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 340E13F1EC
        for <stable@vger.kernel.org>; Mon, 16 May 2022 02:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1652669258;
        bh=LbVZpzmd4WQjgxCWt4NgccxaEzz/Pb7baxR1d7vGewQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=jpdRfJd+LOpDFwb7404gCbExd2FPXYiKqUvkqyDU68OuFfgqfKPqNO+Z2tGuQqcO9
         5Fx5uqN8ZVRpVRQ8UGDiMaplvuHqMyK5yftZx9iYCpSJJ5ZwzCz2IWnQ6X/ueB+K4L
         8DTYZR2KsaachFz/oWx9k9ZjF9FGOWTA7gWedFfe9FaOKB03WjOnM/u3c8QDCR1+sd
         ybdcJPRzQCm9YfR2VusP3O6t9Jwm5q3Pt5pVOdLVAeF4u1m7hUiikWJk1bZfPWmet/
         xxmlMl6gOGRzIthpOe86hmYHXM8HL8BXlHhOdkKc6n5uqAjaB3DGkvUz1hjgCntZFc
         K0y1RT08iuPgA==
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-edc2814451so8567185fac.0
        for <stable@vger.kernel.org>; Sun, 15 May 2022 19:47:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LbVZpzmd4WQjgxCWt4NgccxaEzz/Pb7baxR1d7vGewQ=;
        b=0vv7e+NBUDA2a+EiRlas13iuCATBDR6KFAmCY529DO+c8vemj9FTlb+ID6uHDek4dy
         IDVHE0QsAZtcyIYGd8ng0jXWredfIo24dSkfUh6lJfdB2DsTw0JaL9kuZnQEP0zCzLiV
         iNxL1X5/wnKrbjc0hTlE4yF0I9O5PzCblR0AdSLATwz9AqYf9gZXz1i26N9baNZzV2cW
         +7oxEOeJJqwIU4Hf5+XM4p77l/UjJXVNs/Kp1XJCBnzYuIqe+fFK/p/rYl31SPbsd0k9
         F2n5AOJH9uTPvUR7gkrkAyquXuY5kJMmjHOSfZ77UDQr9UuuSnE19m+TVYiSfFpbWF6r
         aFnQ==
X-Gm-Message-State: AOAM531BZ5uZ23XvjnkFgbv95KCyTc01I5cmr7rFvr1lS2bm1fTzyQNb
        10RELZvx/s1WcUeQv6FOFsi2PBtTmaBJLrFD8reulVAiPWbdvR7SB2i9QbO6iMuvi7eOlKOyxd8
        P3cGhdlEs1/KpKHD28Dcw2z26YhVJSx5KblV5VXxpMzWHMsmQeA==
X-Received: by 2002:a05:6808:1441:b0:328:af9e:5540 with SMTP id x1-20020a056808144100b00328af9e5540mr6949472oiv.42.1652669256991;
        Sun, 15 May 2022 19:47:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5Xuzn8KrPTI5dqpzKra5nhIxZ/jVo2NoLpJO0gz+dNOjl0lDo31AJ40AuXT6T2TEx/ECFU43oTDTaZL7xyE8=
X-Received: by 2002:a05:6808:1441:b0:328:af9e:5540 with SMTP id
 x1-20020a056808144100b00328af9e5540mr6949464oiv.42.1652669256578; Sun, 15 May
 2022 19:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <2584945.lGaqSPkdTl@geek500.localdomain> <eed25dd6-36ba-cd1c-1828-08a1535ce6c6@leemhuis.info>
 <25425832.1r3eYUQgxm@geek500.localdomain>
In-Reply-To: <25425832.1r3eYUQgxm@geek500.localdomain>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 16 May 2022 10:47:25 +0800
Message-ID: <CAAd53p60PzKT50uAkLeTjDVsH7TKSNHiLBQjJx5uPvzPpURkfQ@mail.gmail.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
To:     Christian Casteyde <casteyde.christian@free.fr>
Cc:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        regressions@lists.linux.dev, alexander.deucher@amd.com,
        gregkh@linuxfoundation.org,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+Cc Mario]

On Sun, May 15, 2022 at 1:34 AM Christian Casteyde
<casteyde.christian@free.fr> wrote:
>
> I've applied the commit a56f445f807b0276 on 5.17.7 and tested.
> This does not fix the problem on my laptop.

Maybe some commits are still missing?

>
> For informatio, here is a part of the log around the suspend process:

Is it possible to attach full dmesg?

Kai-Heng

>
> May 14 19:21:41 geek500 kernel: snd_hda_intel 0000:01:00.1: can't change =
power
> state from D3cold to D0 (config space inaccessible)
> May 14 19:21:41 geek500 kernel: PM: late suspend of devices failed
> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> May 14 19:21:41 geek500 kernel: i2c_designware AMDI0010:03: Transfer whil=
e
> suspended
> May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: can't derive routing fo=
r PCI
> INT A
> May 14 19:21:41 geek500 kernel: pci 0000:00:00.2: PCI INT A: no GSI
> May 14 19:21:41 geek500 kernel: WARNING: CPU: 9 PID: 1972 at drivers/i2c/
> busses/i2c-designware-master.c:570 i2c_dw_xfer+0x3f6/0x440
> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_c=
all]
> May 14 19:21:41 geek500 kernel: CPU: 9 PID: 1972 Comm: kworker/u32:18 Tai=
nted:
> G           O      5.17.7+ #7
> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Lapt=
op
> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> May 14 19:21:41 geek500 kernel: Workqueue: events_unbound async_run_entry=
_fn
> May 14 19:21:41 geek500 kernel: RIP: 0010:i2c_dw_xfer+0x3f6/0x440
> May 14 19:21:41 geek500 kernel: Code: c6 05 db 31 45 01 01 4c 8b 67 50 4d=
 85
> e4 75 03 4c 8b 27 e8 fc e1 e9 ff 4c 89 e2 48 c7 c7 00 01 cc
>  ab 48 89 c6 e8 b3 4f 45 00 <0f> 0b 41 be 94 ff ff ff e9 cc fc ff ff e9 2=
d 9c
> 4b 00 83 f8 01 74
> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc31e7c68 EFLAGS: 000102=
86
> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff888540f170=
e8
> RCX: 0000000000000be5
> May 14 19:21:41 geek500 kernel: RDX: 0000000000000000 RSI: 00000000000000=
86
> RDI: ffffffffac858df8
> May 14 19:21:41 geek500 kernel: RBP: ffff888540f170e8 R08: ffffffffabe46d=
60
> R09: 00000000ac86a0f6
> May 14 19:21:41 geek500 kernel: R10: ffffffffffffffff R11: ffffffffffffff=
ff
> R12: ffff888540f5c070
> May 14 19:21:41 geek500 kernel: R13: ffff8dbfc31e7d70 R14: 00000000ffffff=
94
> R15: ffff888540f17028
> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> GS:ffff88885f640000(0000) knlGS:0000000000000000
> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 14 19:21:41 geek500 kernel: CR2: 00007f1984067028 CR3: 0000000045e0c0=
00
> CR4: 0000000000350ee0
> May 14 19:21:41 geek500 kernel: Call Trace:
> May 14 19:21:41 geek500 kernel:  <TASK>
> May 14 19:21:41 geek500 kernel:  ? dequeue_entity+0xd4/0x250
> May 14 19:21:41 geek500 kernel:  ? newidle_balance.constprop.0+0x1f7/0x3b=
0
> May 14 19:21:41 geek500 kernel:  __i2c_transfer+0x16d/0x520
> May 14 19:21:41 geek500 kernel:  i2c_transfer+0x7a/0xd0
> May 14 19:21:41 geek500 kernel:  __i2c_hid_command+0x106/0x2d0
> May 14 19:21:41 geek500 kernel:  ? amd_gpio_irq_enable+0x19/0x50
> May 14 19:21:41 geek500 kernel:  i2c_hid_set_power+0x4a/0xd0
> May 14 19:21:41 geek500 kernel:  i2c_hid_core_resume+0x60/0xb0
> May 14 19:21:41 geek500 kernel:  ? acpi_subsys_resume_early+0x50/0x50
> May 14 19:21:41 geek500 kernel:  dpm_run_callback+0x1d/0xd0
> May 14 19:21:41 geek500 kernel:  device_resume+0x122/0x230
> May 14 19:21:41 geek500 kernel:  async_resume+0x14/0x30
> May 14 19:21:41 geek500 kernel:  async_run_entry_fn+0x1b/0xa0
> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> May 14 19:21:41 geek500 kernel:  </TASK>
> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: failed to c=
hange
> power setting.
> May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> acpi_subsys_resume+0x0/0x50 returns -108
> May 14 19:21:41 geek500 kernel: i2c_hid_acpi i2c-ELAN0718:00: PM: failed =
to
> resume async: error -108
> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0:
> [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110)
> May 14 19:21:41 geek500 kernel: [drm:amdgpu_device_ip_resume_phase2] *ERR=
OR*
> resume of IP block <gfx_v9_0> failed -110
> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: amdgpu:
> amdgpu_device_ip_resume failed (-110).
> May 14 19:21:41 geek500 kernel: PM: dpm_run_callback():
> pci_pm_resume+0x0/0x120 returns -110
> May 14 19:21:41 geek500 kernel: amdgpu 0000:05:00.0: PM: failed to resume
> async: error -110
> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
> clk.c:971 clk_core_disable+0x80/0x1a0
> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_c=
all]
> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainte=
d: G
> W  O      5.17.7+ #7
> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Lapt=
op
> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_disable+0x80/0x1a0
> May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44 00 00 48=
 8b
> 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d 87 c4 ab e=
8 79
> 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48 0f a3 05 4a 61 9d=
 01
> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d50 EFLAGS: 000100=
82
> May 14 19:21:41 geek500 kernel:
> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b63=
00
> RCX: 0000000000000027
> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 00000000000000=
01
> RDI: ffff88885f59f460
> May 14 19:21:41 geek500 kernel: RBP: 0000000000000283 R08: ffffffffabf26d=
a8
> R09: 00000000ffffdfff
> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46d=
c0
> R12: ffff8885401b6300
> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 00000000000000=
08
> R15: 0000000000000000
> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> GS:ffff88885f580000(0000) knlGS:0000000000000000
> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 00000001029560=
00
> CR4: 0000000000350ee0
> May 14 19:21:41 geek500 kernel: Call Trace:
> May 14 19:21:41 geek500 kernel:  <TASK>
> May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x74/0xd0
> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> May 14 19:21:41 geek500 kernel:  </TASK>
> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
> clk.c:829 clk_core_unprepare+0xb1/0x1a0
> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_c=
all]
> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainte=
d: G
> W  O      5.17.7+ #7
> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Lapt=
op
> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_unprepare+0xb1/0x1a0
> May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48 85 db 74=
 a2
> 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35 87 c4 ab e=
8 18
> 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f a3 05 ea 62 9d 01=
 73
> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d60 EFLAGS: 000102=
86
> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b63=
00
> RCX: 0000000000000027
> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 00000000000000=
01
> RDI: ffff88885f59f460
> May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08: ffffffffabf26d=
a8
> R09: 00000000ffffdfff
> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46d=
c0
> R12: 0000000000000000
> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 00000000000000=
08
> R15: 0000000000000000
> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> GS:ffff88885f580000(0000) knlGS:0000000000000000
> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 00000001029560=
00
> CR4: 0000000000350ee0
> May 14 19:21:41 geek500 kernel: Call Trace:
> May 14 19:21:41 geek500 kernel:  <TASK>
> May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x7c/0xd0
> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel: done.
> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> May 14 19:21:41 geek500 kernel:  </TASK>
> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> May 14 19:21:41 geek500 kernel: AMDI0010:03 already disabled
> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
> clk.c:971 clk_core_disable+0x80/0x1a0
> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_c=
all]
> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainte=
d: G
> W  O      5.17.7+ #7
> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Lapt=
op
> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_disable+0x80/0x1a0
> May 14 19:21:41 geek500 kernel: Code: 10 e8 e4 4a d1 00 0f 1f 44 00 00 48=
 8b
> 5b 30 48 85 db 74 b6 8b 43 7c 85 c0 75 a4 48 8b 33 48 c7 c7 7d 87 c4 ab e=
8 79
> 7a 9a 00 <0f> 0b 5b 5d c3 65 8b 05 5c a1 92 55 89 c0 48 0f a3 05 4a 61 9d=
 01
> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d50 EFLAGS: 000100=
82
> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b63=
00
> RCX: 0000000000000027
> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 00000000000000=
01
> RDI: ffff88885f59f460
> May 14 19:21:41 geek500 kernel: RBP: 0000000000000287 R08: ffffffffabf26d=
a8
> R09: 00000000ffffdfff
> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46d=
c0
> R12: ffff8885401b6300
> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 00000000000000=
08
> R15: 0000000000000000
> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> GS:ffff88885f580000(0000) knlGS:0000000000000000
> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 00000001029560=
00
> CR4: 0000000000350ee0
> May 14 19:21:41 geek500 kernel: Call Trace:
> May 14 19:21:41 geek500 kernel:  <TASK>
> May 14 19:21:41 geek500 kernel:  clk_disable+0x24/0x30
> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x88/0xd0
> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> May 14 19:21:41 geek500 kernel:  </TASK>
> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> May 14 19:21:41 geek500 kernel: ------------[ cut here ]------------
> May 14 19:21:41 geek500 kernel: AMDI0010:03 already unprepared
> May 14 19:21:41 geek500 kernel: WARNING: CPU: 6 PID: 1091 at drivers/clk/
> clk.c:829 clk_core_unprepare+0xb1/0x1a0
> May 14 19:21:41 geek500 kernel: Modules linked in: [last unloaded: acpi_c=
all]
> May 14 19:21:41 geek500 kernel: CPU: 6 PID: 1091 Comm: kworker/6:3 Tainte=
d: G
> W  O      5.17.7+ #7
> May 14 19:21:41 geek500 kernel: Hardware name: HP HP Pavilion Gaming Lapt=
op
> 15-ec1xxx/87B2, BIOS F.25 08/18/2021
> May 14 19:21:41 geek500 kernel: Workqueue: pm pm_runtime_work
> May 14 19:21:41 geek500 kernel: RIP: 0010:clk_core_unprepare+0xb1/0x1a0
> May 14 19:21:41 geek500 kernel: Code: 40 00 66 90 48 8b 5b 30 48 85 db 74=
 a2
> 8b 83 80 00 00 00 85 c0 0f 85 79 ff ff ff 48 8b 33 48 c7 c7 35 87 c4 ab e=
8 18
> 7c 9a 00 <0f> 0b 5b c3 65 8b 05 fc a2 92 55 89 c0 48 0f a3 05 ea 62 9d 01=
 73
> May 14 19:21:41 geek500 kernel: RSP: 0018:ffff8dbfc1c47d60 EFLAGS: 000102=
86
> May 14 19:21:41 geek500 kernel: RAX: 0000000000000000 RBX: ffff8885401b63=
00
> RCX: 0000000000000027
> May 14 19:21:41 geek500 kernel: RDX: ffff88885f59f468 RSI: 00000000000000=
01
> RDI: ffff88885f59f460
> May 14 19:21:41 geek500 kernel: RBP: ffff8885401b6300 R08: ffffffffabf26d=
a8
> R09: 00000000ffffdfff
> May 14 19:21:41 geek500 kernel: R10: ffffffffabe46dc0 R11: ffffffffabe46d=
c0
> R12: 0000000000000000
> May 14 19:21:41 geek500 kernel: R13: ffff888540fc30f4 R14: 00000000000000=
08
> R15: 0000000000000000
> May 14 19:21:41 geek500 kernel: FS:  0000000000000000(0000)
> GS:ffff88885f580000(0000) knlGS:0000000000000000
> May 14 19:21:41 geek500 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 14 19:21:41 geek500 kernel: CR2: 00000000010fa990 CR3: 00000001029560=
00
> CR4: 0000000000350ee0
> May 14 19:21:41 geek500 kernel: Call Trace:
> May 14 19:21:41 geek500 kernel:  <TASK>
> May 14 19:21:41 geek500 kernel:  clk_unprepare+0x1f/0x30
> May 14 19:21:41 geek500 kernel:  i2c_dw_prepare_clk+0x90/0xd0
> May 14 19:21:41 geek500 kernel:  dw_i2c_plat_suspend+0x2e/0x40
> May 14 19:21:41 geek500 kernel:  acpi_subsys_runtime_suspend+0x9/0x20
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  __rpm_callback+0x3f/0x150
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  rpm_callback+0x54/0x60
> May 14 19:21:41 geek500 kernel:  ? acpi_dev_suspend+0x160/0x160
> May 14 19:21:41 geek500 kernel:  rpm_suspend+0x142/0x720
> May 14 19:21:41 geek500 kernel:  pm_runtime_work+0x8f/0xa0
> May 14 19:21:41 geek500 kernel:  process_one_work+0x1d3/0x3a0
> May 14 19:21:41 geek500 kernel:  worker_thread+0x48/0x3c0
> May 14 19:21:41 geek500 kernel:  ? rescuer_thread+0x380/0x380
> May 14 19:21:41 geek500 kernel:  kthread+0xd3/0x100
> May 14 19:21:41 geek500 kernel:  ? kthread_complete_and_exit+0x20/0x20
> May 14 19:21:41 geek500 kernel:  ret_from_fork+0x22/0x30
> May 14 19:21:41 geek500 kernel:  </TASK>
> May 14 19:21:41 geek500 kernel: ---[ end trace 0000000000000000 ]---
> May 14 19:21:59 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0: Unable to=
 sync
> register 0x4f0800. -5
> May 14 19:21:59 geek500 kernel: (elapsed 0.175 seconds) done.
> May 14 19:21:59 geek500 kernel: amdgpu 0000:05:00.0: amdgpu: Power consum=
ption
> will be higher as BIOS has not been configured for suspend-to-idle.
> To use suspend-to-idle change the sleep mode in BIOS setup.
> May 14 19:21:59 geek500 kernel: snd_hda_intel 0000:01:00.1: can't change =
power
> state from D3cold to D0 (config space inaccessible)
> May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: can't derive routing fo=
r PCI
> INT A
> May 14 19:21:59 geek500 kernel: pci 0000:00:00.2: PCI INT A: no GSI
> May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:21:59 geek500 kernel: Bluetooth: hci0: command 0xfc20 tx timeou=
t
> May 14 19:21:59 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:21:59 geek500 kernel: Bluetooth: hci0: RTL: download fw command
> failed (-110)
> May 14 19:21:59 geek500 kernel: done.
> May 14 19:22:00 geek500 kernel: snd_hda_codec_hdmi hdaudioC1D0: Unable to=
 sync
> register 0x4f0800. -5
> May 14 19:22:00 geek500 dnsmasq[2079]: no servers found in /etc/dnsmasq.d=
/
> dnsmasq-resolv.conf, will retry
> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:22:01 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:02 geek500 last message buffered 2 times
> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:22:03 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:22:04 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:05 geek500 last message buffered 2 times
> May 14 19:22:05 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:06 geek500 kernel: [drm] Fence fallback timer expired on rin=
g gfx
> May 14 19:22:06 geek500 last message buffered 1 times
> ...
> May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
> May 14 19:22:18 geek500 kernel: [drm:amdgpu_dm_atomic_commit_tail] *ERROR=
*
> Waiting for fences timed out!
> May 14 19:22:18 geek500 kernel: [drm] Fence fallback timer expired on rin=
g
> sdma0
>
> CC
>
> Le samedi 14 mai 2022, 17:12:33 CEST Thorsten Leemhuis a =C3=A9crit :
> > Hi, this is your Linux kernel regression tracker. Thanks for the report=
.
> >
> > On 14.05.22 16:41, Christian Casteyde wrote:
> > > #regzbot introduced v5.17.3..v5.17.4
> > > #regzbot introduced: 001828fb3084379f3c3e228b905223c50bc237f9
> >
> > FWIW, that's commit 887f75cfd0da ("drm/amdgpu: Ensure HDA function is
> > suspended before ASIC reset") upstream.
> >
> > Recently a regression was reported where 887f75cfd0da was suspected as
> > the culprit:
> > https://gitlab.freedesktop.org/drm/amd/-/issues/2008
> >
> > And a one related to it:
> > https://gitlab.freedesktop.org/drm/amd/-/issues/1982
> >
> > You might want to take a look if what was discussed there might be
> > related to your problem (I'm not directly involved in any of this, I
> > don't know the details, it's just that 887f75cfd0da looked familiar to
> > me). If it is, a fix for these two bugs was committed to master earlier
> > this week:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?i
> > d=3Da56f445f807b0276
> >
> > It will likely be backported to 5.17.y, maybe already in the over-next
> > release. HTH.
> >
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat=
)
> >
> > P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > reports and sometimes miss something important when writing mails like
> > this. If that's the case here, don't hesitate to tell me in a public
> > reply, it's in everyone's interest to set the public record straight.
> >
> > > Hello
> > > Since 5.17.4 my laptop doesn't resume from suspend anymore. At resume=
,
> > > symptoms are variable:
> > > - either the laptop freezes;
> > > - either the screen keeps blank;
> > > - either the screen is OK but mouse is frozen;
> > > - either display lags with several logs in dmesg:
> > > [  228.275492] [drm] Fence fallback timer expired on ring gfx
> > > [  228.395466] [drm:amdgpu_dm_atomic_commit_tail] *ERROR* Waiting for
> > > fences timed out!
> > > [  228.779490] [drm] Fence fallback timer expired on ring gfx
> > > [  229.283484] [drm] Fence fallback timer expired on ring sdma0
> > > [  229.283485] [drm] Fence fallback timer expired on ring gfx
> > > [  229.787487] [drm] Fence fallback timer expired on ring gfx
> > > ...
> > >
> > > I've bisected the problem.
> > >
> > > Please note this laptop has a strange behaviour on suspend:
> > > The first suspend request always fails (this point has never been fix=
ed
> > > and
> > > plagues us when trying to diagnose another regression on touchpad not
> > > resuming in the past). The screen goes blank and I can get it OK when
> > > pressing the power button, this seems to reset it. After that all
> > > suspend/resume works OK.
> > >
> > > Since 5.17.4, it is not possible anymore to get the laptop working ag=
ain
> > > after the first suspend failure.
> > >
> > > HW : HP Pavilion / Ryzen 4600H with AMD graphics integrated + NVidia
> > > 1650Ti
> > > (turned off with ACPI call in order to get more battery, I'm not usin=
g
> > > NVidia driver).
>
>
>
>
