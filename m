Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F422AE491
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 01:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgKKAEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 19:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731984AbgKKAEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 19:04:40 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F85C0613D3
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 16:04:39 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id r9so659378lfn.11
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 16:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JzWWY6NuciTI33aQq96X3WiN1h2jDKoGrOwhs2Ifrxc=;
        b=DSw+pVH6EQmIKgMM49DrSxbYR8Ia08GpFokAgc4lncdWrInFkSMUP0k/INRLZEBshA
         H2s4OgDrG9h5nRuZF9VelAC2M2CMq1b94qV7D7IyW3sgxYCmDNn3qsfFlcskaARrnfZ4
         ap7L10qrulUSlTgUG7ZnTO4n1N/I+WLuiUtjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JzWWY6NuciTI33aQq96X3WiN1h2jDKoGrOwhs2Ifrxc=;
        b=MR+NLVbMXrhWR24BjVKs4QLPBzEcEodnbci8NPN8u7519zo8fGBwcsAddfGv7iTEVQ
         aScPsnm2CpijfRPM6LiZj9khHW4MUhzmjUmMtZ4u4r78IL5kiryTQnO7KHRajvQUoKGH
         dFQ1EwiFkKw9LnlPDQGk6/lcOgP3CEiXUL/wLX+YvDOQRHCP2mgXuXVA82DtIHD0ZHt3
         FfzeGm1YiLaCe8rCLKlynq9c+79pMFb81OlLNBAuNaTzsYbSYYRf0nHi+rt/fA1/h1Wb
         4kKnU1ntn6W5V6v+sQiVJOwFhVDQ97+yGBrxlrU0ky9HQ3bOpBOOL+P/JtDufNWrcPZ2
         nOXQ==
X-Gm-Message-State: AOAM533oxgrRIzPm4kKAQ0V3kyxkUwtPfdSOEX9J6IIoHBTSvkhqrFCi
        zlg+g2yCpIQKbKWfIT/AhRdr0Zu+Zr/uhw==
X-Google-Smtp-Source: ABdhPJzALPYAxIUQQ+/PblL7TEFL/dthkwyy0+XpQ2AY5Xw4tXvo2JlTbvByqUQjDVykDKzolDX0EQ==
X-Received: by 2002:a05:6512:3118:: with SMTP id n24mr245025lfb.292.1605053075530;
        Tue, 10 Nov 2020 16:04:35 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id j7sm41369lfe.237.2020.11.10.16.04.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 16:04:34 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id w142so678371lff.8
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 16:04:34 -0800 (PST)
X-Received: by 2002:a19:408b:: with SMTP id n133mr8002533lfa.564.1605053074001;
 Tue, 10 Nov 2020 16:04:34 -0800 (PST)
MIME-Version: 1.0
References: <20201110144932.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
 <CAHp75VcfmJ6-cqCsZ6BjbghGDt+w-AbxGxLoWG61VVF2Knor-Q@mail.gmail.com>
In-Reply-To: <CAHp75VcfmJ6-cqCsZ6BjbghGDt+w-AbxGxLoWG61VVF2Knor-Q@mail.gmail.com>
From:   Evan Green <evgreen@chromium.org>
Date:   Tue, 10 Nov 2020 16:03:57 -0800
X-Gmail-Original-Message-ID: <CAE=gft4vdBytT2=tCbv2aE3RRoDut5CiHdBODjXJamGM5yB3Bw@mail.gmail.com>
Message-ID: <CAE=gft4vdBytT2=tCbv2aE3RRoDut5CiHdBODjXJamGM5yB3Bw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: intel: Fix Jasperlake hostown offset
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andy Shevchenko <andy@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 3:48 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
>
>
> On Wednesday, November 11, 2020, Evan Green <evgreen@chromium.org> wrote:
>>
>> GPIOs that attempt to use interrupts get thwarted with a message like:
>> "pin 161 cannot be used as IRQ" (for instance with SD_CD). This is becau=
se
>> the JSL_HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
>> owned by ACPI.
>
>
> Funny, I have created a similar patch few hours ago. Are you sure this is=
 enough? In mine I have also padcfglock updated. But I have to confirm that=
, that=E2=80=99s why I didn=E2=80=99t send it out.

Oh weird! I didn't check padcfglock since it didn't happen to be
involved in the bug I was tracking down. I was trying to clean out
some skeletons in my kernel closet [1] and debugged it down to this.

If you want to smash the two patches together I'm fine with that. Let
me know, and CC me if you do post something.
-Evan

[1] https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/=
master/overlay-dedede/sys-kernel/chromeos-kernel-5_4/files/0001-CHROMIUM-pi=
nctrl-intel-Allow-pin-as-IRQ-even-in-ACPI.patch
