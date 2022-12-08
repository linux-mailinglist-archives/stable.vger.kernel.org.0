Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD78646803
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 04:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLHDw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 22:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLHDwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 22:52:47 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADFEE08B;
        Wed,  7 Dec 2022 19:52:43 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NSKx208Nrz4f3nq0;
        Thu,  8 Dec 2022 11:52:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAnmdaGX5Fj54VmBw--.53918S3;
        Thu, 08 Dec 2022 11:52:40 +0800 (CST)
Subject: Re: [PATCH 3/9] bfq: Split shared queues on move between cgroups
To:     Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20220330123438.32719-1-jack@suse.cz>
 <20220330124255.24581-3-jack@suse.cz>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <89941655-baeb-9696-dc89-0a1f4bc9e8d6@huaweicloud.com>
Date:   Thu, 8 Dec 2022 11:52:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220330124255.24581-3-jack@suse.cz>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnmdaGX5Fj54VmBw--.53918S3
X-Coremail-Antispam: 1UD129KBjvAXoW3uw1rWr48GFW7GFy5ur1rWFg_yoW8JrW8Zo
        W2qwnakF48CFn8AFW8AF4ktr17GrW0yFn7Cwn3ur18AryDJFWDAry3K3W0y3y8GrWFqF1r
        AryjgrWrAw1UJws5n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUU5i7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Jan!

ÔÚ 2022/03/30 20:42, Jan Kara Ð´µÀ:
> When bfqq is shared by multiple processes it can happen that one of the
> processes gets moved to a different cgroup (or just starts submitting IO
> for different cgroup). In case that happens we need to split the merged
> bfqq as otherwise we will have IO for multiple cgroups in one bfqq and
> we will just account IO time to wrong entities etc.
> 
> Similarly if the bfqq is scheduled to merge with another bfqq but the
> merge didn't happen yet, cancel the merge as it need not be valid
> anymore.
> 
> CC: stable@vger.kernel.org
> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   block/bfq-cgroup.c  | 36 +++++++++++++++++++++++++++++++++---
>   block/bfq-iosched.c |  2 +-
>   block/bfq-iosched.h |  1 +
>   3 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 420eda2589c0..9352f3cc2377 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -743,9 +743,39 @@ static struct bfq_group *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
>   	}
>   
>   	if (sync_bfqq) {
> -		entity = &sync_bfqq->entity;
> -		if (entity->sched_data != &bfqg->sched_data)
> -			bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> +		if (!sync_bfqq->new_bfqq && !bfq_bfqq_coop(sync_bfqq)) {
> +			/* We are the only user of this bfqq, just move it */
> +			if (sync_bfqq->entity.sched_data != &bfqg->sched_data)
> +				bfq_bfqq_move(bfqd, sync_bfqq, bfqg);
> +		} else {
> +			struct bfq_queue *bfqq;
> +
> +			/*
> +			 * The queue was merged to a different queue. Check
> +			 * that the merge chain still belongs to the same
> +			 * cgroup.
> +			 */
> +			for (bfqq = sync_bfqq; bfqq; bfqq = bfqq->new_bfqq)
> +				if (bfqq->entity.sched_data !=
> +				    &bfqg->sched_data)
> +					break;
> +			if (bfqq) {
> +				/*
> +				 * Some queue changed cgroup so the merge is
> +				 * not valid anymore. We cannot easily just
> +				 * cancel the merge (by clearing new_bfqq) as
> +				 * there may be other processes using this
> +				 * queue and holding refs to all queues below
> +				 * sync_bfqq->new_bfqq. Similarly if the merge
> +				 * already happened, we need to detach from
> +				 * bfqq now so that we cannot merge bio to a
> +				 * request from the old cgroup.
> +				 */
> +				bfq_put_cooperator(sync_bfqq);
> +				bfq_release_process_ref(bfqd, sync_bfqq);
> +				bic_set_bfqq(bic, NULL, 1);
> +			}
> +		}
>   	}
Our test found a use-after-free while accessing bfqq->bic->bfqq[] ([1]),
and I really suspect the above change.

1) init state, 2 thread, 2 bic, and 2 bfqq

