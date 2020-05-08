Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6545E1CAC73
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgEHMx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730084AbgEHMx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:53:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A9E924953;
        Fri,  8 May 2020 12:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942406;
        bh=5zSN6v0jILkcNRA64tLyKzZRiwo6FQPYJa2cHL83tGo=;
        h=From:To:Cc:Subject:Date:From;
        b=hotlcAYt0iX+2xsvdvK9nhnfLVZpXnsFgml49DYDpoRBkoR+sqDRNCmku+bIptzlC
         oVEpXEHDSg96mUiz5+VN8wec9/NtrM+H+4O+lbZhZmLYQutGgyG9OpoQDww6hv4gVL
         MImhkT8xLei7S+zhscS37mHfmSo/98jFhg4R14CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/50] 5.4.40-rc1 review
Date:   Fri,  8 May 2020 14:35:06 +0200
Message-Id: <20200508123043.085296641@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.40-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.40-rc1
X-KernelTest-Deadline: 2020-05-10T12:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.40 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.40-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.40-rc1

Marek Szyprowski <m.szyprowski@samsung.com>
    PM / devfreq: Add missing locking while setting suspend_freq

Willem de Bruijn <willemb@google.com>
    udp: document udp_rcv_segment special case for looped packets

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers UAPI: Sync copy of arm64's asm/unistd.h with the kernel sources

Zhan Liu <Zhan.Liu@amd.com>
    Revert "drm/amd/display: setting the DIG_MODE to the correct value."

Will Deacon <will@kernel.org>
    mm/mremap: Add comment explaining the untagging behaviour of mremap()

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    libbpf: Fix readelf output parsing for Fedora

Jiri Slaby <jslaby@suse.cz>
    cgroup, netclassid: remove double cond_resched

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: add ieee80211_is_any_nullfunc()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Fix comment in acpi_s2idle_prepare_late()

Hans de Goede <hdegoede@redhat.com>
    platform/x86: GPD pocket fan: Fix error message when temp-limits are out of range

Christoph Hellwig <hch@lst.de>
    dma-direct: exclude dma_direct_map_resource from the min_low_pfn check

Qian Cai <cai@lca.pw>
    x86/kvm: fix a missing-prototypes "vmread_error"

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Match both PCI ID and SSID for driver blacklist

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: define ioremap_uc

Christoph Hellwig <hch@lst.de>
    hexagon: clean up ioremap

Tuowen Zhao <ztuowen@gmail.com>
    mfd: intel-lpss: Use devm_ioremap_uc for MMIO

Tuowen Zhao <ztuowen@gmail.com>
    lib: devres: add a helper function for ioremap_uc

Brendan Higgins <brendanhiggins@google.com>
    Revert "software node: Simplify software_node_release() function"

Aaron Ma <aaron.ma@canonical.com>
    drm/amdgpu: Fix oops when pp_funcs is unset in ACPI event

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Extend WaDisableDARBFClkGating to icl,ehl,tgl

Doug Berger <opendmb@gmail.com>
    net: systemport: suppress warnings on failed Rx SKB allocations

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: suppress warnings on failed Rx SKB allocations

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mac80211: sta_info: Add lockdep condition for RCU list usage

Nathan Chancellor <natechancellor@gmail.com>
    lib/mpi: Fix building for powerpc with clang

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    tracing: Fix memory leaks in trace_events_hist.c

Paulo Alcantara <pc@cjr.nz>
    cifs: do not share tcons with DFS

Jeremie Francois (on alpha) <jeremie.francois@gmail.com>
    scripts/config: allow colons in option strings for sed

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: protect updating server->dstaddr with a spinlock

Matthias Blankertz <matthias.blankertz@cetitec.com>
    ASoC: rsnd: Fix "status check failed" spam for multi-SSI

Matthias Blankertz <matthias.blankertz@cetitec.com>
    ASoC: rsnd: Don't treat master SSI in multi SSI setup as parent

Julien Beraud <julien.beraud@orolia.com>
    net: stmmac: Fix sub-second increment

Julien Beraud <julien.beraud@orolia.com>
    net: stmmac: fix enabling socfpga's ptp_ref_clock

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    wimax/i2400m: Fix potential urb refcnt leak

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Correctly initialize thermal controller for GPUs with Powerplay table v0 (e.g Hawaii)

Alex Elder <elder@linaro.org>
    remoteproc: qcom_q6v5_mss: fix a bug in q6v5_probe()

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: codecs: hdac_hdmi: Fix incorrect use of list_for_each_entry

