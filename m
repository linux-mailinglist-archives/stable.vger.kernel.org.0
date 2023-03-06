Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A79B6AB985
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 10:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCFJSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 04:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjCFJSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 04:18:08 -0500
X-Greylist: delayed 2399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Mar 2023 01:17:59 PST
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECC219F33;
        Mon,  6 Mar 2023 01:17:59 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4PVW2n60fsz9xqd4;
        Mon,  6 Mar 2023 15:50:25 +0800 (CST)
Received: from [10.221.98.77] (unknown [10.221.98.77])
        by APP2 (Coremail) with SMTP id GxC2BwCXHWQlnQVkniR0AQ--.130S2;
        Mon, 06 Mar 2023 08:58:44 +0100 (CET)
Message-ID: <6b6bd9fb-32dd-343f-1791-c6637b52caf9@huaweicloud.com>
Date:   Mon, 6 Mar 2023 08:58:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: lock_torture results for different patches:
Content-Language: en-US
To:     Antonio Paolillo <antonio.paolillo@huawei.com>, longman@redhat.com
Cc:     David.Laight@ACULAB.COM, akpm@osdl.org, arjan@linux.intel.com,
        boqun.feng@gmail.com, diogo.behrens@huawei.com,
        hernanl.leon@huawei.com, joel@joelfernandes.org,
        jonas.oberhauser@huawei.com, jonas.oberhauser@huaweicloud.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, will@kernel.org
References: <4122ef0d-1508-8ce2-df80-874565a612ce@redhat.com>
 <20230301163214.17530-1-antonio.paolillo@huawei.com>
From:   Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
In-Reply-To: <20230301163214.17530-1-antonio.paolillo@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: GxC2BwCXHWQlnQVkniR0AQ--.130S2
X-Coremail-Antispam: 1UD129KBjvJXoW3GrykZrWkXFW5Kr17urW7urg_yoWxZw18pF
        WjyF1ava1qq34fZ3yvyF40qayqvrZ7JF4UGrW5Kr92k3Z8K34ftr1SkFs2kF4kZrs7WF17
        XrZ0vw18Aa4qyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
        WrylIxkvb40EIxkG14v26r4j6ryUMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
        0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWr
        Zr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
        1UYxBIdaVFxhVjvjDU0xZFpf9x07Ut-B_UUUUU=
X-CM-SenderInfo: xkhu0tnqos00pfhgvzhhrqqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Antonio for the performance results. Taking both correctness and 
performance into consideration, this is my current understanding of the 
situation.

Removing the acquire barrier does not improve performance and while it 
might be unnecessary, it seems better to play it safe and keep it. That 
being said, a comment about this should be added to the code (Paul 
suggested something like this at some point).

Neither of the proposed fixes to the data race significantly affect 
performance. Using READ_ONCE shows better performance in the AMD 
machine, but using atomic_long_or shows the opposite in the HiSilicon 
one. However, the difference is more prominent using READ_ONCE.

I am not sure I got David's comment. Are you proposing to change the 
definition of rt_mutex_base to

struct rt_mutex_base {
	raw_spinlock_t		wait_lock;
	struct rb_root_cached   waiters;
	/* This the waiting task_struct | RT_MUTEX_HAS_WAITERS. */
	atomic_long_t 		*owner;
};

I don't fully understand the consequences of this. At minimum this would 
require changes in several methods such as the one below, right?

static __always_inline bool rt_mutex_cmpxchg_release(struct 
rt_mutex_base *lock,
						     atomic_long_t  *old,
						     atomic_long_t  *new)

Is there anything else that I am missing?

Hernan

