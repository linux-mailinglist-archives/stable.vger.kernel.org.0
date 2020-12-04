Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0DD2CEE3D
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 13:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgLDMj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 07:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgLDMj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 07:39:28 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630ECC061A4F;
        Fri,  4 Dec 2020 04:38:48 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q10so3622993pfn.0;
        Fri, 04 Dec 2020 04:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t1SOBg+AdBEzlFR/pdb3N773Ew8SMnLFrxYMoyMoI4Y=;
        b=XeNP4xOIUF6OvsLEuwn9HOxWtypBAiujLK0J50Z58FBbfTN5ZzajZUQX3P1g7m1rQN
         K9IUliOCzkFi1kY+L6FKnJi2rR7ikxoVZlyBTmvU9AH793uVoo24S3gilKSYSi2+XC2H
         hmkbLJLafGbc8+/mMsk6adiqS/T3msFPFNbb8uqBgthfFpxMXB95CGiMLAWY1b7NK/Ji
         Ui+D3+qPAMeSzcnCDpUKFd2Zg6wOezjN1QkvnWEZcadV6+mYFl9zDhPX9CAdCZfKFJrT
         OYkyOFBxQBoDGqs9JNzxDz2NDaCrSJi1qYgaofECm7PboU04qf1+WLfbjS6+lTMJxwRV
         ngJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t1SOBg+AdBEzlFR/pdb3N773Ew8SMnLFrxYMoyMoI4Y=;
        b=oFroeAKAVmBwM6B88L9mvUjJv9iNSOoUGask6AL/2fTOZfYLaMTNM0e7QpGvA92bwx
         ZVpCfEvyMbeqTKfL9NrgeATl4Y+6zxm2s2HBGkTza63A4ajj/nCJ99Uv1WkNXgt7tSdx
         GYR8GnBV+D8SB7Vai7MuOvIHDAAkvBLFTeuuy0Ud7YH6hmOHFLYkSc6sigi+ssg/Nien
         VCNdU43JiFfmd07+gC4L3Lo2PeCfYhP5SR2iDAhl0bhfjtu4wO+wDlLdwXA2HX57XRu7
         eIaUNYFnkbRzs1W4WbNkmGRBsD+D5eXJCZFe72jQjTi4ylF+7Q3QK3qv29K7RJTg6IWW
         T1IA==
X-Gm-Message-State: AOAM531/NmFYpqyhihe+Th8V23COJzu/2sjQ0vpUR0UOMxfhLZKvSrV7
        Nt0WCr3EwUXfdvOLbz1icRA=
X-Google-Smtp-Source: ABdhPJwrmoGab0aRiAxI8X9DJNcaFqFLzx48/a/ste4Szk0h0ifJPOySQOB5vvep4Y5xx9mjny1QiA==
X-Received: by 2002:a63:4083:: with SMTP id n125mr7427742pga.356.1607085527850;
        Fri, 04 Dec 2020 04:38:47 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id e18sm3799556pgr.71.2020.12.04.04.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 04:38:47 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 4 Dec 2020 20:35:43 +0800
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] pinctrl: amd: remove debounce filter setting in IRQ
 type setting
Message-ID: <20201204123543.3wjng2hn35yhezob@Rk>
References: <20201125130320.311059-1-coiby.xu@gmail.com>
 <CAHp75VfdGH2LmiNUGzy+BcYpCmSGBE6DxVhDDYSnhfu68HGTUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHp75VfdGH2LmiNUGzy+BcYpCmSGBE6DxVhDDYSnhfu68HGTUA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 03:24:20PM +0200, Andy Shevchenko wrote:
>On Wed, Nov 25, 2020 at 3:03 PM Coiby Xu <coiby.xu@gmail.com> wrote:
>>
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
>
>JFYI: this is nowadays
>8dcb7a15a585 ("gpiolib: acpi: Take into account debounce settings")
>

Thank you for the info! Next time I will also check the linux-next
tree:)

>(No need to recend, just an information that can be applied maybe by Linus)
>
>> [2] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
>> [3] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28
>
>--
>With Best Regards,
>Andy Shevchenko

--
Best regards,
Coiby
