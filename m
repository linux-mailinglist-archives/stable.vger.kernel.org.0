Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5055EDA76
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiI1Kua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiI1KuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B4E26AE8;
        Wed, 28 Sep 2022 03:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66C03B82027;
        Wed, 28 Sep 2022 10:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0723C433D6;
        Wed, 28 Sep 2022 10:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362172;
        bh=s/qYw5WUg7JOc7s0AAGYSmWAUNTfj/oeV+wP5Yiyw30=;
        h=From:To:Cc:Subject:Date:From;
        b=U7J+E21biNeSGIERsRQJYu8O52R3nPgnUq1RK2gcQvkH5kZ1Nu129olCsEDWzM5ff
         2Lh4y5md25jkk3J3wzIK3NqMcRyVJvgUsl6xeN1s8Grdz7UZOMoRBvfscsSJnsmM2C
         fpMpGj+0DAo+W5bcdnuhV5Ik3y/sx1OgDa64KfjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.215
Date:   Wed, 28 Sep 2022 12:49:17 +0200
Message-Id: <1664362157198217@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.215 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                             |    3 
 Makefile                                                |    2 
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts         |    5 
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi |    9 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi           |    1 
 arch/mips/cavium-octeon/octeon-irq.c                    |   10 
 arch/mips/lantiq/clk.c                                  |    1 
 arch/mips/loongson32/common/platform.c                  |   16 -
 arch/x86/include/asm/cpu_entry_area.h                   |    2 
 drivers/firmware/efi/libstub/secureboot.c               |    8 
 drivers/gpio/gpio-mpc8xxx.c                             |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c             |    2 
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c |    4 
 drivers/gpu/drm/meson/meson_plane.c                     |    2 
 drivers/gpu/drm/meson/meson_viu.c                       |    2 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                  |    5 
 drivers/hv/vmbus_drv.c                                  |   10 
 drivers/net/can/usb/gs_usb.c                            |    4 
 drivers/net/ethernet/intel/i40e/i40e_main.c             |   32 ++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c      |   20 +
 drivers/net/ethernet/intel/iavf/iavf_txrx.c             |    9 
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c         |    7 
 drivers/net/ethernet/sun/sunhme.c                       |    4 
 drivers/net/ipvlan/ipvlan_core.c                        |    6 
 drivers/net/team/team.c                                 |   24 +-
 drivers/net/usb/qmi_wwan.c                              |    1 
 drivers/of/fdt.c                                        |    2 
 drivers/of/of_mdio.c                                    |    1 
 drivers/parisc/ccio-dma.c                               |    1 
 drivers/regulator/pfuze100-regulator.c                  |    2 
 drivers/s390/block/dasd_alias.c                         |    9 
 drivers/tty/serial/atmel_serial.c                       |   32 +--
 drivers/tty/serial/serial-tegra.c                       |    5 
 drivers/tty/serial/tegra-tcu.c                          |    2 
 drivers/usb/cdns3/gadget.c                              |    1 
 drivers/usb/core/hub.c                                  |    2 
 drivers/usb/dwc3/core.c                                 |    2 
 drivers/usb/dwc3/core.h                                 |    4 
 drivers/usb/dwc3/gadget.c                               |   81 ++++---
 drivers/usb/host/xhci-mtk-sch.c                         |  149 ++++++++------
 drivers/usb/host/xhci-mtk.h                             |    2 
 drivers/usb/serial/option.c                             |    6 
 drivers/video/fbdev/pxa3xx-gcu.c                        |    2 
 fs/afs/misc.c                                           |    1 
 fs/cifs/connect.c                                       |    7 
 fs/cifs/file.c                                          |    3 
 fs/cifs/transport.c                                     |    6 
 fs/ext4/extents.c                                       |    4 
 fs/ext4/ialloc.c                                        |    2 
 fs/nfs/super.c                                          |   27 +-
 fs/xfs/libxfs/xfs_alloc.c                               |   27 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                           |   12 -
 fs/xfs/libxfs/xfs_bmap.c                                |   16 +
 fs/xfs/libxfs/xfs_btree.c                               |    5 
 fs/xfs/libxfs/xfs_da_btree.c                            |   24 +-
 fs/xfs/libxfs/xfs_dir2.c                                |    4 
 fs/xfs/libxfs/xfs_dir2_leaf.c                           |    4 
 fs/xfs/libxfs/xfs_dir2_node.c                           |   12 -
 fs/xfs/libxfs/xfs_dir2_sf.c                             |   28 ++
 fs/xfs/libxfs/xfs_ialloc.c                              |   64 ++++++
 fs/xfs/libxfs/xfs_ialloc.h                              |    1 
 fs/xfs/libxfs/xfs_inode_fork.c                          |    6 
 fs/xfs/libxfs/xfs_refcount.c                            |    4 
 fs/xfs/libxfs/xfs_rtbitmap.c                            |    6 
 fs/xfs/xfs_acl.c                                        |   15 +
 fs/xfs/xfs_attr_inactive.c                              |   10 
 fs/xfs/xfs_attr_list.c                                  |    5 
 fs/xfs/xfs_bmap_item.c                                  |    7 
 fs/xfs/xfs_bmap_util.c                                  |   12 +
 fs/xfs/xfs_buf_item.c                                   |    2 
 fs/xfs/xfs_dquot.c                                      |    2 
 fs/xfs/xfs_error.c                                      |   27 ++
 fs/xfs/xfs_error.h                                      |    7 
 fs/xfs/xfs_extfree_item.c                               |    5 
 fs/xfs/xfs_fsmap.c                                      |    1 
 fs/xfs/xfs_inode.c                                      |   40 +++
 fs/xfs/xfs_inode_item.c                                 |    5 
 fs/xfs/xfs_iomap.c                                      |   17 +
 fs/xfs/xfs_iops.c                                       |   10 
 fs/xfs/xfs_log_recover.c                                |   72 ++++--
 fs/xfs/xfs_message.c                                    |    2 
 fs/xfs/xfs_message.h                                    |    2 
 fs/xfs/xfs_mount.c                                      |  168 +++++++++++-----
 fs/xfs/xfs_pnfs.c                                       |    4 
 fs/xfs/xfs_qm.c                                         |   13 +
 fs/xfs/xfs_refcount_item.c                              |    5 
 fs/xfs/xfs_rmap_item.c                                  |    9 
 fs/xfs/xfs_trace.h                                      |   21 ++
 include/linux/iomap.h                                   |    2 
 include/linux/sched/task_stack.h                        |    2 
 include/linux/serial_core.h                             |   17 +
 kernel/cgroup/cgroup-v1.c                               |    3 
 kernel/trace/trace_preemptirq.c                         |    4 
 kernel/workqueue.c                                      |    6 
 mm/slub.c                                               |    5 
 net/bridge/netfilter/ebtables.c                         |    4 
 net/mac80211/scan.c                                     |   11 -
 net/netfilter/nf_conntrack_irc.c                        |   34 ++-
 net/netfilter/nf_conntrack_sip.c                        |    4 
 net/netfilter/nfnetlink_osf.c                           |    4 
 net/rxrpc/call_event.c                                  |    2 
 net/rxrpc/local_object.c                                |    3 
 net/sched/cls_api.c                                     |    1 
 net/sched/sch_taprio.c                                  |   18 +
 scripts/mksysmap                                        |    2 
 sound/core/oss/pcm_oss.c                                |    5 
 sound/pci/hda/hda_intel.c                               |    2 
 sound/pci/hda/hda_tegra.c                               |    3 
 sound/pci/hda/patch_hdmi.c                              |    1 
 sound/pci/hda/patch_realtek.c                           |   31 ++
 sound/pci/hda/patch_sigmatel.c                          |   24 ++
 sound/soc/codecs/nau8824.c                              |   17 -
 tools/perf/util/genelf.c                                |   14 +
 tools/perf/util/genelf.h                                |    4 
 tools/perf/util/symbol-elf.c                            |    7 
 115 files changed, 1058 insertions(+), 389 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Do not check /proc/modules is unchanged

