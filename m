Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF680638E7F
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 17:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiKYQrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 11:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiKYQrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 11:47:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66CE2BB38;
        Fri, 25 Nov 2022 08:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6406C623A0;
        Fri, 25 Nov 2022 16:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19551C433D7;
        Fri, 25 Nov 2022 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669394808;
        bh=4C2LMbba2m28WdKjq5gsE/0Wy8duG73U1swF6MGnx/s=;
        h=From:To:Cc:Subject:Date:From;
        b=sBTlW7C6r1SrdzgKbUxdOHu7UipHuUsl9Q7zqrxJVqVhEQ7zDt6nFvAGISGBmZIsE
         xeWyAo+AaZRReI9lW3MRDmnOzTZnmXpgtOZWa91lg4NhOzDGPW1tO8Z6rgqD3v0VxJ
         8i2nZbH8ATHNS9u0dfPT58JwmwlHLHaBAhH34C2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.267
Date:   Fri, 25 Nov 2022 17:46:32 +0100
Message-Id: <1669394793178241@kroah.com>
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

I'm announcing the release of the 4.19.267 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/process/code-of-conduct-interpretation.rst |    2 
 Makefile                                                 |    2 
 arch/arm64/kernel/efi.c                                  |   52 ++++++++----
 arch/riscv/kernel/process.c                              |    2 
 arch/x86/include/asm/msr-index.h                         |    8 +
 arch/x86/kernel/cpu/amd.c                                |   10 --
 arch/x86/kvm/svm.c                                       |   10 +-
 arch/x86/kvm/x86.c                                       |    2 
 arch/x86/power/cpu.c                                     |    1 
 block/sed-opal.c                                         |   32 ++++++-
 drivers/ata/libata-transport.c                           |    1 
 drivers/block/drbd/drbd_main.c                           |    4 
 drivers/dma/at_hdmac.c                                   |   34 +++-----
 drivers/dma/at_hdmac_regs.h                              |   10 +-
 drivers/dma/mv_xor_v2.c                                  |    1 
 drivers/gpu/drm/i915/i915_gem_dmabuf.c                   |    4 
 drivers/gpu/drm/imx/imx-tve.c                            |    5 -
 drivers/gpu/drm/vc4/vc4_drv.c                            |    7 +
 drivers/hid/hid-hyperv.c                                 |    2 
 drivers/iio/adc/at91_adc.c                               |    4 
 drivers/iio/pressure/ms5611_spi.c                        |    2 
 drivers/iio/trigger/iio-trig-sysfs.c                     |    6 +
 drivers/input/serio/i8042.c                              |    4 
 drivers/isdn/mISDN/core.c                                |    2 
 drivers/isdn/mISDN/dsp_pipeline.c                        |    3 
 drivers/md/dm-ioctl.c                                    |    4 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                  |    2 
 drivers/mmc/core/core.c                                  |    8 +
 drivers/mmc/host/sdhci-pci-core.c                        |    2 
 drivers/mtd/spi-nor/intel-spi.c                          |    2 
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c         |    4 
 drivers/net/ethernet/broadcom/bgmac.c                    |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                |   12 ++
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c          |    1 
 drivers/net/ethernet/freescale/fman/mac.c                |    9 ++
 drivers/net/ethernet/marvell/mv643xx_eth.c               |    1 
 drivers/net/ethernet/neterion/s2io.c                     |   29 ++++---
 drivers/net/ethernet/ni/nixge.c                          |    1 
 drivers/net/hamradio/bpqether.c                          |    2 
 drivers/net/macvlan.c                                    |    6 -
 drivers/net/thunderbolt.c                                |   19 +++-
 drivers/net/tun.c                                        |   18 +++-
 drivers/net/wan/lapbether.c                              |    2 
 drivers/parport/parport_pc.c                             |    2 
 drivers/phy/st/phy-stm32-usbphyc.c                       |    2 
 drivers/pinctrl/devicetree.c                             |    2 
 drivers/platform/x86/hp-wmi.c                            |   12 ++
 drivers/siox/siox-core.c                                 |    2 
 drivers/slimbus/stream.c                                 |    8 -
 drivers/staging/speakup/main.c                           |    2 
 drivers/target/loopback/tcm_loop.c                       |    3 
 drivers/tty/n_gsm.c                                      |    2 
 drivers/tty/serial/8250/8250_lpss.c                      |   15 ++-
 drivers/tty/serial/8250/8250_omap.c                      |   18 ----
 drivers/tty/serial/8250/8250_port.c                      |    7 +
 drivers/tty/serial/imx.c                                 |    1 
 drivers/usb/chipidea/otg_fsm.c                           |    2 
 drivers/usb/core/quirks.c                                |    3 
 drivers/usb/serial/option.c                              |   19 ++++
 drivers/xen/pcpu.c                                       |    2 
 fs/btrfs/tests/btrfs-tests.c                             |    2 
 fs/btrfs/tests/qgroup-tests.c                            |   16 ---
 fs/buffer.c                                              |    4 
 fs/cifs/ioctl.c                                          |    4 
 fs/gfs2/ops_fstype.c                                     |   11 +-
 fs/namei.c                                               |    2 
 fs/nfs/nfs4proc.c                                        |    6 -
 fs/nilfs2/segment.c                                      |   15 +--
 fs/nilfs2/super.c                                        |    2 
 fs/nilfs2/the_nilfs.c                                    |    2 
 fs/ntfs/attrib.c                                         |   28 +++++-
 fs/ntfs/inode.c                                          |    7 +
 fs/udf/namei.c                                           |    2 
 include/asm-generic/vmlinux.lds.h                        |    2 
 include/uapi/linux/capability.h                          |    2 
 kernel/trace/ftrace.c                                    |    5 -
 kernel/trace/ring_buffer.c                               |    4 
 mm/filemap.c                                             |    2 
 net/9p/trans_fd.c                                        |    6 +
 net/bluetooth/l2cap_core.c                               |    2 
 net/bpf/test_run.c                                       |    1 
 net/caif/chnl_net.c                                      |    3 
 net/core/skbuff.c                                        |   36 ++++----
 net/ipv4/tcp_cdg.c                                       |    2 
 net/ipv6/addrlabel.c                                     |    1 
 net/kcm/kcmsock.c                                        |   62 ++-------------
 net/tipc/netlink_compat.c                                |    2 
 net/wireless/reg.c                                       |   12 ++
 net/x25/x25_dev.c                                        |    2 
 scripts/extract-cert.c                                   |    7 +
 scripts/sign-file.c                                      |    7 +
 sound/hda/hdac_sysfs.c                                   |    4 
 sound/pci/hda/patch_ca0132.c                             |    1 
 sound/soc/codecs/wm5102.c                                |    6 -
 sound/soc/codecs/wm5110.c                                |    6 -
 sound/soc/codecs/wm8997.c                                |    6 -
 sound/soc/soc-core.c                                     |   17 +++-
 sound/soc/soc-utils.c                                    |    2 
 sound/usb/midi.c                                         |    4 
 sound/usb/quirks-table.h                                 |    4 
 sound/usb/quirks.c                                       |    1 
 tools/testing/selftests/futex/functional/Makefile        |    6 -
 tools/testing/selftests/intel_pstate/Makefile            |    6 -
 tools/testing/selftests/kvm/include/x86.h                |    8 +
 104 files changed, 465 insertions(+), 300 deletions(-)

