Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58EB6D78CB
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbjDEJsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbjDEJsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:48:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDED5BB3;
        Wed,  5 Apr 2023 02:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C69A63C64;
        Wed,  5 Apr 2023 09:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EC3C433B3;
        Wed,  5 Apr 2023 09:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680688035;
        bh=FRAWgI2JA442Ngx8WriBmdsQkCpWbe/uBozltVcTsTQ=;
        h=From:To:Cc:Subject:Date:From;
        b=f581PP+9aN81CCO1mGNdxvtXZw44jwKnL17SMGwUe3/2r1DOppy6kWGwwqvCXiUfm
         NyVZ2D55NqaxeLx+8W1Dxg864SpBCMG5cxUzzNWW7NE0z9QQ/tuW184R+qgI0AywKQ
         ppRsgwkKzRG/vTc534PeoeEJmZ2zOcsdo9ANZOYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.177
Date:   Wed,  5 Apr 2023 11:47:09 +0200
Message-Id: <2023040508-huff-cannot-479f@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.177 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/arm/boot/dts/e60k02.dtsi                                    |    1 
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts                     |    1 
 arch/m68k/kernel/traps.c                                         |    4 
 arch/mips/bmips/dma.c                                            |    5 
 arch/mips/bmips/setup.c                                          |    8 
 arch/powerpc/kernel/ptrace/ptrace-view.c                         |    6 
 arch/riscv/include/uapi/asm/setup.h                              |    8 
 arch/s390/lib/uaccess.c                                          |    2 
 arch/sh/include/asm/processor_32.h                               |    1 
 arch/sh/kernel/signal_32.c                                       |    3 
 arch/xtensa/kernel/traps.c                                       |   16 
 drivers/atm/idt77252.c                                           |   11 
 drivers/bluetooth/btqcomsmd.c                                    |   17 
 drivers/bluetooth/btsdio.c                                       |    1 
 drivers/bus/imx-weim.c                                           |    2 
 drivers/char/ipmi/ipmi_ssif.c                                    |  137 ++------
 drivers/firmware/arm_scmi/mailbox.c                              |   37 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c      |   19 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h      |   12 
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c                      |   10 
 drivers/gpu/drm/i915/display/intel_display.c                     |    1 
 drivers/gpu/drm/i915/i915_active.c                               |    3 
 drivers/gpu/drm/meson/meson_drv.c                                |   20 -
 drivers/gpu/drm/sun4i/sun4i_drv.c                                |    4 
 drivers/hid/hid-cp2112.c                                         |    1 
 drivers/hwmon/hwmon.c                                            |    7 
 drivers/hwmon/it87.c                                             |    4 
 drivers/i2c/busses/i2c-imx-lpi2c.c                               |    4 
 drivers/i2c/busses/i2c-xgene-slimpro.c                           |    3 
 drivers/input/mouse/alps.c                                       |   16 
 drivers/input/mouse/focaltech.c                                  |    8 
 drivers/input/touchscreen/goodix.c                               |   14 
 drivers/interconnect/qcom/osm-l3.c                               |    2 
 drivers/md/dm-crypt.c                                            |   16 
 drivers/md/dm-stats.c                                            |    7 
 drivers/md/dm-stats.h                                            |    2 
 drivers/md/dm-thin.c                                             |    2 
 drivers/md/dm.c                                                  |    4 
 drivers/md/md.c                                                  |    3 
 drivers/mtd/nand/raw/meson_nand.c                                |    8 
 drivers/net/dsa/mv88e6xxx/chip.c                                 |    9 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                        |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |    2 
 drivers/net/ethernet/google/gve/gve_ethtool.c                    |    5 
 drivers/net/ethernet/intel/i40e/i40e_diag.c                      |   11 
 drivers/net/ethernet/intel/i40e/i40e_diag.h                      |    2 
 drivers/net/ethernet/intel/iavf/iavf_common.c                    |    2 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                      |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                        |    2 
 drivers/net/ethernet/intel/igbvf/netdev.c                        |    8 
 drivers/net/ethernet/intel/igbvf/vf.c                            |   13 
 drivers/net/ethernet/intel/igc/igc_main.c                        |   20 -
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c               |    6 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c   |    3 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                |    1 
 drivers/net/ethernet/natsemi/sonic.c                             |    4 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                      |    5 
 drivers/net/ethernet/qualcomm/emac/emac.c                        |    6 
 drivers/net/ethernet/realtek/r8169_phy_config.c                  |    3 
 drivers/net/ethernet/sfc/ef10.c                                  |   38 +-
 drivers/net/ethernet/sfc/efx.c                                   |   17 
 drivers/net/ethernet/stmicro/stmmac/common.h                     |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                |   61 ---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                     |   41 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.h                     |    5 
 drivers/net/ethernet/xircom/xirc2ps_cs.c                         |    5 
 drivers/net/ieee802154/ca8210.c                                  |    5 
 drivers/net/ipa/gsi_trans.c                                      |    2 
 drivers/net/mdio/mdio-thunder.c                                  |    1 
 drivers/net/mdio/of_mdio.c                                       |   12 
 drivers/net/net_failover.c                                       |    8 
 drivers/net/phy/dp83869.c                                        |    6 
 drivers/net/phy/mdio_devres.c                                    |   11 
 drivers/net/phy/phy.c                                            |   23 -
 drivers/net/usb/cdc_mbim.c                                       |    5 
 drivers/net/usb/qmi_wwan.c                                       |    1 
 drivers/net/usb/smsc95xx.c                                       |    6 
 drivers/net/xen-netback/common.h                                 |    2 
 drivers/net/xen-netback/netback.c                                |   25 +
 drivers/pinctrl/pinctrl-amd.c                                    |   36 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                              |    1 
 drivers/pinctrl/pinctrl-ocelot.c                                 |    2 
 drivers/platform/chrome/cros_ec_chardev.c                        |    2 
 drivers/power/supply/bq24190_charger.c                           |   64 +--
 drivers/power/supply/da9150-charger.c                            |    1 
 drivers/ptp/ptp_qoriq.c                                          |    2 
 drivers/regulator/fixed.c                                        |    2 
 drivers/s390/crypto/vfio_ap_drv.c                                |    3 
 drivers/scsi/device_handler/scsi_dh_alua.c                       |    6 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                           |    3 
 drivers/scsi/lpfc/lpfc_sli.c                                     |    8 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                      |    4 
 drivers/scsi/qla2xxx/qla_os.c                                    |   11 
 drivers/scsi/scsi_devinfo.c                                      |    1 
 drivers/scsi/storvsc_drv.c                                       |   16 
 drivers/scsi/ufs/ufshcd.c                                        |    1 
 drivers/target/iscsi/iscsi_target_parameters.c                   |   12 
 drivers/tee/amdtee/core.c                                        |   29 -
 drivers/thunderbolt/nhi.c                                        |    2 
 drivers/thunderbolt/usb4.c                                       |   22 -
 drivers/tty/serial/8250/Kconfig                                  |    4 
 drivers/tty/serial/fsl_lpuart.c                                  |   13 
 drivers/usb/cdns3/cdns3-pci-wrap.c                               |    5 
 drivers/usb/chipidea/ci.h                                        |    2 
 drivers/usb/chipidea/core.c                                      |   11 
 drivers/usb/chipidea/otg.c                                       |    5 
 drivers/usb/dwc2/platform.c                                      |   16 
 drivers/usb/dwc3/gadget.c                                        |   79 ++--
 drivers/usb/gadget/function/u_audio.c                            |    2 
 drivers/usb/storage/unusual_uas.h                                |    7 
 drivers/usb/typec/ucsi/ucsi.c                                    |   11 
 drivers/video/fbdev/au1200fb.c                                   |    3 
 drivers/video/fbdev/geode/lxfb_core.c                            |    3 
 drivers/video/fbdev/intelfb/intelfbdrv.c                         |    3 
 drivers/video/fbdev/nvidia/nvidia.c                              |    2 
 drivers/video/fbdev/tgafb.c                                      |    3 
 fs/btrfs/ioctl.c                                                 |    2 
 fs/btrfs/qgroup.c                                                |   11 
 fs/btrfs/volumes.c                                               |   11 
 fs/cifs/cifsfs.h                                                 |    5 
 fs/cifs/cifssmb.c                                                |    9 
 fs/cifs/smb2ops.c                                                |    2 
 fs/ext4/inode.c                                                  |    3 
 fs/gfs2/aops.c                                                   |    2 
 fs/gfs2/bmap.c                                                   |    3 
 fs/gfs2/glops.c                                                  |    3 
 fs/nfs/nfs4proc.c                                                |    5 
 fs/nfsd/nfs4proc.c                                               |   22 -
 fs/nilfs2/ioctl.c                                                |    2 
 fs/ocfs2/aops.c                                                  |   18 -
 fs/verity/enable.c                                               |   24 -
 fs/verity/verify.c                                               |   12 
 fs/xfs/xfs_extent_busy.c                                         |   14 
 fs/xfs/xfs_trans_dquot.c                                         |   13 
 fs/zonefs/super.c                                                |    2 
 include/linux/nvme-tcp.h                                         |    5 
 include/linux/of_mdio.h                                          |   22 +
 include/net/bluetooth/l2cap.h                                    |    1 
 include/trace/events/rcu.h                                       |    2 
 kernel/bpf/core.c                                                |    2 
 kernel/compat.c                                                  |    2 
 kernel/events/core.c                                             |    4 
 kernel/kcsan/Makefile                                            |    3 
 kernel/sched/core.c                                              |    7 
 kernel/sched/fair.c                                              |   54 ++-
 kernel/trace/kprobe_event_gen_test.c                             |    4 
 net/bluetooth/l2cap_core.c                                       |  129 +++++--
 net/can/bcm.c                                                    |   16 
 net/hsr/hsr_framereg.c                                           |    2 
 net/ipv4/ip_gre.c                                                |    4 
 net/ipv6/ip6_gre.c                                               |    4 
 net/mac80211/wme.c                                               |    6 
 net/tls/tls_main.c                                               |    9 
 net/xdp/xdp_umem.c                                               |   13 
 security/keys/request_key.c                                      |    9 
 sound/pci/asihpi/hpi6205.c                                       |    2 
 sound/pci/hda/patch_ca0132.c                                     |    4 
 sound/pci/hda/patch_conexant.c                                   |    6 
 sound/pci/hda/patch_realtek.c                                    |    1 
 sound/pci/ymfpci/ymfpci.c                                        |   71 ++--
 sound/pci/ymfpci/ymfpci_main.c                                   |   74 ++--
 sound/usb/format.c                                               |    8 
 tools/bootconfig/test-bootconfig.sh                              |   12 
 tools/lib/bpf/btf_dump.c                                         |  154 ++++++---
 tools/power/x86/turbostat/turbostat.8                            |    2 
 tools/power/x86/turbostat/turbostat.c                            |    2 
 tools/testing/selftests/bpf/prog_tests/btf.c                     |   28 +
 tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c |    2 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c   |   80 ++++
 tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c   |  171 ++++++++--
 virt/kvm/kvm_main.c                                              |  149 ++++++--
 173 files changed, 1647 insertions(+), 797 deletions(-)

