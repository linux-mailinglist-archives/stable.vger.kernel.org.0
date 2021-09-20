Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4D2411B71
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344334AbhITQ6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343761AbhITQ4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0FF761264;
        Mon, 20 Sep 2021 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156693;
        bh=cp+/qTRAPORbKiOOq1OmVn9cGVovlVCCk/wY1NA4eMI=;
        h=From:To:Cc:Subject:Date:From;
        b=RBoVVNkIB3kd4r5VKKJPc9xEXGHvbvfkmstdS20clu3FVl4fz1/kqA+md9YOANRhH
         UO7EvTTIoi85kpO8dDvQx4vkheBHn9o3toaL4XS5t6ZiTPqnHDT19uwOQY+K/JAEId
         fyWpddMquZA26RIWXmygu1ZiDAFho1j9AP+qF9+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 000/175] 4.9.283-rc1 review
Date:   Mon, 20 Sep 2021 18:40:49 +0200
Message-Id: <20210920163918.068823680@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.283-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.283-rc1
X-KernelTest-Deadline: 2021-09-22T16:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.283 release.
There are 175 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.283-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.283-rc1

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: sh_eth: Fix freeing wrong tx descriptor

Dinghao Liu <dinghao.liu@zju.edu.cn>
    qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Fix calculating number of switch ports

Randy Dunlap <rdunlap@infradead.org>
    ARC: export clear_user_page() for modules

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Yang Li <yang.lee@linux.alibaba.com>
    ethtool: Fix an error code in cxgb2.c

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

Marc Zyngier <maz@kernel.org>
    mfd: Don't use irq_create_mapping() to resolve a mapping

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

Mike Rapoport <rppt@linux.ibm.com>
    x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: check failover_pending in login response

zhenggy <zhenggy@chinatelecom.cn>
    tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

Eric Dumazet <edumazet@google.com>
    net/af_unix: fix a data-race in unix_dgram_poll

Baptiste Lepers <baptiste.lepers@gmail.com>
    events: Reuse value read using READ_ONCE instead of re-reading it

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: increase timeout in tipc_sk_enqueue()

Florian Fainelli <f.fainelli@gmail.com>
    r6040: Restore MDIO clock frequency after MAC reset

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Lin, Zhenpeng <zplin@psu.edu>
    dccp: don't duplicate ccid when cloning dccp sock

Randy Dunlap <rdunlap@infradead.org>
    ptp: dp83640: don't define PAGE0

Eric Dumazet <edumazet@google.com>
    net-caif: avoid user-triggerable WARN_ON(1)

Adrian Bunk <bunk@kernel.org>
    bnx2x: Fix enabling network interfaces without VFs

Juergen Gross <jgross@suse.com>
    xen: reset legacy rtc flag for PV domU

Patryk Duda <pdk@semihalf.com>
    platform/chrome: cros_ec_proto: Send command again when timeout occurs

Vasily Averin <vvs@virtuozzo.com>
    memcg: enable accounting for pids in nested pid namespaces

Liu Zixian <liuzixian4@huawei.com>
    mm/hugetlb: initialize hugetlb_usage in mm_init

Maciej W. Rozycki <macro@orcam.me.uk>
    scsi: BusLogic: Fix missing pr_cont() use

Mikulas Patocka <mpatocka@redhat.com>
    parisc: fix crash with signals and alloca

Yang Yingliang <yangyingliang@huawei.com>
    net: w5100: check return value after calling platform_get_resource()

王贇 <yun.wang@linux.alibaba.com>
    net: fix NULL pointer reference in cipso_v4_doi_free

Miaoqing Pan <miaoqing@codeaurora.org>
    ath9k: fix sleeping in atomic context

Zekun Shen <bruceshenzk@gmail.com>
    ath9k: fix OOB read ar9300_eeprom_restore_internal

Colin Ian King <colin.king@canonical.com>
    parport: remove non-zero check on count

Anirudh Rayabharam <mail@anirudhrb.com>
    usbip: give back URBs for unsent unlink requests during cleanup

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Ding Hui <dinghui@sangfor.com.cn>
    cifs: fix wrong release in sess_alloc_buffer() failed path

