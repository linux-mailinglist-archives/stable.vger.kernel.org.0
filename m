Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23DEC04BA
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 13:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfI0L5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 07:57:15 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41946 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfI0L5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Sep 2019 07:57:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id f20so2067288edv.8
        for <stable@vger.kernel.org>; Fri, 27 Sep 2019 04:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=VudhGRJgGztFYCAmFPgwFvyUZFG1tYJLdgT5ME4hLeY=;
        b=bmsRfqs16rp2xRphehEeZNwjV826IYwMPMC/4iuMJR81mrmjoqulVp3XYL+TdgATTk
         8Q4Jo+ygWm+U2l/opABA/IstTdQmpNed85RcEyNv9KmqpuRyAGvl+Wym/TddifjVpjwi
         xQNQLScqv39CCKbB06fjKX5pkVkX+DyLUdgYGvozeMmsdMUlO23YiJqJLNTvMfGd2aGm
         ZqAIXcoB7lZV/9e78FVDWIpZxEbC2XQd0TyM5MqyJrk1oW2ZflunO2BwQvsulsBidVDv
         HLbLcchKGBDTE7AaGT2kqFdYU7dQUSPyTSFQBuw9hYfOCqwlVnEMPfCXH2JzkpUipEP5
         w53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=VudhGRJgGztFYCAmFPgwFvyUZFG1tYJLdgT5ME4hLeY=;
        b=gXZ36pGBBxgluJTEYhyEK/uKM2ThaRZ2akCG9soMoYElRuTa7E1F9qlDOfdRdhrwxl
         2oQo5YimmtcGLE/a1qcwUsgc3Kvp+XldA5loB6ZU0RpOcnrcI8npFOfzupAMMeaIesqq
         QtAcP46b9wwlLhGyz7Hf/drb7WMuyrApeijsSgupPc2CpHkixFxpErSbzUJ6AfogjFVX
         2jh4qjDyqn6zuZFfw2+HP4t4B/y3JTcD2eQOgJQaCOi5Xmrr55XLemcyv16BxXe/5zkk
         OHEGtGLLI068W4clwSVXIqJHj4mz9kl0l1UnhvsBMeSiIBqmGBQ/aCkscatmTWcIN3hT
         UJsA==
X-Gm-Message-State: APjAAAUXr2TmhQJoIkNaYeDK/pKg12zz/EqWiPnLDsf/RlAa+6Z9IJIx
        t2asKAekPs8mADNBueKwMF3zK4i6WzU=
X-Google-Smtp-Source: APXvYqz798rkVMKnUP+/uGjp05Qo2FrYkY/2/Btg5Ep+VtaO6NYKsAADg3aFlMlHZ9RCq8Mo6wsPBA==
X-Received: by 2002:a05:6402:32f:: with SMTP id q15mr3980720edw.143.1569585433399;
        Fri, 27 Sep 2019 04:57:13 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id h58sm481389edb.43.2019.09.27.04.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 04:57:12 -0700 (PDT)
Date:   Fri, 27 Sep 2019 13:57:11 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Yu Wang <yyuwang@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Please backport 79c92ca42b5a ("mac80211: handle
 deauthentication/disassociation from TDLS peer") to 4.9
Message-ID: <20190927115711.GA8961@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

79c92ca42b5a ("mac80211: handle deauthentication/disassociation from
TDLS peer") was backported to various stable versions, back to 4.14,
but not 4.9, because there is a conflict making it not applying
cleanly to 4.9.

Ben has done the work for 3.16, which got applied 3.16.74.

Attached the backport for 4.9 for review, adjusting the context to
make it apply on top of 4.9.194.

Regards,
Salvatore

From 8e2d380a76d8cbf241390e4dfca634a1b97a89b7 Mon Sep 17 00:00:00 2001
From: Yu Wang <yyuwang@codeaurora.org>
Date: Fri, 10 May 2019 17:04:52 +0800
Subject: [PATCH] mac80211: handle deauthentication/disassociation from TDLS
 peer

commit 79c92ca42b5a3e0ea172ea2ce8df8e125af237da upstream.

When receiving a deauthentication/disassociation frame from a TDLS
peer, a station should not disconnect the current AP, but only
disable the current TDLS link if it's enabled.

Without this change, a TDLS issue can be reproduced by following the
steps as below:

1. STA-1 and STA-2 are connected to AP, bidirection traffic is running
   between STA-1 and STA-2.
2. Set up TDLS link between STA-1 and STA-2, stay for a while, then
   teardown TDLS link.
3. Repeat step #2 and monitor the connection between STA and AP.

During the test, one STA may send a deauthentication/disassociation
frame to another, after TDLS teardown, with reason code 6/7, which
means: Class 2/3 frame received from nonassociated STA.

On receive this frame, the receiver STA will disconnect the current
AP and then reconnect. It's not a expected behavior, purpose of this
frame should be disabling the TDLS link, not the link with AP.

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[Salvatore Bonaccorso: Backported to 4.9: adjust context]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mlme.c        | 12 +++++++++++-
 net/mac80211/tdls.c        | 23 +++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6708de10a3e5..0b0de3030e0d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2123,6 +2123,9 @@ void ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
 					  const u8 *addr);
 void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tdls_chsw_work(struct work_struct *wk);
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason);
+const char *ieee80211_get_reason_code_string(u16 reason_code);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f462f026fc6a..c8409d6e2b88 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2755,7 +2755,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 #define case_WLAN(type) \
 	case WLAN_REASON_##type: return #type
 
-static const char *ieee80211_get_reason_code_string(u16 reason_code)
+const char *ieee80211_get_reason_code_string(u16 reason_code)
 {
 	switch (reason_code) {
 	case_WLAN(UNSPECIFIED);
@@ -2820,6 +2820,11 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 	if (len < 24 + 2)
 		return;
 
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	if (ifmgd->associated &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid)) {
 		const u8 *bssid = ifmgd->associated->bssid;
@@ -2869,6 +2874,11 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
+	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
+		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
+		return;
+	}
+
 	sdata_info(sdata, "disassociated from %pM (Reason: %u)\n",
 		   mgmt->sa, reason_code);
 
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c64ae68ae4f8..863f92c08701 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -2001,3 +2001,26 @@ void ieee80211_tdls_chsw_work(struct work_struct *wk)
 	}
 	rtnl_unlock();
 }
+
+void ieee80211_tdls_handle_disconnect(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u16 reason)
+{
+	struct ieee80211_sta *sta;
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(&sdata->vif, peer);
+	if (!sta || !sta->tdls) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	tdls_dbg(sdata, "disconnected from TDLS peer %pM (Reason: %u=%s)\n",
+		 peer, reason,
+		 ieee80211_get_reason_code_string(reason));
+
+	ieee80211_tdls_oper_request(&sdata->vif, peer,
+				    NL80211_TDLS_TEARDOWN,
+				    WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE,
+				    GFP_ATOMIC);
+}
-- 
2.23.0

