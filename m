Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E181A147AC9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgAXJh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:37:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgAXJhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:37:55 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8874D2070A;
        Fri, 24 Jan 2020 09:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858670;
        bh=bQnO1pXYLNrkyJjYcOvwssKCcfXRtKEcet7CcCstGug=;
        h=From:To:Cc:Subject:Date:From;
        b=Vky08Z1UkL8ohv16JdpdspKBC6fS0CMid0z+F0XXz8zfMVi8V8ouvdfHAA8/JU2Lo
         BaGDWGmClgYQeSgqk5OWuGsk7k+gs73W7rettTn8TxiIgoDWsX61qvq5eUYGc9GkQH
         X7FmweYzzl8wgSiP9Z4C31uRb0TMTkKqIeBG2uzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/639] 4.19.99-stable review
Date:   Fri, 24 Jan 2020 10:22:50 +0100
Message-Id: <20200124093047.008739095@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.99-rc1
X-KernelTest-Deadline: 2020-01-26T09:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.99 release.
There are 639 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.99-rc1

Finn Thain <fthain@telegraphics.com.au>
    m68k: Call timer_interrupt() with interrupts disabled

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxm-khadas-vim2: fix uart_A bluetooth node

Fabrice Gasnier <fabrice.gasnier@st.com>
    serial: stm32: fix clearing interrupt error flags

Max Gurtovoy <maxg@mellanox.com>
    IB/iser: Fix dma_nents type definition

Marc Gonzalez <marc.w.gonzalez@free.fr>
    usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON

Jesper Dangaard Brouer <brouer@redhat.com>
    samples/bpf: Fix broken xdp_rxq_info due to map order assumptions

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: juno: Fix UART frequency

Sam Bobroff <sbobroff@linux.ibm.com>
    drm/radeon: fix bad DMA from INTERRUPT_CNTL2

Chuhong Yuan <hslester96@gmail.com>
    dmaengine: ti: edma: fix missed failure handling

zhengbin <zhengbin13@huawei.com>
    afs: Remove set but not used variables 'before', 'after'

Navid Emamdoost <navid.emamdoost@gmail.com>
    affs: fix a memory leak in affs_remount

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: core: fix wl1251 sdio quirks

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: sdio: fix wl1251 vendor id

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: report dma error during probe

Eric Dumazet <edumazet@google.com>
    packet: fix data-race in fanout_flow_is_huge()

Eric Dumazet <edumazet@google.com>
    net: neigh: use long type to store jiffies delta

Stephen Hemminger <sthemmin@microsoft.com>
    hv_netvsc: flag software created hash value

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Fix return value of loongson_hwmon_init

Madalin Bucur <madalin.bucur@nxp.com>
    dpaa_eth: avoid timestamp read on error paths

Madalin Bucur <madalin.bucur@nxp.com>
    dpaa_eth: perform DMA unmapping before read

Tony Lindgren <tony@atomide.com>
    hwrng: omap3-rom - Fix missing clock by probing with device tree

Dan Carpenter <dan.carpenter@oracle.com>
    drm: panel-lvds: Potential Oops in probe error handling

Marc Dionne <marc.dionne@auristor.com>
    afs: Fix large file support

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix send_table offset in case of a host bug

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix offset usage in netvsc_send_table()

Stefan Wahren <stefan.wahren@in-tech.com>
    net: qca_spi: Move reset_count to struct qcaspi

David Howells <dhowells@redhat.com>
    afs: Fix missing timeout reset

Dan Carpenter <dan.carpenter@oracle.com>
    bpf, offload: Unlock on error in bpf_offload_dev_create()

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix registration of Rx-only sockets

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: correct the parent's backlog when corrupted packet was dropped

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: fix error path for corrupted GSO frames

Pavel Tatashin <pasha.tatashin@soleen.com>
    arm64: hibernate: check pgd table allocation

Jean Delvare <jdelvare@suse.de>
    firmware: dmi: Fix unlikely out-of-bounds read in save_mem_devices

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: fix size check for sdma script_number

Michael S. Tsirkin <mst@redhat.com>
    vhost/test: stop device before reset

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    drm/msm/dsi: Implement reset correctly

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: receive pending data after RCV_SHUTDOWN

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: receive returns without data

Eric Dumazet <edumazet@google.com>
    tcp: annotate lockless access to tcp_memory_pressure

Eric Dumazet <edumazet@google.com>
    net: add {READ|WRITE}_ONCE() annotations on ->rskq_accept_head

Eric Dumazet <edumazet@google.com>
    net: avoid possible false sharing in sk_leave_memory_pressure()

YueHaibing <yuehaibing@huawei.com>
    act_mirred: Fix mirred_init_module error handling

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: Fix initialization of vnicc cmd masks during set online

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: Fix error handling during VNICC initialization

Xin Long <lucien.xin@gmail.com>
    sctp: add chunks to sk_backlog when the newsk sk_socket is not set

Antonio Borneo <antonio.borneo@st.com>
    net: stmmac: fix disabling flexible PPS output

Antonio Borneo <antonio.borneo@st.com>
    net: stmmac: fix length of PTP clock's name string

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    ip6erspan: remove the incorrect mtu limit for ip6erspan

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff refcounting in llc_conn_state_process()

Eric Biggers <ebiggers@google.com>
    llc: fix another potential sk_buff leak in llc_ui_sendmsg()

Johannes Berg <johannes.berg@intel.com>
    mac80211: accept deauth frames in IBSS mode

David Howells <dhowells@redhat.com>
    rxrpc: Fix trace-after-put looking at the put connection record

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: gmac4+: Not all Unicast addresses may be available

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    nvme: retain split access workaround for capability reads

Vladimir Oltean <olteanv@gmail.com>
    net: sched: cbs: Avoid division by zero when calculating the port rate

Dan Carpenter <dan.carpenter@oracle.com>
    net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()

Dan Carpenter <dan.carpenter@oracle.com>
    net: nixge: Fix a signedness bug in nixge_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    of: mdio: Fix a signedness bug in of_phy_get_and_connect()

Dan Carpenter <dan.carpenter@oracle.com>
    net: axienet: fix a signedness bug in probe

Dan Carpenter <dan.carpenter@oracle.com>
    net: stmmac: dwmac-meson8b: Fix signedness bug in probe

Dan Carpenter <dan.carpenter@oracle.com>
    net: socionext: Fix a signedness bug in ave_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    net: netsec: Fix signedness bug in netsec_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    cxgb4: Signedness bug in init_one()

Dan Carpenter <dan.carpenter@oracle.com>
    net: aquantia: Fix aq_vec_isr_legacy() return value

Filippo Sironi <sironi@amazon.de>
    iommu/amd: Wait for completion of IOTLB flush in attach_device

Yunfeng Ye <yeyunfeng@huawei.com>
    crypto: hisilicon - Matching the dma address for dma_pool_free()

Alexei Starovoitov <ast@kernel.org>
    bpf: fix BTF limits

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/mce: Keep irqs disabled during lockless page table walk

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    clk: actions: Fix factor clk struct member access

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    mailbox: qcom-apcs: fix max_register value

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid accessing uninitialized field of inode page in is_alive()

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Increase timeout for HWRM_DBG_COREDUMP_XX commands

Anton Ivanov <anton.ivanov@cambridgegreys.com>
    um: Fix off by one error in IRQ enumeration

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Fix false error message

Nicolas Boichat <drinkcat@chromium.org>
    ath10k: adjust skb length in ath10k_sdio_mbox_rx_packet

Rashmica Gupta <rashmica.g@gmail.com>
    gpio/aspeed: Fix incorrect number of banks

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

Chao Yu <yuchao0@huawei.com>
    f2fs: fix error path of f2fs_convert_inline_page()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix wrong error injection path in inc_valid_block_count()

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv: Fix i2c2 and i2c3 Pin mux

Wei Yongjun <weiyongjun1@huawei.com>
    rtlwifi: Fix file release memory leak

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix error VF index when setting VLAN offload

Mao Wenan <maowenan@huawei.com>
    net: sonic: return NETDEV_TX_OK if failed to map buffer

Oleh Kravchenko <oleg@kaa.org.ua>
    led: triggers: Fix dereferencing of null pointer

Björn Töpel <bjorn.topel@intel.com>
    xsk: avoid store-tearing when assigning umem

Björn Töpel <bjorn.topel@intel.com>
    xsk: avoid store-tearing when assigning queues

Oscar A Perez <linux@neuralgames.com>
    ARM: dts: aspeed-g5: Fixe gpio-ranges upper limit

Andrey Smirnov <andrew.smirnov@gmail.com>
    tty: serial: fsl_lpuart: Use appropriate lpuart32_* I/O funcs

Arnd Bergmann <arnd@arndb.de>
    wcn36xx: use dynamic allocation for large variables

Lorenzo Bianconi <lorenzo@kernel.org>
    ath9k: dynack: fix possible deadlock in ath_dynack_node_{de}init

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: honor IPS_OFFLOAD flag

Colin Ian King <colin.king@canonical.com>
    iio: dac: ad5380: fix incorrect assignment to val

Dan Carpenter <dan.carpenter@oracle.com>
    bcache: Fix an error code in bch_dump_read()

YueHaibing <yuehaibing@huawei.com>
    usb: typec: tps6598x: Fix build error without CONFIG_REGMAP_I2C

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

Vladimir Oltean <olteanv@gmail.com>
    net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm75) Fix write operations for negative temperatures

Linus Torvalds <torvalds@linux-foundation.org>
    Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"

