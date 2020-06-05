Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61ECF1EFDAE
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgFEQ0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgFEQ0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D001C08C5C2;
        Fri,  5 Jun 2020 09:26:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v24so3825970plo.6;
        Fri, 05 Jun 2020 09:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s6oLxuZtz92MCMs+Rc0jAsvvKy4fsrw+h3fzX94hKHI=;
        b=LC9xGG5Mpl7l9RocA+JmkF3GXVhNsllocgKi08w3I/rV5Pvheph3idCf9rJfkJF8gy
         c7m05ERn1FldKvEFXHMxvLJl8BT/nIyf+QIMw6iNMcdl55IbZR8msVD2gZOxoIIiTl5c
         +TNOJa8uLfw6SVEhHf23IWYJQZ7PNisgeQFKyQ6AHCEdkqddGzlViSu1PJeadPTxc1SB
         k7bUzlJLicjyQlwYVVI88Sz+NXj2YxLFUY+5fxEyCjOjRUJJ5k44nhdLmifKv51p0FZH
         pROVUBhPNRg5GClRhqXYL0L29RXYn761O+su/eqXL40VciugEtlWAz+quQv7sSI10Rtq
         ItMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s6oLxuZtz92MCMs+Rc0jAsvvKy4fsrw+h3fzX94hKHI=;
        b=PQ9f9Ade/gUzyZy5S9Vo6KGNqSRI3aLOEzYtuUDr54I0cG8JkE9QgZl57A01/tDrYn
         +HLGOlEpaGzJ2uS/jh474dYOf2ipJpqRGjB8ogX+Kt7tA6QZfI1H8me3c+ekbqQHFENL
         CYWfAct77rlVM4t3QnpTJ/TpyHdo/Q502xotZ5k+1jrRvF2UeuFcr+KWPqoQOvR2g9zn
         o/vUZrPFTxEdl11j8l3GgY2FtIYcBbKWJRDdHEd5+BR3AovQupx1yH0O1WRvZyMEFOlX
         WtjJLocZ2yyz5us39xEyAzYAmrTrC1FYz4XNIO1wCNOOgL5KpgyM9GB/2X+CDy6/OZXc
         KKSA==
X-Gm-Message-State: AOAM530F358/FxuRXdvSKQmnWEB5nkTF5QMGR6f4CjkV3YwdvnqRQ+nN
        czKPO8nTnLe5sHrYQI1Pb7yoFrz+
X-Google-Smtp-Source: ABdhPJzGvAyLDr9UoI4bW8o5yZzXk+PoTpDmgdFNhxX7kuEbHzhX2mG+MBfWxqp5UKeyXBsErABbZw==
X-Received: by 2002:a17:90a:d487:: with SMTP id s7mr3858502pju.37.1591374402616;
        Fri, 05 Jun 2020 09:26:42 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:41 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 21/21] media: dvb_frontend: fix return error code
Date:   Fri,  5 Jun 2020 09:25:18 -0700
Message-Id: <20200605162518.28099-22-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 330dada5957e3ca0c8811b14c45e3ac42c694651 upstream

The correct error code when a function is not defined is
-ENOTSUPP. It was typoed wrong as -EOPNOTSUPP, with,
unfortunately, exists, but it is not used by the DVB core.

Thanks-to: Geert Uytterhoeven <geert@linux-m68k.org>
Thanks-to: Arnd Bergmann <arnd@arndb.de>

To make me revisit this code.

Fixes: a9cb97c3e628 ("media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl() return code")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 740dedf03361..cd45b3894661 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2265,7 +2265,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, err = -EOPNOTSUPP;
+	int i, err = -ENOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-- 
2.17.1

