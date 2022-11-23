Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8186356AB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237839AbiKWJb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbiKWJbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC03CC4C2B;
        Wed, 23 Nov 2022 01:29:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 154A461B49;
        Wed, 23 Nov 2022 09:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76455C433D6;
        Wed, 23 Nov 2022 09:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195794;
        bh=AhoGKzavmuP1w70nVzceQ4rNRR+xFFO87nGzC3Z+Mgs=;
        h=From:To:Cc:Subject:Date:From;
        b=WOb915j42VK1ula/PKsc2q0DuGwJcCMFZdsPXA7+aM0hhzsDpoSTNAOMAKus8z2bw
         vTGCqYWv7EgLXYVBPr05dfdM1HW74gqdfy8HS9Ded+ReUIliBH6jaIrIAKuqjGpjZX
         sorJNJD8n16k8ZOxkEsS98LK0p57pkg14/XZ9b4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/181] 5.15.80-rc1 review
Date:   Wed, 23 Nov 2022 09:49:23 +0100
Message-Id: <20221123084602.707860461@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.80-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.80-rc1
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

This is the start of the stable review cycle for the 5.15.80 release.
There are 181 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.80-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.80-rc1

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: check overflow when iterating ATTR_RECORDs

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: fix out-of-bounds read in ntfs_attr_find()

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: fix use-after-free in ntfs_attr_find()

Dominique Martinet <asmadeus@codewreck.org>
    net/9p: use a dedicated spinlock for trans_fd

Alexander Potapenko <glider@google.com>
    mm: fs: initialize fsdata passed to write_begin/write_end interface

Hawkins Jiawei <yin31149@gmail.com>
    wifi: wext: use flex array destination for memcpy()

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

Yuan Can <yuancan@huawei.com>
    scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: target: tcm_loop: Fix possible name leak in tcm_loop_setup_hba_bus()

Hangbin Liu <liuhangbin@gmail.com>
    net: use struct_group to copy ip/ipv6 header addresses

Aashish Sharma <shraash@google.com>
    tracing: Fix warning on variable 'struct trace_array'

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Include dropped pages in counting dirty patches

Marco Elver <elver@google.com>
    perf: Improve missing SIGTRAP checking

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake

Keith Busch <kbusch@kernel.org>
    nvme: ensure subsystem reset is single threaded

Keith Busch <kbusch@kernel.org>
    nvme: restrict management ioctls to admin

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix sampling using single range output

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

Brian Norris <briannorris@chromium.org>
    firmware: coreboot: Register bus in module init

Tina Zhang <tina.zhang@intel.com>
    iommu/vt-d: Set SRE bit only when hardware has SRS cap

Tina Zhang <tina.zhang@intel.com>
    iommu/vt-d: Preset Access bit for IOVA in FL non-leaf paging entries

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix double free of FSF request when qdio send fails

Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
    net: phy: marvell: add sleep time after enabling the loopback bit

Alban Crequy <albancrequy@linux.microsoft.com>
    maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: iforce - invert valid length check when fetching device IDs

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_lpss: Configure DMA also w/o DMA filter

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Flush DMA Rx on RLSI

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: fix misbehavior if list_versions races with module loading

Mitja Spes <mitja@lxnav.com>
    iio: pressure: ms5611: changed hardcoded SPI speed to value limited

Saravanan Sekar <sravanhome@gmail.com>
    iio: adc: mp2629: fix potential array out of bound access

Saravanan Sekar <sravanhome@gmail.com>
    iio: adc: mp2629: fix wrong comparison of channel

Yang Yingliang <yangyingliang@huawei.com>
    iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()

Yang Yingliang <yangyingliang@huawei.com>
    iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()

Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
    usb: typec: mux: Enter safe mode only when pins need to be reconfigured

Li Jun <jun.li@nxp.com>
    usb: cdns3: host: fix endless superspeed hub port reset

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

Linus Walleij <linus.walleij@linaro.org>
    USB: bcma: Make GPIO explicitly optional

Mushahid Hussain <mushi.shar@gmail.com>
    speakup: fix a segfault caused by switching consoles

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    slimbus: stream: correct presence rate frequencies

Zheng Bin <zhengbin13@huawei.com>
    slimbus: qcom-ngd: Fix build error when CONFIG_SLIM_QCOM_NGD_CTRL=y && CONFIG_QCOM_RPROC_COMMON=m

