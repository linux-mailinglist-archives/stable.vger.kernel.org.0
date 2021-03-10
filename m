Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DA5333E78
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhCJN0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231828AbhCJNZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56D3065089;
        Wed, 10 Mar 2021 13:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382727;
        bh=cd67bvXO51Pwf66pI+MMWT6NBiSeCUGB9c4cDA6SsK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaXAygKAhPflQ41oMY4RFGRes6TNwEkr8OKlnXxfSQNGqU/TjOCfMVx2fbnuWhZKx
         aowoiFDrVDsstHOg9u2072UC2VlUuERZbUpOYtsd62zga/L39Iq6rR7nKXAyZ+Ctir
         bmc7Az8C8cOZWqQsErRQbEmvUla1QQz4ctmVLLME=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/49] scsi: ufs: Fix a duplicate dev quirk number
Date:   Wed, 10 Mar 2021 14:23:57 +0100
Message-Id: <20210310132323.397118099@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit 9599a1cf23330008d90b7c232efe95de7510ff29 ]

Fixes: 2b2bfc8aa519 ("scsi: ufs: Introduce a quirk to allow only page-aligned sg entries")
Link: https://lore.kernel.org/r/20210211104638.292499-1-avri.altman@wdc.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a0bc118f9188..812aa348751e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -553,7 +553,7 @@ enum ufshcd_quirks {
 	/*
 	 * This quirk allows only sg entries aligned with page size.
 	 */
-	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 13,
+	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
 };
 
 enum ufshcd_caps {
-- 
2.30.1



