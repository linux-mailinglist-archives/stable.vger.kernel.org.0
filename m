Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BA0439939
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhJYOwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 10:52:35 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:51514
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233624AbhJYOwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 10:52:13 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7C5913F320
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635173390;
        bh=KricW4D7VolKL3JPfDUExtQxStN8Nau+m8lKmFDnDuQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=f8KTU5sgHG/SgF5CRj6zA5LjHshGBwrZM3hY3wUp6wuK76W67OpsV82HUbW8UZ2Xa
         H7lqO2odLSOcjEw4F/bFT/eE1WYLR5pArXz46UxoyI9EmIEOi5mS7F0woS0qSzsOgB
         hoAWspch+Sl62NaSv+DuARGSpSrG3q651WZI759Y6dn64SGq4SJ6L2sbbJf1cSO62G
         NAOGHNfIvd5LwLPaIsdF6bPCd9C8Xx32LcR6EhRvFmpwikec6OUchk9+rSLYHHwSiN
         dUGPYsF4Hq8Df4k8wft0Z3BoUDI9XUgHwv3UHEYO7DveIUOz7JkFMZwJ173nuioI02
         svBfQjkLKl8xg==
Received: by mail-lf1-f72.google.com with SMTP id i1-20020a056512340100b003fdd5b951e0so5305926lfr.22
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 07:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KricW4D7VolKL3JPfDUExtQxStN8Nau+m8lKmFDnDuQ=;
        b=uXt9eI5HfgPL5gl1/hcB8htBlXJdTx5WAjajT9bAr8V0+0rcbMHzI1hRVv929L1uEn
         S+0rJxj1DF+zN8S/lnbet8H1kxGPcXU2JhONrLYG+dDQQSudKE3rzEpoSSab6REDuE5Z
         Pmzep1lxXpCVfCs02bE7ie2oRBrXxTbVzqZplZ6BPeliWKVFNNrmGP8FimbHjtqPPROG
         Bi7Y08eFUfKjhT5EEScexRdO7BPwtpnUQ61ckg2dNCL8CDLwJcUyzbman9yLdjd+Q8uj
         OABinnRwO51biTEF7I4jYdkZjJGiD+0AKX3NG71+O3uOSna+GJgqzCVYLtlMLP7gcfBx
         RCXg==
X-Gm-Message-State: AOAM531Tk0eaaPturMNpumUiHxNHaZRukwEuanIQ8du4Gfo99i0iUYUo
        Y7UhIt6Yto+WKoYKYjAXjsrdxr17s3p942+eGuLz7BEFhbYGPYOP6FujWHYDqbQfcGnyZvezCBp
        AiwOBb5gQ5Coih6sM7lCjQUWyHV9w0YejYA==
X-Received: by 2002:ac2:5d71:: with SMTP id h17mr14204464lft.642.1635173389990;
        Mon, 25 Oct 2021 07:49:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxRQErlF/R1paw1cLXY13RG/G2M/k1Cz7GJkjb23Wq22EpZlnXHsMIgnnBJ+035rSdh+yV5w==
X-Received: by 2002:ac2:5d71:: with SMTP id h17mr14204445lft.642.1635173389830;
        Mon, 25 Oct 2021 07:49:49 -0700 (PDT)
Received: from kozik-lap.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id j15sm1660922lfe.252.2021.10.25.07.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 07:49:49 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Thierry Escande <thierry.escande@linux.intel.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] nfc: port100: fix using -ERRNO as command type mask
Date:   Mon, 25 Oct 2021 16:49:36 +0200
Message-Id: <20211025144936.556495-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During probing, the driver tries to get a list (mask) of supported
command types in port100_get_command_type_mask() function.  The value
is u64 and 0 is treated as invalid mask (no commands supported).  The
function however returns also -ERRNO as u64 which will be interpret as
valid command mask.

Return 0 on every error case of port100_get_command_type_mask(), so the
probing will stop.

Cc: <stable@vger.kernel.org>
Fixes: 0347a6ab300a ("NFC: port100: Commands mechanism implementation")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Changes since v1:
1. Drop debug code.
---
 drivers/nfc/port100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 517376c43b86..16ceb763594f 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1006,11 +1006,11 @@ static u64 port100_get_command_type_mask(struct port100 *dev)
 
 	skb = port100_alloc_skb(dev, 0);
 	if (!skb)
-		return -ENOMEM;
+		return 0;
 
 	resp = port100_send_cmd_sync(dev, PORT100_CMD_GET_COMMAND_TYPE, skb);
 	if (IS_ERR(resp))
-		return PTR_ERR(resp);
+		return 0;
 
 	if (resp->len < 8)
 		mask = 0;
-- 
2.30.2

