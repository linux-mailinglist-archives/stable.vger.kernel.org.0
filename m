Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4C63DD33
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiK3SZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiK3SZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD72116E;
        Wed, 30 Nov 2022 10:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6C71B81C9A;
        Wed, 30 Nov 2022 18:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D85C433C1;
        Wed, 30 Nov 2022 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832717;
        bh=thYN3O1wU89b9d40lNMO2Xs8iJYUex9abBy7xBtIP9E=;
        h=From:To:Cc:Subject:Date:From;
        b=TIDHUtAbd1mCofUos1j3D6TKSuvndKoP/qNYnh2MqDCffA08q9tTrMa9U8Xm8zSeQ
         x6EoCFQOnaem5iDEIc9yhDTZ6DuaKPuPcGaavtMVGxAdOvF0uAqKc+yjItJwagX+Hm
         Hai36h5WjaEkjaJbIwhdXRZ52Yn1NbBPH6Mey8TU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/162] 5.10.157-rc1 review
Date:   Wed, 30 Nov 2022 19:21:21 +0100
Message-Id: <20221130180528.466039523@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.157-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.157-rc1
X-KernelTest-Deadline: 2022-12-02T18:05+00:00
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

This is the start of the stable review cycle for the 5.10.157 release.
There are 162 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.157-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.157-rc1

Andrzej Hajda <andrzej.hajda@intel.com>
    drm/i915: fix TLB invalidation for Gen12 video and compute engines

Christian König <christian.koenig@amd.com>
    drm/amdgpu: always register an MMU notifier for userptr

Lyude Paul <lyude@redhat.com>
    drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN

Zhen Lei <thunder.leizhen@huawei.com>
    btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying subvol info to userspace

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying fspath to userspace

Josef Bacik <josef@toxicpanda.com>
    btrfs: free btrfs_path before copying root refs to userspace

Luiz Capitulino <luizcap@amazon.com>
    genirq: Take the proposed affinity at face value if force==true

Luiz Capitulino <luizcap@amazon.com>
    irqchip/gic-v3: Always trust the managed affinity provided by the core code

Luiz Capitulino <luizcap@amazon.com>
    genirq: Always limit the affinity to online CPUs

Luiz Capitulino <luizcap@amazon.com>
    genirq/msi: Shutdown managed interrupts with unsatifiable affinities

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate number of channels

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_OPER_CHANNEL attribute

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate pairwise and authentication suite offsets

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: clear the journal on suspend

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: flush the journal on suspend

Robin Murphy <robin.murphy@arm.com>
    gpu: host1x: Avoid trying to use GART on Tegra20

Enrico Sau <enrico.sau@gmail.com>
    net: usb: qmi_wwan: add Telit 0x103a composition

Gleb Mazovetskiy <glex.spb@gmail.com>
    tcp: configurable source port perturb table size

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp-wmi: Ignore Smart Experience App event

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: fix zone report size in __zonefs_io_error()

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()

ruanjinjie <ruanjinjie@huawei.com>
    xen/platform-pci: add missing free_irq() in error path

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    xen-pciback: Allow setting PCI_MSIX_FLAGS_MASKALL too

Hans de Goede <hdegoede@redhat.com>
    Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]

Hans de Goede <hdegoede@redhat.com>
    Input: soc_button_array - add use_low_level_irq module parameter

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - try resetting the controller when no config is set

Lukas Wunner <lukas@wunner.de>
    serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcht_es8316: Add quirk for the Nanote UMPC-01

Aman Dhoot <amandhoot12@gmail.com>
    Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode

Alessandro Astone <ales.astone@gmail.com>
    binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0

Alessandro Astone <ales.astone@gmail.com>
    binder: Address corner cases in deferred copy and fixup

Arnd Bergmann <arnd@arndb.de>
    binder: fix pointer cast warning

Todd Kjos <tkjos@google.com>
    binder: defer copies of pre-patched txn data

Todd Kjos <tkjos@google.com>
    binder: read pre-translated fds from sender buffer

Todd Kjos <tkjos@google.com>
    binder: avoid potential data leakage when copying txn

Michael Kelley <mikelley@microsoft.com>
    x86/ioremap: Fix page aligned size calculation in __ioremap_caller()

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: remove exit_int_info warning in svm_handle_exit

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: leave nested mode on vCPU free

