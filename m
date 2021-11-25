Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5090645D74C
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 10:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353976AbhKYJiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 04:38:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349459AbhKYJgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 04:36:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24264610D2;
        Thu, 25 Nov 2021 09:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637832793;
        bh=46dVKrVr6lFX3Nz6/yAKr1kflaVByiusrk89ZG87XJY=;
        h=From:To:Cc:Subject:Date:From;
        b=DCuF4a+UMPn1I+Qm7nui3vIvIna2eUZDwUOPMCTh1L/noHLTVquzRiE6z2Qyk0EoA
         dWIDqMhX4Ii/EgSXg2ejsAXBQyBVuI5F5gI42s4O/sSNjN5EaTXnAqwBzg0Pv5z1wO
         LafwPVt9zwYxgRh0sfUbDnOX/m6WJ3HwzjQs00QU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/153] 5.10.82-rc2 review
Date:   Thu, 25 Nov 2021 10:23:48 +0100
Message-Id: <20211125092029.973858485@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.82-rc2
X-KernelTest-Deadline: 2021-11-27T09:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.82 release.
There are 153 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Nov 2021 09:20:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.82-rc2

Sasha Levin <sashal@kernel.org>
    Revert "perf: Rework perf_event_exit_event()"

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: hdac_stream: fix potential locking issue in snd_hdac_stream_assign()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: hdac_ext_stream: fix potential locking issues

Randy Dunlap <rdunlap@infradead.org>
    x86/Kconfig: Fix an unused variable error in dell-smm-hwmon

Josef Bacik <josef@toxicpanda.com>
    btrfs: update device path inode time instead of bd_inode

Josef Bacik <josef@toxicpanda.com>
    fs: export an inode_update_time helper

Leon Romanovsky <leon@kernel.org>
    ice: Delete always true check of PF pointer

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: max-3421: Use driver data instead of maintaining a list of bound devices

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Cover regression by kctl change notification fix

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix NULL-pointer dereference when hashtab allocation fails

Leon Romanovsky <leon@kernel.org>
    RDMA/netlink: Add __maybe_unused to static inline in C file

Nadav Amit <namit@vmware.com>
    hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Fix task management completion timeout race

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Fix task management completion

hongao <hongao@uniontech.com>
    drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Ensure sink rate values are always valid

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: clean up all clients on device removal

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: use drm_dev_unplug() during device removal

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: Add a dedicated mutex for the clients list

Johan Hovold <johan@kernel.org>
    drm/udl: fix control-message timeout

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Update swizzle mode enums

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Sven Schnelle <svens@stackframe.org>
    parisc/sticon: fix reverse colors

Nikolay Borisov <nborisov@suse.com>
    btrfs: fix memory ordering between normal and ordered work functions

Meng Li <meng.li@windriver.com>
    net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform

Jan Kara <jack@suse.cz>
    udf: Fix crash after seekdir

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: nVMX: don't use vcpu->arch.efer when checking host state on nested state load

Alistair Delva <adelva@google.com>
    block: Check ADMIN before NICE for IOPRIO_CLASS_RT

Baoquan He <bhe@redhat.com>
    s390/kexec: fix memory leak of ipl report buffer

Ewan D. Milne <emilne@redhat.com>
    scsi: qla2xxx: Fix mailbox direction flags in qla2xxx_get_adapter_id()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX

Sean Christopherson <seanjc@google.com>
    x86/hyperv: Fix NULL deref in set_hv_tscchange_cb() if Hyper-V setup fails

Rustam Kovhaev <rkovhaev@gmail.com>
    mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    ipc: WARN if trying to remove ipc object which is absent

Tadeusz Struk <tadeusz.struk@linaro.org>
    tipc: check for null after calling kmemdup

Nathan Chancellor <nathan@kernel.org>
    hexagon: clean up timer-regs.h

Nathan Chancellor <nathan@kernel.org>
    hexagon: export raw I/O routines for modules

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    tun: fix bonding active backup with arp monitoring

Nick Desaulniers <ndesaulniers@google.com>
    arm64: vdso32: suppress error message for 'make mrproper'

Punit Agrawal <punitagrawal@gmail.com>
    net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices

Heiko Carstens <hca@linux.ibm.com>
    s390/kexec: fix return code handling

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server

Bjorn Andersson <bjorn.andersson@linaro.org>
    pinctrl: qcom: sdm845: Enable dual edge errata

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Use GLOBAL_TOC for kvmppc_h_set_dabr/xdabr()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    e100: fix device suspend/resume

