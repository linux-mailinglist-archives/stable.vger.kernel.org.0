Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C156C5442
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjCVSzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjCVSy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612FA664CC;
        Wed, 22 Mar 2023 11:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCE5A6223F;
        Wed, 22 Mar 2023 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6A2C433EF;
        Wed, 22 Mar 2023 18:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511221;
        bh=libNiujVZCZ+2qwgEXkdvDckK0SumfLufOTYc3ds8ns=;
        h=From:To:Cc:Subject:Date:From;
        b=tdlK6becaDxVOywVRQtTCuPrfHuPuFfzJ/EYLA//t95k2sPDlGPkcDAzC6k+0TT7a
         bn+zBz1sY6xEi8bxXw7UCC1b04bWHThsAVLi9iMZH5/+4SkKUzAWv4VdcFTt00ZIt9
         iECqTok0S7bzi5ULzT7QmBcJt0CGaAjCiqRq8fk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.104
Date:   Wed, 22 Mar 2023 19:53:22 +0100
Message-Id: <1679511203203220@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.104 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/vfs.rst                              |    2 
 Makefile                                                       |    2 
 arch/riscv/include/asm/mmu.h                                   |    2 
 arch/riscv/include/asm/tlbflush.h                              |   18 
 arch/riscv/mm/context.c                                        |   40 -
 arch/riscv/mm/tlbflush.c                                       |   28 -
 arch/s390/boot/ipl_report.c                                    |    8 
 arch/s390/pci/pci.c                                            |   16 
 arch/s390/pci/pci_bus.c                                        |   12 
 arch/s390/pci/pci_bus.h                                        |    3 
 arch/x86/kernel/cpu/mce/core.c                                 |    1 
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c                      |    7 
 arch/x86/kernel/cpu/resctrl/internal.h                         |    1 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                         |   25 +
 arch/x86/kvm/vmx/nested.c                                      |   10 
 arch/x86/mm/mem_encrypt_identity.c                             |    3 
 drivers/block/loop.c                                           |   25 -
 drivers/block/null_blk/main.c                                  |    6 
 drivers/block/sunvdc.c                                         |    2 
 drivers/clk/Kconfig                                            |    2 
 drivers/cpuidle/cpuidle-psci-domain.c                          |    3 
 drivers/firmware/xilinx/zynqmp.c                               |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                        |    9 
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c |    5 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c        |   43 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c                         |    9 
 drivers/gpu/drm/i915/display/intel_display_types.h             |    2 
 drivers/gpu/drm/i915/display/intel_psr.c                       |  207 +++++++---
 drivers/gpu/drm/i915/gt/intel_ring.c                           |    2 
 drivers/gpu/drm/i915/i915_active.c                             |   24 -
 drivers/gpu/drm/meson/meson_vpp.c                              |    2 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                        |    2 
 drivers/gpu/drm/sun4i/sun4i_drv.c                              |    6 
 drivers/hid/hid-core.c                                         |   18 
 drivers/hid/uhid.c                                             |    1 
 drivers/hwmon/adt7475.c                                        |    8 
 drivers/hwmon/ina3221.c                                        |    2 
 drivers/hwmon/ltc2992.c                                        |    1 
 drivers/hwmon/pmbus/adm1266.c                                  |    1 
 drivers/hwmon/pmbus/ucd9000.c                                  |   75 +++
 drivers/hwmon/tmp513.c                                         |    2 
 drivers/hwmon/xgene-hwmon.c                                    |    1 
 drivers/interconnect/core.c                                    |    4 
 drivers/interconnect/samsung/exynos.c                          |    6 
 drivers/media/i2c/m5mols/m5mols_core.c                         |    2 
 drivers/mmc/host/atmel-mci.c                                   |    3 
 drivers/mmc/host/sdhci_am654.c                                 |    2 
 drivers/net/bonding/bond_main.c                                |   23 -
 drivers/net/dsa/mt7530.c                                       |   64 +--
 drivers/net/dsa/mv88e6xxx/chip.c                               |   16 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |    1 
 drivers/net/ethernet/intel/ice/ice.h                           |   14 
 drivers/net/ethernet/intel/ice/ice_main.c                      |   19 
 drivers/net/ethernet/intel/ice/ice_xsk.c                       |    4 
 drivers/net/ethernet/qlogic/qed/qed_dev.c                      |    5 
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c                  |    2 
 drivers/net/ethernet/renesas/ravb_main.c                       |   12 
 drivers/net/ethernet/renesas/sh_eth.c                          |   12 
 drivers/net/ethernet/sun/ldmvsw.c                              |    3 
 drivers/net/ethernet/sun/sunvnet.c                             |    3 
 drivers/net/ipvlan/ipvlan_l3s.c                                |    1 
 drivers/net/phy/nxp-c45-tja11xx.c                              |    2 
 drivers/net/phy/smsc.c                                         |    5 
 drivers/net/usb/smsc75xx.c                                     |    7 
 drivers/nfc/pn533/usb.c                                        |    1 
 drivers/nfc/st-nci/ndlc.c                                      |    6 
 drivers/nvme/host/core.c                                       |   28 -
 drivers/nvme/host/pci.c                                        |    2 
 drivers/nvme/target/core.c                                     |    4 
 drivers/pci/bus.c                                              |   21 +
 drivers/pci/pci-driver.c                                       |    4 
 drivers/pci/pci.c                                              |   57 +-
 drivers/pci/pci.h                                              |   16 
 drivers/pci/pcie/dpc.c                                         |    4 
 drivers/scsi/hosts.c                                           |    3 
 drivers/scsi/mpt3sas/mpt3sas_transport.c                       |   14 
 drivers/tty/serial/8250/8250_em.c                              |    4 
 drivers/tty/serial/8250/8250_fsl.c                             |    4 
 drivers/tty/serial/fsl_lpuart.c                                |   12 
 drivers/vdpa/vdpa_sim/vdpa_sim.c                               |   13 
 drivers/video/fbdev/stifb.c                                    |   27 +
 fs/cifs/smb2inode.c                                            |   31 +
 fs/cifs/transport.c                                            |   21 -
 fs/ext4/inode.c                                                |   18 
 fs/ext4/namei.c                                                |    4 
 fs/ext4/super.c                                                |    7 
 fs/ext4/xattr.c                                                |   11 
 fs/jffs2/file.c                                                |   15 
 include/drm/drm_bridge.h                                       |    4 
 include/linux/hid.h                                            |    3 
 include/linux/netdevice.h                                      |    6 
 include/linux/pci.h                                            |    1 
 include/linux/sh_intc.h                                        |    5 
 include/linux/tracepoint.h                                     |   15 
 io_uring/io_uring.c                                            |    4 
 kernel/events/core.c                                           |    2 
 kernel/trace/ftrace.c                                          |    3 
 kernel/trace/trace.c                                           |    2 
 kernel/trace/trace_events_hist.c                               |    3 
 kernel/trace/trace_hwlat.c                                     |    3 
 mm/huge_memory.c                                               |    6 
 net/9p/client.c                                                |    2 
 net/ipv4/fib_frontend.c                                        |    3 
 net/ipv4/ip_tunnel.c                                           |   12 
 net/ipv4/tcp_output.c                                          |    2 
 net/ipv6/ip6_tunnel.c                                          |    4 
 net/iucv/iucv.c                                                |    2 
 net/mptcp/pm_netlink.c                                         |   16 
 net/mptcp/subflow.c                                            |   12 
 net/netfilter/nft_masq.c                                       |    2 
 net/netfilter/nft_nat.c                                        |    2 
 net/netfilter/nft_redir.c                                      |    4 
 net/smc/smc_cdc.c                                              |    3 
 net/smc/smc_core.c                                             |    2 
 net/xfrm/xfrm_state.c                                          |    3 
 scripts/kconfig/confdata.c                                     |    6 
 sound/hda/intel-dsp-config.c                                   |    9 
 sound/pci/hda/hda_intel.c                                      |    5 
 sound/pci/hda/patch_realtek.c                                  |    1 
 tools/testing/selftests/net/devlink_port_split.py              |   36 +
 120 files changed, 919 insertions(+), 439 deletions(-)

