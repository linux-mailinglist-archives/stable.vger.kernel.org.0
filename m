Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41C266C55E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjAPQFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjAPQE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:04:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C179B23DAE;
        Mon, 16 Jan 2023 08:03:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE1961031;
        Mon, 16 Jan 2023 16:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391B3C433F0;
        Mon, 16 Jan 2023 16:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884997;
        bh=JmsK8+7TDtvY2B5A/0E5cnkOSI1vcXcubIH2xn8bi4M=;
        h=From:To:Cc:Subject:Date:From;
        b=Emt7BI67D/KJz2GN1uGhEETUOYZGGA1K8zxpTLtdLB6X1huiPzM5NyMO+Igv8439J
         TvBsHBufNnIxmBiMf+t2WBWdVAwa9MIEIBFRj6U3jMdvJ+3V2YHaP7Oht/pNkZFMuU
         qNJL5rZbki2H1kyMufsCSzVwj14EXFA1Bh84S9io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/86] 5.15.89-rc1 review
Date:   Mon, 16 Jan 2023 16:50:34 +0100
Message-Id: <20230116154747.036911298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.89-rc1
X-KernelTest-Deadline: 2023-01-18T15:47+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.89 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.89-rc1

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl: amd: Add dynamic debugging for active GPIOs

Ferry Toth <ftoth@exalondelft.nl>
    Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Jens Axboe <axboe@kernel.dk>
    block: handle bio_split_to_limits() NULL return

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: only free worker if it was allocated for creation

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: free worker if task_work creation is canceled

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Remove scsi_dma_map() error messages

Johan Hovold <johan+linaro@kernel.org>
    efi: fix NULL-deref in init error path

Mark Rutland <mark.rutland@arm.com>
    arm64: cmpxchg_double*: hazard against entire exchange variable

Mark Rutland <mark.rutland@arm.com>
    arm64: atomics: remove LL/SC trampolines

Mark Rutland <mark.rutland@arm.com>
    arm64: atomics: format whitespace consistently

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: lock overflowing for IOPOLL

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID

Paolo Bonzini <pbonzini@redhat.com>
    Documentation: KVM: add API issues section

Aaron Thompson <dev@aaront.org>
    mm: Always release pages to the buddy allocator in memblock_free_late().

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Add missing call to ssam_request_sync_free()

Christopher S Hall <christopher.s.hall@intel.com>
    igc: Fix PPS delta between two synchronized end-points

Ian Rogers <irogers@google.com>
    perf build: Properly guard libbpf includes

Gavin Li <gavinl@nvidia.com>
    net/mlx5e: Don't support encap rules with gbp option

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5: Fix ptp max frequency adjustment range

Ido Schimmel <idosch@nvidia.com>
    net/sched: act_mpls: Fix warning during failed attribute validation

Willy Tarreau <w@1wt.eu>
    tools/nolibc: fix the O_* fcntl/open macro definitions for riscv

Willy Tarreau <w@1wt.eu>
    tools/nolibc: restore mips branch ordering in the _start block

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    tools/nolibc: Remove .global _start from the entry point code

Willy Tarreau <w@1wt.eu>
    tools/nolibc/arch: mark the _start symbol as weak

Willy Tarreau <w@1wt.eu>
    tools/nolibc/arch: split arch-specific code into individual files

Willy Tarreau <w@1wt.eu>
    tools/nolibc/types: split syscall-specific definitions into their own files

Willy Tarreau <w@1wt.eu>
    tools/nolibc/std: move the standard type definitions to std.h

Willy Tarreau <w@1wt.eu>
    tools/nolibc: use pselect6 on RISCV

Ammar Faizi <ammar.faizi@students.amikom.ac.id>
    tools/nolibc: x86-64: Use `mov $60,%eax` instead of `mov $60,%rax`

Ammar Faizi <ammar.faizi@students.amikom.ac.id>
    tools/nolibc: x86: Remove `r8`, `r9` and `r10` from the clobber list

Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
    af_unix: selftest: Fix the size of the parameter to connect()

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: lock console list traversal

Angela Czubak <aczubak@marvell.com>
    octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix unexpected link reset due to discovery messages

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Relax hw constraints for implicit fb sync

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Make sure to stop endpoints before closing EPs

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    ASoC: wm8904: fix wrong outputs volume after power reactivation

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: WLUN suspend SSU/enter hibern8 fail recovery

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Stop using the clock scaling lock in the error handler

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile

Ricardo Ribalda <ribalda@chromium.org>
    regulator: da9211: Use irq handler when ready

Peter Newman <peternewman@google.com>
    x86/resctrl: Fix task CLOSID/RMID update race

Eliav Farber <farbere@amazon.com>
    EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Peter Zijlstra <peterz@infradead.org>
    x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Kajol Jain <kjain@linux.ibm.com>
    powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Waiman Long <longman@redhat.com>
    sched/core: Fix use-after-free bug in dup_user_cpus_ptr()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Yunfei Wang <yf.wang@mediatek.com>
    iommu/iova: Fix alloc iova overflows issue

Ferry Toth <ftoth@exalondelft.nl>
    usb: ulpi: defer ulpi_register on ulpi_read_id timeout

Qiang Yu <quic_qianyu@quicinc.com>
    bus: mhi: host: Fix race between channel preparation and M0 event

Herbert Xu <herbert@gondor.apana.org.au>
    ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Yang Yingliang <yangyingliang@huawei.com>
    ixgbe: fix pci device refcount leak

Hans de Goede <hdegoede@redhat.com>
    platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Konrad Dybcio <konrad.dybcio@linaro.org>
    dt-bindings: msm/dsi: Don't require vcca-supply on 14nm PHY

Konrad Dybcio <konrad.dybcio@linaro.org>
    dt-bindings: msm/dsi: Don't require vdds-supply on 10nm PHY

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: do not complete dp_aux_cmd_fifo_tx() if irq is not for aux transfer

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Add Legion 5 15ARH05 DMI id to set_fn_lock_led_list[]

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-phy-28nm: Add missing qcom, dsi-phy-regulator-ldo-mode

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-controller-main: Fix description of core clock

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-controller-main: Fix power-domain constraint

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: Make adreno quirks not overwrite each other

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    dt-bindings: msm: dsi-controller-main: Fix operating-points-v2 constraint

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-privacy: Fix SW_CAMERA_LENS_COVER reporting

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Ignore command messages not intended for us

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-privacy: Only register SW_CAMERA_LENS_COVER if present

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read for smb311 posix symlink create

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Set action fwd flag when parsing tc action goto

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Reset twice

Rob Clark <robdclark@chromium.org>
    drm/virtio: Fix GEM handle creation UAF

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Heiko Carstens <hca@linux.ibm.com>
    s390/cpum_sf: add READ_ONCE() semantics to compare and swap loops

Brian Norris <computersforpeace@gmail.com>
    ASoC: qcom: lpass-cpu: Fix fallback SD line index handling

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/kexec: fix ipl report address for kdump

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter duplicate symbol selection

Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
    net: stmmac: add aux timestamps fifo clearance wait

Jonathan Corbet <corbet@lwn.net>
    docs: Fix the docs build with Sphinx 6.0

Ard Biesheuvel <ardb@kernel.org>
    efi: tpm: Avoid READ_ONCE() for accessing the event log

Jinrong Liang <cloudliang@tencent.com>
    selftests: kvm: Fix a compile error in selftests/kvm/rseq_test.c

Denis Nikitin <denik@chromium.org>
    KVM: arm64: nvhe: Fix build with profile optimization

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix S1PTW handling on RO memslots

Luka Guzenko <l.guzenko@web.de>
    ALSA: hda/realtek: Enable mute/micmute LEDs on HP Spectre x360 13-aw0xxx

Yuchi Yang <yangyuchi66@gmail.com>
    ALSA: hda/realtek - Turn on power early

Jaroslav Kysela <perex@perex.cz>
    ALSA: control-led: use strscpy in set_led_id()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits


-------------

Diffstat:

 .../bindings/display/msm/dsi-controller-main.yaml  |    4 +-
 .../bindings/display/msm/dsi-phy-10nm.yaml         |    1 -
 .../bindings/display/msm/dsi-phy-14nm.yaml         |    1 -
 .../bindings/display/msm/dsi-phy-28nm.yaml         |    4 +
 Documentation/sphinx/load_config.py                |    6 +-
 Documentation/virt/kvm/api.rst                     |   60 +
 Makefile                                           |    4 +-
 arch/arm64/include/asm/atomic_ll_sc.h              |  114 +-
 arch/arm64/include/asm/atomic_lse.h                |   16 +-
 arch/arm64/include/asm/kvm_emulate.h               |   22 +-
 arch/arm64/kvm/hyp/nvhe/Makefile                   |    4 +
 arch/powerpc/include/asm/imc-pmu.h                 |    2 +-
 arch/powerpc/perf/imc-pmu.c                        |  136 +-
 arch/s390/include/asm/cpu_mf.h                     |   31 +-
 arch/s390/include/asm/percpu.h                     |    2 +-
 arch/s390/kernel/machine_kexec_file.c              |    5 +-
 arch/s390/kernel/perf_cpum_sf.c                    |  101 +-
 arch/x86/boot/bioscall.S                           |    4 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   12 +-
 arch/x86/kvm/cpuid.c                               |   32 +-
 block/blk-merge.c                                  |    4 +-
 block/blk-mq.c                                     |    2 +
 drivers/block/drbd/drbd_req.c                      |    2 +
 drivers/block/pktcdvd.c                            |    2 +
 drivers/block/ps3vram.c                            |    2 +
 drivers/block/rsxx/dev.c                           |    2 +
 drivers/bus/mhi/core/pm.c                          |    3 +-
 drivers/edac/edac_device.c                         |   17 +-
 drivers/edac/edac_module.h                         |    2 +-
 drivers/firmware/efi/efi.c                         |    9 +-
 drivers/gpu/drm/i915/gt/intel_reset.c              |   34 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |   10 +-
 drivers/gpu/drm/msm/dp/dp_aux.c                    |    4 +
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   19 +-
 drivers/iommu/iova.c                               |    4 +-
 drivers/iommu/mtk_iommu_v1.c                       |    4 +-
 drivers/md/md.c                                    |    2 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |    2 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |   14 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |    4 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    1 -
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   43 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |    5 +-
 drivers/nfc/pn533/usb.c                            |   44 +-
 drivers/nvme/host/multipath.c                      |    2 +
 drivers/pinctrl/pinctrl-amd.c                      |   10 +-
 drivers/platform/surface/aggregator/controller.c   |    4 +-
 .../surface/aggregator/ssh_request_layer.c         |   14 +
 drivers/platform/x86/dell/dell-wmi-privacy.c       |   41 +-
 drivers/platform/x86/ideapad-laptop.c              |    6 +
 drivers/platform/x86/sony-laptop.c                 |   21 +-
 drivers/regulator/da9211-regulator.c               |   11 +-
 drivers/s390/block/dcssblk.c                       |    2 +
 drivers/scsi/mpi3mr/Makefile                       |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   18 +-
 drivers/scsi/ufs/ufshcd.c                          |   38 +-
 drivers/tty/hvc/hvc_xen.c                          |   46 +-
 fs/cifs/link.c                                     |    1 +
 include/linux/tpm_eventlog.h                       |    4 +-
 io_uring/io-wq.c                                   |    6 +
 io_uring/io_uring.c                                |   18 +-
 kernel/sched/core.c                                |   37 +-
 mm/memblock.c                                      |    8 +-
 net/ipv6/raw.c                                     |    4 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |    4 +-
 net/netfilter/nft_payload.c                        |    2 +-
 net/sched/act_mpls.c                               |    8 +-
 net/tipc/node.c                                    |   12 +-
 sound/core/control_led.c                           |    5 +-
 sound/pci/hda/patch_realtek.c                      |   53 +-
 sound/soc/codecs/wm8904.c                          |    7 +
 sound/soc/qcom/lpass-cpu.c                         |    5 +-
 sound/usb/pcm.c                                    |   11 +-
 tools/include/nolibc/arch-aarch64.h                |  199 +++
 tools/include/nolibc/arch-arm.h                    |  204 +++
 tools/include/nolibc/arch-i386.h                   |  196 +++
 tools/include/nolibc/arch-mips.h                   |  217 ++++
 tools/include/nolibc/arch-riscv.h                  |  204 +++
 tools/include/nolibc/arch-x86_64.h                 |  215 ++++
 tools/include/nolibc/arch.h                        |   32 +
 tools/include/nolibc/nolibc.h                      | 1331 +-------------------
 tools/include/nolibc/std.h                         |   49 +
 tools/include/nolibc/types.h                       |  133 ++
 tools/perf/builtin-trace.c                         |    2 +
 tools/perf/util/auxtrace.c                         |    2 +-
 tools/perf/util/bpf_counter.h                      |    6 +
 tools/testing/selftests/kvm/rseq_test.c            |    2 +-
 .../testing/selftests/net/af_unix/test_unix_oob.c  |    2 +-
 91 files changed, 2269 insertions(+), 1735 deletions(-)