bic1->bfqq = bfqq1
bfqq1->bic = bic1
bic2->bfqq = bfqq2
bfqq2->bic = bic2

2) bfqq1 and bfqq2 is merged
bic1->bfqq = bfqq2
bfqq1->bic = NULL
bic2->bfqq = bfqq2
bfqq2->bic = NULL

3) bfqq1 issue a io, before such io reaches bfq, move t1 to a new
cgroup, and issues a new io. If the new io reaches bfq first:
bic1->bfqq = NULL
bfqq1->bic = NULL
bic2->bfqq = bfqq2
bfqq2->bic = NULL

4) while handling the new io, a new bfqq is created
bic1->bfqq = bfqq3
bfqq3->bic = bic1
bic2->bfqq = bfqq2
bfqq2->bic = NULL

5) the old io reaches bfq, corresponding bic is got from rq:
bic1->bfqq = bfqq3
bfqq3->bic = bic1
bic2->bfqq = bfqq2
bfqq2->bic = bic1

Here comes up the problematic state, two different bfqq point to the
same bic. And furthermore, if t1 exit and all the io from t1 is done,
bic1 can be freed while bfqq2->bic still points to bic1.

I'm not quite sure about how the bic is working, but I think it make
sense to make sure that bfqq->bic never point to a bic that
corresponding thread doesn't match. Something like below:

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a72304c728fc..22bbc9d45ddf 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6757,7 +6757,8 @@ static struct bfq_queue *bfq_init_rq(struct 
request *rq)
          * addition, if the queue has also just been split, we have to
          * resume its state.
          */
