Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645846E10DE
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 17:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbjDMPTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 11:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjDMPTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 11:19:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257D5AF02;
        Thu, 13 Apr 2023 08:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4CC8614A0;
        Thu, 13 Apr 2023 15:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B681DC433EF;
        Thu, 13 Apr 2023 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681399175;
        bh=lAmbGw9CU+jAcSkc+fF1UbuyHZ15xbMWxLifEDekIdY=;
        h=From:To:Cc:Subject:Date:From;
        b=tzYNxXSasJuQ3A73GGryBQp1FN0PG2gmMnxOxXbKjrrXbUkVcSWdJlBBs1GVjKnHq
         VSzi683VWtz3i1ann2QjQjTeD/9xtJ898Z6op4/PBE4NAnTil1R7lS2eXkWs7ycsyq
         H2Zn0Q15C5Fj8EnAmZ1EwMeKKOROdQjbQalA/NrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.107
Date:   Thu, 13 Apr 2023 17:19:31 +0200
Message-Id: <2023041331-roster-frozen-03e4@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.107 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/serial/renesas,scif.yaml               |    4 
 Makefile                                                                 |   18 
 arch/s390/kvm/intercept.c                                                |   32 
 drivers/gpio/Kconfig                                                     |    2 
 drivers/gpio/gpio-davinci.c                                              |    2 
 drivers/gpu/drm/bridge/lontium-lt9611.c                                  |    1 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                                  |   32 
 drivers/gpu/drm/nouveau/nouveau_dp.c                                     |    8 
 drivers/gpu/drm/panfrost/panfrost_mmu.c                                  |    1 
 drivers/hv/connection.c                                                  |    4 
 drivers/hwtracing/coresight/coresight-etm4x-core.c                       |   24 
 drivers/hwtracing/coresight/coresight-etm4x.h                            |   20 
 drivers/iio/adc/ad7791.c                                                 |    2 
 drivers/iio/adc/ti-ads7950.c                                             |    1 
 drivers/iio/dac/cio-dac.c                                                |    4 
 drivers/iio/imu/Kconfig                                                  |    1 
 drivers/iio/light/cm32181.c                                              |   12 
 drivers/infiniband/hw/irdma/verbs.c                                      |   15 
 drivers/net/dsa/mv88e6xxx/chip.c                                         |    2 
 drivers/net/dsa/mv88e6xxx/global2.c                                      |   20 
 drivers/net/dsa/mv88e6xxx/global2.h                                      |    1 
 drivers/net/ethernet/google/gve/gve.h                                    |    2 
 drivers/net/ethernet/google/gve/gve_tx.c                                 |   12 
 drivers/net/ethernet/intel/iavf/iavf_main.c                              |   22 
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c                       |   23 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                        |    6 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                                 |    6 
 drivers/platform/x86/intel/int3472/Makefile                              |    9 
 drivers/platform/x86/intel/int3472/clk_and_regulator.c                   |  210 +
 drivers/platform/x86/intel/int3472/common.c                              |   54 
 drivers/platform/x86/intel/int3472/common.h                              |  119 
 drivers/platform/x86/intel/int3472/discrete.c                            |  439 +++
 drivers/platform/x86/intel/int3472/intel_skl_int3472_clk_and_regulator.c |  207 -
 drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c            |  106 
 drivers/platform/x86/intel/int3472/intel_skl_int3472_common.h            |  122 
 drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete.c          |  413 ---
 drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470.c          |  137 -
 drivers/platform/x86/intel/int3472/tps68470.c                            |  156 +
 drivers/platform/x86/think-lmi.c                                         |   20 
 drivers/pwm/pwm-cros-ec.c                                                |    1 
 drivers/pwm/pwm-sprd.c                                                   |    1 
 drivers/scsi/iscsi_tcp.c                                                 |    3 
 drivers/scsi/qla2xxx/qla_os.c                                            |    1 
 drivers/tty/serial/8250/8250_exar.c                                      |   51 
 drivers/tty/serial/fsl_lpuart.c                                          |    8 
 drivers/tty/serial/sh-sci.c                                              |   10 
 drivers/usb/cdns3/cdnsp-ep0.c                                            |    3 
 drivers/usb/dwc3/dwc3-pci.c                                              |    4 
 drivers/usb/host/xhci-tegra.c                                            |    6 
 drivers/usb/host/xhci.c                                                  |    6 
 drivers/usb/serial/cp210x.c                                              |    1 
 drivers/usb/serial/option.c                                              |   10 
 drivers/usb/typec/altmodes/displayport.c                                 |    6 
 fs/cifs/cifsfs.c                                                         |    1 
 fs/cifs/connect.c                                                        |    2 
 fs/cifs/file.c                                                           |    4 
 fs/cifs/fs_context.c                                                     |   22 
 fs/cifs/fs_context.h                                                     |   11 
 fs/cifs/misc.c                                                           |    2 
 fs/ksmbd/connection.c                                                    |    5 
 fs/namespace.c                                                           |    2 
 fs/nfsd/nfs4callback.c                                                   |    4 
 fs/nfsd/nfs4proc.c                                                       |    7 
 fs/nfsd/nfs4xdr.c                                                        |    4 
 fs/nilfs2/segment.c                                                      |    3 
 fs/nilfs2/super.c                                                        |    2 
 fs/nilfs2/the_nilfs.c                                                    |   12 
 fs/ocfs2/dlmglue.c                                                       |    8 
 fs/ocfs2/journal.c                                                       |    2 
 fs/ocfs2/journal.h                                                       |    1 
 fs/ocfs2/super.c                                                         |  108 
 include/linux/ftrace.h                                                   |    2 
 kernel/bpf/hashtab.c                                                     |    4 
 kernel/events/core.c                                                     |    2 
 kernel/trace/ftrace.c                                                    |   15 
 kernel/trace/ring_buffer.c                                               |   13 
 kernel/trace/trace.c                                                     |    1 
 mm/memory.c                                                              |   16 
 mm/swapfile.c                                                            |    3 
 mm/vmalloc.c                                                             |    8 
 net/can/isotp.c                                                          |   17 
 net/can/j1939/transport.c                                                |    5 
 net/core/netpoll.c                                                       |   19 
 net/ethtool/linkmodes.c                                                  |    7 
 net/ipv4/icmp.c                                                          |    5 
 net/ipv6/ip6_output.c                                                    |    7 
 net/mac80211/sta_info.c                                                  |    3 
 net/qrtr/Makefile                                                        |    3 
 net/qrtr/af_qrtr.c                                                       | 1323 ++++++++++
 net/qrtr/ns.c                                                            |   15 
 net/qrtr/qrtr.c                                                          | 1321 ---------
 net/sctp/socket.c                                                        |    4 
 net/sunrpc/svcauth_unix.c                                                |   17 
 sound/pci/hda/patch_realtek.c                                            |    1 
 sound/soc/codecs/hdac_hdmi.c                                             |   17 
 tools/lib/bpf/btf_dump.c                                                 |    6 
 96 files changed, 2846 insertions(+), 2568 deletions(-)

