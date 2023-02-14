Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BD3695923
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 07:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjBNGZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 01:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjBNGZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 01:25:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D1D1420E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 22:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676355880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PfyXZkWxj/kVv+Py1JHPkitVm0URdtTanKQSxq2Xcgs=;
        b=ToOQRfXqQGig+cqNA+CXKKwoMdvAKDe0r91DwHbAUhSbnirDtzn/zXBwIV+wSSFgy0nT2f
        /f/P4McgtPkCtrcwmGgNGlnr1x79h14ohSeZ0NgqraiOavN+QQYynrdMNerwk3SyYDYgzw
        Lz+D43i/JifkDkjjZaXNncsI/bBFNwk=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-EscquZAfP7G1p_UJ8tPV6Q-1; Tue, 14 Feb 2023 01:24:38 -0500
X-MC-Unique: EscquZAfP7G1p_UJ8tPV6Q-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-16de8b67b4cso3627811fac.10
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 22:24:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfyXZkWxj/kVv+Py1JHPkitVm0URdtTanKQSxq2Xcgs=;
        b=wb6y7QeEJ7mdSrvLmhlyrp+kapTbgfjikwmUqPeIO3UpuYWaMBg0hTcgWOGxZbZXbc
         SJ+glxxaN6xFcwL3+ykv3Y3XrZxH9paU9AniGx29I6Kpl2AYv/AwthCu7hQuRTUGWPuf
         wYbSCy1Xf+5tFg5nar77KeIln9rvOXu8tPEsyTSCxAre+HYdKHm4VjwI/JEFk4yRwCky
         bxR8mKJtcy9rdF95nSwizzu7mUtEPw2Yh1Rpu2v1uBAHfObJ80iR8IQ+Z1lSyOGPTmod
         UxYjh6mSgZpzjiqbI0FgO1oTyiFdfA7Lhq44D+pgY7MYSMQG2joVIhjtV3lCwg2yNRwT
         v+uw==
X-Gm-Message-State: AO0yUKVzqbfSILWg1zSPWdAXQiBfcR9268JV8b0tzcnNofDm+Hr2I+fE
        w7129fb9/2gn0+5TN2vl5HzEFcrOBnwjj52KVvUCw2xl0D4Qe/K5tkZp3gqz96jEIBE2Nx3DLKr
        +UHYELux00jRMKeE2DFzeyV9bus+P1IJh
X-Received: by 2002:aca:705:0:b0:363:a978:6d41 with SMTP id 5-20020aca0705000000b00363a9786d41mr50911oih.280.1676355877781;
        Mon, 13 Feb 2023 22:24:37 -0800 (PST)
X-Google-Smtp-Source: AK7set85wFwfR2MaBWsTGoOEALdVnhI+98ejjvCKJTzuzpGs9tFx7mVZvQJOj+zj4jc+5ZMBWy/tlBWhNN9fVFxOdxo=
X-Received: by 2002:aca:705:0:b0:363:a978:6d41 with SMTP id
 5-20020aca0705000000b00363a9786d41mr50909oih.280.1676355877530; Mon, 13 Feb
 2023 22:24:37 -0800 (PST)
MIME-Version: 1.0
References: <20230214061743.114257-1-lulu@redhat.com>
In-Reply-To: <20230214061743.114257-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Feb 2023 14:24:26 +0800
Message-ID: <CACGkMEtFbxRqJZiho+kxZqziTXLFm5ySfubdAKJf-+eE-wprvw@mail.gmail.com>
Subject: Re: [PATCH] vp_vdpa: fix the crash in hot unplug with vp_vdpa
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 2:17 PM Cindy Lu <lulu@redhat.com> wrote:
>
> While unplugging the vp_vdpa device, the kernel will crash
> The root cause is the function vp_modern_get_status() called following the
> vp_modern_remove().

This needs some tweaking, maybe it's better to say
vdpa_mgmtdev_unregister() will access modern devices which will cause
a use after free.

>So need to change the sequence in vp_vdpa_remove
>
> [  195.016001] Call Trace:

