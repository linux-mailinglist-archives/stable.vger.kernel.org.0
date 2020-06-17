Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AEA1FD1B6
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgFQQNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 12:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgFQQNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 12:13:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EDB421556;
        Wed, 17 Jun 2020 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592410421;
        bh=E5okVa08drUGoFNJb+FgCpXYjun4FSDQ2F5370yRJ9o=;
        h=From:To:Cc:Subject:Date:From;
        b=X7PUg8CU7WbP7Ap0/eIK0etIDYNaa1F6KnS9Giu3SdWrgsVXxN4gfuJKEV8GhWqyZ
         fq4S9XqqH6qRNkMAhCw9UV9osV1/UDpSzNE9gFEXYP5uSvCQynAwEtB1Mbat7gdnBT
         z6g907AJYpgLerVuirVLzkIF6L731jwEOPnz9clw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.6.19
Date:   Wed, 17 Jun 2020 18:13:32 +0200
Message-Id: <1592410412126243@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Note, this is the LAST 5.6.y release to be made, please move to the
5.7.y tree at this time.  It is now end-of-life.
---------

I'm announcing the release of the 5.6.19 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/lzo.txt                                             |    8 
 Makefile                                                          |    2 
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts                         |    2 
 arch/arm/include/asm/kvm_emulate.h                                |    3 
 arch/arm/include/asm/kvm_host.h                                   |    2 
 arch/arm/kernel/ptrace.c                                          |    4 
 arch/arm64/include/asm/acpi.h                                     |    5 
 arch/arm64/include/asm/kvm_emulate.h                              |    6 
 arch/arm64/include/asm/kvm_host.h                                 |    8 
 arch/arm64/kvm/handle_exit.c                                      |   19 --
 arch/arm64/kvm/sys_regs.c                                         |   10 -
 arch/csky/abiv2/inc/abi/entry.h                                   |    2 
 arch/csky/kernel/entry.S                                          |    6 
 arch/mips/include/asm/kvm_host.h                                  |    6 
 arch/powerpc/kernel/vmlinux.lds.S                                 |    6 
 arch/powerpc/mm/ptdump/ptdump.c                                   |   21 +-
 arch/powerpc/sysdev/xive/common.c                                 |    5 
 arch/s390/pci/pci_clp.c                                           |    3 
 arch/x86/events/intel/core.c                                      |    4 
 arch/x86/include/asm/set_memory.h                                 |   19 +-
 arch/x86/kernel/cpu/amd.c                                         |    3 
 arch/x86/kernel/cpu/bugs.c                                        |   92 +++++----
 arch/x86/kernel/cpu/mce/core.c                                    |   11 -
 arch/x86/kernel/process.c                                         |   28 +-
 arch/x86/kernel/reboot.c                                          |    8 
 arch/x86/kernel/time.c                                            |    4 
 arch/x86/kernel/vmlinux.lds.S                                     |    4 
 arch/x86/kvm/mmu/mmu.c                                            |   46 ++--
 arch/x86/kvm/svm.c                                                |    6 
 arch/x86/kvm/vmx/nested.c                                         |    4 
 arch/x86/kvm/vmx/vmx.c                                            |   18 +
 arch/x86/kvm/vmx/vmx.h                                            |    3 
 arch/x86/kvm/x86.c                                                |   11 -
 arch/x86/mm/dump_pagetables.c                                     |   33 ++-
 arch/x86/pci/fixup.c                                              |    4 
 crypto/algapi.c                                                   |    2 
 crypto/drbg.c                                                     |    4 
 drivers/acpi/cppc_acpi.c                                          |    1 
 drivers/acpi/device_pm.c                                          |    2 
 drivers/acpi/evged.c                                              |   22 ++
 drivers/acpi/scan.c                                               |   28 ++
 drivers/acpi/sysfs.c                                              |    4 
 drivers/base/core.c                                               |   34 ++-
 drivers/block/floppy.c                                            |   10 -
 drivers/char/agp/intel-gtt.c                                      |    4 
 drivers/clk/clk.c                                                 |    6 
 drivers/cpufreq/cpufreq.c                                         |   11 -
 drivers/crypto/cavium/nitrox/nitrox_main.c                        |    4 
 drivers/crypto/virtio/virtio_crypto_algs.c                        |   21 +-
 drivers/edac/i10nm_base.c                                         |    2 
 drivers/edac/skx_base.c                                           |   20 --
 drivers/edac/skx_common.c                                         |    6 
 drivers/edac/skx_common.h                                         |    2 
 drivers/firmware/efi/efivars.c                                    |    4 
 drivers/firmware/imx/imx-scu.c                                    |   62 +++++-
 drivers/gpu/drm/amd/display/dc/core/dc.c                          |   23 ++
 drivers/gpu/drm/amd/display/dc/dc.h                               |    1 
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c                       |    8 
 drivers/gpu/drm/vkms/vkms_drv.h                                   |    5 
 drivers/gpu/drm/vkms/vkms_gem.c                                   |   11 -
 drivers/infiniband/core/uverbs_main.c                             |    2 
 drivers/input/misc/axp20x-pek.c                                   |   72 +++----
 drivers/input/mouse/synaptics.c                                   |    1 
 drivers/input/touchscreen/mms114.c                                |   12 -
 drivers/media/common/videobuf2/videobuf2-dma-contig.c             |   20 --
 drivers/mmc/core/sdio.c                                           |   61 ++----
 drivers/mmc/host/mmci_stm32_sdmmc.c                               |    3 
 drivers/mmc/host/sdhci-msm.c                                      |    6 
 drivers/mmc/host/sdhci-of-at91.c                                  |    7 
 drivers/mmc/host/tmio_mmc_core.c                                  |    6 
 drivers/mmc/host/uniphier-sd.c                                    |   12 -
 drivers/net/dsa/qca8k.c                                           |    3 
 drivers/net/ethernet/amazon/ena/ena_netdev.c                      |   10 -
 drivers/net/ethernet/cadence/macb_main.c                          |   14 -
 drivers/net/ethernet/ibm/ibmvnic.c                                |    8 
 drivers/net/ethernet/marvell/mvneta.c                             |   13 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c            |    4 
 drivers/net/ethernet/mellanox/mlx5/core/health.c                  |   14 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c                    |    7 
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c                |   23 ++
 drivers/net/net_failover.c                                        |    3 
 drivers/net/tun.c                                                 |   14 +
 drivers/net/vxlan.c                                               |    4 
 drivers/net/wireless/ath/ath9k/hif_usb.c                          |   58 ++++--
 drivers/net/wireless/ath/ath9k/hif_usb.h                          |    6 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                     |   10 -
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                     |    6 
 drivers/net/wireless/ath/ath9k/htc_hst.c                          |    6 
 drivers/net/wireless/ath/ath9k/wmi.c                              |    6 
 drivers/net/wireless/ath/ath9k/wmi.h                              |    3 
 drivers/pci/pci.c                                                 |    4 
 drivers/platform/x86/sony-laptop.c                                |   60 +++---
 drivers/remoteproc/remoteproc_core.c                              |    2 
 drivers/remoteproc/remoteproc_virtio.c                            |   12 +
 drivers/scsi/lpfc/lpfc_ct.c                                       |    1 
 drivers/scsi/megaraid/megaraid_sas.h                              |    4 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                       |    7 
 drivers/scsi/megaraid/megaraid_sas_fusion.h                       |    6 
 drivers/spi/spi-bcm-qspi.c                                        |   20 --
 drivers/spi/spi-bcm2835.c                                         |    4 
 drivers/spi/spi-bcm2835aux.c                                      |    4 
 drivers/spi/spi-dw.c                                              |   14 +
 drivers/spi/spi-pxa2xx.c                                          |    5 
 drivers/spi/spi.c                                                 |    3 
 drivers/staging/mt7621-pci/pci-mt7621.c                           |   12 +
 drivers/staging/wfx/main.c                                        |    1 
 drivers/target/iscsi/iscsi_target.c                               |   79 ++------
 drivers/target/iscsi/iscsi_target.h                               |    1 
 drivers/target/iscsi/iscsi_target_configfs.c                      |    5 
 drivers/target/iscsi/iscsi_target_login.c                         |    5 
 drivers/video/fbdev/vt8500lcdfb.c                                 |    1 
 drivers/video/fbdev/w100fb.c                                      |    2 
 drivers/watchdog/imx_sc_wdt.c                                     |    5 
 drivers/xen/pvcalls-back.c                                        |    3 
 fs/aio.c                                                          |    8 
 fs/cifs/cifsfs.c                                                  |    2 
 fs/cifs/smb2pdu.c                                                 |    4 
 fs/fat/inode.c                                                    |    6 
 fs/gfs2/lops.c                                                    |   15 -
 fs/io_uring.c                                                     |   15 -
 fs/nilfs2/segment.c                                               |    2 
 fs/notify/fanotify/fanotify.c                                     |    5 
 fs/overlayfs/copy_up.c                                            |    2 
 fs/overlayfs/overlayfs.h                                          |    3 
 fs/proc/inode.c                                                   |    2 
 fs/proc/self.c                                                    |    2 
 fs/proc/thread_self.c                                             |    2 
 include/asm-generic/vmlinux.lds.h                                 |   15 +
 include/linux/elfnote.h                                           |    2 
 include/linux/kvm_host.h                                          |    4 
 include/linux/mm.h                                                |    1 
 include/linux/padata.h                                            |    6 
 include/linux/ptdump.h                                            |    1 
 include/linux/set_memory.h                                        |    2 
 include/media/videobuf2-dma-contig.h                              |    2 
 include/net/inet_hashtables.h                                     |    6 
 include/target/iscsi/iscsi_target_core.h                          |    2 
 kernel/bpf/btf.c                                                  |    9 
 kernel/bpf/sysfs_btf.c                                            |   11 -
 kernel/events/core.c                                              |   23 +-
 kernel/padata.c                                                   |   14 -
 kernel/sched/fair.c                                               |    2 
 lib/bitmap.c                                                      |    9 
 lib/lzo/lzo1x_compress.c                                          |   13 +
 mm/gup.c                                                          |   44 ++++
 mm/huge_memory.c                                                  |    7 
 mm/ptdump.c                                                       |   17 +
 mm/slab_common.c                                                  |    3 
 mm/slub.c                                                         |    4 
 mm/util.c                                                         |   18 +
 net/bridge/br_arp_nd_proxy.c                                      |    4 
 net/dccp/proto.c                                                  |    7 
 net/ipv6/ipv6_sockglue.c                                          |   13 -
 net/netlink/genetlink.c                                           |   94 ++++++----
 net/tipc/msg.c                                                    |    4 
 scripts/link-vmlinux.sh                                           |   24 +-
 security/keys/internal.h                                          |   11 -
 security/keys/keyctl.c                                            |   16 -
 security/smack/smack.h                                            |    6 
 security/smack/smack_lsm.c                                        |   25 --
 security/smack/smackfs.c                                          |   10 +
 sound/core/pcm_native.c                                           |   20 +-
 sound/firewire/fireface/ff-protocol-latter.c                      |   12 -
 sound/firewire/fireface/ff-stream.c                               |   10 -
 sound/isa/es1688/es1688.c                                         |    4 
 sound/pci/hda/hda_intel.c                                         |    3 
 sound/pci/hda/patch_realtek.c                                     |    6 
 sound/soc/codecs/max9867.c                                        |    4 
 sound/usb/card.c                                                  |   19 +-
 sound/usb/quirks-table.h                                          |   20 ++
 sound/usb/usbaudio.h                                              |    2 
 tools/perf/util/probe-event.c                                     |    3 
 tools/testing/selftests/ftrace/test.d/ftrace/tracing-error-log.tc |    2 
 tools/testing/selftests/networking/timestamping/rxtimestamp.c     |    1 
 tools/testing/selftests/tc-testing/tc-tests/filters/tests.json    |    6 
 tools/testing/selftests/tc-testing/tdc_batch.py                   |    6 
 virt/kvm/arm/aarch32.c                                            |   28 ++
 virt/kvm/arm/arm.c                                                |   22 ++
 virt/kvm/kvm_main.c                                               |   26 +-
 180 files changed, 1291 insertions(+), 789 deletions(-)