Alex Hung (1):
      drm/amd/display: fix shift-out-of-bounds in CalculateVMAndRowBytes

Alexandra Winter (1):
      net/iucv: Fix size of interrupt data

Arınç ÜNAL (2):
      net: dsa: mt7530: remove now incorrect comment regarding port 5
      net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used

Baokun Li (3):
      ext4: fail ext4_iget if special inode unallocated
      ext4: update s_journal_inum if it changes after journal replay
      ext4: fix task hung in ext4_xattr_delete_inode

Bard Liao (1):
      ALSA: hda: intel-dsp-config: add MTL PCI id

Bart Van Assche (2):
      scsi: core: Fix a procfs host directory removal regression
      loop: Fix use-after-free issues

Biju Das (1):
      serial: 8250_em: Fix UART port type

Bjorn Helgaas (1):
      ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()

Breno Leitao (1):
      tcp: tcp_make_synack() can be called from process context

Budimir Markovic (1):
      perf: Fix check before add_event_to_groups() in perf_group_detach()

Błażej Szczygieł (1):
      drm/amd/pm: Fix sienna cichlid incorrect OD volage after resume

Chen Zhongjin (1):
      ftrace: Fix invalid address access in lookup_rec() when index is 0

Christian Hewitt (1):
      drm/meson: fix 1px pink line on GXM when scaling video overlay

