Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A771F2B1E92
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 16:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgKMP0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 10:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbgKMP0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 10:26:25 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B035C0613D1
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 07:26:25 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id h16so5122348otq.9
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 07:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/8hKup0PEqekEDnlVknos01eVeSf0vMGU/zIaJqCHk=;
        b=Yd9R5EBka93rwJzrwnksydn8gLHx2y8OoIXhmAUK9eLDFV59JRNvFvlCDzyZm+t76d
         Whk0yYaiY7dBvLhOX3H1byoZOsGHJXsBQLD3N23CoRfbI+mgEHfNvbsEMybK3Gme4rR3
         lRTAyS61/1rEuoUXKQbNtwOsR5U7eDlciay5LpfMAZ5hMf6MUvKeOYG/szMjx/1tOJIM
         3Gl5n54I7W5rWsjNFfB6uXG/e4uzaoMfZKQ664erakI2MsEfDrGngXW5dUV+M4QptiY8
         S2gGEPINplvA3E5ac7Nb1t6zkg18W/AphhvICXAC6biAvf1BBWMqFa8u4yDaIxhfdP4C
         nGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T/8hKup0PEqekEDnlVknos01eVeSf0vMGU/zIaJqCHk=;
        b=Bq1dUnn/6AfKlTIwhiLxqjwdtj03cP7yT2gFwjDGJ1ieNinDwHkbl6h6MBKphP6ptZ
         EwiTg6VejKNQ/vxWUQEM/niuh+BNZ3o7PyeY+QJnAAOMUHK6d76XVblH+Lycx+fcw/zN
         c8KkJbt+8g8Vdu3RpbEVNg/OT6o8iw55CkFpfo/gmdJpsUTOMyx9pBUYWkwapv4LPsTd
         9qPZ6KiZEIkw6Hq4XP6gWSmtyRCKv+BBzPqy7r1YcNfd8LF5d2erSv5xgYDxJNUmr1nk
         liUOT/mfyTHvGTcN+K1Xi/StKidqPFFQspd+vMp0wwiWA+ZEEqUzUwCVXvDhPTSg+3xw
         okqw==
X-Gm-Message-State: AOAM530hI3GeyqiReJxDkOsbWZSgKNlZpm8rGllDcnAj8Fln/FKJm6kP
        Q5P6ynIV46Z3ndxPaxKoHm06li2bfCwHgB2Gaq6Zex0PrAQ=
X-Google-Smtp-Source: ABdhPJy9PVc0+ZSspoGbwKfp07dpaRuznwzwcJdj3RTuxqTgcaq4vyMZcKdvOyRySpDz4EPITx9Pf0Zu727JvVB7F0E=
X-Received: by 2002:a9d:22e4:: with SMTP id y91mr1855412ota.72.1605281179814;
 Fri, 13 Nov 2020 07:26:19 -0800 (PST)
