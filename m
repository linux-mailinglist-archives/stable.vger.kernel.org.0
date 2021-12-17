Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8412E4788A1
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 11:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhLQKVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 05:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbhLQKVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 05:21:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D033C061574;
        Fri, 17 Dec 2021 02:21:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45A62B82786;
        Fri, 17 Dec 2021 10:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805DDC36AE5;
        Fri, 17 Dec 2021 10:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639736461;
        bh=2teeFR2yBHydQbTTji8WNKKuU3muuq8kxiUQqfKibPM=;
        h=From:To:Cc:Subject:Date:From;
        b=oolcDwbf+5N65JdL6ltHflrYCGqF51rUsLvpmjIbbh6ofeOg9LLVWnV9q5RGkilLK
         f8eM/bU9iaF1TaQsvxG8lvqq7g9p/W7AMwBc2jNre3c+trIlIHRMSKDsRmCR0S7aiS
         sKaWpwBJbk+O11rz57Ntjyz5L6BTR3Jmffr0Y20s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.167
Date:   Fri, 17 Dec 2021 11:20:57 +0100
Message-Id: <16397364573237@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.167 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/mm/init.c                                    |   37 ++--
 arch/arm/mm/ioremap.c                                 |    4 
 arch/x86/kvm/hyperv.c                                 |    7 
 drivers/char/agp/parisc-agp.c                         |    6 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c |    8 
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c     |    4 
 drivers/gpu/drm/msm/dsi/dsi_host.c                    |    2 
 drivers/hwmon/dell-smm-hwmon.c                        |    7 
 drivers/i2c/busses/i2c-rk3x.c                         |    4 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c       |    6 
 kernel/bpf/devmap.c                                   |    4 
 kernel/trace/tracing_map.c                            |    3 
 mm/memblock.c                                         |    3 
 net/core/sock_map.c                                   |    2 
 net/netlink/af_netlink.c                              |    5 
 net/nfc/netlink.c                                     |    6 
 security/selinux/ss/services.c                        |  159 +++++++++---------
 18 files changed, 165 insertions(+), 104 deletions(-)

Armin Wolf (1):
      hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Bui Quang Minh (1):
      bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc

Chen Jun (1):
      tracing: Fix a kmemleak false positive in tracing_map

Erik Ekman (1):
      net/mlx4_en: Update reported link modes for 1/10G

Greg Kroah-Hartman (1):
      Linux 5.4.167

Harshit Mogalapalli (1):
      net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Helge Deller (1):
      parisc/agp: Annotate parisc agp init functions with __init

Mike Rapoport (5):
      memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER
      memblock: align freed memory map on pageblock boundaries with SPARSEMEM
      memblock: ensure there is no overflow in memblock_overlaps_region()
      arm: extend pfn_valid to take into account freed memory map alignment
      arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM

Mustapha Ghaddar (1):
      drm/amd/display: Fix for the no Audio bug with Tiled Displays

Ondrej Jirman (1):
      i2c: rk3x: Handle a spurious start completion interrupt flag

Ondrej Mosnacek (1):
      selinux: fix race condition when computing ocontext SIDs

Perry Yuan (1):
      drm/amd/display: add connector type check for CRC source set

Philip Chen (1):
      drm/msm/dsi: set default num_data_lanes

Sean Christopherson (1):
      KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req

Tadeusz Struk (1):
      nfc: fix segfault in nfc_genl_dump_devices_done

