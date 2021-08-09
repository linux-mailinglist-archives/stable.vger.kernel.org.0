Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083663E45CA
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 14:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhHIMi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 08:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbhHIMiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 08:38:51 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1327C061798
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 05:38:30 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id e1so6473170qvs.13
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 05:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+yO3K6qk9feyKDpYOnpP1GKKVS0QyGkKDMEe18ApotA=;
        b=QhOxaclaO5C9XEqW3/dt2zQ54o0NRTBORYfzkU9PBJjr/UzmE2xsIM+58DA1fbhiay
         AAf6KFL7D3w7DxMJb7giIVrQxx9er0yYXsMpBTH+fwbjUnrrcroQJ8DFWGmTaZ6MCkj0
         wkpsk28h5ZeZLjITr6tGSNgdK7I15Bp/VYCzD17BWQePtaEgF3KTo5NiantjxdQ0NolO
         3m1UFnssZgrhxTPaljP/kFtrCPGTnNOihVijXNtIAvoT9J/IjBHDjlmd/Dh2+oGEx0Po
         hYbIjo2BQAF+HSf2nxMZcZOhZmXhuXq1C+lz7V/upW+ZsmLfokuHu+rC/6e9ytswB63W
         Cj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+yO3K6qk9feyKDpYOnpP1GKKVS0QyGkKDMEe18ApotA=;
        b=QE3F16QeX4o2xYUZ+GkWbHhB8I+FtoGRD+vLhrxEpuDteyqWR08PcEQgxMHoWnI8pb
         x7DqkleGFRRyvupnwMoUv43Cyz7wvPdWEpZX7iVq9gLILiG9xNl27pvEwsIMaRoWqL8v
         kxRAv3eqXwJZ0GHqfBiVv3cS7P1onfPLr4JJV/bK14rQgsjxvKewB8tExoO5kCmhSGrS
         b4MgqiqGO56iMpxUluMzABoHRrrbtcRU+7cwS2FmMGzrrL8MR1u+x1EDIKm+c2muiNJU
         4p5R7w0T+WryiP3DhHFlyya+M4QXJAscy5Z2cxxzz8UXRYYNJHJ3G+4Lzzb52svSgB5A
         1tSQ==
X-Gm-Message-State: AOAM530UMxXRRos3rsFnO/zOvNogGkwS4FC862LyjgW/QnOlQ8iCJRi+
        3wJdWpwdRGiqoPD/CyvC3Xo=
X-Google-Smtp-Source: ABdhPJycn7m4kUzagdayz9QBx/KLopvqrvEoCCjYQEVimz6yzoFCEMcXNI6pbJqj3OxvDihnxTHyfA==
X-Received: by 2002:a05:6214:501d:: with SMTP id jo29mr11974612qvb.43.1628512710180;
        Mon, 09 Aug 2021 05:38:30 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id f12sm6574242qtj.40.2021.08.09.05.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 05:38:29 -0700 (PDT)
Subject: Re: Patch "Revert "ACPI: resources: Add checks for ACPI IRQ
 override"" has been added to the 5.13-stable tree
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     hui.wang@canonical.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <16277146132219@kroah.com>
 <e9810931-b21c-195f-26cb-75b46aa9eb9a@gmail.com> <YREdlli29GUfvaUx@kroah.com>
Message-ID: <a64b85a6-cc26-afc3-4d6a-85c7a366576b@gmail.com>
Date:   Mon, 9 Aug 2021 08:41:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YREdlli29GUfvaUx@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/21 8:20 AM, Greg KH wrote:
> On Mon, Aug 09, 2021 at 08:15:11AM -0400, PGNet Dev wrote:
>> On 7/31/21 2:56 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>       Revert "ACPI: resources: Add checks for ACPI IRQ override"
>>>
>>> to the 5.13-stable tree which can be found at:
>>>       http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>>
>>> The filename of the patch is:
>>>        revert-acpi-resources-add-checks-for-acpi-irq-override.patch
>>> and it can be found in the queue-5.13 subdirectory.
>>>
>>> If you, or anyone else, feels it should not be added to the stable tree,
>>> please let <stable@vger.kernel.org> know about it.
>>>
>>>
>>>   From e0eef3690dc66b3ecc6e0f1267f332403eb22bea Mon Sep 17 00:00:00 2001
>>> From: Hui Wang <hui.wang@canonical.com>
>>> Date: Wed, 28 Jul 2021 23:19:58 +0800
>>> Subject: Revert "ACPI: resources: Add checks for ACPI IRQ override"
>>>
>>> From: Hui Wang <hui.wang@canonical.com>
>>>
>>> commit e0eef3690dc66b3ecc6e0f1267f332403eb22bea upstream.
>>
>> Confirming that this^ revert resolves the reported non-boot regression
>>
>> System does boot cleanly; but, then REboots @ 60 seconds.
>>
>> It's a known bug, with fix already in 5.13.9/stable:
>>
>>   Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
>>   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.13.y&id=02db470b866fd06d8951
>>
>> , causing TCO watchdog auto-reboot @ 60 secs.
>>
>> Although particularly nasty on servers with /boot on RAID, breaking arrays if watchdog boots before arrays correctly assembled, iiuc, it's UN-related
>>
>> With interim workaround
>>
>>   edit /etc/modprobe.d/blacklist.conf
>>
>> +	blacklist iTCO_wdt
>> +	blacklist iTCO_vendor_support
>>
>> for this second issue in place, 5.13.8 boots & appears stable.
> 
> I do not understand, am I missing something in the queue for the next
> 5.13 release that needs to be applied?

no.

just confirming this^ revert, landed in 5.13.8, _works_ to fix non-boot.

system _does_ bump into 60-sec REboot.
wasn't sure it's related to this^ or not ...

the fix for this _next_ issue appears already in 5.13.9/stable (https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.13.y&id=02db470b866fd06d8951)
The module blacklist workaround works for 5.13.8.

i.e., as it stands, 5.13.8 is usable (here), iff the iTCO mod blacklist workaround is applied.
5.13.9 is expected to resolved it.