Johan Hovold <johan+linaro@kernel.org>
    Revert "usb: dwc3: disable USB core PHY management"

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Emil Flink <emil.flink@gmail.com>
    ALSA: hda/realtek: fix speakers for Samsung Galaxy Book Pro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Add HUBP surface flip interrupt handler

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: kprobe: Fix potential null-ptr-deref on trace_array in kprobe_event_gen_test_exit()

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: kprobe: Fix potential null-ptr-deref on trace_event_file in kprobe_event_gen_test_exit()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Fix race where eprobes can be called before the event

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: Fix wild-memory-access in register_synth_event()

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: Fix memory leak in test_gen_synth_cmd() and test_empty_synth_event()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/ring-buffer: Have polling block on watermark

Wang Yufen <wangyufen@huawei.com>
    tracing: Fix memory leak in tracing_read_pipe()

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

Shang XiaoJing <shangxiaojing@huawei.com>
    net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix wrong return value checking when GETFLAGS

Wei Yongjun <weiyongjun1@huawei.com>
    net/x25: Fix skb leak in x25_lapb_receive_frame()

Liu Jian <liujian56@huawei.com>
    net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()

Anastasia Belova <abelova@astralinux.ru>
    cifs: add check for returning value of SMB2_close_init

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Do not check for repeated unsequenced packets

Roger Pau Monné <roger.pau@citrix.com>
    platform/x86/intel: pmc: Don't unconditionally attach Intel PMC when virtualized

Dan Carpenter <error27@gmail.com>
    drbd: use after free in drbd_create_device()

Ido Schimmel <idosch@nvidia.com>
    bridge: switchdev: Fix memory leaks when changing VLAN protocol

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process

Yuan Can <yuancan@huawei.com>
    net: ena: Fix error handling in ena_init()

Yuan Can <yuancan@huawei.com>
    net: ionic: Fix error handling in ionic_init_module()

Yang Yingliang <yangyingliang@huawei.com>
    xen/pcpu: fix possible memory leak in register_pcpu()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims

Wei Yongjun <weiyongjun1@huawei.com>
    net: mhi: Fix memory leak in mhi_net_dellink()

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

Xiaolei Wang <xiaolei.wang@windriver.com>
    soc: imx8m: Enable OCOTP clock before reading the register

Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>
    net: stmmac: ensure tx function is not running in stmmac_xdp_release()

Yuan Can <yuancan@huawei.com>
    net: hinic: Fix error handling in hinic_module_init()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: fix possible memory leak in mISDN_dsp_element_register()

Wei Yongjun <weiyongjun1@huawei.com>
    net: bgmac: Drop free_netdev() from bgmac_enet_remove()

Xu Kuohai <xukuohai@huawei.com>
    bpf: Initialize same number of free nodes for each pcpu_freelist

Liao Chang <liaochang1@huawei.com>
    MIPS: Loongson64: Add WARN_ON on kexec related kmalloc failed

Rongwei Zhang <pudh4418@gmail.com>
    MIPS: fix duplicate definitions for exported symbols

Jaco Coetzee <jaco.coetzee@corigine.com>
    nfp: change eeprom length to max length enumerators

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix error handling in ata_tdev_add()

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix error handling in ata_tlink_add()

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix error handling in ata_tport_add()

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix double ata_host_put() in ata_tport_add()

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mn: Fix NAND controller size-cells

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mm: Fix NAND controller size-cells

Marek Vasut <marex@denx.de>
    ARM: dts: imx7: Fix NAND controller size-cells

Shang XiaoJing <shangxiaojing@huawei.com>
    drm: Fix potential null-ptr-deref in drm_vblank_destroy_worker()

Shang XiaoJing <shangxiaojing@huawei.com>
    drm/drv: Fix potential memory leak in drm_dev_init()

Aishwarya Kothari <aishwarya.kothari@toradex.com>
    drm/panel: simple: set bpc field for logic technologies displays

Gaosheng Cui <cuigaosheng1@huawei.com>
    drm/vc4: kms: Fix IS_ERR() vs NULL check for vc4_kms

Zeng Heng <zengheng4@huawei.com>
    pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map

Maciej W. Rozycki <macro@orcam.me.uk>
    parport_pc: Avoid FIFO port location truncation

Yang Yingliang <yangyingliang@huawei.com>
    siox: fix possible memory leak in siox_device_add()

D Scott Phillips <scott@os.amperecomputing.com>
    arm64: Fix bit-shifting UB in the MIDR_CPU_MODEL() macro