Let's paste the full log with the reason for the calltrace (e.g
general protection fault or whatever else).

> [  195.016233]  <TASK>
> [  195.016434]  vp_modern_get_status+0x12/0x20
> [  195.016823]  vp_vdpa_reset+0x1b/0x50 [vp_vdpa]
> [  195.017238]  virtio_vdpa_reset+0x3c/0x48 [virtio_vdpa]
> [  195.017709]  remove_vq_common+0x1f/0x3a0 [virtio_net]
> [  195.018178]  virtnet_remove+0x5d/0x70 [virtio_net]
> [  195.018618]  virtio_dev_remove+0x3d/0x90
> [  195.018986]  device_release_driver_internal+0x1aa/0x230
> [  195.019466]  bus_remove_device+0xd8/0x150
> [  195.019841]  device_del+0x18b/0x3f0
> [  195.020167]  ? kernfs_find_ns+0x35/0xd0
> [  195.020526]  device_unregister+0x13/0x60
> [  195.020894]  unregister_virtio_device+0x11/0x20
> [  195.021311]  device_release_driver_internal+0x1aa/0x230
> [  195.021790]  bus_remove_device+0xd8/0x150
> [  195.022162]  device_del+0x18b/0x3f0
> [  195.022487]  device_unregister+0x13/0x60
> [  195.022852]  ? vdpa_dev_remove+0x30/0x30 [vdpa]
> [  195.023270]  vp_vdpa_dev_del+0x12/0x20 [vp_vdpa]
> [  195.023694]  vdpa_match_remove+0x2b/0x40 [vdpa]
> [  195.024115]  bus_for_each_dev+0x78/0xc0
> [  195.024471]  vdpa_mgmtdev_unregister+0x65/0x80 [vdpa]
> [  195.024937]  vp_vdpa_remove+0x23/0x40 [vp_vdpa]
> [  195.025353]  pci_device_remove+0x36/0xa0
> [  195.025719]  device_release_driver_internal+0x1aa/0x230
> [  195.026201]  pci_stop_bus_device+0x6c/0x90
> [  195.026580]  pci_stop_and_remove_bus_device+0xe/0x20
> [  195.027039]  disable_slot+0x49/0x90
> [  195.027366]  acpiphp_disable_and_eject_slot+0x15/0x90
> [  195.027832]  hotplug_event+0xea/0x210
> [  195.028171]  ? hotplug_event+0x210/0x210
> [  195.028535]  acpiphp_hotplug_notify+0x22/0x80
> [  195.028942]  ? hotplug_event+0x210/0x210
> [  195.029303]  acpi_device_hotplug+0x8a/0x1d0
> [  195.029690]  acpi_hotplug_work_fn+0x1a/0x30
> [  195.030077]  process_one_work+0x1e8/0x3c0
> [  195.030451]  worker_thread+0x50/0x3b0
> [  195.030791]  ? rescuer_thread+0x3a0/0x3a0
> [  195.031165]  kthread+0xd9/0x100
> [  195.031459]  ? kthread_complete_and_exit+0x20/0x20
> [  195.031899]  ret_from_fork+0x22/0x30
> [  195.032233]  </TASK>
>
> Fixes: ffbda8e9df10 ("vdpa/vp_vdpa : add vdpa tool support in vp_vdpa")
> Tested-by: Lei Yang <leiyang@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Cindy Lu <lulu@redhat.com>

Other than above,

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/virtio_pci/vp_vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> index 8fe267ca3e76..281287fae89f 100644
> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> @@ -645,8 +645,8 @@ static void vp_vdpa_remove(struct pci_dev *pdev)
>         struct virtio_pci_modern_device *mdev = NULL;
>
>         mdev = vp_vdpa_mgtdev->mdev;
> -       vp_modern_remove(mdev);
>         vdpa_mgmtdev_unregister(&vp_vdpa_mgtdev->mgtdev);
> +       vp_modern_remove(mdev);
>         kfree(vp_vdpa_mgtdev->mgtdev.id_table);
>         kfree(mdev);
>         kfree(vp_vdpa_mgtdev);
> --
> 2.34.3
>

