Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7351E671B19
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 12:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjARLqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 06:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjARLoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 06:44:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA33569B06;
        Wed, 18 Jan 2023 03:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 489CA6176C;
        Wed, 18 Jan 2023 11:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0A1C433EF;
        Wed, 18 Jan 2023 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674039926;
        bh=bVxQoWWShGVBh9ZOyv0sixy/OKVsNDuk2AX+UtKn6IE=;
        h=From:To:Cc:Subject:Date:From;
        b=KEO+elpbx+CYxExcPLLMErNLoWArWyeeNsJ0J+pOqqV5YMzT6zj/1Qxz4GHcriBY2
         6U4RCZXguUH2LdRw7AHHEC1e1P7OncKM6kI0FmwXndRoD6MRF46Bx2sKKFQkW7Noac
         9rQjtABmUiY3XrpGYt1YKxKyNCSkXkQNy3tblBhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.89
Date:   Wed, 18 Jan 2023 12:05:13 +0100
Message-Id: <167403991380253@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.89 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml |    4 
 Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml        |    1 
 Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml        |    1 
 Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml        |    4 
 Documentation/sphinx/load_config.py                                    |    6 
 Documentation/virt/kvm/api.rst                                         |   60 
 Makefile                                                               |    2 
 arch/arm64/include/asm/atomic_ll_sc.h                                  |  114 
 arch/arm64/include/asm/atomic_lse.h                                    |   16 
 arch/arm64/include/asm/kvm_emulate.h                                   |   22 
 arch/arm64/kvm/hyp/nvhe/Makefile                                       |    4 
 arch/powerpc/include/asm/imc-pmu.h                                     |    2 
 arch/powerpc/perf/imc-pmu.c                                            |  136 -
 arch/s390/include/asm/cpu_mf.h                                         |   31 
 arch/s390/include/asm/percpu.h                                         |    2 
 arch/s390/kernel/machine_kexec_file.c                                  |    5 
 arch/s390/kernel/perf_cpum_sf.c                                        |  101 
 arch/x86/boot/bioscall.S                                               |    4 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                                 |   12 
 arch/x86/kvm/cpuid.c                                                   |   32 
 block/blk-merge.c                                                      |    4 
 block/blk-mq.c                                                         |    2 
 drivers/block/drbd/drbd_req.c                                          |    2 
 drivers/block/pktcdvd.c                                                |    2 
 drivers/block/ps3vram.c                                                |    2 
 drivers/block/rsxx/dev.c                                               |    2 
 drivers/bus/mhi/core/pm.c                                              |    3 
 drivers/edac/edac_device.c                                             |   17 
 drivers/edac/edac_module.h                                             |    2 
 drivers/firmware/efi/efi.c                                             |    9 
 drivers/gpu/drm/i915/gt/intel_reset.c                                  |   34 
 drivers/gpu/drm/msm/adreno/adreno_gpu.h                                |   10 
 drivers/gpu/drm/msm/dp/dp_aux.c                                        |    4 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                                 |   19 
 drivers/iommu/iova.c                                                   |    4 
 drivers/iommu/mtk_iommu_v1.c                                           |    4 
 drivers/md/md.c                                                        |    2 
 drivers/net/ethernet/intel/igc/igc_defines.h                           |    2 
 drivers/net/ethernet/intel/igc/igc_ptp.c                               |   10 
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                           |   14 
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c                        |    4 
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h                        |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                        |   43 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c                    |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c                       |    5 
 drivers/nfc/pn533/usb.c                                                |   44 
 drivers/nvme/host/multipath.c                                          |    2 
 drivers/pinctrl/pinctrl-amd.c                                          |   10 
 drivers/platform/surface/aggregator/controller.c                       |    4 
 drivers/platform/surface/aggregator/ssh_request_layer.c                |   14 
 drivers/platform/x86/dell/dell-wmi-privacy.c                           |   41 
 drivers/platform/x86/ideapad-laptop.c                                  |    6 
 drivers/platform/x86/sony-laptop.c                                     |   21 
 drivers/regulator/da9211-regulator.c                                   |   11 
 drivers/s390/block/dcssblk.c                                           |    2 
 drivers/scsi/mpi3mr/Makefile                                           |    2 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                    |   18 
 drivers/scsi/ufs/ufshcd.c                                              |   38 
 drivers/tty/hvc/hvc_xen.c                                              |   46 
 fs/cifs/link.c                                                         |    1 
 include/linux/tpm_eventlog.h                                           |    4 
 io_uring/io-wq.c                                                       |    6 
 io_uring/io_uring.c                                                    |   18 
 kernel/sched/core.c                                                    |   37 
 mm/memblock.c                                                          |    8 
 net/ipv6/raw.c                                                         |    4 
 net/netfilter/ipset/ip_set_bitmap_ip.c                                 |    4 
 net/netfilter/nft_payload.c                                            |    2 
 net/sched/act_mpls.c                                                   |    8 
 net/tipc/node.c                                                        |   12 
 sound/core/control_led.c                                               |    5 
 sound/pci/hda/patch_realtek.c                                          |   53 
 sound/soc/codecs/wm8904.c                                              |    7 
 sound/soc/qcom/lpass-cpu.c                                             |    5 
 sound/usb/pcm.c                                                        |   11 
 tools/include/nolibc/arch-aarch64.h                                    |  199 +
 tools/include/nolibc/arch-arm.h                                        |  204 +
 tools/include/nolibc/arch-i386.h                                       |  196 +
 tools/include/nolibc/arch-mips.h                                       |  217 +
 tools/include/nolibc/arch-riscv.h                                      |  204 +
 tools/include/nolibc/arch-x86_64.h                                     |  215 +
 tools/include/nolibc/arch.h                                            |   32 
 tools/include/nolibc/nolibc.h                                          | 1331 ----------
 tools/include/nolibc/std.h                                             |   49 
 tools/include/nolibc/types.h                                           |  133 
 tools/perf/builtin-trace.c                                             |    2 
 tools/perf/util/auxtrace.c                                             |    2 
 tools/perf/util/bpf_counter.h                                          |    6 
 tools/testing/selftests/kvm/rseq_test.c                                |    2 
 tools/testing/selftests/net/af_unix/test_unix_oob.c                    |    2 
 91 files changed, 2268 insertions(+), 1734 deletions(-)

