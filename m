Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FD439F97D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhFHOs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:48:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37104 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbhFHOsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 10:48:25 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lqczv-0002cU-Ly
        for stable@vger.kernel.org; Tue, 08 Jun 2021 14:46:31 +0000
Received: by mail-wr1-f69.google.com with SMTP id f22-20020a5d58f60000b029011634e39889so9519405wrd.7
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 07:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UYq7ckgTIydjDJ8JeL1Uz8tXR1AIJE+2YJoedK0dqE4=;
        b=G1AQxtvW5SCM6O7qvznS8qeAakfBePCHal3PQrkrGHMpeI/9YR3FL5U65ngS+oyNqU
         glrvem6cFrzk/gz/IyvaPrKE8fHxiXVrmaDspFc7r+kBytU7tNCDJ9RQ9+CPbSjN55/b
         v43TTBBdJ0RSq9/UYJtFbp54TYWMi12kMBV2FKSY6vNJtYxrBkwIg2GX/jMpUIgaCPRE
         L560OA0g+ZNbbB8v/6rGfFniYrl7Y+r4xWEvaoN7nvlwrZyvlH1WoV099ktdLQ7aL7s1
         TT0NUziKMvY8KBPGbp4D4qCBIwi2NqELqg9cx56ueOv+sc0HTKqQ8KX/wF8OqAm5w5eP
         tZ2w==
X-Gm-Message-State: AOAM531GQQFU7522jmKTkJ2oqNAzrwFMK4bpkrFMzphyeo58WvyUBBNi
        YtB17dFwrbNNEAIZQLPH7IsJNtMgW+1j51Zw05UBveve3nR1i+sKo4PrKhIZZ9PTUNWijqICnEw
        ViMxG+6IHPNnmJPvehOP0qkscgiQio8sbEg==
X-Received: by 2002:adf:fbce:: with SMTP id d14mr22657570wrs.201.1623163591228;
        Tue, 08 Jun 2021 07:46:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw52UcFq0n5SkBMYoaNtvgWvEmfDmxo50JAoPVegqzQ/5T+epVv4spV2Hr2CxLDsod6l7Loeg==
X-Received: by 2002:adf:fbce:: with SMTP id d14mr22657562wrs.201.1623163591121;
        Tue, 08 Jun 2021 07:46:31 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id l5sm3030641wmi.46.2021.06.08.07.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 07:46:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     thibaut.collet@6wind.com, jean-mickael.guerin@6wind.com,
        alfonso.sanchez-beato@canonical.com,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v5.4] bnxt_en: Remove the setting of dev_port.
Date:   Tue,  8 Jun 2021 16:46:21 +0200
Message-Id: <20210608144621.668749-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

commit 1d86859fdf31a0d50cc82b5d0d6bfb5fe98f6c00 upstream.

The dev_port is meant to distinguish the network ports belonging to
the same PCI function.  Our devices only have one network port
associated with each PCI function and so we should not set it for
correctness.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

For stable v5.4. Earlier could work as well, just did not check.

Reported for Ubuntu backport here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1931245
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 106f2b2ce17f..66b0c917fe50 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7002,7 +7002,6 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 
 		pf->fw_fid = le16_to_cpu(resp->fid);
 		pf->port_id = le16_to_cpu(resp->port_id);
-		bp->dev->dev_port = pf->port_id;
 		memcpy(pf->mac_addr, resp->mac_address, ETH_ALEN);
 		pf->first_vf_id = le16_to_cpu(resp->first_vf_id);
 		pf->max_vfs = le16_to_cpu(resp->max_vfs);
-- 
2.27.0

