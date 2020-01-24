Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7782D147AB1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgAXJhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:37:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgAXJhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:37:08 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825742087E;
        Fri, 24 Jan 2020 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858625;
        bh=/ArB9g2p8ISuRY6rtImhVatA8/48V41YTkNjJjqzaD4=;
        h=From:To:Cc:Subject:Date:From;
        b=qwcolyhCIvp6EAWExJ3Y0+kr/2QNg9kLPgBvXuz3eVMdWhPigiAXYqmQwXQ3ap8XL
         iR/po+tR8f1m1ibUaX0sHLZXWvVNtprzXeasC/mI2VDBUaC/dsxyl5sz3ra8nAP4mg
         MJNMxLPuHQJHUXbLDuMCOhoHWRy2VrFKgdfzgpnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/343] 4.14.168-stable review
Date:   Fri, 24 Jan 2020 10:26:58 +0100
Message-Id: <20200124092919.490687572@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.168-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.168-rc1
X-KernelTest-Deadline: 2020-01-26T09:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.168 release.
There are 343 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Jan 2020 09:26:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.168-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.168-rc1

Finn Thain <fthain@telegraphics.com.au>
    m68k: Call timer_interrupt() with interrupts disabled

Fabrice Gasnier <fabrice.gasnier@st.com>
    serial: stm32: fix clearing interrupt error flags

Max Gurtovoy <maxg@mellanox.com>
    IB/iser: Fix dma_nents type definition

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: juno: Fix UART frequency

Sam Bobroff <sbobroff@linux.ibm.com>
    drm/radeon: fix bad DMA from INTERRUPT_CNTL2

Chuhong Yuan <hslester96@gmail.com>
    dmaengine: ti: edma: fix missed failure handling

Navid Emamdoost <navid.emamdoost@gmail.com>
    affs: fix a memory leak in affs_remount

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: core: fix wl1251 sdio quirks

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: sdio: fix wl1251 vendor id

Eric Dumazet <edumazet@google.com>
    packet: fix data-race in fanout_flow_is_huge()

Eric Dumazet <edumazet@google.com>
    net: neigh: use long type to store jiffies delta

Stephen Hemminger <sthemmin@microsoft.com>
    hv_netvsc: flag software created hash value

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Fix return value of loongson_hwmon_init

Marc Dionne <marc.dionne@auristor.com>
    afs: Fix large file support

Stefan Wahren <stefan.wahren@in-tech.com>
    net: qca_spi: Move reset_count to struct qcaspi

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: correct the parent's backlog when corrupted packet was dropped

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: fix error path for corrupted GSO frames

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: fix size check for sdma script_number

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    drm/msm/dsi: Implement reset correctly

Eric Dumazet <edumazet@google.com>
    tcp: annotate lockless access to tcp_memory_pressure

Eric Dumazet <edumazet@google.com>
    net: add {READ|WRITE}_ONCE() annotations on ->rskq_accept_head

Eric Dumazet <edumazet@google.com>
    net: avoid possible false sharing in sk_leave_memory_pressure()

YueHaibing <yuehaibing@huawei.com>
    act_mirred: Fix mirred_init_module error handling

Antonio Borneo <antonio.borneo@st.com>
    net: stmmac: fix length of PTP clock's name string

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Biggers <ebiggers@google.com>
    llc: fix another potential sk_buff leak in llc_ui_sendmsg()

Johannes Berg <johannes.berg@intel.com>
    mac80211: accept deauth frames in IBSS mode

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: gmac4+: Not all Unicast addresses may be available

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    nvme: retain split access workaround for capability reads

Dan Carpenter <dan.carpenter@oracle.com>
    net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()

Dan Carpenter <dan.carpenter@oracle.com>
    of: mdio: Fix a signedness bug in of_phy_get_and_connect()

Dan Carpenter <dan.carpenter@oracle.com>
    net: axienet: fix a signedness bug in probe

Dan Carpenter <dan.carpenter@oracle.com>
    net: stmmac: dwmac-meson8b: Fix signedness bug in probe

Dan Carpenter <dan.carpenter@oracle.com>
    net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    net: aquantia: Fix aq_vec_isr_legacy() return value

Filippo Sironi <sironi@amazon.de>
    iommu/amd: Wait for completion of IOTLB flush in attach_device

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Fix false error message

Nicolas Boichat <drinkcat@chromium.org>
    ath10k: adjust skb length in ath10k_sdio_mbox_rx_packet

Li Jin <li.jin@broadcom.com>
    pinctrl: iproc-gpio: Fix incorrect pinconf configurations

Mao Wenan <maowenan@huawei.com>
    net: sonic: replace dev_kfree_skb in sonic_send_packet

Dan Robertson <dan@dlrobertson.com>
    hwmon: (shtc1) fix shtc1 and shtw1 id mask

Firo Yang <firo.yang@suse.com>
    ixgbe: sync the first fragment unconditionally

Omar Sandoval <osandov@fb.com>
    btrfs: use correct count in btrfs_file_write_iter()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix inode cache waiters hanging on path allocation failure

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix inode cache waiters hanging on failure to start caching thread

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix hang when loading existing inode cache off disk

Govindarajulu Varadarajan <gvaradar@cisco.com>
    scsi: fnic: fix msix interrupt allocation

Mao Wenan <maowenan@huawei.com>
    net: sonic: return NETDEV_TX_OK if failed to map buffer

Andrey Smirnov <andrew.smirnov@gmail.com>
    tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs

Lorenzo Bianconi <lorenzo@kernel.org>
    ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init

Colin Ian King <colin.king@canonical.com>
    iio: dac: ad5380: fix incorrect assignment to val

Colin Ian King <colin.king@canonical.com>
    bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA

Dexuan Cui <decui@microsoft.com>
    irqdomain: Add the missing assignment of domain->fwnode for named fwnode

Dan Carpenter <dan.carpenter@oracle.com>
    staging: greybus: light: fix a couple double frees

Masami Hiramatsu <mhiramat@kernel.org>
    x86, perf: Fix the dependency of the x86 insn decoder selftest

Stephen Boyd <swboyd@chromium.org>
    power: supply: Init device wakeup after device_add()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm75) Fix write operations for negative temperatures

