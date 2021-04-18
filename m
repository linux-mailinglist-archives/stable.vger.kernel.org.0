Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C7F363672
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 17:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhDRPzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhDRPzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 11:55:23 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404C6C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 08:54:55 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e7so22470899wrs.11
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 08:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=K7A3vzERnjukwCTQIXPbLyi+Jl6mxYCKR0t8RMaFcsk=;
        b=ptKzsWOQWqkwa5CpT61WctKG4x1u0ELfQFBIRNPNaZjKOPes38N+uFvrFVQos57qjS
         7WffqnCvbOkgnRoAAiQU17AaMBMpXmehJz1h/3OMqGB1B7DHTWSGQUGhaLadkgab/zkQ
         djBJjOWVTalviWcpB6wmVus9Efqp3q6Zbw7DgItRpiSIzE5VA/MHOwF8RK0SwEoOPIKe
         reGQxgIaGrUHc5hd+2R2Eh2m4ownnC7Un3OEFJDVOe7Qxu1cmWAk6l64uO4i5zCr+Mp1
         UdsuK9Oi0i2GmtV9S9L/cYLcYdhDZvFOKp2N45PQ6IlA7ymmQwnU2Xz2SmaKuts5xhV3
         LqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K7A3vzERnjukwCTQIXPbLyi+Jl6mxYCKR0t8RMaFcsk=;
        b=Cg+wVNwFysdwbxrQJqQnX8P4X/OJrVXVRy+OhpqaPqzek4Nuln4qApo9eRCHPNl4ZS
         M8Oem4a1TX8hxT7XjvvJVKXGknQ1+M/vjwD8xo4RRRhfbErgj0YINxtNzZhNK/kUI5T/
         996s5/L2CqAFttZwLg8J70Q1o5oBPmDQk3uUq08BjA8pKBCVrSEXlPboUmuo1j6SqmKY
         us8aIYK1v0Jq0PivumV41xYgFRrSAc7kmxi5xvmV+55Wt6xGJAlbXRzvnHMCZp6Wy0y5
         kavhGyuq8VtjDNBS+dYuTq6wEIcrHRvwP5icCZ9KOP29rBD4T8dJ0rMpMiWcYKdR1l+0
         aDcQ==
X-Gm-Message-State: AOAM532Q0VFhSSiKT2YVTSopDV8n4+aifHFYdnSj2K3jwFHR1VCQXUA7
        ETZbcx8MwO3kt4iNhALXiQ+DIzxf1g9Akw==
X-Google-Smtp-Source: ABdhPJx/HUdP92R1EnqjKMJd2Nkpgz+gm6a/22nbe1JuLt7JduNExas5lEVrgmsIEcTy6kXVGQttSA==
X-Received: by 2002:a5d:4b8e:: with SMTP id b14mr9545234wrt.86.1618761292545;
        Sun, 18 Apr 2021 08:54:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:7049:2393:32ac:d22c? (p200300ea8f3846007049239332acd22c.dip0.t-ipconnect.de. [2003:ea:8f38:4600:7049:2393:32ac:d22c])
        by smtp.googlemail.com with ESMTPSA id x8sm18924495wru.70.2021.04.18.08.54.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 08:54:51 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] r8169: don't advertise pause in jumbo
 mode" failed to apply to 5.4-stable tree
To:     stable@vger.kernel.org
References: <161874218928233@kroah.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <476069fb-8a0f-bd52-3f8e-5fbf6e0fab17@gmail.com>
Date:   Sun, 18 Apr 2021 17:53:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <161874218928233@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.04.2021 12:36, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
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

>From 90501465d4f9be209587047db1560a310a9fce1b Mon Sep 17 00:00:00 2001
From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 18 Apr 2021 17:42:13 +0200
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
index 1e8244ec5b33..d61fb63da340 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4175,6 +4175,13 @@ static void rtl_jumbo_config(struct rtl8169_private *tp, int mtu)
 		rtl_hw_jumbo_enable(tp);
 	else
 		rtl_hw_jumbo_disable(tp);
+
+	/* Chip doesn't support pause in jumbo mode */
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			 tp->phydev->advertising, mtu <= ETH_DATA_LEN);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 tp->phydev->advertising, mtu <= ETH_DATA_LEN);
+	phy_start_aneg(tp->phydev);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
@@ -6366,8 +6373,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	if (!tp->supports_gmii)
 		phy_set_max_speed(phydev, SPEED_100);
 
-	phy_support_asym_pause(phydev);
-
 	phy_attached_info(phydev);
 
 	return 0;
-- 
2.31.1

