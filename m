Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3412E5EEC43
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 05:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiI2DBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 23:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiI2DB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 23:01:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7783EDD24;
        Wed, 28 Sep 2022 20:01:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 29so222374edv.7;
        Wed, 28 Sep 2022 20:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=GYfljbXoE6Tk4WZKsjAzhovTCQfBmAj2N2aZXhkbCOc=;
        b=cDVzgBE+7b+T9K6lwCnJryYRotZ0kEAXmaxodCvYUhoOlhxBVrygrNARmUPoTk30j8
         skZwpjuvKmY5QBZ4wRW3xYzOb/ogPPhGlKuERho3cYP16XG7M1kGNgnTtdKDU0Ku0gKo
         w28fZnEDK4HDhJSGlMrwnpuMHmGzvGV567kWhUO1D0KPqg3aNvpWMGzJWd8vYVaf4ooS
         YqdnXFWClbMTpkD8b1WvoQ3MHf/sN9z7zVTAWbbeJj70wCeNnH3iww3mrgsflNDWBSr0
         Il63nPCBQDu1aCbAuKnBZGmuoB8ZBEgKSB7S89fos5gPVLDxqceZkjJXfspV+6f8d30d
         beUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GYfljbXoE6Tk4WZKsjAzhovTCQfBmAj2N2aZXhkbCOc=;
        b=m32FPiGF8BZu4tb53KNShVsBLqs0ZZkHWDzLeojF5SH9U8WxoQs7CRKjt9vdUudZhM
         jqb6bdKvQx6EdxgWXhn/V4fRfaZ7+SPs9pOGe2wNuSWeUCQHTs9ePgYeP4d99TJ11tfI
         OSQIpa3Zk/SYPFrKXHkF4OrK9g9zQfdEPsDf2DhrstDnVWaf19oUCUXAwTVW2zCcSUlS
         LNUPpt5IhwDy00eFnbr3OL2AZcUXuQBzy/CY4XrE3H+SFL381sTfkCBXXHQ6/LqZ5B2D
         FIHdWlQvr/R4UuIs195uR2zcSqTQUrKKw6cGxKJn7sgpiLsjHEJ7Ih8N9Mcg3AzTBww7
         vrVQ==
X-Gm-Message-State: ACrzQf3FV1ruMJTMhswAmEj3kco2dPyRPKaCB3jxs4lXehXndCIo9s85
        vszfh4UfU/FSzY5vWb+tatZ8JHXNFvD7zqJrbme1zpW1
X-Google-Smtp-Source: AMsMyM4M03IhQgUdmtIcmeJ77g+ecokiTDw97lYrFao7rCRa6yA2JJ6REoptWh6fOCR6Q1+PZEY/0W5qlKCEarOlYnY=
X-Received: by 2002:a05:6402:909:b0:435:a8b:5232 with SMTP id
 g9-20020a056402090900b004350a8b5232mr1109413edz.240.1664420483239; Wed, 28
 Sep 2022 20:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com> <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 28 Sep 2022 20:01:11 -0700
Message-ID: <CAHQ1cqG5RmqnOuTch02y=pE-XK5dZABTN+FNaF2LOg5oJx=PPQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
To:     Sven Peter <sven@svenpeter.dev>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>, Ferry Toth <fntoth@gmail.com>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 8:53 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> This reverts commit 0f01017191384e3962fa31520a9fd9846c3d352f.
>
> As pointed out by Ferry this breaks Dual Role support on
> Intel Merrifield platforms.
>
> Fixes: 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
> Reported-by: Ferry Toth <fntoth@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Tested-by: Ferry Toth <fntoth@gmail.com> # for Merrifield

Sven can you check that this also fixes the regression of your fix?