Alexander Gordeev (1):
      lib: fix bitmap_parse() on 64-bit big endian archs

Amir Goldstein (2):
      fanotify: fix ignore mask logic for events on child and on dir
      ovl: fix out of bounds access warning in ovl_check_fb_len()

Andreas Gruenbacher (1):
      gfs2: Even more gfs2_find_jhead fixes

Anthony Steinhauser (3):
      x86/speculation: Prevent rogue cross-process SSBD shutdown
      x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.
      x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Ard Biesheuvel (2):
      efi/efivars: Add missing kobject_put() in sysfs entry creation error path
      ACPI: GED: add support for _Exx / _Lxx handler methods

Arnd Bergmann (1):
      smack: avoid unused 'sip' variable warning

Barret Rhoden (1):
      perf: Add cond_resched() to task_function_call()

Bjorn Helgaas (1):
      PCI/PM: Adjust pcie_wait_for_link_delay() for caller delay

Bob Haarman (1):
      x86_64: Fix jiffies ODR violation

Casey Schaufler (1):
      Smack: slab-out-of-bounds in vsscanf

Charles Keepax (1):
      net: macb: Only disable NAPI on the actual error path

Chris Wilson (1):
      agp/intel: Reinforce the barrier after GTT updates

Christophe JAILLET (2):
      crypto: cavium/nitrox - Fix 'nitrox_get_first_device()' when ndevlist is fully iterated
      video: fbdev: w100fb: Fix a potential double free.

