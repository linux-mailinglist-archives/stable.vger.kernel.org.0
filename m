Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9E411EF7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347029AbhITRg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351576AbhITRe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:34:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE3D61B02;
        Mon, 20 Sep 2021 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157544;
        bh=OlAJGHxfCYZKg1dWmYGDoX2U0C3GkqP9c4NtCrgiuo4=;
        h=From:To:Cc:Subject:Date:From;
        b=JVqyzelEaM4/j/2MENx7/hcQzi1I7IiDpf+Ct/OKaQRB5dautNpBukc3EzP75TGxR
         HNWiY3QSyG2lS04++YBa3HWIkBvSQ65/80/xvOgLOIMip4TYqVWcdqirL40UJz97Mh
         3kW0U9omzf3uhPklp469z2Kb6FmqHhCQa6q/z9Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 000/293] 4.19.207-rc1 review
Date:   Mon, 20 Sep 2021 18:39:22 +0200
Message-Id: <20210920163933.258815435@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.207-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.207-rc1
X-KernelTest-Deadline: 2021-09-22T16:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.207 release.
There are 293 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.207-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.207-rc1

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: sh_eth: Fix freeing wrong tx descriptor

Willem de Bruijn <willemb@google.com>
    ip_gre: validate csum_start only on pull

Dinghao Liu <dinghao.liu@zju.edu.cn>
    qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Eric Dumazet <edumazet@google.com>
    fq_codel: reject silly quantum parameters

Benjamin Hesmans <benjamin.hesmans@tessares.net>
    netfilter: socket: icmp6: fix use-after-scope

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: b53: Fix calculating number of switch ports

Randy Dunlap <rdunlap@infradead.org>
    ARC: export clear_user_page() for modules

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Oliver Upton <oupton@google.com>
    KVM: arm64: Handle PSCI resets before userspace touches vCPU state

Dan Carpenter <dan.carpenter@oracle.com>
    PCI: Fix pci_dev_str_match_path() alloc while atomic bug

Hans de Goede <hdegoede@redhat.com>
    mfd: axp20x: Update AXP288 volatile ranges

Yang Li <yang.lee@linux.alibaba.com>
    NTB: perf: Fix an error code in perf_setup_inbuf()

Yang Li <yang.lee@linux.alibaba.com>
    ethtool: Fix an error code in cxgb2.c

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: honor already-setup queue merges

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

George Cherian <george.cherian@marvell.com>
    PCI: Add ACS quirks for Cavium multi-function devices

Marc Zyngier <maz@kernel.org>
    mfd: Don't use irq_create_mapping() to resolve a mapping

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: index kvm->arch.idle_mask by vcpu_idx

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: pad the short tunnel frame before sending to hardware

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: check failover_pending in login response

Shai Malin <smalin@marvell.com>
    qed: Handle management FW error

zhenggy <zhenggy@chinatelecom.cn>
    tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup

Eric Dumazet <edumazet@google.com>
    net/af_unix: fix a data-race in unix_dgram_poll

Baptiste Lepers <baptiste.lepers@gmail.com>
    events: Reuse value read using READ_ONCE instead of re-reading it

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Fix potential sleeping in atomic context

Michael Petlan <mpetlan@redhat.com>
    perf machine: Initialize srcline string member in add_location struct

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

Xin Long <lucien.xin@gmail.com>
    tipc: fix an use-after-free issue in tipc_recvmsg

Mike Rapoport <rppt@linux.ibm.com>
    x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Evan Quan <evan.quan@amd.com>
    PCI: Add AMD GPU multi-function power dependencies

Juergen Gross <jgross@suse.com>
    PM: base: power: don't try to use non-existing RTC for storing data

Mark Brown <broonie@kernel.org>
    arm64/sve: Use correct size when reinitialising SVE state

Adrian Bunk <bunk@kernel.org>
    bnx2x: Fix enabling network interfaces without VFs

Juergen Gross <jgross@suse.com>
    xen: reset legacy rtc flag for PV domU

Ye Bin <yebin10@huawei.com>
    dm thin metadata: Fix use-after-free in dm_bm_set_read_only

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Fix BUG_ON assert

Patryk Duda <pdk@semihalf.com>
    platform/chrome: cros_ec_proto: Send command again when timeout occurs

Vasily Averin <vvs@virtuozzo.com>
    memcg: enable accounting for pids in nested pid namespaces