David Howells <dhowells@redhat.com>
    rxrpc: Fix lack of conn cleanup when local endpoint is cleaned up [ver #2]

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ahci: Do not export local variable ahci_em_messages

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Fix iova_to_phys PA start for 4GB mode

Markus Elfring <elfring@users.sourceforge.net>
    media: em28xx: Fix exception handling in em28xx_alloc_urbs()

Nick Desaulniers <ndesaulniers@google.com>
    mips: avoid explicit UB in assignment of mips_io_port_base

Bruno Thomsen <bruno.thomsen@gmail.com>
    rtc: pcf2127: bugfix: read rtc disables watchdog

Geert Uytterhoeven <geert@linux-m68k.org>
    ARM: 8896/1: VDSO: Don't leak kernel addresses

Alexandre Kroupski <alexandre.kroupski@ingenico.com>
    media: atmel: atmel-isi: fix timeout value for stop streaming

Arnd Bergmann <arnd@arndb.de>
    i40e: reduce stack usage in i40e_set_fc

Felix Fietkau <nbd@nbd.name>
    mac80211: minstrel_ht: fix per-group max throughput rate initialization

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: rv3029: revert error handling patch to rv3029_eeprom_write()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: platform: Switch to acpi_dma_controller_register()

Maxime Ripard <maxime.ripard@bootlin.com>
    ASoC: sun4i-i2s: RX and TX counter registers are swapped

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/radix: Fix memory hot-unplug page table split

Eric W. Biederman <ebiederm@xmission.com>
    signal: Allow cifs and drbd to receive their terminating signals

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails

Fabrizio Castro <fabrizio.castro@bp.renesas.com>
    drm: rcar-du: lvds: Fix bridge_to_rcar_lvds

Quentin Monnet <quentin.monnet@netronome.com>
    tools: bpftool: fix format strings and arguments for jsonw_printf()

Quentin Monnet <quentin.monnet@netronome.com>
    tools: bpftool: fix arguments for p_err() in do_event_pipe()

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: Add a few missing rds_stat_names entries

YueHaibing <yuehaibing@huawei.com>
    ASoC: wm8737: Fix copy-paste error in wm8737_snd_controls

YueHaibing <yuehaibing@huawei.com>
    ASoC: cs4349: Use PM ops 'cs4349_runtime_pm'

YueHaibing <yuehaibing@huawei.com>
    ASoC: es8328: Fix copy-paste error in es8328_right_line_controls

Xi Wang <wangxi11@huawei.com>
    RDMA/hns: bugfix for slab-out-of-bounds when loading hip08 driver

Xi Wang <wangxi11@huawei.com>
    RDMA/hns: Bugfix for slab-out-of-bounds when unloading hip08 driver

Colin Ian King <colin.king@canonical.com>
    ext4: set error return correctly when ext4_htree_store_dirent fails

Iuliana Prodan <iuliana.prodan@nxp.com>
    crypto: caam - free resources in case caam_rng registration failed

Chuhong Yuan <hslester96@gmail.com>
    cxgb4: smt: Add lock for atomic_dec_and_test

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    spi: bcm-qspi: Fix BSPI QUAD and DUAL mode support when using flex mode

Jesper Dangaard Brouer <brouer@redhat.com>
    net: fix bpf_xdp_adjust_head regression for generic-XDP

Chuhong Yuan <hslester96@gmail.com>
    iio: tsl2772: Use devm_add_action_or_reset for tsl2772_chip_off

Steve French <stfrench@microsoft.com>
    cifs: fix rmmod regression in cifs.ko caused by force_sig changes

Mark Zhang <markz@mellanox.com>
    net/mlx5: Fix mlx5_ifc_query_lag_out_bits

Fabrice Gasnier <fabrice.gasnier@st.com>
    ARM: dts: stm32: add missing vdda-supply to adc on stm32h743i-eval

Jon Maloy <jon.maloy@ericsson.com>
    tipc: reduce risk of wakeup queue starvation

Yoshihiro Kaneko <ykaneko0929@gmail.com>
    arm64: dts: renesas: r8a77995: Fix register range of display node

Johannes Berg <johannes@sipsolutions.net>
    ALSA: aoa: onyx: always initialize register read value

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp - Reduce maximum stack usage

Thomas Gleixner <tglx@linutronix.de>
    x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI

Arnd Bergmann <arnd@arndb.de>
    mic: avoid statically declaring a 'struct device'.

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: rcar-vin: Clean up correct notifier in error path

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

Jani Nikula <jani.nikula@intel.com>
    drm/panel: make drm_panel.h self-contained

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm interface: ifname may be wrong in logs

Colin Ian King <colin.king@canonical.com>
    scsi: libfc: fix null pointer dereference on a null lport

Masahiro Yamada <yamada.masahiro@socionext.com>
    ARM: stm32: use "depends on" instead of "if" after prompt

Ilya Maximets <i.maximets@samsung.com>
    xdp: fix possible cq entry leak

Arnd Bergmann <arnd@arndb.de>
    x86/pgtable/32: Fix LOWMEM_PAGES constant

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: fix socket wmem accounting on fallback with netem

Wen Yang <wen.yang99@zte.com.cn>
    net: pasemi: fix an use-after-free in pasemi_mac_phy_init()

David Disseldorp <ddiss@suse.de>
    ceph: fix "ceph.dir.rctime" vxattr value

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Fix the valid check for inbound and outbound windows

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Fix devfn check in mobiveil_pcie_valid_device()

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Remove the flag MSI_FLAG_MULTI_PCI_MSI

Xi Wang <wangxi11@huawei.com>
    RDMA/hns: Fixs hw access invalid dma memory error

Eddie James <eajames@linux.ibm.com>
    fsi: sbefifo: Don't fail operations when in SBE IPL state

Arnd Bergmann <arnd@arndb.de>
    devres: allow const resource arguments

Jeremy Kerr <jk@ozlabs.org>
    fsi/core: Fix error paths on CFAM init

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Introduce "poweroff" callbacks for ACPI PM domain and LPSS

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Simplify and fix PM domain hibernation callbacks

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: ACPI/PCI: Resume all devices during hibernation

Jouni Malinen <j@w1.fi>
    um: Fix IRQ controller regression on console read

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix use-after-free in rpcrdma_post_recvs

David Howells <dhowells@redhat.com>
    rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Release IDA resources

Kevin Mitchell <kevmitch@arista.com>
    iommu/amd: Make iommu_disable safer

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Suppress error messages when querying DSCP DCB capabilities.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ethtool selftest crash under error conditions.

Andrea Arcangeli <aarcange@redhat.com>
    fork,memcg: alloc_thread_stack_node needs to set tsk->stack

Matthias Kaehlcke <mka@chromium.org>
    backlight: pwm_bl: Fix heuristic to determine number of brightness levels

Jakub Kicinski <jakub.kicinski@netronome.com>
    tools: bpftool: use correct argument in cgroup errors

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    nvmem: imx-ocotp: Change TIMING calculation to u-boot algorithm

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    nvmem: imx-ocotp: Ensure WAIT bits are preserved when setting timing

Nathan Huckleberry <nhuck@google.com>
    clk: qcom: Fix -Wunused-const-variable

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: hsu: Revert "set HSU_CH_MTSR to memory width"

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    perf/ioctl: Add check for the sample_period value

Stefano Brivio <sbrivio@redhat.com>
    ip6_fib: Don't discard nodes with valid routing information in fib6_locate_1()

Rob Clark <robdclark@chromium.org>
    drm/msm/a3xx: remove TPL1 regs from snapshot

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: h6: Pine H64: Add interrupt line for RTC

YueHaibing <yuehaibing@huawei.com>
    net/sched: cbs: Fix error path of cbs_module_init

Fabrizio Castro <fabrizio.castro@bp.renesas.com>
    ARM: dts: iwg20d-q7-common: Fix SDHI1 VccQ regularor

Chen-Yu Tsai <wens@csie.org>
    rtc: pcf8563: Clear event flags and disable interrupts before requesting irq

Chen-Yu Tsai <wens@csie.org>
    rtc: pcf8563: Fix interrupt trigger method

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple AXRs

Julian Wiedmann <jwi@linux.ibm.com>
    net/af_iucv: always register net_device notifier

Julian Wiedmann <jwi@linux.ibm.com>
    net/af_iucv: build proper skbs for HiperTransport

Fred Klassen <fklassen@appneta.com>
    net/udp_gso: Allow TX timestamp with UDP GSO

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: netem: fix backlog accounting for corrupted GSO frames

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    drm/msm/mdp5: Fix mdp5_cfg_init error return

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Handle port down properly in pio

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: fix the check that forwarding is enabled in bpf_ipv6_fib_lookup

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/cacheinfo: add cacheinfo_teardown, cacheinfo_rebuild

Michal Kalderon <michal.kalderon@marvell.com>
    qed: iWARP - fix uninitialized callback

Michal Kalderon <michal.kalderon@marvell.com>
    qed: iWARP - Use READ_ONCE and smp_store_release to access ep->state

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Skip devices in D0 for suspend-to-idle

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdmout: right_j is not supported

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdmin: right_j is not supported

Dan Carpenter <dan.carpenter@oracle.com>
    ntb_hw_switchtec: potential shift wrapping bug in switchtec_ntb_init_sndev()

Peng Fan <peng.fan@nxp.com>
    firmware: arm_scmi: update rate_discrete in clock_describe_rates_get

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: fix bitfield definitions for SENSOR_DESC attributes

Florian Fainelli <f.fainelli@gmail.com>
    phy: usb: phy-brcm-usb: Remove sysfs attributes upon driver removal

Eric Auger <eric.auger@redhat.com>
    iommu/vt-d: Duplicate iommu_resv_region objects per device list

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxm-khadas-vim2: fix Bluetooth support

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxm-khadas-vim2: fix gpio-keys-polled node

Borut Seljak <borut.seljak@t-2.net>
    serial: stm32: fix a recursive locking in stm32_config_rs485

George Wilkie <gwilkie@vyatta.att-mail.com>
    mpls: fix warning with multi-label encap

Takeshi Kihara <takeshi.kihara.df@renesas.com>
    arm64: dts: renesas: ebisu: Remove renesas, no-ether-link property

Antoine Tenart <antoine.tenart@bootlin.com>
    crypto: inside-secure - fix queued len computation

Antoine Tenart <antoine.tenart@bootlin.com>
    crypto: inside-secure - fix zeroing of the request in ahash_exit_inv

Colin Ian King <colin.king@canonical.com>
    media: vivid: fix incorrect assignment operation when setting video mode

Ondrej Jirman <megous@megous.com>
    clk: sunxi-ng: sun50i-h6-r: Fix incorrect W1 clock gate register

Florian Fainelli <f.fainelli@gmail.com>
    cpufreq: brcmstb-avs-cpufreq: Fix types for voltage/frequency

Florian Fainelli <f.fainelli@gmail.com>
    cpufreq: brcmstb-avs-cpufreq: Fix initial command check

Colin Ian King <colin.king@canonical.com>
    phy: qcom-qusb2: fix missing assignment of ret when calling clk_prepare_enable

Jakub Kicinski <jakub.kicinski@netronome.com>
    net: don't clear sock->sk early to avoid trouble in strparser

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/uverbs: check for allocation failure in uapi_add_elm()

Stephen Hemminger <stephen@networkplumber.org>
    net: core: support XDP generic on stacked devices.

Stephen Hemminger <stephen@networkplumber.org>
    netvsc: unshare skb in VF rx handler

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix AEAD processing.

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: Staging: media: Release the correct resource in an error handling path

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix a memory leak issue for hclge_map_unmap_ring_to_vf_vector

Eric Dumazet <edumazet@google.com>
    inet: frags: call inet_frags_fini() after unregister_pernet_subsys()

Eric W. Biederman <ebiederm@xmission.com>
    signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig

Eric W. Biederman <ebiederm@xmission.com>
    signal/bpfilter: Fix bpfilter_kernl to use send_sig not force_sig

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Use right function to get group for device

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Add missing new line for dma type

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
    serial: stm32: fix rx data length when parity enabled

Erwan Le Ray <erwan.leray@st.com>
    serial: stm32: fix rx error handling

Erwan Le Ray <erwan.leray@st.com>
    serial: stm32: fix word length configuration

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

Jerome Brunet <jbrunet@baylibre.com>
    clk: meson: axg: spread spectrum is on mpll2

Jerome Brunet <jbrunet@baylibre.com>
    clk: meson: gxbb: no spread spectrum on mpll0

Jernej Skrabec <jernej.skrabec@siol.net>
    ARM: dts: sun8i-h3: Fix wifi in Beelink X2 DT

David Howells <dhowells@redhat.com>
    afs: Fix double inc of vnode->cb_break

David Howells <dhowells@redhat.com>
    afs: Fix lock-wait/callback-break double locking

David Howells <dhowells@redhat.com>
    afs: Don't invalidate callback if AFS_VNODE_DIR_VALID not set

David Howells <dhowells@redhat.com>
    afs: Fix key leak in afs_release() and afs_evict_inode()

Robert Richter <rrichter@marvell.com>
    EDAC/mc: Fix edac_mc_find() in case no device is found

Matthias Kaehlcke <mka@chromium.org>
    thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_get_power

Jiada Wang <jiada_wang@mentor.com>
    thermal: rcar_gen3_thermal: fix interrupt type

Brian Masney <masneyb@onstation.org>
    backlight: lm3630a: Return 0 on success in update_status functions

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: correct NFT_LOGLEVEL_MAX value

Dan Carpenter <dan.carpenter@oracle.com>
    kdb: do a sanity check on the cpu in kdb_per_cpu()

Jiong Wang <jiong.wang@netronome.com>
    nfp: bpf: fix static check error through tightening shift amount adjustment

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

Takashi Iwai <tiwai@suse.de>
    ALSA: aica: Fix a long-time build breakage

YueHaibing <yuehaibing@huawei.com>
    l2tp: Fix possible NULL pointer dereference

Parav Pandit <parav@mellanox.com>
    vfio/mdev: Fix aborting mdev child device removal if one fails

Parav Pandit <parav@mellanox.com>
    vfio/mdev: Follow correct remove sequence

Parav Pandit <parav@mellanox.com>
    vfio/mdev: Avoid release parent reference during error path

David Howells <dhowells@redhat.com>
    afs: Fix the afs.cell and afs.volume xattr handlers

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Fix encoding for protected management frames

Igor Konopko <igor.j.konopko@intel.com>
    lightnvm: pblk: fix lock order in pblk_rb_tear_down_check

Pan Bian <bianpan2016@163.com>
    mmc: core: fix possible use after free of host

Guenter Roeck <linux@roeck-us.net>
    watchdog: rtd119x_wdt: Fix remove function

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

Parav Pandit <parav@mellanox.com>
    RDMA/rxe: Consider skb reserve space based on netdev of GID

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

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-som-lv: Fix MMC1 card detect

Srinath Mannam <srinath.mannam@broadcom.com>
    PCI: iproc: Enable iProc config read for PAXBv2

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_flow_offload: add entry to flowtable after confirmation

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Book3S HV: Fix lockdep warning when entering the guest

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix error handling in qlt_alloc_qfull_cmd()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix a format specifier

Hongbo Yao <yaohongbo@huawei.com>
    irqchip/gic-v3-its: fix some definitions of inner cacheability attributes

Philipp Rudo <prudo@linux.ibm.com>
    s390/kexec_file: Fix potential segment overlap in ELF loader

Arnd Bergmann <arnd@arndb.de>
    coresight: catu: fix clang build warning

Trond Myklebust <trondmy@gmail.com>
    NFS: Don't interrupt file writeout due to fatal errors

David Howells <dhowells@redhat.com>
    afs: Further fix file locking

David Howells <dhowells@redhat.com>
    afs: Fix AFS file locking to allow fine grained locks

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

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix loop condition of hns3_get_tx_timeo_queue_info()

Kees Cook <keescook@chromium.org>
    selftests/ipc: Fix msgque compiler warnings

Hans de Goede <hdegoede@redhat.com>
    usb: typec: tcpm: Notify the tcpc to start connection-detection for SRPs

Jie Liu <liujie165@huawei.com>
    tipc: set sysctl_tipc_rmem and named_timeout right range

Colin Ian King <colin.king@canonical.com>
    platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer

Neil Armstrong <narmstrong@baylibre.com>
    soc: amlogic: meson-gx-pwrc-vpu: Fix power on/off register bitmask

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: dwc: Fix dw_pcie_ep_find_capability() to return correct capability offset

Vincent Stehlé <vincent.stehle@laposte.net>
    staging: android: vsoc: fix copy_from_user overrun

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/core: Fix the address filtering fix

Guenter Roeck <linux@roeck-us.net>
    hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for vport->bw_limit overflow problem

Colin Ian King <colin.king@canonical.com>
    PCI: rockchip: Fix rockchip_pcie_ep_assert_intx() bitwise operations

YueHaibing <yuehaibing@huawei.com>
    ARM: pxa: ssp: Fix "WARNING: invalid free of devm_ allocated data"

Colin Ian King <colin.king@canonical.com>
    brcmfmac: fix leak of mypkt on error return path

Bart Van Assche <bvanassche@acm.org>
    scsi: target/core: Fix a race condition in the LUN lookup code

Jeffrey Altman <jaltman@auristor.com>
    rxrpc: Fix detection of out of order acks

Steven Price <steven.price@arm.com>
    firmware: arm_scmi: fix of_node leak in scmi_mailbox_check

Zhang Rui <rui.zhang@intel.com>
    ACPI: button: reinitialize button state upon resume

Marc Gonzalez <marc.w.gonzalez@free.fr>
    clk: qcom: Skip halt checks on gcc_pcie_0_pipe_clk for 8998

Leandro Dorileo <leandro.maciel.dorileo@intel.com>
    net/sched: cbs: fix port_rate miscalculation

Chris Packham <chris.packham@alliedtelesis.co.nz>
    of: use correct function prototype for of_overlay_fdt_apply()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Unregister chrdev if module initialization fails

YueHaibing <yuehaibing@huawei.com>
    drm/vmwgfx: Remove set but not used variable 'restart'

Andrey Ignatov <rdna@fb.com>
    bpf: Add missed newline in verifier verbose log

YueHaibing <yuehaibing@huawei.com>
    ehea: Fix a copy-paste err in ehea_init_port_res

Pi-Hsun Shih <pihsun@chromium.org>
    rtc: mt6397: Don't call irq_dispose_mapping.

Geert Uytterhoeven <geert+renesas@glider.be>
    rtc: Fix timestamp value for RTC_TIMESTAMP_BEGIN_1900

Matteo Croce <mcroce@redhat.com>
    arm64/vdso: don't leak kernel addresses

Noralf Trønnes <noralf@tronnes.org>
    drm/fb-helper: generic: Call drm_client_add() after setup is done

Martin Sperl <kernel@martin.sperl.org>
    spi: bcm2835aux: fix driver to not allow 65535 (=-1) cs-gpios

Dan Carpenter <dan.carpenter@oracle.com>
    soc/fsl/qe: Fix an error code in qe_pin_request()

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix sysc_unprepare() when no clocks have been allocated

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

Dan Carpenter <dan.carpenter@oracle.com>
    soc: qcom: cmd-db: Fix an error code in cmd_db_dev_probe()

Vladimir Oltean <olteanv@gmail.com>
    net: dsa: Avoid null pointer when failing to connect to PHY

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix potentially uninitialized return value for _setup_reset()

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: don't clear BMCR in genphy_soft_reset

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun9i: optimus: Fix fixed-regulators

Maxime Ripard <maxime.ripard@bootlin.com>
    arm64: dts: allwinner: a64: Add missing PIO clocks

Maxime Ripard <maxime.ripard@bootlin.com>
    ARM: dts: sun8i: a33: Reintroduce default pinctrl muxing

Finn Thain <fthain@telegraphics.com.au>
    m68k: mac: Fix VIA timer counter accesses

Jon Maloy <jon.maloy@ericsson.com>
    tipc: tipc clang warning

Arnd Bergmann <arnd@arndb.de>
    jfs: fix bogus variable self-initialization

Arnd Bergmann <arnd@arndb.de>
    crypto: ccree - reduce kernel stack usage with clang

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

Neil Armstrong <narmstrong@baylibre.com>
    soc: amlogic: gx-socinfo: Add mask for each SoC packages

Axel Lin <axel.lin@ingics.com>
    regulator: lp87565: Fix missing register for LP87565_BUCK_0

Kangjie Lu <kjlu@umn.edu>
    net: sh_eth: fix a missing check of of_get_phy_mode

Feras Daoud <ferasda@mellanox.com>
    net/mlx5e: IPoIB, Fix RX checksum statistics update

Eli Britstein <elibr@mellanox.com>
    net/mlx5: Fix multiple updates of steering rules in parallel

Dan Carpenter <dan.carpenter@oracle.com>
    xen, cpu_hotplug: Prevent an out of bounds access

Dan Carpenter <dan.carpenter@oracle.com>
    drivers/rapidio/rio_cm.c: fix potential oops in riocm_ch_listen()

Dirk van der Merwe <dirk.vandermerwe@netronome.com>
    nfp: fix simple vNIC mailbox length

Steve Sistare <steven.sistare@oracle.com>
    scsi: megaraid_sas: reduce module load time

Qian Cai <cai@lca.pw>
    x86/mm: Remove unused variable 'cpu'

Guenter Roeck <linux@roeck-us.net>
    nios2: ksyms: Add missing symbol exports

Alex Williamson <alex.williamson@redhat.com>
    PCI: Fix "try" semantics of bus and slot reset

Ilya Dryomov <idryomov@gmail.com>
    rbd: clear ->xferred on error from rbd_obj_issue_copyup()

Akihiro Tsukada <tskd08@gmail.com>
    media: dvb/earth-pt1: fix wrong initialization for demod blocks

Rashmica Gupta <rashmica.g@gmail.com>
    powerpc/mm: Check secondary hash page table

Igor Russkikh <Igor.Russkikh@aquantia.com>
    net: aquantia: fixed instack structure overflow

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix invalid deref in FF_LAYOUT_DEVID_NODE()

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Add missing encode / decode sequence_maxsz to v4.2 operations

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix NULL pointer reference in intel_svm_bind_mm()

Jonas Gorski <jonas.gorski@gmail.com>
    hwrng: bcm2835 - fix probe as platform device

Eli Britstein <elibr@mellanox.com>
    net: sched: act_csum: Fix csum calc for tagged packets

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: bogus element self comparison from deactivation path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: fix lookups with fixed size hash on big endian

Surabhi Vishnoi <svishnoi@codeaurora.org>
    ath10k: Fix length of wmi tlv command for protected mgmt frames

Axel Lin <axel.lin@ingics.com>
    regulator: wm831x-dcdc: Fix list of wm831x_dcdc_ilim from mA to uA

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8849/1: NOMMU: Fix encodings for PMSAv8's PRBAR4/PRLAR4

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8848/1: virt: Align GIC version check with arm64 counterpart

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: 8847/1: pm: fix HYP/SVC mode mismatch when MCPM is used

Geert Uytterhoeven <geert+renesas@glider.be>
    iommu: Fix IOMMU debugfs fallout

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

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf, pt, coresight: Fix address filters for vmas with non-zero offset

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf: Copy parent's address filter offsets on clone

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a soft lockup in the delegation recovery code

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Fix logic when handling unknown CPU features

Nathan Chancellor <natechancellor@gmail.com>
    staging: rtlwifi: Use proper enum for return in halmac_parse_psd_data_88xx

Eric W. Biederman <ebiederm@xmission.com>
    fs/nfs: Fix nfs_parse_devname to not modify it's argument

Russell King <rmk+kernel@armlinux.org.uk>
    net: dsa: fix unintended change of bridge interface STP state

Takashi Iwai <tiwai@suse.de>
    ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Fix PM-runtime for links added during consumer probe

Colin Ian King <colin.king@canonical.com>
    drm/nouveau: fix missing break in switch statement

Colin Ian King <colin.king@canonical.com>
    drm/nouveau/pmu: don't print reply values if exec is false

Colin Ian King <colin.king@canonical.com>
    drm/nouveau/bios/ramcfg: fix missing parentheses when calculating RON

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Delete unused FPGA QPN variable

Vinod Koul <vkoul@kernel.org>
    net: dsa: qca8k: Enable delay for RGMII_ID mode

Axel Lin <axel.lin@ingics.com>
    regulator: pv88090: Fix array out-of-bounds access

Axel Lin <axel.lin@ingics.com>
    regulator: pv88080: Fix array out-of-bounds access

Axel Lin <axel.lin@ingics.com>
    regulator: pv88060: Fix array out-of-bounds access

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: create debugfs files for bus-specific layer

YueHaibing <yuehaibing@huawei.com>
    cdc-wdm: pass return value of recover_from_urb_loss

Robin Murphy <robin.murphy@arm.com>
    dmaengine: mv_xor: Use correct device for DMA API

Nicholas Mc Guire <hofrat@osadl.org>
    staging: r8822be: check kzalloc return or bail

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Release all hardware TCE tables attached to a group

YueHaibing <yuehaibing@huawei.com>
    mdio_bus: Fix PTR_ERR() usage after initialization to constant

Vadim Pasternak <vadimp@mellanox.com>
    hwmon: (pmbus/tps53679) Fix driver info initialization in probe routine

Eric Auger <eric.auger@redhat.com>
    vfio_pci: Enable memory accesses before calling pci_map_rom

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: sh: migor: Include missing dma-mapping header

Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
    mt76: usb: fix possible memory leak in mt76u_buf_free

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Do not program CPU port's PVID

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Properly account for VLAN filtering

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Fix default VLAN ID

David Howells <dhowells@redhat.com>
    keys: Timestamp new keys

Ming Lei <ming.lei@redhat.com>
    block: don't use bio->bi_vcnt to figure out segment number

Sven Van Asbroeck <thesven73@gmail.com>
    usb: phy: twl6030-usb: fix possible use-after-free on remove

Wen Yang <wen.yang99@zte.com.cn>
    PCI: endpoint: functions: Use memcpy_fromio()/memcpy_toio()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Fix possible supplier PM-usage counter imbalance

Mark Bloch <markb@mellanox.com>
    RDMA/mlx5: Fix memory leak in case we fail to add an IB device

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh73a0: Fix fsic_spdif pin groups

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7792: Fix vin1_data18_b pin group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: emev2: Add missing pinmux functions

Wesley Sheng <wesley.sheng@microchip.com>
    ntb_hw_switchtec: NT req id mapping table register entry number should be 512

Paul Selles <paul.selles@microchip.com>
    ntb_hw_switchtec: debug print 64bit aligned crosslink BAR Numbers

Dan Carpenter <dan.carpenter@oracle.com>
    drm/etnaviv: potential NULL dereference

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: add missing smp_rmb() in xsk_mmap

Nicholas Mc Guire <hofrat@osadl.org>
    ipmi: kcs_bmc: handle devm_kasprintf() failure case

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

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: original socket family in inet_sock_diag

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    rtc: ds1307: rx8130: Fix alarm handling

Moritz Fischer <mdf@kernel.org>
    net: phy: fixed_phy: Fix fixed_phy not checking GPIO

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: fix dma unmap direction for management frames

Niklas Cassel <niklas.cassel@linaro.org>
    arm64: dts: msm8916: remove bogus argument to the cpu clock

Michael Kao <michael.kao@mediatek.com>
    thermal: mediatek: fix register index error

Colin Ian King <colin.king@canonical.com>
    rtc: ds1672: fix unintended sign extension

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic: jz4740: Fix gating of UDC clock

Colin Ian King <colin.king@canonical.com>
    staging: most: cdev: add missing check for cdev_add failure

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: fix RSS config command

Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
    drm/xen-front: Fix mmap attributes for display buffers

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
    driver core: Do not call rpm_put_suppliers() in pm_runtime_drop_link()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Fix handling of runtime PM flags in device_link_add()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Do not resume suppliers under device_links_write_lock()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Avoid careless re-use of existing device links

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Fix DL_FLAG_AUTOREMOVE_SUPPLIER device link flag handling

Corentin Labbe <clabbe@baylibre.com>
    crypto: crypto4xx - Fix wrong ppc4xx_trng_probe()/ppc4xx_trng_remove() arguments

Liu Jian <liujian56@huawei.com>
    driver: uio: fix possible use-after-free in __uio_register_device

Liu Jian <liujian56@huawei.com>
    driver: uio: fix possible memory leak in __uio_register_device

YueHaibing <yuehaibing@huawei.com>
    tty: ipwireless: Fix potential NULL pointer dereference

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix timer handling with drop pm_runtime_irq_safe()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix A-MPDU reference assignment

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: h6: Move GIC device node fix base address ordering

wenxu <wenxu@ucloud.cn>
    ip_tunnel: Fix route fl4 init in ip_md_tunnel_xmit

Moni Shoua <monis@mellanox.com>
    net/mlx5: Take lock with IRQs disabled to avoid deadlock

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: avoid possible access out of array.

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: sun8i-a23: Enable PLL-MIPI LDOs when ungating it

Chen-Yu Tsai <wens@csie.org>
    ARM: dts: sun8i-a23-a33: Move NAND controller device node to sort by address

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix bug of ethtool_ops.get_channels for VF

YueHaibing <yuehaibing@huawei.com>
    spi/topcliff_pch: Fix potential NULL dereference on allocation error

Eric Wong <e@80x24.org>
    rtc: cmos: ignore bogus century byte

Maor Gottlieb <maorg@mellanox.com>
    IB/mlx5: Don't override existing ip_protocol

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: tw9910: Unregister subdevice with v4l2-async

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix wrong combined count returned by ethtool -l

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

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra: Don't invoke Tegra30+ specific memory timing setup on Tegra20

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ9031

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

Shakeel Butt <shakeelb@google.com>
    fork, memcg: fix cached_stacks case

Noralf Trønnes <noralf@tronnes.org>
    drm/fb-helper: generic: Fix setup error path

Dan Carpenter <dan.carpenter@oracle.com>
    drm/etnaviv: fix some off by one bugs

Biju Das <biju.das@bp.renesas.com>
    ARM: dts: r8a7743: Remove generic compatible string from iic3

YueHaibing <yuehaibing@huawei.com>
    drm: Fix error handling in drm_legacy_addctx

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom: q6v5-mss: Add missing regulator for MSM8996

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom: q6v5-mss: Add missing clocks for MSM8996

Stefan Wahren <stefan.wahren@i2se.com>
    arm64: defconfig: Re-enable bcm2835-thermal driver

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
    clk: ti: fix refcount leak in ti_dt_clocks_register()

Yangtao Li <tiny.windzz@gmail.com>
    clk: qoriq: fix refcount leak in clockgen_init()

Yangtao Li <tiny.windzz@gmail.com>
    clk: highbank: fix refcount leak in hb_clk_init()

Rik van Riel <riel@surriel.com>
    fork,memcg: fix crash in free_thread_stack on memcg charge fail

Dan Carpenter <dan.carpenter@oracle.com>
    Input: nomadik-ske-keypad - fix a loop timeout test

Petr Machata <petrm@mellanox.com>
    vxlan: changelink: Fix handling of default remotes

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix error handling int the hns3_get_vector_ring_chain

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Remove bogus IPSR10 value

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a77995: Remove bogus SEL_PWM[0-3]_3 configurations

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: sh7734: Add missing IPSR11 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a77980: Add missing MOD_SEL0 field

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: r8a77970: Add missing MOD_SEL0 field

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

Willem de Bruijn <willemb@google.com>
    ipv6: add missing tx timestamping on IPPROTO_RAW

Kelvin Cao <kelvin.cao@microchip.com>
    switchtec: Remove immediate status check after submitting MRPC command

Stefan Wahren <stefan.wahren@i2se.com>
    staging: bcm2835-camera: fix module autoloading

Stefan Wahren <stefan.wahren@i2se.com>
    staging: bcm2835-camera: Abort probe if there is no camera

Dan Carpenter <dan.carpenter@oracle.com>
    mailbox: ti-msgmgr: Off by one in ti_msgmgr_of_xlate()

Yuval Shaia <yuval.shaia@oracle.com>
    IB/rxe: Fix incorrect cache cleanup in error flow

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Fix missing debugfs supply directory for OPPs

Mitko Haralanov <mitko.haralanov@intel.com>
    IB/hfi1: Correctly process FECN and BECN in packets

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: phy: Fix not to call phy_resume() if PHY is not attached

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r8a7795-es1: Add missing power domains to IPMMU nodes

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gx: Add hdmi_5v regulator as hdmi tx supply

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Skip validating ports during destruction, just ref

Willem de Bruijn <willemb@google.com>
    net: always initialize pagedlen

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: Fix vblank initialization

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm: rcar-du: Fix the return value in case of error in 'rcar_du_crtc_set_crc_source()'

YueHaibing <yuehaibing@huawei.com>
    exportfs: fix 'passing zero to ERR_PTR()' warning

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Add mcasp optional clocks flag

Neil Armstrong <narmstrong@baylibre.com>
    pinctrl: meson-gxl: remove invalid GPIOX tsin_a pins

Vasily Khoruzhick <anarsoul@gmail.com>
    ASoC: sun8i-codec: add missing route for ADC

Colin Ian King <colin.king@canonical.com>
    pcrypt: use format specifier in kobject_add

Phil Elwell <phil@raspberrypi.org>
    ARM: dts: bcm283x: Correct mailbox register sizes

Arnd Bergmann <arnd@arndb.de>
    ASoC: wm97xx: fix uninitialized regmap pointer problem

Gustavo A. R. Silva <gustavo@embeddedor.com>
    NTB: ntb_hw_idt: replace IS_ERR_OR_NULL with regular NULL checks

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum: Set minimum shaper on MC TCs

Petr Machata <petrm@mellanox.com>
    mlxsw: reg: QEEC: Add minimum shaper fields

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: add error handler for hns3_nic_init_vector_data()

Maxime Ripard <maxime.ripard@bootlin.com>
    drm/sun4i: hdmi: Fix double flag assignation

Masahisa Kojima <masahisa.kojima@linaro.org>
    net: socionext: Add dummy PHY register read in phy_write()

Jon Maloy <jon.maloy@ericsson.com>
    tipc: eliminate message disordering during binding table update

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kgdb: add kgdb_arch_set/remove_breakpoint()

Taehee Yoo <ap420073@gmail.com>
    netfilter: nf_flow_table: do not remove offload when other netns's interface is down

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Add missing spin lock initialization

Colin Ian King <colin.king@canonical.com>
    rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version

YueHaibing <yuehaibing@huawei.com>
    powerpc/pseries/memory-hotplug: Fix return value type of find_aa_index

Hans de Goede <hdegoede@redhat.com>
    pwm: lpss: Release runtime-pm reference from the driver's remove callback

Fernando Fernandez Mancera <ffmancera@riseup.net>
    netfilter: nft_osf: usage from output path is not valid

Spencer E. Olson <olsonse@umich.edu>
    staging: comedi: ni_mio_common: protect register write overflow

Naftali Goldstein <naftali.goldstein@intel.com>
    iwlwifi: nvm: get num of hw addresses from firmware

Nicolas Huaman <nicolas@herochao.de>
    ALSA: usb-audio: update quirk for B&W PX to remove microphone

Rob Herring <robh@kernel.org>
    of: Fix property name in of_node_get_device_type

Colin Ian King <colin.king@canonical.com>
    drm/msm: fix unsigned comparison with less than zero

Tomas Winkler <tomas.winkler@intel.com>
    mei: replace POLL* with EPOLL* for write queues.

Linus Walleij <linus.walleij@linaro.org>
    regulator: fixed: Default enable high on DT regulators

Johannes Berg <johannes.berg@intel.com>
    cfg80211: regulatory: make initialization more robust

Nicholas Mc Guire <hofrat@osadl.org>
    usb: gadget: fsl_udc_core: check allocation return value and cleanup on failure

Arnd Bergmann <arnd@arndb.de>
    usb: dwc3: add EXTCON dependency for qcom

Marc Zyngier <marc.zyngier@arm.com>
    genirq/debugfs: Reinstate full OF path for domain name

Alex Estrin <alex.estrin@intel.com>
    IB/hfi1: Add mtu check for operational data VLs

Zhu Yanjun <yanjun.zhu@oracle.com>
    IB/rxe: replace kvfree with vfree

Houlong Wei <houlong.wei@mediatek.com>
    mailbox: mediatek: Add check for possible failure of kzalloc

Arnd Bergmann <arnd@arndb.de>
    ASoC: wm9712: fix unused variable warning

Eric W. Biederman <ebiederm@xmission.com>
    signal/ia64: Use the force_sig(SIGSEGV,...) in ia64_rt_sigreturn

Eric W. Biederman <ebiederm@xmission.com>
    signal/ia64: Use the generic force_sigsegv in setup_frame

John Garry <john.garry@huawei.com>
    drm/hisilicon: hibmc: Don't overwrite fb helper surface depth

Roopa Prabhu <roopa@cumulusnetworks.com>
    bridge: br_arp_nd_proxy: set icmp6_router if neigh has NTF_ROUTER

Jitendra Bhivare <jitendra.bhivare@broadcom.com>
    PCI: iproc: Remove PAXC slot check to allow VF support

Stephen Boyd <swboyd@chromium.org>
    firmware: coreboot: Let OF core populate platform device

Frank Rowand <frank.rowand@sony.com>
    ARM: qcom_defconfig: Enable MAILBOX

Jann Horn <jannh@google.com>
    apparmor: don't try to replace stale label in ptrace access check

Anders Roxell <anders.roxell@linaro.org>
    ALSA: hda: fix unused variable warning

Tony Jones <tonyj@suse.de>
    apparmor: Fix network performance issue in aa_label_sk_perm

Eugen Hristev <eugen.hristev@microchip.com>
    iio: fix position relative kernel version

Dan Carpenter <dan.carpenter@oracle.com>
    drm/virtio: fix bounds check in virtio_gpu_cmd_get_capset()

Shannon Nelson <shannon.nelson@oracle.com>
    ixgbe: don't clear IPsec sa counters on HW clearing

Peter Rosin <peda@axentia.se>
    ARM: dts: at91: nattis: make the SD-card slot work

Peter Rosin <peda@axentia.se>
    ARM: dts: at91: nattis: set the PRLUD and HIPOW signals low

Peter Rosin <peda@axentia.se>
    drm/sti: do not remove the drm_bridge that was never added

Navid Emamdoost <navid.emamdoost@gmail.com>
    ipmi: Fix memory leak in __ipmi_bmc_register

Shuiqing Li <shuiqing.li@unisoc.com>
    watchdog: sprd: Fix the incorrect pointer getting from driver data

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    soc: aspeed: Fix snoop_file_poll()'s return type

Jean-Jacques Hiblot <jjhiblot@ti.com>
    leds: tlc591xx: update the maximum brightness

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf map: No need to adjust the long name of modules

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - fix big endian issues

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix bbp version check in mt7601u_wait_bbp_ready

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix wrong timeout input for tipc_wait_for_cond()

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: update mon's self addr when node addr generated

Ard Biesheuvel <ardb@kernel.org>
    powerpc/archrandom: fix arch_get_random_seed_int()

Tyrel Datwyler <tyreld@linux.ibm.com>
    powerpc/pseries: Enable support for ibm,drc-info property

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix svcauth_gss_proxy_init()

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    mfd: intel-lpss: Add default I2C device properties for Gemini Lake

Alain Volmat <alain.volmat@st.com>
    i2c: i2c-stm32f7: fix 10-bits check in slave free id search loop

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: rework slave_id allocation

Jan Kara <jack@suse.cz>
    xfs: Sanity check flags of Q_XQUOTARM call

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "efi: Fix debugobjects warning on 'efi_rts_work'"


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-iio            |   2 +-
 Documentation/devicetree/bindings/bus/ti-sysc.txt  |   1 +
 .../devicetree/bindings/rng/omap3_rom_rng.txt      |  27 ++
 Makefile                                           |   8 +-
 arch/arm/boot/dts/aspeed-g5.dtsi                   |   2 +-
 arch/arm/boot/dts/at91-nattis-2-natte-2.dts        |   7 +-
 arch/arm/boot/dts/bcm2835-rpi.dtsi                 |   2 +-
 arch/arm/boot/dts/iwg20d-q7-common.dtsi            |   2 +-
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi    |   2 +-
 arch/arm/boot/dts/logicpd-som-lv.dtsi              |  26 +-
 arch/arm/boot/dts/lpc3250-phy3250.dts              |   4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |  10 +-
 arch/arm/boot/dts/ls1021a-twr.dts                  |   9 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |  11 +-
 arch/arm/boot/dts/omap3-n900.dts                   |   6 +
 arch/arm/boot/dts/r8a7743.dtsi                     |   4 +-
 arch/arm/boot/dts/stm32h743i-eval.dts              |   1 +
 arch/arm/boot/dts/sun8i-a23-a33.dtsi               |  30 +-
 arch/arm/boot/dts/sun8i-h3-beelink-x2.dts          |   4 +
 arch/arm/boot/dts/sun9i-a80-optimus.dts            |   4 +-
 arch/arm/common/mcpm_entry.c                       |   2 +-
 arch/arm/configs/qcom_defconfig                    |   1 +
 arch/arm/include/asm/suspend.h                     |   1 +
 arch/arm/kernel/head-nommu.S                       |   4 +-
 arch/arm/kernel/hyp-stub.S                         |   4 +-
 arch/arm/kernel/sleep.S                            |  12 +
 arch/arm/kernel/vdso.c                             |   1 -
 arch/arm/mach-omap2/omap_hwmod.c                   |   2 +-
 arch/arm/mach-omap2/pdata-quirks.c                 |  12 +-
 arch/arm/mach-rpc/irq.c                            |   3 +-
 arch/arm/mach-stm32/Kconfig                        |   3 +-
 arch/arm/plat-pxa/ssp.c                            |   6 -
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   3 +-
 .../boot/dts/allwinner/sun50i-h6-pine-h64.dts      |   2 +
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |  22 +-
 .../arm64/boot/dts/amlogic/meson-gx-p23x-q20x.dtsi |   1 +
 .../dts/amlogic/meson-gxl-s905x-khadas-vim.dts     |   1 +
 .../dts/amlogic/meson-gxl-s905x-libretech-cc.dts   |   2 +-
 .../boot/dts/amlogic/meson-gxl-s905x-p212.dts      |   1 +
 .../boot/dts/amlogic/meson-gxm-khadas-vim2.dts     |  17 +-
 arch/arm64/boot/dts/arm/juno-clocks.dtsi           |   4 +-
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi          |   2 +
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   8 +-
 arch/arm64/boot/dts/renesas/r8a7795-es1.dtsi       |   2 +
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts     |   1 -
 arch/arm64/boot/dts/renesas/r8a77995.dtsi          |   2 +-
 arch/arm64/configs/defconfig                       |   1 +
 arch/arm64/kernel/hibernate.c                      |   9 +-
 arch/arm64/kernel/vdso.c                           |   2 -
 arch/ia64/kernel/signal.c                          |  60 +--
 arch/m68k/amiga/cia.c                              |   9 +
 arch/m68k/atari/ataints.c                          |   4 +-
 arch/m68k/atari/time.c                             |  15 +-
 arch/m68k/bvme6000/config.c                        |  20 +-
 arch/m68k/hp300/time.c                             |  10 +-
 arch/m68k/mac/via.c                                | 119 +++---
 arch/m68k/mvme147/config.c                         |  18 +-
 arch/m68k/mvme16x/config.c                         |  21 +-
 arch/m68k/q40/q40ints.c                            |  19 +-
 arch/m68k/sun3/sun3ints.c                          |   3 +
 arch/m68k/sun3x/time.c                             |  16 +-
 arch/mips/bcm63xx/Makefile                         |   6 +-
 arch/mips/bcm63xx/boards/board_bcm963xx.c          |  20 -
 arch/mips/bcm63xx/dev-dsp.c                        |  56 ---
 arch/mips/include/asm/io.h                         |  14 +-
 .../include/asm/mach-bcm63xx/bcm63xx_dev_dsp.h     |  14 -
 .../mips/include/asm/mach-bcm63xx/board_bcm963xx.h |   5 -
 arch/mips/kernel/setup.c                           |   2 +-
 arch/nios2/kernel/nios2_ksyms.c                    |  12 +
 arch/powerpc/Makefile                              |   2 +
 arch/powerpc/include/asm/archrandom.h              |   2 +-
 arch/powerpc/include/asm/kgdb.h                    |   5 +-
 arch/powerpc/kernel/cacheinfo.c                    |  21 ++
 arch/powerpc/kernel/cacheinfo.h                    |   4 +
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |  17 +-
 arch/powerpc/kernel/kgdb.c                         |  43 ++-
 arch/powerpc/kernel/mce_power.c                    |  20 +-
 arch/powerpc/kernel/prom_init.c                    |   2 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |   1 -
 arch/powerpc/kvm/book3s_hv.c                       |  15 +-
 arch/powerpc/mm/dump_hashpagetable.c               |   2 +-
 arch/powerpc/mm/pgtable-radix.c                    |   4 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  61 ++-
 arch/powerpc/platforms/pseries/mobility.c          |  10 +
 arch/s390/kernel/kexec_elf.c                       |   2 +-
 arch/sh/boards/mach-migor/setup.c                  |   1 +
 arch/um/drivers/chan_kern.c                        |  52 ++-
 arch/um/include/asm/irq.h                          |   2 +-
 arch/um/kernel/irq.c                               |   4 +
 arch/x86/Kconfig.debug                             |   2 +-
 arch/x86/events/intel/pt.c                         |   9 +-
 arch/x86/include/asm/pgtable_32.h                  |   2 +-
 arch/x86/kernel/kgdb.c                             |   2 +-
 arch/x86/mm/tlb.c                                  |   3 -
 block/blk-merge.c                                  |   8 +-
 crypto/pcrypt.c                                    |   2 +-
 crypto/tgr192.c                                    |   6 +-
 drivers/acpi/acpi_lpss.c                           | 111 +++++-
 drivers/acpi/button.c                              |   5 +-
 drivers/acpi/device_pm.c                           |  94 ++---
 drivers/ata/libahci.c                              |   1 -
 drivers/base/core.c                                |  88 +++--
 drivers/base/power/runtime.c                       |  40 +-
 drivers/base/power/wakeup.c                        |   2 +-
 drivers/bcma/driver_pci.c                          |   4 +-
 drivers/block/drbd/drbd_main.c                     |   2 +
 drivers/block/rbd.c                                |   1 +
 drivers/bus/ti-sysc.c                              |  18 +-
 drivers/char/hw_random/bcm2835-rng.c               |  18 +-
 drivers/char/hw_random/omap3-rom-rng.c             |  17 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   5 +-
 drivers/char/ipmi/kcs_bmc.c                        |   5 +-
 drivers/clk/actions/owl-factor.c                   |   7 +-
 drivers/clk/clk-highbank.c                         |   1 +
 drivers/clk/clk-qoriq.c                            |   1 +
 drivers/clk/imx/clk-imx6q.c                        |   1 +
 drivers/clk/imx/clk-imx6sx.c                       |   1 +
 drivers/clk/imx/clk-imx7d.c                        |   1 +
 drivers/clk/imx/clk-vf610.c                        |   1 +
 drivers/clk/ingenic/jz4740-cgu.c                   |   2 +-
 drivers/clk/meson/axg.c                            |  10 +-
 drivers/clk/meson/gxbb.c                           |   5 -
 drivers/clk/mvebu/armada-370.c                     |   4 +-
 drivers/clk/mvebu/armada-xp.c                      |   4 +-
 drivers/clk/mvebu/dove.c                           |   8 +-
 drivers/clk/mvebu/kirkwood.c                       |   2 +
 drivers/clk/mvebu/mv98dx3236.c                     |   4 +-
 drivers/clk/qcom/gcc-msm8996.c                     |  36 --
 drivers/clk/qcom/gcc-msm8998.c                     |   2 +-
 drivers/clk/samsung/clk-exynos4.c                  |   1 +
 drivers/clk/socfpga/clk-pll-a10.c                  |   1 +
 drivers/clk/socfpga/clk-pll.c                      |   1 +
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c             |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |  19 +-
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h               |   6 +-
 drivers/clk/ti/clk.c                               |   8 +-
 drivers/clocksource/exynos_mct.c                   |  14 +-
 drivers/clocksource/timer-sun5i.c                  |  10 +
 drivers/clocksource/timer-ti-dm.c                  |   1 -
 drivers/cpufreq/brcmstb-avs-cpufreq.c              |  12 +-
 drivers/crypto/amcc/crypto4xx_trng.h               |   4 +-
 drivers/crypto/bcm/cipher.c                        |   6 +-
 drivers/crypto/caam/caamrng.c                      |   5 +-
 drivers/crypto/caam/error.c                        |   2 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |   8 +-
 drivers/crypto/ccp/ccp-ops.c                       |  67 ++--
 drivers/crypto/ccree/cc_cipher.c                   |   2 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |  44 +--
 drivers/crypto/inside-secure/safexcel_hash.c       |  10 +-
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  21 +-
 drivers/crypto/talitos.c                           | 158 +++-----
 drivers/crypto/talitos.h                           |   2 +-
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/dma/dw/platform.c                          |  14 +-
 drivers/dma/hsu/hsu.c                              |   4 +-
 drivers/dma/imx-sdma.c                             |   8 +
 drivers/dma/mv_xor.c                               |   2 +-
 drivers/dma/tegra210-adma.c                        |  72 +++-
 drivers/dma/ti/edma.c                              |   6 +-
 drivers/edac/edac_mc.c                             |  12 +-
 drivers/firmware/arm_scmi/clock.c                  |   2 +
 drivers/firmware/arm_scmi/driver.c                 |   4 +-
 drivers/firmware/arm_scmi/sensors.c                |   4 +-
 drivers/firmware/dmi_scan.c                        |   2 +-
 drivers/firmware/efi/runtime-wrappers.c            |   2 +-
 drivers/firmware/google/coreboot_table-of.c        |  28 +-
 drivers/fsi/fsi-core.c                             |  32 +-
 drivers/fsi/fsi-sbefifo.c                          |   4 +-
 drivers/gpio/gpio-aspeed.c                         |   2 +-
 drivers/gpu/drm/drm_context.c                      |  15 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  15 +-
 drivers/gpu/drm/drm_fb_helper.c                    | 102 ++---
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c        |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c          |   6 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c  |   1 -
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  24 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c           |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   6 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/gddr3.c     |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/memx.c     |   4 +-
 drivers/gpu/drm/panel/panel-lvds.c                 |  21 +-
 drivers/gpu/drm/radeon/cik.c                       |   4 +-
 drivers/gpu/drm/radeon/r600.c                      |   4 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |   2 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |   2 +-
 drivers/gpu/drm/rcar-du/rcar_lvds.c                |   8 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |   4 +-
 drivers/gpu/drm/sti/sti_hda.c                      |   1 -
 drivers/gpu/drm/sti/sti_hdmi.c                     |   1 -
 drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c        |   2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c             |   6 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c            |  13 +-
 drivers/hwmon/lm75.c                               |   2 +-
 drivers/hwmon/pmbus/tps53679.c                     |   9 +-
 drivers/hwmon/shtc1.c                              |   2 +-
 drivers/hwmon/w83627hf.c                           |  42 ++-
 drivers/hwtracing/coresight/coresight-catu.h       |   5 -
 drivers/hwtracing/coresight/coresight-etm-perf.c   |   7 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |   5 +-
 drivers/i2c/busses/i2c-stm32.c                     |  16 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  13 +-
 drivers/iio/dac/ad5380.c                           |   2 +-
 drivers/iio/light/tsl2772.c                        |  16 +-
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/core/uverbs_uapi.c              |   2 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   1 +
 drivers/infiniband/hw/cxgb4/cm.c                   |  24 +-
 drivers/infiniband/hw/hfi1/chip.c                  |  26 +-
 drivers/infiniband/hw/hfi1/driver.c                |  70 ++--
 drivers/infiniband/hw/hfi1/hfi.h                   |  35 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   5 +-
 drivers/infiniband/hw/hfi1/rc.c                    |  32 +-
 drivers/infiniband/hw/hfi1/uc.c                    |   2 +-
 drivers/infiniband/hw/hfi1/ud.c                    |  33 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  19 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   6 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   1 -
 drivers/infiniband/hw/mlx5/ib_rep.c                |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |  53 ++-
 drivers/infiniband/hw/mlx5/qp.c                    |  21 ++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   2 +-
 drivers/infiniband/hw/qedr/verbs.c                 |  27 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   2 +-
 drivers/infiniband/sw/rxe/rxe_cq.c                 |   4 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   3 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |  26 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   5 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   2 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |  10 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |   2 +-
 drivers/iommu/amd_iommu.c                          |   2 +
 drivers/iommu/amd_iommu_init.c                     |   3 +
 drivers/iommu/intel-iommu.c                        |  39 +-
 drivers/iommu/intel-svm.c                          |   2 +-
 drivers/iommu/iommu-debugfs.c                      |  23 +-
 drivers/iommu/iommu.c                              |   8 +-
 drivers/iommu/mtk_iommu.c                          |  26 +-
 drivers/leds/led-triggers.c                        |   4 +-
 drivers/leds/leds-tlc591xx.c                       |   7 +-
 drivers/lightnvm/pblk-rb.c                         |   2 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   3 +
 drivers/mailbox/qcom-apcs-ipc-mailbox.c            |   2 +-
 drivers/mailbox/ti-msgmgr.c                        |   2 +-
 drivers/md/bcache/debug.c                          |   5 +-
 drivers/media/i2c/ov2659.c                         |   2 +-
 drivers/media/i2c/tw9910.c                         |   2 +-
 drivers/media/pci/cx18/cx18-fileops.c              |   2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   5 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |   2 +-
 drivers/media/pci/pt1/pt1.c                        |  54 ++-
 drivers/media/pci/tw5864/tw5864-video.c            |   4 +-
 drivers/media/platform/atmel/atmel-isi.c           |   2 +-
 drivers/media/platform/davinci/isif.c              |   9 -
 drivers/media/platform/davinci/vpbe.c              |   2 +-
 drivers/media/platform/omap/omap_vout.c            |  15 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   2 +-
 drivers/media/platform/vivid/vivid-osd.c           |   2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   5 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   2 +-
 drivers/memory/tegra/mc.c                          |  11 +-
 drivers/mfd/intel-lpss-pci.c                       |  28 +-
 drivers/mfd/intel-lpss.c                           |   1 +
 drivers/misc/aspeed-lpc-snoop.c                    |   4 +-
 drivers/misc/mei/main.c                            |   4 +-
 drivers/misc/mic/card/mic_x100.c                   |  28 +-
 drivers/misc/sgi-xp/xpc_partition.c                |   2 +-
 drivers/mmc/core/host.c                            |   2 -
 drivers/mmc/core/quirks.h                          |   7 +
 drivers/mmc/host/sdhci-brcmstb.c                   |   4 +-
 drivers/net/dsa/b53/b53_common.c                   |  90 ++++-
 drivers/net/dsa/b53/b53_priv.h                     |   3 +
 drivers/net/dsa/qca8k.c                            |  12 +
 drivers/net/dsa/qca8k.h                            |   1 +
 drivers/net/ethernet/amazon/ena/ena_com.c          |   3 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |  15 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c  |   4 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |   4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  20 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/smt.c           |   4 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  47 +--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  17 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  21 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   5 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |  91 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   4 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  11 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/core.c    |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   5 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  22 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  25 ++
 drivers/net/ethernet/natsemi/sonic.c               |   6 +-
 drivers/net/ethernet/netronome/nfp/bpf/jit.c       |  13 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  |   2 +-
 drivers/net/ethernet/ni/nixge.c                    |   2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |  17 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |  34 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |   9 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   1 +
 drivers/net/ethernet/renesas/sh_eth.c              |   6 +-
 drivers/net/ethernet/socionext/netsec.c            |  20 +-
 drivers/net/ethernet/socionext/sni_ave.c           |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +-
 drivers/net/hyperv/hyperv_net.h                    |   3 +-
 drivers/net/hyperv/netvsc.c                        |  38 +-
 drivers/net/hyperv/netvsc_drv.c                    |  13 +-
 drivers/net/phy/fixed_phy.c                        |   6 +-
 drivers/net/phy/mdio_bus.c                         |  11 +-
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/phy/phy_device.c                       |  13 +-
 drivers/net/vxlan.c                                |   7 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |  29 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath9k/dynack.c            |   8 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             | 186 ++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  12 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  19 +-
 drivers/net/wireless/marvell/libertas_tf/cmd.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  14 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |   2 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  71 +---
 drivers/ntb/hw/idt/ntb_hw_idt.c                    |   8 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c             |   4 +-
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvmem/imx-ocotp.c                          |  39 +-
 drivers/of/of_mdio.c                               |   2 +-
 drivers/opp/core.c                                 |  12 +-
 drivers/opp/of.c                                   |  20 +-
 drivers/opp/opp.h                                  |   6 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  10 +-
 drivers/pci/controller/pcie-iproc.c                |  10 +-
 drivers/pci/controller/pcie-mobiveil.c             |   8 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   4 +-
 drivers/pci/pci-driver.c                           |  60 ++-
 drivers/pci/pci.c                                  |  54 ++-
 drivers/pci/switch/switchtec.c                     |   4 -
 drivers/phy/broadcom/phy-brcm-usb.c                |   8 +
 drivers/phy/qualcomm/phy-qcom-qusb2.c              |   2 +-
 drivers/pinctrl/bcm/pinctrl-iproc-gpio.c           |  96 ++++-
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  12 +-
 drivers/pinctrl/sh-pfc/pfc-emev2.c                 |  20 +
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c               |   3 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c               |   8 +-
 drivers/pinctrl/sh-pfc/pfc-r8a7792.c               |   1 +
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c               |   2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a77970.c              |   2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a77980.c              |   2 +-
 drivers/pinctrl/sh-pfc/pfc-r8a77995.c              |   8 +-
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                |   2 +-
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c                |   4 +-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |   4 +-
 drivers/platform/mips/cpu_hwmon.c                  |   2 +-
 drivers/platform/x86/alienware-wmi.c               |  19 +-
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
 drivers/remoteproc/qcom_q6v5_pil.c                 |  12 +-
 drivers/rtc/rtc-88pm80x.c                          |  21 +-
 drivers/rtc/rtc-88pm860x.c                         |  21 +-
 drivers/rtc/rtc-ds1307.c                           |   7 +-
 drivers/rtc/rtc-ds1672.c                           |   3 +-
 drivers/rtc/rtc-mc146818-lib.c                     |   2 +-
 drivers/rtc/rtc-mt6397.c                           |   9 +-
 drivers/rtc/rtc-pcf2127.c                          |  32 +-
 drivers/rtc/rtc-pcf8563.c                          |  13 +-
 drivers/rtc/rtc-pm8xxx.c                           |   6 +-
 drivers/rtc/rtc-rv3029c2.c                         |  16 +-
 drivers/s390/net/qeth_l2_main.c                    |  23 +-
 drivers/scsi/fnic/fnic_isr.c                       |   4 +-
 drivers/scsi/libfc/fc_exch.c                       |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  34 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  21 +-
 drivers/soc/amlogic/meson-gx-pwrc-vpu.c            |   8 +-
 drivers/soc/amlogic/meson-gx-socinfo.c             |  32 +-
 drivers/soc/fsl/qe/gpio.c                          |   4 +-
 drivers/soc/qcom/cmd-db.c                          |   4 +-
 drivers/spi/spi-bcm-qspi.c                         |   4 +-
 drivers/spi/spi-bcm2835aux.c                       |  13 +-
 drivers/spi/spi-cadence.c                          |  11 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-tegra114.c                         | 145 ++++++--
 drivers/spi/spi-topcliff-pch.c                     |   6 +
 drivers/staging/android/vsoc.c                     |   3 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |  24 +-
 drivers/staging/greybus/light.c                    |  12 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  10 +-
 drivers/staging/most/cdev/cdev.c                   |   5 +-
 .../rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c  |   5 +-
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |  10 +
 drivers/target/target_core_device.c                |   4 +-
 drivers/thermal/cpu_cooling.c                      |   2 +-
 drivers/thermal/mtk_thermal.c                      |   6 +-
 drivers/thermal/rcar_gen3_thermal.c                |  38 +-
 drivers/tty/ipwireless/hardware.c                  |   2 +
 drivers/tty/serial/fsl_lpuart.c                    |  28 +-
 drivers/tty/serial/stm32-usart.c                   | 194 ++++++----
 drivers/tty/serial/stm32-usart.h                   |  14 +-
 drivers/uio/uio.c                                  |  10 +-
 drivers/usb/class/cdc-wdm.c                        |   2 +-
 drivers/usb/dwc2/gadget.c                          |   1 +
 drivers/usb/dwc3/Kconfig                           |   4 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |  30 +-
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/phy/Kconfig                            |   2 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   2 +-
 drivers/usb/typec/Kconfig                          |   1 +
 drivers/usb/typec/fusb302/fusb302.c                |  10 +-
 drivers/usb/typec/tcpci.c                          |  10 +-
 drivers/usb/typec/tcpm.c                           |  32 +-
 drivers/usb/typec/typec_wcove.c                    |  10 +-
 drivers/vfio/mdev/mdev_core.c                      |  11 +-
 drivers/vfio/mdev/mdev_sysfs.c                     |   2 +-
 drivers/vfio/pci/vfio_pci.c                        |  19 +-
 drivers/vhost/test.c                               |   2 +
 drivers/video/backlight/lm3630a_bl.c               |   4 +-
 drivers/video/backlight/pwm_bl.c                   |  24 +-
 drivers/video/fbdev/chipsfb.c                      |   3 +-
 drivers/watchdog/rtd119x_wdt.c                     |   2 +-
 drivers/watchdog/sprd_wdt.c                        |   6 +-
 drivers/xen/cpu_hotplug.c                          |   2 +-
 drivers/xen/pvcalls-back.c                         |   2 +-
 fs/affs/super.c                                    |   6 -
 fs/afs/callback.c                                  |   8 +-
 fs/afs/dir_edit.c                                  |  12 +-
 fs/afs/file.c                                      |   7 +-
 fs/afs/flock.c                                     | 412 ++++++++++-----------
 fs/afs/inode.c                                     |   8 +-
 fs/afs/rxrpc.c                                     |   1 +
 fs/afs/security.c                                  |   4 +-
 fs/afs/super.c                                     |   1 +
 fs/afs/xattr.c                                     |   4 +-
 fs/btrfs/file.c                                    |   3 +-
 fs/btrfs/inode-map.c                               |  28 +-
 fs/ceph/xattr.c                                    |   2 +-
 fs/cifs/connect.c                                  |   3 +-
 fs/exportfs/expfs.c                                |   1 +
 fs/ext4/inline.c                                   |   2 +-
 fs/f2fs/dir.c                                      |   5 +
 fs/f2fs/f2fs.h                                     |   3 +-
 fs/f2fs/inline.c                                   |   6 +
 fs/jfs/jfs_txnmgr.c                                |   3 +-
 fs/nfs/delegation.c                                |  20 +-
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/flexfilelayout/flexfilelayout.h             |  32 +-
 fs/nfs/nfs42xdr.c                                  |  10 +
 fs/nfs/pnfs.c                                      |  33 +-
 fs/nfs/pnfs.h                                      |   1 +
 fs/nfs/super.c                                     |   2 +-
 fs/nfs/write.c                                     |   2 +-
 fs/xfs/xfs_quotaops.c                              |   3 +
 include/drm/drm_panel.h                            |   1 +
 include/linux/acpi.h                               |  12 +-
 include/linux/device.h                             |   6 +-
 include/linux/irqchip/arm-gic-v3.h                 |  12 +-
 include/linux/mlx5/mlx5_ifc.h                      |   2 -
 include/linux/mmc/sdio_ids.h                       |   2 +
 include/linux/of.h                                 |   5 +-
 include/linux/pci.h                                |   1 +
 include/linux/perf_event.h                         |   7 +-
 include/linux/platform_data/dma-imx-sdma.h         |   3 +
 include/linux/rtc.h                                |   2 +-
 include/linux/signal.h                             |  15 +-
 include/linux/switchtec.h                          |   4 +-
 include/linux/usb/tcpm.h                           |  13 +-
 include/media/davinci/vpbe.h                       |   2 +-
 include/net/request_sock.h                         |   4 +-
 include/net/sctp/sctp.h                            |   5 +
 include/net/tcp.h                                  |   2 +-
 include/net/xfrm.h                                 |   1 -
 include/sound/soc.h                                |   2 +-
 include/trace/events/rxrpc.h                       |   6 +-
 include/uapi/linux/btf.h                           |   4 +-
 include/uapi/linux/netfilter/nf_tables.h           |   2 +-
 kernel/bpf/offload.c                               |   4 +-
 kernel/bpf/verifier.c                              |   2 +-
 kernel/debug/kdb/kdb_main.c                        |   2 +-
 kernel/events/core.c                               | 126 ++++---
 kernel/fork.c                                      |  16 +-
 kernel/irq/irqdomain.c                             |   3 +-
 kernel/signal.c                                    |   5 +
 lib/devres.c                                       |   3 +-
 lib/kfifo.c                                        |   3 +-
 net/6lowpan/nhc.c                                  |   2 +-
 net/bpfilter/bpfilter_kern.c                       |   2 +-
 net/bridge/br_arp_nd_proxy.c                       |   2 +-
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/core/dev.c                                     |  73 ++--
 net/core/filter.c                                  |   2 +-
 net/core/neighbour.c                               |   4 +-
 net/core/sock.c                                    |   4 +-
 net/dsa/port.c                                     |   7 +-
 net/dsa/slave.c                                    |   8 +-
 net/ieee802154/6lowpan/reassembly.c                |   2 +-
 net/ipv4/af_inet.c                                 |   2 +-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/ip_output.c                               |   3 +-
 net/ipv4/ip_tunnel.c                               |   5 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/udp_offload.c                             |   5 +
 net/ipv6/ip6_fib.c                                 |   3 +-
 net/ipv6/ip6_gre.c                                 |   1 +
 net/ipv6/ip6_output.c                              |   3 +-
 net/ipv6/raw.c                                     |   2 +
 net/ipv6/reassembly.c                              |   2 +-
 net/iucv/af_iucv.c                                 |  40 +-
 net/l2tp/l2tp_core.c                               |   3 +-
 net/llc/af_llc.c                                   |  34 +-
 net/llc/llc_conn.c                                 |  35 +-
 net/llc/llc_if.c                                   |  12 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   2 +-
 net/mac80211/rx.c                                  |  11 +-
 net/mpls/mpls_iptunnel.c                           |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |   7 +-
 net/netfilter/nf_flow_table_core.c                 |   9 +-
 net/netfilter/nft_flow_offload.c                   |   3 +-
 net/netfilter/nft_osf.c                            |  10 +
 net/netfilter/nft_set_hash.c                       |  25 +-
 net/packet/af_packet.c                             |  25 +-
 net/rds/ib_stats.c                                 |   2 +-
 net/rds/stats.c                                    |   2 +
 net/rxrpc/af_rxrpc.c                               |   3 -
 net/rxrpc/ar-internal.h                            |   2 +
 net/rxrpc/call_accept.c                            |   2 +-
 net/rxrpc/conn_client.c                            |  50 ++-
 net/rxrpc/conn_object.c                            |  15 +-
 net/rxrpc/conn_service.c                           |   2 +-
 net/rxrpc/input.c                                  |  18 +-
 net/rxrpc/local_object.c                           |   5 +-
 net/rxrpc/output.c                                 |   3 +
 net/sched/act_csum.c                               |  31 +-
 net/sched/act_mirred.c                             |   6 +-
 net/sched/sch_cbs.c                                | 108 +++++-
 net/sched/sch_netem.c                              |  18 +-
 net/sctp/input.c                                   |  12 +-
 net/smc/smc_diag.c                                 |   3 +-
 net/smc/smc_rx.c                                   |  29 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  84 +++--
 net/sunrpc/xprtrdma/verbs.c                        |   3 +-
 net/tipc/link.c                                    |  29 +-
 net/tipc/monitor.c                                 |  15 +
 net/tipc/monitor.h                                 |   1 +
 net/tipc/name_distr.c                              |  18 +-
 net/tipc/name_table.c                              |   1 +
 net/tipc/name_table.h                              |   1 +
 net/tipc/net.c                                     |   2 +
 net/tipc/node.c                                    |   7 +-
 net/tipc/socket.c                                  |   2 +-
 net/tipc/sysctl.c                                  |   8 +-
 net/tls/tls_device_fallback.c                      |   4 +
 net/wireless/reg.c                                 |   9 +
 net/xdp/xdp_umem.c                                 |   6 +
 net/xdp/xsk.c                                      |  21 +-
 net/xfrm/xfrm_interface.c                          |  10 +-
 samples/bpf/xdp_rxq_info_user.c                    |   6 +-
 security/apparmor/include/cred.h                   |   2 +
 security/apparmor/lsm.c                            |   4 +-
 security/apparmor/net.c                            |  15 +-
 security/keys/key.c                                |   1 +
 sound/aoa/codecs/onyx.c                            |   4 +-
 sound/pci/hda/hda_controller.h                     |   9 +-
 sound/sh/aica.c                                    |  14 +-
 sound/soc/codecs/cs4349.c                          |   1 +
 sound/soc/codecs/es8328.c                          |   2 +-
 sound/soc/codecs/wm8737.c                          |   2 +-
 sound/soc/codecs/wm9705.c                          |  10 +-
 sound/soc/codecs/wm9712.c                          |  13 +-
 sound/soc/codecs/wm9713.c                          |  10 +-
 sound/soc/davinci/davinci-mcasp.c                  |  13 +-
 sound/soc/fsl/imx-sgtl5000.c                       |   3 +-
 sound/soc/meson/axg-tdmin.c                        |   1 -
 sound/soc/meson/axg-tdmout.c                       |   1 -
 sound/soc/qcom/apq8016_sbc.c                       |  21 +-
 sound/soc/soc-pcm.c                                |   4 +-
 sound/soc/sunxi/sun4i-i2s.c                        |   4 +-
 sound/soc/sunxi/sun8i-codec.c                      |   6 +-
 sound/usb/mixer.c                                  |   4 +-
 sound/usb/quirks-table.h                           |   9 +-
 tools/bpf/bpftool/btf_dumper.c                     |   8 +-
 tools/bpf/bpftool/cgroup.c                         |   6 +-
 tools/bpf/bpftool/map_perf_ring.c                  |   4 +-
 tools/perf/util/machine.c                          |  27 +-
 tools/testing/selftests/ipc/msgque.c               |  11 +-
 629 files changed, 4721 insertions(+), 3155 deletions(-)


