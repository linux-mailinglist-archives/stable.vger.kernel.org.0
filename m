Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F251BB26
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 18:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbfEMQlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 12:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbfEMQlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 12:41:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D472084E;
        Mon, 13 May 2019 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557765661;
        bh=z2nY4PqK998hnVfcOEshBMYqpLqdsTjrZu4GVVYQteE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iVDSpidIKANfGQqtt3ZtJUqlGDJE0KggG7Mslt/GxyYWV1nw/dbzBGsX7rXu2zcNZ
         8EknEhl3iqkqP0Kcm70VkYbVgW1jKbRq3HTQhCF3bXUtFKcuJAw0rlns/txTX/grIV
         chF/xpOzEyQobS5tvSSOdPn+1uC0z0TdzvhAeQHg=
Date:   Mon, 13 May 2019 12:41:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Tomer Tayar <ttayar@habana.ai>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] habanalabs: Avoid using a non-initialized MMU cache mutex
Message-ID: <20190513164100.GE11972@sasha-vm>
References: <20190513113237.22425-1-oded.gabbay@gmail.com>
 <20190513141010.8EC6820862@mail.kernel.org>
 <CAFCwf10Ve9jpDZ8LnvFr=85ytHN8nhyBu9YJft0acTy5q3V_rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFCwf10Ve9jpDZ8LnvFr=85ytHN8nhyBu9YJft0acTy5q3V_rg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 05:22:30PM +0300, Oded Gabbay wrote:
>On Mon, May 13, 2019 at 5:10 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: all
>>
>> The bot has tested the following trees: v5.0.15, v4.19.42, v4.14.118, v4.9.175, v4.4.179, v3.18.139.
>>
>> v5.0.15: Failed to apply! Possible dependencies:
>>     0861e41de530 ("habanalabs: add context and ASID modules")
>>     839c48030d27 ("habanalabs: add basic Goya h/w initialization")
>>     9494a8dd8d22 ("habanalabs: add h/w queues module")
>>     99b9d7b4970c ("habanalabs: add basic Goya support")
>>     be5d926b5c10 ("habanalabs: add command buffer module")
>>     c4d66343a46a ("habanalabs: add skeleton driver")
>>     d91389bc839d ("habanalabs: add sysfs and hwmon support")
>>     eff6f4a0e70b ("habanalabs: add command submission module")
>>
>> v4.19.42: Failed to apply! Possible dependencies:
>>     0861e41de530 ("habanalabs: add context and ASID modules")
>>     839c48030d27 ("habanalabs: add basic Goya h/w initialization")
>>     9494a8dd8d22 ("habanalabs: add h/w queues module")
>>     99b9d7b4970c ("habanalabs: add basic Goya support")
>>     be5d926b5c10 ("habanalabs: add command buffer module")
>>     c4d66343a46a ("habanalabs: add skeleton driver")
>>     fcb418cd567f ("pvpanic: move pvpanic to misc as common driver")
>>
>> v4.14.118: Failed to apply! Possible dependencies:
>>     01451ad47e27 ("powerpc/powermac: Use setup_timer() helper")
>>     8275b77a1513 ("mfd: rts5249: Add support for RTS5250S power saving")
>>     83ad1e6a1dc0 ("powerpc/oprofile: Use setup_timer() helper")
>>     8d6b1bf20f61 ("powerpc/6xx: Use setup_timer() helper")
>>     9494a8dd8d22 ("habanalabs: add h/w queues module")
>>     b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
>>     b9eaf1872222 ("treewide: init_timer() -> setup_timer()")
>>     be5d926b5c10 ("habanalabs: add command buffer module")
>>     c4d66343a46a ("habanalabs: add skeleton driver")
>>     cd414f3d9316 ("drm/msm: Move memptrs to msm_gpu")
>>     e455b69ddf9b ("misc: rtsx: Move Realtek Card Reader Driver to misc")
>>     e629cfa36ea0 ("MIPS: Lasat: Use setup_timer() helper")
>>     e99e88a9d2b0 ("treewide: setup_timer() -> timer_setup()")
>>     f97decac5f4c ("drm/msm: Support multiple ringbuffers")
>>
>> v4.9.175: Failed to apply! Possible dependencies:
>>     01451ad47e27 ("powerpc/powermac: Use setup_timer() helper")
>>     118f6523793d ("mfd: rtsx: Convert forgotten dev_info() statement to pcr_dbg()")
>>     53460c53b761 ("[media] au0828: Add timer to restart TS stream if no data arrives on bulk endpoint")
>>     7c96f59e0caf ("[media] s5p-mfc: Fix initialization of internal structures")
>>     8275b77a1513 ("mfd: rts5249: Add support for RTS5250S power saving")
>>     83ad1e6a1dc0 ("powerpc/oprofile: Use setup_timer() helper")
>>     87d284443d07 ("mfd: rtsx: Do retry when DMA transfer error")
>>     8d6b1bf20f61 ("powerpc/6xx: Use setup_timer() helper")
>>     9494a8dd8d22 ("habanalabs: add h/w queues module")
>>     b9eaf1872222 ("treewide: init_timer() -> setup_timer()")
>>     be5d926b5c10 ("habanalabs: add command buffer module")
>>     c4d66343a46a ("habanalabs: add skeleton driver")
>>     cf43e6be865a ("block: add scalable completion tracking of requests")
>>     e26ae3660b9c ("mfd: rtsx: Make arrays depth and cd_mask static const")
>>     e455b69ddf9b ("misc: rtsx: Move Realtek Card Reader Driver to misc")
>>     e629cfa36ea0 ("MIPS: Lasat: Use setup_timer() helper")
>>     e806402130c9 ("block: split out request-only flags into a new namespace")
>>     e99e88a9d2b0 ("treewide: setup_timer() -> timer_setup()")
>>
>> v4.4.179: Failed to apply! Possible dependencies:
>>     118f6523793d ("mfd: rtsx: Convert forgotten dev_info() statement to pcr_dbg()")
>>     53460c53b761 ("[media] au0828: Add timer to restart TS stream if no data arrives on bulk endpoint")
>>     7c96f59e0caf ("[media] s5p-mfc: Fix initialization of internal structures")
>>     80c1bce9aa31 ("[media] au0828: Refactoring for start_urb_transfer()")
>>     8275b77a1513 ("mfd: rts5249: Add support for RTS5250S power saving")
>>     87d284443d07 ("mfd: rtsx: Do retry when DMA transfer error")
>>     9494a8dd8d22 ("habanalabs: add h/w queues module")
>>     9815c7cf22da ("NFC: pn533: Separate physical layer from the core implementation")
>>     b9eaf1872222 ("treewide: init_timer() -> setup_timer()")
>>     be5d926b5c10 ("habanalabs: add command buffer module")
>>     c4d66343a46a ("habanalabs: add skeleton driver")
>>     e26ae3660b9c ("mfd: rtsx: Make arrays depth and cd_mask static const")
>>     e455b69ddf9b ("misc: rtsx: Move Realtek Card Reader Driver to misc")
>>     e99e88a9d2b0 ("treewide: setup_timer() -> timer_setup()")
>>
>> v3.18.139: Failed to apply! Possible dependencies:
>>     0523b8f41473 ("mfd: rtsx: Using pcr_dbg replace dev_dbg")
>>     0b271258544b ("mfd: rt5033: Add Richtek RT5033 driver core.")
>>     19f3bd548f27 ("mfd: rtsx: Remove LCTLR defination")
>>     338a12814297 ("mfd: Add support for Diolan DLN-2 devices")
>>     5cb5d9616a47 ("mfd: rtsx: Fix PM suspend for 5227 & 5249")
>>     663c425f2c8d ("mfd: rtsx: Add support for rts524A")
>>     8275b77a1513 ("mfd: rts5249: Add support for RTS5250S power saving")
>>     9494a8dd8d22 ("habanalabs: add h/w queues module")
>>     9e33ce79f828 ("mfd: rtsx: Update PETXCFG address")
>>     a3b63979f8a3 ("mfd: rtsx: Add func to split u32 into register")
>>     b038538104d5 ("mfd: rtsx: Update phy register")
>>     b158b69a3765 ("mfd: rtsx: Simplify function return logic")
>>     be5d926b5c10 ("habanalabs: add command buffer module")
>>     c4d66343a46a ("habanalabs: add skeleton driver")
>>     ce6a5acc9387 ("mfd: rtsx: Add support for rts522A")
>>     e455b69ddf9b ("misc: rtsx: Move Realtek Card Reader Driver to misc")
>>     e89f231826a7 ("mfd: rtsx: Update driving settings")
>>
>>
>> How should we proceed with this patch?
>>
>> --
>> Thanks,
>> Sasha
>
>ok, I see my mistake.
>How do I specify a specific kernel version ?
>Because this applies only to future 5.1.X, that aren't available yet.

Take a look at
https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst

A "Fixes" tag also helps a lot.

--
Thanks,
Sasha
