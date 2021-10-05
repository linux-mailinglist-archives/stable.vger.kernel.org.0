Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E54E4228CB
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhJENyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235525AbhJENxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC43B615A6;
        Tue,  5 Oct 2021 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441888;
        bh=58FXAWuN6B7tdOM0Dsabq1bZUoHaGb8nXGyBOe+AGWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceRK+86EAFATCxll/ZWPPCGFuN8GLBcReUdQas8HrQEtHl6I1yd8ZGnFdSsU6gOoZ
         fhKBIUF5yUxA7eTlTAE9Jdzq0k+iTMUXnYuhY8Q9gHVlJwze8eGVtxo/3Oq/fIwejN
         YaqwfBpJeoT3BDqa/iRkTE10UM1p6qCic558JTmPI5zEOkHi5RheOzTkj9pvdIGBiZ
         U0KQXyICGbOMyps+4kU4T/KCOd2ju+n3GgDsQyAIp18gwvFFHNEl/OrOtvQG1TQNLx
         xKLp4ioeJEAsRk7+s9dRRHt2uVq+1f4JsQ2vNf5CAatNx4+Lvg0/J4ew/J7xi7hihV
         l3xM5RcdXWjFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, mst@redhat.com,
        jasowang@redhat.com, jejb@linux.ibm.com,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 34/40] scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Tue,  5 Oct 2021 09:50:13 -0400
Message-Id: <20211005135020.214291-34-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit cced4c0ec7c06f5230a2958907a409c849762293 ]

There are a couple of spelling mistakes in pr_info and pr_err messages.
Fix them.

Link: https://lore.kernel.org/r/20210924230330.143785-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b0deaf4af5a3..13f55f41a902 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -300,7 +300,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 		}
 		break;
 	default:
-		pr_info("Unsupport virtio scsi event reason %x\n", event->reason);
+		pr_info("Unsupported virtio scsi event reason %x\n", event->reason);
 	}
 }
 
@@ -392,7 +392,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 		virtscsi_handle_param_change(vscsi, event);
 		break;
 	default:
-		pr_err("Unsupport virtio scsi event %x\n", event->event);
+		pr_err("Unsupported virtio scsi event %x\n", event->event);
 	}
 	virtscsi_kick_event(vscsi, event_node);
 }
-- 
2.33.0