Alistair Popple (1):
      mm: take a page reference when removing device exclusive entries

Andy Roulin (1):
      ethtool: reset #lanes when lanes is omitted

Andy Shevchenko (1):
      serial: 8250_exar: derive nr_ports from PCI ID for Acces I/O cards

Armin Wolf (1):
      platform/x86: think-lmi: Fix memory leak when showing current settings

Arnd Bergmann (1):
      iio: adis16480: select CONFIG_CRC32

Biju Das (2):
      tty: serial: sh-sci: Fix transmit end interrupt handler
      tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Bjørn Mork (1):
      USB: serial: option: add Quectel RM500U-CN modem

Boris Brezillon (1):
      drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Brian Foster (1):
      NFSD: pass range end to vfs_fsync_range() instead of count

Christian Brauner (1):
      fs: drop peer group ids under namespace lock

Chuck Lever (2):
      NFSD: Fix sparse warning
      NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL

Corinna Vinschen (1):
      net: stmmac: fix up RX flow hash indirection table when setting channels

D Scott Phillips (1):
      xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Dai Ngo (1):
      NFSD: callback request does not use correct credential for AUTH_SYS

Daniil Tatianin (1):
      iavf/iavf_main: actually log ->src mask when talking about it

Dhruva Gole (1):
      gpio: davinci: Add irq chip flag to skip set wake

Eduard Zingerman (1):
      bpftool: Print newline before '}' for struct with padding only fields

Enrico Sau (1):
      USB: serial: option: add Telit FE990 compositions

Eric Dumazet (1):
      icmp: guard against too small mtu

Felix Fietkau (1):
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Geert Uytterhoeven (1):
      dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs

Greg Kroah-Hartman (1):
      Linux 5.15.107

Gustav Ekelund (1):
      net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit

Hans de Goede (2):
      platform/x86: int3472: Split into 2 drivers
      platform/x86: int3472/discrete: Ensure the clk/power enable pins are in output mode

