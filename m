Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9980B640B53
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiLBQzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbiLBQzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE31D827C;
        Fri,  2 Dec 2022 08:55:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FF48B8220F;
        Fri,  2 Dec 2022 16:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595FFC433C1;
        Fri,  2 Dec 2022 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670000106;
        bh=zI7LY++3VzswJ9KqgXacUAfaNSXugMpIzNH4IupppSE=;
        h=From:To:Cc:Subject:Date:From;
        b=kXHtcF0GVpMyThPU2H/k+FqqLCHom88qddb8EVKL0lzDCE+Pxt24rc3Wtna8BkNrM
         u+Ey+9LhzaWvJOT4gvRWBhFsqRVlTP+PAOJleBaQjpEB7dpNULBu1pM78KSl4JkDJw
         i8ehrQLvMHhWpZThTH6NoiNfJwB8H3RkcxJbUcwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.157
Date:   Fri,  2 Dec 2022 17:55:03 +0100
Message-Id: <167000010318239@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.157 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/arm/boot/dts/am335x-pcm-953.dtsi                    |   28 
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi              |    9 
 arch/arm/boot/dts/imx6q-prti6q.dts                       |    4 
 arch/arm/mach-mxs/mach-mxs.c                             |    4 
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts      |    2 
 arch/arm64/include/asm/syscall_wrapper.h                 |    2 
 arch/mips/include/asm/fw/fw.h                            |    2 
 arch/mips/pic32/pic32mzda/early_console.c                |   13 
 arch/mips/pic32/pic32mzda/init.c                         |    2 
 arch/nios2/boot/Makefile                                 |    2 
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts      |   38 +
 arch/riscv/kernel/vdso/Makefile                          |    3 
 arch/riscv/kernel/vdso/vdso.lds.S                        |    2 
 arch/s390/kernel/crash_dump.c                            |    2 
 arch/x86/kvm/svm/svm.c                                   |   16 
 arch/x86/mm/ioremap.c                                    |    8 
 block/bfq-cgroup.c                                       |    4 
 drivers/android/binder.c                                 |  437 +++++++++++++--
 drivers/ata/libata-scsi.c                                |   55 +
 drivers/bus/sunxi-rsb.c                                  |   29 
 drivers/dma-buf/dma-heap.c                               |   28 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                  |    8 
 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c  |    3 
 drivers/gpu/drm/drm_dp_dual_mode_helper.c                |   51 -
 drivers/gpu/drm/drm_panel_orientation_quirks.c           |    6 
 drivers/gpu/drm/i915/gt/intel_gt.c                       |    4 
 drivers/gpu/drm/tegra/drm.c                              |    4 
 drivers/gpu/host1x/dev.c                                 |    4 
 drivers/hv/channel_mgmt.c                                |    6 
 drivers/hv/vmbus_drv.c                                   |    1 
 drivers/iio/industrialio-sw-trigger.c                    |    6 
 drivers/iio/light/apds9960.c                             |   12 
 drivers/iio/pressure/ms5611.h                            |   18 
 drivers/iio/pressure/ms5611_core.c                       |   56 -
 drivers/iio/pressure/ms5611_i2c.c                        |   11 
 drivers/iio/pressure/ms5611_spi.c                        |   17 
 drivers/input/misc/soc_button_array.c                    |   14 
 drivers/input/mouse/synaptics.c                          |    1 
 drivers/input/touchscreen/goodix.c                       |   11 
 drivers/irqchip/irq-gic-v3-its.c                         |    2 
 drivers/md/dm-integrity.c                                |   20 
 drivers/mmc/host/sdhci-brcmstb.c                         |   68 +-
 drivers/net/arcnet/arc-rimi.c                            |    4 
 drivers/net/arcnet/arcdevice.h                           |    6 
 drivers/net/arcnet/arcnet.c                              |   66 ++
 drivers/net/arcnet/com20020-isa.c                        |    4 
 drivers/net/arcnet/com20020-pci.c                        |    2 
 drivers/net/arcnet/com20020_cs.c                         |   13 
 drivers/net/arcnet/com90io.c                             |    4 
 drivers/net/arcnet/com90xx.c                             |    4 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c        |   12 
 drivers/net/ethernet/cavium/liquidio/lio_main.c          |    4 
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c        |    4 
 drivers/net/ethernet/freescale/enetc/enetc.c             |   32 -
 drivers/net/ethernet/freescale/enetc/enetc.h             |   10 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c          |    6 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c         |   83 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c              |    3 
 drivers/net/ethernet/mellanox/mlx4/qp.c                  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c            |    6 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    2 
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c         |    2 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c     |    3 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c     |    6 
 drivers/net/ethernet/qlogic/qla3xxx.c                    |    1 
 drivers/net/ethernet/sfc/ef100_netdev.c                  |    1 
 drivers/net/macsec.c                                     |   28 
 drivers/net/usb/qmi_wwan.c                               |    1 
 drivers/net/wireless/cisco/airo.c                        |   18 
 drivers/net/wireless/mac80211_hwsim.c                    |    5 
 drivers/net/wireless/microchip/wilc1000/cfg80211.c       |   40 +
 drivers/net/wireless/microchip/wilc1000/hif.c            |   21 
 drivers/nfc/st-nci/se.c                                  |    6 
 drivers/nvme/host/pci.c                                  |    4 
 drivers/platform/x86/acer-wmi.c                          |    9 
 drivers/platform/x86/asus-wmi.c                          |    2 
 drivers/platform/x86/hp-wmi.c                            |    3 
 drivers/platform/x86/touchscreen_dmi.c                   |   25 
 drivers/regulator/core.c                                 |    8 
 drivers/regulator/twl6030-regulator.c                    |    2 
 drivers/s390/block/dasd_eckd.c                           |    6 
 drivers/scsi/ibmvscsi/ibmvfc.c                           |   14 
 drivers/scsi/scsi_debug.c                                |    7 
 drivers/scsi/scsi_transport_sas.c                        |   13 
 drivers/scsi/storvsc_drv.c                               |   69 +-
 drivers/spi/spi-dw-dma.c                                 |    3 
 drivers/spi/spi-stm32.c                                  |    2 
 drivers/tee/optee/device.c                               |    2 
 drivers/tty/serial/8250/8250_omap.c                      |    7 
 drivers/usb/cdns3/core.c                                 |   24 
 drivers/usb/cdns3/core.h                                 |    5 
 drivers/usb/cdns3/drd.c                                  |  101 ++-
 drivers/usb/cdns3/drd.h                                  |   67 +-
 drivers/usb/dwc3/dwc3-exynos.c                           |   11 
 drivers/usb/dwc3/gadget.c                                |   22 
 drivers/xen/platform-pci.c                               |    7 
 drivers/xen/xen-pciback/conf_space_capability.c          |    9 
 fs/btrfs/ioctl.c                                         |    7 
 fs/btrfs/sysfs.c                                         |    7 
 fs/ceph/caps.c                                           |  105 ++-
 fs/ceph/mds_client.c                                     |   90 ++-
 fs/ceph/mds_client.h                                     |    5 
 fs/ceph/snap.c                                           |   31 -
 fs/ceph/strings.c                                        |    1 
 fs/ext4/extents.c                                        |   18 
 fs/fuse/file.c                                           |   36 -
 fs/nilfs2/sufile.c                                       |    8 
 fs/zonefs/super.c                                        |   37 -
 include/linux/ceph/ceph_fs.h                             |    1 
 include/linux/netfilter/ipset/ip_set.h                   |    3 
 include/net/switchdev.h                                  |    2 
 include/trace/events/rxrpc.h                             |    2 
 include/uapi/linux/audit.h                               |    2 
 init/Kconfig                                             |    2 
 kernel/gcov/clang.c                                      |    2 
 kernel/irq/manage.c                                      |   31 -
 kernel/irq/msi.c                                         |    7 
 lib/vdso/Makefile                                        |    2 
 mm/vmscan.c                                              |   10 
 net/9p/trans_fd.c                                        |    2 
 net/bridge/br_vlan.c                                     |   33 -
 net/core/flow_dissector.c                                |    2 
 net/dccp/ipv4.c                                          |    2 
 net/dccp/ipv6.c                                          |    2 
 net/ipv4/Kconfig                                         |   10 
 net/ipv4/esp4_offload.c                                  |    3 
 net/ipv4/fib_trie.c                                      |    4 
 net/ipv4/inet_hashtables.c                               |   10 
 net/ipv4/ip_input.c                                      |    5 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                       |    4 
 net/ipv4/tcp_ipv4.c                                      |    2 
 net/ipv6/esp6_offload.c                                  |    3 
 net/ipv6/tcp_ipv6.c                                      |    2 
 net/ipv6/xfrm6_policy.c                                  |    6 
 net/key/af_key.c                                         |   32 -
 net/mac80211/main.c                                      |    8 
 net/mac80211/mesh_pathtbl.c                              |    2 
 net/netfilter/ipset/ip_set_hash_ip.c                     |   17 
 net/netfilter/ipset/ip_set_hash_ipmark.c                 |   10 
 net/netfilter/ipset/ip_set_hash_ipport.c                 |    3 
 net/netfilter/ipset/ip_set_hash_ipportip.c               |    3 
 net/netfilter/ipset/ip_set_hash_ipportnet.c              |    3 
 net/netfilter/ipset/ip_set_hash_net.c                    |   11 
 net/netfilter/ipset/ip_set_hash_netiface.c               |   10 
 net/netfilter/ipset/ip_set_hash_netnet.c                 |   16 
 net/netfilter/ipset/ip_set_hash_netport.c                |   11 
 net/netfilter/ipset/ip_set_hash_netportnet.c             |   16 
 net/netfilter/nf_conntrack_core.c                        |    2 
 net/netfilter/nf_conntrack_netlink.c                     |   24 
 net/netfilter/nf_conntrack_standalone.c                  |    2 
 net/netfilter/nf_flow_table_offload.c                    |    4 
 net/netfilter/nft_ct.c                                   |    6 
 net/netfilter/xt_connmark.c                              |   18 
 net/nfc/nci/core.c                                       |    2 
 net/nfc/nci/data.c                                       |    4 
 net/openvswitch/conntrack.c                              |    8 
 net/rxrpc/af_rxrpc.c                                     |    2 
 net/rxrpc/ar-internal.h                                  |   24 
 net/rxrpc/call_accept.c                                  |    4 
 net/rxrpc/call_object.c                                  |   44 -
 net/rxrpc/conn_client.c                                  |   66 +-
 net/rxrpc/conn_object.c                                  |   49 -
 net/rxrpc/conn_service.c                                 |    8 
 net/rxrpc/input.c                                        |    4 
 net/rxrpc/local_object.c                                 |   68 +-
 net/rxrpc/net_ns.c                                       |    5 
 net/rxrpc/peer_object.c                                  |   40 -
 net/rxrpc/proc.c                                         |   75 ++
 net/rxrpc/skbuff.c                                       |    1 
 net/sched/Kconfig                                        |    2 
 net/sched/act_connmark.c                                 |    4 
 net/sched/act_ct.c                                       |    8 
 net/sched/act_ctinfo.c                                   |    6 
 net/tipc/discover.c                                      |    5 
 net/tipc/topsrv.c                                        |   20 
 net/xfrm/xfrm_device.c                                   |   15 
 net/xfrm/xfrm_replay.c                                   |    2 
 sound/soc/codecs/hdac_hda.h                              |    4 
 sound/soc/codecs/sgtl5000.c                              |    1 
 sound/soc/intel/boards/bytcht_es8316.c                   |    7 
 sound/soc/soc-pcm.c                                      |    5 
 tools/testing/selftests/bpf/verifier/ref_tracking.c      |   36 +
 183 files changed, 2158 insertions(+), 895 deletions(-)