Linus Torvalds <torvalds@linux-foundation.org>
    Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ahci: Do not export local variable ahci_em_messages

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Fix iova_to_phys PA start for 4GB mode

Nick Desaulniers <ndesaulniers@google.com>
    mips: avoid explicit UB in assignment of mips_io_port_base

Bruno Thomsen <bruno.thomsen@gmail.com>
    rtc: pcf2127: bugfix: read rtc disables watchdog

Alexandre Kroupski <alexandre.kroupski@ingenico.com>
    media: atmel: atmel-isi: fix timeout value for stop streaming

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel_ht: fix per-group max throughput rate initialization

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: platform: Switch to acpi_dma_controller_register()

Maxime Ripard <maxime.ripard@bootlin.com>
    ASoC: sun4i-i2s: RX and TX counter registers are swapped

Eric W. Biederman <ebiederm@xmission.com>
    signal: Allow cifs and drbd to receive their terminating signals

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: Add a few missing rds_stat_names entries

YueHaibing <yuehaibing@huawei.com>
    ASoC: wm8737: Fix copy-paste error in wm8737_snd_controls

YueHaibing <yuehaibing@huawei.com>
    ASoC: cs4349: Use PM ops 'cs4349_runtime_pm'

YueHaibing <yuehaibing@huawei.com>
    ASoC: es8328: Fix copy-paste error in es8328_right_line_controls

Colin Ian King <colin.king@canonical.com>
    ext4: set error return correctly when ext4_htree_store_dirent fails

Iuliana Prodan <iuliana.prodan@nxp.com>
    crypto: caam - free resources in case caam_rng registration failed

Steve French <stfrench@microsoft.com>
    cifs: fix rmmod regression in cifs.ko caused by force_sig changes

Mark Zhang <markz@mellanox.com>
    net/mlx5: Fix mlx5_ifc_query_lag_out_bits

Fabrice Gasnier <fabrice.gasnier@st.com>
    ARM: dts: stm32: add missing vdda-supply to adc on stm32h743i-eval

Jon Maloy <jon.maloy@ericsson.com>
    tipc: reduce risk of wakeup queue starvation

Johannes Berg <johannes@sipsolutions.net>
    ALSA: aoa: onyx: always initialize register read value

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp - Reduce maximum stack usage

Thomas Gleixner <tglx@linutronix.de>
    x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI

Arnd Bergmann <arnd@arndb.de>
    mic: avoid statically declaring a 'struct device'.

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: host: xhci-hub: fix extra endianness conversion

Arnd Bergmann <arnd@arndb.de>
    qed: reduce maximum stack frame size

YueHaibing <yuehaibing@huawei.com>
    libertas_tf: Use correct channel range in lbtf_geo_init

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Fix possible overflow in pm_system_cancel_wakeup()

Icenowy Zheng <icenowy@aosc.io>
    clk: sunxi-ng: v3s: add the missing PLL_DDR1

Colin Ian King <colin.king@canonical.com>
    scsi: libfc: fix null pointer dereference on a null lport

Wen Yang <wen.yang99@zte.com.cn>
    net: pasemi: fix an use-after-free in pasemi_mac_phy_init()

Xi Wang <wangxi11@huawei.com>
    RDMA/hns: Fixs hw access invalid dma memory error

Arnd Bergmann <arnd@arndb.de>
    devres: allow const resource arguments

David Howells <dhowells@redhat.com>
    rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Release IDA resources

Kevin Mitchell <kevmitch@arista.com>
    iommu/amd: Make iommu_disable safer

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ethtool selftest crash under error conditions.

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    nvmem: imx-ocotp: Ensure WAIT bits are preserved when setting timing

Nathan Huckleberry <nhuck@google.com>
    clk: qcom: Fix -Wunused-const-variable

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: hsu: Revert "set HSU_CH_MTSR to memory width"

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    perf/ioctl: Add check for the sample_period value

Rob Clark <robdclark@chromium.org>
    drm/msm/a3xx: remove TPL1 regs from snapshot

Chen-Yu Tsai <wens@csie.org>
    rtc: pcf8563: Clear event flags and disable interrupts before requesting irq

Chen-Yu Tsai <wens@csie.org>
    rtc: pcf8563: Fix interrupt trigger method

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple AXRs

Julian Wiedmann <jwi@linux.ibm.com>
    net/af_iucv: always register net_device notifier

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: fix backlog accounting for corrupted GSO frames

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    drm/msm/mdp5: Fix mdp5_cfg_init error return

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild

Michal Kalderon <michal.kalderon@marvell.com>
    qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state

Eric Auger <eric.auger@redhat.com>
    iommu/vt-d: Duplicate iommu_resv_region objects per device list

George Wilkie <gwilkie@vyatta.att-mail.com>
    mpls: fix warning with multi-label encap

Colin Ian King <colin.king@canonical.com>
    media: vivid: fix incorrect assignment operation when setting video mode

Florian Fainelli <f.fainelli@gmail.com>
    cpufreq: brcmstb-avs-cpufreq: Fix types for voltage/frequency

Florian Fainelli <f.fainelli@gmail.com>
    cpufreq: brcmstb-avs-cpufreq: Fix initial command check

Stephen Hemminger <stephen@networkplumber.org>
    netvsc: unshare skb in VF rx handler

Eric Dumazet <edumazet@google.com>
    inet: frags: call inet_frags_fini() after unregister_pernet_subsys()

Eric W. Biederman <ebiederm@xmission.com>
    signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Use right function to get group for device

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Avoid possible suspend-to-idle issue

Nathan Chancellor <natechancellor@gmail.com>
    misc: sgi-xp: Properly initialize buf in xpc_get_rsvd_page_pa

Erwan Le Ray <erwan.leray@st.com>
    serial: stm32: fix wakeup source initialization

Erwan Le Ray <erwan.leray@st.com>
    serial: stm32: Add support of TC bit status check

Erwan Le Ray <erwan.leray@st.com>
    serial: stm32: fix transmit_chars when tx is stopped

Erwan Le Ray <erwan.leray@st.com>
    serial: stm32: fix rx error handling

Hook, Gary <Gary.Hook@amd.com>
    crypto: ccp - Fix 3DES complaint from ccp-crypto module

Hook, Gary <Gary.Hook@amd.com>
    crypto: ccp - fix AES CFB error exposed by new test vectors

