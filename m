Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374326D02CA
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 13:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjC3LQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 07:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjC3LQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 07:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10389977E;
        Thu, 30 Mar 2023 04:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 940606200A;
        Thu, 30 Mar 2023 11:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7504BC433EF;
        Thu, 30 Mar 2023 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680174972;
        bh=3zJ4rZAdiBP9UVsApdoFJHW5+yGyko/LtQr45D6QjyA=;
        h=From:To:Cc:Subject:Date:From;
        b=PK6yZ10Vc24sn843cZL3DcLZxiMZmfTkSB5lxUebLjgZOF70QMqU7rEm8j0uBvmTS
         Ep/a0J1+Xw0SQxQwjVk5sDDuM39VAqyPFpnVHNs44WYetEc+76pXcoUd1UKi/IXzru
         U0+b8rjjYgfxW9oT8XWbGJW+8/31H0OQvyRdV2qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.105
Date:   Thu, 30 Mar 2023 13:16:07 +0200
Message-Id: <168017496847124@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.105 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/dts/e60k02.dtsi                                  |    1 
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts                   |    1 
 arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts           |    2 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                      |    5 
 arch/m68k/kernel/traps.c                                       |    4 
 arch/riscv/Kconfig                                             |   22 +
 arch/riscv/Makefile                                            |   10 
 arch/riscv/include/asm/tlbflush.h                              |    2 
 arch/riscv/include/uapi/asm/setup.h                            |    8 
 arch/riscv/mm/context.c                                        |    2 
 arch/riscv/mm/tlbflush.c                                       |    2 
 arch/sh/include/asm/processor_32.h                             |    1 
 arch/sh/kernel/signal_32.c                                     |    3 
 arch/x86/kvm/hyperv.c                                          |   15 -
 drivers/acpi/x86/utils.c                                       |   37 +--
 drivers/atm/idt77252.c                                         |   11 
 drivers/bluetooth/btqcomsmd.c                                  |   17 +
 drivers/bluetooth/btsdio.c                                     |    1 
 drivers/firmware/arm_scmi/mailbox.c                            |   37 +++
 drivers/firmware/efi/sysfb_efi.c                               |    5 
 drivers/firmware/sysfb.c                                       |    4 
 drivers/firmware/sysfb_simplefb.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                            |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                     |   15 +
 drivers/gpu/drm/amd/amdgpu/nv.c                                |    2 
 drivers/gpu/drm/amd/amdgpu/vi.c                                |   17 -
 drivers/gpu/drm/bridge/lontium-lt8912b.c                       |    4 
 drivers/gpu/drm/i915/display/intel_display.c                   |    1 
 drivers/gpu/drm/i915/gt/intel_gt.c                             |    4 
 drivers/gpu/drm/i915/i915_active.c                             |    3 
 drivers/gpu/drm/meson/meson_drv.c                              |   13 -
 drivers/gpu/drm/tiny/cirrus.c                                  |    2 
 drivers/hid/hid-cp2112.c                                       |    1 
 drivers/hid/intel-ish-hid/ipc/ipc.c                            |    9 
 drivers/hwmon/hwmon.c                                          |    7 
 drivers/hwmon/it87.c                                           |    4 
 drivers/i2c/busses/i2c-hisi.c                                  |    6 
 drivers/i2c/busses/i2c-imx-lpi2c.c                             |    4 
 drivers/i2c/busses/i2c-xgene-slimpro.c                         |    3 
 drivers/interconnect/qcom/osm-l3.c                             |    2 
 drivers/md/dm-crypt.c                                          |   16 -
 drivers/md/dm-stats.c                                          |    7 
 drivers/md/dm-stats.h                                          |    2 
 drivers/md/dm-thin.c                                           |    2 
 drivers/md/dm.c                                                |    4 
 drivers/net/dsa/b53/b53_mmap.c                                 |    2 
 drivers/net/dsa/mt7530.c                                       |   49 ++--
 drivers/net/ethernet/google/gve/gve_ethtool.c                  |    5 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                    |    8 
 drivers/net/ethernet/intel/iavf/iavf_common.c                  |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                    |    5 
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                    |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                      |    2 
 drivers/net/ethernet/intel/igbvf/netdev.c                      |    8 
 drivers/net/ethernet/intel/igbvf/vf.c                          |   13 -
 drivers/net/ethernet/intel/igc/igc_main.c                      |   20 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c           |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c             |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |    6 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c |    3 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c              |    1 
 drivers/net/ethernet/natsemi/sonic.c                           |    4 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                    |    5 
 drivers/net/ethernet/qualcomm/emac/emac.c                      |    6 
 drivers/net/ethernet/toshiba/ps3_gelic_net.c                   |   41 +--
 drivers/net/ethernet/toshiba/ps3_gelic_net.h                   |    5 
 drivers/net/ethernet/xircom/xirc2ps_cs.c                       |    5 
 drivers/net/ieee802154/ca8210.c                                |    2 
 drivers/net/mdio/acpi_mdio.c                                   |   10 
 drivers/net/mdio/mdio-thunder.c                                |    1 
 drivers/net/mdio/of_mdio.c                                     |   12 -
 drivers/net/phy/mdio_devres.c                                  |   11 
 drivers/net/phy/phy.c                                          |   23 +
 drivers/net/usb/cdc_mbim.c                                     |    5 
 drivers/net/usb/qmi_wwan.c                                     |    1 
 drivers/net/usb/smsc95xx.c                                     |    6 
 drivers/platform/chrome/cros_ec_chardev.c                      |    2 
 drivers/power/supply/bq24190_charger.c                         |   64 +----
 drivers/power/supply/da9150-charger.c                          |    1 
 drivers/scsi/device_handler/scsi_dh_alua.c                     |    6 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                         |    3 
 drivers/scsi/lpfc/lpfc_init.c                                  |    2 
 drivers/scsi/lpfc/lpfc_sli.c                                   |   12 -
 drivers/scsi/qla2xxx/qla_isr.c                                 |    3 
 drivers/scsi/qla2xxx/qla_os.c                                  |   11 
 drivers/scsi/scsi_devinfo.c                                    |    1 
 drivers/scsi/storvsc_drv.c                                     |   16 +
 drivers/scsi/ufs/ufshcd.c                                      |    1 
 drivers/target/iscsi/iscsi_target_parameters.c                 |   12 -
 drivers/tee/amdtee/core.c                                      |   29 +-
 drivers/thunderbolt/nhi.c                                      |   49 ++--
 drivers/thunderbolt/nhi_regs.h                                 |    6 
 drivers/thunderbolt/retimer.c                                  |   23 +
 drivers/thunderbolt/sb_regs.h                                  |    1 
 drivers/thunderbolt/switch.c                                   |    4 
 drivers/thunderbolt/tb.h                                       |    1 
 drivers/thunderbolt/usb4.c                                     |   36 ++-
 drivers/tty/hvc/hvc_xen.c                                      |   19 +
 drivers/tty/serial/8250/Kconfig                                |    4 
 drivers/tty/serial/fsl_lpuart.c                                |   19 -
 drivers/usb/cdns3/cdns3-pci-wrap.c                             |    5 
 drivers/usb/cdns3/cdnsp-ep0.c                                  |   19 -
 drivers/usb/cdns3/cdnsp-pci.c                                  |   27 --
 drivers/usb/chipidea/ci.h                                      |    2 
 drivers/usb/chipidea/core.c                                    |   11 
 drivers/usb/chipidea/otg.c                                     |    5 
 drivers/usb/dwc2/platform.c                                    |   16 -
 drivers/usb/gadget/function/u_audio.c                          |    2 
 drivers/usb/storage/unusual_uas.h                              |    7 
 drivers/usb/typec/tcpm/tcpm.c                                  |   19 +
 drivers/usb/typec/ucsi/ucsi.c                                  |   11 
 fs/cifs/cifs_debug.c                                           |    5 
 fs/cifs/smb2ops.c                                              |    2 
 fs/ksmbd/connection.c                                          |    7 
 fs/ksmbd/smb2pdu.c                                             |   20 +
 fs/ksmbd/smb_common.c                                          |   27 +-
 fs/ksmbd/smb_common.h                                          |   30 --
 fs/lockd/clnt4xdr.c                                            |    9 
 fs/lockd/xdr4.c                                                |   13 +
 fs/nfsd/nfs4proc.c                                             |   22 -
 fs/nilfs2/ioctl.c                                              |    2 
 fs/ocfs2/aops.c                                                |   18 +
 fs/super.c                                                     |   15 +
 fs/verity/verify.c                                             |   12 -
 include/linux/acpi_mdio.h                                      |    9 
 include/linux/entry-kvm.h                                      |    2 
 include/linux/kthread.h                                        |   25 ++
 include/linux/lockd/xdr4.h                                     |    1 
 include/linux/nvme-tcp.h                                       |    5 
 include/linux/of_mdio.h                                        |   22 +
 include/linux/sysfb.h                                          |    9 
 include/linux/thread_info.h                                    |   14 +
 kernel/bpf/core.c                                              |    2 
 kernel/entry/common.c                                          |    5 
 kernel/entry/kvm.c                                             |    4 
 kernel/events/core.c                                           |    4 
 kernel/kthread.c                                               |    1 
 kernel/sched/core.c                                            |    3 
 kernel/sched/fair.c                                            |   54 ++++
 kernel/trace/trace_hwlat.c                                     |   12 -
 mm/kfence/Makefile                                             |    2 
 mm/kfence/core.c                                               |    8 
 mm/slab.c                                                      |    2 
 net/bluetooth/l2cap_core.c                                     |  117 ++++++----
 net/dsa/tag_brcm.c                                             |   10 
 net/ipv4/ip_gre.c                                              |    4 
 net/ipv6/ip6_gre.c                                             |    4 
 net/mac80211/wme.c                                             |    6 
 net/sched/act_mirred.c                                         |   23 +
 net/tls/tls_main.c                                             |    9 
 net/xdp/xdp_umem.c                                             |   13 -
 security/keys/request_key.c                                    |    9 
 tools/bootconfig/test-bootconfig.sh                            |   12 -
 tools/testing/selftests/bpf/prog_tests/btf.c                   |   28 ++
 tools/testing/selftests/net/forwarding/tc_actions.sh           |   49 ++++
 156 files changed, 1148 insertions(+), 545 deletions(-)

