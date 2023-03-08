Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987976B0EB3
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjCHQ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCHQ0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:26:42 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68238C78F0;
        Wed,  8 Mar 2023 08:26:34 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id ay14so64297533edb.11;
        Wed, 08 Mar 2023 08:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgeq78gxLIL21D+IlAHaFMTP9xI3MPSeyQyoWJK0zfA=;
        b=GFX5HX0K7Tx2uIr251PpqSuZ8wwtoOoiqB1FQIQTABwC3UKfOcLbXUPi2viqlFfvbZ
         utvcZCyW8ORX+t2nO79ztUr/QzfPDzSSyNdkiLuDN6+9nGSGVKFZfVpoEkd2H7meGdcb
         z3jGtbPkxVgCeTd4HUHDyoAR84+BK+d7UPdgfMitw8N5/qP3wwhFWRijFN799GFqiSOJ
         CZuyxFuwJK+Jl/4C0/aeIxR/U1kqL9L9Sfl8vejqNgRagcY3z6oCg1M9l6kj+iS7qnzQ
         YXvtE6K50caEAHEBk8FZtxTacYnDVJiUNwUfO/h2wz0lQjaIGnxTSBapr0Z/pkyONXlL
         1kZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgeq78gxLIL21D+IlAHaFMTP9xI3MPSeyQyoWJK0zfA=;
        b=OzhkEYRIs6DkH/6ZIPFIMJiyLtDA1y9mqcRjmxASvsQYXIlU4sizt8Cr1+WZVSTwla
         RcLTIP92yQg5sLCf8GQyOwVa94Zl3LAjHyVgdEgrZ2nMETD27LL45OyZQ0DisAhKBBnF
         CQT4oFxYIEQtnjerlAZGmclhk1/UsJWMYJLJ680z34iYFwmPubXHFYV2kJBwcZB4vtik
         kobvF2AWtQwltAg42DYPzXMx+0774TF58IgBkITjTcEydrW8bA8opBwNmmqY4zsv4xBG
         IovRW2G0Woa0SK+NvxNqFkKpJACD3Ztbbn+KsOIUQIYhMBpJyGcfjJYxLohNXpw1He6M
         HMqA==
X-Gm-Message-State: AO0yUKVI4KoqgGc7pYJxTO7m6WN0+cZdHIQCxQc4JoPahsnSvbuqzHXU
        j7wdSQ4XQhS1IkJc4KSHYtUlNPTMIw9zAewjbJE=
X-Google-Smtp-Source: AK7set/GaI7SD2azpTIvM79a+TR5Z7cOLnZiQ9WZQ9Nhtda1MjFzID3oaJfGnh3IEVk3XUW6+PmZMzp5v6bZmTsLvJg=
X-Received: by 2002:a17:906:5811:b0:877:747d:4a90 with SMTP id
 m17-20020a170906581100b00877747d4a90mr9518767ejq.14.1678292792688; Wed, 08
 Mar 2023 08:26:32 -0800 (PST)
MIME-Version: 1.0
References: <20221209142615.33574-1-jandryuk@gmail.com> <87359gkc1d.fsf@baylibre.com>
In-Reply-To: <87359gkc1d.fsf@baylibre.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Wed, 8 Mar 2023 11:26:20 -0500
Message-ID: <CAKf6xpsGy7rjK3Rkosevr3dD+64-WqCEzAecBbHEHpBMeAHh7A@mail.gmail.com>
Subject: Re: [PATCH v2] Input: xen-kbdfront - drop keys to shrink modalias
To:     Mattijs Korpershoek <mkorpershoek@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Phillip Susi <phill@thesusis.net>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 8:54=E2=80=AFAM Mattijs Korpershoek
<mkorpershoek@baylibre.com> wrote:
>
> On Fri, Dec 09, 2022 at 09:26, Jason Andryuk <jandryuk@gmail.com> wrote:
>
> > xen kbdfront registers itself as being able to deliver *any* key since
> > it doesn't know what keys the backend may produce.
> >
> > Unfortunately, the generated modalias gets too large and uevent creatio=
n
> > fails with -ENOMEM.
> >
> > This can lead to gdm not using the keyboard since there is no seat
> > associated [1] and the debian installer crashing [2].
> >
> > Trim the ranges of key capabilities by removing some BTN_* ranges.
> > While doing this, some neighboring undefined ranges are removed to trim
> > it further.
> >
> > An upper limit of KEY_KBD_LCD_MENU5 is still too large.  Use an upper
> > limit of KEY_BRIGHTNESS_MENU.
> >
> > This removes:
> > BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
> > Empty space 0x224..0x229
> >
> > Empty space 0x28a..0x28f
> > KEY_MACRO1(0x290)..KEY_MACRO30(0x2ad)
> > KEY_MACRO_RECORD_START          0x2b0
> > KEY_MACRO_RECORD_STOP           0x2b1
> > KEY_MACRO_PRESET_CYCLE          0x2b2
> > KEY_MACRO_PRESET1(0x2b3)..KEY_MACRO_PRESET3(0xb5)
> > Empty space 0x2b6..0x2b7
> > KEY_KBD_LCD_MENU1(0x2b8)..KEY_KBD_LCD_MENU5(0x2bc)
> > Empty space 0x2bd..0x2bf
> > BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
> > Empty space 0x2e8..0x2ff
> >
> > The modalias shrinks from 2082 to 1550 bytes.
> >
> > A chunk of keys need to be removed to allow the keyboard to be used.
> > This may break some functionality, but the hope is these macro keys are
> > uncommon and don't affect any users.
> >
> > [1] https://github.com/systemd/systemd/issues/22944
> > [2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net/T=
/
> >
> > Cc: Phillip Susi <phill@thesusis.net>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
>
> Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>

Thank you, Mattjis.

Any other thoughts?  Can this patch be applied?

Thanks,
Jason