Johannes Weiner <hannes@cmpxchg.org>
    mm: vmscan: fix extreme overreclaim and swap floods

Mukesh Ojha <quic_mojha@quicinc.com>
    gcov: clang: fix the buffer overflow issue

Chen Zhongjin <chenzhongjin@huawei.com>
    nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Clear ep descriptor last

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Return -ESHUTDOWN on ep disable

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: gadget: conditionally remove requests

Xiubo Li <xiubli@redhat.com>
    ceph: fix NULL pointer dereference for req->r_session

Kenneth Lee <klee33@uw.edu>
    ceph: Use kcalloc for allocating multiple elements

Xiubo Li <xiubli@redhat.com>
    ceph: fix possible NULL pointer dereference for req->r_session

Xiubo Li <xiubli@redhat.com>
    ceph: put the requests/sessions when it fails to alloc memory

Dan Carpenter <dan.carpenter@oracle.com>
    ceph: fix off by one bugs in unsafe_request_wait()

Xiubo Li <xiubli@redhat.com>
    ceph: flush the mdlog before waiting on unsafe reqs

Xiubo Li <xiubli@redhat.com>
    ceph: flush mdlog before umounting

Xiubo Li <xiubli@redhat.com>
    ceph: make iterate_sessions a global symbol

Xiubo Li <xiubli@redhat.com>
    ceph: make ceph_create_session_msg a global symbol

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Device side header file for CDNSP driver

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Add support for DRD CDNSP

Brian Norris <briannorris@chromium.org>
    mmc: sdhci-brcmstb: Fix SDHCI_RESET_ALL for CQHCI

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci-brcmstb: Enable Clock Gating to save power

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci-brcmstb: Re-organize flags

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: update the emulation mode after rsm

Randy Dunlap <rdunlap@infradead.org>
    nios2: add FORCE for vmlinuz.gz

Alexandre Belloni <alexandre.belloni@bootlin.com>
    init/Kconfig: fix CC_HAS_ASM_GOTO_TIED_OUTPUT test with dash

Chen Zhongjin <chenzhongjin@huawei.com>
    iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails

Alejandro Concepción Rodríguez <asconcepcion@acoro.eu>
    iio: light: apds9960: fix wrong register for gesture gain

Sam James <sam@gentoo.org>
    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible

Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
    arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_ext_shift_extents

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc3: exynos: Fix remove() function

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lib/vdso: use "grep -E" instead of "egrep"

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: preserve TX ring priority across reconfiguration

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: cache accesses to &priv->si->hw

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled

Heiko Carstens <hca@linux.ibm.com>
    s390/crashdump: fix TOD programmable field size

Yu Liao <liaoyu15@huawei.com>
    net: thunderx: Fix the ACPI memory leak

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix memory leaks in EVT_TRANSACTION

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION

Wang Hai <wanghai38@huawei.com>
    arcnet: fix potential memory leak in com20020_probe()

Ahmed S. Darwish <a.darwish@linutronix.de>
    net: arcnet: Fix RESET flag handling

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix no record found for raw_track_access

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv4: Fix error return code in fib_table_insert()

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp/tcp: Reset saddr on failure after inet6?_hash_connect().

Felix Fietkau <nbd@nbd.name>
    netfilter: flowtable_offload: add missing locking

Dawei Li <set_pte_at@outlook.com>
    dma-buf: fix racing conflict of dma_heap_add()

Yang Yingliang <yangyingliang@huawei.com>
    bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()

Andreas Kemnade <andreas@kemnade.info>
    regulator: twl6030: re-add TWL6032_SUBCLASS

Liu Shixin <liushixin2@huawei.com>
    NFC: nci: fix memory leak in nci_rx_data_packet()

Xin Long <lucien.xin@gmail.com>
    net: sched: allow act_ct to be built without NF_NAT

Zhang Changzhong <zhangchangzhong@huawei.com>
    sfc: fix potential memleak in __ef100_hard_start_xmit()

Chen Zhongjin <chenzhongjin@huawei.com>
    xfrm: Fix ignored return value in xfrm6_init()

YueHaibing <yuehaibing@huawei.com>
    tipc: check skb_linearize() return value in tipc_disc_rcv()