Lin Ma <linma@zju.edu.cn>
    NFC: add NCI_UNREG flag to eliminate the race

Bongsu Jeon <bongsu.jeon@samsung.com>
    net: nfc: nci: Change the NCI close sequence

Lin Ma <linma@zju.edu.cn>
    NFC: reorder the logic in nfc_{un,}register_device

Lin Ma <linma@zju.edu.cn>
    NFC: reorganize the functions in nci_request

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix display error code in dmesg

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix creation of first queue by omitting it if is not power of two

Karen Sornek <karen.sornek@intel.com>
    i40e: Fix warning message and call stack during rmmod i40e driver

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix ping is lost after configuring ADq on VF

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix changing previously set num_queue_pairs for PFs

Michal Maloszewski <michal.maloszewski@intel.com>
    i40e: Fix NULL ptr dereference on VSI filter sync

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix correct max_pkt_size on VF RX queue

Jonathan Davies <jonathan.davies@nutanix.com>
    net: virtio_net_hdr_to_skb: count transport header in UFO

Pavel Skripkin <paskripkin@gmail.com>
    net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove

Xin Long <lucien.xin@gmail.com>
    net: sched: act_mirred: drop dst for the direction from egress to ingress

Mike Christie <michael.christie@oracle.com>
    scsi: core: sysfs: Fix hang when device state is set via sysfs

Raed Salem <raeds@nvidia.com>
    net/mlx5: E-Switch, return error if encap isn't supported

Roi Dayan <roid@nvidia.com>
    net/mlx5: E-Switch, Change mode lock from mutex to rw semaphore

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Lag, update tracker when state change event received

Valentine Fatiev <valentinef@nvidia.com>
    net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Randy Dunlap <rdunlap@infradead.org>
    mips: lantiq: add support for clk_get_parent()

Randy Dunlap <rdunlap@infradead.org>
    mips: bcm63xx: add support for clk_get_parent()

Colin Ian King <colin.i.king@googlemail.com>
    MIPS: generic/yamon-dt: fix uninitialized variable error

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    iavf: Fix for setting queues to 0

Surabhi Boob <surabhi.boob@intel.com>
    iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Mitch Williams <mitch.a.williams@intel.com>
    iavf: validate pointers

Jacob Keller <jacob.e.keller@intel.com>
    iavf: prevent accidental free of filter structure

Piotr Marczak <piotr.marczak@intel.com>
    iavf: Fix failure to exit out from last all-multicast mode

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: free q_vectors before queues in iavf_disable_vf

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: check for null in iavf_fix_features

Mateusz Palczewski <mateusz.palczewski@intel.com>
    iavf: Fix return of set the new channel count

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Make sure the link_id is unique

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    sock: fix /proc/net/sockstat underflow in sk_clone_lock()

Eric Dumazet <edumazet@google.com>
    net: reduce indentation level in sk_clone_lock()

Xin Long <lucien.xin@gmail.com>
    tipc: only accept encrypted MSG_CRYPTO msgs

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    bnxt_en: reject indirect blk offload when hw-tc-offload is off

Pavel Skripkin <paskripkin@gmail.com>
    net: bnx2x: fix variable dereferenced before check

Alex Elder <elder@linaro.org>
    net: ipa: disable HOLB drop when updating timer

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add length protection to histogram string copies

Arjun Roy <arjunroy@google.com>
    tcp: Fix uninitialized access in skb frags array for Rx 0cp.

Arjun Roy <arjunroy@google.com>
    net-zerocopy: Refactor skb frag fast-forward op.

Arjun Roy <arjunroy@google.com>
    net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    drm/nouveau: hdmigv100.c: fix corrupted HDMI Vendor InfoFrame

James Clark <james.clark@arm.com>
    perf tests: Remove bash construct from record+zstd_comp_decomp.sh

Sohaib Mohamed <sohaib.amhmd@gmail.com>
    perf bench futex: Fix memory leak of perf_cpu_map__new()

Ian Rogers <irogers@google.com>
    perf bpf: Avoid memory leak from perf_env__insert_btf()

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/histogram: Do not copy the fixed-size char array field over the field size

Laibin Qiu <qiulaibin@huawei.com>
    blkcg: Remove extra blkcg_bio_issue_init

Like Xu <likexu@tencent.com>
    perf/x86/vlbr: Add c->flags to vlbr event constraints

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Randy Dunlap <rdunlap@infradead.org>
    mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk

Joel Stanley <joel@jms.id.au>
    clk/ast2600: Fix soc revision for AHB

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic: Fix bugs with divided dividers

Chao Yu <chao@kernel.org>
    f2fs: fix incorrect return value in f2fs_sanity_check_ckpt()

Hyeong-Jun Kim <hj514.kim@samsung.com>
    f2fs: compress: disallow disabling compress on non-empty compressed file

Randy Dunlap <rdunlap@infradead.org>
    sh: define __BIG_ENDIAN for math-emu

Randy Dunlap <rdunlap@infradead.org>
    sh: math-emu: drop unused functions

Randy Dunlap <rdunlap@infradead.org>
    sh: fix kconfig unmet dependency warning for FRAME_POINTER

Keoseong Park <keosung.park@samsung.com>
    f2fs: fix to use WHINT_MODE

Gao Xiang <hsiangkao@linux.alibaba.com>
    f2fs: fix up f2fs_lookup tracepoints

Lu Wei <luwei32@huawei.com>
    maple: fix wrong return value of maple_bus_init().

Nick Desaulniers <ndesaulniers@google.com>
    sh: check return code of request_irq

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/dcr: Use cmplwi instead of 3-argument cmpli

Chengfeng Ye <cyeaa@connect.ust.hk>
    ALSA: gus: fix null pointer dereference on pointer block

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: fix memory and mdio nodes naming for RB3011

Anatolij Gustschin <agust@denx.de>
    powerpc/5200: dts: fix memory node unit name

Teng Qi <starmiku1207184332@gmail.com>
    iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix alua_tg_pt_gps_count tracking

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix ordered tag handling

Ye Bin <yebin10@huawei.com>
    scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()

Ye Bin <yebin10@huawei.com>
    scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()

Bart Van Assche <bvanassche@acm.org>
    MIPS: sni: Fix the build

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Randy Dunlap <rdunlap@infradead.org>
    ALSA: ISA: not for M68K

Li Yang <leoyang.li@nxp.com>
    ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash

Li Yang <leoyang.li@nxp.com>
    ARM: dts: ls1021a: move thermal-zones node out of soc/

Yang Yingliang <yangyingliang@huawei.com>
    usb: host: ohci-tmio: check return value after calling platform_get_resource()

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap: fix gpmc,mux-add-data type

Luis Chamberlain <mcgrof@kernel.org>
    firmware_loader: fix pre-allocated buf built-in firmware use

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec

Guo Zhi <qtxuning1999@sjtu.edu.cn>
    scsi: advansys: Fix kernel pointer leak

Hans de Goede <hdegoede@redhat.com>
    ASoC: nau8824: Add DMI quirk mechanism for active-high jack-detect

Stefan Riedmueller <s.riedmueller@phytec.de>
    clk: imx: imx6ul: Move csi_sel mux to correct base register

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix potential locking issue

Michael Walle <michael@walle.cc>
    arm64: dts: freescale: fix arm,sp805 compatible string

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency

Christian Lamparter <chunkeey@gmail.com>
    ARM: BCM53016: Specify switch ports for Meraki MR32

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: remove possible deadlock when disconnect (v2)

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Skomer regulator fixes

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Remove WARN_ON in tps6598x_block_read

Yang Yingliang <yangyingliang@huawei.com>
    usb: musb: tusb6010: check return value after calling platform_get_resource()

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Use context lost quirk for otg

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Add quirk handling for reinit on context lost

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Check if the vlan is valid before reporting

Michael Walle <michael@walle.cc>
    arm64: dts: hisilicon: fix arm,sp805 compatible string

Matthias Brugger <mbrugger@suse.com>
    arm64: dts: rockchip: Disable CDN DP on Pinebook Pro

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()

Matthew Hagan <mnhagan88@gmail.com>
    ARM: dts: NSP: Fix mpcore, mmc node names

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: ensure IRQ is ready before enabling it

Maxime Ripard <maxime@cerno.tech>
    arm64: dts: allwinner: a100: Fix thermal zone node name

Maxime Ripard <maxime@cerno.tech>
    arm64: dts: allwinner: h5: Fix GPU thermal zone node name

Maxime Ripard <maxime@cerno.tech>
    ARM: dts: sunxi: Fix OPPs node name

