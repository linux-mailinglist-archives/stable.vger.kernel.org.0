Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C66353C3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiKWI67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbiKWI6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:58:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7BC1001E8;
        Wed, 23 Nov 2022 00:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87AF0B81EF2;
        Wed, 23 Nov 2022 08:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286FEC433B5;
        Wed, 23 Nov 2022 08:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193928;
        bh=XyjZEcT0zKRkZqb6PQefAMby1jlTbnS+Xg8kd03yGCY=;
        h=From:To:Cc:Subject:Date:From;
        b=PPu9VLcVUdBbjiij/qnXT7uZTMDjfUlu28NsQ4Pm+t8pjW3W5UmUQ6XhOopsjHqsp
         iyVuT+587qo8Qgvhx5MFoCC1Hq9cfE/V/Xdpbg+kdgCpcNCifjftQHFNQw+5WqBphd
         O8R0dDBZEVH9YuUehMAnBtpeh4S1rQaNaN0Ud/Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 00/88] 4.14.300-rc1 review
Date:   Wed, 23 Nov 2022 09:49:57 +0100
Message-Id: <20221123084548.535439312@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.300-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.300-rc1
X-KernelTest-Deadline: 2022-11-25T08:45+00:00
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

This is the start of the stable review cycle for the 4.14.300 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.300-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.300-rc1

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: check overflow when iterating ATTR_RECORDs

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: fix out-of-bounds read in ntfs_attr_find()

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: fix use-after-free in ntfs_attr_find()

Alexander Potapenko <glider@google.com>
    mm: fs: initialize fsdata passed to write_begin/write_end interface

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    9p/trans_fd: always use O_NONBLOCK read/write

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Switch from strlcpy to strscpy

Andrew Price <anprice@redhat.com>
    gfs2: Check sb_bsize_shift after reading superblock

Dominique Martinet <asmadeus@codewreck.org>
    9p: trans_fd/p9_conn_cancel: drop client lock earlier

Cong Wang <cong.wang@bytedance.com>
    kcm: close race conditions on sk_receive_queue

Baisong Zhong <zhongbaisong@huawei.com>
    bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

Eric Dumazet <edumazet@google.com>
    kcm: avoid potential race in kcm_tx_work

Eric Dumazet <edumazet@google.com>
    tcp: cdg: allow tcp_cdg_release() to be called multiple times

Eric Dumazet <edumazet@google.com>
    macvlan: enforce a consistent minimal mtu

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Flush DMA Rx on RLSI

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free bug of ns_writer on remount

Alexander Potapenko <glider@google.com>
    misc/vmw_vmci: fix an infoleak in vmci_host_do_receive_datagram()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()

Yann Gautier <yann.gautier@foss.st.com>
    mmc: core: properly select voltage range without power cycle

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_lpss: Configure DMA also w/o DMA filter

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: fix misbehavior if list_versions races with module loading

Mitja Spes <mitja@lxnav.com>
    iio: pressure: ms5611: changed hardcoded SPI speed to value limited

Yang Yingliang <yangyingliang@huawei.com>
    iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()

Yang Yingliang <yangyingliang@huawei.com>
    iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()

Duoming Zhou <duoming@zju.edu.cn>
    usb: chipidea: fix deadlock in ci_otg_del_timer

Nicolas Dumazet <ndumazet@google.com>
    usb: add NO_LPM quirk for Realforce 87U Keyboard

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Fibocom FM160 0x0111 composition

Davide Tronchin <davide.tronchin.94@gmail.com>
    USB: serial: option: add u-blox LARA-L6 modem

Davide Tronchin <davide.tronchin.94@gmail.com>
    USB: serial: option: add u-blox LARA-R6 00B modem

Davide Tronchin <davide.tronchin.94@gmail.com>
    USB: serial: option: remove old LARA-R6 PID

Benoît Monin <benoit.monin@gmx.fr>
    USB: serial: option: add Sierra Wireless EM9191

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ring_buffer: Do not deactivate non-existant pages

Xiu Jianfeng <xiujianfeng@huawei.com>
    ftrace: Fix null pointer dereference in ftrace_add_mod()

Wang Wensheng <wangwensheng4@huawei.com>
    ftrace: Optimize the allocation for mcount entries

Wang Wensheng <wangwensheng4@huawei.com>
    ftrace: Fix the possible incorrect kernel message

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix wrong return value checking when GETFLAGS

