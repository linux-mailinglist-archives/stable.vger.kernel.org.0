Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F19E1AA9D2
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 16:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgDOOV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732547AbgDOOVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 10:21:49 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F707C061A0E
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 07:21:49 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t40so6750235pjb.3
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 07:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OCcAwVGuCEITH/LUwnqu7+KO2LN2oxkVTv+lIo1EwMw=;
        b=Wwv9BHQhSoRzN8onZGRRuLbpOb9ZdyYThlye6e8+6ok3LHQs9nqNo7Q/jCo5PyaWNo
         2KRgPSrvVBxoK+3Pwz2QKCePW9uV0Cqpfm4kW7QNoC5BM3QgsE8UCPGoTPVbTrZ5TIJn
         oICuxU0DHVprvUfeqYh4n8y/DTcp7Cgd60zjPfN5tgPooJy61h+SB6l2A3LZtkjsafat
         Gi7BJamZpEZmdEQ9ynVCt0JbGN6LrX41snLt9o19dUIIWxU9GnQ2ddye89xEfVsoxf5V
         sBn914Av7baP/yTeHPsvpiUh879FvLci3K/MqZshKEL3EtWjTFkEOvO0iHsqEnItwApS
         dlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OCcAwVGuCEITH/LUwnqu7+KO2LN2oxkVTv+lIo1EwMw=;
        b=IE49yDAPsJ1t7AhGbIlXR4BtGo8/RP9qXZsfGnsim6D0HttRQMe8kTePm3kba7bNvn
         9EYAza57Vi3HQB7ymiHZFtO6vor1yuMQchASrgXhD7XcPArlzZeS/e8vpxJF0ztRxKts
         H2/UMnKVUukgq1/ImnbOQWOs0pfiAsfQqFWySOYbye6lfKo61fTrcea3lYDWAlSMBrFX
         tNeNE7y0nN0neVQdHHVn9rtozCJh69//44WhiXOnQyA/O21H9RIEYCEWSnKkLkm1qyOP
         KyrUIJa7we05+YtzUpkxHZoDel65RMEzWo+8T/wuv2Uw6cZ3KSg93Vl9/Ur/mbL8jPMk
         PhYQ==
X-Gm-Message-State: AGi0PubGQdevcmK/KigwElv9Z4RFgeXEvgD4bXdb8k8dwhXB6yJxtUOK
        gDd5N36jL2xGIy7UaQ3mjksMk8I+
X-Google-Smtp-Source: APiQypK65oluRJ1z50LSx1mrH6sMGpProlVigMXnl+aYiM0AktRfSXB/aqslyoF+NH/TRgpRVoRP5g==
X-Received: by 2002:a17:90b:430f:: with SMTP id ih15mr6565393pjb.56.1586960508376;
        Wed, 15 Apr 2020 07:21:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z1sm3392048pjt.42.2020.04.15.07.21.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:21:47 -0700 (PDT)
Subject: Re: Patches to apply to stable releases
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <20200415003148.GA114493@roeck-us.net>
 <20200415101542.GD2568572@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <6d358d6a-3b7b-25c6-7990-5b36dd4c2d0b@roeck-us.net>
Date:   Wed, 15 Apr 2020 07:21:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200415101542.GD2568572@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/20 3:15 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 14, 2020 at 05:31:48PM -0700, Guenter Roeck wrote:
>> Upstream commit 538d92912d31 ("xen-netfront: Rework the fix for Rx stall during OOM and network stress")
>>     Fixes: 90c311b0eeea ("xen-netfront: Fix Rx stall during network stress and OOM")
>>     in linux-4.4.y: 230fe9c7d814
>>     Applies to:
>>         v4.4.y
> 
> Now queued up.
> 
>> Upstream commit 183ab39eb0ea ("ALSA: hda: Initialize power_state field properly")
>>     Fixes: 98081ca62cba ("ALSA: hda - Record the current power state before suspend/resume calls")
>>     in linux-4.4.y: 2569eed24d93
>>     in linux-4.9.y: 5ee86945565e
>>     in linux-4.14.y: 886e8316b599
>>     Applies to:
>>         v4.4.y, v4.9.y, v4.14.y
> 
> Now queued up.
> 
>> Upstream commit 24e52b11e0ca ("Btrfs: incremental send, fix invalid memory access")
>>     Fixes: e1cbfd7bf6da ("Btrfs: send, fix file hole not being preserved due to inline extent")
>>     in linux-4.4.y: 266bbc907c3f
>>     Applies to:
>>         v4.4.y
> 
> Now queued up.
> 
>> Upstream commit 1f80bd6a6cc8 ("IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush")
>>     Fixes: b4b678b06f6e ("IB/ipoib: Grab rtnl lock on heavy flush when calling ndo_open/stop")
>>     in linux-4.4.y: 26c66554d7bf
>>     Applies to:
>>         v4.4.y
> 
> ChromeOS cares about IB devices?  That's funny...
> 

