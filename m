Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782B75B9877
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 12:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiIOKGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 06:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIOKGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 06:06:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FD731367;
        Thu, 15 Sep 2022 03:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD5A7B81F51;
        Thu, 15 Sep 2022 10:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55238C433C1;
        Thu, 15 Sep 2022 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663236369;
        bh=/mh07OXLnyI9+3v1PrhT2Q2s4QNgVGNPzvkEbxn3Heg=;
        h=From:To:Cc:Subject:Date:From;
        b=hJ5fqIZJrofRdg/oaqLaeRpd9n/gq+y/nlZIOWMUCk/sj84T0x37OiYT7QLqRKYmK
         60ckAqvWt+ErCMaq53HI1TjkcZuVnxmK7mvKaRfIgL6s6S2zR0JP52JdAiEUIDheS8
         VfXiKjjcWuokfa+bolupDmk7gDNiwoqb57ZXdjcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.213
Date:   Thu, 15 Sep 2022 12:06:34 +0200
Message-Id: <1663236394781@kroah.com>
X-Mailer: git-send-email 2.37.3
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

I'm announcing the release of the 5.4.213 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi      |   10 --
 arch/arm64/kernel/cacheinfo.c                      |    6 +
 arch/mips/loongson32/ls1c/board.c                  |    1 
 arch/parisc/kernel/head.S                          |   43 +++++++++
 arch/powerpc/kernel/systbl.S                       |    1 
 arch/s390/include/asm/hugetlb.h                    |    6 -
 arch/s390/kernel/vmlinux.lds.S                     |    1 
 arch/x86/include/asm/nospec-branch.h               |   14 +++
 drivers/android/binder.c                           |   12 ++
 drivers/base/dd.c                                  |   10 ++
 drivers/clk/bcm/clk-raspberrypi.c                  |    2 
 drivers/clk/clk.c                                  |    3 
 drivers/firmware/efi/capsule-loader.c              |   31 +------
 drivers/gpio/gpio-pca953x.c                        |    8 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |    3 
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c            |    1 
 drivers/gpu/drm/drm_gem.c                          |   17 ---
 drivers/gpu/drm/drm_internal.h                     |    4 
 drivers/gpu/drm/drm_prime.c                        |   20 ++--
 drivers/gpu/drm/i915/display/intel_quirks.c        |    3 
 drivers/gpu/drm/i915/gvt/handlers.c                |    2 
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |    2 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |    2 
 drivers/gpu/drm/radeon/radeon_device.c             |    3 
 drivers/hwmon/gpio-fan.c                           |    3 
 drivers/iio/adc/mcp3911.c                          |   19 +++-
 drivers/infiniband/core/cma.c                      |    4 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |    2 
 drivers/infiniband/hw/mlx5/mad.c                   |    6 +
 drivers/infiniband/sw/siw/siw_qp_tx.c              |   18 +++-
 drivers/input/joystick/iforce/iforce-serio.c       |    6 -
 drivers/input/joystick/iforce/iforce-usb.c         |    8 -
 drivers/input/joystick/iforce/iforce.h             |    6 +
 drivers/input/misc/rk805-pwrkey.c                  |    1 
 drivers/misc/fastrpc.c                             |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |    5 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |    4 
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |    2 
 drivers/net/ieee802154/adf7242.c                   |    3 
 drivers/net/phy/dp83822.c                          |    1 
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    5 -
 drivers/nvme/host/tcp.c                            |    2 
 drivers/nvme/target/core.c                         |    6 -
 drivers/parisc/ccio-dma.c                          |   11 +-
 drivers/platform/x86/pmc_atom.c                    |    2 
 drivers/regulator/core.c                           |    9 +-
 drivers/scsi/lpfc/lpfc_init.c                      |    5 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |    1 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |    2 
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                |   50 +++++++++--
 drivers/staging/rtl8712/rtl8712_cmd.c              |   36 --------
 drivers/thunderbolt/ctl.c                          |    2 
 drivers/tty/serial/fsl_lpuart.c                    |    5 -
 drivers/tty/vt/vt.c                                |   12 +-
 drivers/usb/class/cdc-acm.c                        |    3 
 drivers/usb/core/hub.c                             |   10 ++
 drivers/usb/dwc2/platform.c                        |    8 -
 drivers/usb/dwc3/core.c                            |   19 ++--
 drivers/usb/dwc3/dwc3-qcom.c                       |   14 +++
 drivers/usb/dwc3/host.c                            |   11 ++
 drivers/usb/gadget/function/storage_common.c       |    6 -
 drivers/usb/host/xhci-hub.c                        |   13 ++-
 drivers/usb/host/xhci.c                            |   19 +---
 drivers/usb/host/xhci.h                            |    4 
 drivers/usb/serial/ch341.c                         |   15 +++
 drivers/usb/serial/cp210x.c                        |    1 
 drivers/usb/serial/ftdi_sio.c                      |    2 
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/option.c                        |   15 +++
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/usb/typec/altmodes/displayport.c           |    4 
 drivers/video/fbdev/chipsfb.c                      |    1 
 fs/afs/flock.c                                     |    2 
 fs/afs/fsclient.c                                  |    2 
 fs/afs/internal.h                                  |    3 
 fs/afs/rxrpc.c                                     |    7 -
 fs/afs/yfsclient.c                                 |    3 
 fs/btrfs/volumes.c                                 |   44 ++++++++--
 fs/cifs/smb2ops.c                                  |   10 +-
 fs/debugfs/inode.c                                 |   22 +++++
 include/linux/buffer_head.h                        |   11 ++
 include/linux/debugfs.h                            |    6 +
 include/linux/platform_data/x86/pmc_atom.h         |    6 -
 include/linux/usb.h                                |    2 
 include/linux/usb/typec_dp.h                       |    5 +
 kernel/cgroup/cgroup-internal.h                    |    5 -
 kernel/cgroup/cgroup-v1.c                          |    5 -
 kernel/cgroup/cgroup.c                             |   91 +++++++++++++++++----
 kernel/cgroup/cpuset.c                             |    3 
 kernel/kprobes.c                                   |    1 
 mm/kmemleak.c                                      |    8 -
 net/bridge/br_netfilter_hooks.c                    |    2 
 net/bridge/br_netfilter_ipv6.c                     |    1 
 net/ipv4/fib_frontend.c                            |    4 
 net/ipv4/tcp_input.c                               |   29 ++++--
 net/ipv6/seg6.c                                    |    5 +
 net/kcm/kcmsock.c                                  |   15 +--
 net/mac80211/ibss.c                                |    4 
 net/mac802154/rx.c                                 |    2 
 net/netfilter/nf_conntrack_irc.c                   |    5 -
 net/rxrpc/rxkad.c                                  |    2 
 net/sched/sch_sfb.c                                |   13 +--
 net/sched/sch_tbf.c                                |    4 
 net/smc/af_smc.c                                   |    1 
 net/tipc/monitor.c                                 |    2 
 net/wireless/debugfs.c                             |    3 
 sound/core/seq/oss/seq_oss_midi.c                  |    2 
 sound/core/seq/seq_clientmgr.c                     |   12 +-
 sound/drivers/aloop.c                              |    7 -
 sound/pci/emu10k1/emupcm.c                         |    2 
 sound/usb/stream.c                                 |    2 
 112 files changed, 661 insertions(+), 305 deletions(-)