Aaron Thompson (1):
      mm: Always release pages to the buddy allocator in memblock_free_late().

Adrian Hunter (1):
      perf auxtrace: Fix address filter duplicate symbol selection

Alexander Egorenkov (1):
      s390/kexec: fix ipl report address for kdump

Ammar Faizi (3):
      tools/nolibc: x86: Remove `r8`, `r9` and `r10` from the clobber list
      tools/nolibc: x86-64: Use `mov $60,%eax` instead of `mov $60,%rax`
      tools/nolibc: Remove .global _start from the entry point code

Angela Czubak (1):
      octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable

Ard Biesheuvel (1):
      efi: tpm: Avoid READ_ONCE() for accessing the event log

Bart Van Assche (1):
      scsi: ufs: Stop using the clock scaling lock in the error handler

Brian Norris (1):
      ASoC: qcom: lpass-cpu: Fix fallback SD line index handling

Bryan O'Donoghue (4):
      dt-bindings: msm: dsi-controller-main: Fix operating-points-v2 constraint
      dt-bindings: msm: dsi-controller-main: Fix power-domain constraint
      dt-bindings: msm: dsi-controller-main: Fix description of core clock
      dt-bindings: msm: dsi-phy-28nm: Add missing qcom, dsi-phy-regulator-ldo-mode

Chris Wilson (1):
      drm/i915/gt: Reset twice

Christophe JAILLET (1):
      iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Christopher S Hall (1):
      igc: Fix PPS delta between two synchronized end-points

Denis Nikitin (1):
      KVM: arm64: nvhe: Fix build with profile optimization

Eliav Farber (1):
      EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Emanuele Ghidoli (1):
      ASoC: wm8904: fix wrong outputs volume after power reactivation

Ferry Toth (2):
      usb: ulpi: defer ulpi_register on ulpi_read_id timeout
      Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Gavin Li (1):
      net/mlx5e: Don't support encap rules with gbp option

Gavrilov Ilia (1):
      netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Greg Kroah-Hartman (1):
      Linux 5.15.89

Hans de Goede (4):
      platform/x86: dell-privacy: Only register SW_CAMERA_LENS_COVER if present
      platform/x86: dell-privacy: Fix SW_CAMERA_LENS_COVER reporting
      platform/x86: ideapad-laptop: Add Legion 5 15ARH05 DMI id to set_fn_lock_led_list[]
      platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Heiko Carstens (2):
      s390/cpum_sf: add READ_ONCE() semantics to compare and swap loops
      s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Herbert Xu (1):
      ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Ian Rogers (1):
      perf build: Properly guard libbpf includes

