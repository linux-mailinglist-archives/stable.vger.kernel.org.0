Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A8D499AA4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573640AbiAXVp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456592AbiAXVjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B8E0B8105C;
        Mon, 24 Jan 2022 21:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B87CC340E4;
        Mon, 24 Jan 2022 21:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060373;
        bh=Tc9AOZYZp2DQFZcIzTfoE35W2ly/fEgxYSyopAgJIBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2L6/8r7ZV1OCC0AEwbWXnX7FEBzN/Rto8GNZr6Qo9EwK8jzumXVT/d4MNq7RppVUI
         AGAG5I8E/nSuMjZBBArvDsUUMQS8OJTzGuYCxqp8sEGvGNj4DYLaS4XE8LetL78qhd
         NTVCbbSaMH+1E5qf6KaDuKyxQYNS8e/1r9plqMbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.16 0926/1039] RDMA/rxe: Fix a typo in opcode name
Date:   Mon, 24 Jan 2022 19:45:15 +0100
Message-Id: <20220124184156.418140518@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

commit 8d1cfb884e881efd69a3be4ef10772c71cb22216 upstream.

There is a redundant ']' in the name of opcode IB_OPCODE_RC_SEND_MIDDLE,
so just fix it.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20211218112320.3558770-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Acked-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_opcode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/sw/rxe/rxe_opcode.c
+++ b/drivers/infiniband/sw/rxe/rxe_opcode.c
@@ -117,7 +117,7 @@ struct rxe_opcode_info rxe_opcode[RXE_NU
 		}
 	},
 	[IB_OPCODE_RC_SEND_MIDDLE]		= {
-		.name	= "IB_OPCODE_RC_SEND_MIDDLE]",
+		.name	= "IB_OPCODE_RC_SEND_MIDDLE",
 		.mask	= RXE_PAYLOAD_MASK | RXE_REQ_MASK | RXE_SEND_MASK
 				| RXE_MIDDLE_MASK,
 		.length = RXE_BTH_BYTES,


