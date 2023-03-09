Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D092D6B2AB1
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 17:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCIQ1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 11:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjCIQ1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 11:27:04 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB88F8F35
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 08:18:39 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id u9so9232624edd.2
        for <stable@vger.kernel.org>; Thu, 09 Mar 2023 08:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678378653;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pU1OTBYl8ElxfZaqjfIJsMTqsKjO/PQMi+tQNnzKT4Q=;
        b=1s3j1puhxYyfQ09uZ3e+DIhwkoUaFfD0RcK6I16jGn3TiBVvfoubfjqUPRjyNgUkgH
         PS4g7/mLfekYbrkb39ZATniMywOTXQr2+xHHYAa5EPJ2oPiMpFhXapHrUengprVnM0AT
         5lDUNMl6cVovHbftxTx4vRCtYUK34aqb2FCg01G/CatzYQ+rQmwq1WplOTcUn9FnTnw4
         6P3xGQI7GU09oJKvMrmoXtzSuEl4FD/n/3Sh5h1bd/vODPzvu6+1BTHlxwNi9OO5wrRv
         jJyrBhTrK1sMaaHWaL1v2ozQwFgM4Sgrr1iE9wAdMqOIIhXmJJsaC+JiX6kaB41UUgaM
         CMsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678378653;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pU1OTBYl8ElxfZaqjfIJsMTqsKjO/PQMi+tQNnzKT4Q=;
        b=Vpc9qR1o65b2T3aZzOiHkPEUQ+W/RWHXQCOlyWDwnJousKapITxh57IaiTr9rxpgqy
         kev+lr8BIsAkuj6Qu4md05JWp6SkCk9XqVECpyqVNQ+7osuVhQJMHTAOqrL7Ve3ghCN2
         581+cRrFpQ18tYDRTERLV9QTkz1Rjf3hbuoawNdLSN6PqGBRPjQZf59NQqDP6x7llbnK
         s/GLzOFtzgI4Q/PiWHqJin/oViegwKbPYCF0z5B1FuqR4hf2Joy1cr8oWBvXLEGTMGZY
         XhKE8PE1CbyEkOZwOO10D/KRrbbkTZKaPaHZ8PZJ1fgWFblVwceMMxFQMEShxd3OaFwl
         PlYg==
X-Gm-Message-State: AO0yUKWD4X72HrzAcqMcmVVK3EUvYi3gqqRMwIv0zKzooXj5l/Fyon3K
        UOyMyrrg9HZgSVK+xBdBQMiXqnYd9Hp/ydL0Quo=
X-Google-Smtp-Source: AK7set/uDxSQX6guni2q9LjuMZgDKvnwtVPDVc/y4ZwVZTtKpMFGC+aDylsQfmADZ8cH166t4rv0qg==
X-Received: by 2002:a05:600c:1906:b0:3eb:3c76:c23c with SMTP id j6-20020a05600c190600b003eb3c76c23cmr20444802wmq.3.1678378147773;
        Thu, 09 Mar 2023 08:09:07 -0800 (PST)
Received: from localhost ([82.66.159.240])
        by smtp.gmail.com with ESMTPSA id z18-20020a1c4c12000000b003e876122dc1sm216880wmf.47.2023.03.09.08.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:09:07 -0800 (PST)
From:   Mattijs Korpershoek <mkorpershoek@baylibre.com>
To:     Jason Andryuk <jandryuk@gmail.com>
Cc:     linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Phillip Susi <phill@thesusis.net>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2] Input: xen-kbdfront - drop keys to shrink modalias
In-Reply-To: <CAKf6xpsGy7rjK3Rkosevr3dD+64-WqCEzAecBbHEHpBMeAHh7A@mail.gmail.com>
References: <20221209142615.33574-1-jandryuk@gmail.com>
 <87359gkc1d.fsf@baylibre.com>
 <CAKf6xpsGy7rjK3Rkosevr3dD+64-WqCEzAecBbHEHpBMeAHh7A@mail.gmail.com>
Date:   Thu, 09 Mar 2023 17:09:05 +0100
Message-ID: <87o7p1dhzy.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

On mer., mars 08, 2023 at 11:26, Jason Andryuk <jandryuk@gmail.com> wrote:

> On Thu, Dec 15, 2022 at 8:54=E2=80=AFAM Mattijs Korpershoek
> <mkorpershoek@baylibre.com> wrote:
>>
>> On Fri, Dec 09, 2022 at 09:26, Jason Andryuk <jandryuk@gmail.com> wrote:
>>
>> > xen kbdfront registers itself as being able to deliver *any* key since
>> > it doesn't know what keys the backend may produce.
>> >
>> > Unfortunately, the generated modalias gets too large and uevent creati=
on
>> > fails with -ENOMEM.
>> >
>> > This can lead to gdm not using the keyboard since there is no seat
>> > associated [1] and the debian installer crashing [2].
>> >
>> > Trim the ranges of key capabilities by removing some BTN_* ranges.
>> > While doing this, some neighboring undefined ranges are removed to trim
>> > it further.
>> >
>> > An upper limit of KEY_KBD_LCD_MENU5 is still too large.  Use an upper
>> > limit of KEY_BRIGHTNESS_MENU.
>> >
>> > This removes:
>> > BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
>> > Empty space 0x224..0x229
>> >
>> > Empty space 0x28a..0x28f
>> > KEY_MACRO1(0x290)..KEY_MACRO30(0x2ad)
>> > KEY_MACRO_RECORD_START          0x2b0
>> > KEY_MACRO_RECORD_STOP           0x2b1
>> > KEY_MACRO_PRESET_CYCLE          0x2b2
>> > KEY_MACRO_PRESET1(0x2b3)..KEY_MACRO_PRESET3(0xb5)
>> > Empty space 0x2b6..0x2b7
>> > KEY_KBD_LCD_MENU1(0x2b8)..KEY_KBD_LCD_MENU5(0x2bc)
>> > Empty space 0x2bd..0x2bf
>> > BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
>> > Empty space 0x2e8..0x2ff
>> >
>> > The modalias shrinks from 2082 to 1550 bytes.
>> >
>> > A chunk of keys need to be removed to allow the keyboard to be used.
>> > This may break some functionality, but the hope is these macro keys are
>> > uncommon and don't affect any users.
>> >
>> > [1] https://github.com/systemd/systemd/issues/22944
>> > [2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net/=
T/
>> >
>> > Cc: Phillip Susi <phill@thesusis.net>
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
>>
>> Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
>
> Thank you, Mattjis.
>
> Any other thoughts?  Can this patch be applied?

That's not up to to decide, Dmitry might pick this up or give you a
review whenever he has time.

>
> Thanks,
> Jason