Christophe Leroy <christophe.leroy@c-s.fr>
    spi: spi-fsl-spi: call spi_finalize_current_message() at the end

Sagiv Ozeri <sagiv.ozeri@marvell.com>
    RDMA/qedr: Fix incorrect device rate.

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson: libretech-cc: set eMMC as removable

Jon Hunter <jonathanh@nvidia.com>
    dmaengine: tegra210-adma: Fix crash during probe

Jernej Skrabec <jernej.skrabec@siol.net>
    ARM: dts: sun8i-h3: Fix wifi in Beelink X2 DT

Robert Richter <rrichter@marvell.com>
    EDAC/mc: Fix edac_mc_find() in case no device is found

Matthias Kaehlcke <mka@chromium.org>
    thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_get_power

Brian Masney <masneyb@onstation.org>
    backlight: lm3630a: Return 0 on success in update_status functions

Dan Carpenter <dan.carpenter@oracle.com>
    kdb: do a sanity check on the cpu in kdb_per_cpu()

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: riscpc: fix lack of keyboard interrupts after irq conversion

Bichao Zheng <bichao.zheng@amlogic.com>
    pwm: meson: Don't disable PWM when setting duty repeatedly

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pwm: meson: Consider 128 a valid pre-divider

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: CONFIG_COMPAT: reject trailing data after last rule

Iuliana Prodan <iuliana.prodan@nxp.com>
    crypto: caam - fix caam_dump_sg that iterates through scatterlist

Dan Carpenter <dan.carpenter@oracle.com>
    platform/x86: alienware-wmi: printing the wrong error code

Dan Carpenter <dan.carpenter@oracle.com>
    media: davinci/vpbe: array underflow in vpbe_enum_outputs()

Dan Carpenter <dan.carpenter@oracle.com>
    media: omap_vout: potential buffer overflow in vidioc_dqbuf()

YueHaibing <yuehaibing@huawei.com>
    l2tp: Fix possible NULL pointer dereference

Parav Pandit <parav@mellanox.com>
    vfio/mdev: Fix aborting mdev child device removal if one fails

Parav Pandit <parav@mellanox.com>
    vfio/mdev: Avoid release parent reference during error path

David Howells <dhowells@redhat.com>
    afs: Fix the afs.cell and afs.volume xattr handlers

Igor Konopko <igor.j.konopko@intel.com>
    lightnvm: pblk: fix lock order in pblk_rb_tear_down_check

Pan Bian <bianpan2016@163.com>
    mmc: core: fix possible use after free of host

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-adma: restore channel status

Sameeh Jubran <sameehj@amazon.com>
    net: ena: fix ena_com_fill_hash_function() implementation

Sameeh Jubran <sameehj@amazon.com>
    net: ena: fix incorrect test of supported hash function

Sameeh Jubran <sameehj@amazon.com>
    net: ena: fix: Free napi resources when ena_up() fails

Sameeh Jubran <sameehj@amazon.com>
    net: ena: fix swapped parameters when calling ena_com_indirect_table_fill_entry

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Make kernel parameter igfx_off work with vIOMMU

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx5: Add missing XRC options to QP optional params mask

Minas Harutyunyan <minas.harutyunyan@synopsys.com>
    dwc2: gadget: Fix completed transfer size calculation in DDMA

Arnd Bergmann <arnd@arndb.de>
    usb: gadget: fsl: fix link error against usb-gadget module

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: fix valid stream condition

Willem de Bruijn <willemb@google.com>
    packet: in recvmsg msg_name return at least sizeof sockaddr_ll

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix a format specifier

Hongbo Yao <yaohongbo@huawei.com>
    irqchip/gic-v3-its: fix some definitions of inner cacheability attributes

Trond Myklebust <trondmy@gmail.com>
    NFS: Don't interrupt file writeout due to fatal errors

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Handle the error from snd_usb_mixer_apply_create_quirk()

Alexandru Ardelean <alexandru.ardelean@analog.com>
    dmaengine: axi-dmac: Don't check the number of frames for alignment

Dan Carpenter <dan.carpenter@oracle.com>
    6lowpan: Off by one handling ->nexthdr

Akinobu Mita <akinobu.mita@gmail.com>
    media: ov2659: fix unbalanced mutex_lock/unlock

Vladimir Oltean <olteanv@gmail.com>
    ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect

Ben Hutchings <ben@decadent.org.uk>
    powerpc: vdso: Make vdso32 installation conditional in vdso_install

Kees Cook <keescook@chromium.org>
    selftests/ipc: Fix msgque compiler warnings

Jie Liu <liujie165@huawei.com>
    tipc: set sysctl_tipc_rmem and named_timeout right range

Colin Ian King <colin.king@canonical.com>
    platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer

Guenter Roeck <linux@roeck-us.net>
    hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for vport->bw_limit overflow problem

YueHaibing <yuehaibing@huawei.com>
    ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"

Bart Van Assche <bvanassche@acm.org>
    scsi: target/core: Fix a race condition in the LUN lookup code

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Unregister chrdev if module initialization fails

YueHaibing <yuehaibing@huawei.com>
    ehea: Fix a copy-paste err in ehea_init_port_res

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: fix driver to not allow 65535 (=-1) cs-gpios

Dan Carpenter <dan.carpenter@oracle.com>
    soc/fsl/qe: Fix an error code in qe_pin_request()

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: configure dma burst size to fifo trig level

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: flush fifos

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: terminate dma and reset on transfer timeout

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: fix for unpacked mode transfers

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: clear packed bit for unpacked mode

YueHaibing <yuehaibing@huawei.com>
    media: tw5864: Fix possible NULL pointer dereference in tw5864_handle_frame

Arnd Bergmann <arnd@arndb.de>
    media: davinci-isif: avoid uninitialized variable use

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix potentially uninitialized return value for _setup_reset()

Maxime Ripard <maxime.ripard@bootlin.com>
    arm64: dts: allwinner: a64: Add missing PIO clocks

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Fix VIA timer counter accesses

Jon Maloy <jon.maloy@ericsson.com>
    tipc: tipc clang warning

Arnd Bergmann <arnd@arndb.de>
    jfs: fix bogus variable self-initialization

Axel Lin <axel.lin@ingics.com>
    regulator: tps65086: Fix tps65086_ldoa1_ranges for selector 0xB

