Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8812E73C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 15:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgABO3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 09:29:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35162 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728425AbgABO3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 09:29:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577975389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Cq9PVWs6VquKlA4j0NYHB1T+BYKM2HMC7Ak1f9Lsyg=;
        b=Ev0o1TnzNgbV6RBDyMNQGzmE10xjH0c4wQgx333/kOAImH/RFNQeV5j1Ms1v1i+kSnLkuZ
        quwz/2NcN4rOix7ptuJ4C2llldkDcBDTfpxo/EX4cnzAbfTPJ0Q2U705+VZoIunHLwYKz9
        vg0Ex4L5REXZO7R/KU6s1JFrPOGeqFs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-okKEBePyPECSUw5WMksT8g-1; Thu, 02 Jan 2020 09:29:49 -0500
X-MC-Unique: okKEBePyPECSUw5WMksT8g-1
Received: by mail-wr1-f70.google.com with SMTP id z14so21856648wrs.4
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 06:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Cq9PVWs6VquKlA4j0NYHB1T+BYKM2HMC7Ak1f9Lsyg=;
        b=oxM3ofIfZjO73YwsQkkvDSm325TgRj7tkm3kTEaO9hynCmLc8o49pnr5yIuXkv/ifK
         jRMBsCPZmow3KunZ15eTn02O7wghPc+lbRbzgjYt0eG3WoKPH0+yy8Po5u1GVkYxxQYO
         boK4+zomUOYGRfz/ulEC4FrFUePjx7hWbt5JTB4lmSTUNPHKs9O0X0JiAFXobn61mf6e
         zHCbnUzfL2G0ECZXgr+fMdwixt2FadLbXyUGZjou1U32Ocb2QJWYpwZ97dZJooDwowgP
         kfnEZNCeZd93vyRl4ujBSuOjolbxmrxpfXkpIhxJcBHOIaS2RUcgKT3vSPZiXy4HCCpo
         6AtA==
X-Gm-Message-State: APjAAAUIs1ZjPJjl+L2NubAiztzIEYNgSzOXc9gXVzUbgjv1/jMTls1l
        97mNd61LK7lDX1WEeCbdqcTat3r9kjzZIuk/KDJXCNUk4ikuCKCxV6vd+/uVg2SunaSyrj536xf
        FXhMOVZp1PCxkuoG5
X-Received: by 2002:adf:d850:: with SMTP id k16mr78955260wrl.96.1577975387536;
        Thu, 02 Jan 2020 06:29:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzzzevCNsIWI/qRhJJQWHoacJGd4CmF5GMUVJfrQbPiCz0sqe3sQosj8jfK7i97qMo7RA/oVQ==
X-Received: by 2002:adf:d850:: with SMTP id k16mr78955249wrl.96.1577975387371;
        Thu, 02 Jan 2020 06:29:47 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id c5sm8769562wmb.9.2020.01.02.06.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 06:29:46 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] pinctrl: baytrail: Really serialize all
 register accesses" failed to apply to 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
References: <1577634412127144@kroah.com> <20200102010521.GD16372@sasha-vm>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <a0bd276a-2f56-ff63-b8ba-87a4dc250682@redhat.com>
Date:   Thu, 2 Jan 2020 15:29:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200102010521.GD16372@sasha-vm>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 02-01-2020 02:05, Sasha Levin wrote:
> On Sun, Dec 29, 2019 at 04:46:52PM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 40ecab551232972a39cdd8b6f17ede54a3fdb296 Mon Sep 17 00:00:00 2001
>> From: Hans de Goede <hdegoede@redhat.com>
>> Date: Tue, 19 Nov 2019 16:46:41 +0100
>> Subject: [PATCH] pinctrl: baytrail: Really serialize all register accesses
>>
>> Commit 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
>> added a spinlock around all register accesses because:
>>
>> "There is a hardware issue in Intel Baytrail where concurrent GPIO register
>> access might result reads of 0xffffffff and writes might get dropped
>> completely."
>>
>> Testing has shown that this does not catch all cases, there are still
>> 2 problems remaining
>>
>> 1) The original fix uses a spinlock per byt_gpio device / struct,
>> additional testing has shown that this is not sufficient concurent
>> accesses to 2 different GPIO banks also suffer from the same problem.
>>
>> This commit fixes this by moving to a single global lock.
>>
>> 2) The original fix did not add a lock around the register accesses in
>> the suspend/resume handling.
>>
>> Since pinctrl-baytrail.c is using normal suspend/resume handlers,
>> interrupts are still enabled during suspend/resume handling. Nothing
>> should be using the GPIOs when they are being taken down, _but_ the
>> GPIOs themselves may still cause interrupts, which are likely to
>> use (read) the triggering GPIO. So we need to protect against
>> concurrent GPIO register accesses in the suspend/resume handlers too.
>>
>> This commit fixes this by adding the missing spin_lock / unlock calls.
>>
>> The 2 fixes together fix the Acer Switch 10 SW5-012 getting completely
>> confused after a suspend resume. The DSDT for this device has a bug
>> in its _LID method which reprograms the home and power button trigger-
>> flags requesting both high and low _level_ interrupts so the IRQs for
>> these 2 GPIOs continuously fire. This combined with the saving of
>> registers during suspend, triggers concurrent GPIO register accesses
>> resulting in saving 0xffffffff as pconf0 value during suspend and then
>> when restoring this on resume the pinmux settings get all messed up,
>> resulting in various I2C busses being stuck, the wifi no longer working
>> and often the tablet simply not coming out of suspend at all.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 39ce8150a079 ("pinctrl: baytrail: Serialize all register access")
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> There were quite a few variable/struct renames in the file which
> resulted in conflicts. I've fixed them up and queued for all branches.

Thank you for taking care of this!

Regards,

Hans


