Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A11363673
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 17:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhDRPz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 11:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhDRPzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 11:55:25 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE48C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 08:54:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k26so15027356wrc.8
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 08:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=f1PlMPsr9PHx0ISqLspjpBduoOPJgN+P14YU+oWF1FE=;
        b=ZM2bW9ynRBywCc/VneHYy6eYyaaCai+W3otO6aZn7WePzsv4vlqw/atyBq8t2LDE+a
         5ebvgITdeVSpWO2SY7jW+0ROB7HPbojIqYKJBAmy8TOhC3ejPIZI3e6ASsb29iKtoCOr
         doU7Oxg7u0gvFfo0cEgRn+/Nds4Z+oYIrP/Ehn6NINx4OuOy8x82G+Eaoh2gizRKnSYp
         ZLJrMBilSBy8QKMkV8sM1N6JVlWety/t51DgfeunJcLV47SLg/iycEon28BQ1zk5bS1Z
         HcSPpFcV6LA6KFUGqZVAKsyOLH7j8tSrB6IZ+t0anyZnSxxf4LdmxPQj7ZQv5YJ4hyWA
         mu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f1PlMPsr9PHx0ISqLspjpBduoOPJgN+P14YU+oWF1FE=;
        b=jqZTw9vMxo2pUldqjM4bJj1F4AJNjgKdq2fcWlarsj7J84Nxcvk+z0IG4JIQ3p8Ghq
         lZmSgfS7OawndmWTOPOXjKDUXtOAMg+XFZkOGtgaqfFkM+9djJ+d7VjKJ/BjLPYse2A5
         RUemwN5IPsEPyruwDii065E32cmCMCK6CBGJAum5eTLo24684J/EY1GLauE5pvV3enQM
         xYnpQtGJP7c2P37IooHtvoRIXotLJro7xHFm4EV76TOQXtR4SQp5+X+uXIkMZUk2lkwG
         jYz1iw7L0iem28oEf66Pte8Z4oKCyEeqIiay5rTULn2igcIE7e3NvZughymJvmyjhXP7
         inGw==
X-Gm-Message-State: AOAM533bqtXtrEkzqwPwmw2eJ0M3xpccrUpUPHpxZ6ClIsz4e9amQUo3
        cWMDHmfBA5Bq77VBre5yr7fJk+a0NPr9GA==
X-Google-Smtp-Source: ABdhPJxe/8nFQntRzIfdxU+pB5o+tb8PBa325+fNjmLSgD18ey+jkf0LHfp3hqvR8AS6dSP/qR9J8A==
X-Received: by 2002:a05:6000:190:: with SMTP id p16mr9882715wrx.334.1618761296024;
        Sun, 18 Apr 2021 08:54:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:7049:2393:32ac:d22c? (p200300ea8f3846007049239332acd22c.dip0.t-ipconnect.de. [2003:ea:8f38:4600:7049:2393:32ac:d22c])
        by smtp.googlemail.com with ESMTPSA id a72sm16242080wme.29.2021.04.18.08.54.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 08:54:55 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] r8169: don't advertise pause in jumbo
 mode" failed to apply to 5.11-stable tree
To:     stable@vger.kernel.org
References: <16187421903184@kroah.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3c3c598d-f611-ff01-1597-bc06373b9d6c@gmail.com>
Date:   Sun, 18 Apr 2021 17:54:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <16187421903184@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.04.2021 12:36, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.11-stable tree.
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

