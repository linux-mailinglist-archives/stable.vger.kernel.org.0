Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085C96354DD
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiKWJLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbiKWJLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:11:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09178DF35;
        Wed, 23 Nov 2022 01:11:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BA5C61B10;
        Wed, 23 Nov 2022 09:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE205C433D7;
        Wed, 23 Nov 2022 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194695;
        bh=CowHmYPefQRdviNJyC4D4n4toP/Lu/Z5lUDeKbpbeGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=IXKS5srOeJGVZ/d+q3/WbipJuHT6oQFYHSzyd8gWk8pwcY8JZBvzszJg2aqROw5qC
         BCY5VXFUPfAIicnsT9Aegg4YY9UGNU3Dv1gCqax5AhYjcEd3HwO6U0lFfZDkps4BsJ
         aqxu6jNRWtP6WTqpd0XyhTbu8zIBbS+W57yzzbw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 000/156] 5.4.225-rc1 review
Date:   Wed, 23 Nov 2022 09:49:17 +0100
Message-Id: <20221123084557.816085212@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.225-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.225-rc1
X-KernelTest-Deadline: 2022-11-25T08:46+00:00
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

This is the start of the stable review cycle for the 5.4.225 release.
There are 156 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.225-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.225-rc1

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

Chen Jun <chenjun102@huawei.com>
    Input: i8042 - fix leaking of platform device on module removal

Li Huafei <lihuafei1@huawei.com>
    kprobes: Skip clearing aggrprobe's post_handler in kprobe-on-ftrace case

Yang Yingliang <yangyingliang@huawei.com>
    scsi: target: tcm_loop: Fix possible name leak in tcm_loop_setup_hba_bus()

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Include dropped pages in counting dirty patches

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Flush DMA Rx on RLSI

Alexander Potapenko <glider@google.com>
    misc/vmw_vmci: fix an infoleak in vmci_host_do_receive_datagram()

Shuah Khan <skhan@linuxfoundation.org>
    docs: update mediator contact information in CoC doc

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()

Chevron Li <chevron.li@bayhubtech.com>
    mmc: sdhci-pci-o2micro: fix card detect fail issue caused by CD# debounce timeout

Yann Gautier <yann.gautier@foss.st.com>
    mmc: core: properly select voltage range without power cycle

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix double free of FSF request when qdio send fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: iforce - invert valid length check when fetching device IDs

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

Mushahid Hussain <mushi.shar@gmail.com>
    speakup: fix a segfault caused by switching consoles

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    slimbus: stream: correct presence rate frequencies

Johan Hovold <johan+linaro@kernel.org>
    Revert "usb: dwc3: disable USB core PHY management"

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

Anastasia Belova <abelova@astralinux.ru>
    cifs: add check for returning value of SMB2_set_info_init

Yuan Can <yuancan@huawei.com>
    net: thunderbolt: Fix error handling in tbnet_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix wrong return value checking when GETFLAGS

Wei Yongjun <weiyongjun1@huawei.com>
    net/x25: Fix skb leak in x25_lapb_receive_frame()

Roger Pau Monné <roger.pau@citrix.com>
    platform/x86/intel: pmc: Don't unconditionally attach Intel PMC when virtualized

Dan Carpenter <error27@gmail.com>
    drbd: use after free in drbd_create_device()

Yang Yingliang <yangyingliang@huawei.com>
    xen/pcpu: fix possible memory leak in register_pcpu()

Gaosheng Cui <cuigaosheng1@huawei.com>
    bnxt_en: Remove debugfs when pci_register_driver failed

Zhengchao Shao <shaozhengchao@huawei.com>
    net: caif: fix double disconnect client in chnl_net_open()

Chuang Wang <nashuiliang@gmail.com>
    net: macvlan: Use built-in RCU list checking

Wang ShaoBo <bobo.shaobowang@huawei.com>
    mISDN: fix misuse of put_device() in mISDN_register_device()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: liquidio: release resources when liquidio driver open failed

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: fix possible memory leak in mISDN_dsp_element_register()

Wei Yongjun <weiyongjun1@huawei.com>
    net: bgmac: Drop free_netdev() from bgmac_enet_remove()

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix double ata_host_put() in ata_tport_add()

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mn: Fix NAND controller size-cells

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mm: Fix NAND controller size-cells

Zeng Heng <zengheng4@huawei.com>
    pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map

Maciej W. Rozycki <macro@orcam.me.uk>
    parport_pc: Avoid FIFO port location truncation

Yang Yingliang <yangyingliang@huawei.com>
    siox: fix possible memory leak in siox_device_add()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    block: sed-opal: kmalloc the cmd/resp buffers

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: soc-utils: Remove __exit for snd_soc_util_exit()

