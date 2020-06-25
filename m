Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF34209A0D
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 08:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbgFYGrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 02:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390115AbgFYGq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 02:46:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A40C061795
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j94so4637121wrj.0
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 23:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpZUopdNGKoMuokzA38cWTWHt4qMbyx0+mhPHuM+Znc=;
        b=L3gPi0V6eWwUbjc0a7NWVYNxvmyjxoCjIHRVwhhbx3/PgBUBX1nYVYjjVo442aXOq1
         6X+Rxq4jGsIwLTCBZApP2Rl/SureSgHXIaYxg9LovDj+bhfSXt3hSv90MX1xjfcHLEbP
         pizWIa2VTBVMWI6eNMnPoO4qath3LnLnEPgrrJ4dAIBvozmxRyuEBNn35Sv9RQVY/0Lg
         hVqcXYlSA2h6mWAEMsGoEiG/cyjNbXgHy0dMkxXGJQjFqwHHP6PZSwCZU5izFBVnfokC
         WU1eXhZiZYr6t2/pu9Ce3tAAE6tpfZME71ChHW0a72v/TfEzY4id8vKP2OrKnEGANJQQ
         3D8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpZUopdNGKoMuokzA38cWTWHt4qMbyx0+mhPHuM+Znc=;
        b=KUP+3woGFhpw5QicIno2c900b9Lta94j5t1v6Tl0O0ixtCrnSnc8TwB6GREtMEJmJ6
         X/eHLWWYCODCy96piCkS96M3KWBpl/DglqWIY6eAB8lr/IwYUKgkiLhYBiwf9dbwV4QW
         qugNkHx94Ka3xyTHyKzhcAC+rE19zsD2Wlrxvf0d1NXWqRpvtmiY3dZyrgHJweqeZZAX
         bO3jzGz8ezkGS6WIf0ToRJ/vpncqaGg7iLIxR6RBVDaltHG3K08JnWZ7hhaTVv6hq4DT
         bIZx3RfPraGVEplwEAt/Qe6mr/NM/wybbw85Z9j1j6RxNzMU3097LFT3VPMtsETH5FC+
         D44A==
X-Gm-Message-State: AOAM530IvUUbIb7fC5IQhmcWeBdyTNmvaiwp5Franoq7/d+jrAGy62Z9
        dn6apsbxXC1emuASPxxnV38Nyg==
X-Google-Smtp-Source: ABdhPJzMnG23PTfD5iHcY4F5ksyIND4PVZ3+d2rvuDhBikSUcprsL4BwlP+KBch0OuudWQn4B9nZfA==
X-Received: by 2002:a5d:62cd:: with SMTP id o13mr23631593wrv.272.1593067584905;
        Wed, 24 Jun 2020 23:46:24 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id c20sm27235363wrb.65.2020.06.24.23.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 23:46:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 02/10] mfd: mfd-core: Complete kerneldoc header for devm_mfd_add_devices()
Date:   Thu, 25 Jun 2020 07:46:11 +0100
Message-Id: <20200625064619.2775707-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625064619.2775707-1-lee.jones@linaro.org>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Each function parameter should be documented in kerneldoc format.

Squashes the following W=1 warnings:

 drivers/mfd/mfd-core.c:326: warning: Function parameter or member 'dev' not described in 'devm_mfd_add_devices'
 drivers/mfd/mfd-core.c:326: warning: Function parameter or member 'id' not described in 'devm_mfd_add_devices'
 drivers/mfd/mfd-core.c:326: warning: Function parameter or member 'cells' not described in 'devm_mfd_add_devices'
 drivers/mfd/mfd-core.c:326: warning: Function parameter or member 'n_devs' not described in 'devm_mfd_add_devices'
 drivers/mfd/mfd-core.c:326: warning: Function parameter or member 'mem_base' not described in 'devm_mfd_add_devices'
 drivers/mfd/mfd-core.c:326: warning: Function parameter or member 'irq_base' not described in 'devm_mfd_add_devices'
 drivers/mfd/mfd-core.c:326: warning: Function parameter or member 'domain' not described in 'devm_mfd_add_devices'

Cc: <stable@vger.kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/mfd-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index f5a73af60dd40..720e5c8b1588c 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -318,6 +318,16 @@ static void devm_mfd_dev_release(struct device *dev, void *res)
  * Returns 0 on success or an appropriate negative error number on failure.
  * All child-devices of the MFD will automatically be removed when it gets
  * unbinded.
+ *
+ * @dev:	Pointer to parent device.
+ * @id:		Can be PLATFORM_DEVID_AUTO to let the Platform API take care
+ *		of device numbering, or will be added to a device's cell_id.
+ * @cells:	Array of (struct mfd_cell)s describing child devices.
+ * @n_devs:	Number of child devices to register.
+ * @mem_base:	Parent register range resource for child devices.
+ * @irq_base:	Base of the range of virtual interrupt numbers allocated for
+ *		this MFD device. Unused if @domain is specified.
+ * @domain:	Interrupt domain to create mappings for hardware interrupts.
  */
 int devm_mfd_add_devices(struct device *dev, int id,
 			 const struct mfd_cell *cells, int n_devs,
-- 
2.25.1