Thomas Hebb <tommyhebb@gmail.com>
    mmc: rtsx_pci: Fix long reads when clock is prescaled

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't call dlm after protocol is unmounted

J. Bruce Fields <bfields@redhat.com>
    rpc: fix gss_svc_init cleanup on failure

Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>
    ARM: tegra: tamonten: Fix UART pad setting

Tuo Li <islituo@gmail.com>
    gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: avoid circular locks in sco_sock_connect

Nathan Chancellor <nathan@kernel.org>
    net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: skip invalid hci_sync_conn_complete_evt

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: ks7010: Fix the initialization of the 'sleep_status' structure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    serial: 8250_pci: make setup_port() parameters explicitly unsigned

Jiri Slaby <jslaby@suse.cz>
    hvsi: don't panic on tty_register_driver failure

Jiri Slaby <jslaby@suse.cz>
    xtensa: ISS: don't panic in rs_init

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Define RX trigger levels for OxSemi 950 devices

Heiko Carstens <hca@linux.ibm.com>
    s390/jump_label: print real address in a case of a jump label bug

Gustavo A. R. Silva <gustavoars@kernel.org>
    flow_dissector: Fix out-of-bounds warnings

Gustavo A. R. Silva <gustavoars@kernel.org>
    ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: riva: Error out if 'pixclock' equals zero

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: kyro: Error out if 'pixclock' equals zero

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: asiliantfb: Error out if 'pixclock' equals zero

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf/tests: Do not PASS tests without actually testing the result

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf/tests: Fix copy-and-paste error in double word test

Zheyu Ma <zheyuma97@gmail.com>
    tty: serial: jsm: hold port lock when reporting modem line changes

Geert Uytterhoeven <geert+renesas@glider.be>
    staging: board: Fix uninitialized spinlock when attaching genpd

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Allow bMaxPower=0 if self-powered

Maciej Żenczykowski <maze@google.com>
    usb: gadget: u_ether: fix a potential null pointer dereference

Kelly Devilliv <kelly.devilliv@gmail.com>
    usb: host: fotg210: fix the actual_length of an iso packet

Kelly Devilliv <kelly.devilliv@gmail.com>
    usb: host: fotg210: fix the endpoint's transactional opportunities calculation

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    Smack: Fix wrong semantics in smk_access_entry()

Yajun Deng <yajun.deng@linux.dev>
    netlink: Deal with ESRCH error in nlmsg_notify()

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: kyro: fix a DoS bug by restricting user input

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: Use pci_update_current_state() in pci_enable_device_flags()

Sean Anderson <sean.anderson@seco.com>
    crypto: mxs-dcp - Use sg_mapping_iter to copy data

Oleksij Rempel <o.rempel@pengutronix.de>
    MIPS: Malta: fix alignment of the devicetree buffer

Zhen Lei <thunder.leizhen@huawei.com>
    pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()

Randy Dunlap <rdunlap@infradead.org>
    openrisc: don't printk() unconditionally

Jason Gunthorpe <jgg@nvidia.com>
    vfio: Use config not menuconfig for VFIO_NOIOMMU

Krzysztof Wilczyński <kw@linux.com>
    PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure

Marek Behún <kabel@kernel.org>
    PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported

David Heidelberg <david@ixit.cz>
    ARM: 9105/1: atags_to_fdt: don't warn about stack size

Hans de Goede <hdegoede@redhat.com>
    libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs

Sean Young <sean@mess.org>
    media: rc-loopback: return number of emitters rather than error

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: uvc: don't do DMA on stack

Wang Hai <wanghai38@huawei.com>
    VMCI: fix NULL pointer dereference when unmapping queue pair

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    power: supply: max17042: handle fails of reading status register

zhenwei pi <pizhenwei@bytedance.com>
    crypto: public_key: fix overflow during implicit conversion

Juergen Gross <jgross@suse.com>
    xen: fix setting of max_pfn in shared_info

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-gpci: Fix counter value parsing

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    PCI/MSI: Skip masking MSI-X on Xen PV

Dmitry Osipenko <digetx@gmail.com>
    rtc: tps65910: Correct driver module alias

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    fbmem: don't allow too huge resolutions

Linus Walleij <linus.walleij@linaro.org>
    clk: kirkwood: Fix a clocking boot regression

