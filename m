Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9AB3A8696
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFOQhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 12:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhFOQhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 12:37:23 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54B9C061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 09:35:18 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id c8so19700860ybq.1
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 09:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XrIsCHyX+bwWzHgbgovzre+ZaaHXJKaZn7XOa25gCec=;
        b=PatCXQETHYY9XZ53afwA59txjpJweu9t/dPWH0nW1HR1SILNwO2DdXJtbx9J85d7QI
         U7tij/eGyHFT+l7qc7GooDpf5c60GchUnckhE8JJKnO5TDShvhzAsONxp/jt0LzWv4s2
         C2PeXQoIO6RSoOvBXqc/Cz3fM7tRxUGRaCbF2hJvLM/STZID1CiOHG43t5fBmWnpY+vz
         w31s09Ap9J1yAKXMZ5gGYrR7HwB5Vb0WgMhSx5uzwTgG7osSm3ePD2SPurgEm4wVIOAN
         hkRpiesf9uAip3kNQQ+9/6a6LXSu/L8PodQEecQL/nEkNrStRlSBkGdMzTSTXJHI6L1g
         jV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XrIsCHyX+bwWzHgbgovzre+ZaaHXJKaZn7XOa25gCec=;
        b=iA681w9ZCNUkWeNDvPJFajaCxlpFgTsVtJBP1i9sdLIZSGCxQ7rNKaywLpG0LYj1xv
         QCQwKrUozpQ+n6/gw+n1R8A+5Nik5GqxDjjUF8MGCGWPe2vPrXinJHFdfekRMkoBrN74
         Hc6FEHkIla92e3MKzLRxDcjlikKfaMc6pLnK/KWKexaooFRMXFp0bICxdZopqj5m0VyB
         l0X7m71aHuRBzn1jY2UbjVEggEs/g7IOQNmSCi7zFuPyvQDw+R/iWiriaUZN8g7BnFjM
         kP6U56mq5CopOJi3PJPLYdujL7bRakx259umJ36T5MYEe+h7cBLLeGDCvpyhBtvqBEhQ
         +3vg==
X-Gm-Message-State: AOAM5322CHXhWYmMtaaYJLuHkE8EYyddYqZaaEk2E5EiMnov4LlqQsL2
        wD0t/esHxaGwJpAbghqlmsDjY8iReKdTaFEBeIrOag==
X-Google-Smtp-Source: ABdhPJwyQ8m9Ejz1YcCBf9T7Kr9DLxB3/0BYL2DarvqJ36C7cAcoJIt/7AFjv3HJlKAazPAs4JIc1SNyHVjleVgV+0U=
X-Received: by 2002:a25:bb4e:: with SMTP id b14mr20894ybk.412.1623774917738;
 Tue, 15 Jun 2021 09:35:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210615155009.62894-1-sashal@kernel.org> <20210615155009.62894-5-sashal@kernel.org>
In-Reply-To: <20210615155009.62894-5-sashal@kernel.org>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 15 Jun 2021 09:34:41 -0700
Message-ID: <CAGETcx9-ahe0OBaHvxV+YP6cYpQQ3qsFjJFnZWPjTEWXr278MQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 05/12] drm/sun4i: dw-hdmi: Make HDMI PHY into
 a platform device
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Allwinner sunXi SoC support" 
        <linux-sunxi@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 8:50 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Saravana Kannan <saravanak@google.com>
>
> [ Upstream commit 9bf3797796f570b34438235a6a537df85832bdad ]
>
> On sunxi boards that use HDMI output, HDMI device probe keeps being
> avoided indefinitely with these repeated messages in dmesg:
>
>   platform 1ee0000.hdmi: probe deferral - supplier 1ef0000.hdmi-phy
>     not ready
>
> There's a fwnode_link being created with fw_devlink=on between hdmi
> and hdmi-phy nodes, because both nodes have 'compatible' property set.
>
> Fw_devlink code assumes that nodes that have compatible property
> set will also have a device associated with them by some driver
> eventually. This is not the case with the current sun8i-hdmi
> driver.

Not needed. fw_devlink isn't present in 4.19.

-Saravana

