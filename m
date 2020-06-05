Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1940F1EFD9F
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgFEQ0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgFEQ0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20648C08C5C2;
        Fri,  5 Jun 2020 09:26:41 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ne5so323358pjb.5;
        Fri, 05 Jun 2020 09:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jV4daFGWsjhFnvffgzn/EdlePMcCRTFOIwlzfJCB7vg=;
        b=Q1bTgBJ8HMzy/86+TG56pOicptFiM5AtNDIh0w9tYHpnfvbs7cIaCjosUGRfiO+jpA
         IoAN0M+oDA1aRUo5+iNjk6/yR8QHpv8s1tqMtoc1LqgUOmB6HLLn/oB7SoD88wUvHbIM
         ooVEc16/+UmDtik4ehrqrjGy3822X2i7e1AE3eQZ8uV4qOQG7t1rNQMJJV29jTCH/zTL
         vNTS7kWubY0CWdV5jTt8w801IOuCN6a8D8gLmlZ9oluErqwc1YpWeNQLTLstTLMf1kLy
         XUKwL2XQ1wMgR2giDakXUC2aA5b46r8Z7VJTQbCuhPMU75Uz14/ccCWgxKGskuErRGfg
         uNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jV4daFGWsjhFnvffgzn/EdlePMcCRTFOIwlzfJCB7vg=;
        b=DhCppuI+2a0b/gUW7XKXgIANybB2mICU6v6gleA7NY6jN9vxt47Sz7wQzvwPpaJDjl
         C4HyrE8qcAW1skralf8IiXGYcC+TKl5Fe6OCor8lc+Rubu10qj+JqpGRQp4MGfCzHdrc
         rtpjZHpUUL2WQcmsRQDpP5FjoWk8FN/gWgkgjkDHAZ0t16xiEcuulA1BsSmlTHbJImbs
         Im3ujcFI2nVRxC/yUGAcOSqwoD9HMkbT3gk0NQGMr71/0D4ZaCtmiE+K5bi6MfeiQA65
         bmZIfisLMvuvrd2jIaPXS3PV94i54lR7A/IF7Ger+OPqvZsBj6suavb48gmlacwwdPPY
         qPXg==
X-Gm-Message-State: AOAM530Mn6ypGBD4YrCgFZcVMVED+o2HeAcq/wGp6H2WutSyKthvMzv5
        g33d9USBIuTfWLTPkDQIDB0a7bOh
X-Google-Smtp-Source: ABdhPJyfwzO5S6XEAP00SbLLtWAexdM+5vcogfl2B+Tnm13qnaE41Xn9B+pv7ADE7jfI2wyBG8GV0w==
X-Received: by 2002:a17:90a:3321:: with SMTP id m30mr3985903pjb.20.1591374400291;
        Fri, 05 Jun 2020 09:26:40 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:39 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 20/21] media: dvb_frontend: fix wrong cast in compat_ioctl
Date:   Fri,  5 Jun 2020 09:25:17 -0700
Message-Id: <20200605162518.28099-21-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>

commit 5c6c9c4830b76d851d38829611b3c3e4be0f5cdf upstream

FE_GET_PROPERTY has always failed as following situations:
  - Use compatible ioctl
  - The array of 'struct dtv_property' has 2 or more items

This patch fixes wrong cast to a pointer 'struct dtv_property' from a
pointer of 2nd or after item of 'struct compat_dtv_property' array.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 34f55a2ba071..740dedf03361 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2081,7 +2081,7 @@ static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
 		}
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(
-			    fe, &getp, (struct dtv_property *)tvp + i, file);
+			    fe, &getp, (struct dtv_property *)(tvp + i), file);
 			if (err < 0) {
 				kfree(tvp);
 				return err;
-- 
2.17.1

