Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78026C543E
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjCVSyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjCVSx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:53:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB354DBCF;
        Wed, 22 Mar 2023 11:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4226A62283;
        Wed, 22 Mar 2023 18:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD8BC433EF;
        Wed, 22 Mar 2023 18:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511210;
        bh=GRDzOUJy5qdsLXKAnvzNtUfeK85/4gBGog3WGP+aR4w=;
        h=From:To:Cc:Subject:Date:From;
        b=FaLXbKtavXmI3xS1PqD7disIbyWnR6lA6lA/QONB/pmCR24bsjvlpEEScU8XxKUF2
         Em9FtsPFUkugPFeiut82c/KRsup69QlvsKWxBuWIadi/orlWX7X8RMSXARnsLM1UPI
         UBrM9Cce6rdp6URyLQmFlA2vh2PxyFXNLWLyEU+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.238
Date:   Wed, 22 Mar 2023 19:53:11 +0100
Message-Id: <167951119115473@kroah.com>
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

I'm announcing the release of the 5.4.238 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/vfs.rst           |    2 -
 Makefile                                    |    2 -
 arch/s390/boot/ipl_report.c                 |    8 ++++
 arch/x86/kvm/vmx/nested.c                   |   10 ++++-
 arch/x86/mm/mem_encrypt_identity.c          |    3 +
 drivers/block/sunvdc.c                      |    2 +
 drivers/clk/Kconfig                         |    2 -
 drivers/gpu/drm/amd/amdkfd/kfd_events.c     |    9 +---
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c  |    5 +-
 drivers/gpu/drm/meson/meson_vpp.c           |    2 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c     |    2 -
 drivers/hid/hid-core.c                      |   18 ++++++---
 drivers/hid/uhid.c                          |    1 
 drivers/hwmon/adt7475.c                     |    8 ++--
 drivers/hwmon/ina3221.c                     |    2 -
 drivers/hwmon/xgene-hwmon.c                 |    1 
 drivers/interconnect/core.c                 |    4 ++
 drivers/media/i2c/m5mols/m5mols_core.c      |    2 -
 drivers/mmc/host/atmel-mci.c                |    3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c |    1 
 drivers/net/ethernet/qlogic/qed/qed_dev.c   |    5 ++
 drivers/net/ethernet/sun/ldmvsw.c           |    3 +
 drivers/net/ethernet/sun/sunvnet.c          |    3 +
 drivers/net/ipvlan/ipvlan_l3s.c             |    1 
 drivers/net/phy/smsc.c                      |    5 ++
 drivers/net/usb/smsc75xx.c                  |    7 +++
 drivers/nfc/pn533/usb.c                     |    1 
 drivers/nfc/st-nci/ndlc.c                   |    6 ++-
 drivers/nvme/target/core.c                  |    4 +-
 drivers/pci/pci-driver.c                    |    4 +-
 drivers/pci/pci.c                           |   54 ++++++++++++----------------
 drivers/pci/pci.h                           |   10 ++++-
 drivers/scsi/hosts.c                        |    5 --
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |   14 ++++++-
 drivers/tty/serial/8250/8250_em.c           |    4 +-
 drivers/tty/serial/fsl_lpuart.c             |   12 ++++--
 drivers/video/fbdev/stifb.c                 |   27 ++++++++++++++
 fs/cifs/transport.c                         |   21 ++++------
 fs/ext4/inode.c                             |   18 ++++-----
 fs/ext4/namei.c                             |    4 --
 fs/ext4/page-io.c                           |   10 +++--
 fs/ext4/xattr.c                             |   11 +++++
 fs/jffs2/file.c                             |   15 +++----
 include/linux/hid.h                         |    3 +
 include/linux/netdevice.h                   |    6 ++-
 include/linux/sh_intc.h                     |    5 ++
 include/linux/tracepoint.h                  |   15 +++----
 kernel/trace/ftrace.c                       |    3 +
 kernel/trace/trace_events_hist.c            |    3 +
 net/ipv4/fib_frontend.c                     |    3 +
 net/ipv4/ip_tunnel.c                        |   12 +++---
 net/ipv4/tcp_output.c                       |    2 -
 net/ipv6/ip6_tunnel.c                       |    4 +-
 net/iucv/iucv.c                             |    2 -
 net/netfilter/nft_redir.c                   |    2 -
 net/xfrm/xfrm_state.c                       |    3 -
 sound/pci/hda/hda_intel.c                   |   22 ++++++++++-
 sound/pci/hda/patch_hdmi.c                  |    3 +
 58 files changed, 276 insertions(+), 143 deletions(-)

