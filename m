Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553396E7686
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjDSJlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjDSJky (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:40:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEE51BF8;
        Wed, 19 Apr 2023 02:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6365162878;
        Wed, 19 Apr 2023 09:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246FCC433EF;
        Wed, 19 Apr 2023 09:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681897250;
        bh=586AsNnSs1U0Vtg9cXLupcRUWZk+x0eEIBkwhbpvCJA=;
        h=From:To:Cc:Subject:Date:From;
        b=sqponHL6tm1Zs8EECGpnuaU9GLKD3fzfLNA7zIoTfslD94Ux26XcQH3B+Pf9X51e4
         8sb7+OAykQeGz80L58AcGG3fCVXDsdBI/KCgJjCVCitaujdhB+AF6/3RpEQDfyw0r1
         rcWNbjpuDBOHgLgmnkURe0tPG8u2Ie1vkgcqBQos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/132] 6.1.25-rc2 review
Date:   Wed, 19 Apr 2023 11:40:48 +0200
Message-Id: <20230419093701.194867488@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.25-rc2
X-KernelTest-Deadline: 2023-04-21T09:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.25 release.
There are 132 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 21 Apr 2023 09:36:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.25-rc2

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Skip spread flags update on v2

Duy Truong <dory@dory.moe>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD

Juraj Pecigos <kernel@juraj.dev>
    nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN

Alyssa Ross <hi@alyssa.is>
    purgatory: fix disabling debug info

Heiko Stuebner <heiko.stuebner@vrull.eu>
    RISC-V: add infrastructure to allow different str* implementations

David Disseldorp <ddiss@suse.de>
    cifs: fix negotiate context parsing

Gregor Herburger <gregor.herburger@tq-group.com>
    i2c: ocores: generate stop condition after timeout in polling mode

Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
    x86/rtc: Remove __init for runtime functions

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix imbalance overflow

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/papr_scm: Update the NUMA distance table for the target node

Tharun Kumar P <tharunkumar.pasumarthi@microchip.com>
    i2c: mchp-pci1xxxx: Update Timing registers

ZhaoLong Wang <wangzhaolong1@huawei.com>
    ubi: Fix deadlock caused by recursively holding work_sem

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Paolo Abeni <pabeni@redhat.com>
    mptcp: stricter state check in mptcp_worker

Paolo Abeni <pabeni@redhat.com>
    mptcp: use mptcp_schedule_work instead of open-coding it

Horatio Zhang <Hongkun.Zhang@amd.com>
    drm/amd/pm: correct SMU13.0.7 max shader clock reporting

Horatio Zhang <Hongkun.Zhang@amd.com>
    drm/amd/pm: correct SMU13.0.7 pstate profiling clock settings

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix partition root's cpuset.cpus update bug

Josh Don <joshdon@google.com>
    cgroup: fix display of forceidle time at root

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    x86/PCI: Add quirk for AMD XHCI controller that loses MSI-X state in D3hot

Jiri Kosina <jkosina@suse.cz>
    scsi: ses: Handle enclosure with just a primary component gracefully

Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: fix unsigned long multiplication overflow

Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: add remove callback

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    net: sfp: initialize sfp->i2c_block_size at sfp allocation

Tanu Malhotra <tanu.malhotra@intel.com>
    HID: intel-ish-hid: Fix kernel panic during warm reset

Mathis Salmen <mathis.salmen@matsal.de>
    riscv: add icache flush for nommu sigreturn trampoline

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Do not set initial_boot_params to the linear address of the dtb

David Disseldorp <ddiss@suse.de>
    ksmbd: avoid out of bounds access in decode_preauth_ctxt()

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix write memory barrier of nodes once dead for RCU mode

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have tracing_snapshot_instance_cond() write errors to the appropriate instance

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Add trace_array_puts() to write into instance

Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
    KVM: SVM: Flush Hyper-V TLB when required

