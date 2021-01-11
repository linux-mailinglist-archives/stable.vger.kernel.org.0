Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4122E2F14D9
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbhAKNba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:31:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731897AbhAKNPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA0A52253A;
        Mon, 11 Jan 2021 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370901;
        bh=KS5gmCZ6EzJVi1yQawSh86bpDzZj0sa0Ft49c6zGkvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olwA0EsyxxLAt2p7U7WSuzVXNVgVLC+/mEAvo//XSgD94a3YR/sL8mxX3kWsiP+pJ
         101YrVpRxogYz/RhVWA0KMeSb3V9QhHjZjanDgE0a97Ft7j/Pd1Q7TfWuWF+HRGTjf
         oyMh1NuK1B59iNKBlK+6qerhEs6dqQwh+QFAlE6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/145] scsi: ufs: Fix wrong print message in dev_err()
Date:   Mon, 11 Jan 2021 14:01:17 +0100
Message-Id: <20210111130051.077079181@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