Nicholas Mc Guire <hofrat@osadl.org>
    media: cx23885: check allocation return

Dan Carpenter <dan.carpenter@oracle.com>
    media: wl128x: Fix an error code in fm_download_firmware()

Dan Carpenter <dan.carpenter@oracle.com>
    media: cx18: update *pos correctly in cx18_read_pos()

Dan Carpenter <dan.carpenter@oracle.com>
    media: ivtv: update *pos correctly in ivtv_read_pos()

Axel Lin <axel.lin@ingics.com>
    regulator: lp87565: Fix missing register for LP87565_BUCK_0

Kangjie Lu <kjlu@umn.edu>
    net: sh_eth: fix a missing check of of_get_phy_mode

Dan Carpenter <dan.carpenter@oracle.com>
    xen, cpu_hotplug: Prevent an out of bounds access

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/rapidio/rio_cm.c: fix potential oops in riocm_ch_listen()

Steve Sistare <steven.sistare@oracle.com>
    scsi: megaraid_sas: reduce module load time

Qian Cai <cai@lca.pw>
    x86/mm: Remove unused variable 'cpu'

Guenter Roeck <linux@roeck-us.net>
    nios2: ksyms: Add missing symbol exports

Rashmica Gupta <rashmica.g@gmail.com>
    powerpc/mm: Check secondary hash page table

Igor Russkikh <Igor.Russkikh@aquantia.com>
    net: aquantia: fixed instack structure overflow

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix invalid deref in FF_LAYOUT_DEVID_NODE()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: fix lookups with fixed size hash on big endian

Axel Lin <axel.lin@ingics.com>
    regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8848/1: virt: Align GIC version check with arm64 counterpart

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used

Stefan Wahren <stefan.wahren@i2se.com>
    mmc: sdhci-brcmstb: handle mmc_of_parse() errors during probe

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/pnfs: Bulk destroy of layouts needs to be safe w.r.t. umount

Mattias Jacobsson <2pi@mok.nu>
    platform/x86: wmi: fix potential null pointer dereference

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/exynos_mct: Fix error path in timer resources initialization

Chen-Yu Tsai <wens@csie.org>
    clocksource/drivers/sun5i: Fail gracefully when clock rate is unavailable

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a soft lockup in the delegation recovery code

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Fix logic when handling unknown CPU features

Nathan Chancellor <natechancellor@gmail.com>
    staging: rtlwifi: Use proper enum for return in halmac_parse_psd_data_88xx

Eric W. Biederman <ebiederm@xmission.com>
    fs/nfs: Fix nfs_parse_devname to not modify it's argument

Takashi Iwai <tiwai@suse.de>
    ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()

Colin Ian King <colin.king@canonical.com>
    drm/nouveau/pmu: don't print reply values if exec is false

Colin Ian King <colin.king@canonical.com>
    drm/nouveau/bios/ramcfg: fix missing parentheses when calculating RON

Vinod Koul <vkoul@kernel.org>
    net: dsa: qca8k: Enable delay for RGMII_ID mode

Axel Lin <axel.lin@ingics.com>
    regulator: pv88090: Fix array out-of-bounds access

Axel Lin <axel.lin@ingics.com>
    regulator: pv88080: Fix array out-of-bounds access

Axel Lin <axel.lin@ingics.com>
    regulator: pv88060: Fix array out-of-bounds access

YueHaibing <yuehaibing@huawei.com>
    cdc-wdm: pass return value of recover_from_urb_loss

Robin Murphy <robin.murphy@arm.com>
    dmaengine: mv_xor: Use correct device for DMA API

Nicholas Mc Guire <hofrat@osadl.org>
    staging: r8822be: check kzalloc return or bail

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Release all hardware TCE tables attached to a group

Vadim Pasternak <vadimp@mellanox.com>
    hwmon: (pmbus/tps53679) Fix driver info initialization in probe routine

Eric Auger <eric.auger@redhat.com>
    vfio_pci: Enable memory accesses before calling pci_map_rom

David Howells <dhowells@redhat.com>
    keys: Timestamp new keys

Ming Lei <ming.lei@redhat.com>
    block: don't use bio->bi_vcnt to figure out segment number

Sven Van Asbroeck <thesven73@gmail.com>
    usb: phy: twl6030-usb: fix possible use-after-free on remove

Wen Yang <wen.yang99@zte.com.cn>
    PCI: endpoint: functions: Use memcpy_fromio()/memcpy_toio()

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: emev2: Add missing pinmux functions

Dan Carpenter <dan.carpenter@oracle.com>
    drm/etnaviv: potential NULL dereference

Steve Wise <swise@opengridcomputing.com>
    iw_cxgb4: use tos when finding ipv6 routes

Steve Wise <swise@opengridcomputing.com>
    iw_cxgb4: use tos when importing the endpoint

YueHaibing <yuehaibing@huawei.com>
    fbdev: chipsfb: remove set but not used variable 'size'

Colin Ian King <colin.king@canonical.com>
    rtc: pm8xxx: fix unintended sign extension

Colin Ian King <colin.king@canonical.com>
    rtc: 88pm80x: fix unintended sign extension

Colin Ian King <colin.king@canonical.com>
    rtc: 88pm860x: fix unintended sign extension

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    rtc: ds1307: rx8130: Fix alarm handling

Moritz Fischer <mdf@kernel.org>
    net: phy: fixed_phy: Fix fixed_phy not checking GPIO

Michael Kao <michael.kao@mediatek.com>
    thermal: mediatek: fix register index error

Colin Ian King <colin.king@canonical.com>
    rtc: ds1672: fix unintended sign extension

Colin Ian King <colin.king@canonical.com>
    staging: most: cdev: add missing check for cdev_add failure

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: fix RSS config command

Vladimir Zapolskiy <vz@mleia.com>
    ARM: dts: lpc32xx: phy3250: fix SD card regulator voltage

Vladimir Zapolskiy <vz@mleia.com>
    ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller clocks property

Vladimir Zapolskiy <vz@mleia.com>
    ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller variant

Vladimir Zapolskiy <vz@mleia.com>
    ARM: dts: lpc32xx: reparent keypad controller to SIC1

