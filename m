Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008F1376591
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 14:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbhEGMwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 08:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbhEGMwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 08:52:35 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA76FC061574;
        Fri,  7 May 2021 05:51:35 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id w15so11392176ljo.10;
        Fri, 07 May 2021 05:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k/DtSPUDkSbuRZ0BQAVzillf2V45Xj8sjRcVKiI789k=;
        b=YhPg6AH5PtgAMazNsAKtBLkIFFyi/lLcNbGXD/g/e8XWc1gzAKu4/ROVfOFGP/sSvW
         J6Gff1bXStGxePc2OB9iCyKXLGhJ0NKUTi7EBB4AIzwaE9DRFgCnbl99Tgtq0ofCLGxA
         7MgtRCGxqdpOOUd3DqxMZaRfG0TbYyCTKQp1Y40AqE8DfsVVI3eqoVPC/dhiEememOCt
         rOnfBLcbaPYk3y+h3XLDgTIA7Xt1i5idIxTM3YJIj0nvepd48uq8k1PMBUFEuiw+nZT7
         p33w2gce7dwKnUXGuQyKPPvUjBOHu9zmwTLkpARht0GoyTn3qH7FEQyRfJrGBjTz2S7W
         u1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k/DtSPUDkSbuRZ0BQAVzillf2V45Xj8sjRcVKiI789k=;
        b=sq8r0Ebe5S2tXYP4dilfR2MrYwCqyBRkhlCKgu2JlcPbosfrVTmXLAxnGM0QRzR6N4
         dLzACpZDJb8YzEFGx4AjEaOBI4aOb9HmqugsHGNDwDOSusdMkdal9/5rpQHaWhmd55/J
         ghrJr6JT+3l6sLNYfyk6zLF+CW8Dai+epu32hCpKP67OVm3QZob9QswRbG5DOCA93vnN
         pWOYNcKzFzxyobGC+c1P9k/cdj1CMWCZ8QubACyZWRXWyNRdPAIEjChf1/yCwA7Jb+JY
         KSICkLnuDfp/s5qdomm5GqivYjB7Vpd+0SmTOYunRyhQtyGMSkvz4Qt3ImXbCv2oC/op
         znzg==
X-Gm-Message-State: AOAM531ucQorKYcl6py7NwJTEFneZcpBH1Z3Xd9jQy+efGwMfEyDIjcL
        qFnX3UnREp8glThi269G32A=
X-Google-Smtp-Source: ABdhPJz3y7Xr3Nw+3mhxe7PhcWEzINPKHvxkvwn5fmRb0vNJZIxc+vO3M+pwHzrBmO/w1sXeQgp/cQ==
X-Received: by 2002:a2e:8e9a:: with SMTP id z26mr783712ljk.301.1620391894189;
        Fri, 07 May 2021 05:51:34 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.84])
        by smtp.gmail.com with ESMTPSA id r9sm1887855ljp.79.2021.05.07.05.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 05:51:33 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mkrufky@linuxtv.org, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org,
        syzbot+7336195c02c1bd2f64e1@syzkaller.appspotmail.com
Subject: [PATCH v2] media: dvb-usb: fix wrong definition
Date:   Fri,  7 May 2021 15:50:43 +0300
Message-Id: <20210507125043.29825-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506121211.8556-1-paskripkin@gmail.com>
References: <20210506121211.8556-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot reported WARNING in vmalloc. The problem
was in zero size passed to vmalloc.

The root case was in wrong cxusb_bluebird_lgz201_properties
definition. adapter array has only 1 entry, but num_adapters was
2.

Call Trace:
 __vmalloc_node mm/vmalloc.c:2963 [inline]
 vmalloc+0x67/0x80 mm/vmalloc.c:2996
 dvb_dmx_init+0xe4/0xb90 drivers/media/dvb-core/dvb_demux.c:1251
 dvb_usb_adapter_dvb_init+0x564/0x860 drivers/media/usb/dvb-usb/dvb-usb-dvb.c:184
 dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:86 [inline]
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:184 [inline]
 dvb_usb_device_init.cold+0xc94/0x146e drivers/media/usb/dvb-usb/dvb-usb-init.c:308
 cxusb_probe+0x159/0x5e0 drivers/media/usb/dvb-usb/cxusb.c:1634

Fixes: 4d43e13f723e ("V4L/DVB (4643): Multi-input patch for DVB-USB device")
Cc: stable@vger.kernel.org
Reported-by: syzbot+7336195c02c1bd2f64e1@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
----

Changes in v2:

 Added Fixes tag.
 Fixed typos in commit message

---
 drivers/media/usb/dvb-usb/cxusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 761992ad05e2..7707de7bae7c 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1947,7 +1947,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 
 	.size_of_priv     = sizeof(struct cxusb_state),
 
-	.num_adapters = 2,
+	.num_adapters = 1,
 	.adapter = {
 		{
 		.num_frontends = 1,
-- 
2.31.1

