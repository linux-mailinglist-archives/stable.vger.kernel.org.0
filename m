Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F3E5A80FB
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 17:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiHaPMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 11:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiHaPMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 11:12:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459ADD7424
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 08:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661958756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JKP8dj8WuZemTKuRl66zdjz4lCSZEv7hTLOVxotDaj0=;
        b=jNwP5YyPQrlipAgcux1/zOGZ2+KzphsIWJ1RByarvLXGNPcYHcGCs5Ny0KoJ6yBnRKHJ1T
        yIJixOObedhi4GPlHUXFYFsDAlpfEdyMW6JPXJjgLmXTQPzk5rIJpXs+jgWgNLCjDW4VGr
        u17D5pHiz1H/zlV3WdlWGmovfSsGLf4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-5KPvDFqBP7Kz1HulHBxnKw-1; Wed, 31 Aug 2022 11:12:35 -0400
X-MC-Unique: 5KPvDFqBP7Kz1HulHBxnKw-1
Received: by mail-wr1-f69.google.com with SMTP id i4-20020adfaac4000000b00226d1d39229so2137056wrc.18
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 08:12:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JKP8dj8WuZemTKuRl66zdjz4lCSZEv7hTLOVxotDaj0=;
        b=IsrXHXaImvxnOn0j8Rb/n/OWvoPE3Q0Hy16DpRo8xlzePQO2dr7YFDo3ydo0+a7+Yi
         RH0y+YPUkaZ4Ljh5aHj5hj612X25ymLCK9EFvfmsTOW5wHqvDD1m3QWNpfnIb+uemvPu
         CnsA4uE95jESYoOykZ9GZtkNUFBU/1ZLRqWsTA7dTIqjvEJ6IvnkornMFqPAE41DlIaS
         n/e3K7kflfZ5L9oOAyov9ERNBakiUVuU7DQpfYO7PgoKtPAJjO7GPJjSrbdrfq2OfWx/
         Tcx1LPfbIZsFkMJZ/XAjUoWlkNRsusFKGhBIMQkZqhzeUwHSXsZ/X29oS6+o/OadmVx2
         ivFw==
X-Gm-Message-State: ACgBeo0n46koAUuxiBc6Z2bExrw7nDfdgHzxc819682bG6tW5oBfnyxZ
        ha2c8ofd8hxxlUIvMMAfSlHIxfOoBDa5qLhuSos9qzCkVVChNdZJtWx51rr0c4Ak2i8sHdDN4wg
        SHOkN4WvGmu/HE5k5
X-Received: by 2002:adf:fac1:0:b0:226:d790:7644 with SMTP id a1-20020adffac1000000b00226d7907644mr9387379wrs.471.1661958753946;
        Wed, 31 Aug 2022 08:12:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5PJFVzXSpBCAXnH3mX+ZSWG4afgD21FAy1UQUdZOBZlILIOyvF5zouIz/cz3kS0Aab8WIhyg==
X-Received: by 2002:adf:fac1:0:b0:226:d790:7644 with SMTP id a1-20020adffac1000000b00226d7907644mr9387364wrs.471.1661958753736;
        Wed, 31 Aug 2022 08:12:33 -0700 (PDT)
Received: from redhat.com ([2.55.191.225])
        by smtp.gmail.com with ESMTPSA id j5-20020a05600c42c500b003a54fffa809sm2233442wme.17.2022.08.31.08.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:12:32 -0700 (PDT)
Date:   Wed, 31 Aug 2022 11:12:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     jasowang@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, elic@nvidia.com,
        guanjun@linux.alibaba.com, parav@nvidia.com,
        gautam.dawar@xilinx.com, dan.carpenter@oracle.com,
        xieyongji@bytedance.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: prevent uninitialized memory accesses
Message-ID: <20220831111220-mutt-send-email-mst@kernel.org>
References: <20220829073424.5677-1-maxime.coquelin@redhat.com>
 <YwxvXFiuRqGxRgZH@kroah.com>
 <796c9d73-30a0-2401-e499-724aeb0f8dc6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796c9d73-30a0-2401-e499-724aeb0f8dc6@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 05:01:11PM +0200, Maxime Coquelin wrote:
> On 8/29/22 09:48, Greg KH wrote:
> > On Mon, Aug 29, 2022 at 09:34:24AM +0200, Maxime Coquelin wrote:
> > > If the VDUSE application provides a smaller config space
> > > than the driver expects, the driver may use uninitialized
> > > memory from the stack.
> > > 
> > > This patch prevents it by initializing the buffer passed by
> > > the driver to store the config value.
> > > 
> > > This fix addresses CVE-2022-2308.
> > > 
> > > Cc: xieyongji@bytedance.com
> > > Cc: stable@vger.kernel.org # v5.15+
> > > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > > 
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> > 
> > Please no blank line above the Acked-by: line here if possible.
> 
> Sure.
> 
> Jason, do you prefer I post a new revision with this single change or
> you will handle it while applying? Either way is fine to me.
> 
> Thanks,
> Maxime

Repost pls, easier.

> > thanks,
> > 
> > greg k-h
> > 