Duoming Zhou <duoming@zju.edu.cn>
    tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send

Shawn Guo <shawn.guo@linaro.org>
    serial: imx: Add missing .thaw_noirq hook

Tony Lindgren <tony@atomide.com>
    serial: 8250: omap: Flush PM QOS work on remove

Tony Lindgren <tony@atomide.com>
    serial: 8250: omap: Fix unpaired pm_runtime_put_sync() in omap8250_remove()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    serial: 8250_omap: remove wait loop from Errata i202 workaround

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: core: Fix use-after-free in snd_soc_exit()

Marek Vasut <marex@denx.de>
    spi: stm32: Print summary 'callbacks suppressed' message

Colin Ian King <colin.i.king@gmail.com>
    ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm

Filipe Manana <fdmanana@suse.com>
    btrfs: remove pointless and double ulist frees in error paths of qgroup tests

Nathan Huckleberry <nhuck@google.com>
    drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

Nam Cao <namcaov@gmail.com>
    i2c: i801: add lis3lv02d's I2C address for Vostro 5568

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Retry LOCK on OLD_STATEID during delegation return

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: cmos: fix build on non-ACPI platforms

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/intel_pstate: fix build for ARCH=x86_64

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/futex: fix build for clang

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: fix capture selector naming

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: use right control for Capture Volume

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: fix reported volume for Master ctl

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: add missed Line In power control bit

Mauro Lima <mauro.lima@eclypsium.com>
    spi: intel: Fix the offset to get the 64K erase opcode

Xiaolei Wang <xiaolei.wang@windriver.com>
    ASoC: wm8962: Add an event handler for TEMP_HP and TEMP_SPK

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"

Borislav Petkov <bp@suse.de>
    x86/cpu: Restore AMD's DE_CFG MSR after resume

Eric Dumazet <edumazet@google.com>
    net: tun: call napi_schedule_prep() to ensure we own a napi

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

Oliver Hartkopp <socketcan@hartkopp.net>
    can: j1939: j1939_send_one(): fix missing CAN header initialization

ZhangPeng <zhangpeng362@huawei.com>
    udf: Fix a slab-out-of-bounds write bug in udf_find_entry()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    btrfs: selftests: fix wrong error check in btrfs_free_dummy_root()

Jorge Lopez <jorge.lopez2@hp.com>
    platform/x86: hp_wmi: Fix rfkill causing soft blocked wifi

Matthew Auld <matthew.auld@intel.com>
    drm/i915/dmabuf: fix sg_table handling in map_dma_buf

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free bug of ns_writer on remount

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock in nilfs_count_free_blocks()

Nathan Chancellor <nathan@kernel.org>
    vmlinux.lds.h: Fix placement of '.data..decrypted' section

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Add DSD support for Accuphase DAC-60

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk entry for M-Audio Micro

Ye Bin <yebin10@huawei.com>
    ALSA: hda: fix potential memleak in 'add_widget_node'

Xian Wang <dev@xianwang.io>
    ALSA: hda/ca0132: add quirk for EVGA Z390 DARK

Brian Norris <briannorris@chromium.org>
    mmc: sdhci-tegra: Fix SDHCI_RESET_ALL for CQHCI

Brian Norris <briannorris@chromium.org>
    mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI

Brian Norris <briannorris@chromium.org>
    mmc: cqhci: Provide helper for resetting both SDHCI and CQHCI

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: jump_label: Fix compat branch range check

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Fix handling of misaligned runtime regions and drop warning

Jisheng Zhang <jszhang@kernel.org>
    riscv: process: fix kernel info leakage

Chuang Wang <nashuiliang@gmail.com>
    net: macvlan: fix memory leaks of macvlan_common_newlink

Zhengchao Shao <shaozhengchao@huawei.com>
    ethernet: tundra: free irq when alloc ring failed in tsi108_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    ethernet: s2io: disable napi when start nic failed in s2io_card_up()

Zhengchao Shao <shaozhengchao@huawei.com>
    cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: cpsw: disable napi in cpsw_ndo_open()

Roy Novich <royno@nvidia.com>
    net/mlx5: Allow async trigger completion execution on single CPU systems

Zhengchao Shao <shaozhengchao@huawei.com>
    net: nixge: disable napi when enable interrupts failed in nixge_open()

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    perf stat: Fix printing os->prefix in CSV metrics output

Zhengchao Shao <shaozhengchao@huawei.com>
    drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: mv_xor_v2: Fix a resource leak in mv_xor_v2_remove()

Doug Brown <doug@schmorgal.com>
    dmaengine: pxa_dma: use platform_get_irq_optional

Xin Long <lucien.xin@gmail.com>
    tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header

