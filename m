Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE31410CEA
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 20:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhISShw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 14:37:52 -0400
Received: from mail.ispras.ru ([83.149.199.84]:39514 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISShw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Sep 2021 14:37:52 -0400
Received: from [192.168.1.41] (unknown [109.252.87.67])
        by mail.ispras.ru (Postfix) with ESMTPSA id AB7D740D4004;
        Sun, 19 Sep 2021 18:36:20 +0000 (UTC)
Subject: Re: [PATCH 5.10 033/306] cpufreq: schedutil: Use kobject release()
 method to free sugov_tunables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kevin Hao <haokexin@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <20210916155753.903069397@linuxfoundation.org>
 <20210916155755.075805845@linuxfoundation.org>
 <bb93bcd1-b9b3-fc11-0321-7be6eee5beb0@intel.com> <YUN89bXPrsLsTAYB@kroah.com>
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
Autocrypt: addr=khoroshilov@ispras.ru; prefer-encrypt=mutual; keydata=
 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
 kK2E04Fb+Zk1eJvHYRc=
Message-ID: <175d4888-1147-9a2f-32d6-7c90c2628af5@ispras.ru>
Date:   Sun, 19 Sep 2021 21:36:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YUN89bXPrsLsTAYB@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.09.2021 20:20, Greg Kroah-Hartman wrote:
> On Thu, Sep 16, 2021 at 06:12:44PM +0200, Rafael J. Wysocki wrote:
>> On 9/16/2021 5:56 PM, Greg Kroah-Hartman wrote:
>>> From: Kevin Hao <haokexin@gmail.com>
>>>
>>> commit e5c6b312ce3cc97e90ea159446e6bfa06645364d upstream.
>>>
>>> The struct sugov_tunables is protected by the kobject, so we can't free
>>> it directly. Otherwise we would get a call trace like this:
>>>    ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x30
>>>    WARNING: CPU: 3 PID: 720 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
>>>    Modules linked in:
>>>    CPU: 3 PID: 720 Comm: a.sh Tainted: G        W         5.14.0-rc1-next-20210715-yocto-standard+ #507
>>>    Hardware name: Marvell OcteonTX CN96XX board (DT)
>>>    pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
>>>    pc : debug_print_object+0xb8/0x100
>>>    lr : debug_print_object+0xb8/0x100
>>>    sp : ffff80001ecaf910
>>>    x29: ffff80001ecaf910 x28: ffff00011b10b8d0 x27: ffff800011043d80
>>>    x26: ffff00011a8f0000 x25: ffff800013cb3ff0 x24: 0000000000000000
>>>    x23: ffff80001142aa68 x22: ffff800011043d80 x21: ffff00010de46f20
>>>    x20: ffff800013c0c520 x19: ffff800011d8f5b0 x18: 0000000000000010
>>>    x17: 6e6968207473696c x16: 5f72656d6974203a x15: 6570797420746365
>>>    x14: 6a626f2029302065 x13: 303378302f307830 x12: 2b6e665f72656d69
>>>    x11: ffff8000124b1560 x10: ffff800012331520 x9 : ffff8000100ca6b0
>>>    x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 0000000000000001
>>>    x5 : ffff800011d8c000 x4 : ffff800011d8c740 x3 : 0000000000000000
>>>    x2 : ffff0001108301c0 x1 : ab3c90eedf9c0f00 x0 : 0000000000000000
>>>    Call trace:
>>>     debug_print_object+0xb8/0x100
>>>     __debug_check_no_obj_freed+0x1c0/0x230
>>>     debug_check_no_obj_freed+0x20/0x88
>>>     slab_free_freelist_hook+0x154/0x1c8
>>>     kfree+0x114/0x5d0
>>>     sugov_exit+0xbc/0xc0
>>>     cpufreq_exit_governor+0x44/0x90
>>>     cpufreq_set_policy+0x268/0x4a8
>>>     store_scaling_governor+0xe0/0x128
>>>     store+0xc0/0xf0
>>>     sysfs_kf_write+0x54/0x80
>>>     kernfs_fop_write_iter+0x128/0x1c0
>>>     new_sync_write+0xf0/0x190
>>>     vfs_write+0x2d4/0x478
>>>     ksys_write+0x74/0x100
>>>     __arm64_sys_write+0x24/0x30
>>>     invoke_syscall.constprop.0+0x54/0xe0
>>>     do_el0_svc+0x64/0x158
>>>     el0_svc+0x2c/0xb0
>>>     el0t_64_sync_handler+0xb0/0xb8
>>>     el0t_64_sync+0x198/0x19c
>>>    irq event stamp: 5518
>>>    hardirqs last  enabled at (5517): [<ffff8000100cbd7c>] console_unlock+0x554/0x6c8
>>>    hardirqs last disabled at (5518): [<ffff800010fc0638>] el1_dbg+0x28/0xa0
>>>    softirqs last  enabled at (5504): [<ffff8000100106e0>] __do_softirq+0x4d0/0x6c0
>>>    softirqs last disabled at (5483): [<ffff800010049548>] irq_exit+0x1b0/0x1b8
>>>
>>> So split the original sugov_tunables_free() into two functions,
>>> sugov_clear_global_tunables() is just used to clear the global_tunables
>>> and the new sugov_tunables_free() is used as kobj_type::release to
>>> release the sugov_tunables safely.
>>>
>>> Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
>>> Cc: 4.7+ <stable@vger.kernel.org> # 4.7+
>>> Signed-off-by: Kevin Hao <haokexin@gmail.com>
>>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>   kernel/sched/cpufreq_schedutil.c |   16 +++++++++++-----
>>>   1 file changed, 11 insertions(+), 5 deletions(-)
>>>
>>> --- a/kernel/sched/cpufreq_schedutil.c
>>> +++ b/kernel/sched/cpufreq_schedutil.c
>>> @@ -610,9 +610,17 @@ static struct attribute *sugov_attrs[] =
>>>   };
>>>   ATTRIBUTE_GROUPS(sugov);
>>> +static void sugov_tunables_free(struct kobject *kobj)
>>> +{
>>> +	struct gov_attr_set *attr_set = container_of(kobj, struct gov_attr_set, kobj);
>>> +
>>> +	kfree(to_sugov_tunables(attr_set));
>>> +}
>>> +
>>>   static struct kobj_type sugov_tunables_ktype = {
>>>   	.default_groups = sugov_groups,
>>>   	.sysfs_ops = &governor_sysfs_ops,
>>> +	.release = &sugov_tunables_free,
>>>   };
>>>   /********************** cpufreq governor interface *********************/
>>> @@ -712,12 +720,10 @@ static struct sugov_tunables *sugov_tuna
>>>   	return tunables;
>>>   }
>>> -static void sugov_tunables_free(struct sugov_tunables *tunables)
>>> +static void sugov_clear_global_tunables(void)
>>>   {
>>>   	if (!have_governor_per_policy())
>>>   		global_tunables = NULL;
>>> -
>>> -	kfree(tunables);
>>>   }
>>>   static int sugov_init(struct cpufreq_policy *policy)
>>> @@ -780,7 +786,7 @@ out:
>>>   fail:
>>>   	kobject_put(&tunables->attr_set.kobj);
>>>   	policy->governor_data = NULL;
>>> -	sugov_tunables_free(tunables);
>>> +	sugov_clear_global_tunables();
>>>   stop_kthread:
>>>   	sugov_kthread_stop(sg_policy);
>>> @@ -807,7 +813,7 @@ static void sugov_exit(struct cpufreq_po
>>>   	count = gov_attr_set_put(&tunables->attr_set, &sg_policy->tunables_hook);
>>>   	policy->governor_data = NULL;
>>>   	if (!count)
>>> -		sugov_tunables_free(tunables);
>>> +		sugov_clear_global_tunables();
>>>   	mutex_unlock(&global_tunables_lock);
>>>
>>>
>> Please defer this one.
>>
>> It uncovers a bug in cpufreq that needs to be fixed separately.
> 
> Now dropped from all queues, thanks!
> 
> greg k-h
> 

Hi Greg,

I am trying to get familiar with stable release process, because we
would like to start testing stable release candidates. But I cannot get
all the nuances how to get automatically information regarding rc code
ready to be tested.

Also I wonder how we could automatically detect situations when stable
release is expected to became diverged from the rc, e.g. like
[PATCH 5.10 033/306] cpufreq: schedutil: Use kobject release() method to
free sugov_tunables
was dropped from 5.10.67 without announcing the 5.10.67-rc2?

Any suggestions are appreciated.

Best regards,
Alexey Khoroshilov,
Linux Verification Center, ISPRAS

