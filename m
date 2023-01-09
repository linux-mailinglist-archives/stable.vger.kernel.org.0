Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B6E66314D
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 21:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbjAIUTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 15:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbjAIUTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 15:19:17 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C1934D5B;
        Mon,  9 Jan 2023 12:19:15 -0800 (PST)
Received: from [192.168.1.139] ([37.4.248.41]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MfYHW-1oZJ8B2UkC-00fwYV; Mon, 09 Jan 2023 21:19:03 +0100
Message-ID: <09d76f45-9dfe-19a0-33ec-badaac280772@i2se.com>
Date:   Mon, 9 Jan 2023 21:19:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] usb: misc: onboard_hub: Move 'attach' work to the
 driver
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
References: <20230105230119.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
 <20230105230119.2.I16b51f32db0c32f8a8532900bfe1c70c8572881a@changeid>
 <d606398d-8569-5695-5fd7-038977c83eb4@i2se.com>
 <a5a32db9-21a1-1734-1c4f-88b9431d7aa8@i2se.com> <Y7xRjDAgI3UO8Xuv@google.com>
Content-Language: en-US
From:   Stefan Wahren <stefan.wahren@i2se.com>
In-Reply-To: <Y7xRjDAgI3UO8Xuv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8fVqNUrQuoY97iqfAMNpGZm04anZZNms9TcTmwFD1iOPW1aikC9
 B5+n4AhII3gxiZQynPBodjLnIRNy92oH2B5c0sd+r5SyAzZSMswLThCluIkA8oryntJdARl
 xuL1TUxDjupEZJ3Z0h5Tq2giK985lxjl9DctW/Ikpsm7t2E7gb6DjhU6PbBiJWrau8q9GNQ
 puMOWlN5lBUuZjNLpAD5A==
UI-OutboundReport: notjunk:1;M01:P0:TntHzEeApJ8=;Fmr8AJgxW8SpO09Rq8RNDNnlsDb
 Jmi4LyzEQN3RW4K66wYz9O9cpzyIBOWoOnS6xwYeiReo1B0c+bfU1Ql/K4dlPXO/Dev+CdkEO
 z9uKqE4I/xzn93OtjkCa1ibq8nbKw/J/g6zoaxPKKJ66lY8o8Kzn8JNZJG78OW8G5ARnwqhyq
 fqDsrsOM+AH5l7NevMVt4PxOp2Q7krZ+Ig83UPbvpUOlO4lNKYiy1HNV/pjmHlQSTaqTvju7n
 Y3IiBpENjFM32dba/dEsjbG9QFQpdiCnprpfikhINMUX+6wL2SiVowWsQu57yh61F5Uh3TNOl
 dq2l7tQv3b3QSRaboYtkt1SSKE/UesNHsXY8zH/TUPg951Sm6T+qSQUnRKK+up3GZp32WPXMr
 GTWXN5QXuS/W7pFeZE3g3DioQi6No4fox+dG0sDxPJDK8Ot75n3olauAWJ3DluA3p+4mlY5Eg
 mw2zXd5O7p8OH6dcnjnyIjLCGa/vCThNnjxaH/8HVKPFxrbQMHLkaqwbiHyz8eFFYikOP3G2m
 uLHGcHOwyuclJHbwr7onjuEYDRgUO33vqDoDd/iI4hp3uL43h7LF3tqhrembQSqJwicUMiQJC
 gIHltgV7UXf04STjRMfjVukXjfBVUxIxGyO2rjm83Ilc6EwFtHUj4ip+aFI8tvYCNjA55HERQ
 /wWH8vO/62mspsyvrkXZRwy2tYkCUxBhmMGu+Oxlcw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Matthias,

