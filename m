Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B84250664
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgHXRc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgHXRbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 13:31:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB43C061573;
        Mon, 24 Aug 2020 10:31:53 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t14so8980720wmi.3;
        Mon, 24 Aug 2020 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptGIL1/M9Anqh/4n8uHq9h8dNqCw4NwN18MuWXuUz44=;
        b=NAdWRMqAq/4lRGWfeBSJ1uiDIVehTkuVKp8AkMmkPbXs5mJDD+6vP3hf0RPBXksIim
         zCpgC44yHyicAdjFpV5bKFx2DAXZLYGYEtUpWTATa9Yx8ZByWAV92/NNIyW8qPOG6RPI
         bZPqNJL2k3bUA4eDHxlG/aOmcrrOHPa1FFgJHqI5EPowssj1SyKJWJwFV5tHYdCgjt3S
         ig9JuGnCOVC+hCiPogUGkBmadegH3viFnD8yi2y6Psl+xphXEZ6LsOxMYyjYsfprcY/D
         ZgP08MJEPa1sa3aNJyWHEZbtABGNMyqwXhndtfG84QZX2nTMv0l/S3oQj0jPApncSokY
         +dJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptGIL1/M9Anqh/4n8uHq9h8dNqCw4NwN18MuWXuUz44=;
        b=YMNNjNRdXTaTJIc/AiZ2gUMkvpnulG8KvU5GF5GvPtKqpTA1cvQMkA1b2dHVaBL0jH
         xHQkSDxR4nSXkPyOBcNndIp/d7bbhUebasMXb3wjxDfYane4zQwPGhDGRso9ZPFe8WsW
         5jFpor4AcME+Als5pdvQuZAVWxg0KD3PG1BoJW1wb8Jr/pu1cx1ylCgMWSxLGxF3ysFi
         nnMmLEb/nce6x/GIdeY00XuH47BPeod2aaZcA+vfPHHPSFk5ltyJc84RV9G9G7Hj5Leh
         AFgW2GZxSNCrvB98/a/rPs2vNxg/Z1Set2bOYOoM0GxsH1APbcA842rXh8/QVAkelyDz
         l0+g==
X-Gm-Message-State: AOAM531FwGgL71ilgLUtuCymyN6D0sMN91GAwO5D7/Ns5noldYKvYmvR
        wFesvNoxYWmAkZX0w3R/KnubcQrhoGHyIQ==
X-Google-Smtp-Source: ABdhPJyEW3uhyBM0vhHSQQw7wYBknr9KSDXsSaPpB/crnODeddsCwseCyhXaqn6ksgfvvFFCrgxv6g==
X-Received: by 2002:a05:600c:c4:: with SMTP id u4mr364632wmm.100.1598290307750;
        Mon, 24 Aug 2020 10:31:47 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:118:6200:290:f5ff:fed7:e2dd])
        by smtp.gmail.com with ESMTPSA id g18sm26027333wru.27.2020.08.24.10.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 10:31:46 -0700 (PDT)
From:   Cyril Roelandt <tipecaml@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     stern@rowland.harvard.edu, sellis@redhat.com, pachoramos@gmail.com,
        labbott@fedoraproject.org, javhera@gmx.com, brice.goglin@gmail.com,
        Cyril Roelandt <tipecaml@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge
Date:   Mon, 24 Aug 2020 19:31:28 +0200
Message-Id: <20200824173128.48740-1-tipecaml@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824074027.GB3983120@kroah.com>
References: <20200824074027.GB3983120@kroah.com>
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
CC: <stable@vger.kernel.org>
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