Sean Christopherson <seanjc@google.com>
    x86/hyperv: KVM: Rename "hv_enlightenments" to "hv_vmcb_enlightenments"

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Move "struct hv_enlightenments" to x86_64/svm.h

Sean Christopherson <seanjc@google.com>
    x86/hyperv: Move VMCB enlightenment definitions to hyperv-tlfs.h

Aymeric Wibo <obiwac@gmail.com>
    ACPI: resource: Add Medion S17413 to IRQ override quirk

Jane Jian <Jane.Jian@amd.com>
    drm/amdgpu/gfx: set cg flags to enter/exit safe mode

YuBiao Wang <YuBiao.Wang@amd.com>
    drm/amdgpu: Force signal hw_fences that are embedded in non-sched jobs

Tong Liu01 <Tong.Liu01@amd.com>
    drm/amdgpu: add mes resume when do gfx post soft reset

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: protect TXQ list manipulation

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix mvmtxq->stopped handling

Martin George <martinus.gpy@gmail.com>
    nvme: send Identify with CNS 06h only to I/O controllers

Robbie Harwood <rharwood@redhat.com>
    asymmetric_keys: log on fatal failures in PE/pkcs7

Robbie Harwood <rharwood@redhat.com>
    verify_pefile: relax wrapper length check

Tianyi Jing <jingfelix@hust.edu.cn>
    hwmon: (xgene) Fix ioremap and memremap leak

Iwona Winiarska <iwona.winiarska@intel.com>
    hwmon: (peci/cputemp) Fix miscalculated DTS for SKX

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Book X90F

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add backlight=native DMI quirk for Acer Aspire 3830TG

Ming Lei <ming.lei@redhat.com>
    block: ublk_drv: mark device as LIVE before adding disk

Hans de Goede <hdegoede@redhat.com>
    efi: sysfb_efi: Add quirk for Lenovo Yoga Book X91F/L

Yicong Yang <yangyicong@hisilicon.com>
    i2c: hisi: Avoid redundant interrupts

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: clean rx/tx buffers upon new message

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    wifi: mwifiex: mark OF related data as maybe unused

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Fix progs/find_vma_fail1.c build error.

Denis Arefev <arefev@swemel.ru>
    power: supply: axp288_fuel_gauge: Added check for negative values

Grant Grundler <grundler@chromium.org>
    power: supply: cros_usbpd: reclassify "default case!" as debug

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    power: supply: rk817: Fix unsigned comparison with less than zero

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom: apq8026-lg-lenok: add missing reserved memory

Andrew Jeffery <andrew@aj.id.au>
    ARM: 9290/1: uaccess: Fix KASAN false-positives

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix single-line struct definition output in btf_dump

Liang Chen <liangchen.linux@gmail.com>
    skbuff: Fix a race between coalescing and releasing SKBs

Roman Gushchin <roman.gushchin@linux.dev>
    net: macb: fix a memory corruption in extended buffer descriptor mode

Eric Dumazet <edumazet@google.com>
    udp6: fix potential access to stale information

Aaron Conole <aconole@redhat.com>
    selftests: openvswitch: adjust datapath NL message declaration

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/core: Fix GID entry ref leak when create_ah fails

Xin Long <lucien.xin@gmail.com>
    sctp: fix a potential overflow in sctp_ifwdtsn_skip

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cgroup,freezer: hold cpu_hotplug_lock before freezer_mutex

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    net: wwan: iosm: Fix error handling path in ipc_pcie_probe()

Denis Plotnikov <den-plotnikov@yandex-team.ru>
    qlcnic: check pci_reset_function result

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/armada: Fix a potential double free in an error handling path

Claudia Draghicescu <claudia.rosu@nxp.com>
    Bluetooth: Set ISO Data Path on broadcast sink

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix possible circular locking dependency sco_sock_getsockopt

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix printing errors if LE Connection times out

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix not cleaning up on LE Connection failure