Christophe Leroy (1):
      powerpc/ptdump: Properly handle non standard page size

Chuhong Yuan (1):
      ALSA: es1688: Add the missed snd_card_free()

Cong Wang (1):
      genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()

Corentin Labbe (1):
      net: cadence: macb: disable NAPI on error

Cédric Le Goater (1):
      powerpc/xive: Clear the page tables for the ESB IO mapping

Daniel Jordan (1):
      padata: add separate cpuhp node for CPUHP_PADATA_DEAD

Dave Rodgman (1):
      lib/lzo: fix ambiguous encoding bug in lzo-rle

Denis Efremov (1):
      io_uring: use kvfree() in io_sqe_buffer_register()

Dennis Kadioglu (1):
      Input: synaptics - add a second working PNP_ID for Lenovo T470s

Dick Kennedy (1):
      scsi: lpfc: Fix negation of else clause in lpfc_prep_node_fc4type

Eiichi Tsukata (1):
      KVM: x86: Fix APIC page invalidation race

Eric Biggers (1):
      crypto: algapi - Avoid spurious modprobe on LOADED

Eric W. Biederman (1):
      proc: Use new_inode not new_inode_pseudo

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix CALCR register being rewritten

Ezequiel Garcia (1):
      drm/vkms: Hold gem object while still in-use