No, it doesn't, but the script doesn't know that, and if a patch
applies cleanly I add it to the list anyway.

> Anyway, now queued up.
> 
>> Upstream commit 56a49d704870 ("net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags")
>>     Fixes: 5025f7f7d506 ("rtnetlink: add rtnl_link_state check in rtnl_configure_link")
>>     in linux-4.14.y: 23557c5d34b9
>>     Applies to:
>>         v4.14.y
> 
> Nice catch, now queued up.
> 
>> Upstream commit 11dd34f3eae5 ("powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()")
>>     Fixes: c6c26fb55e8e ("powerpc/pseries: Export raw per-CPU VPA data via debugfs")
>>     in linux-4.14.y: 27b1ef75f579
>>     in linux-4.19.y: ee35e01b0f08
>>     Applies to:
>>         v4.14.y, v4.19.y
> 
> Also needed in 5.4.y, thanks.
> 
Sorry, script didn't tell me. See below for reason/details.

>> Upstream commit 34d66caf251d ("x86/speculation: Remove redundant arch_smt_update() invocation")
>>     Fixes: a74cfffb03b7 ("x86/speculation: Rework SMT state change")
>>     in linux-4.14.y: 36a4c5fc9285
>>     in linux-4.19.y: f55e301ec4d5
>>     Applies to:
>>         v4.14.y, v4.19.y
> 
> 4.9.y and 4.4.y also need this.  4.9.y was simple, ugh, 4.4.y doesn't
> care about speculation issues so I didn't attempt the backport.
> 
Yes, that may happen. I only list it if it applies cleanly.
I can add a note in the future that it would be needed but require
a backport.

>> Upstream commit cc41f11a21a5 ("scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug")
>>     Fixes: c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
>>     in linux-4.14.y: 3748694f1b91
>>     Applies to:
>>         v4.14.y
> 
> This also belongs to 4.19.y, 5.4.y, 5.5.y, and 5.6.y as it is cc:
> stable.  But it doesn't backport cleanly to all, so I need a working
> backport in order to be able to take it...
> 
I tracked this one down. The offending patch (c666d3be99c0) was applied
to v4.16 and to v4.14.y. The script takes that as clue to request a backport;
it assumes that the normal stable processs (whatever you and Sasha run to
identify patches to apply) takes care of more recent releases, and doesn't
look into those. This is intentional. We can change it, but I don't really
want to duplicate your and Sasha's work.

Oops, and I completely forgot about 5.5 and 5.6. The script doesn't tell
me (and neither about 4.9) because there is no such Chrome OS release,
so I have to check those manually.

Either case, the patch applies cleanly to 4.19.y and later for me.
Did you see conflicts, or build problems, when trying to apply it ?

Note that we don't really care about mpt3sas; missing that patch
is not a problem for us. My qemu emulations test basic mpt3sas
operation, but not unplug situations, so I would not miss the patch
there either. So feel free to ignore/drop if it causes issues.

>> Upstream commit 82f04bfe2aff ("tools: gpio: Fix out-of-tree build regression")
>>     Fixes: 0161a94e2d1c ("tools: gpio: Correctly add make dependencies for gpio_utils")
>>     in linux-4.14.y: f71e52cb3270
>>     in linux-4.19.y: 036588ec6888
>>     Applies to:
>>         v4.14.y, v4.19.y
> 
> Also belongs to 4.9.y, 5.6.y, 5.5.y, and 5.4.y.  Also has a cc: stable
> that I hadn't gotten to yet, now applied.
> 
The offending patch (0161a94e2d1c) is in 5.4, and thus the script assumes
that the normal stable process would take care of it. Same situation as
above. And I forgot to check 4.9, sorry.

