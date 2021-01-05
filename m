Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF752EA206
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbhAEBAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhAEA77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 19:59:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED992256F;
        Tue,  5 Jan 2021 00:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808359;
        bh=KS5gmCZ6EzJVi1yQawSh86bpDzZj0sa0Ft49c6zGkvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKY1IGTNXgizkZxPfqeSpmbvLhg/pRDvt9xr+N08cHVW+x0J7rVQan/9sTEC3gNMz
         Q3q4fLkyBjDMvx4L1bJWAzw0Z6y/wRKWlfcdPhzSIBbm/99gxBy4Nrwj/O5x/QZDL7
         LVECIpnY7b6ObYRZkFPyPFhfaDRPfgF3JI91aQnNZPyUUtPbVDiM1lNJZMdN4uN474
         zHJ+rNuQpPkRnYB4GeI2XBeb35VOj0rHblMw2YDjGiSv+HTpQ4cXC7GQWLEoew4Qtu
         WbNARxKZmuQpVqgOa6AX5Iam6lcsIKhS6yKbMvSCpBVdwA8O5ERqFOtmUPFIJl0Q7X
         bfPm8DZ0Rt1ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/17] scsi: ufs: Fix wrong print message in dev_err()
Date:   Mon,  4 Jan 2021 19:59:00 -0500
Message-Id: <20210105005915.3954208-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005915.3954208-1-sashal@kernel.org>
References: <20210105005915.3954208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 1fa0570002e3f66db9b58c32c60de4183b857a19 ]

Change dev_err() print message from "dme-reset" to "dme_enable" in function
ufshcd_dme_enable().

Link: https://lore.kernel.org/r/20201207190137.6858-3-huobean@gmail.com
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 911aba3e7675c..d7e9c4bc80478 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3620,7 +3620,7 @@ static int ufshcd_dme_enable(struct ufs_hba *hba)
 	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
 	if (ret)
 		dev_err(hba->dev,
-			"dme-reset: error code %d\n", ret);
+			"dme-enable: error code %d\n", ret);
 
 	return ret;
 }
-- 
2.27.0

