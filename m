Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6CD1AF24A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDRQYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 12:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726331AbgDRQYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 12:24:54 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B7AC061A0C;
        Sat, 18 Apr 2020 09:24:54 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id u13so6632606wrp.3;
        Sat, 18 Apr 2020 09:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=XGEj3VJB73XMSjdKjc291NmLGevIXZKdlnrTsayg+jI=;
        b=SIZzTwJn1Yk5or/nLv3lvJko9gK7r7meNLSAizJaXd2P+BkrneGSkZaX7F7PvWRHGx
         tskb8uW80qPF4B1Wflmodvg1Ku2ssALa/mnOMD8UHGbC9M0bNUFmUvDgCxh1hSsv+OuC
         NCqnDREXNCtElIaiBEXV9lOObMRnMql0d8Aiec9C6IW0u/cpOFUjFQg771wuAuTLdSgw
         18yYusrLrPg86sbv1amNBFhJVoauC+mJqk8fmg6gEQohbqRyVOFwX0Ra/bupcedSVs58
         2/P9WYshzBp/Jssq94je885lPDRKRsVQQK7dpP3fimazY1DB/0ByqQV0StDCVbQIu/Ml
         gHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=XGEj3VJB73XMSjdKjc291NmLGevIXZKdlnrTsayg+jI=;
        b=uYXfLbvhLaFbpu0LOylPB92vozJTWNTWQ1P9XKk2QQCx5NcpAnu2XfW//5VubWGmtt
         A4cgRCX6keWThDpMEjzb+zr8wMqmE3C4e5ctBmOCaVL2KYmR8PDSynnirUwzudq1lrTf
         zF8AMp9JeQLVjtwbZXrYdXEjp+OpMAvVQcdDnxPwgyYnIEoYxc4yv0bsrwYJr14wPlP4
         J7cG4y7mr2MXvvRG2yErLCouT0qQxtX2UM8Nvq8bCOp0Oj/oiuKpNDaf0Pom98/ZZlcv
         nW2z2vlNikphxGsvlaSYWQk5NDwBPE57QXYXboiG3yH03nazcDFb5lADcDuyjgU4koG1
         vuIA==
X-Gm-Message-State: AGi0PuZKbZ89KQYlocNHZpaXHia1dff3wp0wFKudvp6p3yRT0FxbUtoN
        Au8ThzLLDbSuZQ9PiUP3SEpei45D
X-Google-Smtp-Source: APiQypJ6/MElbXcE0UnT48kiPNKQIpXKPuGW3gXNfoZXTy3FbSd75/GBbPf07PiHkG4fgsT381XeUQ==
X-Received: by 2002:a5d:4447:: with SMTP id x7mr9540180wrr.299.1587227092419;
        Sat, 18 Apr 2020 09:24:52 -0700 (PDT)
Received: from [192.168.43.18] (188.29.165.57.threembb.co.uk. [188.29.165.57])
        by smtp.gmail.com with ESMTPSA id x18sm35822640wrs.11.2020.04.18.09.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 09:24:51 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-wireless@vger.kernel.org,
        Oscar Carter <oscar.carter@gmx.com>, stable@vger.kernel.org
From:   Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6656: Don't set RCR_MULTICAST or RCR_BROADCAST by
 default.
Message-ID: <2c24c33d-68c4-f343-bd62-105422418eac@gmail.com>
Date:   Sat, 18 Apr 2020 17:24:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mac80211/users control whether multicast is on or off don't enable it by default.

Fixes an issue when multicast/broadcast is always on allowing other beacons through
in power save.

Fixes: db8f37fa3355 ("staging: vt6656: mac80211 conversion: main_usb add functions...")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3c76d3cb5bbe..b2729d5eadfb 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -801,15 +801,11 @@ static void vnt_configure(struct ieee80211_hw *hw,
 {
 	struct vnt_private *priv = hw->priv;
 	u8 rx_mode = 0;
-	int rc;
 
 	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC;
 
-	rc = vnt_control_in(priv, MESSAGE_TYPE_READ, MAC_REG_RCR,
-			    MESSAGE_REQUEST_MACREG, sizeof(u8), &rx_mode);
-
-	if (!rc)
-		rx_mode = RCR_MULTICAST | RCR_BROADCAST;
+	vnt_control_in(priv, MESSAGE_TYPE_READ, MAC_REG_RCR,
+		       MESSAGE_REQUEST_MACREG, sizeof(u8), &rx_mode);
 
 	dev_dbg(&priv->usb->dev, "rx mode in = %x\n", rx_mode);
 
-- 
2.25.1
