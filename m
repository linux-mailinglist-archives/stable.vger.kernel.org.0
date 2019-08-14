Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2388D99A
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbfHNRKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730421AbfHNRKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:10:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22036208C2;
        Wed, 14 Aug 2019 17:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802600;
        bh=HuRxaVhQ9x52rb/15XzzPx24nCvuKaL4i2x0kerzk+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvOo1bTp74hJEfHp4lZM1jrrndUvtywfHWGIywpoAP+J+vwCUiUtdHhITZ4DwXTeC
         xX0VPijKun8WcU3LHf/se/HKeYvW8zSr6h6b2Tq1+MEeFusa53c7xAPqbs6H7gtVhW
         SnXeUMwoYU2T/9sTmsM2+jiQERL/+ousHMLFdIzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Crispin <john@phrozen.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/91] nl80211: fix NL80211_HE_MAX_CAPABILITY_LEN
Date:   Wed, 14 Aug 2019 19:01:08 +0200
Message-Id: <20190814165751.526332664@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



