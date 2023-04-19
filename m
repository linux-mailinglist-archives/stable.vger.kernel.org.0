Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB48D6E73EC
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjDSHYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjDSHYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AEB8A50;
        Wed, 19 Apr 2023 00:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B4416323E;
        Wed, 19 Apr 2023 07:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541ABC433D2;
        Wed, 19 Apr 2023 07:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681889020;
        bh=mg8gvMPd31sbwWRvcVJbaTICZdd3CItZxGLkUgYEh1s=;
        h=From:To:Cc:Subject:Date:From;
        b=D6aMIIJORBPHg65GsqCasRbwxUU2VOMvv2LwZ97QX9DIkTImstWTOuIV02IaYj9k2
         hQl76m4uOe4iQlYhwTSWMRHLU4dD73/zLLE+ylhjvVkFLZQ44Xt1ZRD4ZHygXTZDg1
         40XK2qtSZnEEL0hfOikgwUpo7vYkEqQOKJ9gYxak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/120] 5.10.178-rc2 review
Date:   Wed, 19 Apr 2023 09:23:38 +0200
Message-Id: <20230419072207.996418578@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.178-rc2
X-KernelTest-Deadline: 2023-04-21T07:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.178 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 21 Apr 2023 07:21:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.178-rc2

Kuniyuki Iwashima <kuniyu@amazon.com>
    sysctl: Fix data-races in proc_dou8vec_minmax().

Valentin Schneider <vschneid@redhat.com>
    panic, kexec: make __crash_kexec() NMI safe

Valentin Schneider <vschneid@redhat.com>
    kexec: turn all kexec_mutex acquisitions into trylocks

Arnd Bergmann <arnd@arndb.de>
    kexec: move locking into do_kexec_load

Nathan Chancellor <nathan@kernel.org>
    riscv: Handle zicsr/zifencei issues between clang and binutils

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: check CONFIG_AS_IS_LLVM instead of LLVM_IAS

Nathan Chancellor <nathan@kernel.org>
    kbuild: Switch to 'f' variants of integrated assembler flag

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: check the minimum assembler version in Kconfig

Steve Clevenger <scclevenger@os.amperecomputing.com>
    coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

George Cherian <george.cherian@marvell.com>
    watchdog: sbsa_wdog: Make sure the timeout programming is within the limits

Gregor Herburger <gregor.herburger@tq-group.com>
    i2c: ocores: generate stop condition after timeout in polling mode

Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
    x86/rtc: Remove __init for runtime functions

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix imbalance overflow

zgpeng <zgpeng.linux@gmail.com>
    sched/fair: Move calculate of avg_load to a better location

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/papr_scm: Update the NUMA distance table for the target node

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: Add support for FORM2 associativity

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: Add a helper for form1 cpu distance

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: Consolidate different NUMA distance update code paths

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: Rename TYPE1_AFFINITY to FORM1_AFFINITY

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: rename min_common_depth to primary_domain_index

ZhaoLong Wang <wangzhaolong1@huawei.com>
    ubi: Fix deadlock caused by recursively holding work_sem

Lee Jones <lee.jones@linaro.org>
    mtd: ubi: wl: Fix a couple of kernel-doc issues

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Jiri Kosina <jkosina@suse.cz>
    scsi: ses: Handle enclosure with just a primary component gracefully

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    net: sfp: initialize sfp->i2c_block_size at sfp allocation

Mathis Salmen <mathis.salmen@matsal.de>
    riscv: add icache flush for nommu sigreturn trampoline

Robbie Harwood <rharwood@redhat.com>
    asymmetric_keys: log on fatal failures in PE/pkcs7

Robbie Harwood <rharwood@redhat.com>
    verify_pefile: relax wrapper length check

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Hans de Goede <hdegoede@redhat.com>
    efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: clean rx/tx buffers upon new message

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    wifi: mwifiex: mark OF related data as maybe unused

Grant Grundler <grundler@chromium.org>
    power: supply: cros_usbpd: reclassify "default case!" as debug

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix single-line struct definition output in btf_dump

Roman Gushchin <roman.gushchin@linux.dev>
    net: macb: fix a memory corruption in extended buffer descriptor mode

Eric Dumazet <edumazet@google.com>
    udp6: fix potential access to stale information

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/core: Fix GID entry ref leak when create_ah fails

