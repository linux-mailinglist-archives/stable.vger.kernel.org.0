Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C53660E8D8
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 21:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbiJZTPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 15:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiJZTOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 15:14:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECDB26485
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 12:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666811610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TcwkxX7f9akzTpXldeCvOVlbHPDFS3e55cTn/Ew1HBQ=;
        b=UHQBqFnXOVg/lWQiIPeFJvvADP8bq12gd/5jHAnfbMBxqOyTLS6VvzF/XcYsN0XGcAh8XP
        2vUKQqQn0vxNEQ57RSd/L22oX6238jExQ2r32xAUiGeOPCVnsfIwHpph+rNaBWobpL/nwy
        dVeG4g6cWCQQej6vA55QfBqHwzjvjLc=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-440-8rLmcVVwOfe9uMtkVrR9sg-1; Wed, 26 Oct 2022 15:13:29 -0400
X-MC-Unique: 8rLmcVVwOfe9uMtkVrR9sg-1
Received: by mail-oo1-f69.google.com with SMTP id y3-20020a4a86c3000000b004761b39fee7so7153329ooh.1
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 12:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcwkxX7f9akzTpXldeCvOVlbHPDFS3e55cTn/Ew1HBQ=;
        b=zcZxkHROTZPTdHTBNg+hlLypLshDRMG8bD/Lp7I5TFLakE9aqTIb3ZYWzvaaKg9kbf
         EQIZcmwSJVnevLldY9QGhD5VJVq41f3T39102kCF+/ZHJ0WcOMNKaU6dJHnY2utkv8mi
         gh66in9Oiwc/7NnIGZfgFNkVwJRhxhU/mNoIw3X4vF5CDdKmJvDgqiY0FPocFUEAcit5
         3r6q7SEpzDmHwLNl1Bju6QhaIc1q/MHrczX3O2z0RaIZO+4JIiKrw2xHZuaLHrj4/riK
         r9FNoDFxJYWkDQYkItCeGWjK0HNSNlEsMPqolIfIr782O9StjZCyzmuC0GpqNdiR1WE8
         hQ7g==
X-Gm-Message-State: ACrzQf3P4rcUJBLXm+iSr9voiv/6xJMKnG29ApYRZiAadKueLM4W3CqZ
        OpLTsJaF0xa1N8vj6dTkhpk0KhwisJu0Nv9ACMjzbd4gfHXtaRfVDF2DICE+AM+LoEY6myaa30g
        WMRZwXBdlmDHZ8hsQ
X-Received: by 2002:a05:6808:1802:b0:354:b406:540b with SMTP id bh2-20020a056808180200b00354b406540bmr2692771oib.256.1666811607653;
        Wed, 26 Oct 2022 12:13:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM51GHRU3SteyubonbaqiEhWoUUnM42aduIw9CPdsyhnz0+5pKAXp58pAeWEh0n/myr6t/6Tvw==
X-Received: by 2002:a05:6808:1802:b0:354:b406:540b with SMTP id bh2-20020a056808180200b00354b406540bmr2692756oib.256.1666811607376;
        Wed, 26 Oct 2022 12:13:27 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id cc14-20020a05683061ce00b00661948e6119sm2568306otb.47.2022.10.26.12.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 12:13:26 -0700 (PDT)
Date:   Wed, 26 Oct 2022 14:13:24 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Vinod Koul <vkoul@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] phy: qcom-qmp-combo: fix NULL-deref on runtime resume
Message-ID: <20221026191324.ehk3zarmcboq32zn@halaney-x13s>
References: <20221026162116.26462-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026162116.26462-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 06:21:16PM +0200, Johan Hovold wrote:
> Commit fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate
> PCS_USB region") started treating the PCS_USB registers as potentially
> separate from the PCS registers but used the wrong base when no PCS_USB
> offset has been provided.
> 
> Fix the PCS_USB base used at runtime resume to prevent dereferencing a
> NULL pointer on platforms that do not provide a PCS_USB offset (e.g.
> SC7180).
> 
> Fixes: fc64623637da ("phy: qcom-qmp-combo,usb: add support for separate PCS_USB region")
> Cc: stable@vger.kernel.org	# 5.20
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

For what it is worth, I double checked and phy-qcom-qmp-usb.c has this
done properly already.

Thanks,
Andrew

> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
> index f6328434c61e..ad6a0fd7ba8e 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
> @@ -2144,7 +2144,7 @@ static void qmp_combo_enable_autonomous_mode(struct qmp_phy *qphy)
>  static void qmp_combo_disable_autonomous_mode(struct qmp_phy *qphy)
>  {
>  	const struct qmp_phy_cfg *cfg = qphy->cfg;
> -	void __iomem *pcs_usb = qphy->pcs_usb ?: qphy->pcs_usb;
> +	void __iomem *pcs_usb = qphy->pcs_usb ?: qphy->pcs;
>  	void __iomem *pcs_misc = qphy->pcs_misc;
>  
>  	/* Disable i/o clamp_n on resume for normal mode */
> -- 
> 2.37.3
> 