AKASHI Takahiro (1):
      igc: fix the validation logic for taprio's gate list

Adrien Thierry (1):
      scsi: ufs: core: Add soft dependency on governor_simpleondemand

Akihiko Odaki (1):
      igbvf: Regard vf reset nack as success

Al Viro (1):
      sh: sanitize the flags on sigreturn

Alex Elder (1):
      net: ipa: compute DMA pool size properly

Alexander Aring (1):
      ca8210: fix mac_len negative array access

Alexander Lobakin (2):
      iavf: fix inverted Rx hash condition leading to disabled hash
      iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Stein (1):
      i2c: imx-lpi2c: check only for enabled interrupt flags

Alexander Sverdlin (1):
      tty: serial: fsl_lpuart: fix race on RX DMA shutdown

Alexandre Ghiti (1):
      riscv: Bump COMMAND_LINE_SIZE value to 1024

Alvin Šipraga (1):
      usb: gadget: u_audio: don't let userspace block driver unbind

Anand Jain (1):
      btrfs: scan device in non-exclusive mode

Anders Roxell (1):
      kernel: kcsan: kcsan_test: build without structleak plugin

Andreas Gruenbacher (1):
      gfs2: Always check inode size of inline inodes

Andrii Nakryiko (3):
      libbpf: Fix BTF-to-C converter's padding logic
      selftests/bpf: Add few corner cases to test padding handling of btf_dump
      libbpf: Fix btf_dump's packed struct determination