AKASHI Takahiro (1):
      igc: fix the validation logic for taprio's gate list

Adrien Thierry (1):
      scsi: ufs: core: Add soft dependency on governor_simpleondemand

Akihiko Odaki (1):
      igbvf: Regard vf reset nack as success

Al Viro (1):
      sh: sanitize the flags on sigreturn

Alexander Aring (1):
      ca8210: fix mac_len negative array access

Alexander Lobakin (2):
      iavf: fix inverted Rx hash condition leading to disabled hash
      iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Stein (1):
      i2c: imx-lpi2c: check only for enabled interrupt flags

Alexander Sverdlin (1):
      tty: serial: fsl_lpuart: fix race on RX DMA shutdown

Alexandr Sapozhnikov (1):
      drm/cirrus: NULL-check pipe->plane.state->fb in cirrus_pipe_update()

Alexandre Ghiti (1):
      riscv: Bump COMMAND_LINE_SIZE value to 1024

Alvin Šipraga (1):
      usb: gadget: u_audio: don't let userspace block driver unbind

Andrzej Hajda (1):
      drm/i915/gt: perform uc late init after probe error injection

Arınç ÜNAL (3):
      net: dsa: mt7530: move enabling disabling core clock to mt7530_pll_setup()
      net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()
      net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case

