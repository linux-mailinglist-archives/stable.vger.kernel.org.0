Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28824F36A1
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 19:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfKGSIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 13:08:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33245 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfKGSIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 13:08:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id w30so4189790wra.0;
        Thu, 07 Nov 2019 10:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nP8YAfmtqjtey8KByyIQp1RAciPvHA7hwpng7tJENZY=;
        b=lHnAp1RjJWiRFSzi0SYQ5rubw7XA327fXIqssMDmKWaHlUkZ4DQhbzJIE+NXccLPqW
         A9gu5ices+rq9rPzc/A6Ld2H4s8bUswlZNsv1EaY1hZ9gxnZIKmy/3HR8V1cnlf8WKbs
         2QiBCpZSQEa3WRlRY1JglNMu9JSRS/dlhCpIlRJlr3tOC6eyEjzNrooXWbU0m+DACiD0
         J+VhGdBNBwmsVx5kjXxaR152ML6vYJf4PaOMP0aPdKfAzkTWo6GOPqwJDVT4B8sMT1/t
         JDkJGX/K4tzgJGcsmiJNrZsF+S7ZGn73Fcod/k5jXvKNUtkzNseXo3A1tay500yDdBgZ
         TBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nP8YAfmtqjtey8KByyIQp1RAciPvHA7hwpng7tJENZY=;
        b=O9sfN55akHeQDRrW1a2kLJ2Nucjd31dnXfklEhSZl2RkudX1UkhuwtzY9XhgGMNdiG
         7yKXQo7zkZXPz4da6t4DzU7fN7gr5DEBiS5RFOtaixRcq80TU+HX5y1agdX2lq1byeTa
         VEqzb5LsvesG3c5Qbx2ofeNN5h7dvwF5uEyBwjDgB2NSyb2Gdg3bIK+2dBDU7FqrvUp3
         X8GIeNMo/n3T/94ce671g/YIdvH/ei6tmYztR5977it9usUlA4HqNbGLdbPgFlOAB5Y7
         CZPUZigS9rCNXOirzeqfZBKNn2+ZeMXl/rI//JeqSIouZpulh+K5/HOtFkXAqnriv7Il
         Zigw==
X-Gm-Message-State: APjAAAX++7Uw/cjnbbFC7nPBzUN1R9bW7dNbLUtKomSH2zAIdwS4Qrnn
        YLUgTI0mAj2DITy/K7X4GC+e3X3i
X-Google-Smtp-Source: APXvYqygNnfM1rDn6F75JybiE6np283Pq9y2KfL0Ieh4tMb+F5kpZuiTdMDF7XYD4PYQhZ00lAkHVA==
X-Received: by 2002:adf:dbc3:: with SMTP id e3mr1898804wrj.185.1573150110079;
        Thu, 07 Nov 2019 10:08:30 -0800 (PST)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h205sm3084265wmf.35.2019.11.07.10.08.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 10:08:29 -0800 (PST)
Subject: Re: Patch "net: bcmgenet: soft reset 40nm EPHYs before MAC init" has
 been added to the 4.19-stable tree
To:     gregkh@linuxfoundation.org, davem@davemloft.net,
        f.fainelli@gmail.com
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
References: <1573050816170143@kroah.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <5e6efc7e-f738-0198-3b74-433ae766da51@gmail.com>
Date:   Thu, 7 Nov 2019 10:08:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573050816170143@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just to triple check, this commit should be removed from the 4.19-stable
tree too.

Thanks,
    Doug

