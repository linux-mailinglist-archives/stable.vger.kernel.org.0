Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C3406071
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhIJARZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229827AbhIJARU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870016023D;
        Fri, 10 Sep 2021 00:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232970;
        bh=LOtFhs2IDua0kYqMBG/6uymeNy/m6t0oV/gclux8KNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5O+Ex/htH+rl/kDGvBa2uIBABiIdPODHpsb8iOdDXP60CLkJOe5V/bC6EN8RQuyd
         z4LQ0AAdgaGoOQKYsn7TDMhHIywCayJ3uLjIWpQ1VNO0GNEOPZG6HR/+VRoJosarxm
         PejgdguJkdsB/wYXmwDIddrMldqC+21B/47aAeiUflhb9XYE28bNhyAXPIggP+aWnw
         afgpqQU7RPhupsz07lxvfzjzRvDVH1sF5pqZM0kwErtGW7K6jzeJO30KKH6hDFRZgq
         V/NjT2Kxo66j8GzyRKDmep6niTUb1tag8WdCb+nEs6f4L6kY70fEWvtvbWAxT3R+9i
         jBvtptgSiirCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 08/99] scsi: lpfc: Fix function description comments for vmid routines
Date:   Thu,  9 Sep 2021 20:14:27 -0400
Message-Id: <20210910001558.173296-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 50baa1595d30412177da3b22625bffc1ce4f65d5 ]

Update comment headers for functions lpfc_vmid_cmd and lpfc_vmid_poll.

Link: https://lore.kernel.org/r/20210707184351.67872-5-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c   | 5 ++---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 610b6dabb3b5..1acb8820a08e 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3884,9 +3884,8 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 /**
  * lpfc_vmid_cmd - Build and send a FDMI cmd to the specified NPort
  * @vport: pointer to a host virtual N_Port data structure.
- * @ndlp: ndlp to send FDMI cmd to (if NULL use FDMI_DID)
- * cmdcode: FDMI command to send
- * mask: Mask of HBA or PORT Attributes to send
+ * @cmdcode: application server command code to send
+ * @vmid: pointer to vmid info structure
  *
  * Builds and sends a FDMI command using the CT subsystem.
  */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index cb7773a9167d..9a84a0b06ee0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4845,7 +4845,7 @@ lpfc_sli4_fcf_redisc_wait_tmo(struct timer_list *t)
 
 /**
  * lpfc_vmid_poll - VMID timeout detection
- * @ptr: Map to lpfc_hba data structure pointer.
+ * @t: Timer context used to obtain the pointer to lpfc hba data structure.
  *
  * This routine is invoked when there is no I/O on by a VM for the specified
  * amount of time. When this situation is detected, the VMID has to be
-- 
2.30.2

