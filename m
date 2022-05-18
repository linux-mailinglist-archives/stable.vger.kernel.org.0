Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0639052B559
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 11:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbiERIyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 04:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbiERIxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 04:53:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE33E134E07;
        Wed, 18 May 2022 01:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43D3BB81EF6;
        Wed, 18 May 2022 08:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657CCC385A5;
        Wed, 18 May 2022 08:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652864020;
        bh=MYxSF25RTdwiYQuzzPy7cGg1lE5WkyPnygiMnkzRoBY=;
        h=From:To:Cc:Subject:Date:From;
        b=j9lYQnAgm3IyzIrG0U5B5+TaoZOG2bC6pTvonUuchFj8N2RwB2QEFPoPpvy48boXd
         EsRfD8Ssx9U39Ktsc6+9O1pYu+Q7zQjBuPTQnFOx3/e39vafSyC5pG2vvfkQFbcdhS
         Vn1qANQkQhZsU3YZtJDP+UVGLQlbGVOqLdFqQSYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.17.9
Date:   Wed, 18 May 2022 10:53:23 +0200
Message-Id: <165286400328164@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.17.9 kernel.

All users of the 5.17 kernel series must upgrade.

The updated 5.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.17.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm/include/asm/io.h                            |    3 
 arch/arm/mm/ioremap.c                                |    8 ++
 arch/arm64/include/asm/io.h                          |    4 +
 arch/arm64/kernel/Makefile                           |    4 +
 arch/arm64/kernel/vdso/Makefile                      |    3 
 arch/arm64/kernel/vdso32/Makefile                    |    3 
 arch/arm64/mm/ioremap.c                              |    8 ++
 arch/powerpc/kvm/book3s_32_sr.S                      |   26 +++++-
 arch/s390/Makefile                                   |   10 ++
 arch/x86/mm/init_64.c                                |    5 -
 drivers/base/firmware_loader/main.c                  |   17 ++++
 drivers/dma-buf/dma-buf.c                            |    8 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c            |    8 --
 drivers/gpu/drm/nouveau/nouveau_backlight.c          |    9 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c   |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                       |    1 
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c                  |   13 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                  |    8 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                   |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c                |   28 +++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c                  |   26 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                  |    8 +-
 drivers/hwmon/Kconfig                                |    2 
 drivers/hwmon/asus_wmi_sensors.c                     |    2 
 drivers/hwmon/f71882fg.c                             |    5 -
 drivers/hwmon/tmp401.c                               |   11 ++
 drivers/infiniband/hw/irdma/cm.c                     |    7 -
 drivers/interconnect/core.c                          |    8 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c         |   30 ++++++++
 drivers/net/dsa/bcm_sf2.c                            |    3 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c |    4 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c       |    4 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c           |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c          |   27 +++----
 drivers/net/ethernet/intel/ice/ice.h                 |    1 
 drivers/net/ethernet/intel/ice/ice_idc.c             |   25 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c            |    2 
 drivers/net/ethernet/intel/ice/ice_ptp.c             |   10 ++
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c     |   68 +++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_ppe.c              |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c  |   11 --
 drivers/net/ethernet/mscc/ocelot_flower.c            |    5 -
 drivers/net/ethernet/mscc/ocelot_vcap.c              |    9 ++
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c  |    3 
 drivers/net/ethernet/sfc/ef10.c                      |    5 +
 drivers/net/ethernet/sfc/efx_channels.c              |    7 +
 drivers/net/ethernet/sfc/ptp.c                       |   14 +++
 drivers/net/ethernet/sfc/ptp.h                       |    1 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c        |   15 ----
 drivers/net/phy/micrel.c                             |    7 +
 drivers/net/phy/phy.c                                |    7 +
 drivers/net/phy/sfp.c                                |   12 ++-
 drivers/net/wireless/ath/ath11k/core.c               |    1 
 drivers/net/wireless/ath/ath11k/core.h               |   13 ++-
 drivers/net/wireless/ath/ath11k/mac.c                |   71 +++++++------------
 drivers/net/wireless/ath/ath11k/mac.h                |    2 
 drivers/net/wireless/ath/ath11k/reg.c                |   43 +++++++----
 drivers/net/wireless/ath/ath11k/reg.h                |    2 
 drivers/net/wireless/ath/ath11k/wmi.c                |   16 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c     |    2 
 drivers/net/wireless/mac80211_hwsim.c                |    3 
 drivers/platform/surface/aggregator/core.c           |    2 
 drivers/s390/net/ctcm_mpc.c                          |    6 -
 drivers/s390/net/ctcm_sysfs.c                        |    5 -
 drivers/s390/net/lcs.c                               |    7 +
 drivers/slimbus/qcom-ctrl.c                          |    4 -
 drivers/tty/n_gsm.c                                  |   20 +++--
 drivers/tty/serial/8250/8250_mtk.c                   |   22 +++--
 drivers/tty/serial/digicolor-usart.c                 |    5 -
 drivers/tty/serial/fsl_lpuart.c                      |   18 ++--
 drivers/usb/class/cdc-wdm.c                          |    1 
 drivers/usb/gadget/function/f_uvc.c                  |   25 ++++++
 drivers/usb/gadget/function/uvc.h                    |    2 
 drivers/usb/gadget/function/uvc_v4l2.c               |    3 
 drivers/usb/host/xhci-mtk-sch.c                      |   16 +---
 drivers/usb/serial/option.c                          |    4 +
 drivers/usb/serial/pl2303.c                          |    1 
 drivers/usb/serial/pl2303.h                          |    1 
 drivers/usb/serial/qcserial.c                        |    2 
 drivers/usb/typec/tcpm/tcpci.c                       |    2 
 drivers/usb/typec/tcpm/tcpci_mt6360.c                |   26 ++++++
 drivers/video/fbdev/efifb.c                          |    9 ++
 drivers/video/fbdev/simplefb.c                       |    8 +-
 drivers/video/fbdev/vesafb.c                         |    8 +-
 fs/ceph/file.c                                       |   16 +++-
 fs/fs-writeback.c                                    |    4 +
 fs/gfs2/bmap.c                                       |   11 +-
 fs/io_uring.c                                        |    7 +
 fs/nfs/fs_context.c                                  |    2 
 fs/notify/fanotify/fanotify_user.c                   |   13 +++
 fs/proc/fd.c                                         |   23 +++++-
 include/linux/bio.h                                  |    5 +
 include/linux/netdev_features.h                      |    4 -
 include/linux/sunrpc/clnt.h                          |    1 
 include/net/inet_hashtables.h                        |    2 
 include/net/secure_seq.h                             |    4 -
 include/net/tc_act/tc_pedit.h                        |    1 
 include/uapi/linux/virtio_ids.h                      |   14 +--
 kernel/cgroup/cpuset.c                               |    7 +
 kernel/irq/irqdesc.c                                 |    1 
 lib/dim/net_dim.c                                    |   44 +++++------
 mm/huge_memory.c                                     |    7 +
 mm/kfence/core.c                                     |   11 ++
 mm/memory-failure.c                                  |   15 ----
 mm/mremap.c                                          |    2 
 net/batman-adv/fragmentation.c                       |   11 ++
 net/core/secure_seq.c                                |   16 ++--
 net/dsa/port.c                                       |    1 
 net/ipv4/inet_hashtables.c                           |   42 +++++++----
 net/ipv4/ping.c                                      |   12 ++-
 net/ipv4/route.c                                     |    1 
 net/ipv6/inet6_hashtables.c                          |    4 -
 net/mac80211/mlme.c                                  |    6 +
 net/netlink/af_netlink.c                             |    1 
 net/rds/tcp.c                                        |   12 ++-
 net/rds/tcp.h                                        |    2 
 net/rds/tcp_connect.c                                |    5 +
 net/rds/tcp_listen.c                                 |    5 +
 net/sched/act_pedit.c                                |   26 +++++-
 net/smc/smc_rx.c                                     |    4 -
 net/sunrpc/auth_gss/gss_rpc_upcall.c                 |    1 
 net/sunrpc/clnt.c                                    |   33 ++++++++
 net/tls/tls_device.c                                 |    3 
 sound/soc/codecs/max98090.c                          |    5 +
 sound/soc/soc-ops.c                                  |   18 ++++
 sound/soc/sof/sof-pci-dev.c                          |    5 +
 tools/perf/tests/shell/test_arm_coresight.sh         |    1 
 tools/testing/selftests/vm/Makefile                  |   10 +-
 129 files changed, 912 insertions(+), 379 deletions(-)