Ahmed S. Darwish (1):
      net: arcnet: Fix RESET flag handling

Al Cooper (2):
      mmc: sdhci-brcmstb: Re-organize flags
      mmc: sdhci-brcmstb: Enable Clock Gating to save power

Alejandro Concepción Rodríguez (1):
      iio: light: apds9960: fix wrong register for gesture gain

Alessandro Astone (2):
      binder: Address corner cases in deferred copy and fixup
      binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0

Alexandre Belloni (1):
      init/Kconfig: fix CC_HAS_ASM_GOTO_TIED_OUTPUT test with dash

Aman Dhoot (1):
      Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode

Anand Jain (2):
      btrfs: free btrfs_path before copying fspath to userspace
      btrfs: free btrfs_path before copying subvol info to userspace

Andreas Kemnade (1):
      regulator: twl6030: re-add TWL6032_SUBCLASS

Andrzej Hajda (1):
      drm/i915: fix TLB invalidation for Gen12 video and compute engines

Arnd Bergmann (1):
      binder: fix pointer cast warning

Baokun Li (1):
      ext4: fix use-after-free in ext4_ext_shift_extents

Bart Van Assche (1):
      scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC

Bean Huo (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro

Brian King (1):
      scsi: ibmvfc: Avoid path failures during live migration

Brian Norris (1):
      mmc: sdhci-brcmstb: Fix SDHCI_RESET_ALL for CQHCI

Chen Zhongjin (3):
      xfrm: Fix ignored return value in xfrm6_init()
      iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails
      nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

Christian König (1):
      drm/amdgpu: always register an MMU notifier for userptr

Christian Langrock (1):
      xfrm: replay: Fix ESN wrap around for GSO

Damien Le Moal (1):
      zonefs: fix zone report size in __zonefs_io_error()

Dan Carpenter (1):
      ceph: fix off by one bugs in unsafe_request_wait()

Daniel Xu (1):
      netfilter: conntrack: Fix data-races around ct mark

Danielle Ratson (1):
      bridge: switchdev: Notify about VLAN protocol changes

David Howells (3):
      rxrpc: Allow list of in-use local UDP endpoints to be viewed in /proc
      rxrpc: Use refcount_t rather than atomic_t
      rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]

