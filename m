Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB68332217D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhBVVey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhBVVet (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:34:49 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEA1C06174A;
        Mon, 22 Feb 2021 13:34:06 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id q85so14208061qke.8;
        Mon, 22 Feb 2021 13:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rpmkj25u0UX9OE/Iypuct9W0L/AwsgyiytycVOE8wf0=;
        b=PAtxIRF2aHb056d9wdfDyVZxrNd7PVhW5aVQ7t9fx6/Fd9vbcrDuPminDNwt20Gwnr
         QPQP3fYi7UgV+FKmjzGj+mdkEO2jSp872n2lGbWzuIWP1opF2PCVAJTbv1EfUc6r2+MW
         sbLUXbcPysLKOxc2ToHWnjhI9DoSzPNJVO+EIa7p7wYHHbbc4HyjpxaYRAfTTC6tsmpM
         lfwAu1jWSQOhIDMOROtJH0cIPesxVxtH7vuaLpzoh9kN1kCZBJUcxs7UVHoAoQnFGMdV
         0rcS7X3h90AaM5KUeEAztO+wpuqCOC2/elxevpcjaXiHaVk3JdJNNQcYD8B9sw4S9l7R
         e8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rpmkj25u0UX9OE/Iypuct9W0L/AwsgyiytycVOE8wf0=;
        b=BVuGu9AM5w/dzAKuTjjNV1sXY3sGWWOrpsIZk0Zi2Z6BwQ1rmvSomvtGpF3yF+u9yk
         jNKQgFcZxuSUqCQpJ7XWg6rKvvJdAadeTIxRSoDK7CszyrobeX93qwQGvDicuFyw48U8
         P1roGSgi5k8DkXEeACoFeUBQTulTya1cQIYW0lO18+aFn0UzD3N9GmI7JfGG0DQP+nTD
         GR4NEiY0F7uT+12uw8G8vXuF/V7u6bWOKwgiVFJGpqMv+aQJsK3VlcOuRV0WO39oU50m
         O1d2OcEldU33RvZZzmBHzyv0mu/n+SA7BQnJRpu5wv7gjXVElmRQA9IvNdnzREmq26m/
         aHNw==
X-Gm-Message-State: AOAM532nq2tQG6XLDQWG4HS8ICaxwoHrRJVT8EIibY1g7LupBHw+6I6Q
        2D0lDGoKp8i1BK+hlLNuSCE=
X-Google-Smtp-Source: ABdhPJwntwwgnjNOf1KqHXaePurY0spM/3JYEik5I6DjE8DhPSdLkpKCRnm8+D2+iMo2diWab1rrww==
X-Received: by 2002:a37:6503:: with SMTP id z3mr23189337qkb.330.1614029645401;
        Mon, 22 Feb 2021 13:34:05 -0800 (PST)
Received: from debian-vm ([189.120.76.30])
        by smtp.gmail.com with ESMTPSA id n7sm4192548qtr.91.2021.02.22.13.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 13:34:05 -0800 (PST)
From:   Igor <igormtorrente@gmail.com>
X-Google-Original-From: Igor <igor>
Date:   Mon, 22 Feb 2021 18:34:00 -0300
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
Message-ID: <YDQjSG6xjL8o9Y8M@debian-vm>
References: <20210222121019.444399883@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:12:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.18 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my machine(x86_64) without any dmesg regression.
My compilation uses the default Debian 10 .config(From kernel
4.19.0-14-amd64), followed by olddefconfig.

Tested-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>

Best regards
---
Igor Matheus Andrade Torrente

> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.18-rc1
> 
> Matwey V. Kornilov <matwey@sai.msu.ru>
>     media: pwc: Use correct device for DMA
> 
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix crash after non-aligned direct IO write with O_DSYNC
> 
> David Sterba <dsterba@suse.com>
>     btrfs: fix backport of 2175bf57dc952 in 5.10.13
> 
> Trent Piepho <tpiepho@gmail.com>
>     Bluetooth: btusb: Always fallback to alt 1 for WBS
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>     tty: protect tty_write from odd low-level tty disciplines
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-blkback: fix error handling in xen_blkbk_map()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-scsiback: don't "handle" error by BUG()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-netback: don't "handle" error by BUG()
> 
> Jan Beulich <jbeulich@suse.com>
>     xen-blkback: don't "handle" error by BUG()
> 
> Stefano Stabellini <stefano.stabellini@xilinx.com>
>     xen/arm: don't ignore return errors from set_phys_to_machine
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/gntdev: correct error checking in gntdev_map_grant_pages()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
> 
> Jan Beulich <jbeulich@suse.com>
>     Xen/x86: don't bail early from clear_foreign_p2m_mapping()
> 
> Yonatan Linik <yonatanlinik@gmail.com>
>     net: fix proc_fs init handling in af_packet and tls
> 
> Wang Hai <wanghai38@huawei.com>
>     net: bridge: Fix a warning when del bridge sysfs
> 
> Eelco Chaudron <echaudro@redhat.com>
>     net: openvswitch: fix TTL decrement exception action execution
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     net: sched: incorrect Kconfig dependencies on Netfilter modules
> 
> Lorenzo Bianconi <lorenzo@kernel.org>
>     mt76: mt7615: fix rdd mcu cmd endianness
> 
> Felix Fietkau <nbd@nbd.name>
>     mt76: mt7915: fix endian issues
> 
> wenxu <wenxu@ucloud.cn>
>     net/sched: fix miss init the mru in qdisc_skb_cb
> 
> Florian Westphal <fw@strlen.de>
>     mptcp: skip to next candidate if subflow has unacked data
> 
> Loic Poulain <loic.poulain@linaro.org>
>     net: qrtr: Fix port ID for control messages
> 
> Max Gurtovoy <mgurtovoy@nvidia.com>
>     IB/isert: add module param to set sg_tablesize for IO cmd
> 
> Stefano Garzarella <sgarzare@redhat.com>
>     vdpa_sim: add get_config callback in vdpasim_dev_attr
> 
> Stefano Garzarella <sgarzare@redhat.com>
>     vdpa_sim: make 'config' generic and usable for any device type
> 
> Stefano Garzarella <sgarzare@redhat.com>
>     vdpa_sim: store parsed MAC address in a buffer
> 
> Stefano Garzarella <sgarzare@redhat.com>
>     vdpa_sim: add struct vdpasim_dev_attr for device attributes
> 
> Max Gurtovoy <mgurtovoy@nvidia.com>
>     vdpa_sim: remove hard-coded virtq count
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                        |  4 +-
>  arch/arm/xen/p2m.c                              |  6 +-
>  arch/x86/xen/p2m.c                              | 15 ++---
>  drivers/block/xen-blkback/blkback.c             | 32 +++++----
>  drivers/bluetooth/btusb.c                       | 20 ++----
>  drivers/infiniband/ulp/isert/ib_isert.c         | 27 +++++++-
>  drivers/infiniband/ulp/isert/ib_isert.h         |  6 ++
>  drivers/media/usb/pwc/pwc-if.c                  | 22 +++---
>  drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 89 ++++++++++++++++++-------
>  drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 87 ++++++++++++++++++------
>  drivers/net/xen-netback/netback.c               |  4 +-
>  drivers/tty/tty_io.c                            |  5 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c                | 83 ++++++++++++++++-------
>  drivers/xen/gntdev.c                            | 37 +++++-----
>  drivers/xen/xen-scsiback.c                      |  4 +-
>  fs/btrfs/ctree.h                                |  6 +-
>  fs/btrfs/inode.c                                |  6 +-
>  include/xen/grant_table.h                       |  1 +
>  net/bridge/br.c                                 |  5 +-
>  net/core/dev.c                                  |  2 +
>  net/mptcp/protocol.c                            |  5 +-
>  net/openvswitch/actions.c                       | 15 ++---
>  net/packet/af_packet.c                          |  2 +
>  net/qrtr/qrtr.c                                 |  2 +-
>  net/sched/Kconfig                               |  6 +-
>  net/tls/tls_proc.c                              |  3 +
>  26 files changed, 337 insertions(+), 157 deletions(-)
> 
> 