Michal Simek <michal.simek@xilinx.com>
    arm64: zynqmp: Fix serial compatible string

Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
    arm64: zynqmp: Do not duplicate flash partition label property


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |   4 +-
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts         |  22 +++
 arch/arm/boot/dts/ls1021a-tsn.dts                  |   2 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |  66 +++----
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi          |   2 +-
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi  |   2 +-
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts          |   6 +-
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts     |   8 +-
 arch/arm/boot/dts/sun8i-a33.dtsi                   |   4 +-
 arch/arm/boot/dts/sun8i-a83t.dtsi                  |   4 +-
 arch/arm/boot/dts/sun8i-h3.dtsi                    |   4 +-
 arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi     |   6 +-
 .../boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi     |   2 +-
 .../boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi      |   2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi       |   2 +-
 .../boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi      |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |  16 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |  16 +-
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |   4 +-
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi          |   2 +-
 arch/arm64/boot/dts/qcom/ipq6018.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  20 ++-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |   4 -
 .../boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts    |   4 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/arm64/kernel/vdso32/Makefile                  |   3 +-
 arch/hexagon/include/asm/timer-regs.h              |  26 ---
 arch/hexagon/include/asm/timex.h                   |   3 +-
 arch/hexagon/kernel/time.c                         |  12 +-
 arch/hexagon/lib/io.c                              |   4 +
 arch/mips/Kconfig                                  |   3 +
 arch/mips/bcm63xx/clk.c                            |   6 +
 arch/mips/generic/yamon-dt.c                       |   2 +-
 arch/mips/lantiq/clk.c                             |   6 +
 arch/mips/sni/time.c                               |   4 +-
 arch/powerpc/boot/dts/charon.dts                   |   2 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |   2 +-
 arch/powerpc/boot/dts/lite5200.dts                 |   2 +-
 arch/powerpc/boot/dts/lite5200b.dts                |   2 +-
 arch/powerpc/boot/dts/media5200.dts                |   2 +-
 arch/powerpc/boot/dts/mpc5200b.dtsi                |   2 +-
 arch/powerpc/boot/dts/o2d.dts                      |   2 +-
 arch/powerpc/boot/dts/o2d.dtsi                     |   2 +-
 arch/powerpc/boot/dts/o2dnt2.dts                   |   2 +-
 arch/powerpc/boot/dts/o3dnt.dts                    |   2 +-
 arch/powerpc/boot/dts/pcm032.dts                   |   2 +-
 arch/powerpc/boot/dts/tqm5200.dts                  |   2 +-
 arch/powerpc/kernel/head_8xx.S                     |  13 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   4 +-
 arch/powerpc/sysdev/dcr-low.S                      |   2 +-
 arch/s390/include/asm/kexec.h                      |   6 +
 arch/s390/kernel/ipl.c                             |   3 +-
 arch/s390/kernel/machine_kexec_file.c              |  18 +-
 arch/sh/Kconfig.debug                              |   1 +
 arch/sh/include/asm/sfp-machine.h                  |   8 +
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |   5 +-
 arch/sh/math-emu/math.c                            | 103 -----------
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/events/intel/core.c                       |   4 +-
 arch/x86/events/intel/uncore_snbep.c               |   4 +
 arch/x86/hyperv/hv_init.c                          |   3 +
 arch/x86/kvm/vmx/nested.c                          |  22 ++-
 block/blk-core.c                                   |   4 +-
 block/ioprio.c                                     |   9 +-
 drivers/base/firmware_loader/main.c                |  13 +-
 drivers/bus/ti-sysc.c                              | 110 +++++++++++-
 drivers/clk/clk-ast2600.c                          |  12 +-
 drivers/clk/imx/clk-imx6ul.c                       |   2 +-
 drivers/clk/ingenic/cgu.c                          |   6 +-
 drivers/clk/qcom/gcc-msm8996.c                     |  15 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   4 +-
 .../drm/amd/display/dc/dml/display_mode_enums.h    |   4 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |  11 ++
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  42 ++++-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |   5 +
 .../gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c   |   1 -
 drivers/gpu/drm/udl/udl_connector.c                |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  12 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/intel/e100.c                  |  18 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 160 +++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 121 +++++--------
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  30 +++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  28 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  28 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   5 +
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  24 ++-
 drivers/net/ipa/ipa_endpoint.c                     |   2 +
 drivers/net/tun.c                                  |   5 +
 drivers/pinctrl/qcom/pinctrl-sdm845.c              |   1 +
 drivers/platform/x86/hp_accel.c                    |   2 +
 drivers/scsi/advansys.c                            |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   1 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |   6 +-
 drivers/scsi/scsi_debug.c                          |  11 +-
 drivers/scsi/scsi_sysfs.c                          |  30 ++--
 drivers/scsi/ufs/ufshcd.c                          |  57 +++----
 drivers/scsi/ufs/ufshcd.h                          |   1 +
 drivers/sh/maple/maple.c                           |   5 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   7 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          |  10 +-
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c       |  22 +--
 drivers/staging/rtl8723bs/core/rtw_xmit.c          |  16 +-
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c     |   2 -
 drivers/staging/wfx/bus_sdio.c                     |  17 +-
 drivers/target/target_core_alua.c                  |   1 -
 drivers/target/target_core_device.c                |   2 +
 drivers/target/target_core_internal.h              |   1 +
 drivers/target/target_core_transport.c             |  76 ++++++---
 drivers/tty/tty_buffer.c                           |   3 +
 drivers/usb/host/max3421-hcd.c                     |  25 +--
 drivers/usb/host/ohci-tmio.c                       |   2 +-
 drivers/usb/musb/tusb6010.c                        |   5 +
 drivers/usb/typec/tps6598x.c                       |   2 +-
 drivers/video/console/sticon.c                     |  12 +-
 fs/btrfs/async-thread.c                            |  14 ++
 fs/btrfs/volumes.c                                 |  21 ++-
 fs/f2fs/f2fs.h                                     |   3 +-
 fs/f2fs/super.c                                    |   4 +-
 fs/inode.c                                         |   7 +-
 fs/udf/dir.c                                       |  32 +++-
 fs/udf/namei.c                                     |   3 +
 fs/udf/super.c                                     |   2 +
 include/linux/fs.h                                 |   2 +
 include/linux/perf_event.h                         |   1 -
 include/linux/platform_data/ti-sysc.h              |   1 +
 include/linux/trace_events.h                       |   2 +-
 include/linux/virtio_net.h                         |   7 +-
 include/net/nfc/nci_core.h                         |   1 +
 include/rdma/rdma_netlink.h                        |   2 +-
 include/sound/hdaudio_ext.h                        |   2 +
 include/target/target_core_base.h                  |   6 +-
 include/trace/events/f2fs.h                        |  12 +-
 include/uapi/linux/tcp.h                           |   2 +
 ipc/util.c                                         |   6 +-
 kernel/events/core.c                               | 142 +++++++---------
 kernel/sched/core.c                                |   3 +
 kernel/trace/trace_events_hist.c                   |  14 +-
 mm/hugetlb.c                                       |  23 ++-
 mm/slab.h                                          |   2 +-
 net/core/sock.c                                    | 189 ++++++++++-----------
 net/ipv4/tcp.c                                     | 122 ++++++++++---
 net/nfc/core.c                                     |  32 ++--
 net/nfc/nci/core.c                                 |  34 +++-
 net/sched/act_mirred.c                             |  11 +-
 net/smc/smc_core.c                                 |   3 +-
 net/tipc/crypto.c                                  |   4 +
 net/tipc/link.c                                    |   7 +-
 net/wireless/util.c                                |   1 +
 security/selinux/ss/hashtab.c                      |  17 +-
 sound/core/Makefile                                |   2 +
 sound/hda/ext/hdac_ext_stream.c                    |  46 +++--
 sound/hda/hdac_stream.c                            |   4 +-
 sound/hda/intel-dsp-config.c                       |  22 ++-
 sound/isa/Kconfig                                  |   2 +-
 sound/isa/gus/gus_dma.c                            |   2 +
 sound/pci/Kconfig                                  |   1 +
 sound/soc/codecs/nau8824.c                         |  40 +++++
 sound/soc/soc-dapm.c                               |  29 +++-
 sound/soc/sof/intel/hda-dai.c                      |   7 +-
 tools/perf/bench/futex-lock-pi.c                   |   1 +
 tools/perf/bench/futex-requeue.c                   |   1 +
 tools/perf/bench/futex-wake-parallel.c             |   1 +
 tools/perf/bench/futex-wake.c                      |   1 +
 tools/perf/tests/shell/record+zstd_comp_decomp.sh  |   2 +-
 tools/perf/util/bpf-event.c                        |   6 +-
 tools/perf/util/env.c                              |   5 +-
 tools/perf/util/env.h                              |   2 +-
 180 files changed, 1483 insertions(+), 983 deletions(-)