Dawei Li (1):
      dma-buf: fix racing conflict of dma_heap_add()

Detlev Casanova (1):
      ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove

Diana Wang (1):
      nfp: fill splittable of devlink_port_attrs correctly

Dominik Haller (1):
      ARM: dts: am335x-pcm-953: Define fixed regulators in root node

Emil Renner Berthing (1):
      riscv: dts: sifive unleashed: Add PWM controlled LEDs

Enrico Sau (1):
      net: usb: qmi_wwan: add Telit 0x103a composition

Eyal Birger (1):
      xfrm: fix "disable_policy" on ipv4 early demux

Fabio Estevam (1):
      ARM: dts: imx6q-prti6q: Fix ref/tcxo-clock-frequency properties

Felix Fietkau (1):
      netfilter: flowtable_offload: add missing locking

Gaosheng Cui (1):
      audit: fix undefined behavior in bit shift for AUDIT_BIT

Gleb Mazovetskiy (1):
      tcp: configurable source port perturb table size

Greg Kroah-Hartman (2):
      lib/vdso: use "grep -E" instead of "egrep"
      Linux 5.10.157

Hans de Goede (7):
      platform/x86: touchscreen_dmi: Add info for the RCA Cambio W101 v2 2-in-1
      drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)
      ASoC: Intel: bytcht_es8316: Add quirk for the Nanote UMPC-01
      Input: goodix - try resetting the controller when no config is set
      Input: soc_button_array - add use_low_level_irq module parameter
      Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]
      platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)