Anton Gusev (1):
      tracing: Fix wrong return in kprobe_event_gen_test.c

Arseniy Krasnov (1):
      mtd: rawnand: meson: invalidate cache on polling ECC bit

Brian Foster (1):
      xfs: don't reuse busy extents on extent trim

Caleb Sander (1):
      nvme-tcp: fix nvme_tcp_term_pdu to match spec

Christophe JAILLET (1):
      regulator: Handle deferred clk

ChunHao Lin (1):
      r8169: fix RTL8168H and RTL8107E rx crc error

Coly Li (1):
      dm thin: fix deadlock when swapping to thin device

Corey Minyard (3):
      ipmi:ssif: Increase the message retry time
      ipmi:ssif: resend_msg() cannot fail
      ipmi:ssif: Add a timer between request retries

Cristian Marussi (1):
      firmware: arm_scmi: Fix device node validation for mailbox transport

Dai Ngo (1):
      NFSD: fix use-after-free in __nfs42_ssc_open()

Damien Le Moal (1):
      zonefs: Fix error message in zonefs_file_dio_append()

Dan Carpenter (1):
      net/mlx5: E-Switch, Fix an Oops in error handling code

Daniel Borkmann (1):
      bpf: Adjust insufficient default bpf_jit_limit

Daniil Tatianin (1):
      qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