Fabio Estevam (1):
      watchdog: imx_sc_wdt: Fix reboot on crash

Fangrui Song (1):
      bpf: Support llvm-objcopy for vmlinux BTF

Felipe Franciosi (1):
      KVM: x86: respect singlestep when emulating instruction

Florian Fainelli (1):
      spi: bcm-qspi: Handle clock probe deferral

Franck LENORMAND (1):
      firmware: imx: scu: Fix corruption of header

Fredrik Strupe (1):
      ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook

Greg Kroah-Hartman (1):
      Linux 5.6.19

Guo Ren (1):
      csky: Fixup abiv2 syscall_trace break a4 & a5

Hangbin Liu (1):
      ipv6: fix IPV6_ADDRFORM operation logic

Hans de Goede (1):
      Input: axp20x-pek - always register interrupt handlers

Hersen Wu (1):
      ALSA: hda: add sienna_cichlid audio asic id for sienna_cichlid up

Hill Ma (1):
      x86/reboot/quirks: Add MacBook6,1 reboot quirk

Hui Wang (1):
      ALSA: hda/realtek - add a pintbl quirk for several Lenovo machines

Ido Schimmel (2):
      bridge: Avoid infinite loop when suppressing NS messages with invalid options
      vxlan: Avoid infinite loop when suppressing NS messages with invalid options

James Morse (1):
      KVM: arm64: Stop writing aarch32's CSSELR into ACTLR

Jason Gunthorpe (1):
      RDMA/uverbs: Make the event_queue fds return POLLERR when disassociated

