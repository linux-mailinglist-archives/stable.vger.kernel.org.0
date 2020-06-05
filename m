Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022731EFDDC
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgFEQ1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgFEQ0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:25 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6203DC08C5C2;
        Fri,  5 Jun 2020 09:26:25 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v24so3825406plo.6;
        Fri, 05 Jun 2020 09:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BLnQZOuB1encvsP/q1TibKnbvwfFTQgmw900uUD1eh0=;
        b=s00v2CjnBugUosRS98w1/0sNO2ock4FIvKSRMeLbUSssi7MVlHqvLRq37Hjfdu22ms
         tP1LS3GniNPJjGdPKLPZVTVkFDCzLVAoaI0pMCwQHV/Ngof36A3Q+h7zeR+ccoudD/qQ
         MKu1OGIJQ7QCrxE7shBQmY7Qat23pA3t8ePzKPjLhon9U0+Npv6RHCdngwIw9+Eq0iGv
         PxEM4xr3gSFjtCrrvI2Yt3uACQLm2sRXUjffqBV4VJfm4iBP7iGNz4mz3B65CuWe2muA
         /gsUYtk61NiJtjU8fPiM7dotWk3b0Fuu28+xAj5o0+pvrPuihVoBj60Mv9VOW9aWucfF
         bfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BLnQZOuB1encvsP/q1TibKnbvwfFTQgmw900uUD1eh0=;
        b=kmy1aTy+mMGMYkyYwSN4/Duc3b39SYjJuhPFdzwERSxJCVtlDcuqGYVvtpxMXVBP0j
         PVw0vGzNRoPuSR7FJFDYKs79Y65a3gb4Wc3YJ9luZOrEbqqb5fwZHTpzls2IoOd7AP6v
         tJyb0hCTYJdC1Q/sgzHmioy1NNOYpBoU5vPROZUiGRZmHx8QECm20o5L7R03vnimdWoi
         S6BQ6iFgE3dsGhYTyNb6+yvUhU+uQtyDD/8hX3h1MgozeJbcE68T0ACWeXTfcsVtZDQP
         KdiHvSIffaZj9NgyMwPhCpo1L4NYonBLzq7Li+iiwVVHrk7rFSSSZoy+tMokFUN3aHWb
         /BZg==
X-Gm-Message-State: AOAM533IU8Mts4H0c8VXW98H80oXQj7cxgxMve7Yo+kJfWc77qBkbXMC
        FFkS5kJyLdIrv6eRL9XrXpggCdOv
X-Google-Smtp-Source: ABdhPJz0cVn1eGekoeOqU4W06zaqiKvd2KFHArWEsQz0WH9fUXfaO5hFFKYjAhl9h/p0Nup6qACHKQ==
X-Received: by 2002:a17:90a:17ed:: with SMTP id q100mr3639794pja.80.1591374384508;
        Fri, 05 Jun 2020 09:26:24 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:23 -0700 (PDT)
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
Subject: [PATCH stable 4.9 13/21] media: dvb_frontend: better document the -EPERM condition
Date:   Fri,  5 Jun 2020 09:25:10 -0700
Message-Id: <20200605162518.28099-14-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit da5516b5e81d45a96291823620f6c820178dc055 upstream

Two readonly ioctls can't be allowed if the frontend device
is opened in read only mode. Explain why.

Reviewed by: Shuah Khan <shuahkh@osg.samsung.com>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a7ba8e200b67..673cefb7230c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1925,9 +1925,23 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 		return -ENODEV;
 	}
 
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
-	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
-	     cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
+	/*
+	 * If the frontend is opened in read-only mode, only the ioctls
+	 * that don't interfere with the tune logic should be accepted.
+	 * That allows an external application to monitor the DVB QoS and
+	 * statistics parameters.
+	 *
+	 * That matches all _IOR() ioctls, except for two special cases:
+	 *   - FE_GET_EVENT is part of the tuning logic on a DVB application;
+	 *   - FE_DISEQC_RECV_SLAVE_REPLY is part of DiSEqC 2.0
+	 *     setup
+	 * So, those two ioctls should also return -EPERM, as otherwise
+	 * reading from them would interfere with a DVB tune application
+	 */
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY
+	    && (_IOC_DIR(cmd) != _IOC_READ
+		|| cmd == FE_GET_EVENT
+		|| cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
 		up(&fepriv->sem);
 		return -EPERM;
 	}
-- 
2.17.1

