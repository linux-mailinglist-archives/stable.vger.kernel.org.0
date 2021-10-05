Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5596421DB1
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 06:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhJEEw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 00:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhJEEwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 00:52:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEE3C061745;
        Mon,  4 Oct 2021 21:50:35 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k23so2249300pji.0;
        Mon, 04 Oct 2021 21:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ykx0E0HoH3gswN00KBdlmyPkgBtTSiv8X3i/sICQMYU=;
        b=WmuQnKkjijrqbv3StPV2yJhsrhB7Rvv5yv/oNegG2zbI9MpArDC6VJTMLqChpgtU3F
         snPnOhKtvvcgIOwemaRFiVPSId9IQROA+B5KB7wtS/Kgwu32WMIFcELzsm+QwqtOtrSN
         6NcxyqzCng5XBCiciMIimuUqBRrNN4Rq2RwkKdN/WmojlRctstWrH0q/hblJqyH7xdZT
         mD8qs4GtPXK+eEF3n3JCvHM/G/5VlftJNkf4g+wYWWRM6NO0EDeQOIudp04IiPwDVo1c
         vSOHw23lq7JYGdA+kmH3X1yN3m7M95IMNDHzl0et2qb+Gr+Nm6YTn9xHthN2VFgChR9F
         02pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ykx0E0HoH3gswN00KBdlmyPkgBtTSiv8X3i/sICQMYU=;
        b=HMCS13nAxkfiN4F0sUo22Wg4r6bjg1OtKs/EVyu8/IC9T06a85ucxRK+1v4609bhlG
         DG3BCn2Lzp5Q/Z/IzmvWfYp1nhCxKXPB+pQn5iI2AXmH2/g9dEKc2nYxJ5OaYsWyVrek
         k8CqdseWWaT0crfGW/dvMwYl1GrNoM57GcpVFujdPfQvNZSxCRq4PLt/EZWDB/dss16k
         e6jlaKqurhKLGboX5DAN4b5MCAilGWPO75Y1NwZjRnRSzBeiE2AZnG5NUWwyHxDWTTjv
         Rpq8QG+pb/gF8PFmVfouWeFwpUAG2+/Rqdey7GsydlLy5sRGZ4SDq/MjPBMbUCR1+dTW
         4Phw==
X-Gm-Message-State: AOAM532vOBK/aqW4WrZOTeOlAy/6uyvHjh/O6kHernQm+o1bUhH5nEQC
        PcPszniz1exS6kvfu5MACmaJnerQZNGhGw==
X-Google-Smtp-Source: ABdhPJxVMbu6CZZnqH4S7a6FUaErlJ6fIwdM+UzNqTo6+TlZEwgNLF0BdrKjiEM97J5z++Q6b5Qlvg==
X-Received: by 2002:a17:90b:1105:: with SMTP id gi5mr1347588pjb.100.1633409435006;
        Mon, 04 Oct 2021 21:50:35 -0700 (PDT)
Received: from unconquered.home.aehallh.com (24-113-252-168.wavecable.com. [24.113.252.168])
        by smtp.gmail.com with ESMTPSA id i8sm15901446pfo.117.2021.10.04.21.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 21:50:34 -0700 (PDT)
From:   "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>
To:     platform-driver-x86@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] platform/x86: gigabyte-wmi: add support for B550 AORUS ELITE AX V2
Date:   Mon,  4 Oct 2021 21:48:55 -0700
Message-Id: <20211005044855.1429724-1-zephaniah@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This works just fine on my system.

Signed-off-by: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index d53634c8a6e0..658bab4b7964 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),
-- 
2.33.0