> ---
>  drivers/usb/dwc3/core.c | 55 +----------------------------------------
>  drivers/usb/dwc3/drd.c  | 50 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index c2b463469d51..219d797e2230 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -23,7 +23,6 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/of.h>
> -#include <linux/of_graph.h>
>  #include <linux/acpi.h>
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/reset.h>
> @@ -86,7 +85,7 @@ static int dwc3_get_dr_mode(struct dwc3 *dwc)
>                  * mode. If the controller supports DRD but the dr_mode is not
>                  * specified or set to OTG, then set the mode to peripheral.
>                  */
> -               if (mode == USB_DR_MODE_OTG && !dwc->edev &&
> +               if (mode == USB_DR_MODE_OTG &&
>                     (!IS_ENABLED(CONFIG_USB_ROLE_SWITCH) ||
>                      !device_property_read_bool(dwc->dev, "usb-role-switch")) &&
>                     !DWC3_VER_IS_PRIOR(DWC3, 330A))
> @@ -1668,51 +1667,6 @@ static void dwc3_check_params(struct dwc3 *dwc)
>         }
>  }
>
> -static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
> -{
> -       struct device *dev = dwc->dev;
> -       struct device_node *np_phy;
> -       struct extcon_dev *edev = NULL;
> -       const char *name;
> -
> -       if (device_property_read_bool(dev, "extcon"))
> -               return extcon_get_edev_by_phandle(dev, 0);
> -
> -       /*
> -        * Device tree platforms should get extcon via phandle.
> -        * On ACPI platforms, we get the name from a device property.
> -        * This device property is for kernel internal use only and
> -        * is expected to be set by the glue code.
> -        */
> -       if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
> -               edev = extcon_get_extcon_dev(name);
> -               if (!edev)
> -                       return ERR_PTR(-EPROBE_DEFER);
> -
> -               return edev;
> -       }
> -
> -       /*
> -        * Try to get an extcon device from the USB PHY controller's "port"
> -        * node. Check if it has the "port" node first, to avoid printing the
> -        * error message from underlying code, as it's a valid case: extcon
> -        * device (and "port" node) may be missing in case of "usb-role-switch"
> -        * or OTG mode.
> -        */
> -       np_phy = of_parse_phandle(dev->of_node, "phys", 0);
> -       if (of_graph_is_present(np_phy)) {
> -               struct device_node *np_conn;
> -
> -               np_conn = of_graph_get_remote_node(np_phy, -1, -1);
> -               if (np_conn)
> -                       edev = extcon_find_edev_by_node(np_conn);
> -               of_node_put(np_conn);
> -       }
> -       of_node_put(np_phy);
> -
> -       return edev;
> -}
> -
>  static int dwc3_probe(struct platform_device *pdev)
>  {
>         struct device           *dev = &pdev->dev;
> @@ -1849,13 +1803,6 @@ static int dwc3_probe(struct platform_device *pdev)
>                 goto err2;
>         }
>
> -       dwc->edev = dwc3_get_extcon(dwc);
> -       if (IS_ERR(dwc->edev)) {
> -               ret = PTR_ERR(dwc->edev);
> -               dev_err_probe(dwc->dev, ret, "failed to get extcon\n");
> -               goto err3;
> -       }
> -
>         ret = dwc3_get_dr_mode(dwc);
>         if (ret)
>                 goto err3;
> diff --git a/drivers/usb/dwc3/drd.c b/drivers/usb/dwc3/drd.c
> index 039bf241769a..8cad9e7d3368 100644
> --- a/drivers/usb/dwc3/drd.c
> +++ b/drivers/usb/dwc3/drd.c
> @@ -8,6 +8,7 @@
>   */
>
>  #include <linux/extcon.h>
> +#include <linux/of_graph.h>
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/property.h>
> @@ -438,6 +439,51 @@ static int dwc3_drd_notifier(struct notifier_block *nb,
>         return NOTIFY_DONE;
>  }
>
> +static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
> +{
> +       struct device *dev = dwc->dev;
> +       struct device_node *np_phy;
> +       struct extcon_dev *edev = NULL;
> +       const char *name;
> +
> +       if (device_property_read_bool(dev, "extcon"))
> +               return extcon_get_edev_by_phandle(dev, 0);
> +
> +       /*
> +        * Device tree platforms should get extcon via phandle.
> +        * On ACPI platforms, we get the name from a device property.
> +        * This device property is for kernel internal use only and
> +        * is expected to be set by the glue code.
> +        */
> +       if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
> +               edev = extcon_get_extcon_dev(name);
> +               if (!edev)
> +                       return ERR_PTR(-EPROBE_DEFER);
> +
> +               return edev;
> +       }
> +
> +       /*
> +        * Try to get an extcon device from the USB PHY controller's "port"
> +        * node. Check if it has the "port" node first, to avoid printing the
> +        * error message from underlying code, as it's a valid case: extcon
> +        * device (and "port" node) may be missing in case of "usb-role-switch"
> +        * or OTG mode.
> +        */
> +       np_phy = of_parse_phandle(dev->of_node, "phys", 0);
> +       if (of_graph_is_present(np_phy)) {
> +               struct device_node *np_conn;
> +
> +               np_conn = of_graph_get_remote_node(np_phy, -1, -1);
> +               if (np_conn)
> +                       edev = extcon_find_edev_by_node(np_conn);
> +               of_node_put(np_conn);
> +       }
> +       of_node_put(np_phy);
> +
> +       return edev;
> +}
> +
>  #if IS_ENABLED(CONFIG_USB_ROLE_SWITCH)
>  #define ROLE_SWITCH 1
>  static int dwc3_usb_role_switch_set(struct usb_role_switch *sw,
> @@ -542,6 +588,10 @@ int dwc3_drd_init(struct dwc3 *dwc)
>             device_property_read_bool(dwc->dev, "usb-role-switch"))
>                 return dwc3_setup_role_switch(dwc);
>
> +       dwc->edev = dwc3_get_extcon(dwc);
> +       if (IS_ERR(dwc->edev))
> +               return PTR_ERR(dwc->edev);
> +
>         if (dwc->edev) {
>                 dwc->edev_nb.notifier_call = dwc3_drd_notifier;
>                 ret = extcon_register_notifier(dwc->edev, EXTCON_USB_HOST,
> --
> 2.35.1
>
