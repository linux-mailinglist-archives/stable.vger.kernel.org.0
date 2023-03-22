Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DF96C5440
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCVSzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCVSyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:54:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C33302BA;
        Wed, 22 Mar 2023 11:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B32FCE1EA4;
        Wed, 22 Mar 2023 18:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06D3C433D2;
        Wed, 22 Mar 2023 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511213;
        bh=112/IaY8qx2ptVTH8uRz8tNQliXCTGmPfGQv28cblIs=;
        h=From:To:Cc:Subject:Date:From;
        b=gKWzZgmLOPIz8CVaX5xuoUHkz56nZZURRHEv+WGppIdWZjXCXYR1jiT0Qtag1puIp
         nqgZ9C7AyoT1FOPJShMD5yZi9CiMi/ZpAViW7xzxtOLPdeT66FA1nfmw/rWWUyvjzC
         Umfm1+4y4oPZzgmAlvf8wwd48VanfC+7Vdlz1gzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.176
Date:   Wed, 22 Mar 2023 19:53:17 +0100
Message-Id: <1679511198146230@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.176 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/vfs.rst                              |    2 
 Documentation/trace/ftrace.rst                                 |    2 
 Makefile                                                       |    2 
 arch/s390/boot/ipl_report.c                                    |    8 
 arch/x86/kernel/cpu/mce/core.c                                 |    1 
 arch/x86/kvm/vmx/nested.c                                      |   10 
 arch/x86/mm/mem_encrypt_identity.c                             |    3 
 drivers/block/Kconfig                                          |    8 
 drivers/block/Makefile                                         |    7 
 drivers/block/null_blk.h                                       |  137 
 drivers/block/null_blk/Kconfig                                 |   12 
 drivers/block/null_blk/Makefile                                |   11 
 drivers/block/null_blk/main.c                                  | 2036 ++++++++++
 drivers/block/null_blk/null_blk.h                              |  137 
 drivers/block/null_blk/trace.c                                 |   21 
 drivers/block/null_blk/trace.h                                 |   79 
 drivers/block/null_blk/zoned.c                                 |  617 +++
 drivers/block/null_blk_main.c                                  | 2036 ----------
 drivers/block/null_blk_trace.c                                 |   21 
 drivers/block/null_blk_trace.h                                 |   79 
 drivers/block/null_blk_zoned.c                                 |  617 ---
 drivers/block/sunvdc.c                                         |    2 
 drivers/clk/Kconfig                                            |    2 
 drivers/cpuidle/cpuidle-psci-domain.c                          |    3 
 drivers/firmware/xilinx/zynqmp.c                               |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c                        |    9 
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c |    5 
 drivers/gpu/drm/drm_gem_shmem_helper.c                         |    9 
 drivers/gpu/drm/i915/gt/intel_ring.c                           |    2 
 drivers/gpu/drm/i915/i915_active.c                             |   24 
 drivers/gpu/drm/meson/meson_vpp.c                              |    2 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                        |    2 
 drivers/hid/hid-core.c                                         |   18 
 drivers/hid/uhid.c                                             |    1 
 drivers/hwmon/adt7475.c                                        |    8 
 drivers/hwmon/ina3221.c                                        |    2 
 drivers/hwmon/pmbus/adm1266.c                                  |    1 
 drivers/hwmon/pmbus/ucd9000.c                                  |   75 
 drivers/hwmon/tmp513.c                                         |    2 
 drivers/hwmon/xgene-hwmon.c                                    |    1 
 drivers/interconnect/core.c                                    |    4 
 drivers/media/i2c/m5mols/m5mols_core.c                         |    2 
 drivers/mmc/host/atmel-mci.c                                   |    3 
 drivers/mmc/host/sdhci_am654.c                                 |    2 
 drivers/net/dsa/mv88e6xxx/chip.c                               |   16 
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |    1 
 drivers/net/ethernet/intel/ice/ice_xsk.c                       |    4 
 drivers/net/ethernet/qlogic/qed/qed_dev.c                      |    5 
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c                  |    2 
 drivers/net/ethernet/sun/ldmvsw.c                              |    3 
 drivers/net/ethernet/sun/sunvnet.c                             |    3 
 drivers/net/ipvlan/ipvlan_l3s.c                                |    1 
 drivers/net/phy/smsc.c                                         |    5 
 drivers/net/usb/smsc75xx.c                                     |    7 
 drivers/nfc/pn533/usb.c                                        |    1 
 drivers/nfc/st-nci/ndlc.c                                      |    6 
 drivers/nvme/host/core.c                                       |   28 
 drivers/nvme/target/core.c                                     |    4 
 drivers/pci/pci-driver.c                                       |    4 
 drivers/pci/pci.c                                              |   57 
 drivers/pci/pci.h                                              |   16 
 drivers/pci/pcie/dpc.c                                         |    4 
 drivers/scsi/hosts.c                                           |    5 
 drivers/scsi/mpt3sas/mpt3sas_transport.c                       |   14 
 drivers/tty/serial/8250/8250_em.c                              |    4 
 drivers/tty/serial/fsl_lpuart.c                                |   12 
 drivers/video/fbdev/stifb.c                                    |   27 
 fs/attr.c                                                      |   70 
 fs/cifs/smb2inode.c                                            |   31 
 fs/cifs/transport.c                                            |   21 
 fs/ext4/inode.c                                                |   18 
 fs/ext4/namei.c                                                |    4 
 fs/ext4/xattr.c                                                |   11 
 fs/inode.c                                                     |   80 
 fs/internal.h                                                  |    6 
 fs/jffs2/file.c                                                |   15 
 fs/namei.c                                                     |   80 
 fs/ocfs2/file.c                                                |    4 
 fs/ocfs2/namei.c                                               |    1 
 fs/open.c                                                      |    6 
 fs/xfs/libxfs/xfs_btree.c                                      |    8 
 fs/xfs/xfs_bmap_util.c                                         |    9 
 fs/xfs/xfs_file.c                                              |   24 
 fs/xfs/xfs_iops.c                                              |   56 
 fs/xfs/xfs_iops.h                                              |    1 
 fs/xfs/xfs_mount.c                                             |    3 
 fs/xfs/xfs_pnfs.c                                              |    9 
 fs/xfs/xfs_qm.c                                                |    9 
 include/drm/drm_bridge.h                                       |    4 
 include/linux/fs.h                                             |    5 
 include/linux/hid.h                                            |    3 
 include/linux/netdevice.h                                      |    6 
 include/linux/sh_intc.h                                        |    5 
 include/linux/tracepoint.h                                     |   15 
 io_uring/io_uring.c                                            |    4 
 kernel/trace/ftrace.c                                          |    3 
 kernel/trace/trace.c                                           |    2 
 kernel/trace/trace_events_hist.c                               |    3 
 mm/huge_memory.c                                               |    6 
 net/ipv4/fib_frontend.c                                        |    3 
 net/ipv4/ip_tunnel.c                                           |   12 
 net/ipv4/tcp_output.c                                          |    2 
 net/ipv6/ip6_tunnel.c                                          |    4 
 net/iucv/iucv.c                                                |    2 
 net/mptcp/subflow.c                                            |    1 
 net/netfilter/nft_masq.c                                       |    2 
 net/netfilter/nft_nat.c                                        |    2 
 net/netfilter/nft_redir.c                                      |    4 
 net/smc/smc_cdc.c                                              |    3 
 net/smc/smc_core.c                                             |    2 
 net/xfrm/xfrm_state.c                                          |    3 
 sound/hda/intel-dsp-config.c                                   |    9 
 sound/pci/hda/hda_intel.c                                      |    5 
 sound/pci/hda/patch_realtek.c                                  |    1 
 tools/testing/selftests/net/devlink_port_split.py              |   30 
 115 files changed, 3620 insertions(+), 3243 deletions(-)

