Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78D860600B
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJTMVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 08:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJTMVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 08:21:42 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C38C1D3475;
        Thu, 20 Oct 2022 05:21:41 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id 13so46872554ejn.3;
        Thu, 20 Oct 2022 05:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IGrBQa4dKAVSu2S4BcOlLBn8S/NnavFLgJaicb8vQu0=;
        b=ZQpm2lcsli3QYI8c+XXlZ/PVz3ooW6w4b5Mmjq4S3wj2ZWs0gomnrAEswUfuVMSEcB
         eH24HXopl+ejc6j6q/xST8VBrxCaZYXtbEYUPmay04U2bKYOwf9a3pXlqchfvHgimGxX
         as0oF66ECDb/95M4SC8EA9Ok4PNFayvL7AQqqeHJE1HNYRygU07DNFiOxi4+xPxF0Td7
         w6NULbuuQSXju9Ujzv80/cNS10Vf8HrMlRdu5OYSFgeyeLtjYXYgKWdNRjL67GY8bz3Q
         +nrJhBhKiywK9iOG50lN3PB+JLhDtnXo99WNa8FWonU0GY2Uq6cgONd6aHAz0rRUptDu
         u4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IGrBQa4dKAVSu2S4BcOlLBn8S/NnavFLgJaicb8vQu0=;
        b=2rxQiM8ISa6m9FVZ5HzmYbNc4XUYpkIjd3OEMrektkzzJtWWkd+1rUT98TMUgw6yp8
         ar60sHfF7ouVU3wESGJ19adMYEbbdFu/xyfG/HHiIgTHd/vKz/xjzv3eEq5GTD4cKpNF
         kovayUnHBfU6xkzG/+3zX2RZEExPJHKTZSNTAZ6Xti0/+lz91/KJbYddHm1IbWzP9vbB
         1m0m7YNLwVsz0xYvV0QNvJYXlGfl75R/ySxUW71Tp97sL9kdV3sEEocvTtLvr1FbyMuk
         rh/1r97rRleJZ0mFvhNi8/LPS63vSHWtvDlqnWM7Ayl3UzlTZGrDSp2iAljv9BMaRuRK
         COBQ==
X-Gm-Message-State: ACrzQf0tmTAlk+CNaf0Pt1g7zF5nLbA83n/ZZk95gyIWq0co7L7evvnv
        77TDogOKEjnW6a+hRf9ywCOACW++mwUB4qU8IJs=
X-Google-Smtp-Source: AMsMyM5rrYLJxnUL0QjcOxLrM4KH7p1BP8kgKiFJVnjNMqYfXBoY0qw73eoKLyoIKGqreJdS0nOkOF5NidYfzvwAPyA=
X-Received: by 2002:a17:907:788:b0:741:4d1a:595d with SMTP id
 xd8-20020a170907078800b007414d1a595dmr10552932ejb.737.1666268499744; Thu, 20
 Oct 2022 05:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221019201458.21803-1-jandryuk@gmail.com> <87zgdq99qx.fsf@baylibre.com>
In-Reply-To: <87zgdq99qx.fsf@baylibre.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Thu, 20 Oct 2022 08:21:27 -0400
Message-ID: <CAKf6xpvHa86frvOp5L3x1nerTCQD=cjz7xqR4VwFBExquKG5bw@mail.gmail.com>
Subject: Re: [PATCH] Input: xen-kbdfront - drop keys to shrink modalias
To:     Mattijs Korpershoek <mkorpershoek@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Phillip Susi <phill@thesusis.net>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022 at 4:31 AM Mattijs Korpershoek
<mkorpershoek@baylibre.com> wrote:
>
> On Wed, Oct 19, 2022 at 16:14, Jason Andryuk <jandryuk@gmail.com> wrote:
>
> > xen kbdfront registers itself as being able to deliver *any* key since
> > it doesn't know what keys the backend may produce.
> >
> > Unfortunately, the generated modalias gets too large and uevent creation
> > fails with -ENOMEM.
> >
> > This can lead to gdm not using the keyboard since there is no seat
> > associated [1] and the debian installer crashing [2].
> >
> > Trim the ranges of key capabilities by removing some BTN_* ranges.
> > While doing this, some neighboring undefined ranges are removed to trim
> > it further.
> >
> > This removes:
> > BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
> > Empty space 0x224..0x229
> >
> > Emtpy space 0x2bd..0x2bf
> > BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
> > Empty space 0x2e8..0x2ff
> >
> > The modalias shrinks from 2082 to 1754 bytes.
> >
> > [1] https://github.com/systemd/systemd/issues/22944
> > [2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net/T/
> >
> > Cc: Phillip Susi <phill@thesusis.net>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
>
> Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>

This patch doesn't work and needs to be withdrawn.  My gdm/udev
workaround was still active when I tested, so that is why I had a
working keyboard.  Sorry about that.

Now the question is, which additional keys can be omitted to trim the
modalias to an acceptable size?

Regards,
Jason

> > ---
> >  drivers/input/misc/xen-kbdfront.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
> > index 8d8ebdc2039b..23f37211be78 100644
> > --- a/drivers/input/misc/xen-kbdfront.c
> > +++ b/drivers/input/misc/xen-kbdfront.c
> > @@ -256,7 +256,14 @@ static int xenkbd_probe(struct xenbus_device *dev,
> >               __set_bit(EV_KEY, kbd->evbit);
> >               for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
> >                       __set_bit(i, kbd->keybit);
> > -             for (i = KEY_OK; i < KEY_MAX; i++)
> > +             /* In theory we want to go KEY_OK..KEY_MAX, but that grows the
> > +              * modalias line too long.  KEY_KBD_LCD_MENU5 is the last
> > +              * defined non-button key. There is a gap of buttons from
> > +              * BTN_DPAD_UP..BTN_DPAD_RIGHT and KEY_ALS_TOGGLE is the next
> > +              * defined. */
> > +             for (i = KEY_OK; i < BTN_DPAD_UP; i++)
> > +                     __set_bit(i, kbd->keybit);
> > +             for (i = KEY_ALS_TOGGLE; i <= KEY_KBD_LCD_MENU5; i++)
> >                       __set_bit(i, kbd->keybit);
> >
> >               ret = input_register_device(kbd);
> > --
> > 2.37.3
