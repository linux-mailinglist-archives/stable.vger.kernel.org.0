Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902A17FA87
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393997AbfHBNXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393993AbfHBNXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:23:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07C4B2182B;
        Fri,  2 Aug 2019 13:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752217;
        bh=zPLz72vRdQQ+nd03SVM/WPAEGpHOT1B5O8fp02BVKSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iv+0n2c51kMksIzOn94Xnwh+73wTGjNz1HDuEYaAjTRwNTEEfD2PYPyQL44VaFDh4
         kJ+nwo+0zbvjLE9CEpPMMIpAiR5aeXlpc0VTBcd8MNmFgQ71FisEkMgHE1UDY8lCqu
         EXS/wyfWPrUNJA0mZ0raNlHyKkMPm+KZN/ROZ5jQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/42] nl80211: fix NL80211_HE_MAX_CAPABILITY_LEN
Date:   Fri,  2 Aug 2019 09:22:33 -0400
Message-Id: <20190802132302.13537-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Crispin <john@phrozen.org>

[ Upstream commit 5edaac063bbf1267260ad2a5b9bb803399343e58 ]

NL80211_HE_MAX_CAPABILITY_LEN has changed between D2.0 and D4.0. It is now
MAC (6) + PHY (11) + MCS (12) + PPE (25) = 54.

Signed-off-by: John Crispin <john@phrozen.org>
Link: https://lore.kernel.org/r/20190627095832.19445-1-john@phrozen.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/nl80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f349427..fa43dd5a7b3dc 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2732,7 +2732,7 @@ enum nl80211_attrs {
 #define NL80211_HT_CAPABILITY_LEN		26
 #define NL80211_VHT_CAPABILITY_LEN		12
 #define NL80211_HE_MIN_CAPABILITY_LEN           16
-#define NL80211_HE_MAX_CAPABILITY_LEN           51
+#define NL80211_HE_MAX_CAPABILITY_LEN           54
 #define NL80211_MAX_NR_CIPHER_SUITES		5
 #define NL80211_MAX_NR_AKM_SUITES		2
 
-- 
2.20.1