Xin Long <lucien.xin@gmail.com>
    tipc: add an extra conn_get in tipc_conn_alloc

Xin Long <lucien.xin@gmail.com>
    tipc: set con sock in tipc_conn_alloc

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix handling of entry refcount when command is not issued to FW

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix FW tracer timestamp calculation

Vishwanath Pai <vpai@akamai.com>
    netfilter: ipset: regression in ip_set_hash_ip.c

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Limit the maximal range of consecutive elements to add/delete

Yang Yingliang <yangyingliang@huawei.com>
    Drivers: hv: vmbus: fix possible memory leak in vmbus_device_register()

Yang Yingliang <yangyingliang@huawei.com>
    Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()

YueHaibing <yuehaibing@huawei.com>
    macsec: Fix invalid error code set

Jaco Coetzee <jaco.coetzee@corigine.com>
    nfp: add port from netdev validation for EEPROM access

Diana Wang <na.wang@corigine.com>
    nfp: fill splittable of devlink_port_attrs correctly

Yang Yingliang <yangyingliang@huawei.com>
    net: pch_gbe: fix pci device refcount leak while module exiting

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/qla3xxx: fix potential memleak in ql3xxx_send()

Peter Kosyh <pkosyh@yandex.ru>
    net/mlx4: Check retval of mlx4_bitmap_init

Liu Jian <liujian56@huawei.com>
    net: ethernet: mtk_eth_soc: fix error handling in mtk_open()

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx6q-prti6q: Fix ref/tcxo-clock-frequency properties

Zheng Yongjun <zhengyongjun3@huawei.com>
    ARM: mxs: fix memory leak in mxs_machine_init()

Daniel Xu <dxu@dxuuu.xyz>
    netfilter: conntrack: Fix data-races around ct mark

Zhengchao Shao <shaozhengchao@huawei.com>
    9p/fd: fix issue of list_del corruption in p9_fd_cancel()

Wang Hai <wanghai38@huawei.com>
    net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()

Lin Ma <linma@zju.edu.cn>
    nfc/nci: fix race with opening and closing

David Howells <dhowells@redhat.com>
    rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]

David Howells <dhowells@redhat.com>
    rxrpc: Use refcount_t rather than atomic_t

David Howells <dhowells@redhat.com>
    rxrpc: Allow list of in-use local UDP endpoints to be viewed in /proc

Leon Romanovsky <leon@kernel.org>
    net: liquidio: simplify if expression

Michael Grzeschik <m.grzeschik@pengutronix.de>
    ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl

Yang Yingliang <yangyingliang@huawei.com>
    tee: optee: fix possible memory leak in optee_register_device()

Samuel Holland <samuel@sholland.org>
    bus: sunxi-rsb: Support atomic transfers

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix UAF in destroy_regulator()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    spi: dw-dma: decrease reference count in dw_spi_dma_init_mfld()

Zeng Heng <zengheng4@huawei.com>
    regulator: core: fix kobject release warning and memory leak in regulator_register()

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix handling of srb_status and capacity change events

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: soc-pcm: Don't zero TDM masks in __soc_pcm_open()

Detlev Casanova <detlev.casanova@collabora.com>
    ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove

Junxiao Chang <junxiao.chang@intel.com>
    ASoC: hdac_hda: fix hda pcm buffer overflow issue

Dominik Haller <d.haller@phytec.de>
    ARM: dts: am335x-pcm-953: Define fixed regulators in root node

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Fix send_acquire race with pfkey_register

Christian Langrock <christian.langrock@secunet.com>
    xfrm: replay: Fix ESN wrap around for GSO

Eyal Birger <eyal.birger@gmail.com>
    xfrm: fix "disable_policy" on ipv4 early demux

Jason A. Donenfeld <Jason@zx2c4.com>
    MIPS: pic32: treat port as signed integer

Nathan Chancellor <nathan@kernel.org>
    RISC-V: vdso: Do not add missing symbols to version section in linker script

Kuniyuki Iwashima <kuniyu@amazon.com>
    arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix null pointer dereference in bfq_bio_bfqg()

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)

Bart Van Assche <bvanassche@acm.org>
    scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Avoid path failures during live migration

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the RCA Cambio W101 v2 2-in-1

