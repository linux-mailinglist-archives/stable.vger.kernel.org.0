Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F122F14EA
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731817AbhAKNPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731767AbhAKNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A30322795;
        Mon, 11 Jan 2021 13:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370896;
        bh=nJXW8k50MDHJuJ3C+GABp+P+axjo7kBiWqO5tLlJr0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YInl/FmY+eMSs9BEkgLEGC2Sx+FYbGcvO2PjK5ltb6GodYGSUyx/RvhLEg01nfxJH
         HOtTAggcd0zjaNK63kv0dW7Wg/p3eSl63oqHAQw3UXJCtywhiTpD8I0VAfdJIrJ8XS
         d14vxy1AotWUlPXCsILcju24PrsaFEkje9x2fwHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Andres Freund <andres@anarazel.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/145] block: add debugfs stanza for QUEUE_FLAG_NOWAIT
Date:   Mon, 11 Jan 2021 14:01:15 +0100
Message-Id: <20210111130050.978460643@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Freund <andres@anarazel.de>

[ Upstream commit dc30432605bbbd486dfede3852ea4d42c40a84b4 ]

This was missed in 021a24460dc2. Leads to the numeric value of
QUEUE_FLAG_NOWAIT (i.e. 29) showing up in
/sys/kernel/debug/block/*/state.

Fixes: 021a24460dc28e7412aecfae89f60e1847e685c0
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 3094542e12ae0..e21eed20a1551 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -129,6 +129,7 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(PCI_P2PDMA),
 	QUEUE_FLAG_NAME(ZONE_RESETALL),
 	QUEUE_FLAG_NAME(RQ_ALLOC_TIME),
+	QUEUE_FLAG_NAME(NOWAIT),
 };
 #undef QUEUE_FLAG_NAME
 
-- 
2.27.0



