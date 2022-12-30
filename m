Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F3659C99
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 22:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiL3V75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 16:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbiL3V74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 16:59:56 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A041CFF7;
        Fri, 30 Dec 2022 13:59:55 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so15032603pjk.3;
        Fri, 30 Dec 2022 13:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BPOpzf4r9Hh/EAielWLYD69jlQAV80ZobxYu4vuYggg=;
        b=L90HY9drT6SHzImE+7wWGUSE3BAbqBnVtnqK0bouVXSOg37GvVcdDJ+fhprEZE+hnS
         7ph2bNLyk8fFRgN036z2Rtm2o0PZeqx+YrAU5AH7yOlT72RvuineviST0yrcSN/Hnmm/
         +wJ0qyEMyMGX0VZQ7spwX7N0J3KYjDe2TySwt/a5V+2BMSmKIapDyOPGuexIAmK80rVi
         OTLJZx7jg4e+LwsPhM550IP0CwmmSegtZj8QGmsZk5ZbBtW1lGw3u5PxnV+zfpB6/4K4
         unlpYcUGTSgcfiTr3lGVZ9i5sg6WJ5OT7IpAThRRS2QJcpZO2L/ORf090rq/uRbJz/Sc
         cv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BPOpzf4r9Hh/EAielWLYD69jlQAV80ZobxYu4vuYggg=;
        b=InT/UTki78HM9mRWKDs4dl7GdaUGN0+oiQ+OSuPueLuerdOxmEbZtpIlJgbqq9lnks
         XkMSBiGhwxmVAQT/krG6DeN89ur7KwrRzrckc45+f6FJFCvUeeBufRx3Hd6uXTDWfRBC
         zZhQXYMW+YAJV/XgKmApW4HkAKw7u7wvL/eso+Ku80uFY4MFdzYT1LN7OBzAU3PsQb6k
         CZ2o4V+5JiQf5dQ32UTLlbAqSgQOCXJbntMLxjdT8ULMnhxC5TV9laroF4xjb9Mi++0Y
         aYQP3pNVJumXdps/GrDZGZ44+6f+B4gVlQM2Bsgmn52dYDzQ82IoroXRkFM+G9fH1cNO
         k1iw==
X-Gm-Message-State: AFqh2koplAsdHbyIfypkxz3uifHxHFVFGcAYjUXogastqbwlAM91Y/eD
        BLZDTKA5Whzhq2cYa0TYyi4=
X-Google-Smtp-Source: AMrXdXsyDm3y9SzyCfbVbczxNS0+3W2zcOER/n7L248Jnz8BpsPIDueIG4+9jGW+8XxZtiVVzWUY/A==
X-Received: by 2002:a17:903:30d2:b0:189:8c38:cb96 with SMTP id s18-20020a17090330d200b001898c38cb96mr29225269plc.20.1672437594713;
        Fri, 30 Dec 2022 13:59:54 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:2403:e698:5f2a:3c9b])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c20200b00190f5e3bcd9sm15481897pll.23.2022.12.30.13.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 13:59:53 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux USB Mailing List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH] usb: storage: de-quirk Seagate Expansion Portable Drive SRD00F1 [0bc2:2320]
Date:   Fri, 30 Dec 2022 13:59:42 -0800
Message-Id: <20221230215942.3241955-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Maciej Żenczykowski <maze@google.com>

Since November 2017 commit 7fee72d5e8f1 ("uas: Always apply US_FL_NO_ATA_1X
quirk to Seagate devices"), the US_FL_NO_ATA_1X is always set for Seagate
devices, but it doesn't appear to be required - at least for this one
(based on internet searches, probably for a fair number more...).

ID 0bc2:2320 Seagate RSS LLC USB 3.0 bridge [Portable Expansion Drive]

Confirmed via:
  smartctl -a /dev/sda
working fine with
  modprobe usb_storage quirks=0bc2:2320:
on
  5.19.11-1rodete1-amd64

Fixes: 7fee72d5e8f1 ("uas: Always apply US_FL_NO_ATA_1X quirk to Seagate devices")
Cc: stable <stable@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Maciej Żenczykowski <zenczykowski@gmail.com>
---
 drivers/usb/storage/uas-detect.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 3f720faa6f97..74d65810f09a 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -112,8 +112,9 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 		}
 	}
 
-	/* All Seagate disk enclosures have broken ATA pass-through support */
-	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
+	/* Most Seagate disk enclosures have broken ATA pass-through support */
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2 &&
+	    le16_to_cpu(udev->descriptor.idProduct) != 0x2320)
 		flags |= US_FL_NO_ATA_1X;
 
 	usb_stor_adjust_quirks(udev, &flags);
-- 
2.39.0.314.g84b9a713c41-goog

