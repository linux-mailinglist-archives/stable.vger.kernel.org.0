Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7564197A
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiLCWZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiLCWZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:25:46 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9289E1E3C8
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 14:25:45 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6AAA23F32E
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 22:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670106344;
        bh=wFsYztbw1d6XulBSaI2xfDMO/g3Xp+TD1FE/YSUSzHM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=jzUDK87GO+8U72e7o/3ZW/0X9CLiG6BFJMHtpCPJpUddS3baNrABspLWp/ImMej0I
         XjKpUVlXU3pfwLgQ8kBEVUtvhzWrA03HDP4NeM+XBbIgu/ZOEXAUx9gYfhnDQ9gwcb
         FByi0GDhdXbL6dtT7IvtOhZES1fkVTgMuFqbZgwTLLbXdur0BgwSGzU5zH1WT+M9+I
         UsuZSVX9Yrh6wsnIGDcuIaYsSw2ciroQ9S5adLPCB1BweSMq1Hpjaf9wJiqKuKiNaZ
         2Ywj6BRpfbLf95g4ryhJ+mYEuqoiP83zE7rnr+qPSQkDWYOvSExr3fkUEHDYMZ7YSC
         0v4DEbUvG9y+g==
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso4510239wmh.2
        for <stable@vger.kernel.org>; Sat, 03 Dec 2022 14:25:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wFsYztbw1d6XulBSaI2xfDMO/g3Xp+TD1FE/YSUSzHM=;
        b=5BpVGb5w3BDISMhPoEx7HzQp1UXH+HX9Uu2vs3VHh+g7toshwD7pJMdtqCRmJgvR+f
         u3xPMd0LE4uHuCF1DS283yYHandhTruI2SzxBDAYz+t1yX6BkXYBhDm6nqr4tWWXggYP
         HU6+10IrOzwvQlsZJl1fkGEwhGFDI2071PIBx1+/lJI9wgenQNPhUypOevFB2xRacOwa
         ItJnUPKJ6NYMuzl6WjPqCrxWeWqefrMy4wtP/DM9/V5wFDIIgIDcERqcRvyg8ry+8bmU
         4Ewxh7sbwkvof95FnADCkFAcZeM/u9KjJKcFYzw1SBpqi121dopp3jwKQ/luiJLc65T8
         n4zw==
X-Gm-Message-State: ANoB5pkI0oqAJcFSRVe/5onTWwPfXD55LiL5GcU5pzJipP3jTwgTCWUf
        0Ifa67nvSqAXxbYUh73v3FAWvrE3GFrFjC8edFKfNqIl8jviInFnl+RSLBcMgklvSJ9HnE+RwT3
        SWEu2HDQZM+x2YJq7DVpOcPS3wWkdSlgVqQ==
X-Received: by 2002:a05:600c:4f82:b0:3cf:aa11:9394 with SMTP id n2-20020a05600c4f8200b003cfaa119394mr43464715wmq.183.1670106343930;
        Sat, 03 Dec 2022 14:25:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4fiNvSs/38KBeTPcnSe4ZGDsFSPJmVFr6teRvaqjpxPVbSTii6SuAC8uglbeqo8x0alojIng==
X-Received: by 2002:a05:600c:4f82:b0:3cf:aa11:9394 with SMTP id n2-20020a05600c4f8200b003cfaa119394mr43464710wmq.183.1670106343727;
        Sat, 03 Dec 2022 14:25:43 -0800 (PST)
Received: from localhost ([92.44.145.54])
        by smtp.gmail.com with ESMTPSA id ba16-20020a0560001c1000b002365254ea42sm11430464wrb.1.2022.12.03.14.25.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 14:25:43 -0800 (PST)
From:   Cengiz Can <cengiz.can@canonical.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 3/3] Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM
Date:   Sun,  4 Dec 2022 01:24:39 +0300
Message-Id: <20221203222434.669854-4-cengiz.can@canonical.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221203222434.669854-1-cengiz.can@canonical.com>
References: <20221203222434.669854-1-cengiz.can@canonical.com>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 711f8c3fb3db61897080468586b970c87c61d9e4 upstream

The Bluetooth spec states that the valid range for SPSM is from
0x0001-0x00ff so it is invalid to accept values outside of this range:

  BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
  page 1059:
  Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges

CVE: CVE-2022-42896
Reported-by: Tamás Koczka <poprdi@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Cc: stable@vger.kernel.org # 5.4.x
Signed-off-by: Cengiz Can <cengiz.can@canonical.com>
---
 net/bluetooth/l2cap_core.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index d4d818f3caa7..c4c25af1dbd5 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5686,6 +5686,19 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 	BT_DBG("psm 0x%2.2x scid 0x%4.4x mtu %u mps %u", __le16_to_cpu(psm),
 	       scid, mtu, mps);
 
+	/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
+	 * page 1059:
+	 *
+	 * Valid range: 0x0001-0x00ff
+	 *
+	 * Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges
+	 */
+	if (!psm || __le16_to_cpu(psm) > L2CAP_PSM_LE_DYN_END) {
+		result = L2CAP_CR_LE_BAD_PSM;
+		chan = NULL;
+		goto response;
+	}
+
 	/* Check if we have socket listening on psm */
 	pchan = l2cap_global_chan_by_psm(BT_LISTEN, psm, &conn->hcon->src,
 					 &conn->hcon->dst, LE_LINK);
@@ -5864,6 +5877,18 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	psm  = req->psm;
 	credits = 0;
 
+	/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
+	 * page 1059:
+	 *
+	 * Valid range: 0x0001-0x00ff
+	 *
+	 * Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges
+	 */
+	if (!psm || __le16_to_cpu(psm) > L2CAP_PSM_LE_DYN_END) {
+		result = L2CAP_CR_LE_BAD_PSM;
+		goto response;
+	}
+
 	BT_DBG("psm 0x%2.2x mtu %u mps %u", __le16_to_cpu(psm), mtu, mps);
 
 	memset(&pdu, 0, sizeof(pdu));
-- 
2.37.2

