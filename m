Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC45E4D76E4
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 17:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiCMQg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 12:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbiCMQg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 12:36:26 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7A12CCA8
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 09:35:13 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id b188so14946704oia.13
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 09:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ob4h2d72COnkU3FY3eI+a2UFXuCW1/ScRGHi/UryDqA=;
        b=TushXGzzRAzyI9MGE9XPNO4vBoxXifNjIKjCnoUkI+mEzZl6CZhW5uEBUDRGoJGHaD
         yQBQqhTD3jqe3Itl2ih/VYfS2AVqG46q374zGDDL6gBW9JTc2T4zamHj1VeOliVF2mVe
         Mqmi1px5JxbR15ozq99jBei8hZ++gA42ZIUv22DaY3YHKN7MSH1i0dMTim51IysvPyWn
         +Gq7wMLMPYLJus5ZwQeaEpMbCZ2JUARUML+mTdMXf95/FsrZn42VmhERTaicPLLP/owq
         ciqGfh1nxr0ORhDiIRQdbTxVCt0nq6AhVdIEdvPLp0OXeiH7hklifcXG8UdDVkB7o7r7
         6HBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ob4h2d72COnkU3FY3eI+a2UFXuCW1/ScRGHi/UryDqA=;
        b=k+ziZeO9ksxdD6TKLtkE7PSuPuXva5MnDCWEg3AqQRCtVP7stCANSCvH2aFD8DA4yx
         zjhfRah+8cU8EDZ4a48selL6cjgdVkCy+gqjeeqDaTKDihVLBJPrBxhb7Gv9DSby/dZY
         BHFWpr0d3E6NdLgjHoLkB+CvFYG+sXWGyiSc/tbyDGWVciAQQ0tvG8zo+F9HzgC/hMPZ
         NuFtmP4eRTJk8v1VKqdfJ2BPT1kHuDj3y+tDc20dgzkb0yAxPYzFRDOOBhsq9w0NtDqQ
         J7rjXK11donmw8T89M6g1fIskWQqmr8yf+cZ3eOW+YvV0tjLP5jGkLx64Gcw57fWHWp3
         Klvg==
X-Gm-Message-State: AOAM530i0RCuewJTrG6g+OFoP83fLeVyWx5shplu8lXjqwp1cyEFHf4N
        1t2Qcrlfa0SY7qZYUt2gyWYQxQ==
X-Google-Smtp-Source: ABdhPJyf3k5XJ/dltTqtkT8q4cm/xQn+rQVTI2+AHnpPI0GfXenHJMCY3JJm9uRIMdQCmtTZS4KxuA==
X-Received: by 2002:a54:4e81:0:b0:2ec:ae99:e02d with SMTP id c1-20020a544e81000000b002ecae99e02dmr5435442oiy.261.1647189311060;
        Sun, 13 Mar 2022 09:35:11 -0700 (PDT)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id e3-20020a056870450300b000da5424e4b0sm5514643oao.50.2022.03.13.09.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 09:35:10 -0700 (PDT)
Date:   Sun, 13 Mar 2022 11:35:07 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Andy Gross <agross@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 11/11] rpmsg: Fix kfree() of static memory on setting
 driver_override
Message-ID: <Yi4dOxArKLNyMFZy@builder.lan>
References: <20220312132856.65163-1-krzysztof.kozlowski@canonical.com>
 <20220312132856.65163-12-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312132856.65163-12-krzysztof.kozlowski@canonical.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 12 Mar 07:28 CST 2022, Krzysztof Kozlowski wrote:

> The driver_override field from platform driver should not be initialized
> from static memory (string literal) because the core later kfree() it,
> for example when driver_override is set via sysfs.
> 
> Use dedicated helper to set driver_override properly.
> 
> Fixes: 950a7388f02b ("rpmsg: Turn name service into a stand alone driver")
> Fixes: c0cdc19f84a4 ("rpmsg: Driver for user space endpoint interface")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/rpmsg/rpmsg_core.c     |  3 ++-
>  drivers/rpmsg/rpmsg_internal.h | 13 +++++++++++--
>  drivers/rpmsg/rpmsg_ns.c       | 14 ++++++++++++--
>  include/linux/rpmsg.h          |  6 ++++--
>  4 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
> index d9e612f4f0f2..6e2bf2742973 100644
> --- a/drivers/rpmsg/rpmsg_core.c
> +++ b/drivers/rpmsg/rpmsg_core.c
> @@ -397,7 +397,8 @@ field##_store(struct device *dev, struct device_attribute *attr,	\
>  	      const char *buf, size_t sz)				\
>  {									\
>  	struct rpmsg_device *rpdev = to_rpmsg_device(dev);		\
> -	char *new, *old;						\
> +	const char *old;						\
> +	char *new;							\
>  									\
>  	new = kstrndup(buf, sz, GFP_KERNEL);				\
>  	if (!new)							\
> diff --git a/drivers/rpmsg/rpmsg_internal.h b/drivers/rpmsg/rpmsg_internal.h
> index b1245d3ed7c6..31345d6e9a7e 100644
> --- a/drivers/rpmsg/rpmsg_internal.h
> +++ b/drivers/rpmsg/rpmsg_internal.h
> @@ -92,10 +92,19 @@ int rpmsg_release_channel(struct rpmsg_device *rpdev,
>   */
>  static inline int rpmsg_chrdev_register_device(struct rpmsg_device *rpdev)
>  {
> +	int ret;
> +
>  	strcpy(rpdev->id.name, "rpmsg_chrdev");
> -	rpdev->driver_override = "rpmsg_chrdev";
> +	ret = driver_set_override(&rpdev->dev, &rpdev->driver_override,
> +				  "rpmsg_chrdev", strlen("rpmsg_chrdev"));
> +	if (ret)
> +		return ret;
> +
> +	ret = rpmsg_register_device(rpdev);
> +	if (ret)
> +		kfree(rpdev->driver_override);
>  
> -	return rpmsg_register_device(rpdev);
> +	return ret;
>  }
>  
>  #endif
> diff --git a/drivers/rpmsg/rpmsg_ns.c b/drivers/rpmsg/rpmsg_ns.c
> index 762ff1ae279f..95a51543f5ad 100644
> --- a/drivers/rpmsg/rpmsg_ns.c
> +++ b/drivers/rpmsg/rpmsg_ns.c
> @@ -20,12 +20,22 @@
>   */
>  int rpmsg_ns_register_device(struct rpmsg_device *rpdev)
>  {
> +	int ret;
> +
>  	strcpy(rpdev->id.name, "rpmsg_ns");
> -	rpdev->driver_override = "rpmsg_ns";
> +	ret = driver_set_override(&rpdev->dev, &rpdev->driver_override,
> +				  "rpmsg_ns", strlen("rpmsg_ns"));
> +	if (ret)
> +		return ret;
> +
>  	rpdev->src = RPMSG_NS_ADDR;
>  	rpdev->dst = RPMSG_NS_ADDR;
>  
> -	return rpmsg_register_device(rpdev);
> +	ret = rpmsg_register_device(rpdev);
> +	if (ret)
> +		kfree(rpdev->driver_override);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(rpmsg_ns_register_device);
>  
> diff --git a/include/linux/rpmsg.h b/include/linux/rpmsg.h
> index 02fa9116cd60..20c8cd1cde21 100644
> --- a/include/linux/rpmsg.h
> +++ b/include/linux/rpmsg.h
> @@ -41,7 +41,9 @@ struct rpmsg_channel_info {
>   * rpmsg_device - device that belong to the rpmsg bus
>   * @dev: the device struct
>   * @id: device id (used to match between rpmsg drivers and devices)
> - * @driver_override: driver name to force a match
> + * @driver_override: driver name to force a match; do not set directly,
> + *                   because core frees it; use driver_set_override() to
> + *                   set or clear it.
>   * @src: local address
>   * @dst: destination address
>   * @ept: the rpmsg endpoint of this channel
> @@ -51,7 +53,7 @@ struct rpmsg_channel_info {
>  struct rpmsg_device {
>  	struct device dev;
>  	struct rpmsg_device_id id;
> -	char *driver_override;
> +	const char *driver_override;
>  	u32 src;
>  	u32 dst;
>  	struct rpmsg_endpoint *ept;
> -- 
> 2.32.0
> 
