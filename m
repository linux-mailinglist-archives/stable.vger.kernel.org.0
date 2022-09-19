Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659DE5BD6B0
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 00:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiISWAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 18:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiISWAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 18:00:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086223FA16
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 15:00:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 3so638999pga.1
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 15:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=95/m5BGPP8JYpHfpydKzQVCEG4c57A7mXTDcVh2ppNE=;
        b=u/LdhXQjH7o5JF2wg9FhfHl6LJAMMIMNNcyOwvWBVIbXzLqhy2CrqV20Za/oJ8uoi5
         tfi6StioCLaozC37RUCcqfx5IIU0A4ChfQQEDNBEfZS28rpYkmC7Vg6oiiJfjeHErX0l
         mKSpb0sWy8bMBruZiYLOBj+o3FI1MRTymcakMlzcTwdQtqfCJKN/3b1LsHKJDljiUKFx
         KnDdR6FFHEKs+CYYSmK+BnV20m5zp6mX/4klXjWzQMlExdg6HVhu6vNNXtqkMpIepXx1
         PuOj1H9vp/QTa8wLL0tHhlVQ8iBJnAOqR3ByvHcyeEOKzQTIlV+y7R3dsvDHftfchd+T
         SNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=95/m5BGPP8JYpHfpydKzQVCEG4c57A7mXTDcVh2ppNE=;
        b=RFukgLbLlYevbeZvtXASb5RXQS0Of0iAtzsMCqhFj3F+f885uk41ECgoVUgq8jg6lA
         w5Zu6BDiFHovGT1QKe5xb9xQP5/ybQVCH2+hyEaxvraxqbFAwf8bXRZGPLOPVPabclHL
         iCRWPYlO6WxiTn4vV22OiYyrcGqZNrPaV2RB5C3E4wh/rVoAPTMzw/6WknhQU6ZZECXu
         2fuL9mHG3zq6g6+bGxYjD/93wPHLxkcqY8SN5Q8qSUmocmPZ+VRe7WMIkAeIYKffrw4m
         QmKlx/GnuEpkUABnIcSsG47CeU1ud/wNJ4R0dcDm7HYqM3UFShCVFa0Syx52NdmhD+0W
         CdgA==
X-Gm-Message-State: ACrzQf3M/tRlmR3TD9kqXxfTbOQ4g95SEdQkycTRvFBLaJH/KkU5fruT
        KhPOaLLxUXhwEj4qi6f+C7SuJg==
X-Google-Smtp-Source: AMsMyM7kRFFaKR6Z1lEjLZ69gbYTx9CSweklloxSQv6ziROLKqNidW65YvH6MyPLw69ISwozh4lUuA==
X-Received: by 2002:a65:58c8:0:b0:438:aecf:5cc8 with SMTP id e8-20020a6558c8000000b00438aecf5cc8mr17423172pgu.18.1663624813409;
        Mon, 19 Sep 2022 15:00:13 -0700 (PDT)
Received: from desktop.hsd1.or.comcast.net ([2601:1c0:4c81:c480:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b0017887d6aa1dsm6614270plx.146.2022.09.19.15.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 15:00:12 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        "Dmitry Vyukov" <dvyukov@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        PaX Team <pageexec@freemail.hu>,
        syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com
Subject: [PATCH v2] usb: mon: make mmapped memory read only
Date:   Mon, 19 Sep 2022 14:59:57 -0700
Message-Id: <20220919215957.205681-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916224741.2269649-1-tadeusz.struk@linaro.org>
References: <20220916224741.2269649-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot found an issue in usbmon module, where the user space client
can corrupt the monitor's internal memory, causing the usbmon module
to crash the kernel with segfault, UAF, etc.
The reproducer mmaps the /dev/usbmon memory to user space, and
overwrites it with arbitrary data, which causes all kinds of issues.
Return an -EPERM error from mon_bin_mmap() if the flag VM_WRTIE is set.
Also clear VM_MAYWRITE to make it impossible to change it to writable
later.

Cc: "Dmitry Vyukov" <dvyukov@google.com>
Cc: <linux-usb@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Fixes: 6f23ee1fefdc ("USB: add binary API to usbmon")

For the VM_MAYWRITE part:
Suggested-by: PaX Team <pageexec@freemail.hu>

Link: https://syzkaller.appspot.com/bug?id=2eb1f35d6525fa4a74d75b4244971e5b1411c95a
Reported-by: syzbot+23f57c5ae902429285d7@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
v2:
   Return an error instead of quietly clearing the flag,
   when VM_WRTIE is set. Also clear VM_MAYWRITE.
---
 drivers/usb/mon/mon_bin.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index f48a23adbc35..094e812e9e69 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1268,6 +1268,11 @@ static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	/* don't do anything here: "fault" will set up page table entries */
 	vma->vm_ops = &mon_bin_vm_ops;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	vma->vm_flags &= ~VM_MAYWRITE;
 	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = filp->private_data;
 	mon_bin_vma_open(vma);
-- 
2.37.3