Austin Kim <austin.kim@lge.com>
    IMA: remove -Wmissing-prototypes warning

Zelin Deng <zelin.deng@linux.alibaba.com>
    KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Nguyen Dinh Phi <phind.uet@gmail.com>
    tty: Fix data race between tiocsti() and flush_to_ldisc()

Eric Dumazet <edumazet@google.com>
    ipv4: make exception cache less predictible

Zenghui Yu <yuzenghui@huawei.com>
    bcma: Fix memory leak for internally-handled cores

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

Evgeny Novikov <novikov@ispras.ru>
    usb: ehci-orion: Handle errors of clk_prepare_enable() in probe

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: mt65xx: fix IRQ check

Len Baker <len.baker@gmx.com>
    CIFS: Fix a potencially linear read overflow

Tony Lindgren <tony@atomide.com>
    mmc: moxart: Fix issue with uninitialized dma_slave_config

Tony Lindgren <tony@atomide.com>
    mmc: dw_mmc: Fix issue with uninitialized dma_slave_config

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: s3c2410: fix IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: iop3xx: fix deferred probing

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: add timeout sanity check to hci_inquiry

Nadezda Lutovinova <lutovinova@ispras.ru>
    usb: gadget: mv_u3d: request_irq() after initializing UDC

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: tahvo: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: host: ohci-tmio: add IRQ check

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Bluetooth: Move shutdown callback before flushing tx and rx queue

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: twl6030: add IRQ checks

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: phy: fsl-usb: add IRQ check

Sergey Shtylyov <s.shtylyov@omp.ru>
    usb: gadget: udc: at91: add IRQ check

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/msm/dsi: Fix some reference counted resource leaks

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: fix repeated calls to sco_sock_kill

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7

Colin Ian King <colin.king@canonical.com>
    Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: smsm: Fix missed interrupts if state changes while masked

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Enable PME if it can be signaled from D3cold

Sergey Shtylyov <s.shtylyov@omp.ru>
    i2c: highlander: add IRQ check

Pavel Skripkin <paskripkin@gmail.com>
    net: cipso: fix warnings in netlbl_cipsov4_add_std

Martin KaFai Lau <kafai@fb.com>
    tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: sco: prevent information leak in sco_conn_defer_accept()

Pavel Skripkin <paskripkin@gmail.com>
    media: go7007: remove redundant initialization

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: fix uninit-value in vp702x_read_mac_addr

Dongliang Mu <mudongliangabcd@gmail.com>
    media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init

Stefan Berger <stefanb@linux.ibm.com>
    certs: Trigger creation of RSA module signing key if it's not an RSA key

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use proper type for vf_mask

Tony Lindgren <tony@atomide.com>
    spi: spi-pic32: Fix issue with uninitialized dma_slave_config

Pavel Skripkin <paskripkin@gmail.com>
    m68k: emu: Fix invalid free in nfeth_cleanup()

Stian Skjelstad <stian.skjelstad@gmail.com>
    udf_get_extendedattr() had no boundary checks.

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - do not export adf_iov_putmsg()

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - fix naming for init/shutdown VF to PF notifications

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - fix reuse of completion variable

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - handle both source of interrupt in VF ISR

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - do not ignore errors from enable_vf2pf_comms()

Damien Le Moal <damien.lemoal@wdc.com>
    libata: fix ata_host_start()

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: fix typo in MAx17042_TOFF

Jan Kara <jack@suse.cz>
    udf: Check LVID earlier

Tony Lindgren <tony@atomide.com>
    crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors

Sean Anderson <sean.anderson@seco.com>
    crypto: mxs-dcp - Check for DMA mapping errors

Jeongtae Park <jeongtae.park@gmail.com>
    regmap: fix the offset of register error log

Marek Behún <kabel@kernel.org>
    PCI: Call Max Payload Size-related fixup quirks early

Paul Gortmaker <paul.gortmaker@windriver.com>
    x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Qu Wenruo <wqu@suse.com>
    Revert "btrfs: compression: don't try to compress if we don't have enough pages"

Muchun Song <songmuchun@bytedance.com>
    mm/page_alloc: speed up the iteration of max_order

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Remove left-over debug message