Xin Long <lucien.xin@gmail.com>
    sctp: fix a potential overflow in sctp_ifwdtsn_skip

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()

Denis Plotnikov <den-plotnikov@yandex-team.ru>
    qlcnic: check pci_reset_function result

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/armada: Fix a potential double free in an error handling path

YueHaibing <yuehaibing@huawei.com>
    tcp: restrict net.ipv4.tcp_app_win

Eric Dumazet <edumazet@google.com>
    tcp: convert elligible sysctls to u8

Eric Dumazet <edumazet@google.com>
    ipv4: shrink netns_ipv4 with sysctl conversions

Eric Dumazet <edumazet@google.com>
    sysctl: add proc_dou8vec_minmax()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    niu: Fix missing unwind goto in niu_alloc_channels()

Zheng Wang <zyytlz.wz@163.com>
    9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Mark Zhang <markzhang@nvidia.com>
    RDMA/cma: Allow UD qp_type to join multicast only

Maher Sanalla <msanalla@nvidia.com>
    IB/mlx5: Add support for 400G_8X lane speed

Meir Lichtinger <meirl@mellanox.com>
    IB/mlx5: Add support for NDR link speed

Chunyan Zhang <chunyan.zhang@unisoc.com>
    clk: sprd: set max_register according to mapping range

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: use timings.mode instead of checking tRC_min

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: remove unsupported EDO mode

Arseniy Krasnov <avkrasnov@sberdevices.ru>
    mtd: rawnand: meson: fix bitmask for length in command word

Bang Li <libang.linuxer@gmail.com>
    mtdblock: tolerate corrected bit-flips

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbmem: Reject FB_ACTIVATE_KD_TEXT from userspace

Christoph Hellwig <hch@lst.de>
    btrfs: fix fast csum implementation detection

David Sterba <dsterba@suse.com>
    btrfs: print checksum type and implementation at mount time

Min Li <lm0963hack@gmail.com>
    Bluetooth: Fix race condition in hidp_session_thread

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Xu Biang <xubiang@hust.edu.cn>
    ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: i2c/cs8427: fix iec958 mixer control deactivation

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: fix capture interrupt handler unlinking

Kornel Dulęba <korneld@chromium.org>
    Revert "pinctrl: amd: Disable and mask interrupts on resume"

Eduard Zingerman <eddyz87@gmail.com>
    bpftool: Print newline before '}' for struct with padding only fields

Heming Zhao <ocfs2-devel@oss.oracle.com>
    ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown

Gaosheng Cui <cuigaosheng1@huawei.com>
    Revert "media: ti: cal: fix possible memory leak in cal_ctx_create()"

Robert Foss <robert.foss@linaro.org>
    drm/bridge: lt9611: Fix PLL being unable to lock

Tommi Rantala <tommi.t.rantala@nokia.com>
    selftests: intel_pstate: ftime() is deprecated

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Zheng Yejian <zhengyejian1@huawei.com>
    ring-buffer: Fix race while reader and writer are on the same page

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/disp: Support more modes by checking with lower bpc

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Jason Montleon <jmontleo@redhat.com>
    ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Free error logs of tracing instances

Michal Sojka <michal.sojka@cvut.cz>
    can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix issue that 'direct->addr' not restored in modify_ftrace_direct()

John Keeping <john@metanate.com>
    ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix the same task check in perf_event_set_output

Zhong Jinghua <zhongjinghua@huawei.com>
    scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad7791: fix IRQ flags

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo X370SNW

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix sysfs interface lifetime

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix transmit end interrupt handler

Kai-Heng Feng <kai.heng.feng@canonical.com>
    iio: light: cm32181: Unregister second I2C client if present

William Breathitt Gray <william.gray@linaro.org>
    iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Lars-Peter Clausen <lars@metafoo.de>
    iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Quectel RM500U-CN modem

Enrico Sau <enrico.sau@gmail.com>
    USB: serial: option: add Telit FE990 compositions

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: Fix configure initial pin assignment

Kees Jan Koster <kjkoster@kjkoster.org>
    USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

D Scott Phillips <scott@os.amperecomputing.com>
    xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Wayne Chang <waynec@nvidia.com>
    usb: xhci: tegra: fix sleep in atomic call

