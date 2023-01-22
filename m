Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0D767730A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 23:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjAVWwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 17:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjAVWwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 17:52:45 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC03255AD
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:52:44 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id i1so5277078ilu.8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2TjhdUkTSjM3fsoPHjiZ7mgr/rcaoErwun6z+/rwNn8=;
        b=PpAxmSycDZRXVhvD8VPU8AqphBBXpVqRI3Ws1vvSjaQ1ByY0Zc70aYxbLKEblBITaO
         B4mjMNH8orn/RGv1MHrCHHwKQ0OIHxnvfVf4FjHQFqhYdPxm/wdmvbC5eq7nLLCSqeGU
         pgFAHQ0Pxtn4mcaQ78IJZJm14DTUJoi+BAEKf2PNmgOdvITntCIm+00G9aMAfE60jGZq
         aLBIL2zXWLIdS/f0MeICCfly85GjFUnObc3gxWyYJReY7Ucc37m9thynNlrj8/Zjkduf
         EWKd/3APxJAyfiIslEO+qDITNZRsoOXMclUGSqKXjJmo/IQHQ0TNGapDa7sEq7RC9SBz
         nFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2TjhdUkTSjM3fsoPHjiZ7mgr/rcaoErwun6z+/rwNn8=;
        b=XFadkX8aqHVmPnTaVJPCtznhRJNi29gGJ+lSavSfqzSh6WhA0ITsZN9DtOQFeUVcAA
         tPm28jjKSgSxw2MuVsEMkrTGYehQY/g+9BHZA94nzR1CoGqEU+2Jd3Ns24ZrVR/xWDmj
         bxgMkMpEZoG0uI+qDFFP9U2ZFBS7E38q9FvIkMaM2d3uLr2Flqff9yPkh8tlkjgT69BZ
         o33H58e1b/rwhZzL6wHog8JI5Bjl2ViFKmg3/8NmdRYjyu8+3GUh2y76Mh5w10n++Txa
         nHMSY6oNC0JggZxYVG5YJ0uHN/cvyLAl+2MIDu9Ak09zBWgfEGivo7AB1Q0scg6zwfJT
         797A==
X-Gm-Message-State: AFqh2kq8w5f+L/RqXtQc6EHdv3qWVa9onJ0644IWJEiLxM6r8h9YbjK+
        HrnCOOnYcT4bIQl5u//KkT0Ptbcrrq0=
X-Google-Smtp-Source: AMrXdXvwJk+i2w+T8EvonqmAbSEuqne4J9AVUwiQvFNeNtWyBJp2iz+B9qvGTemptFDYt7piVhBHWw==
X-Received: by 2002:a05:6e02:1a67:b0:30f:333a:7b53 with SMTP id w7-20020a056e021a6700b0030f333a7b53mr16056148ilv.9.1674427963636;
        Sun, 22 Jan 2023 14:52:43 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id d27-20020a02605b000000b00374fbd37c72sm14577349jaf.147.2023.01.22.14.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 14:52:43 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1/2] octeontx2-pf: Avoid use of GFP_KERNEL in atomic context
Date:   Mon, 23 Jan 2023 06:47:34 +0800
Message-Id: <20230122224735.3713948-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

commit 87b93b678e95c7d93fe6a55b0e0fbda26d8c7760 upstream.

Using GFP_KERNEL in preemption disable context, causing below warning
when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.

[   32.542271] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
[   32.550883] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
[   32.558707] preempt_count: 1, expected: 0
[   32.562710] RCU nest depth: 0, expected: 0
[   32.566800] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc2-00269-gae9dcb91c606 #7
[   32.576188] Hardware name: Marvell CN106XX board (DT)
[   32.581232] Call trace:
[   32.583670]  dump_backtrace.part.0+0xe0/0xf0
[   32.587937]  show_stack+0x18/0x30
[   32.591245]  dump_stack_lvl+0x68/0x84
[   32.594900]  dump_stack+0x18/0x34
[   32.598206]  __might_resched+0x12c/0x160
[   32.602122]  __might_sleep+0x48/0xa0
[   32.605689]  __kmem_cache_alloc_node+0x2b8/0x2e0
[   32.610301]  __kmalloc+0x58/0x190
[   32.613610]  otx2_sq_aura_pool_init+0x1a8/0x314
[   32.618134]  otx2_open+0x1d4/0x9d0

To avoid use of GFP_ATOMIC for memory allocation, disable preemption
after all memory allocation is done.

Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Kevin: Fix the conflict due to the context change in v5.15]
Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f6306eedd59b..30d4c0ad712d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1316,7 +1316,6 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1334,13 +1333,14 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
 				goto err_mem;
+			get_cpu();
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
+			put_cpu();
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
 
 err_mem:
-	put_cpu();
 	return err ? -ENOMEM : 0;
 
 fail:
-- 
2.38.1

