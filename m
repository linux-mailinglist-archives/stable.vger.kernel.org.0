Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FA46B7475
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCMKpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCMKpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:45:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1389130E88
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4837611C0
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8932C433D2;
        Mon, 13 Mar 2023 10:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678704300;
        bh=CW5sYZU2hH/067JWIGT4MV1m6hg64xxODR2H8y8MxK0=;
        h=Subject:To:Cc:From:Date:From;
        b=tgdE3kaIr3WaaQewQdHQIDXf6AXIw0eEosSrq9j/btIZgOOdKKNYQhjY91XRBEzma
         PjUFsY3IW0or2Q0bNac6wZ14NfFfMlQenvWAAf4XgJua0Lj7OzVE1rD5bf9J7HhBHs
         femEngytMOxwb7+KV+wJF+AUi00/Bcu+5qr5jju0=
Subject: FAILED: patch "[PATCH] staging: rtl8723bs: Pass correct parameters to" failed to apply to 4.19-stable tree
To:     hdegoede@redhat.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Mar 2023 11:44:47 +0100
Message-ID: <16787042874743@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x d17789edd6a8270c38459e592ee536a84c6202db
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16787042874743@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

d17789edd6a8 ("staging: rtl8723bs: Pass correct parameters to cfg80211_get_bss()")
6994aa430368 ("staging: rtl8723bs: fix camel case in struct ndis_802_11_ssid")
d8b322b60da6 ("staging: rtl8723bs: fix camel case in struct ndis_802_11_conf")
d3fcee1b78a5 ("staging: rtl8723bs: fix camel case in struct wlan_bssid_ex")
2a62ff13132a ("staging: rtl8723bs: remove commented out condition")
ddd7c8b0033b ("staging: rtl8723bs: remove 5Ghz code blocks")
ec84d0ae54a6 ("staging: rtl8723bs: remove 5Ghz code related to channel plan definition")
708180a92cd8 ("staging: rtl8723bs: remove all 5Ghz network types")
403e6946d119 ("staging: rtl8723bs: remove if (true) statement")
2172a6576388 ("staging: rtl8723bs: remove commented out RT_ASSERT occurrences")
98dc120895a9 ("staging: rtl8723bs: split too long line")
5a94f5c84281 ("staging: rtl8723bs: fix indentation in if block")
79df841b4350 ("staging: rtl8723bs: replace DBG_871X_LEVEL logs with netdev_*()")
027ffa10b80b ("staging: rtl8723bs: remove sdio_drv_priv structure")
ee31d57e4022 ("staging: rtl8723bs: remove unnecessary dump_drv_version() usage")
a2e2a05d5d57 ("staging: rtl8723bs: remove unnecessary goto jumps")
5ffbfcf38b80 ("staging: rtl8723bs: remove empty ifdef blocks conditioned to DEBUG_CFG80211 definition")
dcc48e083749 ("staging: rtl8723bs: remove all DBG_8192C logs")
af6afdb63f17 ("staging: rtl8723bs: split long lines")
e427bdd8e1e5 ("staging: rtl8723bs: rewrite comparison to null")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d17789edd6a8270c38459e592ee536a84c6202db Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 6 Mar 2023 16:35:12 +0100
Subject: [PATCH] staging: rtl8723bs: Pass correct parameters to
 cfg80211_get_bss()

To last 2 parameters to cfg80211_get_bss() should be of
the enum ieee80211_bss_type resp. enum ieee80211_privacy types,
which WLAN_CAPABILITY_ESS very much is not.

Fix both cfg80211_get_bss() calls in ioctl_cfg80211.c to pass
the right parameters.

Note that the second call was already somewhat fixed by commenting
out WLAN_CAPABILITY_ESS and passing in 0 instead. This was still
not entirely correct though since that would limit returned
BSS-es to ESS type BSS-es with privacy on.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230306153512.162104-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 3aba4e6eec8a..84a9f4dd8f95 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -350,7 +350,7 @@ int rtw_cfg80211_check_bss(struct adapter *padapter)
 	bss = cfg80211_get_bss(padapter->rtw_wdev->wiphy, notify_channel,
 			pnetwork->mac_address, pnetwork->ssid.ssid,
 			pnetwork->ssid.ssid_length,
-			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+			IEEE80211_BSS_TYPE_ANY, IEEE80211_PRIVACY_ANY);
 
 	cfg80211_put_bss(padapter->rtw_wdev->wiphy, bss);
 
@@ -1139,8 +1139,8 @@ void rtw_cfg80211_unlink_bss(struct adapter *padapter, struct wlan_network *pnet
 
 	bss = cfg80211_get_bss(wiphy, NULL/*notify_channel*/,
 		select_network->mac_address, select_network->ssid.ssid,
-		select_network->ssid.ssid_length, 0/*WLAN_CAPABILITY_ESS*/,
-		0/*WLAN_CAPABILITY_ESS*/);
+		select_network->ssid.ssid_length, IEEE80211_BSS_TYPE_ANY,
+		IEEE80211_PRIVACY_ANY);
 
 	if (bss) {
 		cfg80211_unlink_bss(wiphy, bss);