Fangrui Song <maskray@google.com>
    powerpc/boot: Delete unneeded .globl _zimage_start

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/module64: Fix comment in R_PPC64_ENTRY handling

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - reduce max key size for SEC1

Andrew Morton <akpm@linux-foundation.org>
    mm/kmemleak.c: make cond_resched() rate-limiting more efficient

Vasily Gorbik <gor@linux.vnet.ibm.com>
    s390/disassembler: correct disassembly lines alignment

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)

Jan Kara <jack@suse.cz>
    gfs2: Don't clear SGID when inheriting ACLs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nvme-pci: Fix an error handling path in 'nvme_probe()'

Philipp Zabel <p.zabel@pengutronix.de>
    tc358743: fix register i2c_rd/wr function fix

Grygorii Strashko <grygorii.strashko@ti.com>
    PM / wakeirq: Enable dedicated wakeirq for suspend

Paul Blakey <paulb@mellanox.com>
    net/sched: cls_flower: Use mask for addr_type

Tom Rix <trix@redhat.com>
    USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Javier Martinez Canillas <javier@osg.samsung.com>
    usb: phy: isp1301: Fix build warning when CONFIG_OF is disabled

Liu Jian <liujian56@huawei.com>
    igmp: Add ip_mc_list lock in ip_check_mc_rcu

Pavel Skripkin <paskripkin@gmail.com>
    media: stkwebcam: fix memory leak in stk_camera_probe

Jouni Malinen <jouni@codeaurora.org>
    ath9k: Postpone key cache entry deletion for TXQ frames reference it

Jouni Malinen <jouni@codeaurora.org>
    ath: Modify ath_key_delete() to not need full key entry

Jouni Malinen <jouni@codeaurora.org>
    ath: Export ath_hw_keysetmac()

Jouni Malinen <jouni@codeaurora.org>
    ath9k: Clear key cache explicitly on disabling hardware

Jouni Malinen <jouni@codeaurora.org>
    ath: Use safer key clearing with key cache entries

Zubin Mithra <zsm@chromium.org>
    ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

Ben Dooks <ben-linux@fluff.org>
    ARM: 8918/2: only build return_address() if needed

Christoph Hellwig <hch@lst.de>
    cryptoloop: add a deprecation warning

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Work around erratum #1197

Shai Malin <smalin@marvell.com>
    qede: Fix memset corruption

Shai Malin <smalin@marvell.com>
    qed: Fix the VF msix vectors flow

Randy Dunlap <rdunlap@infradead.org>
    xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mtd: nand: atmel_nand: remove build warning in atmel_nand_remove()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix race writing to an inline_data file while its xattrs are changing


-------------