Cai Huoqing (2):
      kthread: add the helper function kthread_run_on_cpu()
      trace/hwlat: make use of the helper function kthread_run_on_cpu()

Caleb Sander (1):
      nvme-tcp: fix nvme_tcp_term_pdu to match spec

ChenXiaoSong (1):
      ksmbd: fix possible refcount leak in smb2_open()

Coly Li (1):
      dm thin: fix deadlock when swapping to thin device

Costa Shulyupin (1):
      tracing/hwlat: Replace sched_setaffinity with set_cpus_allowed_ptr

Cristian Marussi (1):
      firmware: arm_scmi: Fix device node validation for mailbox transport

Dai Ngo (1):
      NFSD: fix use-after-free in __nfs42_ssc_open()

Dan Carpenter (1):
      net/mlx5: E-Switch, Fix an Oops in error handling code

Daniel Borkmann (1):
      bpf: Adjust insufficient default bpf_jit_limit

Daniil Tatianin (1):
      qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

Danny Kaehn (1):
      HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded

David Howells (1):
      keys: Do not cache key in task struct if key is requested from kernel thread

Davide Caratti (2):
      net/sched: act_mirred: better wording on protection against excessive stack growth
      act_mirred: use the backlog for nested calls to mirred ingress

Dmitry Baryshkov (1):
      interconnect: qcom: osm-l3: fix icc_onecell_data allocation