Sabrina Dubroca <sd@queasysnail.net>
    Revert "net: macsec: report real_dev features when HW offloading is enabled"

Youlin Li <liulin063@gmail.com>
    selftests/bpf: Add verifier test for release_reference()

Sean Nyekjaer <sean@geanix.com>
    spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mac80211: Fix ack frame idr leak when mesh has no route

Jason A. Donenfeld <Jason@zx2c4.com>
    wifi: airo: do not assign -1 to unsigned char

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix undefined behavior in bit shift for AUDIT_BIT

Emil Renner Berthing <emil.renner.berthing@canonical.com>
    riscv: dts: sifive unleashed: Add PWM controlled LEDs

Jonas Jelonek <jelonek.jonas@gmail.com>
    wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

taozhang <taozhang@bestechnic.com>
    wifi: mac80211: fix memory free error when registering wiphy fail

Xiubo Li <xiubli@redhat.com>
    ceph: avoid putting the realm twice when decoding snaps fails

Xiubo Li <xiubli@redhat.com>
    ceph: do not update snapshot context when there is no new snapshot

Mitja Spes <mitja@lxnav.com>
    iio: pressure: ms5611: fixed value compensation bug

Lars-Peter Clausen <lars@metafoo.de>
    iio: ms5611: Simplify IO callback parameters

Đoàn Trần Công Danh <congdanhqx@gmail.com>
    speakup: replace utils' u_char with unsigned char

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Generate speakupmap.h automatically

Bean Huo <beanhuo@micron.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro

Leo Savernik <l.savernik@aon.at>
    nvme: add a bogus subsystem NQN quirk for Micron MTFDKBA2T0TFH

Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>
    drm/display: Don't assume dual mode adaptors support i2c sub-addressing

Ido Schimmel <idosch@nvidia.com>
    bridge: switchdev: Fix memory leaks when changing VLAN protocol

Danielle Ratson <danieller@nvidia.com>
    bridge: switchdev: Notify about VLAN protocol changes

Niklas Cassel <niklas.cassel@wdc.com>
    ata: libata-core: do not issue non-internal commands once EH is pending

