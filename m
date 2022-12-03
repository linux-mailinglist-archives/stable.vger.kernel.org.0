Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD01641977
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLCWZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLCWZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:25:05 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214A81E3CC
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 14:25:04 -0800 (PST)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2FDB33F32E
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670106302;
        bh=5V4W++/XMlBVjMa9teEJxbmgrLQi1PC1nED7yOm7z6U=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=jb7TTNBKVb+SZxwLjZ+ujzmwKxq8hqztpKQiwRdLq0Sg5FTAD0NcoZyHVHIt2j75y
         eBVNkPRRhwBrUiyUIXQqiRxCLV3KdGmeDRsbF5ZxfcYi+Rcxaaap4uqVIzi58Q+RWF
         sKacYMFXV5m5VYv+8Yvg+O0ZACVnGHmWRD7IO9yQevTuxDdSNxF7iNAVx+srUKakBM
         +tGjFB0p/q+Gz/VoywAXpIxX3jTn+vU1dE7lOKCTjrz5rnofptGQ9D2zWCu/YHLNbC
         n2f12kiaMDKlGPCkt/iNPlC8LrTG9bZRWRxeVPQX0Dg9Gd0emhO2t2tllG3pRxM055
         u+CDQQD2xsHIA==
Received: by mail-wm1-f72.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso4509568wmh.2
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 14:25:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5V4W++/XMlBVjMa9teEJxbmgrLQi1PC1nED7yOm7z6U=;
        b=cWZl6cJZWWZwmjWXBcKunKL5m0mHqrmAMUttQmoYqgT4i9YJHi0TuCnNfa7v16i7if
         2vbgtvwAqA28q0IRb9KI/QLyh3wL7FxWeAWpfrEuBNWynT4mR20kvke/oaM5d6lAThrU
         WW7P28CV+A031VmVBEH+K5U8epemx7PcOZJPHtz0CpUzq5PCJLUMvEoKm98yVV5/uYcP
         ErQVZuX350aVfrmtaGECdsc4SeQvCW631iLFQdXCya2CMRjz7UpexVaw/u5RoM+zQmrA
         YR42/YuE0xX68tydnCo+ZO+jHh66tKrjPvxEvyr+UE4Gn39PC//+BqVtJV6zo9na9yGR
         xZAg==
X-Gm-Message-State: ANoB5pl78H9A2KFmVI78SPPt1Yx1h4wXDObQTxZ1j0UyAGcNJYNm4YEI
        MNLJB+5lXeLF9y1dPGF7gDEF4TYrXQEOccEyAqtnjo2Si7ZluL5LmUt0D0M4ji58Gd9el82XdPp
        SFgk6i3DynI5mpAop/OHeHFrjTFZYSO7ZIQ==
X-Received: by 2002:a05:600c:3583:b0:3b4:6c36:3f59 with SMTP id p3-20020a05600c358300b003b46c363f59mr45366756wmq.100.1670106301519;
        Sat, 03 Dec 2022 14:25:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7x2h380JaaKZ30JJuWWlm2twjdIm2P54yHeYCcurLq+4TjZ5dEj8onVLEjvDepVM8X4LMIlA==
X-Received: by 2002:a05:600c:3583:b0:3b4:6c36:3f59 with SMTP id p3-20020a05600c358300b003b46c363f59mr45366751wmq.100.1670106301271;
        Sat, 03 Dec 2022 14:25:01 -0800 (PST)
Received: from localhost ([92.44.145.54])
        by smtp.gmail.com with ESMTPSA id n5-20020adff085000000b00236c1f2cecesm12692248wro.81.2022.12.03.14.25.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 14:25:00 -0800 (PST)
From:   Cengiz Can <cengiz.can@canonical.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 0/3] Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM
Date:   Sun,  4 Dec 2022 01:24:33 +0300
Message-Id: <20221203222434.669854-1-cengiz.can@canonical.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

commit 711f8c3fb3db ("Bluetooth: L2CAP: Fix accepting connection request for 
invalid SPSM") did not apply to 5.4-stable tree previously.

One of the notable dependencies is commit 15f02b910562 ("Bluetooth: L2CAP: 
Add initial code for Enhanced Credit Based Mode") and that doesn't apply to 
5.4-stable either due to a mismatch on `l2cap_sock_setsockopt_old` in 
l2cap_sock.c.

After doing a comparison between upstream and older revisions, I merged the
changes and backported 15f02b910562 to 5.4-stable.

During compilation, I discovered another dependency commit 145720963b6c 
("Bluetooth: L2CAP: Add definitions for Enhanced Credit Based Mode") and
added that to patchset.

All those combined will hopefully allow us to have the fix for CVE-2022-42896 
in 5.4-stable.

Thank you.

Luiz Augusto von Dentz (3):
  Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode
  Bluetooth: L2CAP: Add definitions for Enhanced Credit Based Mode
  Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM

 include/net/bluetooth/l2cap.h |  43 +++
 net/bluetooth/l2cap_core.c    | 570 +++++++++++++++++++++++++++++++++-
 net/bluetooth/l2cap_sock.c    |  24 +-
 3 files changed, 617 insertions(+), 20 deletions(-)

-- 
2.37.2

