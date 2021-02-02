Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6648A30C015
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhBBNtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbhBBNrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2CF664F89;
        Tue,  2 Feb 2021 13:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273296;
        bh=iZpyMwa3C4bNTPhLDUU5Cs6F4VC/MxuvXIOE00AKwNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNU8YPL71Qo/61W62UZEZhtoyb3y1+6v13ktr2EdUIeWc36J46D+pbZskf6DsB/at
         tyEL+q1Ryfa3OsdpYev/SJjxjICRTun1MJpYG5bpxLsmqFrjYXSXduXKwWF9wP25Jl
         o2aNjJCJIB+781wdLbbBSVwoI8qcS3OrIm+Q0Pk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matti Gottlieb <matti.gottlieb@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 054/142] iwlwifi: Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.
Date:   Tue,  2 Feb 2021 14:36:57 +0100
Message-Id: <20210202132959.946912163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Gottlieb <matti.gottlieb@intel.com>

commit 4886460c4d1576e85b12601b8b328278a483df86 upstream.

The bit that indicates if the device supports 160MHZ
is bit #9. The macro checks bit #8.

Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Fixes: d6f2134a3831 ("iwlwifi: add mac/rf types and 160MHz to the device tables")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.bddbf9b57a75.I16e09e2b1404b16bfff70852a5a654aa468579e2@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -498,7 +498,7 @@ struct iwl_cfg {
 #define IWL_CFG_CORES_BT_GNSS		0x5
 
 #define IWL_SUBDEVICE_RF_ID(subdevice)	((u16)((subdevice) & 0x00F0) >> 4)
-#define IWL_SUBDEVICE_NO_160(subdevice)	((u16)((subdevice) & 0x0100) >> 9)
+#define IWL_SUBDEVICE_NO_160(subdevice)	((u16)((subdevice) & 0x0200) >> 9)
 #define IWL_SUBDEVICE_CORES(subdevice)	((u16)((subdevice) & 0x1C00) >> 10)
 
 struct iwl_dev_info {


