Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B17363674
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 17:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhDRPz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 11:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhDRPz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 11:55:29 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1646C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 08:55:00 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so16662389wmg.0
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 08:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=udfyM9jO4qcDe2GCf/YfVNqqUAm/mkGEHypOUOGcgl8=;
        b=NN/33uy8aCRlIlNgNrFh5j8WQG0hhrDvit9VXeGpVVv3hxH5/i+cy57f99yGZhu1L9
         mlj3xxi5H6kAv78gs3+e/z+pwVDYjWonGN7gSABIKImaQWPKcZGJKWUYC25Tp8Nhyy2L
         AEUvla/V8/RJ6CTNmnkB4hc6opTl3rSg77QHVtF5JyMPQ5f3pKCq+gxE3UiE77BRt+O5
         CrIXGnwSKc5SJQg34gcG2L6MrRydvWHvMu02ktZo0tG9c66vq3b7DeJr/DvToPFUYoIQ
         Z39XCssVDapyY6k7PeXBJ5RbGkJRy8ffE2b0oW/cPfhF00yxGmr77tXNiLYGjazR1B5x
         gzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=udfyM9jO4qcDe2GCf/YfVNqqUAm/mkGEHypOUOGcgl8=;
        b=ifJC+TVZE4hhDcqqiFLRjWAmEosqKmxgn7SB+2vVhy/ICVHE1WYmX1yI1H47zzilbK
         /tJZbVwlvq6GWFmpfy41fdPXmdk1HNGPq0+VW6+1X5gS1zCU9ekGo657+9e93pKKIu4X
         b/reT8Q0g3DkdoXqnzFu4A0tRzMbDzWZ7oMiOpm6qTEknt8FCr2mM18TZKcjPEo0Nsxp
         txui/45q8zhgqM3zp8ho25T7KKTZ5IHmcDtm98PpfVpDCMUE/DhSOXOO4MJLz+s2kgm+
         minrjAu+KDyuoucjJp2oIhywqklrLLq+jQmm1r7egZsIuYBPQQESo9TSWqVuD4NQEi2w
         wuhQ==
X-Gm-Message-State: AOAM533dLHnJlN3TycSS2ORzr8v/Uj4nJj/dQVKHEpTNz+7U9PyrhPcl
        NSxGX4mrvRa2V2AYzzrq2gXA8EwTd1dIjw==
X-Google-Smtp-Source: ABdhPJy1aTjWIh8jh1zkjN8XElUmikFhbPKH6t9A2/kNsL/A8/3Ih7S1cxtHZTYZEY2y2jxDLKkBSA==
X-Received: by 2002:a05:600c:2f9a:: with SMTP id t26mr1347276wmn.20.1618761299373;
        Sun, 18 Apr 2021 08:54:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:7049:2393:32ac:d22c? (p200300ea8f3846007049239332acd22c.dip0.t-ipconnect.de. [2003:ea:8f38:4600:7049:2393:32ac:d22c])
        by smtp.googlemail.com with ESMTPSA id q20sm36780807wmq.2.2021.04.18.08.54.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 08:54:59 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] r8169: don't advertise pause in jumbo
 mode" failed to apply to 5.10-stable tree
To:     stable@vger.kernel.org
References: <161874219017114@kroah.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c4028e4f-6901-f5f5-a213-4435243f1058@gmail.com>
Date:   Sun, 18 Apr 2021 17:54:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <161874219017114@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.04.2021 12:36, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>>From 453a77894efa4d9b6ef9644d74b9419c47ac427c Mon Sep 17 00:00:00 2001
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Wed, 14 Apr 2021 10:47:10 +0200
> Subject: [PATCH] r8169: don't advertise pause in jumbo mode
> 
> It has been reported [0] that using pause frames in jumbo mode impacts
> performance. There's no available chip documentation, but vendor
> drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
> do the same, according to Roman it fixes the issue.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=212617
> 
> Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
> Reported-by: Roman Mamedov <rm+bko@romanrm.net>
> Tested-by: Roman Mamedov <rm+bko@romanrm.net>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 581a92fc3292..1df2c002c9f6 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2350,6 +2350,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
>  
>  	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
>  		pcie_set_readrq(tp->pci_dev, readrq);
> +
> +	/* Chip doesn't support pause in jumbo mode */
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +			 tp->phydev->advertising, !jumbo);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +			 tp->phydev->advertising, !jumbo);
> +	phy_start_aneg(tp->phydev);
>  }
>  
>  DECLARE_RTL_COND(rtl_chipcmd_cond)
> @@ -4630,8 +4637,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>  	if (!tp->supports_gmii)
>  		phy_set_max_speed(phydev, SPEED_100);
>  
> -	phy_support_asym_pause(phydev);
> -
>  	phy_attached_info(phydev);
>  
>  	return 0;
> 

>From ed6aaf67921a7ed44a3e07785c2125835ca5a969 Mon Sep 17 00:00:00 2001
From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 18 Apr 2021 17:50:06 +0200
Subject: [PATCH] r8169: don't advertise pause in jumbo mode

It has been reported [0] that using pause frames in jumbo mode impacts
performance. There's no available chip documentation, but vendor
drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
do the same, according to Roman it fixes the issue.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=212617

Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
Reported-by: Roman Mamedov <rm+bko@romanrm.net>
Tested-by: Roman Mamedov <rm+bko@romanrm.net>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d634da20b4f9..feca75eb75e4 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2419,6 +2419,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 
 	if (!jumbo && pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
 		pcie_set_readrq(tp->pci_dev, 4096);
+
+	/* Chip doesn't support pause in jumbo mode */
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 tp->phydev->advertising, !jumbo);
+	phy_start_aneg(tp->phydev);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
@@ -4710,8 +4717,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (!tp->supports_gmii)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	phy_support_asym_pause(phydev);
-
 	phy_attached_info(phydev);
 
 	return 0;
-- 
2.31.1