Wei Yongjun <weiyongjun1@huawei.com>
    net/x25: Fix skb leak in x25_lapb_receive_frame()

Dan Carpenter <error27@gmail.com>
    drbd: use after free in drbd_create_device()

Yang Yingliang <yangyingliang@huawei.com>
    xen/pcpu: fix possible memory leak in register_pcpu()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: caif: fix double disconnect client in chnl_net_open()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    mISDN: fix misuse of put_device() in mISDN_register_device()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: fix possible memory leak in mISDN_dsp_element_register()

Wei Yongjun <weiyongjun1@huawei.com>
    net: bgmac: Drop free_netdev() from bgmac_enet_remove()

Zeng Heng <zengheng4@huawei.com>
    pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map

Maciej W. Rozycki <macro@orcam.me.uk>
    parport_pc: Avoid FIFO port location truncation

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    block: sed-opal: kmalloc the cmd/resp buffers

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: soc-utils: Remove __exit for snd_soc_util_exit()

Duoming Zhou <duoming@zju.edu.cn>
    tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send

Tony Lindgren <tony@atomide.com>
    serial: 8250: omap: Flush PM QOS work on remove

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    serial: 8250_omap: remove wait loop from Errata i202 workaround

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: core: Fix use-after-free in snd_soc_exit()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm

Nathan Huckleberry <nhuck@google.com>
    drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: cmos: fix build on non-ACPI platforms

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/futex: fix build for clang

Borislav Petkov <bp@suse.de>
    x86/cpu: Restore AMD's DE_CFG MSR after resume

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Check return code of dma_async_device_register

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix impossible condition

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Don't allow CPU to reorder channel enable

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix completion of unissued descriptor in case of errors

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Don't start transactions at tx_submit level

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_hdmac: Fix at_lli struct definition

Linus Torvalds <torvalds@linux-foundation.org>
    cert host tools: Stop complaining about deprecated OpenSSL functions

ZhangPeng <zhangpeng362@huawei.com>
    udf: Fix a slab-out-of-bounds write bug in udf_find_entry()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()

Jorge Lopez <jorge.lopez2@hp.com>
    platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi

Matthew Auld <matthew.auld@intel.com>
    drm/i915/dmabuf: fix sg_table handling in map_dma_buf

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock in nilfs_count_free_blocks()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk entry for M-Audio Micro

Ye Bin <yebin10@huawei.com>
    ALSA: hda: fix potential memleak in 'add_widget_node'

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Fix handling of misaligned runtime regions and drop warning

Chuang Wang <nashuiliang@gmail.com>
    net: macvlan: fix memory leaks of macvlan_common_newlink

Zhengchao Shao <shaozhengchao@huawei.com>
    net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    ethernet: s2io: disable napi when start nic failed in s2io_card_up()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()

Zhengchao Shao <shaozhengchao@huawei.com>
    drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()

Xin Long <lucien.xin@gmail.com>
    tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header

Alexander Potapenko <glider@google.com>
    ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network

Yuan Can <yuancan@huawei.com>
    drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()

Zhengchao Shao <shaozhengchao@huawei.com>
    hamradio: fix issue of dev reference count leakage in bpq_device_event()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()

Gaosheng Cui <cuigaosheng1@huawei.com>
    capabilities: fix undefined behavior in bit shift for CAP_TO_MASK

Sean Anderson <sean.anderson@seco.com>
    net: fman: Unregister ethernet device on removal

Alex Barba <alex.barba@broadcom.com>
    bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer

Jiri Benc <jbenc@redhat.com>
    net: gso: fix panic on frag_list with mixed head alloc types