Alex Hung (1):
      drm/amd/display: fix shift-out-of-bounds in CalculateVMAndRowBytes

Alexandra Winter (1):
      net/iucv: Fix size of interrupt data

Amir Goldstein (4):
      attr: add in_group_or_capable()
      fs: move should_remove_suid()
      attr: add setattr_should_drop_sgid()
      attr: use consistent sgid stripping checks

Baokun Li (2):
      ext4: fail ext4_iget if special inode unallocated
      ext4: fix task hung in ext4_xattr_delete_inode

Bard Liao (1):
      ALSA: hda: intel-dsp-config: add MTL PCI id

Bart Van Assche (1):
      scsi: core: Fix a procfs host directory removal regression

Biju Das (1):
      serial: 8250_em: Fix UART port type

Bjorn Helgaas (1):
      ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()

Breno Leitao (1):
      tcp: tcp_make_synack() can be called from process context

Chen Zhongjin (1):
      ftrace: Fix invalid address access in lookup_rec() when index is 0

Christian Brauner (1):
      fs: use consistent setgid checks in is_sxid()

Christian Hewitt (1):
      drm/meson: fix 1px pink line on GXM when scaling video overlay

D. Wythe (1):
      net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()

Damien Le Moal (3):
      null_blk: Move driver into its own directory
      block: null_blk: Fix handling of fake timeout request
      nvmet: avoid potential UAF in nvmet_req_complete()

