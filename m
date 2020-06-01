Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61C81EAB71
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731829AbgFASR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731820AbgFASR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:17:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 388DB2065C;
        Mon,  1 Jun 2020 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035446;
        bh=aWBdeAHuipsS1CnF7kn+2xqGIexF4Oyd6pLqcmDBPpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YG3k9av4yLenJcFVSqgjlzGyswJrxPhVb+1FtnBuTkIQOarvm7eliy/qo7ggCXlIt
         /rmDNV++rKlcap0gh1T5uYF9TcrKb0Dt3rzor4xHXVp6HEPmjZ5nOglVN5m8eBkxBo
         DJqUUy/wa77zRQQ4hxUW2CAsfaolXNFS4pvi6bLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.6 162/177] ieee80211: Fix incorrect mask for default PE duration
Date:   Mon,  1 Jun 2020 19:55:00 +0200
Message-Id: <20200601174101.747092556@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

commit d031781bdabe1027858a3220f868866586bf6e7c upstream.

Fixes bitmask for HE opration's default PE duration.

Fixes: daa5b83513a7 ("mac80211: update HE operation fields to D3.0")
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Link: https://lore.kernel.org/r/20200506102430.5153-1-pradeepc@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ieee80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2047,7 +2047,7 @@ ieee80211_he_ppe_size(u8 ppe_thres_hdr,
 }
 
 /* HE Operation defines */
-#define IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK		0x00000003
+#define IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK		0x00000007
 #define IEEE80211_HE_OPERATION_TWT_REQUIRED			0x00000008
 #define IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK		0x00003ff0
 #define IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET		4


