Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F1A5A8222
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiHaPro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 11:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiHaPrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 11:47:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A37DB7D2
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 08:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661960783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FDnsKK2cZELk5wddqmtKkVouG+DKHN8ltWUs0oV7mCc=;
        b=LQAi+6/xt/dJsg0wPLDDjDG61+OLGso1WmvwvZKb1CtkxkigQ+2OZ/XIvH6IFAZn17YGie
        axWmXosLmAUR8M8EF90Ooij4kyATOyNYP1nQsyNKhiwhsRQzCZeaacc4JMJe3MijoWkA0E
        MKaUFB6sL2XiZ9nz+AN+n/B33ky4bwo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-g2fnXSQOPCm0EMuO9xF06w-1; Wed, 31 Aug 2022 11:46:19 -0400
X-MC-Unique: g2fnXSQOPCm0EMuO9xF06w-1
Received: by mail-wr1-f69.google.com with SMTP id j4-20020adfa544000000b002255264474bso2515105wrb.17
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 08:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=FDnsKK2cZELk5wddqmtKkVouG+DKHN8ltWUs0oV7mCc=;
        b=SeVEBe+80Dyyrk4q8Ovl2liHPR42tUwmAvQMHRyFOFiW/fk+KgtOd+Q9R5DLM8o5ft
         AGbG2iK7QGf6OZrroKMrZhkZHjS0Mpb+UY8jZ77yA9FyXUFgG3A6FsEpFwVzVxmN0uSE
         zmzA9QjxSkItaWxQKl5zt0dvAq96HX+tktyVs5tuezqUvp6hIy9i1k+DqAcetEGYOrot
         iJeBdLslHibfD6Q7mT6XiBEta2RAMA6rkNVr+J77rOQwMfPvYpCf+M3P027J3MrRfbpd
         mc263L9vP3/DGfNeOwcmCNeL0kJfsNBJxG3OQa8jWZ/P2BvPRXwb4GXPAE6WjKSiwSOf
         aI1Q==
X-Gm-Message-State: ACgBeo0lIK4kq9bIWpfp+3LVFI8Exb7YaeQsNCXDW3zWrFAGbIZP1LUV
        1jaEcgAv8J9rWpNQSIsGlVlUhhHAwuZ7xfL5BDMp9fwnhAqYdoU3eFfYWJPqGgvVo6lvl8cxTK3
        dSrHSyOcsF98qlsjR
X-Received: by 2002:adf:f2c5:0:b0:226:e838:3ed8 with SMTP id d5-20020adff2c5000000b00226e8383ed8mr3256078wrp.545.1661960776896;
        Wed, 31 Aug 2022 08:46:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR51lk4waATJlZuT8JdfrFRa/Uuco6WTTGuyB1nHXQejK5PjPhp5O0007rSiEEDR6ePRgGWKog==
X-Received: by 2002:adf:f2c5:0:b0:226:e838:3ed8 with SMTP id d5-20020adff2c5000000b00226e8383ed8mr3256066wrp.545.1661960776675;
        Wed, 31 Aug 2022 08:46:16 -0700 (PDT)
Received: from redhat.com ([2.55.191.225])
        by smtp.gmail.com with ESMTPSA id n16-20020a5d4850000000b0022546f469e1sm12162234wrs.28.2022.08.31.08.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:46:16 -0700 (PDT)
Date:   Wed, 31 Aug 2022 11:46:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     jasowang@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, elic@nvidia.com,
        guanjun@linux.alibaba.com, parav@nvidia.com,
        gautam.dawar@xilinx.com, dan.carpenter@oracle.com,
        xieyongji@bytedance.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: prevent uninitialized memory accesses
Message-ID: <20220831114534-mutt-send-email-mst@kernel.org>
References: <20220829073424.5677-1-maxime.coquelin@redhat.com>
 <YwxvXFiuRqGxRgZH@kroah.com>
 <796c9d73-30a0-2401-e499-724aeb0f8dc6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796c9d73-30a0-2401-e499-724aeb0f8dc6@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

I queue these normally.

> > thanks,
> > 
> > greg k-h
> > 

