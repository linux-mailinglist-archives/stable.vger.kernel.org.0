Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049E8251427
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHYIZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 04:25:29 -0400
Received: from mail.loongson.cn ([114.242.206.163]:34712 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728992AbgHYIZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 04:25:27 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx6MTjykRf1rkNAA--.391S2;
        Tue, 25 Aug 2020 16:25:07 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Takashi Iwai <tiwai@suse.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>, <stable@vger.kernel.org>
Subject: [PATCH] Revert "ALSA: hda: Add support for Loongson 7A1000 controller"
Date:   Tue, 25 Aug 2020 16:25:03 +0800
Message-Id: <1598343903-2372-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dx6MTjykRf1rkNAA--.391S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4kZF15ZryDZr4xXry3twb_yoWrWFyfpr
        yYqr1jkr48tr1UGr4YyF98Jr17Kw4DA3WDGrW8twn8ZF15Wr1UJr1UtFWUKr1DJr15Jry7
        Jr1Dtr40g34UJ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GFyl
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUjAhL5UUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 61eee4a7fc40 ("ALSA: hda: Add support for Loongson
7A1000 controller").

With this patch, there exists the following error on the Loongson LS7A
platform:

[  216.639938] rcu: INFO: rcu_preempt self-detected stall on CPU
[  216.645685] rcu:     0-....: (1 GPs behind) idle=d5a/1/0x4000000000000004 softirq=562/563 fqs=16476
[  216.654565]  (t=53772 jiffies g=-463 q=11976)
[  216.658923] NMI backtrace for cpu 0
[  216.662417] CPU: 0 PID: 68 Comm: kworker/0:2 Not tainted 5.8.0+ #3
[  216.668587] Hardware name:  , BIOS
[  216.672174] Workqueue: events azx_probe_work [snd_hda_intel]
[  216.677829] Stack : 0000000000000000 0000000000000000 ffffffff95004ce0 d786f9efa2288403
[  216.685848]         d786f9efa2288403 0000000000000000 98000001102638c8 ffffffff80cee270
[  216.693866]         0000000000000000 0000000000000000 0000000000000000 00000000000002b4
[  216.701883]         206b726f775f6562 0000000000000001 0000000000000000 ffffffff80f30000
[  216.709902]         ffffffff80f30000 ffffffff80d90000 0000000000000000 0000000000000000
[  216.717919]         0000000000000000 0000000000000000 0000000000000000 ffffffff80d90000
[  216.725937]         ffffffff80d90000 0000000000000007 ffffffff806aff18 0000000000000000
[  216.733955]         ffffffff80f00000 9800000110cc4000 98000001102638c0 ffffffff80d9db80
[  216.741974]         ffffffff8065a740 0000000000000000 0000000000000000 0000000000000000
[  216.749991]         000073746e657665 0000000000000000 ffffffff80211a64 d786f9efa2288403
[  216.758009]         ...
[  216.760464] Call Trace:
[  216.762920] [<ffffffff80211a64>] show_stack+0x9c/0x130
[  216.768058] [<ffffffff8065a740>] dump_stack+0xb0/0xf0
[  216.773110] [<ffffffff80665774>] nmi_cpu_backtrace+0x134/0x140
[  216.778939] [<ffffffff80665910>] nmi_trigger_cpumask_backtrace+0x190/0x200
[  216.785805] [<ffffffff802b1abc>] rcu_dump_cpu_stacks+0x12c/0x190
[  216.791806] [<ffffffff802b08cc>] rcu_sched_clock_irq+0xa2c/0xfc8
[  216.797808] [<ffffffff802b91d4>] update_process_times+0x2c/0xb8
[  216.803724] [<ffffffff802cad80>] tick_sched_timer+0x40/0xb8
[  216.809293] [<ffffffff802ba5f0>] __hrtimer_run_queues+0x118/0x1d0
[  216.815380] [<ffffffff802bab74>] hrtimer_interrupt+0x12c/0x2d8
[  216.821208] [<ffffffff8021547c>] c0_compare_interrupt+0x74/0xa0
[  216.827124] [<ffffffff80296bd0>] __handle_irq_event_percpu+0xa8/0x198
[  216.833558] [<ffffffff80296cf0>] handle_irq_event_percpu+0x30/0x90
[  216.839732] [<ffffffff8029d958>] handle_percpu_irq+0x88/0xb8
[  216.845388] [<ffffffff80296124>] generic_handle_irq+0x44/0x60
[  216.851131] [<ffffffff80b3cfd0>] do_IRQ+0x18/0x28
[  216.855838] [<ffffffff8067ace4>] plat_irq_dispatch+0x64/0x100
[  216.861579] [<ffffffff80209a20>] handle_int+0x140/0x14c
[  216.866802] [<ffffffff802402e8>] irq_exit+0xf8/0x100

This is because AZX_DRIVER_GENERIC can not work well for Loongson LS7A
HDA controller, it needs some workarounds which are not merged into the
upstream kernel, so it should revert this patch now.

There will be a better solution that has been tested carefully to support
Loongson LS7A HDA controller.

Fixes: 61eee4a7fc40 ("ALSA: hda: Add support for Loongson 7A1000 controller")
Cc: <stable@vger.kernel.org> # 5.9-rc1+
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 sound/pci/hda/hda_intel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e34a4d5..0f86e37 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2745,8 +2745,6 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_GENERIC | AZX_DCAPS_PRESET_ATI_HDMI },
 	/* Zhaoxin */
 	{ PCI_DEVICE(0x1d17, 0x3288), .driver_data = AZX_DRIVER_ZHAOXIN },
-	/* Loongson */
-	{ PCI_DEVICE(0x0014, 0x7a07), .driver_data = AZX_DRIVER_GENERIC },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
-- 
2.1.0

