Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D472C410D
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 14:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgKYNXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 08:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKYNXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 08:23:32 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCF4C0613D4;
        Wed, 25 Nov 2020 05:23:32 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id k5so1105474plt.6;
        Wed, 25 Nov 2020 05:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YwQYvfQDUoa13fsKbpmwHso8WgufFTOG+Z6qNLGXK04=;
        b=l4J2S1JXLDkshzyJl7lW3Zqnvx/CGNGDqiRw4F3kuW8QmjyRIeIOeeKJEdmYcBxPn8
         j+P0q8JTjJYXZOOzWRXcWqYHaKW2j/jrtV6jCWceCH7CdMd9+ySrqStXBA/Z3Z7afucA
         HgxeEWwSZPxOT7LjQALXSvRtnbHXST8WpxYQkHxSwuyyi7Hky2IWbD7UpTItmgFFcMt+
         InuT7lspu9Q2rPD2w6mBXR5mrB3BVl5fR/kJ2Vu8aH7ZA/H7Ilrtxl2vojUYZmU0szep
         lLbrSELWDRvhUd5GMEvUNPb4Nnqx6M1kTGPKXxa7HWMDTK7PsloT6l9VmhoLRnzvf3ez
         jivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YwQYvfQDUoa13fsKbpmwHso8WgufFTOG+Z6qNLGXK04=;
        b=m6dQ5Rkw2SZfG3b+ii5DumJNlwCf4XkkHATzFtnbgHwef3N49zuPYk8F41CDa6wl05
         bT8PfuKEv+tufmaxO2E0Xv2xwRkPoL6bsQWIdFEpWLy0EJIrW87GWQl8cLWNtg3sQRW5
         aNpvT9gwfQIxQz8UeuupWv30g0YZLDQJ24h//zQlM1Xgq0igLZbWIpLQ9A6+Pct0Am9i
         2SaslNKVpZ96jC8sqEe/pBFTIwEZmS9fDDcmPRZ2XyZgendOgLKaLO9G5HyYsGVFXObt
         im4qqki6u72BuBxgVdpx+r4fHkapfhNJPCqu32A2MqlovqKU7EhCvuYWc1oakjQTsl3+
         7oUQ==
X-Gm-Message-State: AOAM5335/hocjufEkE0AYT/KylCxJbRUdTmal7i/2RUqkGAcQ2AN04LL
        EW//L1cjmzaP7K/iR0SiXK/739yzBxh+4mYhXWU=
X-Google-Smtp-Source: ABdhPJwZEeAeqN3pyyyDA41u7zVejFuXVqY7LtXH3SIm/z+F1pLntuMm3BdR0lbLzih2Fwz5QB+E9wzydP6OTQ6Ri64=
X-Received: by 2002:a17:902:ac93:b029:d8:d2c5:e5b1 with SMTP id
 h19-20020a170902ac93b02900d8d2c5e5b1mr2999337plr.17.1606310611989; Wed, 25
 Nov 2020 05:23:31 -0800 (PST)
MIME-Version: 1.0
References: <20201125130320.311059-1-coiby.xu@gmail.com>
In-Reply-To: <20201125130320.311059-1-coiby.xu@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 25 Nov 2020 15:24:20 +0200
Message-ID: <CAHp75VfdGH2LmiNUGzy+BcYpCmSGBE6DxVhDDYSnhfu68HGTUA@mail.gmail.com>
Subject: Re: [PATCH v4] pinctrl: amd: remove debounce filter setting in IRQ
 type setting
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 3:03 PM Coiby Xu <coiby.xu@gmail.com> wrote:
>
> Debounce filter setting should be independent from IRQ type setting
> because according to the ACPI specs, there are separate arguments for
> specifying debounce timeout and IRQ type in GpioIo() and GpioInt().
>
> Together with commit 06abe8291bc31839950f7d0362d9979edc88a666
> ("pinctrl: amd: fix incorrect way to disable debounce filter") and
> Andy's patch "gpiolib: acpi: Take into account debounce settings" [1],
> this will fix broken touchpads for laptops whose BIOS set the
> debounce timeout to a relatively large value. For example, the BIOS
> of Lenovo AMD gaming laptops including Legion-5 15ARH05 (R7000),
> Legion-5P (R7000P) and IdeaPad Gaming 3 15ARH05, set the debounce
> timeout to 124.8ms. This led to the kernel receiving only ~7 HID
> reports per second from the Synaptics touchpad
> (MSFT0001:00 06CB:7F28).
>
> Existing touchpads like [2][3] are not troubled by this bug because
> the debounce timeout has been set to 0 by the BIOS before enabling
> the debounce filter in setting IRQ type.
>
> [1] https://lore.kernel.org/linux-gpio/20201111222008.39993-11-andriy.shevchenko@linux.intel.com/

JFYI: this is nowadays
8dcb7a15a585 ("gpiolib: acpi: Take into account debounce settings")

(No need to recend, just an information that can be applied maybe by Linus)

> [2] https://github.com/Syniurge/i2c-amd-mp2/issues/11#issuecomment-721331582
> [3] https://forum.manjaro.org/t/random-short-touchpad-freezes/30832/28

-- 
With Best Regards,
Andy Shevchenko