D. Wythe (1):
      net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()

Damien Le Moal (2):
      block: null_blk: Fix handling of fake timeout request
      nvmet: avoid potential UAF in nvmet_req_complete()

Daniil Tatianin (2):
      qed/qed_dev: guard against a possible division by zero
      qed/qed_mng_tlv: correctly zero out ->min instead of ->hour

Dave Ertman (1):
      ice: avoid bonding causing auxiliary plug/unplug under RTNL lock

David Hildenbrand (1):
      mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage

Dmitry Osipenko (2):
      drm/panfrost: Don't sync rpm suspension after mmu flushing
      drm/shmem-helper: Remove another errant put in error path

Elmer Miroslav Mosher Golovin (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000

Eric Dumazet (1):
      net: tunnels: annotate lockless accesses to dev->needed_headroom

Eric Van Hensbergen (1):
      net/9p: fix bug in client create for .L

Eugenio Pérez (2):
      vdpa_sim: not reset state in vdpasim_queue_ready
      vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready

Fedor Pchelkin (2):
      nfc: pn533: initialize struct pn533_out_arg properly
      io_uring: avoid null-ptr-deref in io_arm_poll_handler

Francesco Dolcini (1):
      mmc: sdhci_am654: lower power-on failed message severity

Geliang Tang (1):
      mptcp: add ro_after_init for tcp{,v6}_prot_override

Glenn Washburn (1):
      docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate

Greg Kroah-Hartman (1):
      Linux 5.15.104

Guo Ren (1):
      riscv: asid: Fixup stale TLB entry cause application crash

Hamidreza H. Fard (1):
      ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro

Heiner Kallweit (1):
      net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Helge Deller (1):
      fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Herbert Xu (1):
      xfrm: Allow transport-mode states with AF_UNSPEC selector

Ido Schimmel (1):
      ipv4: Fix incorrect table ID in IOCTL path

Ivan Vecera (1):
      i40e: Fix kernel crash during reboot when adapter is in recovery mode

Janusz Krzysztofik (1):
      drm/i915/active: Fix misuse of non-idle barriers as fence trackers

Jeremy Sowden (4):
      netfilter: nft_nat: correct length for loading protocol registers
      netfilter: nft_masq: correct length for loading protocol registers
      netfilter: nft_redir: correct length for loading protocol registers
      netfilter: nft_redir: correct value of inet type `.maxattrs`

Jianguo Wu (1):
      ipvlan: Make skb->skb_iif track skb->dev for l3s mode

Johan Hovold (4):
      serial: 8250_fsl: fix handle_irq locking
      interconnect: fix mem leak when freeing nodes
      interconnect: exynos: fix node leak in probe PM QoS error path
      drm/sun4i: fix missing component unbind on bind errors

John Harrison (1):
      drm/i915: Don't use stolen memory for ring buffers with LLC

José Roberto de Souza (3):
      drm/i915/display: Workaround cursor left overs with PSR2 selective fetch enabled
      drm/i915/display/psr: Use drm damage helpers to calculate plane damaged area
      drm/i915/display/psr: Handle plane and pipe restrictions at every page flip

Jouni Högander (1):
      drm/i915/psr: Use calculated io and fast wake lines

Jurica Vukadin (1):
      kconfig: Update config changed flag before calling callback

Krzysztof Kozlowski (1):
      hwmon: tmp512: drop of_match_ptr for ID table

Lars-Peter Clausen (3):
      hwmon: (ucd90320) Add minimum delay between bus accesses
      hwmon: (adm1266) Set `can_sleep` flag for GPIO chip
      hwmon: (ltc2992) Set `can_sleep` flag for GPIO chip

Lee Jones (2):
      HID: core: Provide new max_buffer_size attribute to over-ride the default
      HID: uhid: Over-ride the default maximum data buffer value with our own

Liang He (2):
      block: sunvdc: add check for mdesc_grab() returning NULL
      ethernet: sun: add check for the mdesc_grab()

Linus Torvalds (1):
      media: m5mols: fix off-by-one loop termination error

Liu Ying (1):
      drm/bridge: Fix returned array size name for atomic_get_input_bus_fmts kdoc

Lukas Wunner (2):
      PCI: Unify delay handling for reset and resume
      PCI/DPC: Await readiness of secondary bus after reset

Maciej Fijalkowski (1):
      ice: xsk: disable txq irq before flushing hw

Marcus Folkesson (1):
      hwmon: (ina3221) return prober error code

Matthieu Baerts (1):
      mptcp: avoid setting TCP_CLOSE state twice

Michael Karcher (1):
      sh: intc: Avoid spurious sizeof-pointer-div warning

Ming Lei (1):
      nvme: fix handling single range discard request

Nikita Zhandarovich (1):
      x86/mm: Fix use of uninitialized buffer in sme_enable()

Niklas Schnelle (1):
      PCI: s390: Fix use-after-free of PCI resources with per-function hotplug

Nikolay Aleksandrov (2):
      bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change
      bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails

Paolo Abeni (2):
      mptcp: fix possible deadlock in subflow_error_report
      mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()

Paolo Bonzini (1):
      KVM: nVMX: add missing consistency checks for CR0 and CR4

Po-Hsu Lin (1):
      selftests: net: devlink_port_split.py: skip test if no suitable device available

Qu Huang (1):
      drm/amdkfd: Fix an illegal memory access

Radu Pirea (OSS) (1):
      net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit

Randy Dunlap (1):
      clk: HI655X: select REGMAP instead of depending on it

Roman Gushchin (1):
      firmware: xilinx: don't make a sleepable memory allocation from an atomic context

Sergey Matyukevich (1):
      Revert "riscv: mm: notify remote harts about mmu cache updates"

Shawn Guo (1):
      cpuidle: psci: Iterate backwards over list in psci_pd_remove()

Shawn Wang (1):
      x86/resctrl: Clear staged_config[] before and after it is used

Sherry Sun (1):
      tty: serial: fsl_lpuart: skip waiting for transmission complete when UARTCTRL_SBK is asserted

Steven Rostedt (Google) (2):
      tracing: Check field value in hist_field_name()
      tracing: Make tracepoint lockdep check actually test something

Sung-hun Kim (1):
      tracing: Make splice_read available again

Sven Schnelle (1):
      s390/ipl: add missing intersection check to ipl_report handling

Szymon Heidrich (2):
      net: usb: smsc75xx: Limit packet length to skb->len
      net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Tero Kristo (1):
      trace/hwlat: Do not wipe the contents of per-cpu thread data

Theodore Ts'o (1):
      ext4: fix possible double unlock when moving a directory

Tobias Schramm (1):
      mmc: atmel-mci: fix race between stop command and start of next command

Tom Rix (1):
      drm/i915/display: clean up comments

Tony O'Brien (2):
      hwmon: (adt7475) Display smoothing attributes in correct order
      hwmon: (adt7475) Fix masking of hysteresis registers

Vladimir Oltean (1):
      net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290

Volker Lendecke (1):
      cifs: Fix smb2_set_path_size()

Wenchao Hao (1):
      scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()

Wenjia Zhang (1):
      net/smc: fix deadlock triggered by cancel_delayed_work_syn()

Wolfram Sang (2):
      ravb: avoid PHY being resumed when interface is not up
      sh_eth: avoid PHY being resumed when interface is not up

Yazen Ghannam (1):
      x86/mce: Make sure logged MCEs are processed after sysfs update

Yifei Liu (1):
      jffs2: correct logic when creating a hole in jffs2_write_begin

Zhang Xiaoxu (1):
      cifs: Move the in_send statistic to __smb_send_rqst()

Zheng Wang (2):
      nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
      hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