Danny Kaehn (1):
      HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded

Darrick J. Wong (1):
      xfs: shut down the filesystem if we screw up quota reservation

David Disseldorp (1):
      cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

David Howells (1):
      keys: Do not cache key in task struct if key is requested from kernel thread

Dmitry Baryshkov (1):
      interconnect: qcom: osm-l3: fix icc_onecell_data allocation

Douglas Raillard (1):
      rcu: Fix rcu_torture_read ftrace event

Eduard Zingerman (1):
      selftests/bpf: Test btf dump for struct with padding only fields

Enrico Sau (2):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
      net: usb: qmi_wwan: add Telit 0x1080 composition

Eric Biggers (1):
      fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

Eric Dumazet (1):
      erspan: do not use skb_mac_header() in ndo_start_xmit()

Fabrice Gasnier (1):
      usb: dwc2: fix a devres leak in hw_enable upon suspend resume

Faicker Mo (1):
      net/net_failover: fix txq exceeding warning

Fangzhi Zuo (1):
      drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub

Felix Fietkau (1):
      wifi: mac80211: fix qos on mesh interfaces

Filipe Manana (1):
      btrfs: fix race between quota disable and quota assign ioctls

Florian Fainelli (1):
      net: phy: Ensure state transitions are processed from phy_stop()

Frank Crawford (1):
      hwmon (it87): Fix voltage scaling for chips with 10.9mV ADCs

Gaosheng Cui (1):
      intel/igbvf: free irq on the error path in igbvf_request_msix()

Geert Uytterhoeven (1):
      serial: 8250: SERIAL_8250_ASPEED_VUART should depend on ARCH_ASPEED

Geoff Levand (2):
      net/ps3_gelic_net: Fix RX sk_buff length
      net/ps3_gelic_net: Use dma_mapping_error

Greg Kroah-Hartman (1):
      Linux 5.10.177

Hangyu Hua (1):
      net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()

Hans de Goede (2):
      usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()
      Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table

Harshit Mogalapalli (1):
      ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Heiko Carstens (1):
      s390/uaccess: add missing earlyclobber annotations to __clear_user()

Horatiu Vultur (1):
      pinctrl: ocelot: Fix alt mode for ocelot

Ivan Bornyakov (1):
      bus: imx-weim: fix branch condition evaluates to a garbage value

Ivan Orlov (1):
      can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Jakob Koschel (1):
      scsi: lpfc: Avoid usage of list iterator variable after loop

Jan Kara via Ocfs2-devel (1):
      ocfs2: fix data corruption after failed write