Alex Barba (1):
      bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer

Alexander Potapenko (3):
      ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network
      misc/vmw_vmci: fix an infoleak in vmci_host_do_receive_datagram()
      mm: fs: initialize fsdata passed to write_begin/write_end interface

Andreas Gruenbacher (1):
      gfs2: Switch from strlcpy to strscpy

Andrew Price (1):
      gfs2: Check sb_bsize_shift after reading superblock

Ard Biesheuvel (1):
      arm64: efi: Fix handling of misaligned runtime regions and drop warning

Arend van Spriel (1):
      wifi: cfg80211: fix memory leak in query_regdb_file()

Baisong Zhong (1):
      bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

Benjamin Coddington (1):
      NFSv4: Retry LOCK on OLD_STATEID during delegation return

Benoît Monin (1):
      USB: serial: option: add Sierra Wireless EM9191

Borislav Petkov (1):
      x86/cpu: Restore AMD's DE_CFG MSR after resume

Chen Jun (1):
      Input: i8042 - fix leaking of platform device on module removal

Chen Zhongjin (2):
      ASoC: core: Fix use-after-free in snd_soc_exit()
      ASoC: soc-utils: Remove __exit for snd_soc_util_exit()

Christophe JAILLET (1):
      dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()

Chuang Wang (1):
      net: macvlan: fix memory leaks of macvlan_common_newlink

