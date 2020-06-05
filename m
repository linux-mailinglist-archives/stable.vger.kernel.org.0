Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308CB1EFDA5
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgFEQ0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbgFEQ01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:27 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26D2C08C5C2;
        Fri,  5 Jun 2020 09:26:27 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 64so5121189pfg.8;
        Fri, 05 Jun 2020 09:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fLC8ozHHD0gNLLpBMnipIeglQHpIP8kwdagjdUrQSk4=;
        b=ts5wD8M/CLvw5rFgWQOpEpZs+0bpNGvwnfCyJ9AvBGS0fE/2B5cD0NUNDBZLWa2mX1
         otli6eRczJOCZevkJse05B4/51bSarTIpB9/l7ucZtsWl+qfFz15nebCjlCv3aabAqkp
         WwOKY2UcRdi+8Uwa5Xgo473mWsbhCBFRrPsenTb9wolVQVeWHJfLhA7xLMWAsYOg/zLd
         MY3isdxgYcLp8lvbmMHlYf1/ghAJiUA/+9WBd+iE9C66NInKnN05rLbiw5AqTwKBtnff
         vnbijBHXg/JHUfQkGd0AY8EPtg7NckOw2ZV93MtseczXmvGN4rnqx3syThtsZUlUKLGM
         UjRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fLC8ozHHD0gNLLpBMnipIeglQHpIP8kwdagjdUrQSk4=;
        b=OahI7V5K4gFw02rSQdXIS/eUb8r9tljJPBngH4aCDRn4zlNoNQAwD29mGOKwm1uAMH
         DxpEJvj+2SFRKGdP6zeUbiHLp5Soz6W+f6sEsoQeaig9Isa8/pyM4cLkGcQNSIIv3OaX
         IGvI3lRf1ulnlx4bUWQjy6YV5j5MfwGxXworWEI31c+bkgCmCiddCiFoEvfukNhVg/u/
         viH9betL4XZPowrWTqHu9505SRbNX5yHp6/WtEUlPDWIsKnaCBEvGRlajk7HrVrUl2wM
         seWxn4ukBRHbGwG2gFg65ZH0ivH1n93+ShdyvnCiL5jbtss0yDsuScGBIvky/p6U3XxE
         V9xw==
X-Gm-Message-State: AOAM531JYkOvs+But7H0PinoWXJ0E4fAYUefGUSGqE5IwM2KLfggr9vZ
        BewyhuJIm/EBcEcQJ4b1q55hjN63
X-Google-Smtp-Source: ABdhPJxdkh+JW2AdAReGmO8hX2+/p42zwlaTalOmne2KEyBkpFSRNadjnUzuVcW0qDCTlqziozaung==
X-Received: by 2002:a62:7841:: with SMTP id t62mr9955304pfc.273.1591374386823;
        Fri, 05 Jun 2020 09:26:26 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:25 -0700 (PDT)
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
Subject: [PATCH stable 4.9 14/21] media: dvb_frontend: fix return values for FE_SET_PROPERTY
Date:   Fri,  5 Jun 2020 09:25:11 -0700
Message-Id: <20200605162518.28099-15-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 259a41d9ae8f3689742267f340ad2b159d00b302 upstream

There are several problems with regards to the return of
FE_SET_PROPERTY. The original idea were to return per-property
return codes via tvp->result field, and to return an updated
set of values.

However, that never worked. What's actually implemented is:

- the FE_SET_PROPERTY implementation doesn't call .get_frontend
  callback in order to get the actual parameters after return;

- the tvp->result field is only filled if there's no error.
  So, it is always filled with zero;

- FE_SET_PROPERTY doesn't call memdup_user() nor any other
  copy_to_user() function. So, any changes to the properties
  will be lost;

- FE_SET_PROPERTY is declared as a write-only ioctl (IOW).

While we could fix the above, it could cause regressions.

So, let's just assume what the code really does, updating
the documentation accordingly and removing the logic that
would update the discarded tvp->result.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/media/uapi/dvb/fe-get-property.rst | 7 +++++--
 drivers/media/dvb-core/dvb_frontend.c            | 2 --
 include/uapi/linux/dvb/frontend.h                | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 015d4db597b5..c80c5fc6e916 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -48,8 +48,11 @@ depends on the delivery system and on the device:
 
    -  This call requires read/write access to the device.
 
-   -  At return, the values are updated to reflect the actual parameters
-      used.
+.. note::
+
+   At return, the values aren't updated to reflect the actual
+   parameters used. If the actual parameters are needed, an explicit
+   call to ``FE_GET_PROPERTY`` is needed.
 
 -  ``FE_GET_PROPERTY:``
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 673cefb7230c..ca4959bbb6c2 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2127,7 +2127,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 				kfree(tvp);
 				return err;
 			}
-			(tvp + i)->result = err;
 		}
 		kfree(tvp);
 		break;
@@ -2172,7 +2171,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 				kfree(tvp);
 				return err;
 			}
-			(tvp + i)->result = err;
 		}
 
 		if (copy_to_user((void __user *)tvps->props, tvp,
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 16a318fc469a..b653754ee9cf 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -830,7 +830,7 @@ struct dtv_fe_stats {
  * @cmd:	Digital TV command.
  * @reserved:	Not used.
  * @u:		Union with the values for the command.
- * @result:	Result of the command set (currently unused).
+ * @result:	Unused
  *
  * The @u union may have either one of the values below:
  *
-- 
2.17.1