Matthias Blankertz <matthias.blankertz@cetitec.com>
    ASoC: rsnd: Fix HDMI channel mapping for multi-SSI mode

Matthias Blankertz <matthias.blankertz@cetitec.com>
    ASoC: rsnd: Fix parent SSI start/stop in multi-SSI mode

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Properly set maxpacket limit

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Fix endianness issue

Sebastian Reichel <sebastian.reichel@collabora.com>
    ASoC: sgtl5000: Fix VAG power-on handling

Tyler Hicks <tyhicks@linux.microsoft.com>
    selftests/ipc: Fix test failure seen after initial test run

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Check return value of soc_tplg_dai_config

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Check return value of pcm_new_ver

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Check soc_tplg_add_route return value

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Check return value of soc_tplg_*_create

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Check return value of soc_tplg_create_tlv

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/bridge: analogix_dp: Split bind() into probe() and real bind()

Jia He <justin.he@arm.com>
    vhost: vsock: kick send_pkt worker once device is started


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/hexagon/include/asm/io.h                      | 12 ++---
 arch/hexagon/kernel/hexagon_ksyms.c                |  2 +-
 arch/hexagon/mm/ioremap.c                          |  2 +-
 arch/x86/kernel/amd_gart_64.c                      |  4 +-
 arch/x86/kvm/vmx/ops.h                             |  1 +
 drivers/acpi/sleep.c                               |  5 +-
 drivers/base/swnode.c                              | 14 +++---
 drivers/devfreq/devfreq.c                          |  4 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |  3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  9 ----
 .../gpu/drm/amd/powerplay/hwmgr/processpptables.c  | 26 +++++++++++
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 33 +++++++++-----
 drivers/gpu/drm/exynos/exynos_dp.c                 | 29 +++++++-----
 drivers/gpu/drm/i915/display/intel_display.c       |  7 ++-
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c    | 36 ++++++++-------
 drivers/mfd/intel-lpss.c                           |  2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  9 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 12 +++--
 drivers/net/wimax/i2400m/usb-fw.c                  |  1 +
 drivers/platform/x86/gpd-pocket-fan.c              |  2 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |  2 +-
 drivers/usb/dwc3/core.h                            |  4 ++
 drivers/usb/dwc3/gadget.c                          | 52 ++++++++++++++++-----
 drivers/vhost/vsock.c                              |  5 ++
 drivers/xen/swiotlb-xen.c                          |  4 +-
 fs/cifs/connect.c                                  |  6 +++
 include/drm/bridge/analogix_dp.h                   |  5 +-
 include/linux/dma-direct.h                         |  5 +-
 include/linux/ieee80211.h                          |  9 ++++
 include/linux/io.h                                 |  2 +
 include/net/udp.h                                  |  7 +++
 kernel/dma/direct.c                                |  4 +-
 kernel/dma/swiotlb.c                               |  2 +-
 kernel/trace/trace_events_hist.c                   |  7 +++
 lib/devres.c                                       | 19 ++++++++
 lib/mpi/longlong.h                                 | 34 +++++++-------
 mm/mremap.c                                        | 10 ++++
 net/core/netclassid_cgroup.c                       |  4 +-
 net/mac80211/mlme.c                                |  2 +-
 net/mac80211/rx.c                                  |  8 ++--
 net/mac80211/sta_info.c                            |  3 +-
 net/mac80211/status.c                              |  5 +-
 net/mac80211/tx.c                                  |  2 +-
 net/sctp/sm_make_chunk.c                           |  6 ++-
 scripts/config                                     |  5 +-
 sound/pci/hda/hda_intel.c                          |  9 ++--
 sound/soc/codecs/hdac_hdmi.c                       |  6 +--
 sound/soc/codecs/sgtl5000.c                        | 34 ++++++++++++++
 sound/soc/codecs/sgtl5000.h                        |  1 +
 sound/soc/sh/rcar/ssi.c                            | 11 ++++-
 sound/soc/sh/rcar/ssiu.c                           |  2 +-
 sound/soc/soc-topology.c                           | 53 ++++++++++++++++------
 tools/arch/arm64/include/uapi/asm/unistd.h         |  1 +
 tools/lib/bpf/Makefile                             |  2 +
 tools/testing/selftests/ipc/msgque.c               |  2 +-
 58 files changed, 390 insertions(+), 166 deletions(-)