Adrian-Ken Rueegsegger (1):
      x86/mm: Fix marking of unused sub-pmd ranges

Ajit Kumar Pandey (1):
      ASoC: SOF: Fix NULL pointer exception in sof_pci_probe callback

Alex Deucher (1):
      Revert "drm/amd/pm: keep the BACO feature enabled for suspend"

Alexander Graf (1):
      KVM: PPC: Book3S PR: Enable MSR_DR for switch_mmu_context()

Alexandra Winter (3):
      s390/ctcm: fix variable dereferenced before check
      s390/ctcm: fix potential memory leak
      s390/lcs: fix variable dereferenced before check

Amir Goldstein (1):
      fanotify: do not allow setting dirent events in mask of non-dir

Amit Cohen (1):
      mlxsw: Avoid warning during ip6gre device removal

Anatolii Gerasymenko (1):
      ice: clear stale Tx queue settings before configuring

Andreas Gruenbacher (1):
      gfs2: Fix filesystem block deallocation for short writes

AngeloGioacchino Del Regno (2):
      serial: 8250_mtk: Fix UART_EFR register address
      serial: 8250_mtk: Fix register address for XON/XOFF character

Ashish Mhetre (1):
      iommu: arm-smmu: disable large page mappings for Nvidia arm-smmu