MIME-Version: 1.0
References: <20201102202515.19073-1-sergio.paracuellos@gmail.com>
In-Reply-To: <20201102202515.19073-1-sergio.paracuellos@gmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Fri, 13 Nov 2020 16:26:08 +0100
Message-ID: <CAMhs-H9DRT6G0GQg-gpDT=q_BniDf3EbE3Qq2YbHCXZSK7nPqw@mail.gmail.com>
Subject: Re: [PATCH] staging: mt7621-pci: avoid to request pci bus resources
To:     "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, NeilBrown <neil@brown.name>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Nov 2, 2020 at 9:25 PM Sergio Paracuellos
<sergio.paracuellos@gmail.com> wrote:
>
> After upgrading kernel to version 5.9.x the driver was not
> working anymore showing the following kernel trace:
>
> ...
> mt7621-pci 1e140000.pcie: resource collision:
> [mem 0x60000000-0x6fffffff] conflicts with pcie@1e140000 [mem 0x60000000-0x6fffffff]
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 73 at kernel/resource.c:1400
> devm_request_resource+0xfc/0x10c
> Modules linked in:
> CPU: 2 PID: 73 Comm: kworker/2:1 Not tainted 5.9.2 #0
> Workqueue: events deferred_probe_work_func
> Stack : 00000000 81590000 807d0a1c 808a0000 8fd49080
>         807d0000 00000009 808ac820
>         00000001 808338d0 7fff0001 800839dc 00000049
>         00000001 8fe51b00 367204ab
>         00000000 00000000 807d0a1c 807c0000 00000001
>         80082358 8fe50000 00559000
>         00000000 8fe519f1 ffffffff 00000005 00000000
>         00000001 00000000 807d0000
>         00000009 808ac820 00000001 808338d0 00000001
>         803bf1b0 00000008 81390008
>
> Call Trace:
> [<8000d018>] show_stack+0x30/0x100
> [<8032e66c>] dump_stack+0xa4/0xd4
> [<8002db1c>] __warn+0xc0/0x134
> [<8002dbec>] warn_slowpath_fmt+0x5c/0xac
> [<80033b34>] devm_request_resource+0xfc/0x10c
> [<80365ff8>] devm_request_pci_bus_resources+0x58/0xdc
> [<8048e13c>] mt7621_pci_probe+0x8dc/0xe48
> [<803d2140>] platform_drv_probe+0x40/0x94
> [<803cfd94>] really_probe+0x108/0x4ec
> [<803cd958>] bus_for_each_drv+0x70/0xb0
> [<803d0388>] __device_attach+0xec/0x164
> [<803cec8c>] bus_probe_device+0xa4/0xc0
> [<803cf1c4>] deferred_probe_work_func+0x80/0xc4
> [<80048444>] process_one_work+0x260/0x510
> [<80048a4c>] worker_thread+0x358/0x5cc
> [<8004f7d0>] kthread+0x134/0x13c
> [<80007478>] ret_from_kernel_thread+0x14/0x1c
> ---[ end trace a9dd2e37537510d3 ]---
> mt7621-pci 1e140000.pcie: Error requesting resources
> mt7621-pci: probe of 1e140000.pcie failed with error -16
> ...
>
> With commit 669cbc708122 ("PCI: Move DT resource setup into
> devm_pci_alloc_host_bridge()"), the DT 'ranges' is parsed and populated
> into resources when the host bridge is allocated. The resources are
> requested as well, but that happens a 2nd time for this driver in
> mt7621_pcie_request_resources(). Hence we should avoid this second
> request.
>
> Also, the bus ranges was also populated by default, so we can remove
> it from mt7621_pcie_request_resources() to avoid the following trace
> if we don't avoid it:
>
> pci_bus 0000:00: busn_res: can not insert [bus 00-ff]
> under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
>
> Function 'mt7621_pcie_request_resources' has been renamed into
> 'mt7621_pcie_add_resources' which now is a more accurate name
> for this function.
>
> Cc: stable@vger.kernel.org#5.9.x-
> Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

This patch have to be added also for stable 5.9.x because driver is
broken in all kernel 5.9.x releases. I noticed a new stable release
comes three days ago (5.9.8) and this was not added. I was wondering
if the way I marked this patch to be included is wrong.

Thanks in advance for your time.

Best regards,
    Sergio Paracuellos

> ---
>  drivers/staging/mt7621-pci/pci-mt7621.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
> index f961b353c22e..8831db383fad 100644
> --- a/drivers/staging/mt7621-pci/pci-mt7621.c
> +++ b/drivers/staging/mt7621-pci/pci-mt7621.c
> @@ -653,16 +653,11 @@ static int mt7621_pcie_init_virtual_bridges(struct mt7621_pcie *pcie)
>         return 0;
>  }
>
> -static int mt7621_pcie_request_resources(struct mt7621_pcie *pcie,
> -                                        struct list_head *res)
> +static void mt7621_pcie_add_resources(struct mt7621_pcie *pcie,
> +                                     struct list_head *res)
>  {
> -       struct device *dev = pcie->dev;
> -
>         pci_add_resource_offset(res, &pcie->io, pcie->offset.io);
>         pci_add_resource_offset(res, &pcie->mem, pcie->offset.mem);
> -       pci_add_resource(res, &pcie->busn);
> -
> -       return devm_request_pci_bus_resources(dev, res);
>  }
>
>  static int mt7621_pcie_register_host(struct pci_host_bridge *host,
> @@ -738,11 +733,7 @@ static int mt7621_pci_probe(struct platform_device *pdev)
>
>         setup_cm_memory_region(pcie);
>
> -       err = mt7621_pcie_request_resources(pcie, &res);
> -       if (err) {
> -               dev_err(dev, "Error requesting resources\n");
> -               return err;
> -       }
> +       mt7621_pcie_add_resources(pcie, &res);
>
>         err = mt7621_pcie_register_host(bridge, &res);
>         if (err) {
> --
> 2.25.1
>
