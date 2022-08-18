Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F175981FF
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 13:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244292AbiHRLJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 07:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244240AbiHRLJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 07:09:19 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8103CBED
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 04:09:17 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id s9so1374511ljs.6
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 04:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=PFisyvghtZppBD/jTo0TmJKinYh/1xxc+KyEJEXrH70=;
        b=TrHuGMeMv+mtek+G3hUQ2eWYdR8oIidVHv0MNI3PjIQUtVd31z3ju/xBbMb6HaG6sF
         3sXJpxrCX9vDEddnLKenCC17AYfhakGGWS1V9NP5FNfzMS+pxJz1FQHep6Izf8FuhqEy
         oXcBIHfIggIZuGd/ouTKfDa5YSD6qB3DnLqTNG4hKQn2HENvKoRqKiVwulzrWmNDkbds
         39G7T+97IOscYHNXSVTs3RQ0b/sPgEFN/ymVqclffLyx9vdEvzXr2bCNCEC14irJv1oy
         UWO5UyTlN9hycdY7lNYGu7CXEWp8IwKOgQQ2JxtATIhGccAsQBtIhAibJ2h8g178P15I
         4w/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=PFisyvghtZppBD/jTo0TmJKinYh/1xxc+KyEJEXrH70=;
        b=qmukgciqpy8DsDZt6tb6QZ9OTu83vG3Q3oRe+BukTIPtBMyxO0c/jJ1NqwSKLuppjd
         74Y0uy3kj+z9JoABML362w66NFrHQV0FyYWlc9hLXLHKQEncc30TG6xB0/9B4YnAV2SQ
         lo0Ug4IsMYXWvErq+8wO+C3ZliSawtooAxc8VCXY+Pi4oob4qz+1Gskg9b/T/bxnaCQN
         Iw3UrLg3MyO+RcyA5kLS/QBxvKGGgeu1v8sD77kDYNgA2bFkp1h9E37USwzAbKxCBKcE
         pGdWdlS9mDQ69IRnE5LkcyTuM+bL5sQ/B+GTfvxJZvcFVxpKRqg6WnrpAyGul854ieC8
         Y0TQ==
X-Gm-Message-State: ACgBeo2vKdZ8sgQwiGUtxtKCrG2EeWle5QMvp4p9Jfiadhe79EchBja/
        Cx04wGkeYLsqFT0bPEMHxXSGIw==
X-Google-Smtp-Source: AA6agR75y3XgtF6Wl6mbiKberA7HavCqTxTgRlDxmsSGrgUExuSbEriJOdRNuQ/fXmItJEDN+fa49Q==
X-Received: by 2002:a2e:8e90:0:b0:260:201:765b with SMTP id z16-20020a2e8e90000000b002600201765bmr760980ljk.432.1660820956039;
        Thu, 18 Aug 2022 04:09:16 -0700 (PDT)
Received: from jade.urgonet (h-79-136-84-253.A175.priv.bahnhof.se. [79.136.84.253])
        by smtp.gmail.com with ESMTPSA id s13-20020a05651c048d00b0025e4ed638dcsm184825ljc.59.2022.08.18.04.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 04:09:15 -0700 (PDT)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        stable@vger.kernel.org, Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Jerome Forissier <jerome.forissier@linaro.org>
Subject: [PATCH v2] tee: add overflow check in register_shm_helper()
Date:   Thu, 18 Aug 2022 13:08:59 +0200
Message-Id: <20220818110859.1918035-1-jens.wiklander@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With special lengths supplied by user space, register_shm_helper() has
an integer overflow when calculating the number of pages covered by a
supplied user space memory region. This causes
internal_get_user_pages_fast() a helper function of
pin_user_pages_fast() to do a NULL pointer dereference.