Yang Yingliang <yangyingliang@huawei.com>
    HID: hyperv: fix possible memory leak in mousevsc_probe()


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm64/kernel/efi.c                           | 52 ++++++++++++-------
 arch/x86/include/asm/msr-index.h                  |  8 +--
 arch/x86/kernel/cpu/amd.c                         | 10 ++--
 arch/x86/kvm/svm.c                                | 10 ++--
 arch/x86/kvm/x86.c                                |  2 +-
 arch/x86/power/cpu.c                              |  1 +
 block/sed-opal.c                                  | 32 ++++++++++--
 drivers/block/drbd/drbd_main.c                    |  4 +-
 drivers/dma/at_hdmac.c                            | 34 ++++++-------
 drivers/dma/at_hdmac_regs.h                       | 10 ++--
 drivers/dma/mv_xor_v2.c                           |  1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c            |  4 +-
 drivers/gpu/drm/imx/imx-tve.c                     |  5 +-
 drivers/gpu/drm/vc4/vc4_drv.c                     |  7 ++-
 drivers/hid/hid-hyperv.c                          |  2 +-
 drivers/iio/adc/at91_adc.c                        |  4 +-
 drivers/iio/pressure/ms5611_spi.c                 |  2 +-
 drivers/iio/trigger/iio-trig-sysfs.c              |  6 ++-
 drivers/isdn/mISDN/core.c                         |  2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                 |  3 +-
 drivers/md/dm-ioctl.c                             |  4 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c           |  2 +
 drivers/mmc/core/core.c                           |  8 ++-
 drivers/mmc/host/sdhci-pci-core.c                 |  2 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c  |  4 +-
 drivers/net/ethernet/broadcom/bgmac.c             |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  1 +
 drivers/net/ethernet/freescale/fman/mac.c         |  9 ++++
 drivers/net/ethernet/marvell/mv643xx_eth.c        |  1 +
 drivers/net/ethernet/neterion/s2io.c              | 29 +++++++----
 drivers/net/hamradio/bpqether.c                   |  2 +-
 drivers/net/macvlan.c                             |  6 ++-
 drivers/net/wan/lapbether.c                       |  2 +-
 drivers/parport/parport_pc.c                      |  2 +-
 drivers/pinctrl/devicetree.c                      |  2 +
 drivers/platform/x86/hp-wmi.c                     | 12 ++++-
 drivers/rtc/rtc-cmos.c                            |  3 ++
 drivers/tty/n_gsm.c                               |  2 +-
 drivers/tty/serial/8250/8250_lpss.c               | 15 ++++--
 drivers/tty/serial/8250/8250_omap.c               | 18 +------
 drivers/tty/serial/8250/8250_port.c               |  7 ++-
 drivers/usb/chipidea/otg_fsm.c                    |  2 +
 drivers/usb/core/quirks.c                         |  3 ++
 drivers/usb/serial/option.c                       | 19 ++++++-
 drivers/xen/pcpu.c                                |  2 +-
 fs/btrfs/tests/btrfs-tests.c                      |  2 +-
 fs/buffer.c                                       |  4 +-
 fs/cifs/ioctl.c                                   |  4 +-
 fs/gfs2/ops_fstype.c                              | 11 ++--
 fs/namei.c                                        |  2 +-
 fs/nilfs2/segment.c                               | 15 +++---
 fs/nilfs2/super.c                                 |  2 -
 fs/nilfs2/the_nilfs.c                             |  2 -
 fs/ntfs/attrib.c                                  | 28 ++++++++--
 fs/ntfs/inode.c                                   |  7 +++
 fs/udf/namei.c                                    |  2 +-
 include/uapi/linux/capability.h                   |  2 +-
 kernel/trace/ftrace.c                             |  5 +-
 kernel/trace/ring_buffer.c                        |  4 +-
 mm/filemap.c                                      |  2 +-
 net/9p/trans_fd.c                                 |  6 ++-
 net/bluetooth/l2cap_core.c                        |  2 +-
 net/bpf/test_run.c                                |  1 +
 net/caif/chnl_net.c                               |  3 --
 net/core/skbuff.c                                 | 36 ++++++-------
 net/ipv4/tcp_cdg.c                                |  2 +
 net/ipv6/addrlabel.c                              |  1 +
 net/kcm/kcmsock.c                                 | 62 ++++-------------------
 net/tipc/netlink_compat.c                         |  2 +-
 net/x25/x25_dev.c                                 |  2 +-
 scripts/extract-cert.c                            |  7 +++
 scripts/sign-file.c                               |  7 +++
 sound/hda/hdac_sysfs.c                            |  4 +-
 sound/soc/soc-core.c                              | 17 ++++++-
 sound/soc/soc-utils.c                             |  2 +-
 sound/usb/midi.c                                  |  4 +-
 sound/usb/quirks-table.h                          |  4 ++
 tools/testing/selftests/futex/functional/Makefile |  6 +--
 80 files changed, 379 insertions(+), 244 deletions(-)


