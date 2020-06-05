Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA5A1EFDFB
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgFEQ0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgFEQ0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:04 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608A7C08C5C2;
        Fri,  5 Jun 2020 09:26:03 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so3833905plt.5;
        Fri, 05 Jun 2020 09:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BK5uIPuoj5s3p1umbZFHQonWFQu9J5ojGIynUIx7wUM=;
        b=o1Y+Lg9GRJIjG8s92hys4u8VNy2FlWfVhj8RIt0DPU3v3vU+fXtiAJ5b10Eclt8AdI
         ekQWzGhmugOXdsdgn6RUO4hVXR3RxzroXWol58QZdgDTuutR2RRGPdY3h7D5qnDvJgbm
         DSqjMPkeYbW/1A6BXjpxtGrDTKn47GRT5uXE+8XKsRaYZb06Hv2fq5WyWoWknqSXr3AC
         UTPKncETIZuSVAeYvtIKDKLj+NuL/52UNUdXkGg1JvFBk0TC6igA665USAll5lxKiFPl
         pWyu/9FPvuMwWjzX3JkTt/raS/PiH/BbQ00tTnOZspvRrvac4YI94xg0AuOrI2KAbSyw
         e8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BK5uIPuoj5s3p1umbZFHQonWFQu9J5ojGIynUIx7wUM=;
        b=WnK5KWw9boUK69X4nkslw2Va1zVjyyEjCajVXcQCVXP6sRyBw+ux+dsxeXA5Sb8Mb2
         dUh16KjVV/G4qEr2U9g/UFpjN1LGujt/ixlmoGvGpz2ME7LP5eULZ4gpEVHsoih/lKwG
         ln1FqzrnEe83nxjYVDgiX3yUFDW2MV+BOEeeg6+Gnypc6Dd56BBaI6kHZ94jEzEGzXLk
         bdnVJkp3SHtrPeffQvUDxWyEixc9w98rgT3nqZUAmQPc9VbkCkvX9qSSiHQ//hs26+M7
         6bdTBK4xnmDdFnb5FDHWg5DWHRl6hlK81C/lr8NozCEHD8wm7U5BJuy44DmtdwePfvJl
         rahA==
X-Gm-Message-State: AOAM533pBwSdPDZI7KpvXEBJ2c1ZCGIzyjsYRKqSF82VwFr7Z7k2vGSx
        LLl32BWJSdwuMREiob8uC8ADsk4p
X-Google-Smtp-Source: ABdhPJxoA8r8XBGDgg/yFx4eRcKgWc49CV2edBLecXIp/5z5xiHV048E+xGGFOBu5mDQDVHIPKoxQg==
X-Received: by 2002:a17:902:a505:: with SMTP id s5mr10619204plq.20.1591374362435;
        Fri, 05 Jun 2020 09:26:02 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:01 -0700 (PDT)
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
Subject: [PATCH stable 4.9 03/21] media: dvb/frontend.h: move out a private internal structure
Date:   Fri,  5 Jun 2020 09:25:00 -0700
Message-Id: <20200605162518.28099-4-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit f35afa4f60c868d7c7811ba747133acbf39410ac upstream

struct dtv_cmds_h is just an ancillary struct used by the
dvb_frontend.c to internally store frontend commands.

It doesn't belong to the userspace header, nor it is used anywhere,
except inside the DVB core. So, remove it from the header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 11 +++++++++++
 include/uapi/linux/dvb/frontend.h     | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 3b045298546c..7eeb5d302c9c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -998,6 +998,17 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	.buffer = b \
 }
 
+struct dtv_cmds_h {
+	char	*name;		/* A display name for debugging purposes */
+
+	__u32	cmd;		/* A unique ID */
+
+	/* Flags */
+	__u32	set:1;		/* Either a set or get property */
+	__u32	buffer:1;	/* Does this property use the buffer? */
+	__u32	reserved:30;	/* Align */
+};
+
 static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_TUNE, 1, 0),
 	_DTV_CMD(DTV_CLEAR, 1, 0),
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index afc3972b0879..3a80f3d1da1c 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -384,17 +384,6 @@ enum atscmh_rs_code_mode {
 #define NO_STREAM_ID_FILTER	(~0U)
 #define LNA_AUTO                (~0U)
 
-struct dtv_cmds_h {
-	char	*name;		/* A display name for debugging purposes */
-
-	__u32	cmd;		/* A unique ID */
-
-	/* Flags */
-	__u32	set:1;		/* Either a set or get property */
-	__u32	buffer:1;	/* Does this property use the buffer? */
-	__u32	reserved:30;	/* Align */
-};
-
 /**
  * Scale types for the quality parameters.
  * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
-- 
2.17.1

