Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9A92E2D14
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 05:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgLZEax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Dec 2020 23:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgLZEaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Dec 2020 23:30:52 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388F5C061757;
        Fri, 25 Dec 2020 20:30:12 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id e2so3080547plt.12;
        Fri, 25 Dec 2020 20:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZT8qsdCeT5k/hqq9TWUszufAJP8kWK+7oXAtkTtgf+M=;
        b=rWyDxeNT5f+UbKj+wm650EQZG8LG7pfD2+PWKHAYcGDkNJMBGg3FY3ilrkgdxY54VE
         3oQASUqSMPTEgE4EpFK8z3YQo3eQ6+mJ3MzhutEKpFa6oMxbUAg4Z02xdbux+rZGSeFL
         rbZqCHlMwWcFWd+cp6xtkM/jM2mHyMqJjQGCa/5jZ7onMERGQitGGJl8snICmMgR4EyT
         rRUAgSYbzQgZLvxXTNOAFOH7E4uJ3T54nsIcfUEsXVd6XhJsBWOROtHEWHd86KXgfpKI
         UngYXsiYsqW4riDx6nEvh3wCNwiNurTc8lDVqV8PLK5+yUDGmVJ9V9ZmV1uFC5s+ruYQ
         s0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZT8qsdCeT5k/hqq9TWUszufAJP8kWK+7oXAtkTtgf+M=;
        b=DLSnXEqKUFtSUIHJZ+Utk1wCYQsSJSiQTaPWAQcxyZwZetWkhkWNyXdNHtQyBgESAA
         con6xdMhTzcr68T5TgoGz5yHoL7nOfR8JC+HdwgKSIyVhlgNApALJeZs+hCG+L3fk73l
         oj7nBe1aihG93eXVsC/ZR2KpvpU7CLSJQGT8iLYFVAmhXIrrG3rm1tkdWUkKCsISSkbw
         puSGT8f1Jxm54+l5wviBn2WfsVQtbg8qb+SNEGGdqiQnufYv6IaF9JujGzoX8hBJGaN9
         HlSaDUkdnNSAXVnvhWNnIRFKyqM1/219Nr7fKEXgooSM6EksmxWRl8YeMS/g45TjySPn
         Xjow==
X-Gm-Message-State: AOAM533Dni+yHj98ldTXoFDFsCs0K9WxJbBa1q/rLstJ2JTVjD8QWmAB
        80WGRWSbx7CNH3y82HcA93FbZYnG+es3fBof
X-Google-Smtp-Source: ABdhPJyVGjIW2SWtY2ypHKnQ9EconUxcgrOotCEiV05SLCi80UEcD8b3XMO00UclsFkVCUG1Psls6w==
X-Received: by 2002:a17:90a:c20d:: with SMTP id e13mr10670760pjt.185.1608957010826;
        Fri, 25 Dec 2020 20:30:10 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id b2sm29057290pfo.164.2020.12.25.20.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Dec 2020 20:30:09 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 26 Dec 2020 12:29:14 +0800
To:     Greg KH <gregkh@linuxfoundation.org>,
        =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201226042914.azz4yqje35h4vybw@Rk>
References: <20201125141022.321643-1-coiby.xu@gmail.com>
 <X75zL12q+FF6KBHi@kroah.com>
 <B3Hx1v5x_ZWS8XSi8-0vZov1KLuINEHyS5yDUGBaoBN4d9wTi9OlCoFX1h6sqYG8dCZr_OKcKeImWX9eyKh8X4X3ZMdAUQ-KVwmG5e9LJeI=@protonmail.com>
 <X9B2B6KuzbP8Is+W@kroah.com>
 <CHTa60htGkyHzaM2En-TPXqyk1v3jVJUolGOMfHphEr_mMG5Z5f2K4mHTFilYR73bgpGEKNcGM1LFstJ7UhvbuJrgqr1-J2-YTZJenhK83Q=@protonmail.com>
 <X9Dw4zxx331I7zAk@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X9Dw4zxx331I7zAk@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Barnabás,

On Wed, Dec 09, 2020 at 04:44:35PM +0100, Greg KH wrote:
>On Wed, Dec 09, 2020 at 03:38:11PM +0000, Barnabás Pőcze wrote:
>> 2020. december 9., szerda 8:00 keltezéssel, Greg KH írta:
>>
>> > On Tue, Dec 08, 2020 at 09:59:20PM +0000, Barnabás Pőcze wrote:
>> >
>> > > 2020.  november 25., szerda 16:07 keltezéssel, Greg KH írta:
>> > >
>> > > > [...]
>> > > >
>> > > > > +static u8 polling_mode;
>> > > > > +module_param(polling_mode, byte, 0444);
>> > > > > +MODULE_PARM_DESC(polling_mode, "How to poll (default=0) - 0 disabled; 1 based on GPIO pin's status");
>> > > >
>> > > > Module parameters are for the 1990's, they are global and horrible to
>> > > > try to work with. You should provide something on a per-device basis,
>> > > > as what happens if your system requires different things here for
>> > > > different devices? You set this for all devices :(
>> > > > [...]

Thank you for pointing out that.

>> > >
>> > > Hi
>> > > do you think something like what the usbcore has would be better?
>> > > A module parameter like "quirks=<vendor-id>:<product-id>:<flags>[,<vendor-id>:<product-id>:<flags>]*"?
>> >
>> > Not really, that's just for debugging, and asking users to test
>> > something, not for a final solution to anything.
>>

This patch is not only for debugging. The primary reason is as a
fallback solution to save the touchpad. The mentioned touchpads will
be fixed by Linux 5.11 which means the enthusiastic Linux users have to
wait for ~10 months to get their touchpads fixed.

>> My understanding is that this polling mode option is by no means intended
>> as a final solution, it's purely for debugging/fallback:
>>
>> "Polling mode could be a fallback solution for enthusiastic Linux users
>> when they have a new laptop. It also acts like a debugging feature. If
>> polling mode works for a broken touchpad, we can almost be certain
>> the root cause is related to the interrupt or power setting."
>>
>> What would you suggest instead of the module parameter?
>
>a debugfs file?  That means it's only for debugging and you have to be
>root to change the value.
>

Thank you for the helpful discussion and the suggestions!

If we can answer the following two questions, it could help decide
what's the next move.

1. How many machines have two or more I2C HID devices?

For the laptops this patch try to fix, they only have one I2C HID
device, i.e., the touchpad. If it's the case with most machines
running Linux, then we don't need to support per-HID-I2C-device
setting and module parameter is the most user-friendly since the user
doesn't even need to know the <vendor-id>/<product-id> pair.

2. How many I2C HID devices like touchpads could be saved by this
patch in the future?

If polling could potentially save lots of I2C hid devices, we are more
motivated to make it easier to use.


--
Best regards,
Coiby