Wenchao Hao <haowenchao@huawei.com>
    ata: libata-scsi: simplify __ata_scsi_queuecmd()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: scsi_transport_sas: Fix error handling in sas_phy_add()


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arm/boot/dts/am335x-pcm-953.dtsi              |   28 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |    9 +
 arch/arm/boot/dts/imx6q-prti6q.dts                 |    4 +-
 arch/arm/mach-mxs/mach-mxs.c                       |    4 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |    2 +-
 arch/arm64/include/asm/syscall_wrapper.h           |    2 +-
 arch/mips/include/asm/fw/fw.h                      |    2 +-
 arch/mips/pic32/pic32mzda/early_console.c          |   13 +-
 arch/mips/pic32/pic32mzda/init.c                   |    2 +-
 arch/nios2/boot/Makefile                           |    2 +-
 .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |   38 +
 arch/riscv/kernel/vdso/Makefile                    |    3 +
 arch/riscv/kernel/vdso/vdso.lds.S                  |    2 +
 arch/s390/kernel/crash_dump.c                      |    2 +-
 arch/x86/kvm/emulate.c                             |    9 +
 arch/x86/kvm/svm/svm.c                             |   16 +-
 arch/x86/mm/ioremap.c                              |    8 +-
 block/bfq-cgroup.c                                 |    4 +
 drivers/accessibility/speakup/.gitignore           |    4 +
 drivers/accessibility/speakup/Makefile             |   28 +
 drivers/accessibility/speakup/genmap.c             |  162 +++
 drivers/accessibility/speakup/makemapdata.c        |  125 ++
 drivers/accessibility/speakup/speakupmap.h         |   66 -
 drivers/accessibility/speakup/utils.h              |  102 ++
 drivers/android/binder.c                           |  437 +++++-
 drivers/ata/libata-scsi.c                          |   55 +-
 drivers/bus/sunxi-rsb.c                            |   29 +-
 drivers/dma-buf/dma-heap.c                         |   28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |    8 +-
 .../drm/amd/display/dc/dce120/dce120_resource.c    |    3 +-
 drivers/gpu/drm/drm_dp_dual_mode_helper.c          |   51 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |    6 +
 drivers/gpu/drm/i915/gt/intel_gt.c                 |    4 +
 drivers/gpu/drm/tegra/drm.c                        |    4 +
 drivers/gpu/host1x/dev.c                           |    4 +
 drivers/hv/channel_mgmt.c                          |    6 +-
 drivers/hv/vmbus_drv.c                             |    1 +
 drivers/iio/industrialio-sw-trigger.c              |    6 +-
 drivers/iio/light/apds9960.c                       |   12 +-
 drivers/iio/pressure/ms5611.h                      |   18 +-
 drivers/iio/pressure/ms5611_core.c                 |   56 +-
 drivers/iio/pressure/ms5611_i2c.c                  |   11 +-
 drivers/iio/pressure/ms5611_spi.c                  |   17 +-
 drivers/input/misc/soc_button_array.c              |   14 +-
 drivers/input/mouse/synaptics.c                    |    1 +
 drivers/input/touchscreen/goodix.c                 |   11 +
 drivers/irqchip/irq-gic-v3-its.c                   |    2 +-
 drivers/md/dm-integrity.c                          |   20 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |   68 +-
 drivers/net/arcnet/arc-rimi.c                      |    4 +-
 drivers/net/arcnet/arcdevice.h                     |    6 +
 drivers/net/arcnet/arcnet.c                        |   66 +-
 drivers/net/arcnet/com20020-isa.c                  |    4 +-
 drivers/net/arcnet/com20020-pci.c                  |    2 +-
 drivers/net/arcnet/com20020_cs.c                   |   13 +-
 drivers/net/arcnet/com90io.c                       |    4 +-
 drivers/net/arcnet/com90xx.c                       |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   12 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |    4 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |    4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   32 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   10 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |    6 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   83 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |    3 +
 drivers/net/ethernet/mellanox/mlx4/qp.c            |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    6 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |    2 +-
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |    2 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |    3 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |    1 +
 drivers/net/ethernet/sfc/ef100_netdev.c            |    1 +
 drivers/net/macsec.c                               |   28 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/wireless/cisco/airo.c                  |   18 +-
 drivers/net/wireless/mac80211_hwsim.c              |    5 +
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   40 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   21 +-
 drivers/nfc/st-nci/se.c                            |    6 +-
 drivers/nvme/host/pci.c                            |    4 +
 drivers/platform/x86/acer-wmi.c                    |    9 +
 drivers/platform/x86/asus-wmi.c                    |    2 +
 drivers/platform/x86/hp-wmi.c                      |    3 +
 drivers/platform/x86/touchscreen_dmi.c             |   25 +
 drivers/regulator/core.c                           |    8 +-
 drivers/regulator/twl6030-regulator.c              |    2 +
 drivers/s390/block/dasd_eckd.c                     |    6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   14 +-
 drivers/scsi/scsi_debug.c                          |    7 +
 drivers/scsi/scsi_transport_sas.c                  |   13 +-
 drivers/scsi/storvsc_drv.c                         |   69 +-
 drivers/spi/spi-dw-dma.c                           |    3 +
 drivers/spi/spi-stm32.c                            |    2 +-
 drivers/tee/optee/device.c                         |    2 +-
 drivers/tty/serial/8250/8250_omap.c                |    7 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   | 1463 ++++++++++++++++++++
 drivers/usb/cdns3/core.c                           |   24 +-
 drivers/usb/cdns3/core.h                           |    5 +
 drivers/usb/cdns3/drd.c                            |  101 +-
 drivers/usb/cdns3/drd.h                            |   67 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |   11 +-
 drivers/usb/dwc3/gadget.c                          |   22 +-
 drivers/xen/platform-pci.c                         |    7 +-
 drivers/xen/xen-pciback/conf_space_capability.c    |    9 +-
 fs/btrfs/ioctl.c                                   |    7 +-
 fs/btrfs/sysfs.c                                   |    7 +-
 fs/ceph/caps.c                                     |  105 +-
 fs/ceph/mds_client.c                               |   90 +-
 fs/ceph/mds_client.h                               |    5 +
 fs/ceph/snap.c                                     |   31 +-
 fs/ceph/strings.c                                  |    1 +
 fs/ext4/extents.c                                  |   18 +-
 fs/nilfs2/sufile.c                                 |    8 +
 fs/zonefs/super.c                                  |   37 +-
 include/linux/ceph/ceph_fs.h                       |    1 +
 include/linux/license.h                            |    2 +
 include/linux/netfilter/ipset/ip_set.h             |    3 +
 include/net/switchdev.h                            |    2 +
 include/trace/events/rxrpc.h                       |    2 +-
 include/uapi/linux/audit.h                         |    2 +-
 init/Kconfig                                       |    2 +-
 kernel/gcov/clang.c                                |    2 +
 kernel/irq/manage.c                                |   31 +-
 kernel/irq/msi.c                                   |    7 +
 lib/vdso/Makefile                                  |    2 +-
 mm/vmscan.c                                        |   10 +-
 net/9p/trans_fd.c                                  |    2 +
 net/bridge/br_vlan.c                               |   33 +-
 net/core/flow_dissector.c                          |    2 +-
 net/dccp/ipv4.c                                    |    2 +
 net/dccp/ipv6.c                                    |    2 +
 net/ipv4/Kconfig                                   |   10 +
 net/ipv4/esp4_offload.c                            |    3 +
 net/ipv4/fib_trie.c                                |    4 +-
 net/ipv4/inet_hashtables.c                         |   10 +-
 net/ipv4/ip_input.c                                |    5 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    4 +-
 net/ipv4/tcp_ipv4.c                                |    2 +
 net/ipv6/esp6_offload.c                            |    3 +
 net/ipv6/tcp_ipv6.c                                |    2 +
 net/ipv6/xfrm6_policy.c                            |    6 +-
 net/key/af_key.c                                   |   32 +-
 net/mac80211/main.c                                |    8 +-
 net/mac80211/mesh_pathtbl.c                        |    2 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |   17 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c           |   10 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |    3 +
 net/netfilter/ipset/ip_set_hash_ipportip.c         |    3 +
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |    3 +
 net/netfilter/ipset/ip_set_hash_net.c              |   11 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |   10 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |   16 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |   11 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c       |   16 +-
 net/netfilter/nf_conntrack_core.c                  |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |   24 +-
 net/netfilter/nf_conntrack_standalone.c            |    2 +-
 net/netfilter/nf_flow_table_offload.c              |    4 +
 net/netfilter/nft_ct.c                             |    6 +-
 net/netfilter/xt_connmark.c                        |   18 +-
 net/nfc/nci/core.c                                 |    2 +-
 net/nfc/nci/data.c                                 |    4 +-
 net/openvswitch/conntrack.c                        |    8 +-
 net/rxrpc/af_rxrpc.c                               |    2 +-
 net/rxrpc/ar-internal.h                            |   24 +-
 net/rxrpc/call_accept.c                            |    4 +-
 net/rxrpc/call_object.c                            |   44 +-
 net/rxrpc/conn_client.c                            |   66 +-
 net/rxrpc/conn_object.c                            |   49 +-
 net/rxrpc/conn_service.c                           |    8 +-
 net/rxrpc/input.c                                  |    4 +-
 net/rxrpc/local_object.c                           |   68 +-
 net/rxrpc/net_ns.c                                 |    5 +-
 net/rxrpc/peer_object.c                            |   40 +-
 net/rxrpc/proc.c                                   |   75 +-
 net/rxrpc/skbuff.c                                 |    1 -
 net/sched/Kconfig                                  |    2 +-
 net/sched/act_connmark.c                           |    4 +-
 net/sched/act_ct.c                                 |    8 +-
 net/sched/act_ctinfo.c                             |    6 +-
 net/tipc/discover.c                                |    5 +-
 net/tipc/topsrv.c                                  |   20 +-
 net/xfrm/xfrm_device.c                             |   15 +-
 net/xfrm/xfrm_replay.c                             |    2 +-
 sound/soc/codecs/hdac_hda.h                        |    4 +-
 sound/soc/codecs/sgtl5000.c                        |    1 +
 sound/soc/intel/boards/bytcht_es8316.c             |    7 +
 sound/soc/soc-pcm.c                                |    5 -
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   36 +
 191 files changed, 4038 insertions(+), 942 deletions(-)