Camel Guo (1):
      hwmon: (tmp401) Add OF device ID table

Charan Teja Reddy (1):
      dma-buf: call dma_buf_stats_setup after dmabuf is in valid list

ChiYuan Huang (1):
      usb: typec: tcpci_mt6360: Update for BMC PHY setting

Christophe JAILLET (1):
      drm/nouveau: Fix a potential theorical leak in nouveau_get_backlight_name()

Chunfeng Yun (1):
      usb: xhci-mtk: fix fs isoc's transfer error

Dan Aloni (1):
      nfs: fix broken handling of the softreval mount option

Dan Vacura (1):
      usb: gadget: uvc: allow for application to cleanly shutdown

Daniel Starke (3):
      tty: n_gsm: fix buffer over-read in gsm_dlci_data()
      tty: n_gsm: fix mux activation issues in gsm_config()
      tty: n_gsm: fix invalid gsmtty_write_room() result

Denis Pauk (1):
      hwmon: (asus_wmi_sensors) Fix CROSSHAIR VI HERO name

Duoming Zhou (1):
      RDMA/irdma: Fix deadlock in irdma_cleanup_cm_core()

Eric Dumazet (2):
      netlink: do not reset transport header in netlink_recvmsg()
      tcp: resalt the secret every 10 seconds

Ethan Yang (1):
      USB: serial: qcserial: add support for Sierra Wireless EM7590

Fabio Estevam (2):
      net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
      net: phy: micrel: Pass .probe for KS8737

Florian Fainelli (2):
      net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral
      net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()

Francesco Dolcini (1):
      net: phy: Fix race condition on link status change

Greg Kroah-Hartman (1):
      Linux 5.17.9

Guangguan Wang (1):
      net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending

Guenter Roeck (1):
      iwlwifi: iwl-dbg: Use del_timer_sync() before freeing

Hui Tang (1):
      drm/vc4: hdmi: Fix build error for implicit function declaration

Hyeonggon Yoo (1):
      mm/kfence: reset PG_slab and memcg_data before freeing __kfence_pool

Indan Zupancic (1):
      fsl_lpuart: Don't enable interrupts too early

Ivan Vecera (1):
      ice: Fix race during aux device (un)plugging

Javier Martinez Canillas (4):
      fbdev: simplefb: Cleanup fb_info in .fb_destroy rather than .remove
      fbdev: efifb: Cleanup fb_info in .fb_destroy rather than .remove
      fbdev: vesafb: Cleanup fb_info in .fb_destroy rather than .remove
      fbdev: efifb: Fix a use-after-free due early fb_info cleanup

Jeff Layton (1):
      ceph: fix setting of xattrs on async created inodes

Jens Axboe (1):
      io_uring: assign non-fixed early for async work

Jeremy Linton (1):
      perf tests: Fix coresight `perf test` failure.

Jesse Brandeburg (1):
      dim: initialize all struct fields

Ji-Ze Hong (Peter Hong) (1):
      hwmon: (f71882fg) Fix negative temperature

Jing Xia (1):
      writeback: Avoid skipping inode writeback

Joel Savitz (1):
      selftests: vm: Makefile: rename TARGETS to VMTARGETS

Joey Gouly (1):
      arm64: vdso: fix makefile dependency on vdso.so

Johannes Berg (1):
      mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection

Kalesh Singh (1):
      procfs: prevent unprivileged processes accessing fdinfo dir

Kees Cook (1):
      net: chelsio: cxgb4: Avoid potential negative array offset

Lokesh Dhoundiyal (1):
      ipv4: drop dst in multicast routing path

