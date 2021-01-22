Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0933300B12
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbhAVSUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728570AbhAVOXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B4F230FC;
        Fri, 22 Jan 2021 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325016;
        bh=7NtATfN3pXCDymTXpZ4z8ks7bCXDDQ1jUjDDvwrcEmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPdeSnGyc64mONBEv7B/JwMZNYNmrBdByPuTgZHoxIak+JZTIsqc2Mh9tw93GYMah
         qjCPqx/JlUpjfvpjqii+MCzBeK8fr70i9FKMm5K9RgyGo0OuSEzUjR1wbJtbgfGBkQ
         tTp1tdv8HqI2ia7lKPL6rOjnm3mM8mmrXnAJLbB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        zhengbin <zhengbin13@huawei.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 05/33] scsi: lpfc: Make function lpfc_defer_pt2pt_acc static
Date:   Fri, 22 Jan 2021 15:12:21 +0100
Message-Id: <20210122135733.790049063@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

commit f7cb0d0945ebc9879aff72cf7b3342fd1040ffaa upstream.

Fix sparse warnings:

drivers/scsi/lpfc/lpfc_nportdisc.c:290:1: warning: symbol 'lpfc_defer_pt2pt_acc' was not declared. Should it be static?

Link: https://lore.kernel.org/r/1570183477-137273-1-git-send-email-zhengbin13@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Reviewed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_nportdisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -286,7 +286,7 @@ lpfc_els_abort(struct lpfc_hba *phba, st
  * This routine is only called if we are SLI3, direct connect pt2pt
  * mode and the remote NPort issues the PLOGI after link up.
  */
-void
+static void
 lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
 {
 	LPFC_MBOXQ_t *login_mbox;