Dylan Jhong (1):
      riscv: mm: Fix incorrect ASID argument when flushing TLB

Enrico Sau (2):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
      net: usb: qmi_wwan: add Telit 0x1080 composition

Eric Biggers (1):
      fscrypt: destroy keyring after security_sb_delete()

Eric Dumazet (1):
      erspan: do not use skb_mac_header() in ndo_start_xmit()

Fabrice Gasnier (1):
      usb: dwc2: fix a devres leak in hw_enable upon suspend resume

Felix Fietkau (1):
      wifi: mac80211: fix qos on mesh interfaces

Florian Fainelli (2):
      net: phy: Ensure state transitions are processed from phy_stop()
      net: mdio: fix owner field for mdio buses registered using ACPI

Frank Crawford (1):
      hwmon (it87): Fix voltage scaling for chips with 10.9mV ADCs

Frederic Weisbecker (1):
      entry/rcu: Check TIF_RESCHED _after_ delayed RCU wake-up

Gaosheng Cui (1):
      intel/igbvf: free irq on the error path in igbvf_request_msix()

Gavin Li (1):
      net/mlx5e: Set uplink rep as NETNS_LOCAL

Geert Uytterhoeven (2):
      serial: 8250: SERIAL_8250_ASPEED_VUART should depend on ARCH_ASPEED
      mm/slab: Fix undefined init_cache_node_node() for NUMA and !SMP

Geoff Levand (2):
      net/ps3_gelic_net: Fix RX sk_buff length
      net/ps3_gelic_net: Use dma_mapping_error

Gil Fine (1):
      thunderbolt: Add missing UNSET_INBOUND_SBTX for retimer access

Greg Kroah-Hartman (1):
      Linux 5.15.105

Hangyu Hua (1):
      net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()

Hans de Goede (2):
      efi: sysfb_efi: Fix DMI quirks not working for simpledrm
      usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()

Jakob Koschel (1):
      scsi: lpfc: Avoid usage of list iterator variable after loop

Jan Kara via Ocfs2-devel (1):
      ocfs2: fix data corruption after failed write

Jason Wang (1):
      serial: fsl_lpuart: Fix comment typo

Jeff Layton (1):
      lockd: set file_lock start and end when decoding nlm4 testargs

Jiasheng Jiang (2):
      octeontx2-vf: Add missing free for alloc_percpu
      dm stats: check for and propagate alloc_percpu failure

Joel Selvaraj (1):
      scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Johan Hovold (1):
      drm/meson: fix missing component unbind on bind errors

Joshua Washington (1):
      gve: Cache link_speed value from device

Justin Tee (1):
      scsi: lpfc: Check kzalloc() in lpfc_sli4_cgn_params_read()

Kai-Heng Feng (1):
      drm/amdgpu/nv: Apply ASPM quirk on Intel ADL + AMD Navi

Kal Conley (1):
      xsk: Add missing overflow check in xdp_umem_reg

Kang Chen (1):
      scsi: hisi_sas: Check devm_add_action() return value

Krzysztof Kozlowski (1):
      arm64: dts: imx8mm-nitrogen-r2: fix WM8960 clock name

Lama Kayal (1):
      net/mlx5: Fix steering rules cleanup

Li Zetao (1):
      atm: idt77252: fix kmemleak when rmmod idt77252

Liang He (1):
      net: mdio: thunder: Add missing fwnode_handle_put()

Lin Ma (1):
      igb: revert rtnl_lock() that causes deadlock

Lorenz Bauer (1):
      selftests/bpf: check that modifier resolves after pointer

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix responding with wrong PDU type

Maher Sanalla (1):
      net/mlx5: Read the TC mapping of all priorities on ETS query

Marco Elver (1):
      kfence: avoid passing -g for test

Marek Vasut (1):
      arm64: dts: imx8mn: specify #sound-dai-cells for SAI nodes

Mario Limonciello (3):
      thunderbolt: Disable interrupt auto clear for rings
      thunderbolt: Use const qualifier for `ring_interrupt_index`
      ACPI: x86: utils: Add Cezanne to the list for forcing StorageD3Enable

Mark Rutland (2):
      thread_info: Add helpers to snapshot thread flags
      entry: Snapshot thread flags

Masami Hiramatsu (Google) (1):
      bootconfig: Fix testcase to increase max node