Lukas Wunner (1):
      genirq: Remove WARN_ON_ONCE() in generic_handle_domain_irq()

Manikanta Pubbisetty (1):
      mac80211: Reset MBSSID parameters upon connection

Manuel Ullmann (1):
      net: atlantic: always deep reset on pm op, fixing up my null deref regression

Mark Brown (3):
      ASoC: max98090: Reject invalid values in custom control put()
      ASoC: max98090: Generate notifications on changes for custom control
      ASoC: ops: Validate input values in snd_soc_put_volsw_range()

Matthew Hagan (1):
      net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT

Matthew Wilcox (Oracle) (1):
      block: Do not call folio_next() on an unreferenced folio

Maxim Mikityanskiy (1):
      tls: Fix context leak on tls_device_down

Maximilian Luz (1):
      platform/surface: aggregator: Fix initialization order when compiling as builtin module

Miaoqian Lin (1):
      slimbus: qcom: Fix IRQ check in qcom_slim_probe

Michal Michalik (1):
      ice: fix PTP stale Tx timestamps cleanup

Mike Rapoport (1):
      arm[64]/memremap: don't abuse pfn_valid() to ensure presence of linear map

Naoya Horiguchi (1):
      mm/hwpoison: use pr_err() instead of dump_page() in get_any_page()

Nicolas Dichtel (1):
      ping: fix address binding wrt vrf

Niels Dossche (1):
      mm: mremap: fix sign for EFAULT error return value

Paolo Abeni (1):
      net/sched: act_pedit: really ensure the skb is writable

Randy Dunlap (1):
      hwmon: (ltq-cputemp) restrict it to SOC_XWAY

Robin Murphy (1):
      drm/nouveau/tegra: Stop using iommu_present()

Scott Chen (1):
      USB: serial: pl2303: add device id for HP LM930 Display

Sergey Ryazanov (1):
      usb: cdc-wdm: fix reading stuck on device close

Shravya Kumbham (1):
      net: emaclite: Don't advertise 1000BASE-T and do auto negotiation

Shunsuke Mie (1):
      virtio: fix virtio transitional ids

Stephen Boyd (1):
      interconnect: Restore sync state by ignoring ipa-virt in provider count

Sven Eckelmann (1):
      batman-adv: Don't skb_split skbuffs with frag_list

Sven Schnelle (1):
      s390: disable -Warray-bounds

Sven Schwermer (2):
      USB: serial: option: add Fibocom L610 modem
      USB: serial: option: add Fibocom MA510 modem

Taehee Yoo (2):
      net: sfc: fix memory leak due to ptp channel
      net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Tariq Toukan (1):
      net: Fix features skip in for_each_netdev_feature()

Tetsuo Handa (1):
      net: rds: use maybe_get_net() when acquiring refcount on TCP sockets

Thiébaud Weksteen (1):
      firmware_loader: use kernel credentials when reading firmware

Trond Myklebust (1):
      SUNRPC: Ensure that the gssproxy client can start in a connected state

Uwe Kleine-König (1):
      usb: typec: tcpci: Don't skip cleanup in .remove() on error

Vladimir Oltean (5):
      net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
      net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
      net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
      net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters
      net: dsa: flush switchdev workqueue on bridge join error path

Waiman Long (1):
      cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()

Wan Jiabing (1):
      net: phy: micrel: Fix incorrect variable type in micrel

Wen Gong (1):
      ath11k: reduce the wait time of 11d scan and hw scan while add interface

Willy Tarreau (6):
      secure_seq: use the 64 bits of the siphash for port offset calculation
      tcp: use different parts of the port_offset for index and offset
      tcp: add small random increments to the source port
      tcp: dynamically allocate the perturb table used by source ports
      tcp: increase source port perturb table to 2^16
      tcp: drop the hash_32() part from the index calculation

Xiaomeng Tong (1):
      i40e: i40e_main: fix a missing check on list iterator

Xu Yu (2):
      Revert "mm/memory-failure.c: skip huge_zero_page in memory_failure()"
      mm/huge_memory: do not overkill when splitting huge_zero_page

Yang Yingliang (3):
      ionic: fix missing pci_release_regions() on error in ionic_probe()
      net: ethernet: mediatek: ppe: fix wrong size passed to memset()
      tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()

Zack Rusin (3):
      drm/vmwgfx: Fix fencing on SVGAv3
      drm/vmwgfx: Disable command buffers on svga3 without gbobjects
      drm/vmwgfx: Initialize drm_mode_fb_cmd2

