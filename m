Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CFB451430
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241876AbhKOUCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344309AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3D426365E;
        Mon, 15 Nov 2021 18:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002543;
        bh=5tNJ7cn2V77si9hZuvtyH4t0dwIsYFYNiyA4DJomHtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eblf+ywOhWGLnEyrI61EeDp6sYdu8zcY8ioqgLLTa3FS01Kk2Angh83g+pQp/fWqU
         tmyeiCGh7av4bcn4ZXZ0EjgZfLHkbVEmbiUKPhYecHqMrBjwm/aEB7SxPC5W2KxoMO
         aFKpQg29nT5QkntWkoafnfA1HBGQRN5gQyvX91X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 608/917] scsi: ufs: core: Fix ufshcd_probe_hba() prototype to match the definition
Date:   Mon, 15 Nov 2021 18:01:43 +0100
Message-Id: <20211115165449.407912089@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 68444d73d6a5864ede12df6366bd6602e022ae5b ]

Since commit 568dd9959611 ("scsi: ufs: Rename the second ufshcd_probe_hba()
argument"), the second ufshcd_probe_hba() argument has been changed to
init_dev_params.

Link: https://lore.kernel.org/r/20210929200640.828611-3-huobean@gmail.com
Fixes: 568dd9959611 ("scsi: ufs: Rename the second ufshcd_probe_hba() argument")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 41f2ff35f82b2..b02feb3ab7b56 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -223,7 +223,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
-- 
2.33.0



