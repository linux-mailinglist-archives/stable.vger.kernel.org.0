Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4F461825D
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiKCPTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiKCPTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:19:20 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCFF5FA2
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 08:19:19 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221103151918euoutp0153ea9dc6cf3687071c22fff07a8caf4d~kHDDd4qQ53071530715euoutp01h
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 15:19:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221103151918euoutp0153ea9dc6cf3687071c22fff07a8caf4d~kHDDd4qQ53071530715euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667488758;
        bh=tXNppWO/p/BXEPilMY5O7F1D2ssWHgvMCPECI//TJQQ=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=XU02lTQf6C7B7TD/mhxK7sZG+0m2NiRRSVl9u6+IBcB/MCBrnHFuf0lWpmuVmWK4Z
         kcLdhDarxAr3T/VdQV0qDjjxF+iGWTYZdHpqQVPIWeVGTpZmG+KnhqIbuZuwJUNnux
         GaYKrXlkAa7r2bKYHApYqTFdLJzZuxMIQ8etiX/c=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221103151917eucas1p29e4d7ade0f1a97984fff2d4b5e7f07b5~kHDDM7IXQ1167711677eucas1p2_;
        Thu,  3 Nov 2022 15:19:17 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 6A.22.19378.5FBD3636; Thu,  3
        Nov 2022 15:19:17 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221103151917eucas1p2b1aece847b31052e782360f07ccec143~kHDCpzUFi0389003890eucas1p2e;
        Thu,  3 Nov 2022 15:19:17 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221103151917eusmtrp22ed1cc97e1db9e636b85b5034b530405~kHDCo7R_A2941329413eusmtrp2d;
        Thu,  3 Nov 2022 15:19:17 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-14-6363dbf580b3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id BC.78.10862.5FBD3636; Thu,  3
        Nov 2022 15:19:17 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221103151916eusmtip21a7c9778694c6d62b84007e299c42887~kHDCMZDQf2407724077eusmtip2F;
        Thu,  3 Nov 2022 15:19:16 +0000 (GMT)
Message-ID: <e870459c-70e8-b4f3-ef7e-4dde0e952b3d@samsung.com>
Date:   Thu, 3 Nov 2022 16:19:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
        Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH] Revert "usb: dwc3: disable USB core PHY management"
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>, stable@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20221103144648.14197-1-johan+linaro@kernel.org>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djPc7pfbycnG3xZYmrRvHg9m8WKSovL
        u+awWSxa1spssWDjI0aLzeva2S1WLTjA7sDusfj7PWaPTas62Tz2z13D7rFl/2dGj8+b5AJY
        o7hsUlJzMstSi/TtErgyDh9YxF6wUrjicMN81gbGm/xdjJwcEgImEi+XPGPsYuTiEBJYwSix
        +NRmFgjnC6PExsnP2CGcz4wSJxt/scK0rLzdA9WynFHiftM9qKqPjBLLtq5nAaniFbCTuLH9
        NROIzSKgIjFh2yl2iLigxMmZT8BqRAVSJHZ3bwOzhQU8JOa+nwVWzywgLnHryXwmkKEiAu2M
        EpNv72OESJRKvGp9wAZiswkYSnS97QKzOQVsJXZtu8kCUSMvsf3tHGaQZgmBBxwSnxuXsUPc
        7SKxYOsJFghbWOLV8S1QcRmJ/zshtkmAbFvw+z6UM4FRouH5LUaIKmuJO+d+Aa3jAFqhKbF+
        lz5E2FHi75kfzCBhCQE+iRtvBSGO4JOYtG06VJhXoqNNCKJaTWLW8XVwaw9euMQ8gVFpFlK4
        zELy/ywk78xC2LuAkWUVo3hqaXFuemqxcV5quV5xYm5xaV66XnJ+7iZGYBI6/e/41x2MK159
        1DvEyMTBeIhRgoNZSYT307bkZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8bDO0koUE0hNLUrNT
        UwtSi2CyTBycUg1MDpdml65nnnMw48f+K0xepYtfLG3sqVhw0sdWfbvBLP1Dcv1RBgG3hJa+
        F11gtz910fStkxgssk/evVVmXWj77F3QnBeN03ycD91U4FFm0ujt+jC1pePDrYwtnbsTOR8t
        ZvCsy56weJU4z+M17POkdFo5xWQsQ1Rv65b+cPu54OQz0d8fWo7tkM03aRWU+HnSrUJGW/x5
        yQ1m4YNXLwTLRv81/rZc58XSHU/+Ozw65d7OqLI0p9V1vWleVtjargVsDU8MvJ/k7QjkmPRm
        lvD9a88t2l82Ok7MdE/3f3Ygp/f50853Lt8vLKzdr+9n5e/w3UPO+aHtr++iYok6T99x/5KJ
        UeGb39554HrpHLVEJZbijERDLeai4kQAYnLV0bEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xe7pfbycnG6w8y2/RvHg9m8WKSovL
        u+awWSxa1spssWDjI0aLzeva2S1WLTjA7sDusfj7PWaPTas62Tz2z13D7rFl/2dGj8+b5AJY
        o/RsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQyDh9Y
        xF6wUrjicMN81gbGm/xdjJwcEgImEitv9zB2MXJxCAksZZQ4cK+DDSIhI3FyWgMrhC0s8eda
        FxtE0XtGiTfP7oEleAXsJG5sf80EYrMIqEhM2HaKHSIuKHFy5hOWLkYODlGBFIlv5+pAwsIC
        HhJz388CK2cWEJe49WQ+E8hMEYFORol1t+ewQiRKJR6dPsAMsWwCo8Tih99YQBJsAoYSXW+7
        wK7jFLCV2LXtJgtEg5lE19YuRghbXmL72znMExiFZiG5YxaShbOQtMxC0rKAkWUVo0hqaXFu
        em6xkV5xYm5xaV66XnJ+7iZGYMxtO/Zzyw7Gla8+6h1iZOJgPMQowcGsJML7aVtyshBvSmJl
        VWpRfnxRaU5q8SFGU2BgTGSWEk3OB0Z9Xkm8oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2
        ampBahFMHxMHp1QDk7qZx9PNz47OWX9H5Fnz3aPrXa77ZYtE6CavLsnJ9J/dsCsr9NCW7vii
        mTJ3dcLvyvyUvHRewOXckuwTLXxJZYu0pzSc5S77c0VorpXL8juLn8+exutqWnN/pt+70req
        G5mlS/z++QtvmZ9v8/3AvntHtl/uObh3SprJa+mJ2nOsjq+c8FpU1EIuysp23s0+Bdbe0uv5
        EXEWou58Xy78vr/B4sxvZtMAL8cJbCbcy/z1F84Rm3j/3g7HDyknfqlosgt/vVWd/r/ZpD2C
        /y3fmXv8/oybZO6+bC+foT0lQG4p0wsbwzOhZ29aNU77xbSeY+H5lHczIhVYHsxclXV9L+PO
        +g2rcm5OdmF41cJ8O1uJpTgj0VCLuag4EQBdm/N3QgMAAA==