On 11/6/19 6:33 AM, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     net: bcmgenet: soft reset 40nm EPHYs before MAC init
> 
> to the 4.19-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-bcmgenet-soft-reset-40nm-ephys-before-mac-init.patch
> and it can be found in the queue-4.19 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> From foo@baz Wed 06 Nov 2019 03:31:22 PM CET
> From: Doug Berger <opendmb@gmail.com>
> Date: Wed, 16 Oct 2019 16:06:31 -0700
> Subject: net: bcmgenet: soft reset 40nm EPHYs before MAC init
> 
> From: Doug Berger <opendmb@gmail.com>
> 
> [ Upstream commit 1f515486275a08a17a2c806b844cca18f7de5b34 ]
> 
> It turns out that the "Workaround for putting the PHY in IDDQ mode"
> used by the internal EPHYs on 40nm Set-Top Box chips when powering
> down puts the interface to the GENET MAC in a state that can cause
> subsequent MAC resets to be incomplete.
> 
> Rather than restore the forced soft reset when powering up internal
> PHYs, this commit moves the invocation of phy_init_hw earlier in
> the MAC initialization sequence to just before the MAC reset in the
> open and resume functions. This allows the interface to be stable
> and allows the MAC resets to be successful.
> 
> The bcmgenet_mii_probe() function is split in two to accommodate
> this. The new function bcmgenet_mii_connect() handles the first
> half of the functionality before the MAC initialization, and the
> bcmgenet_mii_config() function is extended to provide the remaining
> PHY configuration following the MAC initialization.
> 
> Fixes: 484bfa1507bf ("Revert "net: bcmgenet: Software reset EPHY after power on"")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c |   28 +++---
>  drivers/net/ethernet/broadcom/genet/bcmgenet.h |    2 
>  drivers/net/ethernet/broadcom/genet/bcmmii.c   |  112 +++++++++++--------------
>  3 files changed, 69 insertions(+), 73 deletions(-)
> 
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -2879,6 +2879,12 @@ static int bcmgenet_open(struct net_devi
>  	if (priv->internal_phy)
>  		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
>  
> +	ret = bcmgenet_mii_connect(dev);
> +	if (ret) {
> +		netdev_err(dev, "failed to connect to PHY\n");
> +		goto err_clk_disable;
> +	}
> +
>  	/* take MAC out of reset */
>  	bcmgenet_umac_reset(priv);
>  
> @@ -2888,6 +2894,12 @@ static int bcmgenet_open(struct net_devi
>  	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
>  	priv->crc_fwd_en = !!(reg & CMD_CRC_FWD);
>  
> +	ret = bcmgenet_mii_config(dev, true);
> +	if (ret) {
> +		netdev_err(dev, "unsupported PHY\n");
> +		goto err_disconnect_phy;
> +	}
> +
>  	bcmgenet_set_hw_addr(priv, dev->dev_addr);
>  
>  	if (priv->internal_phy) {
> @@ -2903,7 +2915,7 @@ static int bcmgenet_open(struct net_devi
>  	ret = bcmgenet_init_dma(priv);
>  	if (ret) {
>  		netdev_err(dev, "failed to initialize DMA\n");
> -		goto err_clk_disable;
> +		goto err_disconnect_phy;
>  	}
>  
>  	/* Always enable ring 16 - descriptor ring */
> @@ -2926,25 +2938,19 @@ static int bcmgenet_open(struct net_devi
>  		goto err_irq0;
>  	}
>  
> -	ret = bcmgenet_mii_probe(dev);
> -	if (ret) {
> -		netdev_err(dev, "failed to connect to PHY\n");
> -		goto err_irq1;
> -	}
> -
>  	bcmgenet_netif_start(dev);
>  
>  	netif_tx_start_all_queues(dev);
>  
>  	return 0;
>  
> -err_irq1:
> -	free_irq(priv->irq1, priv);
>  err_irq0:
>  	free_irq(priv->irq0, priv);
>  err_fini_dma:
>  	bcmgenet_dma_teardown(priv);
>  	bcmgenet_fini_dma(priv);
> +err_disconnect_phy:
> +	phy_disconnect(dev->phydev);
>  err_clk_disable:
>  	if (priv->internal_phy)
>  		bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
> @@ -3657,6 +3663,8 @@ static int bcmgenet_resume(struct device
>  	if (priv->internal_phy)
>  		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
>  
> +	phy_init_hw(dev->phydev);
> +
>  	bcmgenet_umac_reset(priv);
>  
>  	init_umac(priv);
> @@ -3665,8 +3673,6 @@ static int bcmgenet_resume(struct device
>  	if (priv->wolopts)
>  		clk_disable_unprepare(priv->clk_wol);
>  
> -	phy_init_hw(dev->phydev);
> -
>  	/* Speed settings must be restored */
>  	bcmgenet_mii_config(priv->dev, false);
>  
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> @@ -723,8 +723,8 @@ GENET_IO_MACRO(rbuf, GENET_RBUF_OFF);
>  
>  /* MDIO routines */
>  int bcmgenet_mii_init(struct net_device *dev);
> +int bcmgenet_mii_connect(struct net_device *dev);
>  int bcmgenet_mii_config(struct net_device *dev, bool init);
> -int bcmgenet_mii_probe(struct net_device *dev);
>  void bcmgenet_mii_exit(struct net_device *dev);
>  void bcmgenet_phy_power_set(struct net_device *dev, bool enable);
>  void bcmgenet_mii_setup(struct net_device *dev);
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -176,6 +176,46 @@ static void bcmgenet_moca_phy_setup(stru
>  					  bcmgenet_fixed_phy_link_update);
>  }
>  
> +int bcmgenet_mii_connect(struct net_device *dev)
> +{
> +	struct bcmgenet_priv *priv = netdev_priv(dev);
> +	struct device_node *dn = priv->pdev->dev.of_node;
> +	struct phy_device *phydev;
> +	u32 phy_flags = 0;
> +	int ret;
> +
> +	/* Communicate the integrated PHY revision */
> +	if (priv->internal_phy)
> +		phy_flags = priv->gphy_rev;
> +
> +	/* Initialize link state variables that bcmgenet_mii_setup() uses */
> +	priv->old_link = -1;
> +	priv->old_speed = -1;
> +	priv->old_duplex = -1;
> +	priv->old_pause = -1;
> +
> +	if (dn) {
> +		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
> +					phy_flags, priv->phy_interface);
> +		if (!phydev) {
> +			pr_err("could not attach to PHY\n");
> +			return -ENODEV;
> +		}
> +	} else {
> +		phydev = dev->phydev;
> +		phydev->dev_flags = phy_flags;
> +
> +		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
> +					 priv->phy_interface);
> +		if (ret) {
> +			pr_err("could not attach to PHY\n");
> +			return -ENODEV;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int bcmgenet_mii_config(struct net_device *dev, bool init)
>  {
>  	struct bcmgenet_priv *priv = netdev_priv(dev);
> @@ -269,71 +309,21 @@ int bcmgenet_mii_config(struct net_devic
>  		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
>  	}
>  
> -	if (init)
> -		dev_info(kdev, "configuring instance for %s\n", phy_name);
> -
> -	return 0;
> -}
> -
> -int bcmgenet_mii_probe(struct net_device *dev)
> -{
> -	struct bcmgenet_priv *priv = netdev_priv(dev);
> -	struct device_node *dn = priv->pdev->dev.of_node;
> -	struct phy_device *phydev;
> -	u32 phy_flags = 0;
> -	int ret;
> -
> -	/* Communicate the integrated PHY revision */
> -	if (priv->internal_phy)
> -		phy_flags = priv->gphy_rev;
> -
> -	/* Initialize link state variables that bcmgenet_mii_setup() uses */
> -	priv->old_link = -1;
> -	priv->old_speed = -1;
> -	priv->old_duplex = -1;
> -	priv->old_pause = -1;
> -
> -	if (dn) {
> -		phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup,
> -					phy_flags, priv->phy_interface);
> -		if (!phydev) {
> -			pr_err("could not attach to PHY\n");
> -			return -ENODEV;
> -		}
> -	} else {
> -		phydev = dev->phydev;
> -		phydev->dev_flags = phy_flags;
> +	if (init) {
> +		phydev->advertising = phydev->supported;
>  
> -		ret = phy_connect_direct(dev, phydev, bcmgenet_mii_setup,
> -					 priv->phy_interface);
> -		if (ret) {
> -			pr_err("could not attach to PHY\n");
> -			return -ENODEV;
> -		}
> -	}
> +		/* The internal PHY has its link interrupts routed to the
> +		 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
> +		 * that prevents the signaling of link UP interrupts when
> +		 * the link operates at 10Mbps, so fallback to polling for
> +		 * those versions of GENET.
> +		 */
> +		if (priv->internal_phy && !GENET_IS_V5(priv))
> +			phydev->irq = PHY_IGNORE_INTERRUPT;
>  
> -	/* Configure port multiplexer based on what the probed PHY device since
> -	 * reading the 'max-speed' property determines the maximum supported
> -	 * PHY speed which is needed for bcmgenet_mii_config() to configure
> -	 * things appropriately.
> -	 */
> -	ret = bcmgenet_mii_config(dev, true);
> -	if (ret) {
> -		phy_disconnect(dev->phydev);
> -		return ret;
> +		dev_info(kdev, "configuring instance for %s\n", phy_name);
>  	}
>  
> -	phydev->advertising = phydev->supported;
> -
> -	/* The internal PHY has its link interrupts routed to the
> -	 * Ethernet MAC ISRs. On GENETv5 there is a hardware issue
> -	 * that prevents the signaling of link UP interrupts when
> -	 * the link operates at 10Mbps, so fallback to polling for
> -	 * those versions of GENET.
> -	 */
> -	if (priv->internal_phy && !GENET_IS_V5(priv))
> -		dev->phydev->irq = PHY_IGNORE_INTERRUPT;
> -
>  	return 0;
>  }
>  
> 
> 
> Patches currently in stable-queue which might be from opendmb@gmail.com are
> 
> queue-4.19/net-phy-bcm7xxx-define-soft_reset-for-40nm-ephy.patch
> queue-4.19/net-bcmgenet-reset-40nm-ephy-on-energy-detect.patch
> queue-4.19/net-bcmgenet-don-t-set-phydev-link-from-mac.patch
> queue-4.19/net-bcmgenet-soft-reset-40nm-ephys-before-mac-init.patch
> 