Felix Huettner <felix.huettner@mail.schwarz>
    net: openvswitch: fix race on port output

Ahmed Zaki <ahmed.zaki@intel.com>
    iavf: remove active_cvlans and active_svlans bitmaps

Ahmed Zaki <ahmed.zaki@intel.com>
    iavf: refactor VLAN filter states

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix ns validation on backup slaves

YueHaibing <yuehaibing@huawei.com>
    tcp: restrict net.ipv4.tcp_app_win

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    niu: Fix missing unwind goto in niu_alloc_channels()

Fuad Tabba <tabba@google.com>
    KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs

Will Deacon <will@kernel.org>
    KVM: arm64: Initialise hypervisor copies of host symbols unconditionally

Xu Kuohai <xukuohai@huawei.com>
    bpf, arm64: Fixed a BTI error on returning to patched function

Zheng Wang <zyytlz.wz@163.com>
    9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition

Martin Povišer <povik+lin@cutebit.org>
    dmaengine: apple-admac: Fix 'current_tx' not getting freed

Martin Povišer <povik+lin@cutebit.org>
    dmaengine: apple-admac: Set src_addr_widths capability

Martin Povišer <povik+lin@cutebit.org>
    dmaengine: apple-admac: Handle 'global' interrupt flags

George Guo <guodongtai@kylinos.cn>
    LoongArch, bpf: Fix jit to skip speculation barrier opcode

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp

Mark Zhang <markzhang@nvidia.com>
    RDMA/cma: Allow UD qp_type to join multicast only

Alexander Stein <alexander.stein@ew.tq-group.com>
    clk: rs9: Fix suspend/resume

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Defer probing if netdevice can not be found

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Inline mtt entries into WQE if supported

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Update default EQ depth to 4096 and max_send_wr to 8192

Maher Sanalla <msanalla@nvidia.com>
    IB/mlx5: Add support for 400G_8X lane speed

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Add ipv4 check to irdma_find_listener()

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Increase iWARP CM default rexmit count

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix memory leak of PBLE objects

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Do not generate SW completions for NOPs

Chunyan Zhang <chunyan.zhang@unisoc.com>
    clk: sprd: set max_register according to mapping range

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsi: fix DSS CTL register offsets for TGL+

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: set_con2fb_map needs to set con2fb_map!

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: Fix error paths in set_con2fb_map

Reiji Watanabe <reijiw@google.com>
    KVM: arm64: PMU: Restore the guest's EL0 event counting after migration

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

Christoph Hellwig <hch@lst.de>
    btrfs: restore the thread_pool= behavior in remount for the end I/O workqueues

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix possible UAF

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: Free potentially unfreed SCO connection

Sasha Finkelstein <fnkl.kernel@gmail.com>
    bluetooth: btbcm: Fix logic error in forming the board name.

Min Li <lm0963hack@gmail.com>
    Bluetooth: Fix race condition in hidp_session_thread

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: disable KAE for Intel DG2

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: don't create old pass-through playback device on Audigy

Xu Biang <xubiang@hust.edu.cn>
    ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirks for Lenovo Z13/Z16 Gen2

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: patch_realtek: add quirk for Asus N7601ZM

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: i2c/cs8427: fix iec958 mixer control deactivation

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: fix capture interrupt handler unlinking

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Pass the right info to drm_dp_remove_payload

Kornel Dulęba <korneld@chromium.org>
    Revert "pinctrl: amd: Disable and mask interrupts on resume"


-------------