Alan Stern (1):
      USB: core: Fix RST error in hub.c

Alexander Sverdlin (1):
      MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

Ard Biesheuvel (1):
      efi: libstub: check Shim mode using MokSBStateRT

Benjamin Poirier (1):
      net: team: Unsync device addresses on ndo_stop

Borislav Petkov (1):
      task_stack, x86/cea: Force-inline stack helpers

Brett Creeley (1):
      iavf: Fix cached head and tail value for iavf_get_tx_pending

Brian Foster (2):
      xfs: stabilize insert range start boundary to avoid COW writeback race
      xfs: use bitops interface for buf log item AIL flag check

Brian Norris (1):
      arm64: dts: rockchip: Pull up wlan wake# on Gru-Bob

Callum Osmotherly (1):
      ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop

Carl Yin(殷张成) (1):
      USB: serial: option: add Quectel BG95 0x0203 composition

Chandan Babu R (2):
      MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
      iomap: iomap that extends beyond EOF should be marked dirty

Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

Christoph Hellwig (1):
      xfs: slightly tweak an assert in xfs_fs_map_blocks

Chunfeng Yun (7):
      usb: xhci-mtk: get the microframe boundary for ESIT
      usb: xhci-mtk: add only one extra CS for FS/LS INTR
      usb: xhci-mtk: use @sch_tt to check whether need do TT schedule
      usb: xhci-mtk: add a function to (un)load bandwidth info
      usb: xhci-mtk: add some schedule error number
      usb: xhci-mtk: allow multiple Start-Split in a microframe
      usb: xhci-mtk: fix issue of out-of-bounds array access

