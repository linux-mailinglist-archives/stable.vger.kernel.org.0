Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176624F0622
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 22:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244198AbiDBUXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 16:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiDBUXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 16:23:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 020C243ED2
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 13:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648930866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pfcZsik3I2SIE8qQILPMN8Zc1KzLk+Vrska+Chldl+0=;
        b=bC1paczNnIvCyK3jWlG9wDHM1f2aLDrMh60puNi3LyRVEZJb34X3pT/PZFRubnm80C0rT+
        Msl2j9kvrJGgtieyogAZaM4edECBlr18YOtp6EGIa2hqis3kuFGBKn8qJJc8r8g9CAQ7be
        Qi5+p+nD+LrKvwmUb5qfjYpj0RYWaqU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-YtqFW0USNR2JVHTF3LHTDw-1; Sat, 02 Apr 2022 16:21:05 -0400
X-MC-Unique: YtqFW0USNR2JVHTF3LHTDw-1
Received: by mail-wr1-f70.google.com with SMTP id i5-20020adfaac5000000b00206067b1a74so297684wrc.21
        for <stable@vger.kernel.org>; Sat, 02 Apr 2022 13:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pfcZsik3I2SIE8qQILPMN8Zc1KzLk+Vrska+Chldl+0=;
        b=2pr1k5caAKEwMT+6UFzu5Cx6qk5Ov4OQvxMgiOmPfO6e2jarBUpyWNTUtdQV1OSsws
         grFiXE/DRxAWKBQZyJ2pIZlP1e13tvnE6S/uRdVvYyIuI9+9d3LllFYwuJ/8rLaFMQfK
         VcztEOwf0HfQE+Tc/JE4myd4SODC6Ox8ojevxaLL0iZmMzIOw6rrGUA00hPiq+M558bZ
         rONHoW41Qci7Yevi9f0s2D2WBDtBs+XElBO5PaJvKh9NTJnnpYCxOegJTivl1rieHjcb
         JXl4bHtodPdLIDMi5X09nVrnBpojLKn2xJeUfYBmPLhIqPGerBSz4S6HE2xmy1dIQTq9
         SFJg==
X-Gm-Message-State: AOAM530UcOF2Fwno4+1X9xSDlAMV0eHpMGelM0TxE8U7BTDYlckPowRg
        APZwffUbKpd2G4y+jVT6x8IjczBJOfEpWksFFgNytoxXzBosPe2JAl+vDy5CGGbPMPmjxS5KN4x
        fcOBsFYHBws7Xi8Em
X-Received: by 2002:adf:e4c1:0:b0:205:8b74:8dee with SMTP id v1-20020adfe4c1000000b002058b748deemr12150285wrm.225.1648930864410;
        Sat, 02 Apr 2022 13:21:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7w2Xr/S73KlMNvxpZCgXcPZ5zanWwcC+dAaKhNC/sNKYVMZVi4DmovQxn8ADvEYQjpm7w2w==
X-Received: by 2002:adf:e4c1:0:b0:205:8b74:8dee with SMTP id v1-20020adfe4c1000000b002058b748deemr12150271wrm.225.1648930864165;
        Sat, 02 Apr 2022 13:21:04 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:5e14:21b4:9fd8:a48d:eb89])
        by smtp.gmail.com with ESMTPSA id g1-20020a1c4e01000000b003899c8053e1sm6536481wmh.41.2022.04.02.13.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 13:21:03 -0700 (PDT)
Date:   Sat, 2 Apr 2022 16:20:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, rdunlap@infradead.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: Patch "virtio_blk: eliminate anonymous module_init &
 module_exit" has been added to the 5.17-stable tree
Message-ID: <20220402161936-mutt-send-email-mst@kernel.org>
References: <20220402130329.2055072-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402130329.2055072-1-sashal@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 09:03:29AM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     virtio_blk: eliminate anonymous module_init & module_exit
> 
> to the 5.17-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      virtio_blk-eliminate-anonymous-module_init-module_ex.patch
> and it can be found in the queue-5.17 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 

I don't see how this patch qualifies for stable.
Yes it's probably harmless but you never know
what kind of script might be parsing e.g. System.map
and changing that in the middle of stable seems
like a bad idea to me.


> 
> commit 0c0434a33667dbfedceb984ade0e7e3faeb4bfae
> Author: Randy Dunlap <rdunlap@infradead.org>
> Date:   Wed Mar 16 12:20:02 2022 -0700
> 
>     virtio_blk: eliminate anonymous module_init & module_exit
>     
>     [ Upstream commit bcfe9b6cbb4438b8c1cc4bd475221652c8f9301b ]
>     
>     Eliminate anonymous module_init() and module_exit(), which can lead to
>     confusion or ambiguity when reading System.map, crashes/oops/bugs,
>     or an initcall_debug log.
>     
>     Give each of these init and exit functions unique driver-specific
>     names to eliminate the anonymous names.
>     
>     Example 1: (System.map)
>      ffffffff832fc78c t init
>      ffffffff832fc79e t init
>      ffffffff832fc8f8 t init
>     
>     Example 2: (initcall_debug log)
>      calling  init+0x0/0x12 @ 1
>      initcall init+0x0/0x12 returned 0 after 15 usecs
>      calling  init+0x0/0x60 @ 1
>      initcall init+0x0/0x60 returned 0 after 2 usecs
>      calling  init+0x0/0x9a @ 1
>      initcall init+0x0/0x9a returned 0 after 74 usecs
>     
>     Fixes: e467cde23818 ("Block driver using virtio.")
>     Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>     Cc: "Michael S. Tsirkin" <mst@redhat.com>
>     Cc: Jason Wang <jasowang@redhat.com>
>     Cc: Paolo Bonzini <pbonzini@redhat.com>
>     Cc: Stefan Hajnoczi <stefanha@redhat.com>
>     Cc: virtualization@lists.linux-foundation.org
>     Cc: Jens Axboe <axboe@kernel.dk>
>     Cc: linux-block@vger.kernel.org
>     Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>     Acked-by: Jason Wang <jasowang@redhat.com>
>     Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>     Link: https://lore.kernel.org/r/20220316192010.19001-2-rdunlap@infradead.org
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 8c415be86732..bf926426950d 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -1058,7 +1058,7 @@ static struct virtio_driver virtio_blk = {
>  #endif
>  };
>  
> -static int __init init(void)
> +static int __init virtio_blk_init(void)
>  {
>  	int error;
>  
> @@ -1084,14 +1084,14 @@ static int __init init(void)
>  	return error;
>  }
>  
> -static void __exit fini(void)
> +static void __exit virtio_blk_fini(void)
>  {
>  	unregister_virtio_driver(&virtio_blk);
>  	unregister_blkdev(major, "virtblk");
>  	destroy_workqueue(virtblk_wq);
>  }
> -module_init(init);
> -module_exit(fini);
> +module_init(virtio_blk_init);
> +module_exit(virtio_blk_fini);
>  
>  MODULE_DEVICE_TABLE(virtio, id_table);
>  MODULE_DESCRIPTION("Virtio block driver");