Vladimir Zapolskiy <vz@mleia.com>
    ARM: dts: lpc32xx: add required clocks property to keypad device node

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Do not resume suppliers under device_links_write_lock()

Corentin Labbe <clabbe@baylibre.com>
    crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove() arguments

Liu Jian <liujian56@huawei.com>
    driver: uio: fix possible use-after-free in __uio_register_device

Liu Jian <liujian56@huawei.com>
    driver: uio: fix possible memory leak in __uio_register_device

YueHaibing <yuehaibing@huawei.com>
    tty: ipwireless: Fix potential NULL pointer dereference

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix A-MPDU reference assignment

Moni Shoua <monis@mellanox.com>
    net/mlx5: Take lock with IRQs disabled to avoid deadlock

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: avoid possible access out of array.

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: sun8i-a23: Enable PLL-MIPI LDOs when ungating it

YueHaibing <yuehaibing@huawei.com>
    spi/topcliff_pch: Fix potential NULL dereference on allocation error

Eric Wong <e@80x24.org>
    rtc: cmos: ignore bogus century byte

Israel Rukshin <israelr@mellanox.com>
    IB/iser: Pass the correct number of entries for dma mapped SGL

Stefan Agner <stefan@agner.ch>
    ASoC: imx-sgtl5000: put of nodes if finding codec fails

Eric Biggers <ebiggers@google.com>
    crypto: tgr192 - fix unaligned memory access

YueHaibing <yuehaibing@huawei.com>
    crypto: brcm - Fix some set-but-not-used warning

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: mark prepare0 as PHONY to fix external module build

Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>
    media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL

Dan Carpenter <dan.carpenter@oracle.com>
    drm/etnaviv: NULL vs IS_ERR() buf in etnaviv_core_dump()

Raju Rangoju <rajur@chelsio.com>
    RDMA/iw_cxgb4: Fix the unchecked ep dereference

Charles Keepax <ckeepax@opensource.cirrus.com>
    spi: cadence: Correct initialisation of runtime PM

Loic Poulain <loic.poulain@linaro.org>
    arm64: dts: apq8016-sbc: Increase load on l11 for SDCARD

YueHaibing <yuehaibing@huawei.com>
    drm/shmob: Fix return value check in shmob_drm_probe

Gal Pressman <galpress@amazon.com>
    RDMA/qedr: Fix out of bounds index check in query pkey

Gal Pressman <galpress@amazon.com>
    RDMA/ocrdma: Fix out of bounds index check in query pkey

Gal Pressman <galpress@amazon.com>
    IB/usnic: Fix out of bounds index check in query pkey

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: BCM63XX: drop unused and broken DSP platform device

Yangtao Li <tiny.windzz@gmail.com>
    clk: dove: fix refcount leak in dove_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: mv98dx3236: fix refcount leak in mv98dx3236_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: armada-xp: fix refcount leak in axp_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: kirkwood: fix refcount leak in kirkwood_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: armada-370: fix refcount leak in a370_clk_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: vf610: fix refcount leak in vf610_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: imx7d: fix refcount leak in imx7d_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: imx6sx: fix refcount leak in imx6sx_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: imx6q: fix refcount leak in imx6q_clocks_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: samsung: exynos4: fix refcount leak in exynos4_get_xom()

Yangtao Li <tiny.windzz@gmail.com>
    clk: socfpga: fix refcount leak

Yangtao Li <tiny.windzz@gmail.com>
    clk: qoriq: fix refcount leak in clockgen_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: highbank: fix refcount leak in hb_clk_init()

Dan Carpenter <dan.carpenter@oracle.com>
    Input: nomadik-ske-keypad - fix a loop timeout test

Petr Machata <petrm@mellanox.com>
    vxlan: changelink: Fix handling of default remotes

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Remove bogus IPSR10 value

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a77995: Remove bogus SEL_PWM[0-3]_3 configurations

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Add missing IPSR11 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh73a0: Add missing TO pin to tpu4_to3 group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7791: Remove bogus marks from vin1_b_data18 group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7791: Remove bogus ctrl marks from qspi_data4_b group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7740: Add missing LCD0 marks to lcd0_data24_1 group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7740: Add missing REF125CK pin to gether_gmii group

Kelvin Cao <kelvin.cao@microchip.com>
    switchtec: Remove immediate status check after submitting MRPC command

Stefan Wahren <stefan.wahren@i2se.com>
    staging: bcm2835-camera: Abort probe if there is no camera

Yuval Shaia <yuval.shaia@oracle.com>
    IB/rxe: Fix incorrect cache cleanup in error flow

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: phy: Fix not to call phy_resume() if PHY is not attached

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Skip validating ports during destruction, just ref

YueHaibing <yuehaibing@huawei.com>
    exportfs: fix 'passing zero to ERR_PTR()' warning

Colin Ian King <colin.king@canonical.com>
    pcrypt: use format specifier in kobject_add

Gustavo A. R. Silva <gustavo@embeddedor.com>
    NTB: ntb_hw_idt: replace IS_ERR_OR_NULL with regular NULL checks

Petr Machata <petrm@mellanox.com>
    mlxsw: reg: QEEC: Add minimum shaper fields

Maxime Ripard <maxime.ripard@bootlin.com>
    drm/sun4i: hdmi: Fix double flag assignation

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kgdb: add kgdb_arch_set/remove_breakpoint()

Hans de Goede <hdegoede@redhat.com>
    pwm: lpss: Release runtime-pm reference from the driver's remove callback

Spencer E. Olson <olsonse@umich.edu>
    staging: comedi: ni_mio_common: protect register write overflow

Nicolas Huaman <nicolas@herochao.de>
    ALSA: usb-audio: update quirk for B&W PX to remove microphone

Linus Walleij <linus.walleij@linaro.org>
    regulator: fixed: Default enable high on DT regulators

Alex Estrin <alex.estrin@intel.com>
    IB/hfi1: Add mtu check for operational data VLs

Zhu Yanjun <yanjun.zhu@oracle.com>
    IB/rxe: replace kvfree with vfree

John Garry <john.garry@huawei.com>
    drm/hisilicon: hibmc: Don't overwrite fb helper surface depth

Jitendra Bhivare <jitendra.bhivare@broadcom.com>
    PCI: iproc: Remove PAXC slot check to allow VF support

