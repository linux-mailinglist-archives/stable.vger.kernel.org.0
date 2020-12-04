Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537152CEE3F
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 13:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgLDMjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 07:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgLDMjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 07:39:39 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18912C061A51;
        Fri,  4 Dec 2020 04:38:59 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b26so3619400pfi.3;
        Fri, 04 Dec 2020 04:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TZ6S7owe8jEaWVkTXdzygQVG2HWdB0aFUPTIiE7tBDM=;
        b=Grpkk225OFIpqgJpxC5e0+kJeX+tVOiAN/XAoEbgYAhmhgwEZ3/OyhBupeMwM18ElN
         SJWW+zZI60eoTDnGK+osZnx+CNePS8sbAqCM3fSeIVJuemL5ogwamKb3e71/clsZSke6
         50TdAIy5ihnXhbAr2g+P2ksN020tZYa4SJkEAeEhgDotpWTKC1y8psuNSEXCCzBj65Ll
         KZt6WZOF7pYc4UARN8aZcvN9apCHIlbMyl+butBPwiYg/SAo0x3U+yhD+lDe9Mk9Dw7e
         NhGUs7m6NFy0l6KAIrwa9wBEyoDlqf/n4yD3USxrHrgu7hlV8d+FDI78TRJ9JoR6gsg4
         aelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TZ6S7owe8jEaWVkTXdzygQVG2HWdB0aFUPTIiE7tBDM=;
        b=IBeShmq/DgyY0yBHU4k2X2p4U8g7w8jKKG13b5Axdy3KOvexywe5Twj/s5t2mZpoLl
         mrdVznMxJ+WBpzvUnIJGNVfllzW+zGIA308WdEslg4xZQPCjQrHjB+KB3tF8Q5o/t0/G
         v4QxvB3ILWhBTzRp7PNIKf04qjBBCN01O4TA9gquiKuOkd7JetN2uNTKU51oNns9uaof
         7smthtgqjXEBAZ6ulTN5L3cdRnmQ2e0FUQnbFKmf9spIKumI3gqHCh/1aJFnqotaTGsj
         8M7tZQMrsGG6bthW6OHYiar2saHIpExfoTYiCuRvd6RbM5Q5gmi9sohC6YckxiYBbRtI
         5pWw==
X-Gm-Message-State: AOAM531hfhTCOt0/ceMF6T+NYadbVMNejTCRvn8NvzLVTSprDFoxqYyC
        T2veFEmxRZTjPwc2wRBEt7Y=
X-Google-Smtp-Source: ABdhPJwa9vITJCOTT2aOTsl461jIB5CM58oSQtlJp3P8Ykzh23/G6zJZ+gMJbEnSoWBZ+cMnuekibg==
X-Received: by 2002:a63:c4c:: with SMTP id 12mr7295551pgm.428.1607085538671;
        Fri, 04 Dec 2020 04:38:58 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id a20sm3638486pgg.89.2020.12.04.04.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 04:38:58 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 4 Dec 2020 20:38:02 +0800
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] pinctrl: amd: remove debounce filter setting in IRQ
 type setting
Message-ID: <20201204123802.n7nc2nmcen7z5xtt@Rk>
References: <20201125130320.311059-1-coiby.xu@gmail.com>
 <CACRpkdaYJZxj1QS190dd-hftO+VpAdFWQ8iRezoyw3WAa8h+AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACRpkdaYJZxj1QS190dd-hftO+VpAdFWQ8iRezoyw3WAa8h+AQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 10:03:43AM +0100, Linus Walleij wrote:
>On Wed, Nov 25, 2020 at 2:03 PM Coiby Xu <coiby.xu@gmail.com> wrote:
>
>> Debounce filter setting should be independent from IRQ type setting
>> because according to the ACPI specs, there are separate arguments for
>> specifying debounce timeout and IRQ type in GpioIo() and GpioInt().
>>
>> Together with commit 06abe8291bc31839950f7d0362d9979edc88a666
>> ("pinctrl: amd: fix incorrect way to disable debounce filter") and
>> Andy's patch "gpiolib: acpi: Take into account debounce settings" [1],
>> this will fix broken touchpads for laptops whose BIOS set the
>> debounce timeout to a relatively large value. For example, the BIOS
>> of Lenovo AMD gaming laptops including Legion-5 15ARH05 (R7000),
>> Legion-5P (R7000P) and IdeaPad Gaming 3 15ARH05, set the debounce
>> timeout to 124.8ms. This led to the kernel receiving only ~7 HID
>> reports per second from the Synaptics touchpad
>> (MSFT0001:00 06CB:7F28).
>>
>> Existing touchpads like [2][3] are not troubled by this bug because
>> the debounce timeout has been set to 0 by the BIOS before enabling
>> the debounce filter in setting IRQ type.
>>
>> [1] https://lore.kernel.org/linux-gpio/20201111222008.39993-11-andriy.shevchenko@linux.intel.com/
>> [2] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
>> [3] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28
>>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>> BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
>> Link: https://lore.kernel.org/linux-gpio/CAHp75VcwiGREBUJ0A06EEw-SyabqYsp%2Bdqs2DpSrhaY-2GVdAA%40mail.gmail.com/
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>> Changelog v4:
>>  - Note in the commit message that this patch depends on other two
>>    patches to fix the broken touchpad [Hans de Goede]
>>  - Add in the commit message that one more touchpad could be fixed.
>
>Patch applied for fixes adding a reference to Andy's commit.
>Thanks for sorting this out!
>

Thank you for applying the patch!

>Yours,
>Linus Walleij

--
Best regards,
Coiby
