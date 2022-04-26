Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69A650F0D9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiDZGWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiDZGWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:22:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51D7D12B440
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650953984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EQYMa3DGNKurO3iT3qnt0CypDzkBqPK2CLR0WQxJotg=;
        b=EAkcCyxF/EWObzLRZzgx/rLzjT9VDuLBEH27i7RDUKPlXgPqxAANUrVdiRTEsJbXOPFJtM
        ARo1kVA9Ve0qNdHpzH2d2mFsMCzGjs1xrJhV01HKz9UicEaQaGfb7lV6qCK8SO6YgaH+ad
        N+5YHm9s+M5JN88Xuy4BO1n2LOCx9GI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-aclA3d9XMyqE9OPWJB8J7w-1; Tue, 26 Apr 2022 02:19:41 -0400
X-MC-Unique: aclA3d9XMyqE9OPWJB8J7w-1
Received: by mail-lf1-f71.google.com with SMTP id h12-20020a05651211cc00b00471af04ec12so7256671lfr.15
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 23:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQYMa3DGNKurO3iT3qnt0CypDzkBqPK2CLR0WQxJotg=;
        b=2usRk0v7M8TUfyvrO0HRdoQtrfwWRd7e9oqMgFlHvs/880/PHFYNKeeYtTmzVmA0eW
         igIs+6wswDwECY9dArNpaUprrnQhN4FEAAqRR6U83MyyXyy6WX2EnU9qv4+X9464dJcd
         Zl7NOG2O8zQsmihsMaUsHLD6G666wvxBj9+fOzKSsVd+aU9vnZ3O/ONpVu/Gti9Znt5f
         IMwkpazb6YGIwZ28IFe6eQSzNii0nFCwl4yK3Eu8ISF9emhXDOn7iMnHVO7Kfc+uu7qU
         7JHtFZ9ua6sbOIFMM4bpmtyHlmUZd3g3mcuvdFgZNUVdotaI0aTCFetQwG1wPmpEFOZD
         4Tug==
X-Gm-Message-State: AOAM533ZNZaeVYKjBQp0pIUxcWL0afRnkSwOQsiw0Po2+grF12V3Jqtb
        xlbNx8JPkpHodMga/O7Eqc8ouywqWjPVHiQ0xOHxZ4WYTXQHa58ciqAbYV23xMEmg75nQnX7xxJ
        20zqrXbgQWrukDsDHozkVtpUEMMLWj2/K
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id h16-20020a19ca50000000b00471f556092bmr11541605lfj.587.1650953979508;
        Mon, 25 Apr 2022 23:19:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHRJZRr25niHsOv0rh5fj62mTbJ/i3zQBf1gJ86LXWrg1e8vSlgtm8gMqVgwq6rAsjLtyPK4eBS6VFQk7xZW4=
X-Received: by 2002:a19:ca50:0:b0:471:f556:92b with SMTP id
 h16-20020a19ca50000000b00471f556092bmr11541597lfj.587.1650953979316; Mon, 25
 Apr 2022 23:19:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220426060103.104-1-xieyongji@bytedance.com>
In-Reply-To: <20220426060103.104-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Apr 2022 14:19:28 +0800
Message-ID: <CACGkMEued=Pewd-xfLu7nhY0_gvMowAte4084mLWxAkykzJ8gw@mail.gmail.com>
Subject: Re: [PATCH] vduse: Fix NULL pointer dereference on sysfs access
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst <mst@redhat.com>, mcgrof@kernel.org, akpm@linux-foundation.org,
        oliver.sang@intel.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 2:01 PM Xie Yongji <xieyongji@bytedance.com> wrote:
>
> The control device has no drvdata. So we will get a NULL
> NULL pointer dereference when accessing control device's
> msg_timeout via sysfs:
>
> [ 132.841881][ T3644] BUG: kernel NULL pointer dereference, address: 00000000000000f8
> [ 132.850619][ T3644] RIP: 0010:msg_timeout_show (drivers/vdpa/vdpa_user/vduse_dev.c:1271)
> [ 132.869447][ T3644] dev_attr_show (drivers/base/core.c:2094)
> [ 132.870215][ T3644] sysfs_kf_seq_show (fs/sysfs/file.c:59)
> [ 132.871164][ T3644] ? device_remove_bin_file (drivers/base/core.c:2088)
> [ 132.872082][ T3644] kernfs_seq_show (fs/kernfs/file.c:164)
> [ 132.872838][ T3644] seq_read_iter (fs/seq_file.c:230)
> [ 132.873578][ T3644] ? __vmalloc_area_node (mm/vmalloc.c:3041)
> [ 132.874532][ T3644] kernfs_fop_read_iter (fs/kernfs/file.c:238)
> [ 132.875513][ T3644] __kernel_read (fs/read_write.c:440 (discriminator 1))
> [ 132.876319][ T3644] kernel_read (fs/read_write.c:459)
> [ 132.877129][ T3644] kernel_read_file (fs/kernel_read_file.c:94)
> [ 132.877978][ T3644] kernel_read_file_from_fd (include/linux/file.h:45 fs/kernel_read_file.c:186)
> [ 132.879019][ T3644] __do_sys_finit_module (kernel/module.c:4207)
> [ 132.879930][ T3644] __ia32_sys_finit_module (kernel/module.c:4189)
> [ 132.880930][ T3644] do_int80_syscall_32 (arch/x86/entry/common.c:112 arch/x86/entry/common.c:132)
> [ 132.881847][ T3644] entry_INT80_compat (arch/x86/entry/entry_64_compat.S:419)
>
> To fix it, let's add a NULL check in msg_timeout_show() and
> msg_timeout_store().
>
> Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index f85d1a08ed87..f1c42f4aabb4 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1268,6 +1268,9 @@ static ssize_t msg_timeout_show(struct device *device,
>  {
>         struct vduse_dev *dev = dev_get_drvdata(device);
>
> +       if (!dev)
> +               return -EPERM;
> +

I wonder if it's possible to not have those attributes for the control device.

Thanks

>         return sysfs_emit(buf, "%u\n", dev->msg_timeout);
>  }
>
> @@ -1278,6 +1281,9 @@ static ssize_t msg_timeout_store(struct device *device,
>         struct vduse_dev *dev = dev_get_drvdata(device);
>         int ret;
>
> +       if (!dev)
> +               return -EPERM;
> +
>         ret = kstrtouint(buf, 10, &dev->msg_timeout);
>         if (ret < 0)
>                 return ret;
> --
> 2.20.1
>

