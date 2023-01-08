Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5E2661490
	for <lists+stable@lfdr.de>; Sun,  8 Jan 2023 11:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjAHKr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Jan 2023 05:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjAHKr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 05:47:27 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D1310B78;
        Sun,  8 Jan 2023 02:47:25 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.41]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N5G1V-1opPKp0zOX-011AXO; Sun, 08 Jan 2023 11:47:14 +0100
Message-ID: <a5a32db9-21a1-1734-1c4f-88b9431d7aa8@i2se.com>
Date:   Sun, 8 Jan 2023 11:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] usb: misc: onboard_hub: Move 'attach' work to the
 driver
Content-Language: en-US
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Matthias Kaehlcke <mka@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
References: <20230105230119.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
 <20230105230119.2.I16b51f32db0c32f8a8532900bfe1c70c8572881a@changeid>
 <d606398d-8569-5695-5fd7-038977c83eb4@i2se.com>
In-Reply-To: <d606398d-8569-5695-5fd7-038977c83eb4@i2se.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zTeUPxs3brbn2qNaZKQn2+f6WKnabOwUy5qOXpwp/sBn/zacQvq
 AIMkeaXB+r7KV+V8sEX5U9LfZfIIFYKl/3vmPdSIjbEcyhxcPIMXFJdSahmp6YQEouh4eH2
 Wrp1zOdkJ+AWpjPLCbgJV3PRUVmr4TOJD0Exi670rLXA4mjjf0+MOVskGVSpJm7jYkpgHsa
 DIoFTPx8Od4QO/r4DIyKw==
UI-OutboundReport: notjunk:1;M01:P0:egx/Qr3tUvM=;AoCxTyUUstKMkc6DczcdTyKvS2D
 dAOcLG68lomGPhz9luKVxNv1Fpu/zXi4CFQncnWqcaIIg7NFIOTaIGC0Y1SzW1Hm7qqhCouES
 0+RecBmtszsVCylCxOBAopuR27yPZl4lVdpVm4ctonhC8Nujpf/KLXT5aryvyoiED+V0dEHoj
 qSZrQC9m4vSjv05TNvcR4MqUGZPZy2ycyXeE2iQ+z3lQniUn1N6WNO7gptHSEY/Pf4irmlqf8
 rd0MoCXkgS4dzA6PSDj5K+4+cgxZ0Y0L6eFF/uQmRlHrDL6+nxnMvUyucfb1Xq8vrY8VBqOuy
 CNDloQBlu1FbUTYOSRA9d7K0cdTD1Fp30Yhzsj3g1IO4nraeHR6ljCs2Rl5l1J799IHaHrMkt
 6YCz7CCniT4MBiVp62uJA/ujYm+azdRRAeliCiqlfQOXMXZ8shiYP0Eqydgkl2HMQUATqWhXr
 9DzOtqLq4K4mIHjyfTBFmFenw2OPTe0yZqbR8mAGbDXYwy4H4xIVkGPJOVNmO/qwc2CfY+fgy
 g5bYfntdX9yAX5T3vnoFaWudZSbZMogiM7dcdWVKX22PBfbjMNc2GSEpXrAoLe8P5HWvevOz0
 ECG2MF6SpSdXXjt+QnhzsNdOaOjM67GSS9YCw66RJR+ZZF8WGEla4+iyC0evKgU5jkRTPKNnV
 p2Zazlj0SbU1OQ+MKAVyx5W12Q5eN8UZRmRKDW+eDg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 07.01.23 um 18:23 schrieb Stefan Wahren:
> Hi Matthias,
>
> Am 06.01.23 um 00:03 schrieb Matthias Kaehlcke:
>> Currently each onboard_hub platform device owns an 'attach' work,
>> which is scheduled when the device probes. With this deadlocks
>> have been reported on a Raspberry Pi 3 B+ [1], which has nested
>> onboard hubs.
>>
>> The flow of the deadlock is something like this (with the onboard_hub
>> driver built as a module) [2]:
>>
>> - USB root hub is instantiated
>> - core hub driver calls onboard_hub_create_pdevs(), which creates the
>>    'raw' platform device for the 1st level hub
>> - 1st level hub is probed by the core hub driver
>> - core hub driver calls onboard_hub_create_pdevs(), which creates
>>    the 'raw' platform device for the 2nd level hub
>>
>> - onboard_hub platform driver is registered
>> - platform device for 1st level hub is probed
>>    - schedules 'attach' work
>> - platform device for 2nd level hub is probed
>>    - schedules 'attach' work
>>
>> - onboard_hub USB driver is registered
>> - device (and parent) lock of hub is held while the device is
>>    re-probed with the onboard_hub driver
>>
>> - 'attach' work (running in another thread) calls driver_attach(), which
>>     blocks on one of the hub device locks
>>
>> - onboard_hub_destroy_pdevs() is called by the core hub driver when one
>>    of the hubs is detached
>> - destroying the pdevs invokes onboard_hub_remove(), which waits for the
>>    'attach' work to complete
>>    - waits forever, since the 'attach' work can't acquire the device 
>> lock
>>
>> Use a single work struct for the driver instead of having a work struct
>> per onboard hub platform driver instance. With that it isn't necessary
>> to cancel the work in onboard_hub_remove(), which fixes the deadlock.
>> The work is only cancelled when the driver is unloaded.
>
> i applied both patches for this series on top of v6.1 
> (multi_v7_defconfig), but usb is still broken on Raspberry Pi 3 B+

here is the hung task output:

[  243.682193] INFO: task kworker/1:0:18 blocked for more than 122 seconds.
[  243.682222]       Not tainted 6.1.0-00002-gaa61d98d165b #2
[  243.682233] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  243.682242] task:kworker/1:0     state:D stack:0     pid:18 
ppid:2      flags:0x00000000
[  243.682267] Workqueue: events onboard_hub_attach_usb_driver 
[onboard_usb_hub]
[  243.682317]  __schedule from schedule+0x4c/0xe0
[  243.682345]  schedule from schedule_preempt_disabled+0xc/0x10
[  243.682367]  schedule_preempt_disabled from 
__mutex_lock.constprop.0+0x244/0x804
[  243.682394]  __mutex_lock.constprop.0 from __driver_attach+0x7c/0x188
[  243.682421]  __driver_attach from bus_for_each_dev+0x70/0xb0
[  243.682449]  bus_for_each_dev from 
onboard_hub_attach_usb_driver+0xc/0x28 [onboard_usb_hub]
[  243.682494]  onboard_hub_attach_usb_driver [onboard_usb_hub] from 
process_one_work+0x1ec/0x4d0
[  243.682534]  process_one_work from worker_thread+0x50/0x540
[  243.682559]  worker_thread from kthread+0xd0/0xec
[  243.682582]  kthread from ret_from_fork+0x14/0x2c
[  243.682600] Exception stack(0xf086dfb0 to 0xf086dff8)
[  243.682615] dfa0:                                     00000000 
00000000 00000000 00000000
[  243.682631] dfc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[  243.682646] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  243.682692] INFO: task kworker/1:2:82 blocked for more than 122 seconds.
[  243.682703]       Not tainted 6.1.0-00002-gaa61d98d165b #2
[  243.682713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  243.682721] task:kworker/1:2     state:D stack:0     pid:82 
ppid:2      flags:0x00000000
[  243.682741] Workqueue: events_power_efficient hub_init_func2
[  243.682764]  __schedule from schedule+0x4c/0xe0
[  243.682785]  schedule from schedule_preempt_disabled+0xc/0x10
[  243.682808]  schedule_preempt_disabled from 
__mutex_lock.constprop.0+0x244/0x804
[  243.682833]  __mutex_lock.constprop.0 from hub_activate+0x584/0x8b0
[  243.682859]  hub_activate from process_one_work+0x1ec/0x4d0
[  243.682883]  process_one_work from worker_thread+0x50/0x540
[  243.682907]  worker_thread from kthread+0xd0/0xec
[  243.682927]  kthread from ret_from_fork+0x14/0x2c
[  243.682944] Exception stack(0xf1509fb0 to 0xf1509ff8)
[  243.682958] 9fa0:                                     00000000 
00000000 00000000 00000000
[  243.682974] 9fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[  243.682988] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  243.683023] INFO: task kworker/1:4:257 blocked for more than 122 seconds.
[  243.683034]       Not tainted 6.1.0-00002-gaa61d98d165b #2
[  243.683043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  243.683051] task:kworker/1:4     state:D stack:0     pid:257 
ppid:2      flags:0x00000000
[  243.683071] Workqueue: events_power_efficient hub_init_func2
[  243.683092]  __schedule from schedule+0x4c/0xe0
[  243.683113]  schedule from schedule_preempt_disabled+0xc/0x10
[  243.683135]  schedule_preempt_disabled from 
__mutex_lock.constprop.0+0x244/0x804
[  243.683160]  __mutex_lock.constprop.0 from hub_activate+0x584/0x8b0
[  243.683184]  hub_activate from process_one_work+0x1ec/0x4d0
[  243.683209]  process_one_work from worker_thread+0x50/0x540
[  243.683233]  worker_thread from kthread+0xd0/0xec
[  243.683253]  kthread from ret_from_fork+0x14/0x2c
[  243.683270] Exception stack(0xf09d9fb0 to 0xf09d9ff8)
[  243.683283] 9fa0:                                     00000000 
00000000 00000000 00000000
[  243.683299] 9fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[  243.683313] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000

>
> Best regards
>
>>
>> [1] 
>> https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
>> [2] https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
>> Link: 
>> https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
>> Link: https://lore.kernel.org/all/Y6OrGbqaMy2iVDWB@google.com/
>> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> ---
>>
>>   drivers/usb/misc/onboard_usb_hub.c | 19 +++++++++++++------
>>   1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/usb/misc/onboard_usb_hub.c 
>> b/drivers/usb/misc/onboard_usb_hub.c
>> index db0844b30bbd..8bc4deb465f0 100644
>> --- a/drivers/usb/misc/onboard_usb_hub.c
>> +++ b/drivers/usb/misc/onboard_usb_hub.c
>> @@ -27,7 +27,10 @@
>>     #include "onboard_usb_hub.h"
>>   +static void onboard_hub_attach_usb_driver(struct work_struct *work);
>> +
>>   static struct usb_device_driver onboard_hub_usbdev_driver;
>> +static DECLARE_WORK(attach_usb_driver_work, 
>> onboard_hub_attach_usb_driver);
>>     /************************** Platform driver 
>> **************************/
>>   @@ -45,7 +48,6 @@ struct onboard_hub {
>>       bool is_powered_on;
>>       bool going_away;
>>       struct list_head udev_list;
>> -    struct work_struct attach_usb_driver_work;
>>       struct mutex lock;
>>   };
>>   @@ -270,9 +272,15 @@ static int onboard_hub_probe(struct 
>> platform_device *pdev)
>>        *
>>        * This needs to be done deferred to avoid self-deadlocks on 
>> systems
>>        * with nested onboard hubs.
>> +     *
>> +     * If the work is already running wait for it to complete, then
>> +     * schedule it again to ensure that the USB devices of this onboard
>> +     * hub instance are bound to the USB driver.
>>        */
>> -    INIT_WORK(&hub->attach_usb_driver_work, 
>> onboard_hub_attach_usb_driver);
>> -    schedule_work(&hub->attach_usb_driver_work);
>> +    while (work_busy(&attach_usb_driver_work) & WORK_BUSY_RUNNING)
>> +        msleep(10);
>> +
>> +    schedule_work(&attach_usb_driver_work);
>>         return 0;
>>   }
>> @@ -285,9 +293,6 @@ static int onboard_hub_remove(struct 
>> platform_device *pdev)
>>         hub->going_away = true;
>>   -    if (&hub->attach_usb_driver_work != current_work())
>> -        cancel_work_sync(&hub->attach_usb_driver_work);
>> -
>>       mutex_lock(&hub->lock);
>>         /* unbind the USB devices to avoid dangling references to 
>> this device */
>> @@ -449,6 +454,8 @@ static void __exit onboard_hub_exit(void)
>>   {
>> usb_deregister_device_driver(&onboard_hub_usbdev_driver);
>>       platform_driver_unregister(&onboard_hub_driver);
>> +
>> +    cancel_work_sync(&attach_usb_driver_work);
>>   }
>>   module_exit(onboard_hub_exit);
