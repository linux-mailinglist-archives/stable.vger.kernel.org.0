Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478E060396A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 07:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJSF6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 01:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJSF6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 01:58:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EBF537EF
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 22:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666159116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pqNgzDPaWWHyoLaC733Qdl7ljuE8EbGh7ekgiNrTuhE=;
        b=Voh8+8or4jLl6HHFsY37sjm0b2zLp6TWy7O3WFs+2xXsDSwNkwSCm8XuEOFoSN+syQFz7B
        XbARAMWyodMf18DQnnwtTHPoKBXe+ohINBzcqw43HUViINWaESL9pBEkJSor9tKLmMHzdt
        hap7bFsBxgJFWd9JBUhhi28qj7WpBs0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-414-JEhZd8PYOFypX6zZsA5bZA-1; Wed, 19 Oct 2022 01:58:35 -0400
X-MC-Unique: JEhZd8PYOFypX6zZsA5bZA-1
Received: by mail-wm1-f71.google.com with SMTP id v191-20020a1cacc8000000b003bdf7b78dccso10345410wme.3
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 22:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqNgzDPaWWHyoLaC733Qdl7ljuE8EbGh7ekgiNrTuhE=;
        b=0eqwIB23Typ++iX9CzrIs80YRjWkctaqZI6GnZMgJjG/3BXkr0SDK7W2p+RgRjftrP
         WOAKP4tgD60ATK7KLhlTQPjEWBBw/HuXeigx1ptL+XioVBrzfEUjsJPbS0rvFTiJugSa
         xMyARowm8gfttEULa0/orR/L0BaP8nquJmgLp6gHMJRuvTxxud47JilVOZgsmC6/tnRj
         +bvG5c5/gNJD9txXP4S0TszOjMEPrK6GRxAkxsmFbsWLhsdVL8oKdle3vfSGwlDDSV+H
         mkBQKn5a2eqwOeQ5FuVg0xH0X45WJSuaiFCPy4Q2+KHaKz0YyW63qKtcWblBKtiWhkl3
         0+hQ==
X-Gm-Message-State: ACrzQf3gqKMSSGyFgdBsuQsNf74+m3gN1h9s04AZHtS2TPXGa+J9xwDf
        ydfTph0GhOLqmp+apjeto/NacfqMDzTqeN0UneIWPPkk/lKTBQTUd6Y9NR3/FTVgVxiArmqRGBR
        D1IIXuz/v/JTszau9
X-Received: by 2002:a5d:410c:0:b0:22e:632a:9bc0 with SMTP id l12-20020a5d410c000000b0022e632a9bc0mr3969818wrp.696.1666159113923;
        Tue, 18 Oct 2022 22:58:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ydgSy7J+rRd/x5USsw37lsUYGP8h1BG06y3ia3UhlbPnNx/Sat2sTQ4QAGd4xLnHJpGbqQw==
X-Received: by 2002:a5d:410c:0:b0:22e:632a:9bc0 with SMTP id l12-20020a5d410c000000b0022e632a9bc0mr3969806wrp.696.1666159113695;
        Tue, 18 Oct 2022 22:58:33 -0700 (PDT)
Received: from redhat.com ([2.54.191.184])
        by smtp.gmail.com with ESMTPSA id i29-20020a1c541d000000b003c41144b3cfsm20704885wmb.20.2022.10.18.22.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 22:58:33 -0700 (PDT)
Date:   Wed, 19 Oct 2022 01:58:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Angus Chen <angus.chen@jaguarmicro.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.9 8/8] virtio_pci: don't try to use intxif pin
 is zero
Message-ID: <20221019015706-mutt-send-email-mst@kernel.org>
References: <20221018001202.2732458-1-sashal@kernel.org>
 <20221018001202.2732458-8-sashal@kernel.org>
 <TY2PR06MB3424671C418DAEF5E1B7E57C852B9@TY2PR06MB3424.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TY2PR06MB3424671C418DAEF5E1B7E57C852B9@TY2PR06MB3424.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 12:27:46AM +0000, Angus Chen wrote:
> Hi sasha
> 
> > -----Original Message-----
> > From: Sasha Levin <sashal@kernel.org>
> > Sent: Tuesday, October 18, 2022 8:12 AM
> > To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> > Cc: Angus Chen <angus.chen@jaguarmicro.com>; Michael S . Tsirkin
> > <mst@redhat.com>; Sasha Levin <sashal@kernel.org>; jasowang@redhat.com;
> > virtualization@lists.linux-foundation.org
> > Subject: [PATCH AUTOSEL 4.9 8/8] virtio_pci: don't try to use intxif pin is zero
> > 
> > From: Angus Chen <angus.chen@jaguarmicro.com>
> > 
> > [ Upstream commit 71491c54eafa318fdd24a1f26a1c82b28e1ac21d ]
> > 
> > The background is that we use dpu in cloud computing,the arch is x86,80
> > cores. We will have a lots of virtio devices,like 512 or more.
> > When we probe about 200 virtio_blk devices,it will fail and
> > the stack is printed as follows:
> > 
> > [25338.485128] virtio-pci 0000:b3:00.0: virtio_pci: leaving for legacy driver
> > [25338.496174] genirq: Flags mismatch irq 0. 00000080 (virtio418) vs. 00015a00
> > (timer)
> > [25338.503822] CPU: 20 PID: 5431 Comm: kworker/20:0 Kdump: loaded Tainted:
> > G           OE    --------- -  - 4.18.0-305.30.1.el8.x86_64
> > [25338.516403] Hardware name: Inspur NF5280M5/YZMB-00882-10E, BIOS
> > 4.1.21 08/25/2021
> > [25338.523881] Workqueue: events work_for_cpu_fn
> > [25338.528235] Call Trace:
> > [25338.530687]  dump_stack+0x5c/0x80
> > [25338.534000]  __setup_irq.cold.53+0x7c/0xd3
> > [25338.538098]  request_threaded_irq+0xf5/0x160
> > [25338.542371]  vp_find_vqs+0xc7/0x190
> > [25338.545866]  init_vq+0x17c/0x2e0 [virtio_blk]
> > [25338.550223]  ? ncpus_cmp_func+0x10/0x10
> > [25338.554061]  virtblk_probe+0xe6/0x8a0 [virtio_blk]
> > [25338.558846]  virtio_dev_probe+0x158/0x1f0
> > [25338.562861]  really_probe+0x255/0x4a0
> > [25338.566524]  ? __driver_attach_async_helper+0x90/0x90
> > [25338.571567]  driver_probe_device+0x49/0xc0
> > [25338.575660]  bus_for_each_drv+0x79/0xc0
> > [25338.579499]  __device_attach+0xdc/0x160
> > [25338.583337]  bus_probe_device+0x9d/0xb0
> > [25338.587167]  device_add+0x418/0x780
> > [25338.590654]  register_virtio_device+0x9e/0xe0
> > [25338.595011]  virtio_pci_probe+0xb3/0x140
> > [25338.598941]  local_pci_probe+0x41/0x90
> > [25338.602689]  work_for_cpu_fn+0x16/0x20
> > [25338.606443]  process_one_work+0x1a7/0x360
> > [25338.610456]  ? create_worker+0x1a0/0x1a0
> > [25338.614381]  worker_thread+0x1cf/0x390
> > [25338.618132]  ? create_worker+0x1a0/0x1a0
> > [25338.622051]  kthread+0x116/0x130
> > [25338.625283]  ? kthread_flush_work_fn+0x10/0x10
> > [25338.629731]  ret_from_fork+0x1f/0x40
> > [25338.633395] virtio_blk: probe of virtio418 failed with error -16
> > 
> > The log :
> > "genirq: Flags mismatch irq 0. 00000080 (virtio418) vs. 00015a00 (timer)"
> > was printed because of the irq 0 is used by timer exclusive,and when
> > vp_find_vqs call vp_find_vqs_msix and returns false twice (for
> > whatever reason), then it will call vp_find_vqs_intx as a fallback.
> > Because vp_dev->pci_dev->irq is zero, we request irq 0 with
> > flag IRQF_SHARED, and get a backtrace like above.
> > 
> > According to PCI spec about "Interrupt Pin" Register (Offset 3Dh):
> > "The Interrupt Pin register is a read-only register that identifies the
> >  legacy interrupt Message(s) the Function uses. Valid values are 01h, 02h,
> >  03h, and 04h that map to legacy interrupt Messages for INTA,
> >  INTB, INTC, and INTD respectively. A value of 00h indicates that the
> >  Function uses no legacy interrupt Message(s)."
> > 
> > So if vp_dev->pci_dev->pin is zero, we should not request legacy
> > interrupt.
> > 
> > Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
> > Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> > Message-Id: <20220930000915.548-1-angus.chen@jaguarmicro.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/virtio/virtio_pci_common.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/virtio/virtio_pci_common.c
> > b/drivers/virtio/virtio_pci_common.c
> > index 37e3ba5dadf6..d634eb926a2f 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -389,6 +389,9 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned
> > nvqs,
> >  				 true, false);
> >  	if (!err)
> >  		return 0;
> > +	/* Is there an interrupt pin? If not give up. */
> > +	if (!(to_vp_device(vdev)->pci_dev->pin))
> > +		return err;
> >  	/* Finally fall back to regular interrupts. */
> >  	return vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names,
> >  				  false, false);
> > --
> > 2.35.1
> 
> the patch 71491c54eafa31 has been fixed by 2145ab513e3b3,
> It is report by Michael Ellerman <mpe@ellerman.id.au> and suggested by linus.
> If it is merged in the stable git repo, I worry about powerpc arch.
> Thans.

Yes, please either pick up both this and the fixup or none, and
same for all other stable trees where this was autoselected.

It looks like autoselection basically picks up everything that
has a Fixes tag in it yes?

-- 
MST