Alexandra Winter (1):
      net/iucv: Fix size of interrupt data

Baokun Li (2):
      ext4: fail ext4_iget if special inode unallocated
      ext4: fix task hung in ext4_xattr_delete_inode

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

Christian Hewitt (1):
      drm/meson: fix 1px pink line on GXM when scaling video overlay

Damien Le Moal (1):
      nvmet: avoid potential UAF in nvmet_req_complete()

Daniil Tatianin (1):
      qed/qed_dev: guard against a possible division by zero

Dmitry Osipenko (1):
      drm/panfrost: Don't sync rpm suspension after mmu flushing

Eric Biggers (1):
      ext4: fix cgroup writeback accounting with fs-layer encryption

Eric Dumazet (1):
      net: tunnels: annotate lockless accesses to dev->needed_headroom

Fedor Pchelkin (1):
      nfc: pn533: initialize struct pn533_out_arg properly

Glenn Washburn (1):
      docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate

Greg Kroah-Hartman (1):
      Linux 5.4.238

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

Jeremy Sowden (1):
      netfilter: nft_redir: correct value of inet type `.maxattrs`

Jianguo Wu (1):
      ipvlan: Make skb->skb_iif track skb->dev for l3s mode

Johan Hovold (1):
      interconnect: fix mem leak when freeing nodes

John Harrison (1):
      drm/i915: Don't use stolen memory for ring buffers with LLC

Kai Vehmanen (4):
      ALSA: hda - add Intel DG1 PCI and HDMI ids
      ALSA: hda - controller is in GPU on the DG1
      ALSA: hda: Add Alderlake-S PCI ID and HDMI codec vid
      ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid

Lee Jones (2):
      HID: core: Provide new max_buffer_size attribute to over-ride the default
      HID: uhid: Over-ride the default maximum data buffer value with our own

Liang He (2):
      block: sunvdc: add check for mdesc_grab() returning NULL
      ethernet: sun: add check for the mdesc_grab()

Linus Torvalds (1):
      media: m5mols: fix off-by-one loop termination error

Lukas Wunner (1):
      PCI: Unify delay handling for reset and resume

Marcus Folkesson (1):
      hwmon: (ina3221) return prober error code

Michael Karcher (1):
      sh: intc: Avoid spurious sizeof-pointer-div warning

Nikita Zhandarovich (1):
      x86/mm: Fix use of uninitialized buffer in sme_enable()

Paolo Bonzini (1):
      KVM: nVMX: add missing consistency checks for CR0 and CR4

Qu Huang (1):
      drm/amdkfd: Fix an illegal memory access

Randy Dunlap (1):
      clk: HI655X: select REGMAP instead of depending on it

Sherry Sun (1):
      tty: serial: fsl_lpuart: skip waiting for transmission complete when UARTCTRL_SBK is asserted

Steven Rostedt (Google) (2):
      tracing: Check field value in hist_field_name()
      tracing: Make tracepoint lockdep check actually test something

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

Wenchao Hao (1):
      scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()

Xiang Chen (1):
      scsi: core: Fix a comment in function scsi_host_dev_release()

Yifei Liu (1):
      jffs2: correct logic when creating a hole in jffs2_write_begin

Zhang Xiaoxu (1):
      cifs: Move the in_send statistic to __smb_send_rqst()

Zheng Wang (2):
      nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
      hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

