Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C507419C9C0
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388894AbgDBTRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39776 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388902AbgDBTRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id e9so4949778wme.4
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NOfGgcTiWADSg1kaZeJWpioqsrn+8/pbHvDt5GKLgns=;
        b=YZCuQWU5BAn2BJez3L9OldALsx+UcsDPJ/YEAJP9L3nVBZ8FwAXiDVA67rekiEV3Ms
         TvEzGGqAOhirF7RhPlqa0gHTgcc5OBwmw7YfodgoinO3GRyxViOmBGRQZurGVswl4TU7
         014Wdsj0jQMIMfrKYzLuMRjaPnw36OLqT3d8fYxWnxhvkUxJ7l6hFK9h4sBg5Vj0D9bK
         QKfGFJWyouJ9CuMGEz6d3mpFrypyUBNcGpEIxqnYeY07ErsUeTR7roMhc4mABkUBLSTQ
         1ARulwFvLQePWNYJFD604VxDEJkpROe4CHGzQ44qMv4b1HOCOBFZ/3mVGuDgjTQqrIix
         JO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOfGgcTiWADSg1kaZeJWpioqsrn+8/pbHvDt5GKLgns=;
        b=Dzo4DwUaU/opeOkac2k+QJpb4oAwuFV3u030WvlqD4ii92Vwt0iVDtE9IXaZLk079X
         VvHa8zf0FJ7eEKmPB1wbzrBDTgEtrHzyIKubZ7teeMckfLIm1nDBMgxeOU2lIwBBzugO
         puOzbWL25/rLWsIOy+biPhjBQbZFZtV3ZCX+6nQ2zrYqzqVVw4OHCrdcH7jKgpqf9Kee
         jpwjFs0SSnPUXHPel31tnnCxZl81vuCqoSLS5p/OV00xSq/3D7A9WP7dvzhCENjY2+bq
         thFNglHpBZVNHSx5zI22B4XS8W00UZ/AhKrMlio6JvY+21+3XApXxeZsJgA632xhTrHH
         lVZA==
X-Gm-Message-State: AGi0PuajjDAsLwKXQFR23KVq/qp4uJcSvaNggh8/FheWe6wqPfr9b9qO
        +6eVOWMZnQNoSoZ94G/7fkGqYdn5nT1XGw==
X-Google-Smtp-Source: APiQypKGQRIkLk4/8mneXJDQ/+3+j+Fjsdf8bbBSAYdTQcehMw8ptcZh6s0FjJjKiKeF3+uUDIoqdg==
X-Received: by 2002:a1c:e904:: with SMTP id q4mr4757274wmc.84.1585855029160;
        Thu, 02 Apr 2020 12:17:09 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 15/24] scsi: ufs: ufs-qcom: remove broken hci version quirk
Date:   Thu,  2 Apr 2020 20:17:38 +0100
Message-Id: <20200402191747.789097-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

[ Upstream commit 69a6fff068567469c0ef1156ae5ac8d3d71701f0 ]

UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION is only applicable for QCOM UFS host
controller version 2.x.y and this has been fixed from version 3.x.y
onwards, hence this change removes this quirk for version 3.x.y onwards.

[mkp: applied by hand]

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 51d559214db60..1fe193590b8bd 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1094,7 +1094,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
 	}
 
-	if (host->hw_ver.major >= 0x2) {
+	if (host->hw_ver.major == 0x2) {
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
 
 		if (!ufs_qcom_cap_qunipro(host))
-- 
2.25.1

