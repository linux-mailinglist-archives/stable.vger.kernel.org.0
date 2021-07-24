Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF623D4859
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 17:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhGXOr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 10:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGXOr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Jul 2021 10:47:56 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B30C061575
        for <stable@vger.kernel.org>; Sat, 24 Jul 2021 08:28:26 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id p38so2835853qvp.11
        for <stable@vger.kernel.org>; Sat, 24 Jul 2021 08:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s/cBgAdYiO4xbiSb64DJCJYxjA4gi/AIoamqR2p4D78=;
        b=NLrnP6kZoWixjA8C+59+k0jFO4zWP8U01SYH8VQ9OHRvHO+fXEnwEs6nziTIsL1foC
         couMWhxtAzcJRMOt0MPK04ZHj1/+suwXIR3TM0zmLRTcKVRjQd1H+xXh2egcccsZNeUA
         xnz1mtVZSf+45jq0PZCsQOeJQd4Q1nwK3A7eCHAje7Rj+SW/arHLmx7dl9k4NMlCoj7A
         8VvbG8T00n34faQFKga2HN8h09l0PmxjvJ/g2gys7dihCyowA2G3YE5c7AqkYk3U/yrB
         1GNtgJrSEVu5DAQZiSPpjhp2HfoKq9Qu8SnqhQtIybEi/DY3zh0IzgA/ygCJey40jyci
         rhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/cBgAdYiO4xbiSb64DJCJYxjA4gi/AIoamqR2p4D78=;
        b=ZvAygq2w2L5MTUy4YxAb2oTh2prUZAybSkTtxrrUoXcc0S2uFs5QSE3/ASWZXm6fXw
         qwn6iOyZJqt11LLOSuGUm4yto9gJlU9x6yh+87LKf0SkaJSQ0JEwoWhmynn7ghOpG1eY
         7SI5uK8bYM7gvDGIKtLuRolBt598RBPgXPaw4Yv3jz/bqitQG2jhbLd41bE0XB7Pg4dh
         cCByjHf2M1wmANAxGxRrqTqzBVgZ/3talP3RvxiVLuXGBr4RQ7ujD5k8bWVhSYjQOhnB
         MXFm897dpj1evTHljj3enIug6luz8OPz3jIqnZVg4U+yRGlmD/njSnQdyDzNUyd2KQk1
         rL7Q==
X-Gm-Message-State: AOAM532MJ7dyc0zxtVJxlQZfUgnK8+VIhypdFmYKQ5EqrKMkxhDttdAc
        Pc1T0InRY5KxQpZ0/ghjs0cTiFI4qnQ=
X-Google-Smtp-Source: ABdhPJwsPCnKgZnpTVhIakOZECe5yGSnpBk/J8Od8XfFrdTSTmrZR6VUJpBGKqAOKfQud+RsO2GfBQ==
X-Received: by 2002:ad4:5bad:: with SMTP id 13mr10369921qvq.8.1627140505867;
        Sat, 24 Jul 2021 08:28:25 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id j7sm10297734qtx.39.2021.07.24.08.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 08:28:25 -0700 (PDT)
Subject: Re: boot of J1900 (quad-core Celeron) mobo: kernel <= 5.12.15, OK;
 kernel >= 5.12.17, 5.13.4, slow boot (>> 660 secs) + hang/FAIL
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <5b5d1b7f-7327-52a2-5221-de39206a07a3@gmail.com>
 <YPppToU9X3LZYwoe@kroah.com> <6a2784d4-c348-1bef-063c-a7db2ffb1248@gmail.com>
Message-ID: <3491db05-3bb4-a2c9-2350-881a77734070@gmail.com>
Date:   Sat, 24 Jul 2021 11:30:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <6a2784d4-c348-1bef-063c-a7db2ffb1248@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/23/21 9:22 AM, PGNet Dev wrote:
>> Can you use 'git bisect' to find the offending change?
>>
>> thanks,
>>
>> greg k-h

Greg,