Matheus Castello (1):
      drm/bridge: lt8912b: return EPROBE_DEFER if bridge is not found

Maurizio Lombardi (1):
      scsi: target: iscsi: Fix an error message in iscsi_check_key()

Maxime Bizon (1):
      net: mdio: fix owner field for mdio buses registered using device-tree

Michael Kelley (1):
      scsi: storvsc: Handle BlockSize change in Hyper-V VHD/VHDX file

Michael Schmitz (1):
      m68k: Only force 030 bus error if PC not in exception table

Mika Westerberg (2):
      thunderbolt: Use scale field when allocating USB3 bandwidth
      thunderbolt: Call tb_check_quirks() after initializing adapters

Mike Snitzer (1):
      dm crypt: avoid accessing uninitialized tasklet

Mikulas Patocka (1):
      dm crypt: add cond_resched() to dmcrypt_write()

Minghao Chi (1):
      power: supply: bq24190_charger: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

Muchun Song (1):
      mm: kfence: fix using kfence_metadata without initialization in show_object()

Namjae Jeon (5):
      ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA
      ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES
      ksmbd: set FILE_NAMED_STREAMS attribute in FS_ATTRIBUTE_INFORMATION
      ksmbd: return STATUS_NOT_SUPPORTED on unsupported smb2.0 dialect
      ksmbd: return unsupported error on smb1 mount

Nathan Chancellor (1):
      riscv: Handle zicsr/zifencei issues between clang and binutils

Nathan Huckleberry (1):
      fsverity: Remove WQ_UNBOUND from fsverity read workqueue

Nilesh Javali (1):
      scsi: qla2xxx: Perform lockless command completion in abort path

Nirmoy Das (1):
      drm/i915/active: Fix missing debug object activation

Pawel Laszczak (3):
      usb: cdns3: Fix issue with using incorrect PCI device function
      usb: cdnsp: Fixes issue with redundant Status Stage
      usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver

Peng Fan (2):
      ARM: dts: imx6sll: e60k02: fix usbotg1 pinctrl
      ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl

Phinex Hung (1):
      hwmon: fix potential sensor registration fail if of_node is missing

Quinn Tran (1):
      scsi: qla2xxx: Synchronize the IOCB count to be in order

Radoslaw Tyl (1):
      i40e: fix flow director packet filter programming

Randy Dunlap (1):
      serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it

Reka Norman (1):
      HID: intel-ish-hid: ipc: Fix potential use-after-free in work function

Rijo Thomas (1):
      tee: amdtee: fix race condition in amdtee_open_session

Roger Pau Monne (1):
      hvc/xen: prevent concurrent accesses to the shared ring

Ryusuke Konishi (1):
      nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Sherry Sun (1):
      tty: serial: fsl_lpuart: switch to new dmaengine_terminate_* API

Shyam Prasad N (2):
      cifs: empty interface list when server doesn't support query interfaces
      cifs: print session id while listing open files

Song Liu (1):
      perf: fix perf_event_context->time

Stefan Assmann (1):
      iavf: fix hang on reboot with ice

Stephan Gerhold (1):
      Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Szymon Heidrich (1):
      net: usb: smsc95xx: Limit packet length to skb->len

Tero Kristo (1):
      trace/hwlat: Do not start per-cpu thread if it is already running

Tom Rix (1):
      thunderbolt: Rename shadowed variables bit to interrupt_bit and auto_clear_bit

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Ville Syrjälä (1):
      drm/i915: Preserve crtc_state->inherited during state clearing

Vincent Guittot (1):
      sched/fair: Sanitize vruntime of entity being migrated

Vitaly Kuznetsov (1):
      KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL

Wei Chen (1):
      i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()

Xu Yang (3):
      usb: typec: tcpm: fix warning when handle discover_identity message
      usb: chipdea: core: fix return -EINVAL if request role is the same with current role
      usb: chipidea: core: fix possible concurrent when switch role

Yang Jihong (1):
      perf/core: Fix perf_output_begin parameter is incorrectly invoked in perf_event_bpf_output

Yaroslav Furman (1):
      uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Yicong Yang (1):
      i2c: hisi: Only use the completion interrupt to finish the transfer

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

Álvaro Fernández Rojas (2):
      net: dsa: b53: mmap: fix device tree support
      net: dsa: tag_brcm: legacy: fix daisy-chained switches