Dai Ngo <dai.ngo@oracle.com>
    NFSD: callback request does not use correct credential for AUTH_SYS

Jeff Layton <jlayton@kernel.org>
    sunrpc: only free unix grouplist after RCU settles

Corinna Vinschen <vinschen@redhat.com>
    net: stmmac: fix up RX flow hash indirection table when setting channels

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe

Dhruva Gole <d-gole@ti.com>
    gpio: davinci: Add irq chip flag to skip set wake

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6: Fix an uninit variable access bug in __ip6_make_skb()

Sricharan Ramabadhran <quic_srichara@quicinc.com>
    net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT

Xin Long <lucien.xin@gmail.com>
    sctp: check send stream number after wait_for_sndbuf

Jakub Kicinski <kuba@kernel.org>
    net: don't let netpoll invoke NAPI if in xmit context

Eric Dumazet <edumazet@google.com>
    icmp: guard against too small mtu

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: qrtr: Fix a refcount bug in qrtr_recvmsg()

Luca Weiss <luca@z3ntu.xyz>
    net: qrtr: combine nameservice into main module

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: pv: fix external interruption loop not always detected

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sprd: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: cros-ec: Explicitly set .polarity in .get_state()

Mohammed Gamal <mgamal@redhat.com>
    Drivers: vmbus: Check for channel allocation before looking up relids

Randy Dunlap <rdunlap@infradead.org>
    gpio: GPIO_REGMAP: select REGMAP instead of depending on it


-------------

