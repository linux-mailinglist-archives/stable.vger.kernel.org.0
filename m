Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C182E601311
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiJQP5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJQP5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49F16D860
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 08:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666022222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DQ9BSUfDKoJUJ+YyUq4v3/jXsEiShgxTQU4ItDdSgGE=;
        b=edb92rZ0c7o04VKukdiLfnFNszI+HiuPYRu+tnpI1gyZQ/Omj7s7HzbAP4vJIR2ishCubH
        OT8XRl6o6d2BUWB3uROGuS0OePKKtZ40MMqpgyKhD7uF9WTJFS+GcwZlZubquxd6vXflnC
        nX/sd6c+yvxOcqjZRNC8N6NaepYvqOs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-599-Eg_D1dQUPrqmS8lZ_B8CdA-1; Mon, 17 Oct 2022 11:57:00 -0400
X-MC-Unique: Eg_D1dQUPrqmS8lZ_B8CdA-1
Received: by mail-qk1-f199.google.com with SMTP id j13-20020a05620a410d00b006e08208eb31so9874043qko.3
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 08:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQ9BSUfDKoJUJ+YyUq4v3/jXsEiShgxTQU4ItDdSgGE=;
        b=kolRbSd4crcttFCMqwqK4e9ynHeHCH8SK1NJzKbaPbT7EVGV/najI1NCNYUw6E3lrZ
         LFvE/9fZoEfkkFoy/yz/fkP0HNjlzD3zlA9H5q7itdFZhCV64T/5Jo/CcKb1IRtTbokE
         +a1WRvpZE6DUrjDW/hCPa5+IKj+hyz03MGqiXe2JUB1x103TS6ER2hsy0Ha/7KNRAjrE
         FEv3hF0bqe63V/baUQ5owuaJNuFVc/PPaEclv/LDJWhFe6HmDE/Y72MOxzc4V8cMrsig
         EzYhSSU/dTAwrzmdhuDosUdlLsoAQznyWlT7HwvJv60P06FzEUfZOa+K2C9aR2/Jb0F2
         CoHQ==
X-Gm-Message-State: ACrzQf0Pn8rXZNJFRsVmnkHxFOkDHY/sNd0tGfYmn5b2VSvulul/+k12
        PHOLTLqOsWxqUnprFUGt/+FxoGmKOtjLzyDjqIc4U4yeG3pZBjAvu1iSlyrDacvKIAgQWDjGzWU
        UfLDUUxfRM2pKAIcV
X-Received: by 2002:a05:6214:2aaf:b0:4b1:d684:f724 with SMTP id js15-20020a0562142aaf00b004b1d684f724mr9133426qvb.97.1666022219842;
        Mon, 17 Oct 2022 08:56:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4MXOXDAWK4nrAqUigIaANtf8VLQnL+iRuWPSVrKyXzwp36CNxsgKkJX8PxMceOAIliBF741A==
X-Received: by 2002:a05:6214:2aaf:b0:4b1:d684:f724 with SMTP id js15-20020a0562142aaf00b004b1d684f724mr9133411qvb.97.1666022219641;
        Mon, 17 Oct 2022 08:56:59 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id s9-20020a05620a0bc900b006cfc4744589sm57440qki.128.2022.10.17.08.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 08:56:59 -0700 (PDT)
Date:   Mon, 17 Oct 2022 08:56:57 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     Vinod Koul <vkoul@kernel.org>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        dmaengine@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: idxd: Do not enable user type Work Queue
 without Shared Virtual Addressing
Message-ID: <20221017155657.kpwvx5jicitoxbzp@cantor>
References: <20221014222541.3912195-1-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014222541.3912195-1-fenghua.yu@intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 03:25:41PM -0700, Fenghua Yu wrote:
> When the idxd_user_drv driver is bound to a Work Queue (WQ) device
> without IOMMU or with IOMMU Passthrough without Shared Virtual
> Addressing (SVA), the application gains direct access to physical
> memory via the device by programming physical address to a submitted
> descriptor. This allows direct userspace read and write access to
> arbitrary physical memory. This is inconsistent with the security
> goals of a good kernel API.
> 
> Unlike vfio_pci driver, the IDXD char device driver does not provide any
> ways to pin user pages and translate the address from user VA to IOVA or
> PA without IOMMU SVA. Therefore the application has no way to instruct the
> device to perform DMA function. This makes the char device not usable for
> normal application usage.
> 
> Since user type WQ without SVA cannot be used for normal application usage
> and presents the security issue, bind idxd_user_drv driver and enable user
> type WQ only when SVA is enabled (i.e. user PASID is enabled).
> 
> Fixes: 448c3de8ac83 ("dmaengine: idxd: create user driver for wq 'device'")
> Cc: stable@vger.kernel.org
> Suggested-by: Arjan Van De Ven <arjan.van.de.ven@intel.com>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

> ---
> v2:
> - Update changlog per Dave Hansen's comments
> 
>  drivers/dma/idxd/cdev.c   | 18 ++++++++++++++++++
>  include/uapi/linux/idxd.h |  1 +
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
> index c2808fd081d6..a9b96b18772f 100644
> --- a/drivers/dma/idxd/cdev.c
> +++ b/drivers/dma/idxd/cdev.c
> @@ -312,6 +312,24 @@ static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
>  	if (idxd->state != IDXD_DEV_ENABLED)
>  		return -ENXIO;
>  
> +	/*
> +	 * User type WQ is enabled only when SVA is enabled for two reasons:
> +	 *   - If no IOMMU or IOMMU Passthrough without SVA, userspace
> +	 *     can directly access physical address through the WQ.
> +	 *   - The IDXD cdev driver does not provide any ways to pin
> +	 *     user pages and translate the address from user VA to IOVA or
> +	 *     PA without IOMMU SVA. Therefore the application has no way
> +	 *     to instruct the device to perform DMA function. This makes
> +	 *     the cdev not usable for normal application usage.
> +	 */
> +	if (!device_user_pasid_enabled(idxd)) {
> +		idxd->cmd_status = IDXD_SCMD_WQ_USER_NO_IOMMU;
> +		dev_dbg(&idxd->pdev->dev,
> +			"User type WQ cannot be enabled without SVA.\n");
> +
> +		return -EOPNOTSUPP;
> +	}
> +
>  	mutex_lock(&wq->wq_lock);
>  	wq->type = IDXD_WQT_USER;
>  	rc = drv_enable_wq(wq);
> diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
> index 095299c75828..2b9e7feba3f3 100644
> --- a/include/uapi/linux/idxd.h
> +++ b/include/uapi/linux/idxd.h
> @@ -29,6 +29,7 @@ enum idxd_scmd_stat {
>  	IDXD_SCMD_WQ_NO_SIZE = 0x800e0000,
>  	IDXD_SCMD_WQ_NO_PRIV = 0x800f0000,
>  	IDXD_SCMD_WQ_IRQ_ERR = 0x80100000,
> +	IDXD_SCMD_WQ_USER_NO_IOMMU = 0x80110000,
>  };
>  
>  #define IDXD_SCMD_SOFTERR_MASK	0x80000000
> -- 
> 2.32.0
> 