Wang Yufen <wangyufen@huawei.com>
    bpf: Fix memory leaks in __check_func_call

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    block: sed-opal: kmalloc the cmd/resp buffers

Yang Yingliang <yangyingliang@huawei.com>
    scsi: scsi_transport_sas: Fix error handling in sas_phy_add()

Quentin Schulz <quentin.schulz@theobroma-systems.com>
    pinctrl: rockchip: list all pins in a possible mux route for PX30

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: soc-utils: Remove __exit for snd_soc_util_exit()

Baisong Zhong <zhongbaisong@huawei.com>
    bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

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

Tony Lindgren <tony@atomide.com>
    serial: 8250: omap: Fix missing PM runtime calls for omap8250_set_mctrl()

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: avoid soft resetting AC DLL

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Fix set_tdm_slot in case of single slot

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Fix set_tdm_slot in case of single slot

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: core: Fix use-after-free in snd_soc_exit()

Mihai Sain <mihai.sain@microchip.com>
    ARM: dts: at91: sama7g5: fix signal name of pin PB2

Marek Vasut <marex@denx.de>
    spi: stm32: Print summary 'callbacks suppressed' message

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sm8350-hdk: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sm8250-xperia-edo: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sm8150-xperia-kumano: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sa8155p-adp: Specify which LDO modes are allowed

James Houghton <jthoughton@google.com>
    hugetlbfs: don't delete error page from pagecache

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Do not speculatively query Intel GP PMCs that don't exist yet

Mika Westerberg <mika.westerberg@linux.intel.com>
    spi: intel: Use correct mask for flash and protected regions

Mika Westerberg <mika.westerberg@linux.intel.com>
    mtd: spi-nor: intel-spi: Disable write protection only if asked

Colin Ian King <colin.i.king@gmail.com>
    ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"

Tony Luck <tony.luck@intel.com>
    x86/cpu: Add several Intel server CPU model numbers

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm

Filipe Manana <fdmanana@suse.com>
    btrfs: remove pointless and double ulist frees in error paths of qgroup tests

Nathan Huckleberry <nhuck@google.com>
    drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

Nam Cao <namcaov@gmail.com>
    i2c: i801: add lis3lv02d's I2C address for Vostro 5568

Thierry Reding <treding@nvidia.com>
    i2c: tegra: Allocate DMA memory for DMA engine

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Cleanup the core driver removal callback

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Add another system to quirk list for forcing StorageD3Enable

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Retry LOCK on OLD_STATEID during delegation return

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: properly handle the error when unable to find the missing stripe

Michael Margolin <mrgolin@amazon.com>
    RDMA/efa: Add EFA 0xefa2 PCI ID

Hans de Goede <hdegoede@redhat.com>
    ACPI: scan: Add LATT2021 to acpi_ignore_dep_ids[]

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Remove wrong pipe control lock

Shuming Fan <shumingf@realtek.com>
    ASoC: rt1308-sdw: add the default value of some registers

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: cmos: fix build on non-ACPI platforms

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/intel_pstate: fix build for ARCH=x86_64

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/futex: fix build for clang

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add quirk variant for LAPBC710 NUC15

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

Derek Fang <derek.fang@realtek.com>
    ASoC: rt1019: Fix the TDM settings

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: mt6660: Keep the pm_runtime enables before component stuff in mt6660_i2c_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"

Yang Shi <shy828301@gmail.com>
    mm: shmem: don't truncate page if memory failure happens

Yang Shi <shy828301@gmail.com>
    mm: hwpoison: handle non-anonymous THP correctly

Yang Shi <shy828301@gmail.com>
    mm: hwpoison: refactor refcount check handling


-------------