Liu Zixian <liuzixian4@huawei.com>
    mm/hugetlb: initialize hugetlb_usage in mm_init

Pratik R. Sampat <psampat@linux.ibm.com>
    cpufreq: powernv: Fix init_chip_info initialization in numa=off

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Sync queue idx with queue_pair_map idx

Maciej W. Rozycki <macro@orcam.me.uk>
    scsi: BusLogic: Fix missing pr_cont() use

chenying <chenying.kernel@bytedance.com>
    ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup()

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

Xiaotan Luo <lxt@rock-chips.com>
    ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B

Sugar Zhang <sugar.zhang@rock-chips.com>
    ASoC: rockchip: i2s: Fix regmap_ops hang

Shuah Khan <skhan@linuxfoundation.org>
    usbip:vhci_hcd USB port can get stuck in the disabled state

Anirudh Rayabharam <mail@anirudhrb.com>
    usbip: give back URBs for unsent unlink requests during cleanup

Nadezda Lutovinova <lutovinova@ispras.ru>
    usb: musb: musb_dsps: request_irq() after initializing musb

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Ding Hui <dinghui@sangfor.com.cn>
    cifs: fix wrong release in sess_alloc_buffer() failed path

Nishad Kamdar <nishadkamdar@gmail.com>
    mmc: core: Return correct emmc response in case of ioctl error

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests/bpf: Enlarge select() timeout for test_maps

Thomas Hebb <tommyhebb@gmail.com>
    mmc: rtsx_pci: Fix long reads when clock is prescaled

Manish Narani <manish.narani@xilinx.com>
    mmc: sdhci-of-arasan: Check return value of non-void funtions

Marc Zyngier <maz@kernel.org>
    of: Don't allow __of_attached_node_sysfs() without CONFIG_SYSFS

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't call dlm after protocol is unmounted

Kees Cook <keescook@chromium.org>
    staging: rts5208: Fix get_ms_information() heap buffer size

J. Bruce Fields <bfields@redhat.com>
    rpc: fix gss_svc_init cleanup on failure

Luke Hsiao <lukehsiao@google.com>
    tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD

Ulrich Hecht <uli+renesas@fpond.eu>
    serial: sh-sci: fix break handling for sysrq

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix handling of LE Enhanced Connection Complete

Andreas Obergschwandtner <andreas.obergschwandtner@gmail.com>
    ARM: tegra: tamonten: Fix UART pad setting

Tuo Li <islituo@gmail.com>
    gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: avoid circular locks in sco_sock_connect

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: schedule SCO timeouts with delayed_work

Nathan Chancellor <nathan@kernel.org>
    net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()

Vinod Koul <vkoul@kernel.org>
    arm64: dts: qcom: sdm660: use reg value for memory node

Sebastian Reichel <sebastian.reichel@collabora.com>
    ARM: dts: imx53-ppd: Fix ACHC entry

Evgeny Novikov <novikov@ispras.ru>
    media: tegra-cec: Handle errors of clk_prepare_enable()

Krzysztof Hałasa <khalasa@piap.pl>
    media: TDA1997x: fix tda1997x_query_dv_timings() return value

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings.c: fix wrong condition in two for-loops

Umang Jain <umang.jain@ideasonboard.com>
    media: imx258: Limit the max analogue gain to 480

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx258: Rectify mismatch of VTS value

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output

Yufeng Mo <moyufeng@huawei.com>
    bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    Bluetooth: skip invalid hci_sync_conn_complete_evt

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()

Juhee Kang <claudiajkang@gmail.com>
    samples: bpf: Fix tracex7 error raised on the missing argument

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

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/amdgpu: Update debugfs link_settings output link_rate field in hex

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

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: apq8064: correct clock names

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Xin Long <lucien.xin@gmail.com>
    tipc: keep the skb in rcv queue until the whole data is read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: Use pci_update_current_state() in pci_enable_device_flags()

Sean Anderson <sean.anderson@seco.com>
    crypto: mxs-dcp - Use sg_mapping_iter to copy data

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dib8000: rewrite the init prbs logic

Nadav Amit <namit@vmware.com>
    userfaultfd: prevent concurrent API initialization

Oleksij Rempel <o.rempel@pengutronix.de>
    MIPS: Malta: fix alignment of the devicetree buffer