Diffstat:

 .../devicetree/bindings/serial/renesas,scif.yaml   |   4 +-
 Documentation/networking/ip-sysctl.rst             |   2 +
 Documentation/powerpc/associativity.rst            | 104 +++++
 Documentation/sound/hd-audio/models.rst            |   2 +-
 Makefile                                           |  12 +-
 arch/powerpc/include/asm/firmware.h                |   7 +-
 arch/powerpc/include/asm/prom.h                    |   3 +-
 arch/powerpc/include/asm/topology.h                |   6 +-
 arch/powerpc/kernel/prom_init.c                    |   3 +-
 arch/powerpc/mm/numa.c                             | 433 ++++++++++++++++-----
 arch/powerpc/platforms/pseries/firmware.c          |   3 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   2 +
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +
 arch/powerpc/platforms/pseries/lpar.c              |   4 +-
 arch/powerpc/platforms/pseries/papr_scm.c          |   7 +
 arch/riscv/Kconfig                                 |  22 ++
 arch/riscv/Makefile                                |  12 +-
 arch/riscv/kernel/signal.c                         |   9 +-
 arch/s390/kvm/intercept.c                          |  32 +-
 arch/x86/kernel/sysfb_efi.c                        |   8 +
 arch/x86/kernel/x86_init.c                         |   4 +-
 arch/x86/pci/fixup.c                               |  21 +
 crypto/asymmetric_keys/pkcs7_verify.c              |  10 +-
 crypto/asymmetric_keys/verify_pefile.c             |  32 +-
 drivers/clk/sprd/common.c                          |   9 +-
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-davinci.c                        |   2 +-
 drivers/gpu/drm/armada/armada_drv.c                |   1 -
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   1 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  13 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  32 ++
 drivers/gpu/drm/nouveau/nouveau_dp.c               |   8 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   1 +
 drivers/hv/connection.c                            |   4 +
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   2 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   2 +
 drivers/i2c/busses/i2c-ocores.c                    |  35 +-
 drivers/iio/adc/ad7791.c                           |   2 +-
 drivers/iio/adc/ti-ads7950.c                       |   1 +
 drivers/iio/dac/cio-dac.c                          |   4 +-
 drivers/iio/light/cm32181.c                        |  12 +
 drivers/infiniband/core/cma.c                      |  60 +--
 drivers/infiniband/core/verbs.c                    |   2 +
 drivers/infiniband/hw/mlx5/main.c                  |  16 +
 drivers/media/platform/ti-vpe/cal.c                |   4 +-
 drivers/mtd/mtdblock.c                             |  12 +-
 drivers/mtd/nand/raw/meson_nand.c                  |   6 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |   3 +
 drivers/mtd/ubi/build.c                            |  21 +-
 drivers/mtd/ubi/wl.c                               |   5 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/ethernet/sun/niu.c                     |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   6 +-
 drivers/net/phy/sfp.c                              |  13 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/pinctrl/pinctrl-amd.c                      |  36 +-
 drivers/power/supply/cros_usbpd-charger.c          |   2 +-
 drivers/pwm/pwm-cros-ec.c                          |   1 +
 drivers/pwm/pwm-sprd.c                             |   1 +
 drivers/scsi/iscsi_tcp.c                           |   3 +-
 drivers/scsi/ses.c                                 |  20 +-
 drivers/tty/serial/fsl_lpuart.c                    |   8 +-
 drivers/tty/serial/sh-sci.c                        |  10 +-
 drivers/usb/host/xhci-tegra.c                      |   6 +-
 drivers/usb/host/xhci.c                            |   6 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/option.c                        |  10 +
 drivers/usb/typec/altmodes/displayport.c           |   6 +-
 drivers/video/fbdev/core/fbmem.c                   |   2 +
 drivers/watchdog/sbsa_gwdt.c                       |   1 +
 fs/btrfs/disk-io.c                                 |  17 +
 fs/btrfs/super.c                                   |   2 -
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nilfs2/segment.c                                |   3 +-
 fs/nilfs2/super.c                                  |   2 +
 fs/nilfs2/the_nilfs.c                              |  12 +-
 fs/ocfs2/dlmglue.c                                 |   8 +-
 fs/ocfs2/super.c                                   |   3 +-
 fs/proc/proc_sysctl.c                              |   6 +
 include/linux/ftrace.h                             |   2 +-
 include/linux/kexec.h                              |   2 +-
 include/linux/sysctl.h                             |   2 +
 include/net/netns/ipv4.h                           | 100 ++---
 init/Kconfig                                       |  12 +
 kernel/cgroup/cpuset.c                             |   6 +-
 kernel/events/core.c                               |   2 +-
 kernel/kexec.c                                     |  41 +-
 kernel/kexec_core.c                                |  28 +-
 kernel/kexec_file.c                                |   4 +-
 kernel/kexec_internal.h                            |  15 +-
 kernel/ksysfs.c                                    |   7 +-
 kernel/sched/fair.c                                |  15 +-
 kernel/sysctl.c                                    |  65 ++++
 kernel/trace/ftrace.c                              |  15 +-
 kernel/trace/ring_buffer.c                         |  13 +-
 kernel/trace/trace.c                               |   1 +
 mm/swapfile.c                                      |   3 +-
 net/9p/trans_xen.c                                 |   4 +
 net/bluetooth/hidp/core.c                          |   2 +-
 net/bluetooth/l2cap_core.c                         |  24 +-
 net/can/isotp.c                                    |  17 +-
 net/can/j1939/transport.c                          |   5 +-
 net/core/netpoll.c                                 |  19 +-
 net/ipv4/icmp.c                                    |   5 +
 net/ipv4/sysctl_net_ipv4.c                         | 203 +++++-----
 net/ipv6/ip6_output.c                              |   7 +-
 net/ipv6/udp.c                                     |   8 +-
 net/mac80211/sta_info.c                            |   3 +-
 net/qrtr/Makefile                                  |   3 +-
 net/qrtr/{qrtr.c => af_qrtr.c}                     |  15 +
 net/qrtr/ns.c                                      |  15 +-
 net/sctp/socket.c                                  |   4 +
 net/sctp/stream_interleave.c                       |   3 +-
 net/sunrpc/svcauth_unix.c                          |  17 +-
 scripts/Kconfig.include                            |   6 +
 scripts/as-version.sh                              |  69 ++++
 scripts/dummy-tools/gcc                            |   6 +
 sound/firewire/tascam/tascam-stream.c              |   2 +-
 sound/i2c/cs8427.c                                 |   7 +-
 sound/pci/emu10k1/emupcm.c                         |   4 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/hda/patch_sigmatel.c                     |  10 +
 sound/soc/codecs/hdac_hdmi.c                       |  17 +-
 tools/lib/bpf/btf_dump.c                           |  11 +-
 tools/testing/selftests/intel_pstate/aperf.c       |  22 +-
 128 files changed, 1492 insertions(+), 567 deletions(-)