X-CMS-MailID: 20221103151917eucas1p2b1aece847b31052e782360f07ccec143
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221103144724eucas1p2a1b7c96e013cb32ae24f4bb8b353771d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221103144724eucas1p2a1b7c96e013cb32ae24f4bb8b353771d
References: <CGME20221103144724eucas1p2a1b7c96e013cb32ae24f4bb8b353771d@eucas1p2.samsung.com>
        <20221103144648.14197-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03.11.2022 15:46, Johan Hovold wrote:
> This reverts commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea.
>
> The offending commit disabled the USB core PHY management as the dwc3
> already manages the PHYs in question.
>
> Unfortunately some platforms have started relying on having USB core
> also controlling the PHY and this is specifically currently needed on
> some Exynos platforms for PHY calibration or connected device may fail
> to enumerate.
>
> The PHY calibration was previously handled in the dwc3 driver, but to
> work around some issues related to how the dwc3 driver interacts with
> xhci (e.g. using multiple drivers) this was moved to USB core by commits
> 34c7ed72f4f0 ("usb: core: phy: add support for PHY calibration") and
> a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls").
>
> The same PHY obviously should not be controlled from two different
> places, which for example do no agree on the PHY mode or power state
> during suspend, but as the offending patch was backported to stable,
> let's revert it for now.
>
> Reported-by: Stefan Agner <stefan@agner.ch>
> Link: https://lore.kernel.org/lkml/808bdba846bb60456adf10a3016911ee@agner.ch/
> Fixes: 6000b8d900cd ("usb: dwc3: disable USB core PHY management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   drivers/usb/dwc3/host.c | 10 ----------
>   1 file changed, 10 deletions(-)
>
> diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> index a7154fe8206d..f6f13e7f1ba1 100644
> --- a/drivers/usb/dwc3/host.c
> +++ b/drivers/usb/dwc3/host.c
> @@ -11,13 +11,8 @@
>   #include <linux/of.h>
>   #include <linux/platform_device.h>
>   
> -#include "../host/xhci-plat.h"
>   #include "core.h"
>   
> -static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
> -	.quirks = XHCI_SKIP_PHY_INIT,
> -};
> -
>   static void dwc3_host_fill_xhci_irq_res(struct dwc3 *dwc,
>   					int irq, char *name)
>   {
> @@ -97,11 +92,6 @@ int dwc3_host_init(struct dwc3 *dwc)
>   		goto err;
>   	}
>   
> -	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
> -					sizeof(dwc3_xhci_plat_priv));
> -	if (ret)
> -		goto err;
> -
>   	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
>   
>   	if (dwc->usb3_lpm_capable)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