Chao Yu <chao@kernel.org>
    f2fs: fix to unmap pages from userspace process in punch_hole()

Chao Yu <chao@kernel.org>
    f2fs: fix to account missing .skipped_gc_rwsem

David Howells <dhowells@redhat.com>
    fscache: Fix cookie key hashing

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qedi: Fix error codes in qedi_alloc_global_queues()

Zhen Lei <thunder.leizhen@huawei.com>
    pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()

Randy Dunlap <rdunlap@infradead.org>
    openrisc: don't printk() unconditionally

Michal Suchanek <msuchanek@suse.de>
    powerpc/stacktrace: Include linux/delay.h

Jason Gunthorpe <jgg@nvidia.com>
    vfio: Use config not menuconfig for VFIO_NOIOMMU

Jaehyoung Choi <jkkkkk.choi@samsung.com>
    pinctrl: samsung: Fix pinctrl bank pin count

Leon Romanovsky <leonro@nvidia.com>
    docs: Fix infiniband uverbs minor number

Leon Romanovsky <leonro@nvidia.com>
    RDMA/iwcm: Release resources if iw_cm module initialization fails

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: do not report stylus battery state as "full"

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix masking and unmasking legacy INTx interrupts

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response

Hyun Kwon <hyun.kwon@xilinx.com>
    PCI: xilinx-nwl: Enable the clock through CCF

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

Arne Welzel <arne.welzel@corelight.com>
    dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    power: supply: max17042: handle fails of reading status register

Damien Le Moal <damien.lemoal@wdc.com>
    block: bfq: fix bfq_set_next_ioprio_data()

zhenwei pi <pizhenwei@bytedance.com>
    crypto: public_key: fix overflow during implicit conversion

Mark Rutland <mark.rutland@arm.com>
    arm64: head: avoid over-mapping in map_memory

Iwona Winiarska <iwona.winiarska@intel.com>
    soc: aspeed: lpc-ctrl: Fix boundary check for mmap

Rolf Eike Beer <eb@emlix.com>
    tools/thermal/tmon: Add cross compiling support

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix pointer arithmetic mask tightening under state pruning

Lorenz Bauer <lmb@cloudflare.com>
    bpf: verifier: Allocate idmap scratch in verifier env

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage due to insufficient speculative store bypass mitigation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Introduce BPF nospec instruction for mitigating Spectre v4

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: fix tests due to const spill/fill

Alexei Starovoitov <ast@kernel.org>
    bpf: track spill/fill of constants

Andrey Ignatov <rdna@fb.com>
    selftests/bpf: Test variable offset stack access

Andrey Ignatov <rdna@fb.com>
    bpf: Sanity check max value for var_off stack access

Andrey Ignatov <rdna@fb.com>
    bpf: Reject indirect var_off stack access in unpriv mode

Andrey Ignatov <rdna@fb.com>
    bpf: Reject indirect var_off stack access in raw mode

Andrey Ignatov <rdna@fb.com>
    bpf: Support variable offset stack access from helpers

Jiong Wang <jiong.wang@netronome.com>
    bpf: correct slot_type marking logic to allow more stack slot sharing

Edward Cree <ecree@solarflare.com>
    bpf/verifier: per-register parent pointers

Harshvardhan Jha <harshvardhan.jha@oracle.com>
    9p/xen: Fix end of loop tests for list_for_each_entry

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    include/linux/list.h: add a macro to test if entry is pointing to the head

Juergen Gross <jgross@suse.com>
    xen: fix setting of max_pfn in shared_info

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-gpci: Fix counter value parsing

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    PCI/MSI: Skip masking MSI-X on Xen PV

Niklas Cassel <niklas.cassel@wdc.com>
    blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN

Niklas Cassel <niklas.cassel@wdc.com>
    blk-zoned: allow zone management send operations without CAP_SYS_ADMIN

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    btrfs: reset replace target device to allocation state on close

Dmitry Osipenko <digetx@gmail.com>
    rtc: tps65910: Correct driver module alias

Linus Walleij <linus.walleij@linaro.org>
    clk: kirkwood: Fix a clocking boot regression

Daniel Thompson <daniel.thompson@linaro.org>
    backlight: pwm_bl: Improve bootloader/kernel device handover

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    fbmem: don't allow too huge resolutions

THOBY Simon <Simon.THOBY@viveris.fr>
    IMA: remove the dependency on CRYPTO_MD5

