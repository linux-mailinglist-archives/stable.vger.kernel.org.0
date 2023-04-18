Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1566E6476
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjDRMt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjDRMtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD7B3C24
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C5B3633F0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B53C433D2;
        Tue, 18 Apr 2023 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822156;
        bh=sgnAwlEzF26ishKFFok/I/STR5zd3qxwa8msNWEC4X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuKGxlkDrE09widkFUcplaTUaAcZkJa5lLY0T/4ZZdLACQo/1Hl3SaIHhWSyFXT6Y
         RhZa+iCqXJP9EaSj3qZYVpTHGXvZowLVEvPDkEnByMXOTT58uCJ2dCWRZmW8tn9XU7
         23460DGAnlRVclOCAJg7GjMGGFI4VdBpY5SEoZzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 036/139] RDMA/erdma: Fix some typos
Date:   Tue, 18 Apr 2023 14:21:41 +0200
Message-Id: <20230418120315.013479699@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 3fe26c0493e4c2da4b7d8ba8c975a6f48fb75ec2 ]

FAA is short for atomic fetch and add, not FAD. Fix this.

Fixes: 0ca9c2e2844a ("RDMA/erdma: Implement atomic operations support")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230320084652.16807-2-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_cq.c | 2 +-
 drivers/infiniband/hw/erdma/erdma_hw.h | 2 +-
 drivers/infiniband/hw/erdma/erdma_qp.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cq.c b/drivers/infiniband/hw/erdma/erdma_cq.c
index cabd8678b3558..7bc354273d4ec 100644
--- a/drivers/infiniband/hw/erdma/erdma_cq.c
+++ b/drivers/infiniband/hw/erdma/erdma_cq.c
@@ -65,7 +65,7 @@ static const enum ib_wc_opcode wc_mapping_table[ERDMA_NUM_OPCODES] = {
 	[ERDMA_OP_LOCAL_INV] = IB_WC_LOCAL_INV,
 	[ERDMA_OP_READ_WITH_INV] = IB_WC_RDMA_READ,
 	[ERDMA_OP_ATOMIC_CAS] = IB_WC_COMP_SWAP,
-	[ERDMA_OP_ATOMIC_FAD] = IB_WC_FETCH_ADD,
+	[ERDMA_OP_ATOMIC_FAA] = IB_WC_FETCH_ADD,
 };
 
 static const struct {
diff --git a/drivers/infiniband/hw/erdma/erdma_hw.h b/drivers/infiniband/hw/erdma/erdma_hw.h
index ab371fec610c3..cbeb6909580cf 100644
--- a/drivers/infiniband/hw/erdma/erdma_hw.h
+++ b/drivers/infiniband/hw/erdma/erdma_hw.h
@@ -491,7 +491,7 @@ enum erdma_opcode {
 	ERDMA_OP_LOCAL_INV = 15,
 	ERDMA_OP_READ_WITH_INV = 16,
 	ERDMA_OP_ATOMIC_CAS = 17,
-	ERDMA_OP_ATOMIC_FAD = 18,
+	ERDMA_OP_ATOMIC_FAA = 18,
 	ERDMA_NUM_OPCODES = 19,
 	ERDMA_OP_INVALID = ERDMA_NUM_OPCODES + 1
 };
diff --git a/drivers/infiniband/hw/erdma/erdma_qp.c b/drivers/infiniband/hw/erdma/erdma_qp.c
index d088d6bef431a..ff473b208acfb 100644
--- a/drivers/infiniband/hw/erdma/erdma_qp.c
+++ b/drivers/infiniband/hw/erdma/erdma_qp.c
@@ -439,7 +439,7 @@ static int erdma_push_one_sqe(struct erdma_qp *qp, u16 *pi,
 				cpu_to_le64(atomic_wr(send_wr)->compare_add);
 		} else {
 			wqe_hdr |= FIELD_PREP(ERDMA_SQE_HDR_OPCODE_MASK,
-					      ERDMA_OP_ATOMIC_FAD);
+					      ERDMA_OP_ATOMIC_FAA);
 			atomic_sqe->fetchadd_swap_data =
 				cpu_to_le64(atomic_wr(send_wr)->compare_add);
 		}
-- 
2.39.2