Diffstat:

 Documentation/networking/ip-sysctl.rst             |   2 +
 Documentation/sound/hd-audio/models.rst            |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts        |  10 ++
 arch/arm/lib/uaccess_with_memcpy.c                 |   4 +-
 arch/arm64/kvm/arm.c                               |  39 ++++-
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |   5 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   7 -
 arch/arm64/kvm/pmu-emul.c                          |   1 +
 arch/arm64/kvm/sys_regs.c                          |   1 -
 arch/arm64/net/bpf_jit.h                           |   4 +
 arch/arm64/net/bpf_jit_comp.c                      |   3 +-
 arch/loongarch/net/bpf_jit.c                       |   4 +
 arch/powerpc/mm/numa.c                             |   1 +
 arch/powerpc/platforms/pseries/papr_scm.c          |   7 +
 arch/riscv/include/asm/string.h                    |  10 ++
 arch/riscv/kernel/riscv_ksyms.c                    |   3 +
 arch/riscv/kernel/setup.c                          |   5 +-
 arch/riscv/kernel/signal.c                         |   9 +-
 arch/riscv/lib/Makefile                            |   3 +
 arch/riscv/lib/strcmp.S                            |  36 ++++
 arch/riscv/lib/strlen.S                            |  28 +++
 arch/riscv/lib/strncmp.S                           |  41 +++++
 arch/riscv/purgatory/Makefile                      |  14 +-
 arch/x86/include/asm/hyperv-tlfs.h                 |  22 +++
 arch/x86/include/asm/svm.h                         |   7 +-
 arch/x86/kernel/x86_init.c                         |   4 +-
 arch/x86/kvm/kvm_onhyperv.h                        |   5 +
 arch/x86/kvm/svm/hyperv.h                          |  22 ---
 arch/x86/kvm/svm/nested.c                          |  11 +-
 arch/x86/kvm/svm/svm.c                             |  37 +++-
 arch/x86/kvm/svm/svm.h                             |   5 +-
 arch/x86/kvm/svm/svm_onhyperv.c                    |   6 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |  34 ++--
 arch/x86/pci/fixup.c                               |  21 +++
 arch/x86/purgatory/Makefile                        |   3 +-
 crypto/asymmetric_keys/pkcs7_verify.c              |  10 +-
 crypto/asymmetric_keys/verify_pefile.c             |  32 ++--
 drivers/acpi/resource.c                            |   7 +
 drivers/acpi/video_detect.c                        |   8 +
 drivers/block/ublk_drv.c                           |   3 +-
 drivers/bluetooth/btbcm.c                          |   2 +-
 drivers/clk/clk-renesas-pcie.c                     |   3 +-
 drivers/clk/sprd/common.c                          |   9 +-
 drivers/dma/apple-admac.c                          |  20 ++-
 drivers/firmware/efi/sysfb_efi.c                   |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   9 +
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  14 ++
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  57 ++++++-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  83 ++++++++-
 drivers/gpu/drm/armada/armada_drv.c                |   1 -
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  13 +-
 drivers/gpu/drm/i915/display/icl_dsi.c             |  20 ++-
 drivers/hid/intel-ish-hid/ishtp/bus.c              |   4 +-
 drivers/hwmon/peci/cputemp.c                       |   8 +-
 drivers/hwmon/xgene-hwmon.c                        |  14 +-
 drivers/i2c/busses/i2c-hisi.c                      |   7 +
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   2 +
 drivers/i2c/busses/i2c-mchp-pci1xxxx.c             |  60 +++----
 drivers/i2c/busses/i2c-ocores.c                    |  35 ++--
 drivers/infiniband/core/cma.c                      |  60 ++++---
 drivers/infiniband/core/verbs.c                    |   2 +
 drivers/infiniband/hw/erdma/erdma_hw.h             |   2 +-
 drivers/infiniband/hw/erdma/erdma_main.c           |   2 +-
 drivers/infiniband/hw/erdma/erdma_qp.c             |   2 +-
 drivers/infiniband/hw/erdma/erdma_verbs.h          |   2 +-
 drivers/infiniband/hw/irdma/cm.c                   |  16 +-
 drivers/infiniband/hw/irdma/cm.h                   |   2 +-
 drivers/infiniband/hw/irdma/hw.c                   |   3 +
 drivers/infiniband/hw/irdma/utils.c                |   5 +-
 drivers/infiniband/hw/mlx5/main.c                  |   4 +
 drivers/mtd/mtdblock.c                             |  12 +-
 drivers/mtd/nand/raw/meson_nand.c                  |   6 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |   3 +
 drivers/mtd/ubi/build.c                            |  21 ++-
 drivers/mtd/ubi/wl.c                               |   4 +-
 drivers/net/bonding/bond_main.c                    |   5 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +
 drivers/net/ethernet/intel/iavf/iavf.h             |  20 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  44 ++---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  68 ++++----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c    |   8 +-
 drivers/net/ethernet/sun/niu.c                     |   2 +-
 drivers/net/phy/nxp-c45-tja11xx.c                  |  14 +-
 drivers/net/phy/sfp.c                              |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  50 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  29 +++-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |   3 +-
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/pci.c                            |   3 +
 drivers/pinctrl/pinctrl-amd.c                      |  36 ++--
 drivers/power/supply/axp288_fuel_gauge.c           |   2 +
 drivers/power/supply/cros_usbpd-charger.c          |   2 +-
 drivers/power/supply/rk817_charger.c               |   4 -
 drivers/scsi/ses.c                                 |  20 +--
 drivers/video/fbdev/core/fbcon.c                   |  18 +-
 drivers/video/fbdev/core/fbmem.c                   |   2 +
 fs/btrfs/disk-io.c                                 |  14 ++
 fs/btrfs/super.c                                   |   4 +-
 fs/cifs/smb2pdu.c                                  |  41 +++--
 fs/ksmbd/smb2pdu.c                                 |  23 ++-
 include/linux/trace.h                              |  12 ++
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/bonding.h                              |   8 +-
 kernel/cgroup/cpuset.c                             | 187 +++++++++++++++++----
 kernel/cgroup/legacy_freezer.c                     |   7 +-
 kernel/cgroup/rstat.c                              |   4 +-
 kernel/sched/fair.c                                |  10 ++
 kernel/trace/trace.c                               |  41 +++--
 lib/maple_tree.c                                   |   7 +-
 net/9p/trans_xen.c                                 |   4 +
 net/bluetooth/hci_conn.c                           |  92 ++++++----
 net/bluetooth/hci_event.c                          |  18 +-
 net/bluetooth/hci_sync.c                           |  13 +-
 net/bluetooth/hidp/core.c                          |   2 +-
 net/bluetooth/l2cap_core.c                         |  24 +--
 net/bluetooth/sco.c                                |  16 +-
 net/core/dev.c                                     |   1 +
 net/core/skbuff.c                                  |  16 +-
 net/ipv4/sysctl_net_ipv4.c                         |   3 +
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv6/udp.c                                     |   8 +-
 net/mptcp/options.c                                |   5 +-
 net/mptcp/protocol.c                               |   2 +-
 net/mptcp/subflow.c                                |  18 +-
 net/openvswitch/actions.c                          |   2 +-
 net/qrtr/af_qrtr.c                                 |   8 +-
 net/sctp/stream_interleave.c                       |   3 +-
 sound/firewire/tascam/tascam-stream.c              |   2 +-
 sound/i2c/cs8427.c                                 |   7 +-
 sound/pci/emu10k1/emupcm.c                         |  14 +-
 sound/pci/hda/patch_hdmi.c                         |   2 +-
 sound/pci/hda/patch_realtek.c                      |  29 ++++
 sound/pci/hda/patch_sigmatel.c                     |  10 ++
 tools/lib/bpf/btf_dump.c                           |   7 +-
 tools/testing/radix-tree/maple.c                   |  16 ++
 tools/testing/selftests/bpf/progs/find_vma_fail1.c |   1 +
 tools/testing/selftests/kvm/include/x86_64/svm.h   |  22 ++-
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |  25 +--
 .../testing/selftests/net/openvswitch/ovs-dpctl.py |   2 +-
 144 files changed, 1465 insertions(+), 631 deletions(-)