Austin Kim <austin.kim@lge.com>
    IMA: remove -Wmissing-prototypes warning

Zelin Deng <zelin.deng@linux.alibaba.com>
    KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix a maybe-uninitialized build warning treated as error

Nguyen Dinh Phi <phind.uet@gmail.com>
    tty: Fix data race between tiocsti() and flush_to_ldisc()

Eric Biggers <ebiggers@google.com>
    ubifs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    f2fs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    ext4: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_symlink_getattr() for computing st_size

Guillaume Nault <gnault@redhat.com>
    netns: protect netns ID lookups with RCU

Eric Dumazet <edumazet@google.com>
    ipv4: fix endianness issue in inet_rtm_getroute_build_skb()

Stefan Wahren <stefan.wahren@i2se.com>
    net: qualcomm: fix QCA7000 checksum handling

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed

Eric Dumazet <edumazet@google.com>
    ipv4: make exception cache less predictible

Zenghui Yu <yuzenghui@huawei.com>
    bcma: Fix memory leak for internally-handled cores

Dan Carpenter <dan.carpenter@oracle.com>
    ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()

Andy Duan <fugang.duan@nxp.com>
    tty: serial: fsl_lpuart: fix the wrong mapbase value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: bdc: Fix an error handling path in 'bdc_probe()' when no suitable DMA config is available

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

Chih-Kang Chang <gary.chang@realtek.com>
    mac80211: Fix insufficient headroom issue for AMSDU

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

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make dpu_hw_ctl_clear_all_blendstages clear necessary LMs

Colin Ian King <colin.king@canonical.com>
    Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: smsm: Fix missed interrupts if state changes while masked

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Enable PME if it can be signaled from D3cold

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Avoid forcing PCI_D0 for wakeup reasons inconsistently

Colin Ian King <colin.king@canonical.com>
    media: venus: venc: Fix potential null pointer dereference on pointer fmt

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx-input: fix refcount bug in em28xx_usb_disconnect

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

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally

Krzysztof Hałasa <khalasa@piap.pl>
    media: TDA1997x: enable EDID support

Chunyan Zhang <chunyan.zhang@unisoc.com>
    spi: sprd: Fix the wrong WDG_LOAD_VAL

Stefan Berger <stefanb@linux.ibm.com>
    certs: Trigger creation of RSA module signing key if it's not an RSA key

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use proper type for vf_mask

Phong Hoang <phong.hoang.wz@renesas.com>
    clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel

Hongbo Li <herberthbli@tencent.com>
    lib/mpi: use kcalloc in mpi_resize

Tony Lindgren <tony@atomide.com>
    spi: spi-pic32: Fix issue with uninitialized dma_slave_config

Tony Lindgren <tony@atomide.com>
    spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config

Pavel Skripkin <paskripkin@gmail.com>
    m68k: emu: Fix invalid free in nfeth_cleanup()

Stian Skjelstad <stian.skjelstad@gmail.com>
    udf_get_extendedattr() had no boundary checks.

Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
    fcntl: fix potential deadlock for &fasync_struct.fa_lock

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

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: add dev_busid sysfs entry for each subchannel

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    power: supply: max17042_battery: fix typo in MAx17042_TOFF

Ruozhu Li <liruozhu@huawei.com>
    nvme-rdma: don't update queue count when failing to set io queues

Christoph Hellwig <hch@lst.de>
    bcache: add proper error unwinding in bcache_device_init

Pali Rohár <pali@kernel.org>
    isofs: joliet: Fix iocharset=utf8 mount option

Jan Kara <jack@suse.cz>
    udf: Check LVID earlier

Thomas Gleixner <tglx@linutronix.de>
    hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/deadline: Fix missing clock update in migrate_task_rq_dl()

Tony Lindgren <tony@atomide.com>
    crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors

Quentin Perret <qperret@google.com>
    sched/deadline: Fix reset_on_fork reporting of DL tasks

Sean Anderson <sean.anderson@seco.com>
    crypto: mxs-dcp - Check for DMA mapping errors

Jeongtae Park <jeongtae.park@gmail.com>
    regmap: fix the offset of register error log

Peter Zijlstra <peterz@infradead.org>
    locking/mutex: Fix HANDOFF condition

Marek Behún <kabel@kernel.org>
    PCI: Call Max Payload Size-related fixup quirks early

