Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F1E1CD916
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 13:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgEKL4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 07:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729909AbgEKL4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 07:56:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31893206F5;
        Mon, 11 May 2020 11:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589198193;
        bh=6hkPqUfE/A52mAHI4n5dRpGiROlJaXK2p0PZhJDcAPo=;
        h=Subject:To:Cc:From:Date:From;
        b=zuTfb1hZIeHsL2p+g+//+P3k87j3Yc2PUmudv7+0f2Ldp8bnXfTFdZrbcutczouo0
         XqYLIgqV2be0ALohS23GJ1Mjg4kRD1n5/LjMiyy0+L0SRSeJbVzt9SanRlaByKpV8g
         Hstv27jTsKYwo387mmPN2yBpGGR3VVUDxvRTHNGE=
Subject: Linux 5.6.12
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon, 11 May 2020 13:56:23 +0200
Message-ID: <1589198183975@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.6.12 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/x86/kvm/vmx/ops.h                                |    1 
 drivers/acpi/sleep.c                                  |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                |    3 
 drivers/gpu/drm/amd/powerplay/hwmgr/processpptables.c |   26 ++++
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c            |    7 -
 drivers/gpu/drm/bridge/analogix/analogix-anx6345.c    |    3 
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c    |   33 +++--
 drivers/gpu/drm/exynos/exynos_dp.c                    |   29 ++--
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c       |   36 ++---
 drivers/net/ethernet/broadcom/bcmsysport.c            |    3 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c   |    9 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |   12 +
 drivers/net/phy/bcm84881.c                            |    6 
 drivers/net/wimax/i2400m/usb-fw.c                     |    1 
 drivers/platform/x86/gpd-pocket-fan.c                 |    2 
 drivers/remoteproc/qcom_q6v5_mss.c                    |    2 
 drivers/scsi/sg.c                                     |    4 
 drivers/usb/dwc3/core.h                               |    4 
 drivers/usb/dwc3/gadget.c                             |   52 ++++++--
 drivers/vhost/vsock.c                                 |    5 
 fs/cifs/connect.c                                     |    6 
 include/drm/bridge/analogix_dp.h                      |    5 
 include/linux/ieee80211.h                             |    9 +
 kernel/trace/ftrace.c                                 |    1 
 kernel/trace/trace_events_hist.c                      |    7 +
 lib/mpi/longlong.h                                    |   34 ++---
 mm/mremap.c                                           |   10 +
 net/core/netclassid_cgroup.c                          |    4 
 net/mac80211/mlme.c                                   |    2 
 net/mac80211/rx.c                                     |    8 -
 net/mac80211/sta_info.c                               |    3 
 net/mac80211/status.c                                 |    5 
 net/mac80211/tx.c                                     |    2 
 net/sctp/sm_make_chunk.c                              |    6 
 net/sunrpc/cache.c                                    |    5 
 scripts/config                                        |    5 
 sound/pci/hda/hda_intel.c                             |    9 -
 sound/soc/codecs/hdac_hdmi.c                          |    6 
 sound/soc/codecs/sgtl5000.c                           |   34 +++++
 sound/soc/codecs/sgtl5000.h                           |    1 
 sound/soc/sh/rcar/ssi.c                               |   11 +
 sound/soc/sh/rcar/ssiu.c                              |    2 
 sound/soc/soc-topology.c                              |  115 +++++++++++++-----
 tools/bpf/runqslower/Makefile                         |    2 
 tools/testing/selftests/ipc/msgque.c                  |    2 
 tools/testing/selftests/tpm2/test_smoke.sh            |   13 --
 tools/testing/selftests/tpm2/test_space.sh            |    9 -
 tools/testing/selftests/vm/Makefile                   |    4 
 tools/testing/selftests/vm/run_vmtests                |    2 
 51 files changed, 401 insertions(+), 169 deletions(-)

Aaron Ma (1):
      drm/amdgpu: Fix oops when pp_funcs is unset in ACPI event

Alex Elder (1):
      remoteproc: qcom_q6v5_mss: fix a bug in q6v5_probe()