Zhengchao Shao <shaozhengchao@huawei.com>
    can: af_can: fix NULL pointer dereference in can_rx_register()

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

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()

Wang Yufen <wangyufen@huawei.com>
    net: tun: Fix memory leaks of napi_get_frags

Jiri Benc <jbenc@redhat.com>
    net: gso: fix panic on frag_list with mixed head alloc types

Yang Yingliang <yangyingliang@huawei.com>
    HID: hyperv: fix possible memory leak in mousevsc_probe()

Wang Yufen <wangyufen@huawei.com>
    bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues

Arend van Spriel <arend.vanspriel@broadcom.com>
    wifi: cfg80211: fix memory leak in query_regdb_file()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: silence a sparse RCU warning

Dan Carpenter <dan.carpenter@oracle.com>
    phy: stm32: fix an error code in probe

Brian Foster <bfoster@redhat.com>
    xfs: drain the buf delwri queue before xfsaild idles

Eric Sandeen <sandeen@redhat.com>
    xfs: preserve inode versioning across remounts

Dave Chinner <dchinner@redhat.com>
    xfs: use MMAPLOCK around filemap_map_pages()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: redesign the reflink remap loop to fix blkres depletion crash

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: rename xfs_bmap_is_real_extent to is_written_extent

Brian Foster <bfoster@redhat.com>
    xfs: preserve rmapbt swapext block reservation from freed blocks


-------------