Codrin.Ciubotariu@microchip.com (1):
      tty/serial: atmel: RS485 & ISO7816: wait for TXRDY before sending data

Darrick J. Wong (13):
      xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
      xfs: add missing assert in xfs_fsmap_owner_from_rmap
      xfs: range check ri_cnt when recovering log items
      xfs: attach dquots and reserve quota blocks during unwritten conversion
      xfs: convert EIO to EFSCORRUPTED when log contents are invalid
      xfs: constify the buffer pointer arguments to error functions
      xfs: always log corruption errors
      xfs: fix some memory leaks in log recovery
      xfs: refactor agfl length computation function
      xfs: split the sunit parameter update into two parts
      xfs: don't commit sunit/swidth updates to disk if that would cause repair failures
      xfs: fix an ABBA deadlock in xfs_rename
      xfs: fix use-after-free when aborting corrupt attr inactivation

David Howells (3):
      rxrpc: Fix local destruction being repeated
      rxrpc: Fix calc of resend age
      afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

Fabio Estevam (1):
      arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Florian Westphal (1):
      netfilter: ebtables: fix memory leak when blob is malformed

Greg Kroah-Hartman (3):
      Revert "usb: add quirks for Lenovo OneLink+ Dock"
      Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"
      Linux 5.4.215

Hamza Mahfooz (1):
      drm/amdgpu: use dirty framebuffer helper

Hangyu Hua (1):
      net: sched: fix possible refcount leak in tc_new_tfilter()

Hyunwoo Kim (1):
      video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Igor Ryzhov (1):
      netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Ikjoon Jang (1):
      usb: xhci-mtk: relax TT periodic bandwidth allocation

Ilpo Järvinen (3):
      serial: Create uart_xmit_advance()
      serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting
      serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting

Jan Kara (1):
      ext4: make directory inode spreading reflect flexbg size

Jean-Francois Le Fillatre (1):
      usb: add quirks for Lenovo OneLink+ Dock

Kai Vehmanen (1):
      ALSA: hda: add Intel 5 Series / 3400 PCI DID

Liang He (1):
      of: mdio: Add of_node_put() when breaking out of for_each_xx

Lieven Hey (1):
      perf jit: Include program header in ELF files