Alan Stern (1):
      USB: core: Prevent nested device-reset calls

Anand Jain (1):
      btrfs: harden identification of a stale device

Andrew Halaney (1):
      regulator: core: Clean up on enable failure

Andy Shevchenko (1):
      platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Armin Wolf (1):
      hwmon: (gpio-fan) Fix array out of bounds access

Bart Van Assche (1):
      nvmet: fix a use-after-free

Candice Li (1):
      drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

Carlos Llamas (1):
      binder: fix UAF of ref->proc caused by race condition

Chen-Yu Tsai (2):
      clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops
      clk: core: Fix runtime PM sequence in clk_core_unprepare()

Chengchang Tang (1):
      RDMA/hns: Fix supported page size

Chris Mi (1):
      RDMA/mlx5: Set local port to one when accessing counters

Christian A. Ehrhardt (1):
      kprobes: Prohibit probes in gate area

Colin Ian King (1):
      drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"

Cong Wang (1):
      kcm: fix strp_init() order and cleanup

Dan Carpenter (3):
      wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
      staging: rtl8712: fix use after free bugs
      tipc: fix shift wrapping bug in map_get()

David Howells (3):
      smb3: missing inode locks in punch hole
      rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
      afs: Use the operation issue time instead of the reply time for callbacks

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

David Lebrun (1):
      ipv6: sr: fix out-of-bounds read when setting HMAC data.

Diego Santa Cruz (1):
      drm/i915/glk: ECS Liva Q2 needs GLK HDMI port timing quirk

Dongxiang Ke (1):
      ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Douglas Anderson (1):
      drm/msm/dsi: Fix number of regulators for msm8996_dsi_cfg

Duoming Zhou (1):
      ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Enguerrand de Ribaucourt (1):
      net: dp83822: disable false carrier interrupt

Eric Dumazet (1):
      tcp: annotate data-race around challenge_timestamp

Gerald Schaefer (1):
      s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages

Greg Kroah-Hartman (3):
      net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()
      debugfs: add debugfs_lookup_and_remove()
      Linux 5.4.213

Guixin Liu (1):
      scsi: megaraid_sas: Fix double kfree()

Haibo Chen (1):
      gpio: pca953x: Add mutex_lock for regcache sync in PM

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Heiner Kallweit (1):
      usb: dwc2: fix wrong order of phy_power_on and phy_init