Diffstat:

 .../devicetree/bindings/mtd/gpmc-nand.txt          |  2 +-
 Makefile                                           |  4 +-
 arch/arc/mm/cache.c                                |  2 +-
 arch/arm/boot/compressed/Makefile                  |  2 +
 arch/arm/boot/dts/tegra20-tamonten.dtsi            | 14 ++--
 arch/arm/kernel/Makefile                           |  6 +-
 arch/arm/kernel/return_address.c                   |  4 -
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |  2 +-
 arch/m68k/emu/nfeth.c                              |  4 +-
 arch/mips/mti-malta/malta-dtshim.c                 |  2 +-
 arch/openrisc/kernel/entry.S                       |  2 +
 arch/parisc/kernel/signal.c                        |  6 ++
 arch/powerpc/boot/crt0.S                           |  3 -
 arch/powerpc/kernel/module_64.c                    |  2 +-
 arch/powerpc/perf/hv-gpci.c                        |  2 +-
 arch/s390/kernel/dis.c                             |  2 +-
 arch/s390/kernel/jump_label.c                      |  2 +-
 arch/x86/events/amd/ibs.c                          |  8 ++
 arch/x86/kernel/reboot.c                           |  3 +-
 arch/x86/kvm/x86.c                                 |  4 +
 arch/x86/mm/init_64.c                              |  6 +-
 arch/x86/xen/enlighten.c                           |  7 ++
 arch/x86/xen/p2m.c                                 |  4 +-
 arch/xtensa/Kconfig                                |  2 +-
 arch/xtensa/platforms/iss/console.c                | 17 +++-
 certs/Makefile                                     |  8 ++
 drivers/ata/libata-core.c                          |  6 +-
 drivers/ata/sata_dwc_460ex.c                       | 12 +--
 drivers/base/power/wakeirq.c                       | 12 ++-
 drivers/base/regmap/regmap.c                       |  2 +-
 drivers/bcma/main.c                                |  6 +-
 drivers/block/Kconfig                              |  4 +-
 drivers/block/cryptoloop.c                         |  2 +
 drivers/clk/mvebu/kirkwood.c                       |  1 +
 drivers/crypto/mxs-dcp.c                           | 81 +++++++++---------
 drivers/crypto/omap-sham.c                         |  2 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |  4 +-
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |  4 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |  8 +-
 drivers/crypto/qat/qat_common/adf_init.c           |  5 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |  7 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  3 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      | 12 +--
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  7 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |  4 +-
 drivers/crypto/talitos.c                           |  4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c            |  2 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |  6 +-
 drivers/i2c/busses/i2c-highlander.c                |  2 +-
 drivers/i2c/busses/i2c-iop3xx.c                    |  6 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |  2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |  2 +-
 drivers/iio/dac/ad5624r_spi.c                      | 18 +++-
 drivers/media/i2c/tc358743.c                       |  2 +-
 drivers/media/rc/rc-loopback.c                     |  2 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c            |  6 +-
 drivers/media/usb/dvb-usb/vp702x.c                 | 12 ++-
 drivers/media/usb/go7007/go7007-driver.c           | 26 ------
 drivers/media/usb/stkwebcam/stk-webcam.c           |  6 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   | 34 +++++---
 drivers/mfd/ab8500-core.c                          |  2 +-
 drivers/mfd/stmpe.c                                |  4 +-
 drivers/mfd/tc3589x.c                              |  2 +-
 drivers/mfd/wm8994-irq.c                           |  2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |  6 +-
 drivers/mmc/host/dw_mmc.c                          |  1 +
 drivers/mmc/host/moxart-mmc.c                      |  1 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  | 36 +++++---
 drivers/mtd/nand/atmel_nand.c                      |  1 -
 drivers/mtd/nand/cafe_nand.c                       |  4 +-
 drivers/net/dsa/b53/b53_common.c                   |  3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |  1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  8 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  7 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |  1 -
 drivers/net/ethernet/rdc/r6040.c                   |  9 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    | 18 ++--
 drivers/net/ethernet/wiznet/w5100.c                |  2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  4 +-
 drivers/net/phy/dp83640_reg.h                      |  2 +-
 drivers/net/usb/cdc_mbim.c                         |  5 ++
 drivers/net/wireless/ath/ath.h                     |  3 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |  2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  2 +-
 drivers/net/wireless/ath/ath9k/hw.c                | 12 +--
 drivers/net/wireless/ath/ath9k/hw.h                |  1 +
 drivers/net/wireless/ath/ath9k/main.c              | 95 +++++++++++++++++++++-
 drivers/net/wireless/ath/key.c                     | 41 ++++++----
 drivers/nvme/host/pci.c                            |  7 +-
 drivers/parport/ieee1284_ops.c                     |  2 +-
 drivers/pci/msi.c                                  |  3 +
 drivers/pci/pci.c                                  | 15 ++--
 drivers/pci/quirks.c                               | 13 +--
 drivers/pci/syscall.c                              |  4 +-
 drivers/pinctrl/pinctrl-single.c                   |  1 +
 drivers/platform/chrome/cros_ec_proto.c            |  9 ++
 drivers/power/supply/axp288_fuel_gauge.c           |  4 +-
 drivers/power/supply/max17042_battery.c            |  8 +-
 drivers/rtc/rtc-tps65910.c                         |  2 +-
 drivers/scsi/BusLogic.c                            |  4 +-
 drivers/soc/qcom/smsm.c                            | 11 ++-
 drivers/spi/spi-pic32.c                            |  1 +
 drivers/staging/board/board.c                      |  7 +-
 drivers/staging/ks7010/ks7010_sdio.c               |  2 +-
 drivers/tty/hvc/hvsi.c                             | 19 ++++-
 drivers/tty/serial/8250/8250_pci.c                 |  2 +-
 drivers/tty/serial/8250/8250_port.c                |  3 +-
 drivers/tty/serial/jsm/jsm_neo.c                   |  2 +
 drivers/tty/serial/jsm/jsm_tty.c                   |  3 +
 drivers/tty/tty_io.c                               |  4 +-
 drivers/usb/gadget/composite.c                     |  8 +-
 drivers/usb/gadget/function/u_ether.c              |  5 +-
 drivers/usb/gadget/udc/at91_udc.c                  |  4 +-
 drivers/usb/gadget/udc/mv_u3d_core.c               | 19 +++--
 drivers/usb/host/ehci-orion.c                      |  8 +-
 drivers/usb/host/fotg210-hcd.c                     | 41 +++++-----
 drivers/usb/host/fotg210.h                         |  5 --
 drivers/usb/host/ohci-tmio.c                       |  3 +
 drivers/usb/host/xhci.c                            | 24 +++---
 drivers/usb/phy/phy-fsl-usb.c                      |  2 +
 drivers/usb/phy/phy-isp1301.c                      |  2 +-
 drivers/usb/phy/phy-tahvo.c                        |  4 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |  5 ++
 drivers/usb/serial/mos7720.c                       |  4 +-
 drivers/usb/usbip/vhci_hcd.c                       | 24 ++++++
 drivers/vfio/Kconfig                               |  2 +-
 drivers/video/fbdev/asiliantfb.c                   |  3 +
 drivers/video/fbdev/core/fbmem.c                   |  7 ++
 drivers/video/fbdev/kyro/fbdev.c                   |  8 ++
 drivers/video/fbdev/riva/fbdev.c                   |  3 +
 fs/btrfs/inode.c                                   |  2 +-
 fs/cifs/cifs_unicode.c                             |  9 +-
 fs/cifs/sess.c                                     |  2 +-
 fs/ext4/inline.c                                   |  6 ++
 fs/gfs2/acl.c                                      | 27 +++---
 fs/gfs2/lock_dlm.c                                 |  5 ++
 fs/udf/misc.c                                      | 13 ++-
 fs/udf/super.c                                     | 25 ++++--
 include/crypto/public_key.h                        |  4 +-
 include/linux/hugetlb.h                            |  9 ++
 include/linux/pci.h                                |  5 +-
 include/linux/power/max17042_battery.h             |  2 +-
 include/linux/skbuff.h                             |  2 +-
 include/uapi/linux/serial_reg.h                    |  1 +
 kernel/events/core.c                               |  2 +-
 kernel/fork.c                                      |  1 +
 kernel/pid_namespace.c                             |  2 +-
 lib/test_bpf.c                                     | 13 ++-
 mm/kmemleak.c                                      |  2 +-
 mm/page_alloc.c                                    |  8 +-
 net/bluetooth/cmtp/cmtp.h                          |  2 +-
 net/bluetooth/hci_core.c                           | 14 ++++
 net/bluetooth/hci_event.c                          | 15 ++++
 net/bluetooth/sco.c                                | 50 +++++-------
 net/caif/chnl_net.c                                | 19 +----
 net/core/flow_dissector.c                          | 12 ++-
 net/dccp/minisocks.c                               |  2 +
 net/ipv4/icmp.c                                    | 23 +++++-
 net/ipv4/igmp.c                                    |  2 +
 net/ipv4/ip_output.c                               |  5 +-
 net/ipv4/route.c                                   | 46 +++++++----
 net/ipv4/tcp_input.c                               |  2 +-
 net/ipv4/tcp_ipv4.c                                |  5 +-
 net/l2tp/l2tp_core.c                               |  4 +-
 net/netlabel/netlabel_cipso_v4.c                   | 12 +--
 net/netlink/af_netlink.c                           |  4 +-
 net/sched/cls_flower.c                             |  4 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |  2 +-
 net/tipc/socket.c                                  |  2 +-
 net/unix/af_unix.c                                 |  2 +-
 security/integrity/ima/ima_mok.c                   |  2 +-
 security/smack/smack_access.c                      | 17 ++--
 sound/core/pcm_lib.c                               |  2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  9 +-
 179 files changed, 935 insertions(+), 488 deletions(-)


