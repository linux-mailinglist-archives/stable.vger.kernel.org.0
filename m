Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C404324B453
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgHTKDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730404AbgHTKBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:01:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2505622B4D;
        Thu, 20 Aug 2020 10:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917704;
        bh=an2qDyvexFxr4rBh8yzEGHY2b5T586DGONdlqCE5QIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC9+d6ypjKU2uxnRF7JwOrZHJx4gQOBieU7opyEg9+lkGmr18dH9xckxxaAhajMG9
         9Z5wU8MRCNIT91Dd/LGpSOjLEiXmt4LTfyB4RCE/Sn8z+FhxZB7PFEnEmMdSOWIMhx
         mVQlNudyfqQ4YsWi/t1Yb9x1fdKu1o4AFSGvndNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 100/212] brcmfmac: To fix Bss Info flag definition Bug
Date:   Thu, 20 Aug 2020 11:21:13 +0200
Message-Id: <20200820091607.395740461@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>

[ Upstream commit fa3266541b13f390eb35bdbc38ff4a03368be004 ]

Bss info flag definition need to be fixed from 0x2 to 0x4
This flag is for rssi info received on channel.
All Firmware branches defined as 0x4 and this is bug in brcmfmac.

Signed-off-by: Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200604071835.3842-6-wright.feng@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 59013572fbe3f..d6a4a08fd3c44 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -30,7 +30,7 @@
 #define BRCMF_ARP_OL_PEER_AUTO_REPLY	0x00000008
 
 #define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
-#define BRCMF_BSS_RSSI_ON_CHANNEL	0x0002
+#define BRCMF_BSS_RSSI_ON_CHANNEL	0x0004
 
 #define BRCMF_STA_WME              0x00000002      /* WMM association */
 #define BRCMF_STA_AUTHE            0x00000008      /* Authenticated */
-- 
2.25.1



