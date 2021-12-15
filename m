Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DCF475F2A
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbhLOR2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43512 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343953AbhLOR0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45211B82032;
        Wed, 15 Dec 2021 17:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5291AC36AE2;
        Wed, 15 Dec 2021 17:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589211;
        bh=iq96+Oisq3hLwALZjatJrHKyYhwPIn4BaXsCypheb3s=;
        h=From:To:Cc:Subject:Date:From;
        b=Sp3jQKYvAwNUyrs3HaaYnsTmyNIIf7xwzDp2r5nDGEnr32ML4dHJXKsbqeGJ6BZMJ
         trEsT+MW/ucaoAtRssYEtFihYoVoX3ZmfomC84p8B0mO55Jd9L3doMPNCwZN5x2s47
         0rVCICnM4Zk80Prbt7Jy1Me1pPggqA4hmP6q9cr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/18] 5.4.166-rc1 review
Date:   Wed, 15 Dec 2021 18:21:21 +0100
Message-Id: <20211215172022.795825673@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.166-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.166-rc1
X-KernelTest-Deadline: 2021-12-17T17:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.166 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.166-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.166-rc1

Mike Rapoport <rppt@linux.ibm.com>
    arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM

Mike Rapoport <rppt@linux.ibm.com>
    arm: extend pfn_valid to take into account freed memory map alignment

Mike Rapoport <rppt@linux.ibm.com>
    memblock: ensure there is no overflow in memblock_overlaps_region()

Mike Rapoport <rppt@linux.ibm.com>
    memblock: align freed memory map on pageblock boundaries with SPARSEMEM

Mike Rapoport <rppt@linux.ibm.com>
    memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Bui Quang Minh <minhquangbui99@gmail.com>
    bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix race condition when computing ocontext SIDs

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req

Chen Jun <chenjun102@huawei.com>
    tracing: Fix a kmemleak false positive in tracing_map

Perry Yuan <Perry.Yuan@amd.com>
    drm/amd/display: add connector type check for CRC source set

Mustapha Ghaddar <mghaddar@amd.com>
    drm/amd/display: Fix for the no Audio bug with Tiled Displays

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Ondrej Jirman <megous@megous.com>
    i2c: rk3x: Handle a spurious start completion interrupt flag

Helge Deller <deller@gmx.de>
    parisc/agp: Annotate parisc agp init functions with __init

Erik Ekman <erik@kryo.se>
    net/mlx4_en: Update reported link modes for 1/10G

Philip Chen <philipchen@chromium.org>
    drm/msm/dsi: set default num_data_lanes

Tadeusz Struk <tadeusz.struk@linaro.org>
    nfc: fix segfault in nfc_genl_dump_devices_done


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mm/init.c                                 |  37 +++--
 arch/arm/mm/ioremap.c                              |   4 +-
 arch/x86/kvm/hyperv.c                              |   7 +-
 drivers/char/agp/parisc-agp.c                      |   6 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |   8 ++
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   4 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +
 drivers/hwmon/dell-smm-hwmon.c                     |   7 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   6 +-
 kernel/bpf/devmap.c                                |   4 +-
 kernel/trace/tracing_map.c                         |   3 +
 mm/memblock.c                                      |   3 +-
 net/core/sock_map.c                                |   2 +-
 net/netlink/af_netlink.c                           |   5 +
 net/nfc/netlink.c                                  |   6 +-
 security/selinux/ss/services.c                     | 159 +++++++++++----------
 18 files changed, 166 insertions(+), 105 deletions(-)


