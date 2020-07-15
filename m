Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DEE220F69
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGOOen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 10:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbgGOOen (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 10:34:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 367702065D;
        Wed, 15 Jul 2020 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594823682;
        bh=LrWUkleHxZV4c+Di+w1VVzb6X+CPgI6RtdSaLqqPXCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=umBRMvjgol0MNMeEYw91XA59Oyz8fUvDWT9IMOt5qmPRHHGZQSwBiXyhC+kkMbEr9
         YvYahzKUL6OtUZUg2mAAgKDwxI3MmM1VPNYyQXygqttfaohKm4tc2SAkCFy3OeR3ZI
         q2SkD42+7y1wMDvKv67qzFV/FUyPIl5uOUeVuOX0=
Date:   Wed, 15 Jul 2020 10:34:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.7.9-rc1-c2fb28a.cki (stable)
Message-ID: <20200715143441.GM2722994@sasha-vm>
References: <cki.9BE0703C38.BLD1GT3V8U@redhat.com>
 <2125467353.2778784.1594820204666.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2125467353.2778784.1594820204666.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 09:36:44AM -0400, Veronika Kabatova wrote:
>
>
>----- Original Message -----
>> From: "CKI Project" <cki-project@redhat.com>
>> To: "Linux Stable maillist" <stable@vger.kernel.org>
>> Cc: "Xiong Zhou" <xzhou@redhat.com>
>> Sent: Wednesday, July 15, 2020 3:33:45 PM
>> Subject: 💥 PANICKED: Test report for kernel 5.7.9-rc1-c2fb28a.cki (stable)
>>
>>
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>        Kernel repo:
>>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>             Commit: c2fb28a4b6e4 - Linux 5.7.9-rc1
>>
>> The results of these automated tests are provided below.
>>
>>     Overall result: FAILED (see details below)
>>              Merge: OK
>>            Compile: OK
>>              Tests: PANICKED
>>
>> All kernel binaries, config files, and logs are available for download here:
>>
>>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/07/14/610210
>>
>> One or more kernel tests failed:
>>
>>     s390x:
>>      ❌ Boot test
>>      ❌ Boot test
>>      💥 Boot test
>>
>
>Hi,
>
>we started observing boot panics with 5.7 on s390x yesterday:
>
>[    0.388965] Kernel panic - not syncing: Corrupted kernel text
>[    0.388970] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.7.8-0930ce5.cki #1
>[    0.388971] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)
>[    0.388975] Workqueue: events timer_update_keys
>[    0.388977] Call Trace:
>[    0.388980]  [<00000001378c868a>] show_stack+0x8a/0xd0
>[    0.388983]  [<0000000137e0c9c2>] dump_stack+0x8a/0xb8
>[    0.388985]  [<00000001378fa372>] panic+0x112/0x308
>[    0.388989]  [<00000001378d20b6>] jump_label_bug+0x7e/0x80
>[    0.388990]  [<00000001378d1fb8>] __jump_label_transform+0xa8/0xd8
>[    0.388992]  [<00000001378d200e>] arch_jump_label_transform+0x26/0x40
>[    0.388995]  [<0000000137a8d448>] __jump_label_update+0xb8/0x128
>[    0.388996]  [<0000000137a8dca6>] static_key_enable_cpuslocked+0x8e/0xd0
>[    0.388998]  [<0000000137a8dd18>] static_key_enable+0x30/0x40
>[    0.389000]  [<000000013798a0d2>] timer_update_keys+0x3a/0x50
>[    0.389003]  [<000000013791cdde>] process_one_work+0x206/0x458
>[    0.389005]  [<000000013791d078>] worker_thread+0x48/0x460
>[    0.389007]  [<0000000137924912>] kthread+0x12a/0x160
>[    0.389013]  [<00000001381b9a70>] ret_from_fork+0x2c/0x30
>
>I only released one of the reports to not spam too much but the panics are
>still happening with the most recent code.
>
>These panics are NOT present on the current mainline. All other arches are OK.
>
>Given the call trace, I'm guessing it is something related to
>
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.7.y&id=477d4930b0c7e70c1ac3e3c35e5ad15c5ebde8be

Indeed, looks like we were missing d6df52e9996d ("s390/maccess: add no
DAT mode to kernel_write").

I also took cb2cceaefb4c ("s390: Change s390_kernel_write() return type
to match memcpy()") as a dependency.

Thank you!

-- 
Thanks,
Sasha