Jens Axboe (1):
      sched/fair: Don't NUMA balance for kthreads

Jiri Kosina (1):
      block/floppy: fix contended case in floppy_queue_rq()

Joseph Gravenor (1):
      drm/amd/display: remove invalid dc_is_hw_initialized function

Juergen Gross (1):
      xen/pvcalls-back: test for errors when calling backend_connect()

Justin Chen (1):
      spi: bcm-qspi: when tx/rx buffer is NULL set to 0

Jérôme Pouiller (1):
      staging: wfx: fix double free

Kai-Heng Feng (1):
      ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock

Kan Liang (1):
      perf/x86/intel: Add more available bits for OFFCORE_RESPONSE of Intel Tremont

Kim Phillips (1):
      x86/cpu/amd: Make erratum #1054 a legacy erratum

Linus Torvalds (1):
      gup: document and work around "COW can break either way" issue

Longpeng(Mike) (3):
      crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()
      crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()
      crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()

Lorenzo Bianconi (1):
      net: mvneta: do not redirect frames during reconfiguration

Ludovic Barre (1):
      mmc: mmci_sdmmc: fix DMA API warning overlapping mappings

Ludovic Desroches (1):
      ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node description

Lukas Wunner (6):
      spi: dw: Fix controller unregister order
      spi: Fix controller unregister order
      spi: pxa2xx: Fix controller unregister order
      spi: pxa2xx: Fix runtime PM ref imbalance on probe error
      spi: bcm2835: Fix controller unregister order
      spi: bcm2835aux: Fix controller unregister order

Marc Zyngier (3):
      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
      KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
      KVM: arm64: Save the host's PtrAuth keys in non-preemptible context

Masahiro Yamada (1):
      mmc: uniphier-sd: call devm_request_irq() after tmio_mmc_host_probe()

Masami Hiramatsu (2):
      perf probe: Accept the instance number of kretprobe event
      selftests/ftrace: Return unsupported if no error_log file

Masashi Honma (1):
      ath9k_htc: Silence undersized packet warnings

Mattia Dongili (2):
      platform/x86: sony-laptop: SNC calls should handle BUFFER types
      platform/x86: sony-laptop: Make resuming thermal profile safer

Maurizio Lombardi (2):
      scsi: target: remove boilerplate code
      scsi: target: fix hang when multiple threads try to destroy the same iscsi session

Maxim Mikityanskiy (1):
      net/mlx5e: Fix repeated XSK usage on one channel

Michal Vokáč (1):
      net: dsa: qca8k: Fix "Unexpected gfp" kernel exception

Michał Mirosław (2):
      ALSA: pcm: disallow linking stream to itself
      ALSA: pcm: fix snd_pcm_link() lockdep splat

Miklos Szeredi (1):
      aio: fix async fsync creds

Namjae Jeon (1):
      smb3: add indatalen that can be a non-zero value to calculation of credit charge in smb2 ioctl

Nick Desaulniers (2):
      elfnote: mark all .note sections SHF_ALLOC
      arm64: acpi: fix UBSAN warning

OGAWA Hirofumi (1):
      fat: don't allow to mount if the FAT length == 0

Paolo Bonzini (4):
      KVM: x86: only do L1TF workaround on affected processors
      KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags
      KVM: nSVM: fix condition for filtering async PF
      KVM: nSVM: leave ASID aside in copy_vmcb_control_area

Parav Pandit (1):
      net/mlx5: Disable reload while removing the device

Pavel Begunkov (1):
      io_uring: fix flush req->refs underflow

Pavel Dobias (1):
      ASoC: max9867: fix volume controls

Peng Fan (1):
      firmware: imx-scu: Support one TX and one RX

Petr Tesarik (1):
      s390/pci: Log new handle in clp_disable_fh()

Qiujun Huang (5):
      ath9k: Fix use-after-free Read in htc_connect_service
      ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
      ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
      ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Qiushi Wu (2):
      ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()
      ACPI: CPPC: Fix reference count leak in acpi_cppc_processor_probe()

Qiuxu Zhuo (1):
      EDAC/skx: Use the mcmtr register to retrieve close_pg/bank_xor_enable