On 3/1/2023 5:32 PM, Antonio Paolillo wrote:
> Dear all,
> 
> I want to provide some support to Hernan regarding performance claims.
> 
> I used lock_torture to evaluate the different proposed patches on two
> different server machines:
> - a Huawei TaiShan 200 (Model 2280) rack server that has 128 GB of RAM
>    and 2x Kunpeng 920-4826 processors, a HiSilicon chip with 48 ARMv8.2
>    64-bit cores totaling 96 cores (no SMT) [1, 2],
>    denoted as taishan200-96c;
> - a GIGABYTE R182-Z91-00 rack server that has 128 GB of RAM and 2x
>    EPYC 7352 processors, an AMD chip with 24 x86_64 cores, totaling 48
>    cores (96 CPUs when counting hyperthreading) [3, 4],
>    denoted as gigabyte-96c.
> 
> I ran the evaluation on a Ubuntu 22.04 distro, with custom kernels based
> on v6.2-rc6 (6d796c50f84ca79f1722bb131799e5a5710c4700).
> The different kernels are combination of patches:
> - (0) Stock kernel;
> - (1) With relaxed set owner barrier (as discussed in [5] and questioned
>    by Peter, the barrier seems not to be needed);
> - (2) With READ_ONCE(), as originally proposed in this thread;
> - (3) With atomic_long_or() as proposed by Peter;
> - (4) With relaxed set owner barrier and READ_ONCE();
> - (5) With relaxed set owner barrier and atomic_long_or().
> 
> I ran lock_torture several times, exploring the following parameter
> space:
> - torture_type="rtmutex_lock",
> - nwriters_stress=[1, 2, 3, 4, 8, 16, 32, 64, 95],
> - stat_interval=4,
> - stutter=0,
> - shuffle_interval=0.
> For each value of "nwriters_stress", I ran the configuration 5 times.
> 
> By feeding the lock_torture kthread pids to "taskset -p", I overruled
> the scheduling such that the distribution of kthreads to CPUs is fixed.
> I also disabled "irq balance" and "numa balance" daemons, fixed the
> frequency to 1.5GHz using the "userspace" cpufreq governor and isolated
> all the cores used (using isolcpus=1-95 at boot-time) to avoid any
> source of interference.
> 
> As a warm-up phase, I ignored the first reported results and only
> considered the latest 60 seconds of execution (after all kthreads
> migrated to their final CPU).
> The reported throughput is computed by dividing the reported number of
> operations by the duration of the measurement for each dot (60 seconds),
> so higher is better.
> 
> Here follows the results on taishan200-96c (the 'rel' column is the mean
> relative to the mean of the stock kernel, in percent, and each mean is
> the average over 5 independent runs):
> 
> Kernel:             k0-stock-6.2.0-rc6       k1-rmacq             k2-readonce             k3-alongor             k4-rmacq+readonce             k5-rmacq+alongor
> Statistic (kops/s):               mean   std     mean   std   rel        mean   std   rel       mean   std   rel              mean   std   rel             mean   std   rel
> nwriters_stress:
> 1                               899.91 24.95   880.10 29.62   -2%      871.57 44.27   -3%     888.65 37.90   -1%            898.63 29.82   -0%           889.83 25.64   -1%
> 2                               359.30 25.92   416.83 32.77  +16%      360.65 28.32   +0%     404.79 42.64  +13%            380.65 21.29   +6%           404.37 23.27  +13%
> 3                               314.97 24.32   308.41  9.68   -2%      315.00  9.97   +0%     313.86 13.47   -0%            313.47  4.01   -0%           322.77 20.82   +2%
> 4                               328.02 15.09   330.65 29.33   +1%      314.83 24.28   -4%     305.71 12.72   -7%            322.95 10.39   -2%           343.32 13.73   +5%
> 8                               292.16 22.03   288.85 10.50   -1%      288.28 18.84   -1%     285.42 24.58   -2%            310.23 26.08   +6%           285.67 20.03   -2%
> 16                              297.03 26.89   281.89 29.22   -5%      265.19 33.73  -11%     279.02 22.43   -6%            284.40 36.21   -4%           285.21 36.33   -4%
> 32                              187.36 28.59   175.71 19.77   -6%      186.44 48.15   -0%     206.59 14.11  +10%            174.08 24.30   -7%           185.80 45.12   -1%
> 64                              148.13 48.65   172.48 34.29  +16%      154.59 47.05   +4%     164.22 29.81  +11%            142.13 47.40   -4%           136.39 29.95   -8%
> 95                              174.35 57.89   148.59 38.03  -15%      156.85 43.64  -10%     132.92 32.35  -24%            126.44 28.24  -27%           146.82 60.04  -16%
> 
> And the results on gigabyte-96c:
> 
> Kernel:             k0-stock-6.2.0-rc6       k1-rmacq               k2-readonce             k3-alongor             k4-rmacq+readonce             k5-rmacq+alongor
> Statistic (kops/s):               mean   std     mean    std    rel        mean   std   rel       mean   std   rel              mean   std   rel             mean    std  rel
> nwriters_stress:
> 1                               713.72 25.68   707.32  17.73    -1%      718.81 12.63   +1%     712.80 13.57   -0%            709.17 14.10   -1%           730.33   9.14  +2%
> 2                               376.25  8.19   400.09  16.24    +6%      396.71 26.09   +5%     412.61 17.80  +10%            396.48  7.02   +5%           409.90  14.61  +9%
> 3                               415.07 16.83   410.19  19.82    -1%      423.39  9.68   +2%     417.28 10.23   +1%            424.94 17.48   +2%           422.92  11.75  +2%
> 4                               286.77 26.63   285.13   6.80    -1%      297.33 23.62   +4%     296.49 16.60   +3%            303.99 30.38   +6%           296.93   9.90  +4%
> 8                               296.56 20.45   308.97  12.53    +4%      305.49 19.91   +3%     294.24 17.24   -1%            294.71 24.03   -1%           294.09  25.20  -1%
> 16                              257.34 33.94   266.03  29.60    +3%      270.72 35.22   +5%     252.28 50.16   -2%            263.83 45.84   +3%           247.42  41.01  -4%
> 32                              278.78 51.45   215.35  68.40   -23%      259.77 87.44   -7%     217.26 79.67  -22%            201.23 70.46  -28%           282.47 116.65  +1%
> 64                               75.82 64.87   194.52 137.19  +157%       35.57 12.14  -53%      74.24 72.04   -2%             71.29 45.55   -6%            77.93  43.57  +3%
> 95                               60.37 68.13   198.38 116.93  +229%       43.12 17.60  -29%      58.80 36.47   -3%             57.78 63.00   -4%            61.33  71.18  +2%
> 
> We can safely conclude that the patches do not significatively affect
> the throughput of the lock_torture benchmark for rtmutex_lock.
> The values for nwriters_stress>=64 can safely be ignored as they are too
> spread.
> 
> Please notice that I pushed a landing page [6] with results in HTML that
> may be more convenient to browse together with interactive charts.
> 
> Cheers,
> 
> Antonio
> 
> [1] https://e.huawei.com/uk/products/servers/taishan-server/taishan-2280-v2
> [2] https://en.wikichip.org/wiki/hisilicon/kunpeng/920-4826
> [3] https://www.gigabyte.com/Rack-Server/R182-Z91-rev-100
> [4] https://www.amd.com/en/products/cpu/amd-epyc-7352
> [5] https://lkml.org/lkml/2023/1/22/160
> [6] https://antonio.paolillo.be/public/rtlocks-locktorture-patches.html

