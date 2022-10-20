Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77006060B8
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 14:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiJTM5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 08:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiJTM47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 08:56:59 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC74617F2A9;
        Thu, 20 Oct 2022 05:56:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id q19so29755869edd.10;
        Thu, 20 Oct 2022 05:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=211dklALD6kGYLtQWYoou26mE1SCmw0zj++qOMCYAqo=;
        b=bB5izx67N6r3OD509n1Qml1Lhtq/mqwKb4YnJlEiBLkuOTQy7gJbbSSoQsG2j89rW3
         tfz2SZsi4mEYpMMuj1CuhgwdREvJeeUr+UW59UTPIjEopAltK2ihEAbKBNCi44cOIces
         kaq76CsNQuhycRuA6xevwN81B0e6J2ee7qzuk287844nUVu34FM5nhrACUtUHjn2MBrZ
         r+KSmX4jMMyUGVB6zvMJ/sDNPA1fgt96q/04oYFl8uJEuxXd8me1MZcWUgEI7GUBuTv5
         lsxMnj/5W2DEB5vXJvle3f3wRI/0723NSensamUuIjaX3sDc6/Y2E9CB4ulFbu314xbz
         hVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=211dklALD6kGYLtQWYoou26mE1SCmw0zj++qOMCYAqo=;
        b=eo6obQdHiSTkiuaM1f+aCpz7RnnzXfXZRRCTsp74FmWfr1IO8vZrJ3vF+oDidTtzwA
         Aoo9MvXfVNR/np68rIHhUo7+5G3RB7hGIKxHpqhOQ7+30aEvlB+jMLZp+mbisKPwoZr3
         Szs0L9G3flknoP1n1hlnz8fp8vbNGWPOVTLTnEGBp1nALX1qphU+xO1lEosE8gQsR/AP
         egQPfDxsHY2cMfCfljZT88NUGnvjGtaTkEjN09N2evzFGQjA5nGoEG5fl44wHdhtESYX
         8ksO+N5T4yN8BrprJu6f6madiRkGlNCC2tnOSV9sjVwB77dDyf/K7xoPDkBjsyqn89qH
         h/Aw==
X-Gm-Message-State: ACrzQf1BCWvl7ze8ABLKBPR5m0VHnI0J3FBqn0vgI4ALjNvd/KFXFrB9
        k4P/RPefiPf0vabEmXwAlBqgNHk19QNdzi4H69s=
X-Google-Smtp-Source: AMsMyM6ct2gQbef1pZcBeR72NPxKc89pqQgxVpdTN84gbT3+Qc7/qAxzeQBOM4cb7WeVMjaW6um+zrL3dI2YH/lcqB4=
X-Received: by 2002:aa7:ca45:0:b0:458:d9a2:6164 with SMTP id
 j5-20020aa7ca45000000b00458d9a26164mr12275972edt.340.1666270600413; Thu, 20
 Oct 2022 05:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221019201458.21803-1-jandryuk@gmail.com> <87zgdq99qx.fsf@baylibre.com>
 <CAKf6xpvHa86frvOp5L3x1nerTCQD=cjz7xqR4VwFBExquKG5bw@mail.gmail.com>
In-Reply-To: <CAKf6xpvHa86frvOp5L3x1nerTCQD=cjz7xqR4VwFBExquKG5bw@mail.gmail.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Thu, 20 Oct 2022 08:56:27 -0400
Message-ID: <CAKf6xpvd6rg4AP1XfhCLo0K+BfhVrydBhJy8TReAaTD_1zcY0g@mail.gmail.com>
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

On Thu, Oct 20, 2022 at 8:21 AM Jason Andryuk <jandryuk@gmail.com> wrote:
>
> On Thu, Oct 20, 2022 at 4:31 AM Mattijs Korpershoek
> <mkorpershoek@baylibre.com> wrote:
> >
> > On Wed, Oct 19, 2022 at 16:14, Jason Andryuk <jandryuk@gmail.com> wrote:
> >
> > > xen kbdfront registers itself as being able to deliver *any* key since
> > > it doesn't know what keys the backend may produce.
> > >
> > > Unfortunately, the generated modalias gets too large and uevent creation
> > > fails with -ENOMEM.
> > >
> > > This can lead to gdm not using the keyboard since there is no seat
> > > associated [1] and the debian installer crashing [2].
> > >
> > > Trim the ranges of key capabilities by removing some BTN_* ranges.
> > > While doing this, some neighboring undefined ranges are removed to trim
> > > it further.
> > >
> > > This removes:
> > > BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
> > > Empty space 0x224..0x229
> > >
> > > Emtpy space 0x2bd..0x2bf
> > > BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
> > > Empty space 0x2e8..0x2ff
> > >
> > > The modalias shrinks from 2082 to 1754 bytes.
> > >
> > > [1] https://github.com/systemd/systemd/issues/22944
> > > [2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net/T/
> > >
> > > Cc: Phillip Susi <phill@thesusis.net>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> >
> > Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
>
> This patch doesn't work and needs to be withdrawn.  My gdm/udev
> workaround was still active when I tested, so that is why I had a
> working keyboard.  Sorry about that.
>
> Now the question is, which additional keys can be omitted to trim the
> modalias to an acceptable size?
>
> Regards,
> Jason
>
> > > ---
> > >  drivers/input/misc/xen-kbdfront.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
> > > index 8d8ebdc2039b..23f37211be78 100644
> > > --- a/drivers/input/misc/xen-kbdfront.c
> > > +++ b/drivers/input/misc/xen-kbdfront.c
> > > @@ -256,7 +256,14 @@ static int xenkbd_probe(struct xenbus_device *dev,
> > >               __set_bit(EV_KEY, kbd->evbit);
> > >               for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
> > >                       __set_bit(i, kbd->keybit);
> > > -             for (i = KEY_OK; i < KEY_MAX; i++)
> > > +             /* In theory we want to go KEY_OK..KEY_MAX, but that grows the
> > > +              * modalias line too long.  KEY_KBD_LCD_MENU5 is the last
> > > +              * defined non-button key. There is a gap of buttons from
> > > +              * BTN_DPAD_UP..BTN_DPAD_RIGHT and KEY_ALS_TOGGLE is the next
> > > +              * defined. */
> > > +             for (i = KEY_OK; i < BTN_DPAD_UP; i++)
> > > +                     __set_bit(i, kbd->keybit);
> > > +             for (i = KEY_ALS_TOGGLE; i <= KEY_KBD_LCD_MENU5; i++)

Changing the upper bound to KEY_BRIGHTNESS_MENU works.  That trims out
KEY_MACRO* and KEY_KBD_LCD_MENU*.

Something has to get trimmed out to bring the size down.  These are
probably less common and okay to remove, but I'm just guessing.

Regards,
Jason
