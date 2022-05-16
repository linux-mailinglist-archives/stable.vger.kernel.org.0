Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C225291DF
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346592AbiEPUER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiEPTy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:54:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A903D4754A;
        Mon, 16 May 2022 12:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC1C760BBB;
        Mon, 16 May 2022 19:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEBCC34100;
        Mon, 16 May 2022 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730540;
        bh=Ev+knGsV3BnS3a2c6ZPe8WPOAA0Zw2vLoqqN59ypFgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x952K86Qtc+oumdPptaa2hkzkX1o39DMrs5TKQArGpbCJV2GxuheuHgP3Rg4nO+cI
         838ma/eU+VOEBjlsyGOvFnouCWLbvIB//xtQFbyw2sv+6t0WwHi7aCbzzoFor156B/
         kreCu9fpn3aEHNyFu/mpd4FWhDGphYWjzxXitGkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/102] virtio: fix virtio transitional ids
Date:   Mon, 16 May 2022 21:36:05 +0200
Message-Id: <20220516193624.894398566@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shunsuke Mie <mie@igel.co.jp>

[ Upstream commit 7ff960a6fe399fdcbca6159063684671ae57eee9 ]

This commit fixes the transitional PCI device ID.

Fixes: d61914ea6ada ("virtio: update virtio id table, add transitional ids")
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Link: https://lore.kernel.org/r/20220510102723.87666-1-mie@igel.co.jp
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/virtio_ids.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 80d76b75bccd..7aa2eb766205 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -73,12 +73,12 @@
  * Virtio Transitional IDs
  */
 
-#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
-#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
-#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
-#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
-#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
-#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
-#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
+#define VIRTIO_TRANS_ID_NET		0x1000 /* transitional virtio net */
+#define VIRTIO_TRANS_ID_BLOCK		0x1001 /* transitional virtio block */
+#define VIRTIO_TRANS_ID_BALLOON		0x1002 /* transitional virtio balloon */
+#define VIRTIO_TRANS_ID_CONSOLE		0x1003 /* transitional virtio console */
+#define VIRTIO_TRANS_ID_SCSI		0x1004 /* transitional virtio SCSI */
+#define VIRTIO_TRANS_ID_RNG		0x1005 /* transitional virtio rng */
+#define VIRTIO_TRANS_ID_9P		0x1009 /* transitional virtio 9p console */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
2.35.1



