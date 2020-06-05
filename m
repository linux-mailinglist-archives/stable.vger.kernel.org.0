Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00AF1EFD9C
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgFEQ0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgFEQ0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E80C08C5C4;
        Fri,  5 Jun 2020 09:26:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d66so5131226pfd.6;
        Fri, 05 Jun 2020 09:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wS0FplcEHKkha537ftRtmFe7oqwpBZmXOkXwoZ5YLM4=;
        b=HAb4EpHZ44cieamqBez4audEeYm3SXN4/aZbWIt2ZuhGrVTwrcBbtQqvGusVckRJvr
         ZhqX/bYEkRPiItVanv4svAFj7fTcYwKnAyGfmAK2Ra1yTR8x7mnsIzWyV4KuJc6uImJD
         vng4u5XZvV50sqQFzjOc6JhAyZ04VGwNvaWmYNP220hfRtv+67rFrRfQeCeHcdVC9RJV
         Vkemu6oMd430RJXXY6Nb9MOejIWqUjHXdTZDQ2OUMdrLINaN8eYzrUEhGa8lmtqqAX7a
         eWAyudL6idmnQTR5mwDt1gQJ8nzxXvFHnBZMETUY2gycPizY3e8FszasbBF66j891GtS
         FiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wS0FplcEHKkha537ftRtmFe7oqwpBZmXOkXwoZ5YLM4=;
        b=SwzUV7sM4OvmeexKmCQdO/a0LjTEnvNDFe6F5KSZJKlylTKoS5t8fm7fxumD1FBNxd
         qWTgpSxnz+vI3GhoCrydqe1+i1G1QZRD2bRCwBIR4v054BO+m95dePVrRhUue7LWl4CZ
         d/p7luuhHKQZg0bE2SHRph2lP0R7if0IRqR7j5CsOEs4Nz6qT2z2mTr6/Zmmi0FGq7DP
         0fXd8w2cIJ0YkYOIgJijLp0qsDXwAxiJAwv6a4nwvKI8HCksxSVG+IxUZbdclhfnVdCB
         lbccsiccoGNjATtS8Idc6lm8AIAB9ALpkF6ccyDrUx8wse+Rc1yAyMDhCGV98t0HQcFI
         E8QQ==
X-Gm-Message-State: AOAM531+bZu0+WYtjtLnApitF8dBqn0wH0zg9ud7fDkiRYIQTZump5qC
        xSYZf1CrrIzypqJfszBKX0jPpZ3M
X-Google-Smtp-Source: ABdhPJzcYCZRxmnFkP119aIzW0clCUkfzwjLLEkg+1TcV+0cA27hNYWVx35erGXIXjHjGJqV3MeFiw==
X-Received: by 2002:aa7:97bd:: with SMTP id d29mr9863623pfq.262.1591374391294;
        Fri, 05 Jun 2020 09:26:31 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:30 -0700 (PDT)
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
Subject: [PATCH stable 4.9 16/21] media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl() return code
Date:   Fri,  5 Jun 2020 09:25:13 -0700
Message-Id: <20200605162518.28099-17-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit a9cb97c3e628902e37583d8a40bb28cf76522cf1 upstream

As smatch warned:
	drivers/media/dvb-core/dvb_frontend.c:2468 dvb_frontend_handle_ioctl() error: uninitialized symbol 'err'.

The ioctl handler actually got a regression here: before changeset
d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic"),
the code used to return -EOPNOTSUPP if an ioctl handler was not
implemented on a driver. After the change, it may return a random
value.

Fixes: d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic")

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Tested-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a9ae9e509205..6f9ee78a1870 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2113,7 +2113,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, err;
+	int i, err = -EOPNOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
@@ -2148,6 +2148,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			}
 		}
 		kfree(tvp);
+		err = 0;
 		break;
 	}
 	case FE_GET_PROPERTY: {
@@ -2198,6 +2199,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			return -EFAULT;
 		}
 		kfree(tvp);
+		err = 0;
 		break;
 	}
 
-- 
2.17.1