Rafael J. Wysocki (3):
      ACPI: PM: Avoid using power resources if there are none for D0
      PM: runtime: clk: Fix clk_pm_runtime_get() error path
      cpufreq: Fix up cpufreq_boost_set_sw()

Ryusuke Konishi (1):
      nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Sam Ravnborg (1):
      video: vt8500lcdfb: fix fallthrough warning

Sameeh Jubran (2):
      net: ena: xdp: XDP_TX: fix memory leak
      net: ena: xdp: update napi budget for DROP and ABORTED

Saravana Kannan (1):
      driver core: Update device link status correctly for SYNC_STATE_ONLY links

Sasha Levin (1):
      spi: dw: Fix native CS being unset

Sean Christopherson (3):
      KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated
      KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02
      KVM: nVMX: Consult only the "basic" exit reason when routing nested exit

Sergio Paracuellos (1):
      staging: mt7621-pci: properly power off dual-ported pcie phy

Shay Drory (2):
      net/mlx5: drain health workqueue in case of driver load error
      net/mlx5: Fix fatal error handling during device load

Shivasharan S (1):
      scsi: megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with __BIG_ENDIAN_BITFIELD macro

Stephan Gerhold (1):
      Input: mms114 - fix handling of mms345l

Steve French (2):
      smb3: fix incorrect number of credits when ioctl MaxOutputResponse > 64K
      smb3: fix typo in mount options displayed in /proc/mounts

Steven Price (1):
      x86: mm: ptdump: calculate effective permissions correctly

Suman Anna (1):
      remoteproc: Fix and restore the parenting hierarchy for vdev

Sumit Saxena (1):
      scsi: megaraid_sas: TM command refire leads to controller firmware crash

Takashi Iwai (1):
      ALSA: usb-audio: Fix inconsistent card PM state after resume

Takashi Sakamoto (2):
      ALSA: fireface: fix configuration error for nominal sampling transfer frequency
      ALSA: fireface: start IR context immediately

Tero Kristo (1):
      remoteproc: Fall back to using parent memory pool if no dedicated available

Thomas Falcon (1):
      drivers/net/ibmvnic: Update VNIC protocol version reporting

Tomi Valkeinen (1):
      media: videobuf2-dma-contig: fix bad kfree in vb2_dma_contig_clear_max_seg_size

Tony Luck (1):
      x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned

Tuong Lien (1):
      tipc: fix NULL pointer dereference in streaming

Ulf Hansson (3):
      mmc: tmio: Further fixup runtime PM management at remove
      mmc: sdio: Fix potential NULL pointer error in mmc_sdio_init_card()
      mmc: sdio: Fix several potential memory leaks in mmc_sdio_init_card()

Vadim Pasternak (1):
      mlxsw: core: Use different get_trend() callbacks for different thermal zones

Vasily Averin (1):
      net_failover: fixed rollback in net_failover_open()

Veerabhadrarao Badiganti (1):
      mmc: sdhci-msm: Clear tuning done flag while hs400 tuning

Vlad Buslov (1):
      selftests: fix flower parent qdisc

Vlastimil Babka (1):
      usercopy: mark dma-kmalloc caches as usercopy caches

Waiman Long (1):
      mm: add kvfree_sensitive() for freeing sensitive data objects

Wang Hai (2):
      dccp: Fix possible memleak in dccp_init and dccp_fini
      mm/slub: fix a memory leak in sysfs_slab_add()

Wei Yongjun (1):
      crypto: drbg - fix error return code in drbg_alloc_state()

Willem de Bruijn (1):
      tun: correct header offsets in napi frags mode

Xiaochun Lee (1):
      x86/PCI: Mark Intel C620 MROMs as having non-compliant BARs

Xiaoguang Wang (1):
      io_uring: fix mismatched finish_wait() calls in io_uring_cancel_files()

Xing Li (2):
      KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
      KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits

Yongqiang Sun (1):
      drm/amd/display: Not doing optimize bandwidth if flip pending.

Yuxuan Shui (1):
      ovl: initialize error in ovl_copy_xattr

tannerlove (1):
      selftests/net: in rxtimestamp getopt_long needs terminating null entry