Diffstat:

 .../process/code-of-conduct-interpretation.rst     |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   4 +-
 arch/arm/boot/dts/sama7g5-pinfunc.h                |   2 +-
 arch/arm/mach-at91/pm_suspend.S                    |   7 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   4 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   2 +-
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts           |  13 ++-
 .../boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi   |   6 ++
 .../boot/dts/qcom/sm8250-sony-xperia-edo.dtsi      |   6 ++
 arch/arm64/boot/dts/qcom/sm8350-hdk.dts            |  12 +++
 arch/arm64/include/asm/cputype.h                   |   2 +-
 arch/mips/kernel/relocate_kernel.S                 |  15 +--
 arch/mips/loongson64/reset.c                       |  10 ++
 arch/x86/events/intel/pt.c                         |   9 ++
 arch/x86/include/asm/intel-family.h                |  11 +-
 arch/x86/kvm/x86.c                                 |  14 +--
 block/sed-opal.c                                   |  32 +++++-
 drivers/accessibility/speakup/main.c               |   2 +-
 drivers/acpi/scan.c                                |   1 +
 drivers/acpi/x86/utils.c                           |   6 ++
 drivers/ata/libata-transport.c                     |  19 +++-
 drivers/block/drbd/drbd_main.c                     |   4 +-
 drivers/firmware/arm_scmi/bus.c                    |  11 ++
 drivers/firmware/arm_scmi/common.h                 |   1 +
 drivers/firmware/arm_scmi/driver.c                 |  31 +++---
 drivers/firmware/google/coreboot_table.c           |  37 +++++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c  |   1 +
 drivers/gpu/drm/drm_drv.c                          |   2 +-
 drivers/gpu/drm/drm_internal.h                     |   3 +-
 drivers/gpu/drm/imx/imx-tve.c                      |   5 +-
 drivers/gpu/drm/panel/panel-simple.c               |   2 +
 drivers/gpu/drm/vc4/vc4_kms.c                      |   8 +-
 drivers/i2c/busses/i2c-i801.c                      |   1 +
 drivers/i2c/busses/i2c-tegra.c                     |  16 +--
 drivers/iio/adc/at91_adc.c                         |   4 +-
 drivers/iio/adc/mp2629_adc.c                       |   5 +-
 drivers/iio/pressure/ms5611_spi.c                  |   2 +-
 drivers/iio/trigger/iio-trig-sysfs.c               |   6 +-
 drivers/infiniband/hw/efa/efa_main.c               |   4 +-
 drivers/input/joystick/iforce/iforce-main.c        |   8 +-
 drivers/input/serio/i8042.c                        |   4 -
 drivers/iommu/intel/iommu.c                        |   8 +-
 drivers/iommu/intel/pasid.c                        |   5 +-
 drivers/isdn/mISDN/core.c                          |   2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |   3 +-
 drivers/md/dm-ioctl.c                              |   4 +-
 drivers/mfd/lpc_ich.c                              |  59 ++++++++++-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   2 +
 drivers/mmc/core/core.c                            |   8 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   2 +
 drivers/mmc/host/sdhci-pci-o2micro.c               |   7 ++
 drivers/mtd/spi-nor/controllers/intel-spi-pci.c    |  29 ++++--
 drivers/mtd/spi-nor/controllers/intel-spi.c        |  51 +++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   8 +-
 drivers/net/ethernet/atheros/ag71xx.c              |   3 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  34 +++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  10 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   9 +-
 .../net/ethernet/microchip/sparx5/sparx5_ethtool.c |   3 +
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   3 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   6 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +
 drivers/net/macvlan.c                              |   6 +-
 drivers/net/mhi_net.c                              |   2 +
 drivers/net/phy/marvell.c                          |  16 +--
 drivers/net/thunderbolt.c                          |  19 +++-
 drivers/nvme/host/ioctl.c                          |   6 ++
 drivers/nvme/host/nvme.h                           |  16 ++-
 drivers/parport/parport_pc.c                       |   2 +-
 drivers/pinctrl/devicetree.c                       |   2 +
 drivers/pinctrl/pinctrl-rockchip.c                 |  40 ++++++++
 .../platform/surface/aggregator/ssh_packet_layer.c |  24 ++++-
 drivers/platform/x86/intel/pmc/pltdrv.c            |   9 ++
 drivers/rtc/rtc-cmos.c                             |   3 +
 drivers/s390/scsi/zfcp_fsf.c                       |   2 +-
 drivers/scsi/scsi_debug.c                          |   6 +-
 drivers/scsi/scsi_transport_sas.c                  |  13 ++-
 drivers/siox/siox-core.c                           |   2 +
 drivers/slimbus/Kconfig                            |   2 +-
 drivers/slimbus/stream.c                           |   8 +-
 drivers/soc/imx/soc-imx8m.c                        |  11 ++
 drivers/spi/spi-stm32.c                            |   1 +
 drivers/target/loopback/tcm_loop.c                 |   3 +-
 drivers/tty/n_gsm.c                                |   2 +-
 drivers/tty/serial/8250/8250_lpss.c                |  18 +++-
 drivers/tty/serial/8250/8250_omap.c                |  45 +++++----
 drivers/tty/serial/8250/8250_port.c                |   7 +-
 drivers/tty/serial/imx.c                           |   1 +
 drivers/usb/cdns3/host.c                           |  56 +++++------
 drivers/usb/chipidea/otg_fsm.c                     |   2 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/host.c                            |  10 --
 drivers/usb/host/bcma-hcd.c                        |  10 +-
 drivers/usb/serial/option.c                        |  19 +++-
 drivers/usb/typec/mux/intel_pmc_mux.c              |  15 ++-
 drivers/xen/pcpu.c                                 |   2 +-
 fs/btrfs/raid56.c                                  |   6 +-
 fs/btrfs/tests/qgroup-tests.c                      |  16 +--
 fs/buffer.c                                        |   4 +-
 fs/cifs/ioctl.c                                    |   4 +-
 fs/cifs/smb2ops.c                                  |   4 +
 fs/gfs2/ops_fstype.c                               |  17 ++--
 fs/hugetlbfs/inode.c                               |  13 ++-
 fs/namei.c                                         |   2 +-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/ntfs/attrib.c                                   |  28 +++++-
 fs/ntfs/inode.c                                    |   7 ++
 include/linux/platform_data/x86/intel-spi.h        |   6 +-
 include/linux/ring_buffer.h                        |   2 +-
 include/linux/trace.h                              |   4 +-
 include/linux/wireless.h                           |  10 +-
 include/net/ip.h                                   |   2 +-
 include/net/ipv6.h                                 |   2 +-
 include/soc/at91/sama7-ddr.h                       |   5 +-
 include/uapi/linux/ip.h                            |   6 +-
 include/uapi/linux/ipv6.h                          |   6 +-
 kernel/bpf/percpu_freelist.c                       |  23 ++---
 kernel/bpf/verifier.c                              |  14 ++-
 kernel/events/core.c                               |  25 +++--
 kernel/kprobes.c                                   |   8 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/kprobe_event_gen_test.c               |  48 ++++++---
 kernel/trace/ring_buffer.c                         |  71 +++++++++----
 kernel/trace/synth_event_gen_test.c                |  16 ++-
 kernel/trace/trace.c                               |   3 +-
 kernel/trace/trace_eprobe.c                        |   3 +
 kernel/trace/trace_events_synth.c                  |   5 +-
 mm/filemap.c                                       |   2 +-
 mm/hugetlb.c                                       |   4 +
 mm/maccess.c                                       |   2 +-
 mm/memory-failure.c                                | 111 ++++++++++++++-------
 mm/shmem.c                                         |  51 ++++++++--
 mm/userfaultfd.c                                   |   5 +
 net/9p/trans_fd.c                                  |  45 ++++++---
 net/bluetooth/l2cap_core.c                         |   2 +-
 net/bpf/test_run.c                                 |   1 +
 net/bridge/br_vlan.c                               |  17 +++-
 net/caif/chnl_net.c                                |   3 -
 net/dsa/dsa_priv.h                                 |   1 +
 net/dsa/master.c                                   |   3 +-
 net/dsa/port.c                                     |  16 +++
 net/ipv4/tcp_cdg.c                                 |   2 +
 net/kcm/kcmsock.c                                  |  62 ++----------
 net/wireless/wext-core.c                           |  17 ++--
 net/x25/x25_dev.c                                  |   2 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/codecs/jz4725b.c                         |  34 ++++---
 sound/soc/codecs/mt6660.c                          |   8 +-
 sound/soc/codecs/rt1019.c                          |  20 ++--
 sound/soc/codecs/rt1019.h                          |   6 ++
 sound/soc/codecs/rt1308-sdw.h                      |   2 +
 sound/soc/codecs/tas2764.c                         |  19 ++--
 sound/soc/codecs/tas2770.c                         |  20 ++--
 sound/soc/codecs/wm5102.c                          |   6 +-
 sound/soc/codecs/wm5110.c                          |   6 +-
 sound/soc/codecs/wm8962.c                          |  54 +++++++++-
 sound/soc/codecs/wm8997.c                          |   6 +-
 sound/soc/intel/boards/sof_sdw.c                   |  11 ++
 sound/soc/soc-core.c                               |  17 +++-
 sound/soc/soc-utils.c                              |   2 +-
 sound/usb/midi.c                                   |   4 +-
 tools/testing/selftests/futex/functional/Makefile  |   6 +-
 tools/testing/selftests/intel_pstate/Makefile      |   6 +-
 168 files changed, 1335 insertions(+), 612 deletions(-)


