Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656BE29DB58
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389307AbgJ1XwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730365AbgJ1XvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 19:51:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA4BC0613D1
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:51:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k6so654851pls.22
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=4L3GRWcn1QXFFa7JJprgoYtKbufpSEL9YuPHfYyVTUE=;
        b=FS11cTDssD4qFhhvSvr8OMnHBQs0YfmUBNbQ6GMBkC0StxVxvOCco6X1AdNk5fwATT
         rrKB4mR973yDSM5JaTDguyAbJZF10hRPGksqjZhPknT29t8nw0unS/rGiwVeHx7BlHy6
         7HdwlGCXHhliyVi0/2ZgWX3KXaOZMFt1JzH1g9ZKMv9cZMkwPTwU5o8eWUsGcn1BsbA3
         fwU8KJN3RZBCTE1W3FZdIDjsSP59sDj+5xy19dyOMurYa4smkhmSYRTc8aQAWd9S1vI3
         hJC+eb5ICQPm7SKGfKABhKAC2uvG4Zf/0yXVi8hSNIxSKrxnoDf6Z8U3NDCZNStXPWC/
         ONqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=4L3GRWcn1QXFFa7JJprgoYtKbufpSEL9YuPHfYyVTUE=;
        b=Hk1tAwx9mEStWR8wcohVknXV+Xr8asaBC5xYga26roU87HqFugsWlM0l7EvpStKhAu
         gWzlzwAw6648RH7iUie4j/WiGKuYYbTxltEGkAWjNy546rMoClcxqZ3ebpkBQu4DCYJw
         B8JgHT/vEnEKjoB9V+HUVh9KLi8OV5h0ehA1PIqaV/ybFlRye+nRilvEQc0dim1hpb3d
         uJHlxwa/1oPpAbejuX+UAhi638GEnvbNpp+FhW+HvR7VB72DBm/ikAqNEJrBlEuUDK1H
         RM4hDsgeRWWKnuU9LwyTJ4DHp+BxhSnSKDh1UhzKgRHyHWBD/v7YHUaVCfIjPrJLGwy3
         4RlA==
X-Gm-Message-State: AOAM5318hE96S8oFNdJFn7xbTh+zvkcLvgquI2GRpuB1fWNJnlM8UHW5
        iH21RabVMHdsWOhUADj68ArSCEr7
X-Google-Smtp-Source: ABdhPJymqtGNqSycCbjZl77iBugadd06rm8G6OX8ko7OYPo2rTeEX7Olc9jYAsonMBIdbCCxyBePF6c7
Sender: "lzye via sendgmr" <lzye@chrisye.mtv.corp.google.com>
X-Received: from chrisye.mtv.corp.google.com ([2620:15c:211:2:f693:9fff:fef4:4323])
 (user=lzye job=sendgmr) by 2002:a17:90a:ec11:: with SMTP id
 l17mr1361011pjy.104.1603929077614; Wed, 28 Oct 2020 16:51:17 -0700 (PDT)
Date:   Wed, 28 Oct 2020 16:51:13 -0700
Message-Id: <20201028235113.660272-1-lzye@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
From:   FirstName LastName <lzye@google.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, trivial@kernel.org,
        stable@vger.kernel.org, linzhao.ye@gmail.com,
        Chris Ye <lzye@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kernel 5.4 introduces HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE, devices
need to be set explicitly with this flag.

Signed-off-by: Chris Ye <lzye@google.com>

diff -uprN -X linux-vanilla/Documentation/dontdiff linux-vanilla/drivers/hid/hid-ids.h linux/drivers/hid/hid-ids.h
--- linux-vanilla/drivers/hid/hid-ids.h	2020-10-26 22:16:49.930361683 -0700
+++ linux/drivers/hid/hid-ids.h	2020-10-26 22:20:02.811994573 -0700
@@ -443,6 +443,10 @@
 #define USB_VENDOR_ID_FRUCTEL	0x25B6
 #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
 
+#define USB_VENDOR_ID_GAMEVICE	0x27F8
+#define USB_DEVICE_ID_GAMEVICE_GV186	0x0BBE
+#define USB_DEVICE_ID_GAMEVICE_KISHI	0x0BBF
+
 #define USB_VENDOR_ID_GAMERON		0x0810
 #define USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR	0x0001
 #define USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR	0x0002
diff -uprN -X linux-vanilla/Documentation/dontdiff linux-vanilla/drivers/hid/hid-quirks.c linux/drivers/hid/hid-quirks.c
--- linux-vanilla/drivers/hid/hid-quirks.c	2020-10-26 22:16:49.930361683 -0700
+++ linux/drivers/hid/hid-quirks.c	2020-10-28 16:14:14.498337383 -0700
@@ -84,6 +84,10 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_GV186),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMEVICE, USB_DEVICE_ID_GAMEVICE_KISHI),
+		HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