Heiko Carstens (1):
      s390/crashdump: fix TOD programmable field size

Herbert Xu (1):
      af_key: Fix send_acquire race with pfkey_register

Ido Schimmel (1):
      bridge: switchdev: Fix memory leaks when changing VLAN protocol

Jaco Coetzee (1):
      nfp: add port from netdev validation for EEPROM access

Jakob Unterwurzacher (1):
      arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

Jason A. Donenfeld (2):
      wifi: airo: do not assign -1 to unsigned char
      MIPS: pic32: treat port as signed integer

Johannes Weiner (1):
      mm: vmscan: fix extreme overreclaim and swap floods

Jonas Jelonek (1):
      wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

Josef Bacik (1):
      btrfs: free btrfs_path before copying root refs to userspace

Jozsef Kadlecsik (1):
      netfilter: ipset: Limit the maximal range of consecutive elements to add/delete

Junxiao Chang (1):
      ASoC: hdac_hda: fix hda pcm buffer overflow issue

Kai-Heng Feng (1):
      platform/x86: hp-wmi: Ignore Smart Experience App event

Kenneth Lee (1):
      ceph: Use kcalloc for allocating multiple elements

Kuniyuki Iwashima (2):
      arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.
      dccp/tcp: Reset saddr on failure after inet6?_hash_connect().