Ido Schimmel (1):
      net/sched: act_mpls: Fix warning during failed attribute validation

Jaroslav Kysela (1):
      ALSA: control-led: use strscpy in set_led_id()

Jens Axboe (3):
      io_uring/io-wq: free worker if task_work creation is canceled
      io_uring/io-wq: only free worker if it was allocated for creation
      block: handle bio_split_to_limits() NULL return

Jinrong Liang (1):
      selftests: kvm: Fix a compile error in selftests/kvm/rseq_test.c

Johan Hovold (1):
      efi: fix NULL-deref in init error path

Jonathan Corbet (1):
      docs: Fix the docs build with Sphinx 6.0

Kajol Jain (1):
      powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Konrad Dybcio (3):
      drm/msm/adreno: Make adreno quirks not overwrite each other
      dt-bindings: msm/dsi: Don't require vdds-supply on 10nm PHY
      dt-bindings: msm/dsi: Don't require vcca-supply on 14nm PHY

Kuogee Hsieh (1):
      drm/msm/dp: do not complete dp_aux_cmd_fifo_tx() if irq is not for aux transfer

Luka Guzenko (1):
      ALSA: hda/realtek: Enable mute/micmute LEDs on HP Spectre x360 13-aw0xxx

Marc Zyngier (1):
      KVM: arm64: Fix S1PTW handling on RO memslots

Mario Limonciello (1):
      pinctrl: amd: Add dynamic debugging for active GPIOs

Mark Rutland (3):
      arm64: atomics: format whitespace consistently
      arm64: atomics: remove LL/SC trampolines
      arm64: cmpxchg_double*: hazard against entire exchange variable

Maximilian Luz (2):
      platform/surface: aggregator: Ignore command messages not intended for us
      platform/surface: aggregator: Add missing call to ssam_request_sync_free()

Minsuk Kang (1):
      nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Mirsad Goran Todorovac (1):
      af_unix: selftest: Fix the size of the parameter to connect()

Noor Azura Ahmad Tarmizi (1):
      net: stmmac: add aux timestamps fifo clearance wait

Pablo Neira Ayuso (1):
      netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits

Paolo Bonzini (2):
      Documentation: KVM: add API issues section
      KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID

Pavel Begunkov (1):
      io_uring: lock overflowing for IOPOLL

Peter Newman (1):
      x86/resctrl: Fix task CLOSID/RMID update race

Peter Wang (1):
      scsi: ufs: core: WLUN suspend SSU/enter hibern8 fail recovery

Peter Zijlstra (1):
      x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Qiang Yu (1):
      bus: mhi: host: Fix race between channel preparation and M0 event

Rahul Rameshbabu (1):
      net/mlx5: Fix ptp max frequency adjustment range

Ricardo Ribalda (1):
      regulator: da9211: Use irq handler when ready

Rob Clark (1):
      drm/virtio: Fix GEM handle creation UAF

Roger Pau Monne (1):
      hvc/xen: lock console list traversal

Roi Dayan (1):
      net/mlx5e: Set action fwd flag when parsing tc action goto

Shin'ichiro Kawasaki (1):
      scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile

Sreekanth Reddy (1):
      scsi: mpt3sas: Remove scsi_dma_map() error messages

Takashi Iwai (2):
      ALSA: usb-audio: Make sure to stop endpoints before closing EPs
      ALSA: usb-audio: Relax hw constraints for implicit fb sync

Tung Nguyen (1):
      tipc: fix unexpected link reset due to discovery messages

Volker Lendecke (1):
      cifs: Fix uninitialized memory read for smb311 posix symlink create

Waiman Long (1):
      sched/core: Fix use-after-free bug in dup_user_cpus_ptr()

Willy Tarreau (7):
      tools/nolibc: use pselect6 on RISCV
      tools/nolibc/std: move the standard type definitions to std.h
      tools/nolibc/types: split syscall-specific definitions into their own files
      tools/nolibc/arch: split arch-specific code into individual files
      tools/nolibc/arch: mark the _start symbol as weak
      tools/nolibc: restore mips branch ordering in the _start block
      tools/nolibc: fix the O_* fcntl/open macro definitions for riscv

Yang Yingliang (1):
      ixgbe: fix pci device refcount leak

Yuchi Yang (1):
      ALSA: hda/realtek - Turn on power early

Yunfei Wang (1):
      iommu/iova: Fix alloc iova overflows issue