Jason A. Donenfeld (1):
      Input: focaltech - use explicitly signed char type

Jason Wang (1):
      serial: fsl_lpuart: Fix comment typo

Jens Axboe (1):
      powerpc: Don't try to copy PPR for task with NULL pt_regs

Jiasheng Jiang (1):
      dm stats: check for and propagate alloc_percpu failure

Joel Selvaraj (1):
      scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Johan Hovold (3):
      drm/sun4i: fix missing component unbind on bind errors
      drm/meson: fix missing component unbind on bind errors
      pinctrl: at91-pio4: fix domain name assignment

Joshua Washington (1):
      gve: Cache link_speed value from device

Josua Mayer (1):
      net: phy: dp83869: fix default value for tx-/rx-internal-delay

Juergen Gross (1):
      xen/netback: don't do grant copy across page boundary

Kal Conley (1):
      xsk: Add missing overflow check in xdp_umem_reg

Kalesh AP (1):
      bnxt_en: Fix typo in PCI id to device description string mapping

Kang Chen (1):
      scsi: hisi_sas: Check devm_add_action() return value

Kornel Dulęba (1):
      pinctrl: amd: Disable and mask interrupts on resume

Kristian Overskeid (1):
      net: hsr: Don't log netdev_err message on unknown prp dst node

Kuninori Morimoto (2):
      ALSA: asihpi: check pao in control_message()
      ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Lama Kayal (1):
      net/mlx5: Fix steering rules cleanup

Li Zetao (1):
      atm: idt77252: fix kmemleak when rmmod idt77252

Liang He (1):
      net: mdio: thunder: Add missing fwnode_handle_put()

Liguang Zhang (1):
      ipmi:ssif: make ssif_i2c_send() void

Lin Ma (1):
      igb: revert rtnl_lock() that causes deadlock

Linus Torvalds (1):
      sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Lorenz Bauer (1):
      selftests/bpf: check that modifier resolves after pointer

Lucas Stach (1):
      drm/etnaviv: fix reference leak when mmaping imported buffer

Luiz Augusto von Dentz (2):
      Bluetooth: L2CAP: Fix not checking for maximum number of DCID
      Bluetooth: L2CAP: Fix responding with wrong PDU type

Maher Sanalla (1):
      net/mlx5: Read the TC mapping of all priorities on ETS query

Marco Elver (1):
      kcsan: avoid passing -g for test

Mario Limonciello (1):
      thunderbolt: Use const qualifier for `ring_interrupt_index`

Martin Blumenstingl (1):
      drm/meson: Fix error handling when afbcd.ops->init fails

Masami Hiramatsu (Google) (1):
      bootconfig: Fix testcase to increase max node

Matthieu Baerts (1):
      hsr: ratelimit only when errors are printed

Maurizio Lombardi (1):
      scsi: target: iscsi: Fix an error message in iscsi_check_key()

Max Filippov (1):
      xtensa: fix KASAN report for show_stack

Maxime Bizon (1):
      net: mdio: fix owner field for mdio buses registered using device-tree

Miaohe Lin (1):
      KVM: fix memoryleak in kvm_init()

Michael Chan (1):
      bnxt_en: Add missing 200G link speed reporting

Michael Grzeschik (1):
      usb: dwc3: gadget: move cmd_endtransfer to extra function

Michael Kelley (1):
      scsi: storvsc: Handle BlockSize change in Hyper-V VHD/VHDX file

Michael Schmitz (1):
      m68k: Only force 030 bus error if PC not in exception table

Mika Westerberg (1):
      thunderbolt: Use scale field when allocating USB3 bandwidth

Mike Snitzer (1):
      dm crypt: avoid accessing uninitialized tasklet

Mikulas Patocka (1):
      dm crypt: add cond_resched() to dmcrypt_write()

Minghao Chi (1):
      power: supply: bq24190_charger: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

Nathan Huckleberry (1):
      fsverity: Remove WQ_UNBOUND from fsverity read workqueue

NeilBrown (1):
      md: avoid signed overflow in slot_store()

Nilesh Javali (1):
      scsi: qla2xxx: Perform lockless command completion in abort path

Nirmoy Das (1):
      drm/i915/active: Fix missing debug object activation