Lars-Peter Clausen (1):
      iio: ms5611: Simplify IO callback parameters

Leo Savernik (1):
      nvme: add a bogus subsystem NQN quirk for Micron MTFDKBA2T0TFH

Leon Romanovsky (1):
      net: liquidio: simplify if expression

Lin Ma (1):
      nfc/nci: fix race with opening and closing

Liu Jian (1):
      net: ethernet: mtk_eth_soc: fix error handling in mtk_open()

Liu Shixin (1):
      NFC: nci: fix memory leak in nci_rx_data_packet()

Luiz Capitulino (4):
      genirq/msi: Shutdown managed interrupts with unsatifiable affinities
      genirq: Always limit the affinity to online CPUs
      irqchip/gic-v3: Always trust the managed affinity provided by the core code
      genirq: Take the proposed affinity at face value if force==true

Lukas Wunner (1):
      serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()

Lyude Paul (1):
      drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN

Marek Marczykowski-Górecki (1):
      xen-pciback: Allow setting PCI_MSIX_FLAGS_MASKALL too

Marek Szyprowski (1):
      usb: dwc3: exynos: Fix remove() function

Martin Faltesek (2):
      nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
      nfc: st-nci: fix memory leaks in EVT_TRANSACTION

Maxim Levitsky (2):
      KVM: x86: nSVM: leave nested mode on vCPU free
      KVM: x86: remove exit_int_info warning in svm_handle_exit

Michael Grzeschik (2):
      ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl
      usb: dwc3: gadget: conditionally remove requests

Michael Kelley (2):
      scsi: storvsc: Fix handling of srb_status and capacity change events
      x86/ioremap: Fix page aligned size calculation in __ioremap_caller()

Miklos Szeredi (1):
      fuse: lock inode unconditionally in fuse_fallocate()

Mikulas Patocka (2):
      dm integrity: flush the journal on suspend
      dm integrity: clear the journal on suspend

Mitja Spes (1):
      iio: pressure: ms5611: fixed value compensation bug

Moshe Shemesh (2):
      net/mlx5: Fix FW tracer timestamp calculation
      net/mlx5: Fix handling of entry refcount when command is not issued to FW

Mukesh Ojha (1):
      gcov: clang: fix the buffer overflow issue

Nathan Chancellor (1):
      RISC-V: vdso: Do not add missing symbols to version section in linker script

Nicolas Cavallari (1):
      wifi: mac80211: Fix ack frame idr leak when mesh has no route

Niklas Cassel (1):
      ata: libata-core: do not issue non-internal commands once EH is pending

Pawel Laszczak (1):
      usb: cdns3: Add support for DRD CDNSP

Peter Kosyh (1):
      net/mlx4: Check retval of mlx4_bitmap_init

Phil Turnbull (4):
      wifi: wilc1000: validate pairwise and authentication suite offsets
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_OPER_CHANNEL attribute
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute
      wifi: wilc1000: validate number of channels

