Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4802522B0
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 23:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHYVWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 17:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgHYVWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 17:22:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000C5C061574;
        Tue, 25 Aug 2020 14:22:37 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id 2so176777wrj.10;
        Tue, 25 Aug 2020 14:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8yrvm2wRlJdJMJvVgVYmOkiM4rYd8h4RVIKqWc6E5E0=;
        b=bvz4pc3sd5Hlm3XHCPwsuX+JRISL5EFI4g4feG8ZP/N7ANzJKrCcNZ6NEFdSWAWeeA
         a1jh2WUgTfOiGYY4J4++WzKu+U3AkVVEV+W4lwqYxxxMrD4R8TK6ogbKNrjWG8jOa9ui
         U8OmILRiIieAqAzzicMUOpElwPtQ6Wfw6Jy1SmEnqrGzlsGBiTWqtFCMkv5E46fvojZh
         7PkPSTSRUG9VRj4/dMRG53UVy1GMbm4r9MCjkTjZzItuRRGrVXlHGTVTdN0OyTD90VWH
         mqMNPu7P5NXCrEidmg5M42HVoMMocoJuiwvYgmUPFt47RT6yqZenwung09E7S/xnd9kV
         u0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8yrvm2wRlJdJMJvVgVYmOkiM4rYd8h4RVIKqWc6E5E0=;
        b=RrmAyO3NnoIlRm+sBQ0AYl17/lF6QhuGzENzxW9LTpAinyq2gLS8b4/JnHhqy/QCsf
         cj6cMypw/UAR0H9wYl+ZLUs+2e8G992Y0qBzkTu2FojIGJP40SBq/1zYjVTGD69MpLU7
         8NvVeJZczLkJnt3PM+MNwkDSfNCq87ILoKhfEnP9oRMIHk+ayW7LOTTomUbexbYY/QjW
         o8SFMpksdei1TUpmamh5GshATUOEwkldjiHHBCkzgzvCkPsNAKZ5D/wfhCwScmqDe9+D
         bT2eO4cEMM5/ZV5c8DT2RYLhChMRi9ctdVu3JdeDMUTEeQdIhNs0A3qK8PqTzgAEqmm/
         XXSA==
X-Gm-Message-State: AOAM530X9Wzgdk0fPKkedAr1Nhi0vpuWUB3txNjyH6p2O8MOvc4NDT++
        lxTuZ5iZUu4d6wg8cUE8gH8CbgBCZRuA5Q==
X-Google-Smtp-Source: ABdhPJygKMn9lUCpMao+XPKIBFURMPyVq4Fa7wEwWESDMwqL7TluFUbUZlTkd2yRF03Opcw3UkGkAg==
X-Received: by 2002:adf:f086:: with SMTP id n6mr9040521wro.208.1598390556364;
        Tue, 25 Aug 2020 14:22:36 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:118:6200:290:f5ff:fed7:e2dd])
        by smtp.gmail.com with ESMTPSA id u205sm848063wmu.6.2020.08.25.14.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 14:22:35 -0700 (PDT)
From:   Cyril Roelandt <tipecaml@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     stern@rowland.harvard.edu, sellis@redhat.com, pachoramos@gmail.com,
        labbott@fedoraproject.org, javhera@gmx.com, brice.goglin@gmail.com,
        Cyril Roelandt <tipecaml@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge
Date:   Tue, 25 Aug 2020 23:22:31 +0200
Message-Id: <20200825212231.46309-1-tipecaml@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824201856.GC344424@rowland.harvard.edu>
References: <20200824201856.GC344424@rowland.harvard.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This device does not support UAS properly and a similar entry already
exists in drivers/usb/storage/unusual_uas.h. Without this patch,
storage_probe() defers the handling of this device to UAS, which cannot
handle it either.

Tested-by: Brice Goglin <brice.goglin@gmail.com>
Fixes: bc3bdb12bbb3 ("usb-storage: Disable UAS on JMicron SATA enclosure")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/storage/unusual_devs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 220ae2c356ee..5732e9691f08 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2328,7 +2328,7 @@ UNUSUAL_DEV(  0x357d, 0x7788, 0x0114, 0x0114,
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_BROKEN_FUA ),
+		US_FL_BROKEN_FUA | US_FL_IGNORE_UAS ),
 
 /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
 UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
-- 
2.28.0

