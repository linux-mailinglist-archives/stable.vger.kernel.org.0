Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429A4300B13
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbhAVSUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbhAVOXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19D8F23AFE;
        Fri, 22 Jan 2021 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325019;
        bh=lkqE5f3qb6E6Gs69DA9ZChZmyiuLBQy/EDcksU3bHgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HWQjI6ymuIdsGiBWhG1FsEW7vCnYVCiPQksJ+SwsF0EEs84HJyUiUPuc9JjtpKsL
         kBQzVGF274YjAMRCXot90Uki+gdqFuhfUfKJ+2PRFuHucptJf2p2BvxxNzzINp1zFM
         cC99JEcAm4x77UFJXojES2NmUZXASqIH8CR+Bkbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        James Smart <james.smart@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 06/33] scsi: lpfc: Make lpfc_defer_acc_rsp static
Date:   Fri, 22 Jan 2021 15:12:22 +0100
Message-Id: <20210122135733.832053756@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

commit fdb827e4a3f84cb92e286a821114ac0ad79c8281 upstream.

Fix sparse warning:

drivers/scsi/lpfc/lpfc_nportdisc.c:344:1: warning:
 symbol 'lpfc_defer_acc_rsp' was not declared. Should it be static?

Link: https://lore.kernel.org/r/20200107014956.41748-1-yuehaibing@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_nportdisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -340,7 +340,7 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *ph
  * This routine is only called if we are SLI4, acting in target
  * mode and the remote NPort issues the PLOGI after link up.
  **/
-void
+static void
 lpfc_defer_acc_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;