Randy Dunlap (1):
      nios2: add FORCE for vmlinuz.gz

Richard Fitzgerald (1):
      ASoC: soc-pcm: Don't zero TDM masks in __soc_pcm_open()

Robin Murphy (1):
      gpu: host1x: Avoid trying to use GART on Tegra20

Sabrina Dubroca (1):
      Revert "net: macsec: report real_dev features when HW offloading is enabled"

Samuel Holland (1):
      bus: sunxi-rsb: Support atomic transfers

Sean Nyekjaer (1):
      spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run

Simon Rettberg (1):
      drm/display: Don't assume dual mode adaptors support i2c sub-addressing

Stefan Haberland (1):
      s390/dasd: fix no record found for raw_track_access

Thinh Nguyen (2):
      usb: dwc3: gadget: Return -ESHUTDOWN on ep disable
      usb: dwc3: gadget: Clear ep descriptor last

Todd Kjos (3):
      binder: avoid potential data leakage when copying txn
      binder: read pre-translated fds from sender buffer
      binder: defer copies of pre-patched txn data

Vishwanath Pai (1):
      netfilter: ipset: regression in ip_set_hash_ip.c

Vladimir Oltean (3):
      net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled
      net: enetc: cache accesses to &priv->si->hw
      net: enetc: preserve TX ring priority across reconfiguration

Wang Hai (2):
      net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
      arcnet: fix potential memory leak in com20020_probe()

Wenchao Hao (1):
      ata: libata-scsi: simplify __ata_scsi_queuecmd()

Xin Long (3):
      tipc: set con sock in tipc_conn_alloc
      tipc: add an extra conn_get in tipc_conn_alloc
      net: sched: allow act_ct to be built without NF_NAT

Xiongfeng Wang (2):
      spi: dw-dma: decrease reference count in dw_spi_dma_init_mfld()
      platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()

Xiubo Li (9):
      ceph: do not update snapshot context when there is no new snapshot
      ceph: avoid putting the realm twice when decoding snaps fails
      ceph: make ceph_create_session_msg a global symbol
      ceph: make iterate_sessions a global symbol
      ceph: flush mdlog before umounting
      ceph: flush the mdlog before waiting on unsafe reqs
      ceph: put the requests/sessions when it fails to alloc memory
      ceph: fix possible NULL pointer dereference for req->r_session
      ceph: fix NULL pointer dereference for req->r_session

Yang Yingliang (7):
      scsi: scsi_transport_sas: Fix error handling in sas_phy_add()
      regulator: core: fix UAF in destroy_regulator()
      tee: optee: fix possible memory leak in optee_register_device()
      net: pch_gbe: fix pci device refcount leak while module exiting
      Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
      Drivers: hv: vmbus: fix possible memory leak in vmbus_device_register()
      bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()

Youlin Li (1):
      selftests/bpf: Add verifier test for release_reference()

Yu Kuai (1):
      block, bfq: fix null pointer dereference in bfq_bio_bfqg()

Yu Liao (1):
      net: thunderx: Fix the ACPI memory leak

YueHaibing (2):
      macsec: Fix invalid error code set
      tipc: check skb_linearize() return value in tipc_disc_rcv()

Zeng Heng (1):
      regulator: core: fix kobject release warning and memory leak in regulator_register()

Zhang Changzhong (2):
      net/qla3xxx: fix potential memleak in ql3xxx_send()
      sfc: fix potential memleak in __ef100_hard_start_xmit()

Zhen Lei (1):
      btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()

Zheng Yongjun (1):
      ARM: mxs: fix memory leak in mxs_machine_init()

Zhengchao Shao (1):
      9p/fd: fix issue of list_del corruption in p9_fd_cancel()

Ziyang Xuan (1):
      ipv4: Fix error return code in fib_table_insert()

ruanjinjie (1):
      xen/platform-pci: add missing free_irq() in error path

taozhang (1):
      wifi: mac80211: fix memory free error when registering wiphy fail