>> Upstream commit 3e487d2e4aa4 ("PCI: pciehp: Fix indefinite wait on sysfs requests")
>>     Fixes: 157c1062fcd8 ("PCI: pciehp: Avoid returning prematurely from sysfs requests")
>>     in linux-4.19.y: 248e65f3220e
>>     in linux-5.4.y: 9bd9d123399b
>>     Applies to:
>>         v4.19.y, v5.4.y
> 
> Already queued up yesterday, and to 5.5.y and 5.6.y.
> 
>> Upstream commit 8644772637de ("mm: Use fixed constant in page_frag_alloc instead of size + 1")
>>     Fixes: 2c2ade81741c ("mm: page_alloc: fix ref bias in page_frag_alloc() for 1-byte allocs")
>>     in linux-4.14.y: a977209627ca
>>     in linux-4.19.y: 33e83ea302c0
>>     Applies to:
>>         v4.14.y, v4.19.y
> 
> Also needed in 4.9.y, now queued up.
> 
>> Upstream commit 2abb5792387e ("net: qualcomm: rmnet: Allow configuration updates to existing devices")
>>     Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
>>     in linux-4.19.y: 48c5bfbbcec1
>>     in linux-5.4.y: 835bbd892683
>>     Applies to:
>>         v4.19.y, v5.4.y
> 
> Normally I wait for DavidM to send me these as they are also applicable
> to 5.6.y and 5.5.y.  Now queued up.
> 
>> Upstream commit 36eb7dc1bd42 ("cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL")
>>     Fixes: 2733fb0d0699 ("cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull")
>>     in linux-4.19.y: 4ef576e99d29
>>     Applies to:
>>         v4.19.y
> 
> Queued up yesterday.
> 
>> Upstream commit 4c7eeb9af3e4 ("arm64: dts: allwinner: h6: Fix PMU compatible")
>>     Fixes: 7aa9b9eb7d6a ("arm64: dts: allwinner: H6: Add PMU mode")
>>     in linux-4.19.y: 8f1046b33f1b
>>     in linux-5.4.y: 02dfae36b03f
>>     Applies to:
>>         v4.19.y, v5.4.y
> 
> Also needed in 5.5.y and 5.6.y.
> 
>> Upstream commit ae769d355664 ("ALSA: pcm: oss: Fix regression by buffer overflow fix")
>>     Fixes: f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
>>     in linux-4.14.y: 5ac3462e1921
>>     in linux-4.19.y: 8c5bd5520334
>>     in linux-5.4.y: 07ec940ceda5
>>     Applies to:
>>         v4.14.y, v4.19.y, v5.4.y
> 
> Already queued up yesterday all the way back to 4.4.y and 4.9.y as well
> because f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
> went that far back.  Did your scripts miss that?
> 
It was dropped from 4.4 because it causes a conflict when trying to apply
it to chromeos-4.4. I'll see what I can do about that.

>> Upstream commit 82e0516ce3a1 ("sched/core: Remove duplicate assignment in sched_tick_remote()")
>>     Fixes: ebc0f83c78a2 ("timers/nohz: Update NOHZ load in remote tick")
>>     in linux-5.4.y: 166d6008fa2a
>>     Applies to:
>>         v5.4.y
> 
> Also applied to 5.5.y and 5.6.y
> 
>> Upstream commit 4ae7a3c3d7d3 ("arm64: dts: allwinner: h5: Fix PMU compatible")
>>     Fixes: c35a516a4618 ("arm64: dts: allwinner: H5: Add PMU node")
>>     in linux-5.4.y: 5a241d7bf1e6
>>     Applies to:
>>         v5.4.y
> 
> Also applied to 5.5.y and 5.6.y
> 
>> Upstream commit 9b8b17541f13 ("mm, memcg: do not high throttle allocators based on wraparound")
>>     Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
>>     in linux-5.4.y: 61cfbcce9e09
>>     Applies to:
>>         v5.4.y
> 
> Hadn't gotten to it yet, also queued up for 5.5.y and 5.6.y
> 
>> Upstream commit 8c5c66052920 ("nvme-fc: Revert "add module to ops template to allow module references"")
>>     Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module references")
>>     in linux-4.14.y: a123233fc320
>>     in linux-4.19.y: 6c786e656cd9
>>     in linux-5.4.y: 6b49a5a9eb46
>>     Applies to:
>>         v4.14.y, v4.19.y, v5.4.y
> 
> Queued up yesterday, also for 5.5.y and 5.6.y.
> 
> Many thanks for these, I think they should now all be handled.
> 

Thanks a lot, and sorry for missing 5.5/5.6. Those really completely
slipped my mind.

So the big question is if we should report patches such as 82f04bfe2aff,
ie patches missing from stable releases where the offending patch was
not applied to a stable release but to mainline. This would overlap
with Sasha's script, though, so I am not sure if it would be a good
idea. What is your take ?

Thanks,
Guenter