Cong Wang (1):
      kcm: close race conditions on sk_receive_queue

Dan Carpenter (2):
      phy: stm32: fix an error code in probe
      drbd: use after free in drbd_create_device()

Daniil Tatianin (1):
      ring_buffer: Do not deactivate non-existant pages

Davide Tronchin (3):
      USB: serial: option: remove old LARA-R6 PID
      USB: serial: option: add u-blox LARA-R6 00B modem
      USB: serial: option: add u-blox LARA-L6 modem

Dominique Martinet (1):
      9p: trans_fd/p9_conn_cancel: drop client lock earlier

Duoming Zhou (2):
      tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send
      usb: chipidea: fix deadlock in ci_otg_del_timer

Eric Dumazet (4):
      net: tun: call napi_schedule_prep() to ensure we own a napi
      macvlan: enforce a consistent minimal mtu
      tcp: cdg: allow tcp_cdg_release() to be called multiple times
      kcm: avoid potential race in kcm_tx_work

Filipe Manana (1):
      btrfs: remove pointless and double ulist frees in error paths of qgroup tests

Gaosheng Cui (2):
      capabilities: fix undefined behavior in bit shift for CAP_TO_MASK
      bnxt_en: Remove debugfs when pci_register_driver failed

Greg Kroah-Hartman (1):
      Linux 4.19.267

Hawkins Jiawei (3):
      ntfs: fix use-after-free in ntfs_attr_find()
      ntfs: fix out-of-bounds read in ntfs_attr_find()
      ntfs: check overflow when iterating ATTR_RECORDs

Ilpo Järvinen (3):
      serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs
      serial: 8250_lpss: Configure DMA also w/o DMA filter
      serial: 8250: Flush DMA Rx on RLSI

Jiri Benc (1):
      net: gso: fix panic on frag_list with mixed head alloc types

Jisheng Zhang (1):
      riscv: process: fix kernel info leakage

Jorge Lopez (1):
      platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi

Jussi Laako (1):
      ALSA: usb-audio: Add DSD support for Accuphase DAC-60

Krzysztof Kozlowski (1):
      slimbus: stream: correct presence rate frequencies

Linus Torvalds (1):
      cert host tools: Stop complaining about deprecated OpenSSL functions

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm

Maciej W. Rozycki (1):
      parport_pc: Avoid FIFO port location truncation

Matthew Auld (1):
      drm/i915/dmabuf: fix sg_table handling in map_dma_buf

Matthias Schiffer (1):
      serial: 8250_omap: remove wait loop from Errata i202 workaround

Mauro Lima (1):
      spi: intel: Fix the offset to get the 64K erase opcode

Mikulas Patocka (1):
      dm ioctl: fix misbehavior if list_versions races with module loading

Mitja Spes (1):
      iio: pressure: ms5611: changed hardcoded SPI speed to value limited

Mushahid Hussain (1):
      speakup: fix a segfault caused by switching consoles