Am 09.01.23 um 18:40 schrieb Matthias Kaehlcke:
> On Sun, Jan 08, 2023 at 11:47:13AM +0100, Stefan Wahren wrote:
>> Am 07.01.23 um 18:23 schrieb Stefan Wahren:
>>> Hi Matthias,
>>>
>>> Am 06.01.23 um 00:03 schrieb Matthias Kaehlcke:
>>>> Currently each onboard_hub platform device owns an 'attach' work,
>>>> which is scheduled when the device probes. With this deadlocks
>>>> have been reported on a Raspberry Pi 3 B+ [1], which has nested
>>>> onboard hubs.
>>>>
>>>> The flow of the deadlock is something like this (with the onboard_hub
>>>> driver built as a module) [2]:
>>>>
>>>> - USB root hub is instantiated
>>>> - core hub driver calls onboard_hub_create_pdevs(), which creates the
>>>>     'raw' platform device for the 1st level hub
>>>> - 1st level hub is probed by the core hub driver
>>>> - core hub driver calls onboard_hub_create_pdevs(), which creates
>>>>     the 'raw' platform device for the 2nd level hub
>>>>
>>>> - onboard_hub platform driver is registered
>>>> - platform device for 1st level hub is probed
>>>>     - schedules 'attach' work
>>>> - platform device for 2nd level hub is probed
>>>>     - schedules 'attach' work
>>>>
>>>> - onboard_hub USB driver is registered
>>>> - device (and parent) lock of hub is held while the device is
>>>>     re-probed with the onboard_hub driver
>>>>
>>>> - 'attach' work (running in another thread) calls driver_attach(), which
>>>>      blocks on one of the hub device locks
>>>>
>>>> - onboard_hub_destroy_pdevs() is called by the core hub driver when one
>>>>     of the hubs is detached
>>>> - destroying the pdevs invokes onboard_hub_remove(), which waits for the
>>>>     'attach' work to complete
>>>>     - waits forever, since the 'attach' work can't acquire the device
>>>> lock
>>>>
>>>> Use a single work struct for the driver instead of having a work struct
>>>> per onboard hub platform driver instance. With that it isn't necessary
>>>> to cancel the work in onboard_hub_remove(), which fixes the deadlock.
>>>> The work is only cancelled when the driver is unloaded.
>>> i applied both patches for this series on top of v6.1
>>> (multi_v7_defconfig), but usb is still broken on Raspberry Pi 3 B+
> Thanks for testing.
>
>> here is the hung task output:
>>
>> [  243.682193] INFO: task kworker/1:0:18 blocked for more than 122 seconds.
>> [  243.682222]       Not tainted 6.1.0-00002-gaa61d98d165b #2
>> [  243.682233] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
>> this message.
>> [  243.682242] task:kworker/1:0     state:D stack:0     pid:18 ppid:2
>> flags:0x00000000
>> [  243.682267] Workqueue: events onboard_hub_attach_usb_driver
>> [onboard_usb_hub]
>> [  243.682317]  __schedule from schedule+0x4c/0xe0
>> [  243.682345]  schedule from schedule_preempt_disabled+0xc/0x10
>> [  243.682367]  schedule_preempt_disabled from
>> __mutex_lock.constprop.0+0x244/0x804
>> [  243.682394]  __mutex_lock.constprop.0 from __driver_attach+0x7c/0x188
>> [  243.682421]  __driver_attach from bus_for_each_dev+0x70/0xb0
>> [  243.682449]  bus_for_each_dev from onboard_hub_attach_usb_driver+0xc/0x28
>> [onboard_usb_hub]
>> [  243.682494]  onboard_hub_attach_usb_driver [onboard_usb_hub] from
>> process_one_work+0x1ec/0x4d0
>> [  243.682534]  process_one_work from worker_thread+0x50/0x540
>> [  243.682559]  worker_thread from kthread+0xd0/0xec
>> [  243.682582]  kthread from ret_from_fork+0x14/0x2c
>> [  243.682600] Exception stack(0xf086dfb0 to 0xf086dff8)
>> [  243.682615] dfa0:                                     00000000 00000000
>> 00000000 00000000
>> [  243.682631] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [  243.682646] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> [  243.682692] INFO: task kworker/1:2:82 blocked for more than 122 seconds.
>> [  243.682703]       Not tainted 6.1.0-00002-gaa61d98d165b #2
>> [  243.682713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
>> this message.
>> [  243.682721] task:kworker/1:2     state:D stack:0     pid:82 ppid:2
>> flags:0x00000000
>> [  243.682741] Workqueue: events_power_efficient hub_init_func2
>> [  243.682764]  __schedule from schedule+0x4c/0xe0
>> [  243.682785]  schedule from schedule_preempt_disabled+0xc/0x10
>> [  243.682808]  schedule_preempt_disabled from
>> __mutex_lock.constprop.0+0x244/0x804
>> [  243.682833]  __mutex_lock.constprop.0 from hub_activate+0x584/0x8b0
>> [  243.682859]  hub_activate from process_one_work+0x1ec/0x4d0
>> [  243.682883]  process_one_work from worker_thread+0x50/0x540
>> [  243.682907]  worker_thread from kthread+0xd0/0xec
>> [  243.682927]  kthread from ret_from_fork+0x14/0x2c
>> [  243.682944] Exception stack(0xf1509fb0 to 0xf1509ff8)
>> [  243.682958] 9fa0:                                     00000000 00000000
>> 00000000 00000000
>> [  243.682974] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [  243.682988] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> [  243.683023] INFO: task kworker/1:4:257 blocked for more than 122 seconds.
>> [  243.683034]       Not tainted 6.1.0-00002-gaa61d98d165b #2
>> [  243.683043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
>> this message.
>> [  243.683051] task:kworker/1:4     state:D stack:0     pid:257 ppid:2
>> flags:0x00000000
>> [  243.683071] Workqueue: events_power_efficient hub_init_func2
>> [  243.683092]  __schedule from schedule+0x4c/0xe0
>> [  243.683113]  schedule from schedule_preempt_disabled+0xc/0x10
>> [  243.683135]  schedule_preempt_disabled from
>> __mutex_lock.constprop.0+0x244/0x804
>> [  243.683160]  __mutex_lock.constprop.0 from hub_activate+0x584/0x8b0
>> [  243.683184]  hub_activate from process_one_work+0x1ec/0x4d0
>> [  243.683209]  process_one_work from worker_thread+0x50/0x540
>> [  243.683233]  worker_thread from kthread+0xd0/0xec
>> [  243.683253]  kthread from ret_from_fork+0x14/0x2c
>> [  243.683270] Exception stack(0xf09d9fb0 to 0xf09d9ff8)
>> [  243.683283] 9fa0:                                     00000000 00000000
>> 00000000 00000000
>> [  243.683299] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000
>> [  243.683313] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> Does commenting the following help:
>
>    while (work_busy(&attach_usb_driver_work) & WORK_BUSY_RUNNING)
>        msleep(10);
>
> ?
Yes, it does. I restarted the board multiple times and it never hang :-)