git clone https://gitlab.com/cki-project/kernel-ark.git
cd kernel-ark
git log -n1 | head -n1
       1 commit 94dd448e56d2446de85682efabd2f833c5f6dfc8 (HEAD -> os-build, origin/os-build, origin/HEAD)

git bisect start
git bisect good v5.12.15
git bisect bad  v5.12.17
git bisect visualize --oneline | wc -l
	715

bisect:

	1  BAD   [88611c8036bf96f91e59d223b1b8630e9ace82f2] mm: mmap_lock: use local locks instead of disabling preemption
	2  GOOD  [49e077e7c08ec4fd9299646d430bcc085ae81b86] mmc: sdhci-sprd: use sdhci_sprd_writew
	3  BAD   [2d3650748f83eb9fb5121a52c8b53e436e1f349c] crypto: ux500 - Fix error return code in hash_hw_final()
	4  GOOD  [b1bdf36471f2166725a688cf0204059455aedd66] fs: dlm: cancel work sync othercon
	5  BAD   [19d2497258ad98e1938c43ea00edfdd5408699a9] smb3: fix uninitialized value for port in witness protocol move
	6  BAD   [d401922918b0f36e2cef76413c07d1c223ee6df0] block: fix race between adding/removing rq qos and normal IO
	7  GOOD  [bc58f76172e8b80b9231abb275fac32c069df151] fs: dlm: fix memory leak when fenced
	8  BAD   [96b15a0b45182f1c3da5a861196da27000da2e3c] ACPI: resources: Add checks for ACPI IRQ override
	9  GOOD  [24743ca474860e2c350268b98cfff4ed1ff37fb4] ACPI: bus: Call kobject_put() in acpi_init() error path

	96b15a0b45182f1c3da5a861196da27000da2e3c is the first bad commit
	commit 96b15a0b45182f1c3da5a861196da27000da2e3c
	Author: Hui Wang <hui.wang@canonical.com>
	Date:   Wed Jun 9 10:14:42 2021 +0800

	    ACPI: resources: Add checks for ACPI IRQ override

	    [ Upstream commit 0ec4e55e9f571f08970ed115ec0addc691eda613 ]

	    The laptop keyboard doesn't work on many MEDION notebooks, but the
	    keyboard works well under Windows and Unix.

	    Through debugging, we found this log in the dmesg:

	     ACPI: IRQ 1 override to edge, high
	     pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)

	     And we checked the IRQ definition in the DSDT, it is:

	        IRQ (Level, ActiveLow, Exclusive, )
	            {1}

	    So the BIOS defines the keyboard IRQ to Level_Low, but the Linux
	    kernel override it to Edge_High. If the Linux kernel is modified
	    to skip the IRQ override, the keyboard will work normally.

	    From the existing comment in acpi_dev_get_irqresource(), the override
	    function only needs to be called when IRQ() or IRQNoFlags() is used
	    to populate the resource descriptor, and according to Section 6.4.2.1
	    of ACPI 6.4 [1], if IRQ() is empty or IRQNoFlags() is used, the IRQ
	    is High true, edge sensitive and non-shareable. ACPICA also assumes
	    that to be the case (see acpi_rs_set_irq[] in rsirq.c).

	    In accordance with the above, check 3 additional conditions
	    (EdgeSensitive, ActiveHigh and Exclusive) when deciding whether or
	    not to treat an ACPI_RESOURCE_TYPE_IRQ resource as "legacy", in which
	    case the IRQ override is applicable to it.

	    Link: https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configuration.html#irq-descriptor # [1]
	    BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213031
	    BugLink: http://bugs.launchpad.net/bugs/1909814
	    Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
	    Reported-by: Manuel Krause <manuelkrause@netscape.net>
	    Tested-by: Manuel Krause <manuelkrause@netscape.net>
	    Signed-off-by: Hui Wang <hui.wang@canonical.com>
	    [ rjw: Subject rewrite, changelog edits ]
	    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
	    Signed-off-by: Sasha Levin <sashal@kernel.org>

	 drivers/acpi/resource.c | 9 ++++++++-
	 1 file changed, 8 insertions(+), 1 deletion(-)