Lino Sanfilippo (1):
      serial: atmel: remove redundant assignment in rs485_config

Lu Wei (1):
      ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Luke D. Jones (3):
      ALSA: hda/realtek: Add pincfg for ASUS G513 HP jack
      ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack
      ALSA: hda/realtek: Add quirk for ASUS GA503R laptop

Luís Henriques (1):
      ext4: fix bug in extents parsing when eh_entries == 0 and eh_depth > 0

Marc Kleine-Budde (1):
      can: gs_usb: gs_can_open(): fix race dev->can.state condition

Michal Jaron (3):
      iavf: Fix set max MTU size with port VLAN and jumbo frames
      i40e: Fix VF set max MTU size
      i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Mohan Kumar (2):
      ALSA: hda/tegra: Align BDL entry to 4KB boundary
      ALSA: hda/tegra: set depop delay for tegra

Nathan Huckleberry (1):
      drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Norbert Zulinski (1):
      iavf: Fix bad page state

Pablo Neira Ayuso (1):
      netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

Pali Rohár (1):
      gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Pawel Laszczak (1):
      usb: cdns3: fix issue with rearming ISO OUT endpoint

Piyush Mehta (1):
      usb: gadget: udc-xilinx: replace memcpy with memcpy_toio

Randy Dunlap (1):
      MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Ronnie Sahlberg (1):
      cifs: revalidate mapping when doing direct writes

Sasha Levin (1):
      ALSA: pcm: oss: Fix race at SNDCTL_DSP_SYNC

Sean Anderson (1):
      net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Serge Semin (1):
      MIPS: Loongson32: Fix PHY-mode being left unspecified

Sergey Shtylyov (1):
      of: fdt: fix off-by-one error in unflatten_dt_nodes()

Sergiu Moga (1):
      tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Siddh Raman Pant (1):
      wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Stefan Haberland (1):
      s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Stefan Metzmacher (2):
      cifs: don't send down the destination address to sendmsg for a SOCK_STREAM
      cifs: always initialize struct msghdr smb_msg completely

Stuart Menefy (2):
      drm/meson: Correct OSD1 global alpha value
      drm/meson: Fix OSD1 RGB to YCbCr coefficient

Takashi Iwai (4):
      ASoC: nau8824: Fix semaphore unbalance at error paths
      ALSA: hda/sigmatel: Keep power up while beep is enabled
      ALSA: hda/sigmatel: Fix unused variable warning for beep power change
      ALSA: hda/realtek: Re-arrange quirk table entries

Tetsuo Handa (2):
      cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()
      workqueue: don't skip lockdep work dependency in cancel_work_sync()

Thinh Nguyen (3):
      usb: dwc3: gadget: Prevent repeat pullup()
      usb: dwc3: gadget: Refactor pullup()
      usb: dwc3: gadget: Don't modify GEVNTCOUNT in pullup()

Trond Myklebust (1):
      NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0

Vitaly Kuznetsov (1):
      Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Vladimir Oltean (2):
      net/sched: taprio: avoid disabling offload when it was never enabled
      net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Wesley Cheng (3):
      usb: dwc3: gadget: Avoid starting DWC3 gadget during UDC unbind
      usb: dwc3: Issue core soft reset before enabling run/stop
      usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop

Xiaolei Wang (1):
      regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Yang Yingliang (1):
      parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Yao Wang1 (1):
      drm/amd/display: Limit user regamma to a valid value

Yipeng Zou (1):
      tracing: hold caller_addr to hardirq_{enable,disable}_ip

Youling Tang (1):
      mksysmap: Fix the mismatch of 'L0' symbols in System.map

huangwenhui (1):
      ALSA: hda/realtek: Add quirk for Huawei WRT-WX9

jerry meng (1):
      USB: serial: option: add Quectel RM520N

jerry.meng (1):
      net: usb: qmi_wwan: add Quectel RM520N

kaixuxia (1):
      xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()

zain wang (1):
      arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz

