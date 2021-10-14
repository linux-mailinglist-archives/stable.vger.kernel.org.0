Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F20142DD21
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhJNPEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233422AbhJNPDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F0C61211;
        Thu, 14 Oct 2021 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223600;
        bh=iZ8eXtz7ZpiC8As78Kl4WydGQKxk+z9pgePxd7CFSX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2V95N0pAuOLcvsyUBd7YsZHgtmoy5BHLJ6bzsgDcOPuu+ixcyFDHvSpf2EnxZZCnv
         RwYc0idwwhzyZhXgi3Zy8MBFSGrb17sIy1soK4GMM5kIpphHC5c4yxWaW9+sYfcjLT
         s+yeUqRW2e/D79B/It/T7UuM5X3TrdldCtRD1Cns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/22] scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Thu, 14 Oct 2021 16:54:25 +0200
Message-Id: <20211014145208.598843858@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
References: <20211014145207.979449962@linuxfoundation.org>
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
index b9c86a7e3b97..6dac58ae6120 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -302,7 +302,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 		}
 		break;
 	default:
-		pr_info("Unsupport virtio scsi event reason %x\n", event->reason);
+		pr_info("Unsupported virtio scsi event reason %x\n", event->reason);
 	}
 }
 
@@ -394,7 +394,7 @@ static void virtscsi_handle_event(struct work_struct *work)
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



