Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395C5330DFF
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCHMeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhCHMeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0298A651CF;
        Mon,  8 Mar 2021 12:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206856;
        bh=Ka9ouMWEb0Nu9M24W7opbQSgicq4l+VrtNaiTnVYThw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFET7Ct0n0B1TVKwpKjq2ATQg/lk5Sg5Y1+9DemIA5I2Ia4m9ff48o9dwM+MSGMNL
         t5oRdP0R29zFaY8lewdQVoDTasv0jRWdA3uyqbz2/Vn2r9CVWZFzCmdYqIZMW2Nunn
         gxdwJFIpYFRyhuK+2y4DZCKgb9tqbpykUHOaWDF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: [PATCH 5.10 30/42] mm: Remove examples from enum zone_type comment
Date:   Mon,  8 Mar 2021 13:30:56 +0100
Message-Id: <20210308122719.604428347@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 04435217f96869ac3a8f055ff68c5237a60bcd7e upstream

We can't really list every setup in common code. On top of that they are
unlikely to stay true for long as things change in the arch trees
independently of this comment.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20201119175400.9995-8-nsaenzjulienne@suse.de
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -354,26 +354,6 @@ enum zone_type {
 	 * DMA mask is assumed when ZONE_DMA32 is defined. Some 64-bit
 	 * platforms may need both zones as they support peripherals with
 	 * different DMA addressing limitations.
-	 *
-	 * Some examples:
-	 *
-	 *  - i386 and x86_64 have a fixed 16M ZONE_DMA and ZONE_DMA32 for the
-	 *    rest of the lower 4G.
-	 *
-	 *  - arm only uses ZONE_DMA, the size, up to 4G, may vary depending on
-	 *    the specific device.
-	 *
-	 *  - arm64 has a fixed 1G ZONE_DMA and ZONE_DMA32 for the rest of the
-	 *    lower 4G.
-	 *
-	 *  - powerpc only uses ZONE_DMA, the size, up to 2G, may vary
-	 *    depending on the specific device.
-	 *
-	 *  - s390 uses ZONE_DMA fixed to the lower 2G.
-	 *
-	 *  - ia64 and riscv only use ZONE_DMA32.
-	 *
-	 *  - parisc uses neither.
 	 */
 #ifdef CONFIG_ZONE_DMA
 	ZONE_DMA,


