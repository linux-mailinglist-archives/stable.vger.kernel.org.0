Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B7D1BC9DE
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731207AbgD1SnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgD1SnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E698C20575;
        Tue, 28 Apr 2020 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099393;
        bh=hBYyPRpUugYM2RKU4wm2ghw09N54/z4/XyL37XBU07E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOd1+BgTVIZI2QcLaNQkFxxvBqDa6mR2jroWN/KJAFrDRpGoPP62m53TgMZ35fWTM
         lk4ahu+LSEeGKui08Acynrq89yoxRj6+e/KUDS7KrgPg9bDgGpJx4i9VFyLTPylusW
         N4L9p3AFzpOAACcdxdSLhz479sNjphDEo7zCWVRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 131/168] iwlwifi: mvm: Do not declare support for ACK Enabled Aggregation
Date:   Tue, 28 Apr 2020 20:25:05 +0200
Message-Id: <20200428182248.630387041@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

commit 38af8d5a90a8c3b41ff0484855e24bd55b43ce9d upstream.

As this was not supposed to be enabled to begin with.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417100405.53dbc3c6c36b.Idfe118546b92cc31548b2211472a5303c7de5909@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -525,8 +525,7 @@ static struct ieee80211_sband_iftype_dat
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 				.mac_cap_info[2] =
-					IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP |
-					IEEE80211_HE_MAC_CAP2_ACK_EN,
+					IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP,
 				.mac_cap_info[3] =
 					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
 					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
@@ -610,8 +609,7 @@ static struct ieee80211_sband_iftype_dat
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 				.mac_cap_info[2] =
-					IEEE80211_HE_MAC_CAP2_BSR |
-					IEEE80211_HE_MAC_CAP2_ACK_EN,
+					IEEE80211_HE_MAC_CAP2_BSR,
 				.mac_cap_info[3] =
 					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
 					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,