Daniil Tatianin (2):
      qed/qed_dev: guard against a possible division by zero
      qed/qed_mng_tlv: correctly zero out ->min instead of ->hour

Darrick J. Wong (3):
      xfs: purge dquots after inode walk fails during quotacheck
      xfs: don't leak btree cursor when insrec fails after a split
      xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (4):
      xfs: don't assert fail on perag references on teardown
      xfs: remove XFS_PREALLOC_SYNC
      xfs: fallocate() should call file_modified()
      xfs: set prealloc flag in xfs_alloc_file_space()

David Hildenbrand (1):
      mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage

Dmitry Osipenko (2):
      drm/panfrost: Don't sync rpm suspension after mmu flushing
      drm/shmem-helper: Remove another errant put in error path

Eric Dumazet (1):
      net: tunnels: annotate lockless accesses to dev->needed_headroom

Fedor Pchelkin (2):
      nfc: pn533: initialize struct pn533_out_arg properly
      io_uring: avoid null-ptr-deref in io_arm_poll_handler

Francesco Dolcini (1):
      mmc: sdhci_am654: lower power-on failed message severity

Gaosheng Cui (1):
      xfs: remove xfs_setattr_time() declaration

Glenn Washburn (1):
      docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate

Greg Kroah-Hartman (1):
      Linux 5.10.176

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

Johan Hovold (1):
      interconnect: fix mem leak when freeing nodes

John Harrison (1):
      drm/i915: Don't use stolen memory for ring buffers with LLC

Krzysztof Kozlowski (1):
      hwmon: tmp512: drop of_match_ptr for ID table

Lars-Peter Clausen (2):
      hwmon: (ucd90320) Add minimum delay between bus accesses
      hwmon: (adm1266) Set `can_sleep` flag for GPIO chip

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

Paolo Bonzini (1):
      KVM: nVMX: add missing consistency checks for CR0 and CR4

Po-Hsu Lin (1):
      selftests: net: devlink_port_split.py: skip test if no suitable device available

Qu Huang (1):
      drm/amdkfd: Fix an illegal memory access

Randy Dunlap (1):
      clk: HI655X: select REGMAP instead of depending on it

Roman Gushchin (1):
      firmware: xilinx: don't make a sleepable memory allocation from an atomic context

Shawn Guo (1):
      cpuidle: psci: Iterate backwards over list in psci_pd_remove()

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

Theodore Ts'o (1):
      ext4: fix possible double unlock when moving a directory

Tobias Schramm (1):
      mmc: atmel-mci: fix race between stop command and start of next command

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

Xiang Chen (1):
      scsi: core: Fix a comment in function scsi_host_dev_release()

Yang Xu (2):
      fs: add mode_strip_sgid() helper
      fs: move S_ISGID stripping into the vfs_*() helpers

Yazen Ghannam (1):
      x86/mce: Make sure logged MCEs are processed after sysfs update

Yifei Liu (1):
      jffs2: correct logic when creating a hole in jffs2_write_begin

Zhang Xiaoxu (1):
      cifs: Move the in_send statistic to __smb_send_rqst()

Zheng Wang (2):
      nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
      hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

