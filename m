Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A536B0EC1
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCHQ3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjCHQ2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:28:41 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949E2069F;
        Wed,  8 Mar 2023 08:28:04 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id ay14so64314611edb.11;
        Wed, 08 Mar 2023 08:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qplyMQINe2W3LTK4CSzGPDowxH4S62V5RleKulPJLo=;
        b=UtXXjB2Sb8uE0I4aQP+tKLypRWWg8k3euJKU2xyVGn64N6QNcvZeL21p+DOHBO63lz
         gZkplvHD9ZzIaTXGvqSOp3gmPNC+rmIPzX3HMIBoW5fHIZcEjiFeovQTma48qQrCmtDL
         B1n7s5Kaggh90Z/RXSXXfnypGsOT5SMrjcerMVXz4qTgDlSgqm0NxX7BB/3AdeGXXZ+Q
         7nxPhpFKOI7n3b4fa3Rfu+wwB+ceq7APuXgJGE2pJmXLlio7Kl7JaylaKPSgrXsqDSIi
         usqxI8ZBZe+BR0o2rb40Zm4iTall99XMKe1a/ho6rCaRJLd+kfsXWLLWYnaz/mvAV/je
         wqeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qplyMQINe2W3LTK4CSzGPDowxH4S62V5RleKulPJLo=;
        b=5kTokw50Fkvvdm15kCEZOHTWXC6SPqhaVz5seZ9Z8Eh3Whyr6YbYkINmATEVehC5Rm
         KRXlXwn/YlIVWeb1uSFj4m7y0Lah3wG9nn+l1GU74zst4Qg2miIa7Uvw8NY/Iw4xsOTa
         BmWZDPdlD/OB2WfDiqIxCdYPxtSjGT2vVVQXUJqhTF9k01OEFoLkp9wFEdhs2WvTo4gP
         VLsAWYCgICy8kIWmhGSwrSuW26ZI1FxWVzKQR78rWw88O3d+IkAs8dctTEJEbFGlgEz/
         W7ypsaitvzAkgHqpm2jAIEqe41FXIvK8tW36r9V+ccB7PhdfKbZP8rPnWWsPT93d6aBc
         DYAw==
X-Gm-Message-State: AO0yUKVDUkUtNyhIfMR7yIRyHXw8v5pPTeSXU93l3d91qYjqGIAQjRUO
        NbYJS+XycW5FFH1pe6mwmXTNaMraZ+14uGdjtiM=
X-Google-Smtp-Source: AK7set+hOtnRk+qv+mClFvaRL1/R3Qml7puc5AuPLJ04zytXRlCcUdQoy38YoFwXbCxX06FIf9stExK/tK3Naq6QgOM=
X-Received: by 2002:a17:906:6b83:b0:878:790b:b7fd with SMTP id
 l3-20020a1709066b8300b00878790bb7fdmr8941949ejr.14.1678292882589; Wed, 08 Mar
 2023 08:28:02 -0800 (PST)
MIME-Version: 1.0
References: <20221209142615.33574-1-jandryuk@gmail.com> <87359gkc1d.fsf@baylibre.com>
 <CAKf6xpsGy7rjK3Rkosevr3dD+64-WqCEzAecBbHEHpBMeAHh7A@mail.gmail.com>
In-Reply-To: <CAKf6xpsGy7rjK3Rkosevr3dD+64-WqCEzAecBbHEHpBMeAHh7A@mail.gmail.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Wed, 8 Mar 2023 11:27:50 -0500
Message-ID: <CAKf6xpsXjZ11cB05q3iKUcY3k2i0MXnpC-8anRe8YAwwxrhh7A@mail.gmail.com>
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

On Wed, Mar 8, 2023 at 11:26=E2=80=AFAM Jason Andryuk <jandryuk@gmail.com> =
wrote:
>
> On Thu, Dec 15, 2022 at 8:54=E2=80=AFAM Mattijs Korpershoek
> <mkorpershoek@baylibre.com> wrote:
> >
> > On Fri, Dec 09, 2022 at 09:26, Jason Andryuk <jandryuk@gmail.com> wrote=
:
> >
> > > xen kbdfront registers itself as being able to deliver *any* key sinc=
e
> > > it doesn't know what keys the backend may produce.
> > >
> > > Unfortunately, the generated modalias gets too large and uevent creat=
ion
> > > fails with -ENOMEM.
> > >
> > > This can lead to gdm not using the keyboard since there is no seat
> > > associated [1] and the debian installer crashing [2].
> > >
> > > Trim the ranges of key capabilities by removing some BTN_* ranges.
> > > While doing this, some neighboring undefined ranges are removed to tr=
im
> > > it further.
> > >
> > > An upper limit of KEY_KBD_LCD_MENU5 is still too large.  Use an upper
> > > limit of KEY_BRIGHTNESS_MENU.
> > >
> > > This removes:
> > > BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
> > > Empty space 0x224..0x229
> > >
> > > Empty space 0x28a..0x28f
> > > KEY_MACRO1(0x290)..KEY_MACRO30(0x2ad)
> > > KEY_MACRO_RECORD_START          0x2b0
> > > KEY_MACRO_RECORD_STOP           0x2b1
> > > KEY_MACRO_PRESET_CYCLE          0x2b2
> > > KEY_MACRO_PRESET1(0x2b3)..KEY_MACRO_PRESET3(0xb5)
> > > Empty space 0x2b6..0x2b7
> > > KEY_KBD_LCD_MENU1(0x2b8)..KEY_KBD_LCD_MENU5(0x2bc)
> > > Empty space 0x2bd..0x2bf
> > > BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
> > > Empty space 0x2e8..0x2ff
> > >
> > > The modalias shrinks from 2082 to 1550 bytes.
> > >
> > > A chunk of keys need to be removed to allow the keyboard to be used.
> > > This may break some functionality, but the hope is these macro keys a=
re
> > > uncommon and don't affect any users.
> > >
> > > [1] https://github.com/systemd/systemd/issues/22944
> > > [2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net=
/T/
> > >
> > > Cc: Phillip Susi <phill@thesusis.net>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> >
> > Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
>
> Thank you, Mattjis.

Thank you, Mattijs.  My apologies.

Regards,
Jason
