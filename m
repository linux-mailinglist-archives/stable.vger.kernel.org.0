Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F3042DC31
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhJNO5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhJNO5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B67E660F36;
        Thu, 14 Oct 2021 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223310;
        bh=Op1xPynIXSawr1fpr2Qud0HdieV2FajoysJ26UESgsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrbYnVhaEBjfZSg/Oz1+RQNVW3z/1SlwdcLYapzxheMeREqPDOcghjwThUJLiNCzZ
         1gRXhikn1uLZoBSrGs7WA3gWA20Qc0mNlyyfnxhWGyJ2GTvOXPiHLe2a0+ngfazjDB
         15BMmZeuch+2JQ4xgz62qadfRUiO+iXmoq2aUhgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/18] scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Thu, 14 Oct 2021 16:53:49 +0200
Message-Id: <20211014145206.872554382@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
References: <20211014145206.330102860@linuxfoundation.org>
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
index 9237427728ce..58e3f6db9928 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -342,7 +342,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 		}
 		break;
 	default:
-		pr_info("Unsupport virtio scsi event reason %x\n", event->reason);
+		pr_info("Unsupported virtio scsi event reason %x\n", event->reason);
 	}
 }
 
@@ -395,7 +395,7 @@ static void virtscsi_handle_event(struct work_struct *work)
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



