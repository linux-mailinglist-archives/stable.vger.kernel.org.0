Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB57646E3DE
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 09:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhLIIQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 03:16:43 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:47688
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230243AbhLIIQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 03:16:43 -0500
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id BD5AF3F1A9
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 08:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639037589;
        bh=li++Q1lkbhIYARBNYivAD9l31K5a4noYe2Z2qkyrMDA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=OnUBjr8J0of7aq5VvS+nGLcZJAwuRgInZNSw0K9G1/yekR6fDocUXPHv4yWegdlwp
         2ZlpBnO1lhk4vhWIfHXLLdxrbEtPIJ5XQLxUZtMBliryKHx4mU3O5T8XD9eInFxgge
         vNOx5EAu4jEwLU1hNIcdJ3+oIL2xAa7S/j3avybKT5iWteYTsDG14WiOYM6AMUzxbi
         HcL1Oqo4c0ROt7tUmueVSSiXIBM+tCTwO/mH2nODUSIc58mL/u4PoSP4Y8KxtJ7hKU
         YEJIJXCqk4Gx1/CrNWP+NClZ44TM+ONgxUthpNzFXIyI3okBKZ1dqwE+AnSI+YH0XY
         9L8rfYbMrW5Og==
Received: by mail-lj1-f200.google.com with SMTP id w16-20020a05651c103000b00218c9d46faeso1523383ljm.2
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 00:13:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=li++Q1lkbhIYARBNYivAD9l31K5a4noYe2Z2qkyrMDA=;
        b=RGHQ37hHYqtzvU9vR9/xHHs9VVhyeziZp4uM73huNFef7OF9aAvKJonCvTDw+oZi5h
         pR1FLusv+gCH620LR4rWsDTPsO1CNqOliIR7aXVSvdRL2MNQe1P0xE1tN+hoagNDviAj
         ShTb0cO/PdsZjvQRG+wdeP31kXnGjNbLoaMT8E8rmGpTmxyDv9EG3DUPH+y7lUyv9Chz
         qV3gX5P2yUSwRhRo0ILOM6KDmj3LZDS8bBhG8hDSkcly8sf28ztdHR/jVe18Ui+sF8G0
         1Vd5uGjPJ+4QJbJOGwkf/JVf0mg5CyraHr6LfUsEkFDfaidnX050DD5tUR+/l3628/Ng
         21bA==
X-Gm-Message-State: AOAM533mUaJV74pI8iJk1hnVpRaFmWRSjNKjiREYA5/R9zdojjEwwIXz
        Z8lZabQt2sRcEXMEMQy1YHtlO2Px0vPaUu5XttkbLDJp6ZmQEkhq1gdvAA53NxzVG9H8yOmvHjo
        1VaW6PDciKyE9R4SfXecfiXeLjbW+w9Xjjg==
X-Received: by 2002:a05:6512:3082:: with SMTP id z2mr4516780lfd.351.1639037589269;
        Thu, 09 Dec 2021 00:13:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxew4i4a9DoT8yTaM1mSJukQJbcgVSv8A/a2FaL4870WYGHn9oTdN4j+N4jiTVK5QQzEioo6A==
X-Received: by 2002:a05:6512:3082:: with SMTP id z2mr4516767lfd.351.1639037589089;
        Thu, 09 Dec 2021 00:13:09 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id s5sm531144ljg.3.2021.12.09.00.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 00:13:08 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tadeusz.struk@linaro.org, stable@vger.kernel.org
Subject: [PATCH] nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done
Date:   Thu,  9 Dec 2021 09:13:07 +0100
Message-Id: <20211209081307.57337-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The done() netlink callback nfc_genl_dump_ses_done() should check if
received argument is non-NULL, because its allocation could fail earlier
in dumpit() (nfc_genl_dump_ses()).

Fixes: ac22ac466a65 ("NFC: Add a GET_SE netlink API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 334f63c9529e..5c706ed75b33 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1392,8 +1392,10 @@ static int nfc_genl_dump_ses_done(struct netlink_callback *cb)
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }
-- 
2.32.0