Helge Deller (2):
      vt: Clear selection before changing the font
      parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Hyunwoo Kim (1):
      efi: capsule-loader: Fix use-after-free in efi_capsule_write

Isaac J. Manjarres (1):
      driver core: Don't probe devices after bus_type.match() probe deferral

Ivan Vecera (1):
      i40e: Fix kernel crash during module removal

Jakub Kicinski (1):
      Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"

Jeffy Chen (1):
      drm/gem: Fix GEM handle release errors

Johan Hovold (8):
      misc: fastrpc: fix memory corruption on probe
      misc: fastrpc: fix memory corruption on open
      usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
      USB: serial: cp210x: add Decagon UCA device id
      usb: dwc3: fix PHY disable sequence
      usb: dwc3: disable USB core PHY management
      USB: serial: ch341: fix lost character on LCR updates
      USB: serial: ch341: fix disabled rx timer on older devices

Josh Poimboeuf (1):
      s390: fix nospec table alignments

Krishna Kurapati (1):
      usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS

Li Qiong (1):
      parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Liang He (1):
      soc: brcmstb: pm-arm: Fix refcount leak and __iomem leak bugs

Lin Ma (1):
      ieee802154/adf7242: defer destroy_workqueue call

Linus Torvalds (1):
      fs: only do a memory barrier for the first set_buffer_uptodate()

Linus Walleij (1):
      RDMA/siw: Pass a pointer to virt_to_page()

Marco Felsch (1):
      ARM: dts: imx6qdl-kontron-samx6i: remove duplicated node

Marcus Folkesson (2):
      iio: adc: mcp3911: make use of the sign bit
      iio: adc: mcp3911: use correct formula for AD conversion

Masahiro Yamada (1):
      powerpc: align syscall table for ppc32

Mathias Nyman (2):
      Revert "xhci: turn off port power in shutdown"
      xhci: Add grace period after xHC start to prevent premature runtime suspend.

Michael Guralnik (1):
      RDMA/cma: Fix arguments order in net device validation

Michal Koutný (1):
      cgroup: Optimize single thread migration

Mika Westerberg (1):
      thunderbolt: Use the actual buffer in tb_async_error()

Miquel Raynal (1):
      net: mac802154: Fix a condition in the receive path

Neal Cardwell (1):
      tcp: fix early ETIMEDOUT after spurious non-SACK RTO

Nicolas Dichtel (1):
      ip: fix triggering of 'icmp redirect'

Niek Nooijens (1):
      USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Pablo Sun (1):
      usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles

Pattara Teerapong (1):
      ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Peter Robinson (1):
      Input: rk805-pwrkey - fix module autoloading

Peter Zijlstra (1):
      x86/nospec: Fix i386 RSB stuffing

Qu Huang (1):
      drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly

Sagi Grimberg (1):
      nvme-tcp: fix UAF when detecting digest errors

Shenwei Wang (1):
      serial: fsl_lpuart: RS485 RTS polariy is inverse

Sherry Sun (1):
      tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete

Siddh Raman Pant (1):
      wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix use-after-free warning

Stanislaw Gruszka (1):
      wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Stefan Wahren (1):
      clk: bcm: rpi: Fix error handling of raspberrypi_fw_get_rate

Stephen Boyd (1):
      Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops"

Sudeep Holla (1):
      arm64: cacheinfo: Fix incorrect assignment of signed error value to unsigned fw_level

Takashi Iwai (2):
      ALSA: seq: oss: Fix data-race for max_midi_devs access
      ALSA: seq: Fix data-race at module auto-loading

Tasos Sahanidis (1):
      ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Tejun Heo (2):
      cgroup: Elide write-locking threadgroup_rwsem when updating csses on an empty subtree
      cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tetsuo Handa (1):
      Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING flag

Thierry GUIBERT (1):
      USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)

Toke Høiland-Jørgensen (3):
      sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
      sch_sfb: Don't assume the skb is still around after enqueueing to child
      sch_sfb: Also store skb len before calling child enqueue

Witold Lipieta (1):
      usb-storage: Add ignore-residue quirk for NXP PN7462AU

Yacan Liu (1):
      net/smc: Remove redundant refcount increase

Yan Xinyu (1):
      USB: serial: option: add support for OPPO R11 diag port

Yang Ling (1):
      MIPS: loongson32: ls1c: Fix hang during startup

Yang Yingliang (2):
      fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()
      scsi: lpfc: Add missing destroy_workqueue() in error path

Yee Lee (1):
      Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

Yonglin Tan (1):
      USB: serial: option: add Quectel EM060K modem

Zhengchao Shao (1):
      net: sched: tbf: don't call qdisc_put() while holding tree lock

Zhenneng Li (1):
      drm/radeon: add a force flush to delay work when radeon

sunliming (1):
      drm/msm/dsi: fix the inconsistent indenting