>
> This commit makes sun8i-hdmi-phy into a proper platform device
> and fixes the display pipeline probe on sunxi boards that use HDMI.
>
> More context: https://lkml.org/lkml/2021/5/16/203
>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> Tested-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210607085836.2827429-1-megous@megous.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c  | 31 ++++++++++++++++---
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h  |  5 ++--
>  drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 41 ++++++++++++++++++++++----
>  3 files changed, 66 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> index 5073622cbb56..ab048f9412e7 100644
> --- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> +++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
> @@ -144,7 +144,7 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
>                 goto err_disable_clk_tmds;
>         }
>
> -       ret = sun8i_hdmi_phy_probe(hdmi, phy_node);
> +       ret = sun8i_hdmi_phy_get(hdmi, phy_node);
>         of_node_put(phy_node);
>         if (ret) {
>                 dev_err(dev, "Couldn't get the HDMI PHY\n");
> @@ -179,7 +179,6 @@ static int sun8i_dw_hdmi_bind(struct device *dev, struct device *master,
>
>  cleanup_encoder:
>         drm_encoder_cleanup(encoder);
> -       sun8i_hdmi_phy_remove(hdmi);
>  err_disable_clk_tmds:
>         clk_disable_unprepare(hdmi->clk_tmds);
>  err_assert_ctrl_reset:
> @@ -194,7 +193,6 @@ static void sun8i_dw_hdmi_unbind(struct device *dev, struct device *master,
>         struct sun8i_dw_hdmi *hdmi = dev_get_drvdata(dev);
>
>         dw_hdmi_unbind(hdmi->hdmi);
> -       sun8i_hdmi_phy_remove(hdmi);
>         clk_disable_unprepare(hdmi->clk_tmds);
>         reset_control_assert(hdmi->rst_ctrl);
>  }
> @@ -230,7 +228,32 @@ static struct platform_driver sun8i_dw_hdmi_pltfm_driver = {
>                 .of_match_table = sun8i_dw_hdmi_dt_ids,
>         },
>  };
> -module_platform_driver(sun8i_dw_hdmi_pltfm_driver);
> +
> +static int __init sun8i_dw_hdmi_init(void)
> +{
> +       int ret;
> +
> +       ret = platform_driver_register(&sun8i_dw_hdmi_pltfm_driver);
> +       if (ret)
> +               return ret;
> +
> +       ret = platform_driver_register(&sun8i_hdmi_phy_driver);
> +       if (ret) {
> +               platform_driver_unregister(&sun8i_dw_hdmi_pltfm_driver);
> +               return ret;
> +       }
> +
> +       return ret;
> +}
> +
> +static void __exit sun8i_dw_hdmi_exit(void)
> +{
> +       platform_driver_unregister(&sun8i_dw_hdmi_pltfm_driver);
> +       platform_driver_unregister(&sun8i_hdmi_phy_driver);
> +}
> +
> +module_init(sun8i_dw_hdmi_init);
> +module_exit(sun8i_dw_hdmi_exit);
>
>  MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@siol.net>");
>  MODULE_DESCRIPTION("Allwinner DW HDMI bridge");
> diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
> index aadbe0a10b0c..41355bf3aca8 100644
> --- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
> +++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h
> @@ -179,14 +179,15 @@ struct sun8i_dw_hdmi {
>         struct reset_control            *rst_ctrl;
>  };
>
> +extern struct platform_driver sun8i_hdmi_phy_driver;
> +
>  static inline struct sun8i_dw_hdmi *
>  encoder_to_sun8i_dw_hdmi(struct drm_encoder *encoder)
>  {
>         return container_of(encoder, struct sun8i_dw_hdmi, encoder);
>  }
>
> -int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node);
> -void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi);
> +int sun8i_hdmi_phy_get(struct sun8i_dw_hdmi *hdmi, struct device_node *node);
>
>  void sun8i_hdmi_phy_init(struct sun8i_hdmi_phy *phy);
>  const struct dw_hdmi_phy_ops *sun8i_hdmi_phy_get_ops(void);
> diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
> index dc9b1398adb9..7e7a81f9d29a 100644
> --- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
> +++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
> @@ -5,6 +5,7 @@
>
>  #include <linux/delay.h>
>  #include <linux/of_address.h>
> +#include <linux/of_platform.h>
>
>  #include "sun8i_dw_hdmi.h"
>
> @@ -433,10 +434,30 @@ static const struct of_device_id sun8i_hdmi_phy_of_table[] = {
>         { /* sentinel */ }
>  };
>
> -int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
> +int sun8i_hdmi_phy_get(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
> +{
> +       struct platform_device *pdev = of_find_device_by_node(node);
> +       struct sun8i_hdmi_phy *phy;
> +
> +       if (!pdev)
> +               return -EPROBE_DEFER;
> +
> +       phy = platform_get_drvdata(pdev);
> +       if (!phy)
> +               return -EPROBE_DEFER;
> +
> +       hdmi->phy = phy;
> +
> +       put_device(&pdev->dev);
> +
> +       return 0;
> +}
> +
> +static int sun8i_hdmi_phy_probe(struct platform_device *pdev)
>  {
>         const struct of_device_id *match;
> -       struct device *dev = hdmi->dev;
> +       struct device *dev = &pdev->dev;
> +       struct device_node *node = dev->of_node;
>         struct sun8i_hdmi_phy *phy;
>         struct resource res;
>         void __iomem *regs;
> @@ -540,7 +561,7 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
>                 clk_prepare_enable(phy->clk_phy);
>         }
>
> -       hdmi->phy = phy;
> +       platform_set_drvdata(pdev, phy);
>
>         return 0;
>
> @@ -564,9 +585,9 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
>         return ret;
>  }
>
> -void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi)
> +static int sun8i_hdmi_phy_remove(struct platform_device *pdev)
>  {
> -       struct sun8i_hdmi_phy *phy = hdmi->phy;
> +       struct sun8i_hdmi_phy *phy = platform_get_drvdata(pdev);
>
>         clk_disable_unprepare(phy->clk_mod);
>         clk_disable_unprepare(phy->clk_bus);
> @@ -580,4 +601,14 @@ void sun8i_hdmi_phy_remove(struct sun8i_dw_hdmi *hdmi)
>         clk_put(phy->clk_pll1);
>         clk_put(phy->clk_mod);
>         clk_put(phy->clk_bus);
> +       return 0;
>  }
> +
> +struct platform_driver sun8i_hdmi_phy_driver = {
> +       .probe  = sun8i_hdmi_phy_probe,
> +       .remove = sun8i_hdmi_phy_remove,
> +       .driver = {
> +               .name = "sun8i-hdmi-phy",
> +               .of_match_table = sun8i_hdmi_phy_of_table,
> +       },
> +};
> --
> 2.30.2
>
