Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F741B41E1
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgDVKzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgDVKGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BCF420575;
        Wed, 22 Apr 2020 10:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550008;
        bh=7QgeglU0Ikc/qfy2xfFtJXgiuvLE1HtqwiqKz5k4OpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/jasFN4//oYUjKmwiahPSAFNJqInuVlN5pIwq/aUV2ykNC2578car1Ri8ldkfLWt
         hNMpbzzNcDE/YEA/gKXcfpHA2t+C0vU4dAzxihgrpfHlo+ksEWsjGq/uetYp8ECTL/
         nCRJp+HFkzPNeUpleIJHf5WZWiYY1PQw+Qw13ZJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 095/125] scsi: ufs: ufs-qcom: remove broken hci version quirk
Date:   Wed, 22 Apr 2020 11:56:52 +0200
Message-Id: <20200422095048.517945138@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-qcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1094,7 +1094,7 @@ static void ufs_qcom_advertise_quirks(st
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
 	}
 
-	if (host->hw_ver.major >= 0x2) {
+	if (host->hw_ver.major == 0x2) {
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
 
 		if (!ufs_qcom_cap_qunipro(host))