Diffstat:

 .../process/code-of-conduct-interpretation.rst     |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   4 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   2 +-
 arch/arm64/kernel/efi.c                            |  52 +++--
 arch/mips/kernel/jump_label.c                      |   2 +-
 arch/riscv/kernel/process.c                        |   2 +
 arch/x86/include/asm/msr-index.h                   |   8 +-
 arch/x86/kernel/cpu/amd.c                          |   6 +-
 arch/x86/kernel/cpu/hygon.c                        |   4 +-
 arch/x86/kvm/svm.c                                 |  10 +-
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/power/cpu.c                               |   1 +
 block/sed-opal.c                                   |  32 ++-
 drivers/ata/libata-transport.c                     |   1 -
 drivers/block/drbd/drbd_main.c                     |   4 +-
 drivers/dma/at_hdmac.c                             |  34 ++-
 drivers/dma/at_hdmac_regs.h                        |  10 +-
 drivers/dma/mv_xor_v2.c                            |   1 +
 drivers/dma/pxa_dma.c                              |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |   4 +-
 drivers/gpu/drm/imx/imx-tve.c                      |   5 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   7 +-
 drivers/hid/hid-hyperv.c                           |   2 +-
 drivers/i2c/busses/i2c-i801.c                      |   1 +
 drivers/iio/adc/at91_adc.c                         |   4 +-
 drivers/iio/pressure/ms5611_spi.c                  |   2 +-
 drivers/iio/trigger/iio-trig-sysfs.c               |   6 +-
 drivers/input/joystick/iforce/iforce-main.c        |   8 +-
 drivers/input/serio/i8042.c                        |   4 -
 drivers/isdn/mISDN/core.c                          |   2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |   3 +-
 drivers/md/dm-ioctl.c                              |   4 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   2 +
 drivers/mmc/core/core.c                            |   8 +-
 drivers/mmc/host/sdhci-cqhci.h                     |  24 ++
 drivers/mmc/host/sdhci-of-arasan.c                 |   3 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   2 +
 drivers/mmc/host/sdhci-pci-o2micro.c               |   7 +
 drivers/mmc/host/sdhci-tegra.c                     |   3 +-
 drivers/mtd/spi-nor/intel-spi.c                    |   2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |   4 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  34 ++-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   1 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   2 +-
 drivers/net/ethernet/freescale/fman/mac.c          |   9 +
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  11 +-
 drivers/net/ethernet/neterion/s2io.c               |  29 ++-
 drivers/net/ethernet/ni/nixge.c                    |   1 +
 drivers/net/ethernet/ti/cpsw.c                     |   2 +
 drivers/net/ethernet/tundra/tsi108_eth.c           |   5 +-
 drivers/net/hamradio/bpqether.c                    |   2 +-
 drivers/net/macvlan.c                              |  10 +-
 drivers/net/thunderbolt.c                          |  19 +-
 drivers/net/tun.c                                  |  18 +-
 drivers/net/wan/lapbether.c                        |   2 +-
 drivers/parport/parport_pc.c                       |   2 +-
 drivers/phy/st/phy-stm32-usbphyc.c                 |   2 +
 drivers/pinctrl/devicetree.c                       |   2 +
 drivers/platform/x86/hp-wmi.c                      |  12 +-
 drivers/platform/x86/intel_pmc_core_pltdrv.c       |   9 +
 drivers/rtc/rtc-cmos.c                             |   3 +
 drivers/s390/scsi/zfcp_fsf.c                       |   2 +-
 drivers/siox/siox-core.c                           |   2 +
 drivers/slimbus/stream.c                           |   8 +-
 drivers/spi/spi-stm32.c                            |   1 +
 drivers/staging/speakup/main.c                     |   2 +-
 drivers/target/loopback/tcm_loop.c                 |   3 +-
 drivers/tty/n_gsm.c                                |   2 +-
 drivers/tty/serial/8250/8250_lpss.c                |  15 +-
 drivers/tty/serial/8250/8250_omap.c                |  23 +-
 drivers/tty/serial/8250/8250_port.c                |   7 +-
 drivers/tty/serial/imx.c                           |   1 +
 drivers/usb/chipidea/otg_fsm.c                     |   2 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/host.c                            |  10 -
 drivers/usb/serial/option.c                        |  19 +-
 drivers/xen/pcpu.c                                 |   2 +-
 fs/btrfs/tests/btrfs-tests.c                       |   2 +-
 fs/btrfs/tests/qgroup-tests.c                      |  16 +-
 fs/buffer.c                                        |   4 +-
 fs/cifs/ioctl.c                                    |   4 +-
 fs/cifs/smb2ops.c                                  |   2 +
 fs/gfs2/ops_fstype.c                               |  17 +-
 fs/namei.c                                         |   2 +-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nilfs2/segment.c                                |  15 +-
 fs/nilfs2/super.c                                  |   2 -
 fs/nilfs2/the_nilfs.c                              |   2 -
 fs/ntfs/attrib.c                                   |  28 ++-
 fs/ntfs/inode.c                                    |   7 +
 fs/udf/namei.c                                     |   2 +-
 fs/xfs/libxfs/xfs_bmap.h                           |  15 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                       |   2 +-
 fs/xfs/libxfs/xfs_shared.h                         |   1 +
 fs/xfs/xfs_bmap_util.c                             |  18 +-
 fs/xfs/xfs_file.c                                  |  15 +-
 fs/xfs/xfs_reflink.c                               | 244 +++++++++++----------
 fs/xfs/xfs_super.c                                 |   4 +
 fs/xfs/xfs_trace.h                                 |  52 +----
 fs/xfs/xfs_trans.c                                 |  19 +-
 fs/xfs/xfs_trans_ail.c                             |  16 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/uapi/linux/capability.h                    |   2 +-
 kernel/kprobes.c                                   |   8 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/ring_buffer.c                         |  16 +-
 mm/filemap.c                                       |   2 +-
 net/9p/trans_fd.c                                  |   6 +-
 net/bluetooth/l2cap_core.c                         |   2 +-
 net/bpf/test_run.c                                 |   1 +
 net/caif/chnl_net.c                                |   3 -
 net/can/af_can.c                                   |   2 +-
 net/can/j1939/main.c                               |   3 +
 net/core/skbuff.c                                  |  36 +--
 net/ipv4/tcp_bpf.c                                 |   8 +-
 net/ipv4/tcp_cdg.c                                 |   2 +
 net/ipv6/addrlabel.c                               |   1 +
 net/kcm/kcmsock.c                                  |  62 +-----
 net/tipc/netlink_compat.c                          |   2 +-
 net/wireless/reg.c                                 |  12 +-
 net/wireless/scan.c                                |   4 +-
 net/x25/x25_dev.c                                  |   2 +-
 scripts/extract-cert.c                             |   7 +
 scripts/sign-file.c                                |   7 +
 sound/hda/hdac_sysfs.c                             |   4 +-
 sound/pci/hda/patch_ca0132.c                       |   1 +
 sound/soc/codecs/jz4725b.c                         |  34 +--
 sound/soc/codecs/wm5102.c                          |   6 +-
 sound/soc/codecs/wm5110.c                          |   6 +-
 sound/soc/codecs/wm8962.c                          |  54 ++++-
 sound/soc/codecs/wm8997.c                          |   6 +-
 sound/soc/soc-core.c                               |  17 +-
 sound/soc/soc-utils.c                              |   2 +-
 sound/usb/midi.c                                   |   4 +-
 sound/usb/quirks-table.h                           |   4 +
 sound/usb/quirks.c                                 |   1 +
 tools/perf/util/stat-display.c                     |   2 +-
 tools/testing/selftests/futex/functional/Makefile  |   6 +-
 tools/testing/selftests/intel_pstate/Makefile      |   6 +-
 .../selftests/kvm/include/x86_64/processor.h       |   8 +-
 145 files changed, 881 insertions(+), 555 deletions(-)