Paul Gortmaker <paul.gortmaker@windriver.com>
    x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: fix the wrong HS mult value

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: use @mult for HS isoc or intr

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: xhci-rcar: Don't reload firmware after the completion

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 800

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

Trond Myklebust <trondmy@gmail.com>
    SUNRPC/nfs: Fix return value for nfs4_callback_compound()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)

Tom Rix <trix@redhat.com>
    USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Liu Jian <liujian56@huawei.com>
    igmp: Add ip_mc_list lock in ip_check_mc_rcu

Colin Ian King <colin.king@canonical.com>
    ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init

Yang Yingliang <yangyingliang@huawei.com>
    ARM: imx: add missing clk_disable_unprepare()

Pavel Skripkin <paskripkin@gmail.com>
    media: stkwebcam: fix memory leak in stk_camera_probe

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    clk: fix build warning for orphan_list

Zubin Mithra <zsm@chromium.org>
    ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

Ben Dooks <ben-linux@fluff.org>
    ARM: 8918/2: only build return_address() if needed

Christoph Hellwig <hch@lst.de>
    cryptoloop: add a deprecation warning

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Work around erratum #1197

Xiaoyao Li <xiaoyao.li@intel.com>
    perf/x86/intel/pt: Fix mask of num_address_ranges

Shai Malin <smalin@marvell.com>
    qede: Fix memset corruption

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Add a NULL check on desc_ptp

Shai Malin <smalin@marvell.com>
    qed: Fix the VF msix vectors flow

Krzysztof Hałasa <khalasa@piap.pl>
    gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats

Randy Dunlap <rdunlap@infradead.org>
    xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Theodore Ts'o <tytso@mit.edu>
    ext4: fix race writing to an inline_data file while its xattrs are changing


-------------

