Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4507E25152F
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 11:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgHYJRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 05:17:50 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45318 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728245AbgHYJRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 05:17:49 -0400
Received: from localhost.localdomain (unknown [10.20.41.73])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxf8cs10RfZ78NAA--.460S3;
        Tue, 25 Aug 2020 17:17:33 +0800 (CST)
Subject: Re: [PATCH] Revert "ALSA: hda: Add support for Loongson 7A1000
 controller"
To:     Takashi Iwai <tiwai@suse.de>
References: <1598343903-2372-1-git-send-email-yangtiezhu@loongson.cn>
 <s5h4kor6sb4.wl-tiwai@suse.de>
Cc:     Takashi Iwai <tiwai@suse.com>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>, stable@vger.kernel.org
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <35883e9a-9d2a-624a-66c8-cace17ae6673@loongson.cn>
Date:   Tue, 25 Aug 2020 17:17:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <s5h4kor6sb4.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dxf8cs10RfZ78NAA--.460S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWFy3GFyrGry3Jryftw1DZFb_yoW5uw4Dpr
        y8Jr4UCw40qr17Gr1Yyrs8Jr97Kr4UA3WUJ348trn8ZF1UWr17Jw1UtFWUKr1DJr15try7
        J39rAF4rKryUG3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvS14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280
        aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43
        ZEXa7VUbKsjUUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/25/2020 04:30 PM, Takashi Iwai wrote:
> On Tue, 25 Aug 2020 10:25:03 +0200,
> Tiezhu Yang wrote:
>> This reverts commit 61eee4a7fc40 ("ALSA: hda: Add support for Loongson
>> 7A1000 controller").
>>
>> With this patch, there exists the following error on the Loongson LS7A
>> platform:
>>
>> [  216.639938] rcu: INFO: rcu_preempt self-detected stall on CPU
>> [  216.645685] rcu:     0-....: (1 GPs behind) idle=d5a/1/0x4000000000000004 softirq=562/563 fqs=16476
>> [  216.654565]  (t=53772 jiffies g=-463 q=11976)
>> [  216.658923] NMI backtrace for cpu 0
>> [  216.662417] CPU: 0 PID: 68 Comm: kworker/0:2 Not tainted 5.8.0+ #3
>> [  216.668587] Hardware name:  , BIOS
>> [  216.672174] Workqueue: events azx_probe_work [snd_hda_intel]
>> [  216.677829] Stack : 0000000000000000 0000000000000000 ffffffff95004ce0 d786f9efa2288403
>> [  216.685848]         d786f9efa2288403 0000000000000000 98000001102638c8 ffffffff80cee270
>> [  216.693866]         0000000000000000 0000000000000000 0000000000000000 00000000000002b4
>> [  216.701883]         206b726f775f6562 0000000000000001 0000000000000000 ffffffff80f30000
>> [  216.709902]         ffffffff80f30000 ffffffff80d90000 0000000000000000 0000000000000000
>> [  216.717919]         0000000000000000 0000000000000000 0000000000000000 ffffffff80d90000
>> [  216.725937]         ffffffff80d90000 0000000000000007 ffffffff806aff18 0000000000000000
>> [  216.733955]         ffffffff80f00000 9800000110cc4000 98000001102638c0 ffffffff80d9db80
>> [  216.741974]         ffffffff8065a740 0000000000000000 0000000000000000 0000000000000000
>> [  216.749991]         000073746e657665 0000000000000000 ffffffff80211a64 d786f9efa2288403
>> [  216.758009]         ...
>> [  216.760464] Call Trace:
>> [  216.762920] [<ffffffff80211a64>] show_stack+0x9c/0x130
>> [  216.768058] [<ffffffff8065a740>] dump_stack+0xb0/0xf0
>> [  216.773110] [<ffffffff80665774>] nmi_cpu_backtrace+0x134/0x140
>> [  216.778939] [<ffffffff80665910>] nmi_trigger_cpumask_backtrace+0x190/0x200
>> [  216.785805] [<ffffffff802b1abc>] rcu_dump_cpu_stacks+0x12c/0x190
>> [  216.791806] [<ffffffff802b08cc>] rcu_sched_clock_irq+0xa2c/0xfc8
>> [  216.797808] [<ffffffff802b91d4>] update_process_times+0x2c/0xb8
>> [  216.803724] [<ffffffff802cad80>] tick_sched_timer+0x40/0xb8
>> [  216.809293] [<ffffffff802ba5f0>] __hrtimer_run_queues+0x118/0x1d0
>> [  216.815380] [<ffffffff802bab74>] hrtimer_interrupt+0x12c/0x2d8
>> [  216.821208] [<ffffffff8021547c>] c0_compare_interrupt+0x74/0xa0
>> [  216.827124] [<ffffffff80296bd0>] __handle_irq_event_percpu+0xa8/0x198
>> [  216.833558] [<ffffffff80296cf0>] handle_irq_event_percpu+0x30/0x90
>> [  216.839732] [<ffffffff8029d958>] handle_percpu_irq+0x88/0xb8
>> [  216.845388] [<ffffffff80296124>] generic_handle_irq+0x44/0x60
>> [  216.851131] [<ffffffff80b3cfd0>] do_IRQ+0x18/0x28
>> [  216.855838] [<ffffffff8067ace4>] plat_irq_dispatch+0x64/0x100
>> [  216.861579] [<ffffffff80209a20>] handle_int+0x140/0x14c
>> [  216.866802] [<ffffffff802402e8>] irq_exit+0xf8/0x100
> Could you edit the Oops message to drop unnecessary hex numbers,
> timestamps, and whatever redundant for readers?

OK, thanks for your reply.
I will do it and then send v2 soon.

Thanks,
Tiezhu

>
>
> thanks,
>
> Takashi

