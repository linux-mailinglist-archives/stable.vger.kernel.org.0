Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D2E251590
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 11:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgHYJkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 05:40:12 -0400
Received: from mail.loongson.cn ([114.242.206.163]:49204 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729462AbgHYJkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 05:40:10 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxCMZo3ERfncENAA--.2579S2;
        Tue, 25 Aug 2020 17:39:53 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Takashi Iwai <tiwai@suse.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>, <stable@vger.kernel.org>
Subject: [PATCH v2] Revert "ALSA: hda: Add support for Loongson 7A1000 controller"
Date:   Tue, 25 Aug 2020 17:39:48 +0800
Message-Id: <1598348388-2518-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxCMZo3ERfncENAA--.2579S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW3Gr43KFW5XFyrAw4DXFb_yoW5Jw1fpw
        15Zr12yr4kKr4qqa15ta4Yvry8twnrAasrGrWxJw17ZFnrur18JryxZF4SkFs8urWrJFy7
        J34DtwsrWayDGw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
        xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUq38nUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 61eee4a7fc40 ("ALSA: hda: Add support for Loongson
7A1000 controller") to fix the following error on the Loongson LS7A
platform:

rcu: INFO: rcu_preempt self-detected stall on CPU
<SNIP>
NMI backtrace for cpu 0
CPU: 0 PID: 68 Comm: kworker/0:2 Not tainted 5.8.0+ #3
Hardware name:  , BIOS
Workqueue: events azx_probe_work [snd_hda_intel]
<SNIP>
Call Trace:
[<ffffffff80211a64>] show_stack+0x9c/0x130
[<ffffffff8065a740>] dump_stack+0xb0/0xf0
[<ffffffff80665774>] nmi_cpu_backtrace+0x134/0x140
[<ffffffff80665910>] nmi_trigger_cpumask_backtrace+0x190/0x200
[<ffffffff802b1abc>] rcu_dump_cpu_stacks+0x12c/0x190
[<ffffffff802b08cc>] rcu_sched_clock_irq+0xa2c/0xfc8
[<ffffffff802b91d4>] update_process_times+0x2c/0xb8
[<ffffffff802cad80>] tick_sched_timer+0x40/0xb8
[<ffffffff802ba5f0>] __hrtimer_run_queues+0x118/0x1d0
[<ffffffff802bab74>] hrtimer_interrupt+0x12c/0x2d8
[<ffffffff8021547c>] c0_compare_interrupt+0x74/0xa0
[<ffffffff80296bd0>] __handle_irq_event_percpu+0xa8/0x198
[<ffffffff80296cf0>] handle_irq_event_percpu+0x30/0x90
[<ffffffff8029d958>] handle_percpu_irq+0x88/0xb8
[<ffffffff80296124>] generic_handle_irq+0x44/0x60
[<ffffffff80b3cfd0>] do_IRQ+0x18/0x28
[<ffffffff8067ace4>] plat_irq_dispatch+0x64/0x100
[<ffffffff80209a20>] handle_int+0x140/0x14c
[<ffffffff802402e8>] irq_exit+0xf8/0x100

Because AZX_DRIVER_GENERIC can not work well for Loongson LS7A HDA
controller, it needs some workarounds which are not merged into the
upstream kernel at this time, so it should revert this patch now.

Fixes: 61eee4a7fc40 ("ALSA: hda: Add support for Loongson 7A1000 controller")
Cc: <stable@vger.kernel.org> # 5.9-rc1+
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---

v2: update commit message

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