Jann Horn <jannh@google.com>
    apparmor: don't try to replace stale label in ptrace access check

Anders Roxell <anders.roxell@linaro.org>
    ALSA: hda: fix unused variable warning

Dan Carpenter <dan.carpenter@oracle.com>
    drm/virtio: fix bounds check in virtio_gpu_cmd_get_capset()

Peter Rosin <peda@axentia.se>
    drm/sti: do not remove the drm_bridge that was never added

Jean-Jacques Hiblot <jjhiblot@ti.com>
    leds: tlc591xx: update the maximum brightness

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - fix big endian issues

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix bbp version check in mt7601u_wait_bbp_ready

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix wrong timeout input for tipc_wait_for_cond()

Ard Biesheuvel <ardb@kernel.org>
    powerpc/archrandom: fix arch_get_random_seed_int()

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    mfd: intel-lpss: Add default I2C device properties for Gemini Lake

Jan Kara <jack@suse.cz>
    xfs: Sanity check flags of Q_XQUOTARM call


-------------

Diffstat:

 Makefile                                           |   8 +-
 arch/arm/boot/dts/lpc3250-phy3250.dts              |   4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |  10 +-
 arch/arm/boot/dts/ls1021a-twr.dts                  |   9 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |  11 +-
 arch/arm/boot/dts/stm32h743i-eval.dts              |   1 +
 arch/arm/boot/dts/sun8i-h3-beelink-x2.dts          |   4 +
 arch/arm/common/mcpm_entry.c                       |   2 +-
 arch/arm/include/asm/suspend.h                     |   1 +
 arch/arm/kernel/hyp-stub.S                         |   4 +-
 arch/arm/kernel/sleep.S                            |  12 ++
 arch/arm/mach-omap2/omap_hwmod.c                   |   2 +-
 arch/arm/mach-rpc/irq.c                            |   3 +-
 arch/arm/plat-pxa/ssp.c                            |   6 -
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   3 +-
 .../dts/amlogic/meson-gxl-s905x-libretech-cc.dts   |   1 -
 arch/arm64/boot/dts/arm/juno-clocks.dtsi           |   4 +-
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi          |   2 +
 arch/m68k/amiga/cia.c                              |   9 ++
 arch/m68k/atari/ataints.c                          |   4 +-
 arch/m68k/atari/time.c                             |  15 ++-
 arch/m68k/bvme6000/config.c                        |  20 +--
 arch/m68k/hp300/time.c                             |  10 +-
 arch/m68k/mac/via.c                                | 119 ++++++++++-------
 arch/m68k/mvme147/config.c                         |  18 +--
 arch/m68k/mvme16x/config.c                         |  21 +--
 arch/m68k/q40/q40ints.c                            |  19 +--
 arch/m68k/sun3/sun3ints.c                          |   3 +
 arch/m68k/sun3x/time.c                             |  16 ++-
 arch/mips/bcm63xx/Makefile                         |   6 +-
 arch/mips/bcm63xx/boards/board_bcm963xx.c          |  20 ---
 arch/mips/bcm63xx/dev-dsp.c                        |  56 --------
 arch/mips/include/asm/io.h                         |  14 +-
 .../include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h     |  14 --
 .../mips/include/asm/mach-bcm63xx/board_bcm963xx.h |   5 -
 arch/mips/kernel/setup.c                           |   2 +-
 arch/nios2/kernel/nios2_ksyms.c                    |  12 ++
 arch/powerpc/Makefile                              |   2 +
 arch/powerpc/include/asm/archrandom.h              |   2 +-
 arch/powerpc/include/asm/kgdb.h                    |   5 +-
 arch/powerpc/kernel/cacheinfo.c                    |  21 +++
 arch/powerpc/kernel/cacheinfo.h                    |   4 +
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |  17 +--
 arch/powerpc/kernel/kgdb.c                         |  43 ++++--
 arch/powerpc/kvm/book3s_64_vio.c                   |   1 -
 arch/powerpc/mm/dump_hashpagetable.c               |   2 +-
 arch/powerpc/platforms/pseries/mobility.c          |  10 ++
 arch/x86/Kconfig.debug                             |   2 +-
 arch/x86/kernel/kgdb.c                             |   2 +-
 arch/x86/mm/tlb.c                                  |   3 -
 block/blk-merge.c                                  |   8 +-
 crypto/pcrypt.c                                    |   2 +-
 crypto/tgr192.c                                    |   6 +-
 drivers/ata/libahci.c                              |   1 -
 drivers/base/core.c                                |  20 ++-
 drivers/base/power/wakeup.c                        |   2 +-
 drivers/bcma/driver_pci.c                          |   4 +-
 drivers/block/drbd/drbd_main.c                     |   2 +
 drivers/clk/clk-highbank.c                         |   1 +
 drivers/clk/clk-qoriq.c                            |   1 +
 drivers/clk/imx/clk-imx6q.c                        |   1 +
 drivers/clk/imx/clk-imx6sx.c                       |   1 +
 drivers/clk/imx/clk-imx7d.c                        |   1 +
 drivers/clk/imx/clk-vf610.c                        |   1 +
 drivers/clk/mvebu/armada-370.c                     |   4 +-
 drivers/clk/mvebu/armada-xp.c                      |   4 +-
 drivers/clk/mvebu/dove.c                           |   8 +-
 drivers/clk/mvebu/kirkwood.c                       |   2 +
 drivers/clk/mvebu/mv98dx3236.c                     |   4 +-
 drivers/clk/qcom/gcc-msm8996.c                     |  36 -----
 drivers/clk/samsung/clk-exynos4.c                  |   1 +
 drivers/clk/socfpga/clk-pll-a10.c                  |   1 +
 drivers/clk/socfpga/clk-pll.c                      |   1 +
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |  19 ++-
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h               |   6 +-
 drivers/clocksource/exynos_mct.c                   |  14 +-
 drivers/clocksource/timer-sun5i.c                  |  10 ++
 drivers/cpufreq/brcmstb-avs-cpufreq.c              |  12 +-
 drivers/crypto/amcc/crypto4xx_trng.h               |   4 +-
 drivers/crypto/bcm/cipher.c                        |   6 +-
 drivers/crypto/caam/caamrng.c                      |   5 +-
 drivers/crypto/caam/error.c                        |   2 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |   8 +-
 drivers/crypto/ccp/ccp-ops.c                       |  67 +++++-----
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  21 +--
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/dma/dw/platform.c                          |  14 +-
 drivers/dma/edma.c                                 |   6 +-
 drivers/dma/hsu/hsu.c                              |   4 +-
 drivers/dma/imx-sdma.c                             |   8 ++
 drivers/dma/mv_xor.c                               |   2 +-
 drivers/dma/tegra210-adma.c                        |  72 ++++++++--
 drivers/edac/edac_mc.c                             |  12 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  15 ++-
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c        |   2 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c  |   1 -
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  24 ++--
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   6 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c            |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gddr3.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c     |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |   4 +-
 drivers/gpu/drm/radeon/r600.c                      |   4 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |   4 +-
 drivers/gpu/drm/sti/sti_hda.c                      |   1 -
 drivers/gpu/drm/sti/sti_hdmi.c                     |   1 -
 drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c        |   2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   5 +-
 drivers/hwmon/lm75.c                               |   2 +-
 drivers/hwmon/pmbus/tps53679.c                     |   9 +-
 drivers/hwmon/shtc1.c                              |   2 +-
 drivers/hwmon/w83627hf.c                           |  42 +++++-
 drivers/iio/dac/ad5380.c                           |   2 +-
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |  24 ++--
 drivers/infiniband/hw/hfi1/chip.c                  |  26 +++-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   1 -
 drivers/infiniband/hw/mlx5/qp.c                    |  21 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   2 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  27 ++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   2 +-
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   4 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |  26 ++--
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   5 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   2 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |  10 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |   2 +-
 drivers/iommu/amd_iommu.c                          |   2 +
 drivers/iommu/amd_iommu_init.c                     |   3 +
 drivers/iommu/intel-iommu.c                        |  39 +++---
 drivers/iommu/iommu.c                              |   6 +-
 drivers/iommu/mtk_iommu.c                          |  26 +++-
 drivers/leds/leds-tlc591xx.c                       |   7 +-
 drivers/lightnvm/pblk-rb.c                         |   2 +-
 drivers/media/i2c/ov2659.c                         |   2 +-
 drivers/media/pci/cx18/cx18-fileops.c              |   2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   5 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |   2 +-
 drivers/media/pci/tw5864/tw5864-video.c            |   4 +-
 drivers/media/platform/atmel/atmel-isi.c           |   2 +-
 drivers/media/platform/davinci/isif.c              |   9 --
 drivers/media/platform/davinci/vpbe.c              |   2 +-
 drivers/media/platform/omap/omap_vout.c            |  15 +--
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   2 +-
 drivers/media/platform/vivid/vivid-osd.c           |   2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   5 +-
 drivers/mfd/intel-lpss-pci.c                       |  28 ++--
 drivers/mfd/intel-lpss.c                           |   1 +
 drivers/misc/mic/card/mic_x100.c                   |  28 ++--
 drivers/misc/sgi-xp/xpc_partition.c                |   2 +-
 drivers/mmc/core/host.c                            |   2 -
 drivers/mmc/core/quirks.h                          |   7 +
 drivers/mmc/host/sdhci-brcmstb.c                   |   4 +-
 drivers/net/dsa/qca8k.c                            |  12 ++
 drivers/net/dsa/qca8k.h                            |   1 +
 drivers/net/ethernet/amazon/ena/ena_com.c          |   3 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |  15 +--
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c  |   4 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  18 ++-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  16 ++-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   5 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  22 +++-
 drivers/net/ethernet/natsemi/sonic.c               |   6 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |  16 ++-
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |  34 +++--
 drivers/net/ethernet/qualcomm/qca_spi.c            |   9 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   1 +
 drivers/net/ethernet/renesas/sh_eth.c              |   6 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +-
 drivers/net/hyperv/netvsc_drv.c                    |  13 +-
 drivers/net/phy/fixed_phy.c                        |   6 +-
 drivers/net/phy/phy_device.c                       |  11 +-
 drivers/net/vxlan.c                                |   7 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |  29 +++--
 drivers/net/wireless/ath/ath9k/dynack.c            |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  19 ++-
 drivers/net/wireless/marvell/libertas_tf/cmd.c     |   2 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |   2 +-
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |   8 +-
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvmem/imx-ocotp.c                          |   3 +-
 drivers/of/of_mdio.c                               |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   4 +-
 drivers/pci/host/pcie-iproc.c                      |   8 --
 drivers/pci/pci-driver.c                           |  17 ++-
 drivers/pci/switch/switchtec.c                     |   4 -
 drivers/pinctrl/bcm/pinctrl-iproc-gpio.c           |  96 +++++++++++---
 drivers/pinctrl/sh-pfc/pfc-emev2.c                 |  20 +++
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               |   3 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |   8 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7792.c               |   1 +
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c               |   2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a77995.c              |   8 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |   2 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |   4 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |   4 +-
 drivers/platform/mips/cpu_hwmon.c                  |   2 +-
 drivers/platform/x86/alienware-wmi.c               |  19 ++-
 drivers/platform/x86/wmi.c                         |   3 +
 drivers/power/supply/power_supply_core.c           |  10 +-
 drivers/pwm/pwm-lpss.c                             |   6 +
 drivers/pwm/pwm-meson.c                            |   9 +-
 drivers/rapidio/rio_cm.c                           |   4 +-
 drivers/regulator/fixed.c                          |  11 +-
 drivers/regulator/lp87565-regulator.c              |   2 +-
 drivers/regulator/pv88060-regulator.c              |   2 +-
 drivers/regulator/pv88080-regulator.c              |   2 +-
 drivers/regulator/pv88090-regulator.c              |   2 +-
 drivers/regulator/tps65086-regulator.c             |   4 +-
 drivers/regulator/wm831x-dcdc.c                    |   4 +-
 drivers/rtc/rtc-88pm80x.c                          |  21 ++-
 drivers/rtc/rtc-88pm860x.c                         |  21 ++-
 drivers/rtc/rtc-ds1307.c                           |   7 +-
 drivers/rtc/rtc-ds1672.c                           |   3 +-
 drivers/rtc/rtc-mc146818-lib.c                     |   2 +-
 drivers/rtc/rtc-pcf2127.c                          |  32 ++---
 drivers/rtc/rtc-pcf8563.c                          |  13 +-
 drivers/rtc/rtc-pm8xxx.c                           |   6 +-
 drivers/scsi/fnic/fnic_isr.c                       |   4 +-
 drivers/scsi/libfc/fc_exch.c                       |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  34 +++--
 drivers/scsi/qla2xxx/qla_target.c                  |  14 +-
 drivers/soc/fsl/qe/gpio.c                          |   4 +-
 drivers/spi/spi-bcm2835aux.c                       |  13 +-
 drivers/spi/spi-cadence.c                          |  11 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-tegra114.c                         | 145 +++++++++++++++------
 drivers/spi/spi-topcliff-pch.c                     |   6 +
 drivers/staging/comedi/drivers/ni_mio_common.c     |  24 +++-
 drivers/staging/greybus/light.c                    |  12 +-
 drivers/staging/most/aim-cdev/cdev.c               |   5 +-
 .../rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c  |   5 +-
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |   9 ++
 drivers/target/target_core_device.c                |   4 +-
 drivers/thermal/cpu_cooling.c                      |   2 +-
 drivers/thermal/mtk_thermal.c                      |   6 +-
 drivers/tty/ipwireless/hardware.c                  |   2 +
 drivers/tty/serial/fsl_lpuart.c                    |  28 ++--
 drivers/tty/serial/stm32-usart.c                   | 123 +++++++++--------
 drivers/tty/serial/stm32-usart.h                   |  10 +-
 drivers/uio/uio.c                                  |  10 +-
 drivers/usb/class/cdc-wdm.c                        |   2 +-
 drivers/usb/dwc2/gadget.c                          |   1 +
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/phy/Kconfig                            |   2 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   2 +-
 drivers/vfio/mdev/mdev_core.c                      |  11 +-
 drivers/vfio/pci/vfio_pci.c                        |  19 ++-
 drivers/video/backlight/lm3630a_bl.c               |   4 +-
 drivers/video/fbdev/chipsfb.c                      |   3 +-
 drivers/xen/cpu_hotplug.c                          |   2 +-
 drivers/xen/pvcalls-back.c                         |   2 +-
 fs/affs/super.c                                    |   6 -
 fs/afs/super.c                                     |   1 +
 fs/afs/xattr.c                                     |   4 +-
 fs/btrfs/file.c                                    |   3 +-
 fs/btrfs/inode-map.c                               |  28 +++-
 fs/cifs/connect.c                                  |   3 +-
 fs/exportfs/expfs.c                                |   1 +
 fs/ext4/inline.c                                   |   2 +-
 fs/jfs/jfs_txnmgr.c                                |   3 +-
 fs/nfs/delegation.c                                |  20 +--
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/flexfilelayout/flexfilelayout.h             |  32 +++--
 fs/nfs/pnfs.c                                      |  33 +++--
 fs/nfs/pnfs.h                                      |   1 +
 fs/nfs/super.c                                     |   2 +-
 fs/nfs/write.c                                     |   2 +-
 fs/xfs/xfs_quotaops.c                              |   3 +
 include/linux/device.h                             |   3 +-
 include/linux/irqchip/arm-gic-v3.h                 |  12 +-
 include/linux/mlx5/mlx5_ifc.h                      |   2 -
 include/linux/mmc/sdio_ids.h                       |   2 +
 include/linux/pci.h                                |   1 +
 include/linux/platform_data/dma-imx-sdma.h         |   3 +
 include/linux/signal.h                             |  15 ++-
 include/media/davinci/vpbe.h                       |   2 +-
 include/net/request_sock.h                         |   4 +-
 include/net/tcp.h                                  |   2 +-
 kernel/debug/kdb/kdb_main.c                        |   2 +-
 kernel/events/core.c                               |   3 +
 kernel/irq/irqdomain.c                             |   1 +
 kernel/signal.c                                    |   5 +
 lib/devres.c                                       |   3 +-
 lib/kfifo.c                                        |   3 +-
 net/6lowpan/nhc.c                                  |   2 +-
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/core/neighbour.c                               |   4 +-
 net/core/sock.c                                    |   4 +-
 net/ieee802154/6lowpan/reassembly.c                |   2 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/iucv/af_iucv.c                                 |  27 +++-
 net/l2tp/l2tp_core.c                               |   3 +-
 net/llc/af_llc.c                                   |  34 +++--
 net/llc/llc_conn.c                                 |  35 ++---
 net/llc/llc_if.c                                   |  12 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   2 +-
 net/mac80211/rx.c                                  |  11 +-
 net/mpls/mpls_iptunnel.c                           |   2 +-
 net/netfilter/nft_set_hash.c                       |  23 +++-
 net/packet/af_packet.c                             |  25 +++-
 net/rds/ib_stats.c                                 |   2 +-
 net/rds/stats.c                                    |   2 +
 net/rxrpc/output.c                                 |   3 +
 net/sched/act_mirred.c                             |   6 +-
 net/sched/sch_netem.c                              |  18 ++-
 net/tipc/link.c                                    |  29 +++--
 net/tipc/node.c                                    |   7 +-
 net/tipc/socket.c                                  |   2 +-
 net/tipc/sysctl.c                                  |   8 +-
 security/apparmor/include/context.h                |   2 +
 security/apparmor/lsm.c                            |   4 +-
 security/keys/key.c                                |   1 +
 sound/aoa/codecs/onyx.c                            |   4 +-
 sound/pci/hda/hda_controller.h                     |   9 +-
 sound/soc/codecs/cs4349.c                          |   1 +
 sound/soc/codecs/es8328.c                          |   2 +-
 sound/soc/codecs/wm8737.c                          |   2 +-
 sound/soc/davinci/davinci-mcasp.c                  |  13 +-
 sound/soc/fsl/imx-sgtl5000.c                       |   3 +-
 sound/soc/qcom/apq8016_sbc.c                       |  21 ++-
 sound/soc/soc-pcm.c                                |   4 +-
 sound/soc/sunxi/sun4i-i2s.c                        |   4 +-
 sound/usb/mixer.c                                  |   4 +-
 sound/usb/quirks-table.h                           |   9 +-
 tools/testing/selftests/ipc/msgque.c               |  11 +-
 346 files changed, 2015 insertions(+), 1275 deletions(-)