Paulo Alcantara (1):
      cifs: prevent infinite recursion in CIFSGetDFSRefer()

Pawel Laszczak (1):
      usb: cdns3: Fix issue with using incorrect PCI device function

Peng Fan (2):
      ARM: dts: imx6sll: e60k02: fix usbotg1 pinctrl
      ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl

Phinex Hung (1):
      hwmon: fix potential sensor registration fail if of_node is missing

Prarit Bhargava (1):
      tools/power turbostat: Fix /dev/cpu_dma_latency warnings

Radoslaw Tyl (1):
      i40e: fix registers dump after run ethtool adapter self test

Randy Dunlap (1):
      serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it

Rijo Thomas (1):
      tee: amdtee: fix race condition in amdtee_open_session

Ryusuke Konishi (1):
      nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Sean Christopherson (3):
      KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
      KVM: KVM: Use cpumask_available() to check for NULL cpumask when kicking vCPUs
      KVM: Register /dev/kvm as the _very_ last thing during initialization

Shyam Prasad N (1):
      cifs: empty interface list when server doesn't support query interfaces

Song Liu (1):
      perf: fix perf_event_context->time

SongJingyi (1):
      ptp_qoriq: fix memory leak in probe()

Steffen Bätz (1):
      net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Stephan Gerhold (1):
      Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Szymon Heidrich (1):
      net: usb: smsc95xx: Limit packet length to skb->len

Takashi Iwai (3):
      ALSA: ymfpci: Fix assignment in if condition
      ALSA: hda/conexant: Partial revert of a quirk for Lenovo
      ALSA: usb-audio: Fix regression on detection of Roland VS-100

Tasos Sahanidis (1):
      ALSA: ymfpci: Fix BUG_ON in probe function

Tomas Henzl (1):
      scsi: megaraid_sas: Fix crash after a double completion

Tony Krowiak (1):
      s390/vfio-ap: fix memory leak in vfio_ap device driver

Trond Myklebust (1):
      NFSv4: Fix hangs when recovering open state after a server reboot

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Ville Syrjälä (1):
      drm/i915: Preserve crtc_state->inherited during state clearing

Vincent Guittot (1):
      sched/fair: Sanitize vruntime of entity being migrated

Vitaly Kuznetsov (2):
      KVM: Optimize kvm_make_vcpus_request_mask() a bit
      KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()

Vladimir Oltean (1):
      net: stmmac: don't reject VLANs when IFF_PROMISC is set

Wei Chen (6):
      i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()
      fbdev: tgafb: Fix potential divide by zero
      fbdev: nvidia: Fix potential divide by zero
      fbdev: intelfb: Fix potential divide by zero
      fbdev: lxfb: Fix potential divide by zero
      fbdev: au1200fb: Fix potential divide by zero

Wesley Cheng (1):
      usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC

Xu Yang (2):
      usb: chipdea: core: fix return -EINVAL if request role is the same with current role
      usb: chipidea: core: fix possible concurrent when switch role

Yang Jihong (1):
      perf/core: Fix perf_output_begin parameter is incorrectly invoked in perf_event_bpf_output

Yaroslav Furman (1):
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Ye Bin (1):
      ext4: fix kernel BUG in 'ext4_write_inline_data_end()'

Yu Kuai (1):
      scsi: scsi_dh_alua: Fix memleak for 'qdata' in alua_activate()

Zhang Changzhong (1):
      net/sonic: use dma_mapping_error() for error check

Zhang Qiao (1):
      sched/fair: sanitize vruntime of entity being placed

Zheng Wang (5):
      power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition
      power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition
      xirc2ps_cs: Fix use after free bug in xirc2ps_detach
      net: qcom/emac: Fix use after free bug in emac_remove due to race condition
      Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

huangwenhui (1):
      ALSA: hda/realtek: Add quirk for Lenovo ZhaoYang CF4620Z

msizanoen (1):
      Input: alps - fix compatibility with -funsigned-char

Álvaro Fernández Rojas (1):
      mips: bmips: BCM6358: disable RAC flush for TP1

Íñigo Huguet (1):
      sfc: ef10: don't overwrite offload features at NIC reset