[   14.141620] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
[   14.142556] Mem abort info:
[   14.142829]   ESR = 0x0000000096000044
[   14.143237]   EC = 0x25: DABT (current EL), IL = 32 bits
[   14.143742]   SET = 0, FnV = 0
[   14.144052]   EA = 0, S1PTW = 0
[   14.144348]   FSC = 0x04: level 0 translation fault
[   14.144767] Data abort info:
[   14.145053]   ISV = 0, ISS = 0x00000044
[   14.145394]   CM = 0, WnR = 1
[   14.145766] user pgtable: 4k pages, 48-bit VAs, pgdp=000000004278e000
[   14.146279] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
[   14.147435] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[   14.148026] Modules linked in:
[   14.148595] CPU: 1 PID: 173 Comm: optee_example_a Not tainted 5.19.0 #11
[   14.149204] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
[   14.149832] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   14.150481] pc : internal_get_user_pages_fast+0x474/0xa80
[   14.151640] lr : internal_get_user_pages_fast+0x404/0xa80
[   14.152408] sp : ffff80000a88bb30
[   14.152711] x29: ffff80000a88bb30 x28: 0000fffff836d000 x27: 0000fffff836e000
[   14.153580] x26: fffffc0000000000 x25: fffffc0000f4a1c0 x24: ffff00000289fb70
[   14.154634] x23: ffff000002702e08 x22: 0000000000040001 x21: ffff8000097eec60
[   14.155378] x20: 0000000000f4a1c0 x19: 00e800007d287f43 x18: 0000000000000000
[   14.156215] x17: 0000000000000000 x16: 0000000000000000 x15: 0000fffff836cfb0
[   14.157068] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[   14.157747] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
[   14.158576] x8 : ffff00000276ec80 x7 : 0000000000000000 x6 : 000000000000003f
[   14.159243] x5 : 0000000000000000 x4 : ffff000041ec4eac x3 : ffff000002774cb8
[   14.159977] x2 : 0000000000000004 x1 : 0000000000000010 x0 : 0000000000000000
[   14.160883] Call trace:
[   14.161166]  internal_get_user_pages_fast+0x474/0xa80
[   14.161763]  pin_user_pages_fast+0x24/0x4c
[   14.162227]  register_shm_helper+0x194/0x330
[   14.162734]  tee_shm_register_user_buf+0x78/0x120
[   14.163290]  tee_ioctl+0xd0/0x11a0
[   14.163739]  __arm64_sys_ioctl+0xa8/0xec
[   14.164227]  invoke_syscall+0x48/0x114
[   14.164653]  el0_svc_common.constprop.0+0x44/0xec
[   14.165130]  do_el0_svc+0x2c/0xc0
[   14.165498]  el0_svc+0x2c/0x84
[   14.165847]  el0t_64_sync_handler+0x1ac/0x1b0
[   14.166258]  el0t_64_sync+0x18c/0x190
[   14.166878] Code: 91002318 11000401 b900f7e1 f9403be1 (f820d839)
[   14.167666] ---[ end trace 0000000000000000 ]---

Fix this by adding an overflow check when calculating the end of the
memory range. Also add an explicit call to access_ok() in
tee_shm_register_user_buf() to catch an invalid user space address
early.

Fixes: 033ddf12bcf5 ("tee: add register user memory")
Cc: stable@vger.kernel.org
Reported-by: Nimish Mishra <neelam.nimish@gmail.com>
Reported-by: Anirban Chakraborty <ch.anirban00727@gmail.com>
Reported-by: Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>
Suggested-by: Jerome Forissier <jerome.forissier@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/tee_shm.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index f2b1bcefcadd..f71651021c8d 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -231,15 +231,30 @@ EXPORT_SYMBOL_GPL(tee_shm_alloc_priv_buf);
 
 static struct tee_shm *
 register_shm_helper(struct tee_context *ctx, unsigned long addr,
-		    size_t length, u32 flags, int id)
+		    unsigned long length, u32 flags, int id)
 {
 	struct tee_device *teedev = ctx->teedev;
+	unsigned long end_addr;
 	struct tee_shm *shm;
 	unsigned long start;
 	size_t num_pages;
 	void *ret;
 	int rc;
 
+	/* Check for overflows, this may be input from user space */
+	addr = untagged_addr(addr);
+	start = rounddown(addr, PAGE_SIZE);
+	if (check_add_overflow(addr, length, &end_addr))
+		return ERR_PTR(-EINVAL);
+	end_addr = roundup(end_addr, PAGE_SIZE);
+	if (end_addr < start)
+		return ERR_PTR(-EINVAL);
+	num_pages = (end_addr - start) / PAGE_SIZE;
+
+	/* Error out early if no pages are to be registered */
+	if (!num_pages)
+		return ERR_PTR(-EINVAL);
+
 	if (!tee_device_get(teedev))
 		return ERR_PTR(-EINVAL);
 
@@ -261,11 +276,8 @@ register_shm_helper(struct tee_context *ctx, unsigned long addr,
 	shm->flags = flags;
 	shm->ctx = ctx;
 	shm->id = id;
-	addr = untagged_addr(addr);
-	start = rounddown(addr, PAGE_SIZE);
 	shm->offset = addr - start;
 	shm->size = length;
-	num_pages = (roundup(addr + length, PAGE_SIZE) - start) / PAGE_SIZE;
 	shm->pages = kcalloc(num_pages, sizeof(*shm->pages), GFP_KERNEL);
 	if (!shm->pages) {
 		ret = ERR_PTR(-ENOMEM);
@@ -326,6 +338,9 @@ struct tee_shm *tee_shm_register_user_buf(struct tee_context *ctx,
 	void *ret;
 	int id;
 
+	if (!access_ok((void __user *)addr, length))
+		return ERR_PTR(-EFAULT);
+
 	mutex_lock(&teedev->mutex);
 	id = idr_alloc(&teedev->idr, NULL, 1, 0, GFP_KERNEL);
 	mutex_unlock(&teedev->mutex);
-- 
2.31.1

