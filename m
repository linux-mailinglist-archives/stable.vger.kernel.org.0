Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7686353B660
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 11:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiFBJvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 05:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiFBJvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 05:51:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BCCD2A553F
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 02:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654163494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+kegU7ORx0W8UnxolSPCB9JQoq9JSMa2fSWT0u2zedo=;
        b=iU50wQzwdlbWykldp4ZfK1GXjC/JuKAoldyrXKZE9f59hUkp8I171ZrmggR4CLEN+MjReH
        UDre0CjfoVSqzvNsjhbaLot+eUxNKNnpIuJPCUWA8Tci8TYF67SvXlYLR00aLLfwCtOORC
        mE3o5WXDYj4m4TVC7LyoPyO/30QWuu4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-FG9OzvVjOCCNdHMUayMb1g-1; Thu, 02 Jun 2022 05:51:33 -0400
X-MC-Unique: FG9OzvVjOCCNdHMUayMb1g-1
Received: by mail-wr1-f72.google.com with SMTP id o17-20020a5d4091000000b002102fe310dcso668647wrp.20
        for <stable@vger.kernel.org>; Thu, 02 Jun 2022 02:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+kegU7ORx0W8UnxolSPCB9JQoq9JSMa2fSWT0u2zedo=;
        b=OYPAKyJ92SGoPhuO4o3kt7xLe0Dfx+pxfFsjtFvcRCTxsy6sx3cs90NUjxmGqvJ/sq
         /DuLDtQ7gzuDaO1B59vP6ihSg7BjxQBzcv3M+iN4Q3hD+Nj+v2lxUHHEpS0VVriixU5/
         qdDg4xnnk8z/tP32cxM6w3VA7yGXOjVX1zUNSb2MWBz3F7PD00mCuSCElJFS93w/KYHt
         A+HyefgKXDooMtQoUet8fSDnlR+eawdh4eF9gGP5oQc8HSKLI+b2jyTgIyaF+5Z5fWPA
         GSSLCqOb+yIEbUvQXm98MEwihytLJdEQ8rDXVMWT092Wm7/pUuCjpVXOMgIN2YF2HGya
         ymtg==
X-Gm-Message-State: AOAM531mWEGM9h0HFOvCqDycwfU8QHAp5JYpy4Z+FjjUehSS+axiQaH7
        NK1ZJ9MFVUhqkyy1GtQt+liqVanJGq839xUuViwxNO3MSMntjLRPuz7OomDGlrfKY94DoK3QNt9
        rWa7HgiBTNA4m/Ssc
X-Received: by 2002:a5d:64ac:0:b0:211:7f3b:a0d4 with SMTP id m12-20020a5d64ac000000b002117f3ba0d4mr3004790wrp.490.1654163491436;
        Thu, 02 Jun 2022 02:51:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCe/mjZchJWw3n43gLEvTclxgrryh7EI+ogi7ouPTFMNYR2LffHT+ygDCYALQpH0gwN+7kGg==
X-Received: by 2002:a5d:64ac:0:b0:211:7f3b:a0d4 with SMTP id m12-20020a5d64ac000000b002117f3ba0d4mr3004761wrp.490.1654163491211;
        Thu, 02 Jun 2022 02:51:31 -0700 (PDT)
Received: from redhat.com ([2.52.157.68])
        by smtp.gmail.com with ESMTPSA id q16-20020adfcd90000000b00213abce60e4sm401297wrj.111.2022.06.02.02.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 02:51:30 -0700 (PDT)
Date:   Thu, 2 Jun 2022 05:51:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Message-ID: <20220602055103-mutt-send-email-mst@kernel.org>
References: <20220426073656.229-1-xieyongji@bytedance.com>
 <CACycT3v+r1-RO1q_BuStkaais7n0yDXK4gT89WhchpX3AvRPcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3v+r1-RO1q_BuStkaais7n0yDXK4gT89WhchpX3AvRPcg@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 02, 2022 at 12:55:02PM +0800, Yongji Xie wrote:
> Ping.

Thanks for the reminder!
Will queue for rc2, rc1 has too much stuff already.

> On Tue, Apr 26, 2022 at 3:36 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> >
> > The control device has no drvdata. So we will get a
> > NULL pointer dereference when accessing control
> > device's msg_timeout attribute via sysfs:
> >
> > [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> > [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> > [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> > [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> > [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> > [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> > [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> > [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> > [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> > [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> > [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> > [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> > [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> > [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> > [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> > [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> > [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
> >
> > To fix it, don't create the unneeded attribute for
> > control device anymore.
> >
> > Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> > index f85d1a08ed87..160e40d03084 100644
> > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
> >
> >         dev->minor = ret;
> >         dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
> > -       dev->dev = device_create(vduse_class, NULL,
> > -                                MKDEV(MAJOR(vduse_major), dev->minor),
> > -                                dev, "%s", config->name);
> > +       dev->dev = device_create_with_groups(vduse_class, NULL,
> > +                               MKDEV(MAJOR(vduse_major), dev->minor),
> > +                               dev, vduse_dev_groups, "%s", config->name);
> >         if (IS_ERR(dev->dev)) {
> >                 ret = PTR_ERR(dev->dev);
> >                 goto err_dev;
> > @@ -1595,7 +1595,6 @@ static int vduse_init(void)
> >                 return PTR_ERR(vduse_class);
> >
> >         vduse_class->devnode = vduse_devnode;
> > -       vduse_class->dev_groups = vduse_dev_groups;
> >
> >         ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
> >         if (ret)
> > --
> > 2.20.1
> >