Heikki Krogerus (1):
      usb: dwc3: pci: add support for the Intel Meteor Lake-S

Heming Zhao (1):
      ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

Heming Zhao via Ocfs2-devel (2):
      ocfs2: ocfs2_mount_volume does cleanup job before return error
      ocfs2: rewrite error handling of ocfs2_fill_super

Jacob Keller (1):
      iavf: return errno code instead of status code

Jakub Kicinski (1):
      net: don't let netpoll invoke NAPI if in xmit context

Jason Montleon (1):
      ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()

Jeff Layton (1):
      sunrpc: only free unix grouplist after RCU settles

Jeremy Soller (1):
      ALSA: hda/realtek: Add quirk for Clevo X370SNW

John Keeping (1):
      ftrace: Mark get_lock_parent_ip() __always_inline

Kai-Heng Feng (1):
      iio: light: cm32181: Unregister second I2C client if present

Kan Liang (1):
      perf/core: Fix the same task check in perf_event_set_output

Karol Herbst (1):
      drm/nouveau/disp: Support more modes by checking with lower bpc

Kees Jan Koster (1):
      USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Lars-Peter Clausen (1):
      iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Li Zetao (2):
      ocfs2: fix memory leak in ocfs2_mount_volume()
      scsi: qla2xxx: Fix memory leak in qla2x00_probe_one()

Lingyu Liu (1):
      ice: Reset FDIR counter in FDIR init stage

Luca Weiss (1):
      net: qrtr: combine nameservice into main module

Marios Makassikis (1):
      ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN

Mark Pearson (2):
      platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings
      platform/x86: think-lmi: Clean up display of current_value on Thinkstation

Masahiro Yamada (2):
      kbuild: refactor single builds of *.ko
      kbuild: fix single directory build

Matthew Howell (1):
      serial: exar: Add support for Sealevel 7xxxC serial cards

Michal Sojka (1):
      can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Mohammed Gamal (1):
      Drivers: vmbus: Check for channel allocation before looking up relids

Mustafa Ismail (1):
      RDMA/irdma: Do not request 2-level PBLEs for CQ alloc

Nico Boehr (1):
      KVM: s390: pv: fix external interruption loop not always detected

Nuno Sá (1):
      iio: adc: ad7791: fix IRQ flags

Oleksij Rempel (1):
      can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Pawel Laszczak (1):
      usb: cdnsp: Fixes error: uninitialized symbol 'len'

RD Babiera (1):
      usb: typec: altmodes/displayport: Fix configure initial pin assignment

Randy Dunlap (1):
      gpio: GPIO_REGMAP: select REGMAP instead of depending on it

Robert Foss (1):
      drm/bridge: lt9611: Fix PLL being unable to lock

Rongwei Wang (1):
      mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Ryusuke Konishi (2):
      nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
      nilfs2: fix sysfs interface lifetime

Shailend Chand (1):
      gve: Secure enough bytes in the first TX desc for all TCP pkts

Sherry Sun (1):
      tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe

Simei Su (1):
      ice: fix wrong fallback logic for FDIR

Sricharan Ramabadhran (1):
      net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT

Steve Clevenger (1):
      coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Steve French (2):
      smb3: allow deferred close timeout to be configurable
      smb3: lower default deferred close timeout to address perf regression

Steven Rostedt (Google) (1):
      tracing: Free error logs of tracing instances

Suzuki K Poulose (1):
      coresight: etm4x: Do not access TRCIDR1 for identification

Thiago Rafael Becker (1):
      cifs: sanitize paths in cifs_update_super_prepath.

Tonghao Zhang (1):
      bpf: hash map, avoid deadlock with suitable hash mask

Uwe Kleine-König (2):
      pwm: cros-ec: Explicitly set .polarity in .get_state()
      pwm: sprd: Explicitly set .polarity in .get_state()

Wayne Chang (1):
      usb: xhci: tegra: fix sleep in atomic call

William Breathitt Gray (1):
      iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Xin Long (1):
      sctp: check send stream number after wait_for_sndbuf

Yafang Shao (1):
      mm: vmalloc: avoid warn_alloc noise caused by fatal signal

Zheng Yejian (2):
      ftrace: Fix issue that 'direct->addr' not restored in modify_ftrace_direct()
      ring-buffer: Fix race while reader and writer are on the same page

Zhong Jinghua (1):
      scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()

Ziyang Xuan (2):
      net: qrtr: Fix a refcount bug in qrtr_recvmsg()
      ipv6: Fix an uninit variable access bug in __ip6_make_skb()

