Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F906483B7
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 15:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIO0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 09:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIO0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 09:26:39 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0112018E3B;
        Fri,  9 Dec 2022 06:26:39 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id z12so684301qtv.5;
        Fri, 09 Dec 2022 06:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z26CJkV4bYBR7Igz8UtlKjC+5Be28A36hbOcGnHeAHA=;
        b=lOXPlqVDsCU/iT7WgJtYT6+UXxMsr9qT3EOt0VEoisMXgRg2R6Cue68/yFc610oSNh
         QnEoyGDMtbIXZ0bcGN7E9cL+XqHtaulIlfCJ0SrkEn1pk0KCvOb68uQDaVEEyvCs58xN
         iP0YGW9B+VQG0wWOE4wnxp/GFMyOLOlHRRYGrOvkYDAvxI6ra/Ckgj1Po8LdgacBnJ/q
         5/XMqgDXCxsb8uI9/IVSBogDGas/MITu53Pz8u8YEn0nyhweWfxfITv4XODmPn/pzoS7
         ql5V6+gmKsRgqwaGRdIxKnH/74vE3hD8AEUEPiqyCMnv3Du3zlp6FVPDvVf7G09I8/0e
         hK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z26CJkV4bYBR7Igz8UtlKjC+5Be28A36hbOcGnHeAHA=;
        b=A5wludngEY7viUz7Jp2QoISKmlLsW8oVlhCnRmJCACmi1McKgFME6XxbKsonqLm2Gt
         llvnjNHI9UTNPmZ0tvxFOWlKRqtpCMIlRrmyL+h70hD10iW9YKYXKbRvAFyoX+qBwgL6
         GFxan6hSDMZkyfmzqI5EX1tFBR2kZ91QTdB5vVB9ITzIBd+uJznmKXKK0S5RSqNBw8Ml
         IXnzIakmv6JsCJp5abQVpkeWY1+v/xXaQmuGBYI7RBvlh34xe8aYohV0vMBClND3a03F
         yQrAHWqvUe9qiAAetMpp0yBh9AnkCs6ZKTRpkDQsXWofCPhhLyT4wQzXqYG3mFBustHK
         Mslw==
X-Gm-Message-State: ANoB5pk09SHftm0er3iUtSKpYW9N9BJ6jPeYJKKwQnptRGMZ7Vl7iK1F
        VLupZvmIznLbvONYMDF3wJMdx7b2JrI=
X-Google-Smtp-Source: AA0mqf7cBf3HtEfnMTHbn2B9g1hb6GZYhiARbmje9pr3rZIgEL0K9R+JMsEs+TSJ3w/N9SLufELTUQ==
X-Received: by 2002:a05:622a:1e11:b0:3a5:fa33:917f with SMTP id br17-20020a05622a1e1100b003a5fa33917fmr8841541qtb.37.1670595997584;
        Fri, 09 Dec 2022 06:26:37 -0800 (PST)
Received: from pm2-ws13.praxislan02.com (207-172-141-204.s8906.c3-0.slvr-cbr1.lnh-slvr.md.cable.rcncustomer.com. [207.172.141.204])
        by smtp.gmail.com with ESMTPSA id bb12-20020a05622a1b0c00b003a530a32f67sm944094qtb.65.2022.12.09.06.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 06:26:36 -0800 (PST)
From:   Jason Andryuk <jandryuk@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     xen-devel@lists.xenproject.org, Jason Andryuk <jandryuk@gmail.com>,
        Phillip Susi <phill@thesusis.net>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH v2] Input: xen-kbdfront - drop keys to shrink modalias
Date:   Fri,  9 Dec 2022 09:26:14 -0500
Message-Id: <20221209142615.33574-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xen kbdfront registers itself as being able to deliver *any* key since
it doesn't know what keys the backend may produce.

Unfortunately, the generated modalias gets too large and uevent creation
fails with -ENOMEM.

This can lead to gdm not using the keyboard since there is no seat
associated [1] and the debian installer crashing [2].

Trim the ranges of key capabilities by removing some BTN_* ranges.
While doing this, some neighboring undefined ranges are removed to trim
it further.

An upper limit of KEY_KBD_LCD_MENU5 is still too large.  Use an upper
limit of KEY_BRIGHTNESS_MENU.

This removes:
BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
Empty space 0x224..0x229

Empty space 0x28a..0x28f
KEY_MACRO1(0x290)..KEY_MACRO30(0x2ad)
KEY_MACRO_RECORD_START          0x2b0
KEY_MACRO_RECORD_STOP           0x2b1
KEY_MACRO_PRESET_CYCLE          0x2b2
KEY_MACRO_PRESET1(0x2b3)..KEY_MACRO_PRESET3(0xb5)
Empty space 0x2b6..0x2b7
KEY_KBD_LCD_MENU1(0x2b8)..KEY_KBD_LCD_MENU5(0x2bc)
Empty space 0x2bd..0x2bf
BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
Empty space 0x2e8..0x2ff

The modalias shrinks from 2082 to 1550 bytes.

A chunk of keys need to be removed to allow the keyboard to be used.
This may break some functionality, but the hope is these macro keys are
uncommon and don't affect any users.

[1] https://github.com/systemd/systemd/issues/22944
[2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net/T/

Cc: Phillip Susi <phill@thesusis.net>
Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
---
 drivers/input/misc/xen-kbdfront.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

v2:
Remove more keys: v1 didn't remove enough and modalias was still broken.

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 8d8ebdc2039b..4ecb579df748 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -256,7 +256,14 @@ static int xenkbd_probe(struct xenbus_device *dev,
 		__set_bit(EV_KEY, kbd->evbit);
 		for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
 			__set_bit(i, kbd->keybit);
-		for (i = KEY_OK; i < KEY_MAX; i++)
+		/* In theory we want to go KEY_OK..KEY_MAX, but that grows the
+		 * modalias line too long.  There is a gap of buttons from
+		 * BTN_DPAD_UP..BTN_DPAD_RIGHT and KEY_ALS_TOGGLE is the next
+		 * defined. Then continue up to KEY_BRIGHTNESS_MENU as an upper
+		 * limit. */
+		for (i = KEY_OK; i < BTN_DPAD_UP; i++)
+			__set_bit(i, kbd->keybit);
+		for (i = KEY_ALS_TOGGLE; i <= KEY_BRIGHTNESS_MENU; i++)
 			__set_bit(i, kbd->keybit);
 
 		ret = input_register_device(kbd);
-- 
2.38.1