Nathan Chancellor (1):
      vmlinux.lds.h: Fix placement of '.data..decrypted' section

Nathan Huckleberry (1):
      drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

Nicolas Dumazet (1):
      usb: add NO_LPM quirk for Realforce 87U Keyboard

Reinhard Speyerer (1):
      USB: serial: option: add Fibocom FM160 0x0111 composition

Ricardo Cañuelo (2):
      selftests/futex: fix build for clang
      selftests/intel_pstate: fix build for ARCH=x86_64

Ryusuke Konishi (2):
      nilfs2: fix deadlock in nilfs_count_free_blocks()
      nilfs2: fix use-after-free bug of ns_writer on remount

Sean Anderson (1):
      net: fman: Unregister ethernet device on removal

Serge Semin (1):
      block: sed-opal: kmalloc the cmd/resp buffers

Shawn Guo (1):
      serial: imx: Add missing .thaw_noirq hook

Shuah Khan (1):
      docs: update mediator contact information in CoC doc

Takashi Iwai (2):
      ALSA: usb-audio: Add quirk entry for M-Audio Micro
      ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()

Tetsuo Handa (1):
      9p/trans_fd: always use O_NONBLOCK read/write

Tony Lindgren (1):
      serial: 8250: omap: Flush PM QOS work on remove

Tudor Ambarus (6):
      dmaengine: at_hdmac: Fix at_lli struct definition
      dmaengine: at_hdmac: Don't start transactions at tx_submit level
      dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors
      dmaengine: at_hdmac: Don't allow CPU to reorder channel enable
      dmaengine: at_hdmac: Fix impossible condition
      dmaengine: at_hdmac: Check return code of dma_async_device_register

Wang ShaoBo (1):
      mISDN: fix misuse of put_device() in mISDN_register_device()

Wang Wensheng (2):
      ftrace: Fix the possible incorrect kernel message
      ftrace: Optimize the allocation for mcount entries

Wang Yufen (1):
      net: tun: Fix memory leaks of napi_get_frags

Wei Yongjun (2):
      net: bgmac: Drop free_netdev() from bgmac_enet_remove()
      net/x25: Fix skb leak in x25_lapb_receive_frame()

Xian Wang (1):
      ALSA: hda/ca0132: add quirk for EVGA Z390 DARK

Xin Long (1):
      tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header

Xiongfeng Wang (1):
      mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()

Xiu Jianfeng (1):
      ftrace: Fix null pointer dereference in ftrace_add_mod()

Yang Yingliang (8):
      HID: hyperv: fix possible memory leak in mousevsc_probe()
      siox: fix possible memory leak in siox_device_add()
      ata: libata-transport: fix double ata_host_put() in ata_tport_add()
      mISDN: fix possible memory leak in mISDN_dsp_element_register()
      xen/pcpu: fix possible memory leak in register_pcpu()
      iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()
      iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()
      scsi: target: tcm_loop: Fix possible name leak in tcm_loop_setup_hba_bus()

Yann Gautier (1):
      mmc: core: properly select voltage range without power cycle

Ye Bin (1):
      ALSA: hda: fix potential memleak in 'add_widget_node'

Yuan Can (2):
      drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()
      net: thunderbolt: Fix error handling in tbnet_init()

Zeng Heng (1):
      pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map

Zhang Qilong (3):
      ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"
      ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"
      ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"

Zhang Xiaoxu (2):
      btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()
      cifs: Fix wrong return value checking when GETFLAGS

ZhangPeng (1):
      udf: Fix a slab-out-of-bounds write bug in udf_find_entry()

Zhengchao Shao (8):
      net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
      hamradio: fix issue of dev reference count leakage in bpq_device_event()
      drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
      net: nixge: disable napi when enable interrupts failed in nixge_open()
      net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
      ethernet: s2io: disable napi when start nic failed in s2io_card_up()
      net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
      net: caif: fix double disconnect client in chnl_net_open()