-       if (likely(bfqq != &bfqd->oom_bfqq) && bfqq_process_refs(bfqq) 
== 1) {
+       if (likely(bfqq != &bfqd->oom_bfqq) && bfqq_process_refs(bfqq) 
== 1 &&
+           bfqq->org_bic == bic) {
                 bfqq->bic = bic;

[1]
[605854.098478] 
==================================================================
[605854.099367] BUG: KASAN: use-after-free in bfq_select_queue+0x378/0xa30
[605854.100133] Read of size 8 at addr ffff88810efb42d8 by task 
fsstress/2318352

[605854.101213] CPU: 6 PID: 2318352 Comm: fsstress Kdump: loaded Not 
tainted 5.10.0-60.18.0.50.h602.kasan.eulerosv2r11.x86_64 #1
[605854.101218] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS rel-1.12.1-0-ga5cab58-20220320_160524-szxrtosci10000 04/01/2014
[605854.101221] Call Trace:
[605854.101231]  dump_stack+0x9c/0xd3
[605854.101240]  print_address_description.constprop.0+0x19/0x170
[605854.101247]  ? bfq_select_queue+0x378/0xa30
[605854.101254]  __kasan_report.cold+0x6c/0x84
[605854.101261]  ? bfq_select_queue+0x378/0xa30
[605854.101267]  kasan_report+0x3a/0x50
[605854.101273]  bfq_select_queue+0x378/0xa30
[605854.101279]  ? bfq_bfqq_expire+0x6c0/0x6c0
[605854.101286]  ? bfq_mark_bfqq_busy+0x1f/0x30
[605854.101293]  ? _raw_spin_lock_irq+0x7b/0xd0
[605854.101299]  __bfq_dispatch_request+0x1c4/0x220
[605854.101306]  bfq_dispatch_request+0xe8/0x130
[605854.101313]  __blk_mq_do_dispatch_sched+0x3f4/0x560
[605854.101320]  ? blk_mq_sched_mark_restart_hctx+0x50/0x50
[605854.101326]  ? bfq_init_rq+0x128/0x940
[605854.101333]  ? pvclock_clocksource_read+0xf6/0x1d0
[605854.101339]  blk_mq_do_dispatch_sched+0x62/0xb0
[605854.101345]  __blk_mq_sched_dispatch_requests+0x215/0x2a0
[605854.101351]  ? blk_mq_do_dispatch_ctx+0x3a0/0x3a0
[605854.101358]  ? bfq_insert_request+0x193/0x3f0
[605854.101364]  blk_mq_sched_dispatch_requests+0x8f/0xd0
[605854.101370]  __blk_mq_run_hw_queue+0x98/0x180
[605854.101377]  __blk_mq_delay_run_hw_queue+0x22b/0x240
[605854.101383]  ? bfq_asymmetric_scenario+0x160/0x160
[605854.101389]  blk_mq_run_hw_queue+0xe3/0x190
[605854.101396]  ? bfq_insert_request+0x3f0/0x3f0
[605854.101401]  blk_mq_sched_insert_requests+0x107/0x200
[605854.101408]  blk_mq_flush_plug_list+0x26e/0x3c0
[605854.101415]  ? blk_mq_insert_requests+0x250/0x250
[605854.101422]  ? blk_check_plugged+0x190/0x190
[605854.101429]  blk_finish_plug+0x63/0x90
[605854.101436]  __iomap_dio_rw+0x7b5/0x910
[605854.101443]  ? iomap_dio_actor+0x150/0x150
[605854.101450]  ? userns_put+0x70/0x70
[605854.101456]  ? userns_put+0x70/0x70
[605854.101463]  ? avc_has_perm_noaudit+0x1d0/0x1d0
[605854.101468]  ? down_read+0xd5/0x1a0
[605854.101474]  ? down_read_killable+0x1b0/0x1b0
[605854.101479]  ? from_kgid+0xa0/0xa0
[605854.101485]  iomap_dio_rw+0x36/0x80
[605854.101544]  ext4_dio_read_iter+0x146/0x190 [ext4]
[605854.101602]  ext4_file_read_iter+0x1e2/0x230 [ext4]
[605854.101609]  new_sync_read+0x29f/0x400
[605854.101615]  ? default_llseek+0x160/0x160
[605854.101621]  ? find_isec_ns+0x8d/0x2e0
[605854.101627]  ? avc_policy_seqno+0x27/0x40
[605854.101633]  ? selinux_file_permission+0x34/0x180
[605854.101641]  ? security_file_permission+0x135/0x2b0
[605854.101648]  vfs_read+0x24e/0x2d0
[605854.101654]  ksys_read+0xd5/0x1b0
[605854.101661]  ? __ia32_sys_pread64+0x160/0x160
[605854.101667]  ? __audit_syscall_entry+0x1cc/0x220
[605854.101675]  do_syscall_64+0x33/0x40
[605854.101681]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[605854.101686] RIP: 0033:0x7ff05f96fe62
[605854.101705] Code: c0 e9 b2 fe ff ff 50 48 8d 3d 12 04 0c 00 e8 b5 fe 
01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 
05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[605854.101709] RSP: 002b:00007fffd30c0ff8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[605854.101717] RAX: ffffffffffffffda RBX: 00000000000000a5 RCX: 
00007ff05f96fe62
[605854.101721] RDX: 000000000001d000 RSI: 0000000001ffc000 RDI: 
0000000000000003
[605854.101724] RBP: 0000000000000003 R08: 0000000002019000 R09: 
0000000000000000
[605854.101729] R10: 00007ff05fa65290 R11: 0000000000000246 R12: 
0000000000131800
[605854.101732] R13: 000000000001d000 R14: 0000000000000000 R15: 
0000000001ffc000

[605854.102003] Allocated by task 2318348:
[605854.102489]  kasan_save_stack+0x1b/0x40
[605854.102495]  __kasan_kmalloc.constprop.0+0xb5/0xe0
[605854.102501]  kmem_cache_alloc_node+0x15d/0x480
[605854.102505]  ioc_create_icq+0x68/0x2e0
[605854.102510]  blk_mq_sched_assign_ioc+0xbc/0xd0
[605854.102516]  blk_mq_rq_ctx_init+0x4b0/0x600
[605854.102521]  __blk_mq_alloc_request+0x21f/0x2e0
[605854.102526]  blk_mq_submit_bio+0x27a/0xd60
[605854.102532]  __submit_bio_noacct_mq+0x10b/0x270
[605854.102538]  submit_bio_noacct+0x13d/0x150
[605854.102543]  submit_bio+0xbf/0x280
[605854.102548]  iomap_dio_submit_bio+0x155/0x180
[605854.102553]  iomap_dio_bio_actor+0x2f0/0x770
[605854.102557]  iomap_dio_actor+0xd9/0x150
[605854.102562]  iomap_apply+0x1d2/0x4f0
[605854.102567]  __iomap_dio_rw+0x43a/0x910
[605854.102572]  iomap_dio_rw+0x36/0x80
[605854.102628]  ext4_dio_write_iter+0x46f/0x730 [ext4]
[605854.102684]  ext4_file_write_iter+0xd8/0x100 [ext4]
[605854.102689]  new_sync_write+0x2ac/0x3a0
[605854.102701]  vfs_write+0x365/0x430
[605854.102707]  ksys_write+0xd5/0x1b0
[605854.102712]  do_syscall_64+0x33/0x40
[605854.102718]  entry_SYSCALL_64_after_hwframe+0x61/0xc6

[605854.102984] Freed by task 2320929:
[605854.103434]  kasan_save_stack+0x1b/0x40
[605854.103439]  kasan_set_track+0x1c/0x30
[605854.103444]  kasan_set_free_info+0x20/0x40
[605854.103449]  __kasan_slab_free+0x151/0x180
[605854.103454]  kmem_cache_free+0x9e/0x540
[605854.103461]  rcu_do_batch+0x292/0x700
[605854.103465]  rcu_core+0x270/0x2d0
[605854.103471]  __do_softirq+0xfd/0x402

[605854.103741] Last call_rcu():
[605854.104141]  kasan_save_stack+0x1b/0x40
[605854.104146]  kasan_record_aux_stack+0xa8/0xf0
[605854.104150]  __call_rcu+0xa4/0x3a0
[605854.104155]  ioc_release_fn+0x45/0x120
[605854.104161]  process_one_work+0x3c5/0x730
[605854.104167]  worker_thread+0x93/0x650
[605854.104172]  kthread+0x1ba/0x210
[605854.104178]  ret_from_fork+0x22/0x30

[605854.104440] Second to last call_rcu():
[605854.104930]  kasan_save_stack+0x1b/0x40
[605854.104935]  kasan_record_aux_stack+0xa8/0xf0
[605854.104939]  __call_rcu+0xa4/0x3a0
[605854.104944]  ioc_release_fn+0x45/0x120
[605854.104949]  process_one_work+0x3c5/0x730
[605854.104955]  worker_thread+0x93/0x650
[605854.104960]  kthread+0x1ba/0x210
[605854.104965]  ret_from_fork+0x22/0x30

[605854.105229] The buggy address belongs to the object at ffff88810efb42a0
                  which belongs to the cache bfq_io_cq of size 160
[605854.106659] The buggy address is located 56 bytes inside of
                  160-byte region [ffff88810efb42a0, ffff88810efb4340)
[605854.108021] The buggy address belongs to the page:
[605854.108608] page:00000000a519c14c refcount:1 mapcount:0 
mapping:0000000000000000 index:0xffff88810efb4000 pfn:0x10efb4
[605854.108612] head:00000000a519c14c order:1 compound_mapcount:0
[605854.108620] flags: 
0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
[605854.108628] raw: 0017ffffc0010200 0000000000000000 dead000000000122 
ffff8881407c8600
[605854.108635] raw: ffff88810efb4000 000000008024001a 00000001ffffffff 
0000000000000000
[605854.108639] page dumped because: kasan: bad access detected

[605854.108909] Memory state around the buggy address:
[605854.109494]  ffff88810efb4180: fc fc fc fc fc fc fc fc fb fb fb fb 
fb fb fb fb
[605854.110323]  ffff88810efb4200: fb fb fb fb fb fb fb fb fb fb fb fb 
fc fc fc fc
[605854.111151] >ffff88810efb4280: fc fc fc fc fa fb fb fb fb fb fb fb 
fb fb fb fb
[605854.111978]                                                     ^
[605854.112692]  ffff88810efb4300: fb fb fb fb fb fb fb fb fc fc fc fc 
fc fc fc fc
[605854.113522]  ffff88810efb4380: fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb fb
[605854.114350] 
==================================================================

