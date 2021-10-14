Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7CD42DD79
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhJNPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233344AbhJNPGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:06:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC2C661251;
        Thu, 14 Oct 2021 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223694;
        bh=58FXAWuN6B7tdOM0Dsabq1bZUoHaGb8nXGyBOe+AGWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbELqPfqrkBH55tzbq5Bm3REexOi9ex8Sk5TWybrb/Jlc0+MU3+iqTWvXbpwXcuvQ
         TsXxmxJZA07+Z1jEn/1hjXgNI89oEsgRN0mT8fYbALD2v4mQ66DYc762Y3EWov295n
         MuZ+M5UKwwGa9vVZZDlVch/+PLdsSdLte+vZkDN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 25/30] scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Thu, 14 Oct 2021 16:54:30 +0200
Message-Id: <20211014145210.349438778@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



