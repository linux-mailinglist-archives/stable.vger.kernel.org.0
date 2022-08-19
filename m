Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6182C59992D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 11:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346450AbiHSJuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 05:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347760AbiHSJuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 05:50:22 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A54947BB9
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 02:50:14 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id l1so4925168lfk.8
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 02:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=aiN/HyG19DAMmbb9E+HYWiEWCBwaM3d/0InVB5qAHRk=;
        b=ihVp3uzkmmR10XTCmJzBZykUjcpn6QvNZrJdy4LwjQXxGXqE48nVGTcya0+vVgtNT0
         2AdCsWNh5DnHaf2otTxA83SSN/HoK0ALD4bjAZLLGyGoAHNf4ttSxCdkX6O7rZhzKCzl
         o1gMN4L0AHcfnZKiuEOQOnUyOXyzRhsYuICNa9tPWEC2saAMi8O8b/F9+jFdKIZKY1GM
         vpe3xn7g55CwWtvFFwKRjIUOq7nddHruhmZIqnFpUO9UdlJtrg/emHA0615pet04w99F
         1HRFbPcSGmHlhHwFd1ZR3cOr+lN3/qErLQJQTi9pWGLnzKjzIos5auQd0/k2N0GAENOY
         KseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=aiN/HyG19DAMmbb9E+HYWiEWCBwaM3d/0InVB5qAHRk=;
        b=GNF0RfNfITbI5Md7MBMaEoJnI/M/HsjV29lxHP8oWMu9BBYSy2zfyW6Logc3NbxkPn
         Zgustx28up49mSOfmpk/OLTpPhBotaP9i50t7mShLnSGGVSegTv4Oyb9JbnuM5dFQyLY
         fsk03hu35XvyuB1LncBaPORjlvFnYjUnccT9VwexW9Oi0odJROqrZDCOd0kAahr499Wk
         y0Bs6IrkLXcU8Y83KkShfEICIVvkjiP99LII7LfKY5iwQ3+bC79lmd1LTeIKBp8Z9p98
         zZk9G+qUACtvrHFv7LRE5tpqpKMYhcYAZpd4hfgIGmGB7yBxjDd7epf/jGCZRAicPvVA
         kw1g==
X-Gm-Message-State: ACgBeo0jqfnD2Ngt7RkRCMuS19Hi6jLP+c2mA26UdIaxClqr/OwIaqQ+
        M8ZSVU0xf/1no8l/lTV6AsFdFg==
X-Google-Smtp-Source: AA6agR6GKA1ewQ34KeEE0/vNCZ3FJe263bs7hBJiiJxT2uwSXGEJpuJt3+vi/zOWIofu4VneRlMd9w==
X-Received: by 2002:ac2:47f1:0:b0:48a:ea6e:b8fd with SMTP id b17-20020ac247f1000000b0048aea6eb8fdmr2117418lfp.26.1660902612651;
        Fri, 19 Aug 2022 02:50:12 -0700 (PDT)
Received: from jade.urgonet (h-79-136-84-253.A175.priv.bahnhof.se. [79.136.84.253])
        by smtp.gmail.com with ESMTPSA id a8-20020a2eb548000000b00261b05d9d54sm541996ljn.127.2022.08.19.02.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 02:50:11 -0700 (PDT)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jerome Forissier <jerome.forissier@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        stable@vger.kernel.org, Nimish Mishra <neelam.nimish@gmail.com>,
        Anirban Chakraborty <ch.anirban00727@gmail.com>,
        Debdeep Mukhopadhyay <debdeep.mukhopadhyay@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [PATCH v3] tee: add overflow check in register_shm_helper()
Date:   Fri, 19 Aug 2022 11:49:52 +0200
Message-Id: <20220819094952.2602066-1-jens.wiklander@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
v2 -> v3:
- Public review
- Relies entirely on access_ok() for overflow checks as suggested
- Check against zero registersted pages is kept
- Replaced Suggested-by tag

v1 -> v2:
- Non-public review
- Added access_ok() and overflow check with roundup()

 drivers/tee/tee_shm.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index f2b1bcefcadd..a88669d6ea68 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -240,6 +240,14 @@ register_shm_helper(struct tee_context *ctx, unsigned long addr,
 	void *ret;
 	int rc;
 
+	addr = untagged_addr(addr);
+	start = rounddown(addr, PAGE_SIZE);
+	num_pages = (roundup(addr + length, PAGE_SIZE) - start) / PAGE_SIZE;
+
+	/* Error out early if no pages are to be registered */
+	if (!num_pages)
+		return ERR_PTR(-EINVAL);
+
 	if (!tee_device_get(teedev))
 		return ERR_PTR(-EINVAL);
 
@@ -261,11 +269,8 @@ register_shm_helper(struct tee_context *ctx, unsigned long addr,
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
@@ -326,6 +331,9 @@ struct tee_shm *tee_shm_register_user_buf(struct tee_context *ctx,
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