Diffstat:

 Documentation/admin-guide/devices.txt              |   6 +-
 .../devicetree/bindings/mtd/gpmc-nand.txt          |   2 +-
 Makefile                                           |   4 +-
 arch/arc/mm/cache.c                                |   2 +-
 arch/arm/boot/compressed/Makefile                  |   2 +
 arch/arm/boot/dts/imx53-ppd.dts                    |  23 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |   6 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |  14 +-
 arch/arm/kernel/Makefile                           |   6 +-
 arch/arm/kernel/return_address.c                   |   4 -
 arch/arm/mach-imx/mmdc.c                           |  14 +-
 arch/arm/net/bpf_jit_32.c                          |   3 +
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   2 +-
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts          |   2 +-
 arch/arm64/include/asm/kernel-pgtable.h            |   4 +-
 arch/arm64/kernel/fpsimd.c                         |   2 +-
 arch/arm64/kernel/head.S                           |  11 +-
 arch/arm64/net/bpf_jit_comp.c                      |  13 +
 arch/m68k/emu/nfeth.c                              |   4 +-
 arch/mips/mti-malta/malta-dtshim.c                 |   2 +-
 arch/mips/net/ebpf_jit.c                           |   3 +
 arch/openrisc/kernel/entry.S                       |   2 +
 arch/parisc/kernel/signal.c                        |   6 +
 arch/powerpc/boot/crt0.S                           |   3 -
 arch/powerpc/kernel/module_64.c                    |   2 +-
 arch/powerpc/kernel/stacktrace.c                   |   1 +
 arch/powerpc/net/bpf_jit_comp64.c                  |   6 +
 arch/powerpc/perf/hv-gpci.c                        |   2 +-
 arch/s390/kernel/jump_label.c                      |   2 +-
 arch/s390/kvm/interrupt.c                          |   4 +-
 arch/s390/kvm/kvm-s390.h                           |   2 +-
 arch/s390/net/bpf_jit_comp.c                       |   5 +
 arch/sparc/net/bpf_jit_comp_64.c                   |   3 +
 arch/x86/events/amd/ibs.c                          |   8 +
 arch/x86/events/intel/pt.c                         |   2 +-
 arch/x86/kernel/cpu/intel_rdt_monitor.c            |   6 +
 arch/x86/kernel/reboot.c                           |   3 +-
 arch/x86/kvm/x86.c                                 |   4 +
 arch/x86/mm/init_64.c                              |   6 +-
 arch/x86/net/bpf_jit_comp.c                        |   7 +
 arch/x86/net/bpf_jit_comp32.c                      |   6 +
 arch/x86/xen/enlighten_pv.c                        |   7 +
 arch/x86/xen/p2m.c                                 |   4 +-
 arch/xtensa/Kconfig                                |   2 +-
 arch/xtensa/platforms/iss/console.c                |  17 +-
 block/bfq-iosched.c                                |  18 +-
 block/blk-zoned.c                                  |   6 -
 certs/Makefile                                     |   8 +
 drivers/ata/libata-core.c                          |   6 +-
 drivers/ata/sata_dwc_460ex.c                       |  12 +-
 drivers/base/power/trace.c                         |  10 +
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/bcma/main.c                                |   6 +-
 drivers/block/Kconfig                              |   4 +-
 drivers/block/cryptoloop.c                         |   2 +
 drivers/clk/clk.c                                  |  10 +-
 drivers/clk/mvebu/kirkwood.c                       |   1 +
 drivers/clocksource/sh_cmt.c                       |  30 +-
 drivers/cpufreq/powernv-cpufreq.c                  |  16 +-
 drivers/crypto/mxs-dcp.c                           |  81 ++--
 drivers/crypto/omap-sham.c                         |   2 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |   4 +-
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   4 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   8 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   5 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |   7 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |   3 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      |  12 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |   7 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |   4 +-
 drivers/crypto/talitos.c                           |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  16 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |  10 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 +-
 drivers/gpu/ipu-v3/ipu-cpmem.c                     |  30 +-
 drivers/hid/hid-input.c                            |   2 -
 drivers/i2c/busses/i2c-highlander.c                |   2 +-
 drivers/i2c/busses/i2c-iop3xx.c                    |   6 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   2 +-
 drivers/iio/dac/ad5624r_spi.c                      |  18 +-
 drivers/infiniband/core/iwcm.c                     |  19 +-
 drivers/md/bcache/super.c                          |  16 +-
 drivers/md/dm-crypt.c                              |   7 +-
 drivers/md/dm-thin-metadata.c                      |   2 +-
 drivers/md/persistent-data/dm-block-manager.c      |  14 +-
 drivers/media/dvb-frontends/dib8000.c              |  58 ++-
 drivers/media/i2c/imx258.c                         |   4 +-
 drivers/media/i2c/tda1997x.c                       |   6 +-
 drivers/media/platform/qcom/venus/venc.c           |   2 +
 drivers/media/platform/tegra-cec/tegra_cec.c       |  10 +-
 drivers/media/rc/rc-loopback.c                     |   2 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c            |   6 +-
 drivers/media/usb/dvb-usb/vp702x.c                 |  12 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   1 -
 drivers/media/usb/go7007/go7007-driver.c           |  26 --
 drivers/media/usb/stkwebcam/stk-webcam.c           |   6 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  34 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/mfd/ab8500-core.c                          |   2 +-
 drivers/mfd/axp20x.c                               |   3 +-
 drivers/mfd/stmpe.c                                |   4 +-
 drivers/mfd/tc3589x.c                              |   2 +-
 drivers/mfd/wm8994-irq.c                           |   2 +-
 drivers/misc/aspeed-lpc-ctrl.c                     |   2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   6 +-
 drivers/mmc/core/block.c                           |   3 +-
 drivers/mmc/host/dw_mmc.c                          |   1 +
 drivers/mmc/host/moxart-mmc.c                      |   1 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  36 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |  18 +-
 drivers/mtd/nand/raw/cafe_nand.c                   |   4 +-
 drivers/net/bonding/bond_main.c                    |   3 +-
 drivers/net/dsa/b53/b53_common.c                   |   3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   2 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |  11 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   9 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   7 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |   6 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |   1 -
 drivers/net/ethernet/qualcomm/qca_spi.c            |   2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/ethernet/rdc/r6040.c                   |   9 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  18 +-
 drivers/net/ethernet/wiznet/w5100.c                |   2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   4 +-
 drivers/net/phy/dp83640_reg.h                      |   2 +-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   3 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  12 +-
 drivers/ntb/test/ntb_perf.c                        |   1 +
 drivers/nvme/host/rdma.c                           |   4 +-
 drivers/of/kobj.c                                  |   2 +-
 drivers/parport/ieee1284_ops.c                     |   2 +-
 drivers/pci/controller/pci-aardvark.c              |  11 +-
 drivers/pci/controller/pcie-xilinx-nwl.c           |  12 +
 drivers/pci/msi.c                                  |   3 +
 drivers/pci/pci.c                                  |  33 +-
 drivers/pci/quirks.c                               |  26 +-
 drivers/pci/syscall.c                              |   4 +-
 drivers/pinctrl/pinctrl-single.c                   |   1 +
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   2 +-
 drivers/platform/chrome/cros_ec_proto.c            |   9 +
 drivers/platform/x86/dell-smbios-wmi.c             |   1 +
 drivers/power/supply/axp288_fuel_gauge.c           |   4 +-
 drivers/power/supply/max17042_battery.c            |   8 +-
 drivers/rtc/rtc-tps65910.c                         |   2 +-
 drivers/s390/cio/css.c                             |  17 +
 drivers/scsi/BusLogic.c                            |   4 +-
 drivers/scsi/qedi/qedi_main.c                      |  14 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/soc/qcom/smsm.c                            |  11 +-
 drivers/soc/rockchip/Kconfig                       |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |   1 +
 drivers/spi/spi-pic32.c                            |   1 +
 drivers/spi/spi-sprd-adi.c                         |   2 +-
 drivers/staging/board/board.c                      |   7 +-
 drivers/staging/ks7010/ks7010_sdio.c               |   2 +-
 drivers/staging/rts5208/rtsx_scsi.c                |  10 +-
 drivers/tty/hvc/hvsi.c                             |  19 +-
 drivers/tty/serial/8250/8250_pci.c                 |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/serial/fsl_lpuart.c                    |   2 +-
 drivers/tty/serial/jsm/jsm_neo.c                   |   2 +
 drivers/tty/serial/jsm/jsm_tty.c                   |   3 +
 drivers/tty/serial/sh-sci.c                        |   7 +-
 drivers/tty/tty_io.c                               |   4 +-
 drivers/usb/gadget/composite.c                     |   8 +-
 drivers/usb/gadget/function/u_ether.c              |   5 +-
 drivers/usb/gadget/udc/at91_udc.c                  |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |   3 +-
 drivers/usb/gadget/udc/mv_u3d_core.c               |  19 +-
 drivers/usb/host/ehci-orion.c                      |   8 +-
 drivers/usb/host/fotg210-hcd.c                     |  41 +-
 drivers/usb/host/fotg210.h                         |   5 -
 drivers/usb/host/ohci-tmio.c                       |   3 +
 drivers/usb/host/xhci-rcar.c                       |   7 +
 drivers/usb/host/xhci.c                            |  24 +-
 drivers/usb/mtu3/mtu3_gadget.c                     |   6 +-
 drivers/usb/musb/musb_dsps.c                       |  13 +-
 drivers/usb/phy/phy-fsl-usb.c                      |   2 +
 drivers/usb/phy/phy-tahvo.c                        |   4 +-
 drivers/usb/phy/phy-twl6030-usb.c                  |   5 +
 drivers/usb/serial/mos7720.c                       |   4 +-
 drivers/usb/usbip/vhci_hcd.c                       |  32 +-
 drivers/vfio/Kconfig                               |   2 +-
 drivers/video/backlight/pwm_bl.c                   |  54 +--
 drivers/video/fbdev/asiliantfb.c                   |   3 +
 drivers/video/fbdev/core/fbmem.c                   |   6 +
 drivers/video/fbdev/kyro/fbdev.c                   |   8 +
 drivers/video/fbdev/riva/fbdev.c                   |   3 +
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/volumes.c                                 |   3 +
 fs/cifs/cifs_unicode.c                             |   9 +-
 fs/cifs/sess.c                                     |   2 +-
 fs/crypto/hooks.c                                  |  44 ++
 fs/ext4/inline.c                                   |   6 +
 fs/ext4/symlink.c                                  |  11 +-
 fs/f2fs/file.c                                     |   4 +-
 fs/f2fs/gc.c                                       |   4 +-
 fs/f2fs/namei.c                                    |  11 +-
 fs/fcntl.c                                         |   5 +-
 fs/fscache/cookie.c                                |  14 +-
 fs/fscache/internal.h                              |   2 +
 fs/fscache/main.c                                  |  39 ++
 fs/gfs2/lock_dlm.c                                 |   5 +
 fs/isofs/inode.c                                   |  27 +-
 fs/isofs/isofs.h                                   |   1 -
 fs/isofs/joliet.c                                  |   4 +-
 fs/nfs/callback_xdr.c                              |   2 +-
 fs/overlayfs/dir.c                                 |   6 +-
 fs/ubifs/file.c                                    |  12 +-
 fs/udf/misc.c                                      |  13 +-
 fs/udf/super.c                                     |  25 +-
 fs/userfaultfd.c                                   |  93 ++--
 include/crypto/public_key.h                        |   4 +-
 include/linux/bpf_verifier.h                       |  19 +-
 include/linux/filter.h                             |  15 +
 include/linux/fscrypt_notsupp.h                    |   6 +
 include/linux/fscrypt_supp.h                       |   1 +
 include/linux/hugetlb.h                            |   9 +
 include/linux/list.h                               |  29 +-
 include/linux/memory_hotplug.h                     |   4 +-
 include/linux/pci.h                                |   5 +-
 include/linux/power/max17042_battery.h             |   2 +-
 include/linux/skbuff.h                             |   2 +-
 include/linux/sunrpc/svc.h                         |   2 +
 include/uapi/linux/pkt_sched.h                     |   2 +
 include/uapi/linux/serial_reg.h                    |   1 +
 kernel/bpf/core.c                                  |  18 +-
 kernel/bpf/disasm.c                                |  16 +-
 kernel/bpf/verifier.c                              | 498 ++++++++++-----------
 kernel/events/core.c                               |   2 +-
 kernel/fork.c                                      |   1 +
 kernel/locking/mutex.c                             |  15 +-
 kernel/pid_namespace.c                             |   3 +-
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/sched.h                               |   2 +
 kernel/time/hrtimer.c                              |  60 ++-
 lib/mpi/mpiutil.c                                  |   2 +-
 lib/test_bpf.c                                     |  13 +-
 mm/memory_hotplug.c                                |   4 +-
 mm/page_alloc.c                                    |   8 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/bluetooth/cmtp/cmtp.h                          |   2 +-
 net/bluetooth/hci_core.c                           |  14 +
 net/bluetooth/hci_event.c                          | 108 +++--
 net/bluetooth/sco.c                                |  85 ++--
 net/caif/chnl_net.c                                |  19 +-
 net/core/flow_dissector.c                          |  12 +-
 net/core/net_namespace.c                           |  18 +-
 net/dccp/minisocks.c                               |   2 +
 net/dsa/slave.c                                    |  12 +-
 net/ipv4/icmp.c                                    |  23 +-
 net/ipv4/igmp.c                                    |   2 +
 net/ipv4/ip_gre.c                                  |   9 +-
 net/ipv4/ip_output.c                               |   5 +-
 net/ipv4/route.c                                   |  48 +-
 net/ipv4/tcp_fastopen.c                            |   3 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                |   5 +-
 net/ipv6/netfilter/nf_socket_ipv6.c                |   4 +-
 net/l2tp/l2tp_core.c                               |   4 +-
 net/mac80211/tx.c                                  |   4 +-
 net/netlabel/netlabel_cipso_v4.c                   |  12 +-
 net/netlink/af_netlink.c                           |   4 +-
 net/sched/sch_cbq.c                                |   2 +-
 net/sched/sch_fq_codel.c                           |  12 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   2 +-
 net/sunrpc/svc.c                                   |  27 +-
 net/tipc/socket.c                                  |  36 +-
 net/unix/af_unix.c                                 |   2 +-
 samples/bpf/test_override_return.sh                |   1 +
 samples/bpf/tracex7_user.c                         |   5 +
 security/integrity/ima/Kconfig                     |   1 -
 security/integrity/ima/ima_mok.c                   |   2 +-
 security/smack/smack_access.c                      |  17 +-
 sound/core/pcm_lib.c                               |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   9 +-
 sound/soc/rockchip/rockchip_i2s.c                  |  35 +-
 sound/usb/quirks.c                                 |   1 +
 tools/perf/util/machine.c                          |   1 +
 tools/testing/selftests/bpf/test_maps.c            |   2 +-
 tools/testing/selftests/bpf/test_verifier.c        | 144 +++++-
 tools/thermal/tmon/Makefile                        |   2 +-
 virt/kvm/arm/arm.c                                 |   8 +
 294 files changed, 2182 insertions(+), 1183 deletions(-)