Amadeusz Sławiński (8):
      ASoC: topology: Add missing memory checks
      ASoC: topology: Check return value of soc_tplg_create_tlv
      ASoC: topology: Check return value of soc_tplg_*_create
      ASoC: topology: Check soc_tplg_add_route return value
      ASoC: topology: Check return value of pcm_new_ver
      ASoC: topology: Check return value of soc_tplg_dai_config
      ASoC: topology: Fix endianness issue
      ASoC: codecs: hdac_hdmi: Fix incorrect use of list_for_each_entry

Andrii Nakryiko (1):
      tools/runqslower: Ensure own vmlinux.h is picked up first

Doug Berger (2):
      net: bcmgenet: suppress warnings on failed Rx SKB allocations
      net: systemport: suppress warnings on failed Rx SKB allocations

Greg Kroah-Hartman (1):
      Linux 5.6.12

Hans de Goede (1):
      platform/x86: GPD pocket fan: Fix error message when temp-limits are out of range

Jarkko Sakkinen (1):
      Revert "Kernel selftests: tpm2: check for tpm support"

Jere Leppänen (1):
      sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Jeremie Francois (on alpha) (1):
      scripts/config: allow colons in option strings for sed

Jia He (1):
      vhost: vsock: kick send_pkt worker once device is started

Jiri Slaby (1):
      cgroup, netclassid: remove double cond_resched

Julien Beraud (2):
      net: stmmac: fix enabling socfpga's ptp_ref_clock
      net: stmmac: Fix sub-second increment

Madhuparna Bhowmik (1):
      mac80211: sta_info: Add lockdep condition for RCU list usage

Marek Szyprowski (1):
      drm/bridge: analogix_dp: Split bind() into probe() and real bind()

Matthias Blankertz (4):
      ASoC: rsnd: Fix parent SSI start/stop in multi-SSI mode
      ASoC: rsnd: Fix HDMI channel mapping for multi-SSI mode
      ASoC: rsnd: Don't treat master SSI in multi SSI setup as parent
      ASoC: rsnd: Fix "status check failed" spam for multi-SSI

Nathan Chancellor (1):
      lib/mpi: Fix building for powerpc with clang

Paulo Alcantara (1):
      cifs: do not share tcons with DFS

Prike Liang (1):
      drm/amd/powerplay: fix resume failed as smu table initialize early exit

Qian Cai (1):
      x86/kvm: fix a missing-prototypes "vmread_error"

Rafael J. Wysocki (1):
      ACPI: PM: s2idle: Fix comment in acpi_s2idle_prepare_late()

Ronnie Sahlberg (1):
      cifs: protect updating server->dstaddr with a spinlock

Russell King (1):
      net: phy: bcm84881: clear settings on link down

Sandeep Raghuraman (1):
      drm/amdgpu: Correctly initialize thermal controller for GPUs with Powerplay table v0 (e.g Hawaii)

Sandipan Das (2):
      selftests: vm: Do not override definition of ARCH
      selftests: vm: Fix 64-bit test builds for powerpc64le

Sebastian Reichel (1):
      ASoC: sgtl5000: Fix VAG power-on handling

Steven Rostedt (VMware) (1):
      ftrace: Fix memory leak caused by not freeing entry in unregister_ftrace_direct()

Takashi Iwai (1):
      ALSA: hda: Match both PCI ID and SSID for driver blacklist

Thinh Nguyen (1):
      usb: dwc3: gadget: Properly set maxpacket limit

Thomas Pedersen (1):
      mac80211: add ieee80211_is_any_nullfunc()

Tyler Hicks (1):
      selftests/ipc: Fix test failure seen after initial test run

Vamshi K Sthambamkadi (1):
      tracing: Fix memory leaks in trace_events_hist.c

Vasily Khoruzhick (1):
      drm/bridge: anx6345: set correct BPC for display_info of connector

Will Deacon (1):
      mm/mremap: Add comment explaining the untagging behaviour of mremap()

Wu Bo (1):
      scsi: sg: add sg_remove_request in sg_write

Xiyu Yang (1):
      wimax/i2400m: Fix potential urb refcnt leak

Yihao Wu (1):
      SUNRPC/cache: Fix unsafe traverse caused double-free in cache_purge

