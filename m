Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B862E354AD3
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 04:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbhDFCWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 22:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238828AbhDFCWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 22:22:11 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B280C06174A;
        Mon,  5 Apr 2021 19:22:03 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id x207so13586783oif.1;
        Mon, 05 Apr 2021 19:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=19kpffbAVNdi4vsZj8TMnzstnGYyFppvEB6JSrzy1/Y=;
        b=j+j3fUT9Y4S3n9gywytwrl1xK+qVvDjJ6LehF6aqGfD8a/RJRV2mhCxWmoR84tQQJO
         buGz3yXHtUQRWFpOyPio2WDBexGFgCEZ7qjUiRwVVSr4C2NtMxH2rPlPD+qskQiejSUO
         ednSYinpJsuO+9RcbeIYvIJBYhdrQaIotAt1YvJwXCAk3msFn3l/SQkcOPQiPlpgTIqo
         Z5OmGd00oye0c+d84ZTbNhwgISqu3wWJUN0ACU5nZtDvOxPBJBZokzgo9WG5s0Thi8Lb
         BDOuKmI1PYWY/G22XNRKOchAoWDvxnETxmKvAfRhfdLYqthC5nAcE52zKZpKUWvZ+UtH
         WrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=19kpffbAVNdi4vsZj8TMnzstnGYyFppvEB6JSrzy1/Y=;
        b=qzeKaDEU13UHWEq879jYuCBQXOcrwMK92OSuKj/y5KBvtmUQFb+1mGlX/U2lbX65ya
         xdzcd4z7SlO9DhszTLZR4vhZeEYLe3nbnPXgFxwXzUq9WgYXf+e9ai94DbW6ZG+K92jv
         K6oS9TZ1a8dxIDEXkfo7ctqUfwVHqBdrNZ8guUmCtBIYZZhyhrlYTf+mXuPyZIilR225
         Cd3SCYS0YEHt8AEpeubjAUrcLy8yOEtszNwfh7aL42F3zt9hey+nE71lu/QSi56/eFUK
         L8oiVkIxXZ8yP7g1VLo9WoxKyh4P8hUIhH7JNIA/CcjNzmj0ii/+lbIiEiIGP6+cWxBX
         obuw==
X-Gm-Message-State: AOAM532exxJS2U9WzKHXsPfIdUW/7atqpuvjwso99ULS76s1FyOGyLOD
        PfQTVzAECptgFSymHjOm6C8=
X-Google-Smtp-Source: ABdhPJz/ZLftz58qwsTjXjs6SHJPgE+bsrWxWActnZ7v3P/BxUszM2obBBKRmK3u1BnmHNqnYAF+0w==
X-Received: by 2002:aca:c349:: with SMTP id t70mr1579523oif.87.1617675722791;
        Mon, 05 Apr 2021 19:22:02 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g5sm3412345oiy.24.2021.04.05.19.22.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 19:22:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 19:22:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
Message-ID: <20210406022200.GA20578@roeck-us.net>
References: <20210405085018.871387942@linuxfoundation.org>
 <20210405175629.GB93485@roeck-us.net>
 <20210405235155.GA75187@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405235155.GA75187@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 04:51:55PM -0700, Guenter Roeck wrote:
> On Mon, Apr 05, 2021 at 10:56:29AM -0700, Guenter Roeck wrote:
> > On Mon, Apr 05, 2021 at 10:53:35AM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.9.265 release.
> > > There are 35 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 163 pass: 163 fail: 0
> > Qemu test results:
> > 	total: 383 pass: 382 fail: 1
> > Failed tests:
> > 	parisc:generic-32bit_defconfig:smp:net,pcnet:scsi[53C895A]:rootfs
> > 
> > In the failing test, the network interfcace instantiates but fails to get
> > an IP address. This is not a new problem but a new test. For some reason
> > it only happens with this specific network interface, this specific SCSI
> > controller, and with v4.9.y. No reason for concern; I'll try to track down
> > what is going on.
> > 
> 
> Interesting. The problem affects all kernels up to and including
> v4.19.y. Unlike I thought initially, the problem is not associated
> with the SCSI controller (that was coincidental) but with pcnet
> Ethernet interfaces. It has been fixed in the upstream kernel with
> commit 518a2f1925c3 ("dma-mapping: zero memory returned from
> dma_alloc_*"). This patch does not apply cleanly to any of the
> affected kernels. I backported part of it to v4.19.y and v4.9.y
> and confirmed that it fixes the problem in those branches.
> 
> Question is what we should do: try to backport 518a2f1925c3 to v4.19.y
> and earlier, or stop testing against this specific problem.
> 

Another update: The following code change fixes the problem as well.
Commit 518a2f1925c3 fixes it only as side effect since it clears
all DMA buffers.

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index c22bf52d3320..7a25ec8390e4 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1967,7 +1967,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
                return -ENOMEM;
        }

-       lp->rx_ring = pci_alloc_consistent(lp->pci_dev,
+       lp->rx_ring = pci_zalloc_consistent(lp->pci_dev,
                                           sizeof(struct pcnet32_rx_head) *
                                           lp->rx_ring_size,
                                           &lp->rx_ring_dma_addr);

I'll submit a patch implementing that; we'll see how it goes.

Thanks,
Guenter
