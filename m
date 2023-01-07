Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8746D660E0A
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 11:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbjAGKpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 05:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjAGKpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 05:45:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22B6EBF;
        Sat,  7 Jan 2023 02:45:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F9AD60BAD;
        Sat,  7 Jan 2023 10:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ACBC433EF;
        Sat,  7 Jan 2023 10:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673088320;
        bh=2Cmew1gKLZxe4QbDqgRW1f7uULhFAXMf2YQkufByV6M=;
        h=From:To:Cc:Subject:Date:From;
        b=iYmXFakU3HZQ/XebzjLOmmz4ZekPGBhJ8DusnXl8oPiwUyyZx68c40XjDisvhVd5M
         Dfj9sQfxuj92Cx/Bn08B8ExF6EBNlUINWWXur/2tsPwu92aMDplHPdBS5eGezDu246
         i4Bqq6mRFN4ST+N0MpAWb3b+w/NSj1nYlxRoSIAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.4
Date:   Sat,  7 Jan 2023 11:45:12 +0100
Message-Id: <16730883124073@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.4 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt                    |   27 
 Documentation/filesystems/mount_api.rst                            |    1 
 Makefile                                                           |    2 
 arch/arm/nwfpe/Makefile                                            |    6 
 arch/arm64/boot/dts/mediatek/mt8195-demo.dts                       |    4 
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi                             |   10 
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                         |    5 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts               |    6 
 arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts                   |    6 
 arch/arm64/kernel/stacktrace.c                                     |   10 
 arch/parisc/include/asm/pgtable.h                                  |    4 
 arch/parisc/kernel/firmware.c                                      |   24 
 arch/parisc/kernel/kgdb.c                                          |   20 
 arch/parisc/kernel/pdc_cons.c                                      |   16 
 arch/parisc/kernel/vdso32/Makefile                                 |    4 
 arch/parisc/kernel/vdso64/Makefile                                 |    4 
 arch/powerpc/include/asm/ftrace.h                                  |   12 
 arch/riscv/Kconfig                                                 |    2 
 arch/riscv/include/asm/kexec.h                                     |    5 
 arch/riscv/include/asm/mmu.h                                       |    2 
 arch/riscv/include/asm/pgtable.h                                   |    2 
 arch/riscv/include/asm/tlbflush.h                                  |   18 
 arch/riscv/kernel/elf_kexec.c                                      |   14 
 arch/riscv/kernel/stacktrace.c                                     |    2 
 arch/riscv/mm/context.c                                            |   10 
 arch/riscv/mm/tlbflush.c                                           |   28 
 arch/um/drivers/virt-pci.c                                         |    9 
 arch/x86/events/intel/uncore.h                                     |    1 
 arch/x86/events/intel/uncore_snbep.c                               |   22 
 arch/x86/kernel/cpu/mce/amd.c                                      |   33 
 arch/x86/kernel/cpu/microcode/intel.c                              |    8 
 arch/x86/kernel/fpu/xstate.c                                       |   12 
 arch/x86/kernel/ftrace.c                                           |    2 
 arch/x86/kernel/kprobes/core.c                                     |   10 
 arch/x86/kernel/kprobes/opt.c                                      |   28 
 arch/x86/kvm/lapic.c                                               |    5 
 arch/x86/kvm/vmx/nested.c                                          |   47 -
 arch/x86/kvm/vmx/sgx.c                                             |    4 
 arch/xtensa/kernel/xtensa_ksyms.c                                  |    2 
 arch/xtensa/lib/Makefile                                           |    2 
 arch/xtensa/lib/umulsidi3.S                                        |  230 ++++++
 block/mq-deadline.c                                                |   83 ++
 drivers/acpi/video_detect.c                                        |   52 -
 drivers/ata/ahci.h                                                 |  245 +++---
 drivers/base/dd.c                                                  |    6 
 drivers/bus/mhi/host/pm.c                                          |    3 
 drivers/char/ipmi/ipmi_msghandler.c                                |    4 
 drivers/char/ipmi/ipmi_si_intf.c                                   |   27 
 drivers/char/random.c                                              |   38 +
 drivers/cpufreq/cpufreq.c                                          |    2 
 drivers/crypto/Kconfig                                             |    4 
 drivers/crypto/ccp/sp-pci.c                                        |   11 
 drivers/crypto/hisilicon/Kconfig                                   |    2 
 drivers/crypto/n2_core.c                                           |    6 
 drivers/cxl/core/region.c                                          |    5 
 drivers/devfreq/devfreq.c                                          |    6 
 drivers/devfreq/governor_userspace.c                               |   12 
 drivers/edac/edac_mc_sysfs.c                                       |   24 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                         |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                            |   13 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                         |    3 
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c                             |    3 
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c                          |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                  |    1 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h |    2 
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                     |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c               |  111 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c               |   19 
 drivers/gpu/drm/drm_connector.c                                    |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem.c                              |    7 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                              |   23 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h                              |    1 
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c                       |    4 
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c                     |   59 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                           |    2 
 drivers/gpu/drm/i915/gem/i915_gem_object.c                         |    3 
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h                   |   10 
 drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c                         |   18 
 drivers/gpu/drm/i915/gt/intel_migrate.c                            |   16 
 drivers/gpu/drm/i915/i915_gem_evict.c                              |   37 
 drivers/gpu/drm/i915/i915_gem_evict.h                              |    4 
 drivers/gpu/drm/i915/i915_vma.c                                    |    2 
 drivers/gpu/drm/i915/selftests/i915_gem_evict.c                    |    4 
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c                          |    6 
 drivers/gpu/drm/mgag200/mgag200_g200se.c                           |    3 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                                |    3 
 drivers/hid/hid-ids.h                                              |    1 
 drivers/hid/hid-input.c                                            |    2 
 drivers/iommu/amd/init.c                                           |   86 +-
 drivers/md/dm-cache-metadata.c                                     |   54 +
 drivers/md/dm-cache-target.c                                       |   11 
 drivers/md/dm-clone-target.c                                       |    1 
 drivers/md/dm-integrity.c                                          |    2 
 drivers/md/dm-thin-metadata.c                                      |   60 +
 drivers/md/dm-thin.c                                               |   18 
 drivers/md/md-bitmap.c                                             |   20 
 drivers/media/dvb-core/dmxdev.c                                    |    8 
 drivers/media/dvb-core/dvbdev.c                                    |    1 
 drivers/media/dvb-frontends/stv0288.c                              |    5 
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c              |    4 
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c               |   12 
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c            |   14 
 drivers/mmc/host/sdhci-sprd.c                                      |   16 
 drivers/mtd/spi-nor/core.c                                         |    2 
 drivers/mtd/spi-nor/gigadevice.c                                   |   24 
 drivers/net/ethernet/renesas/ravb_main.c                           |    2 
 drivers/net/wireless/microchip/wilc1000/sdio.c                     |    1 
 drivers/of/kexec.c                                                 |   10 
 drivers/parisc/led.c                                               |    3 
 drivers/pci/doe.c                                                  |   20 
 drivers/pci/pci-sysfs.c                                            |   13 
 drivers/pci/pci.c                                                  |    2 
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c                          |   47 +
 drivers/platform/x86/ideapad-laptop.c                              |  371 +++++++---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c     |    1 
 drivers/platform/x86/thinkpad_acpi.c                               |    1 
 drivers/platform/x86/x86-android-tablets.c                         |  285 +++++++
 drivers/remoteproc/imx_dsp_rproc.c                                 |   12 
 drivers/remoteproc/imx_rproc.c                                     |    4 
 drivers/remoteproc/remoteproc_core.c                               |    9 
 drivers/rtc/rtc-ds1347.c                                           |    2 
 drivers/soc/qcom/Kconfig                                           |    2 
 drivers/soc/ux500/ux500-soc-id.c                                   |   10 
 drivers/staging/media/ipu3/ipu3-v4l2.c                             |   57 -
 drivers/staging/media/tegra-video/csi.c                            |    4 
 drivers/staging/media/tegra-video/csi.h                            |    2 
 fs/btrfs/backref.c                                                 |    4 
 fs/btrfs/extent-io-tree.c                                          |    2 
 fs/btrfs/volumes.c                                                 |    3 
 fs/cifs/cifsfs.c                                                   |    8 
 fs/cifs/connect.c                                                  |   16 
 fs/dlm/lowcomms.c                                                  |    9 
 fs/ext2/dir.c                                                      |    2 
 fs/ext4/ext4.h                                                     |    9 
 fs/ext4/extents.c                                                  |    8 
 fs/ext4/extents_status.c                                           |    3 
 fs/ext4/fast_commit.c                                              |  171 ++--
 fs/ext4/fast_commit.h                                              |    3 
 fs/ext4/indirect.c                                                 |    9 
 fs/ext4/inode.c                                                    |   48 +
 fs/ext4/ioctl.c                                                    |   24 
 fs/ext4/namei.c                                                    |   47 -
 fs/ext4/orphan.c                                                   |    2 
 fs/ext4/resize.c                                                   |   32 
 fs/ext4/super.c                                                    |   42 -
 fs/ext4/verity.c                                                   |    2 
 fs/ext4/xattr.c                                                    |   19 
 fs/fs_parser.c                                                     |    3 
 fs/mbcache.c                                                       |   14 
 fs/quota/dquot.c                                                   |    2 
 include/linux/bpf_verifier.h                                       |    2 
 include/linux/devfreq.h                                            |    7 
 include/linux/fs_parser.h                                          |    1 
 include/linux/mbcache.h                                            |    9 
 include/linux/prandom.h                                            |   18 
 include/linux/random.h                                             |   65 +
 include/net/mptcp.h                                                |   12 
 include/trace/events/ext4.h                                        |    7 
 include/trace/events/jbd2.h                                        |   44 -
 kernel/bpf/core.c                                                  |    5 
 kernel/events/core.c                                               |    6 
 kernel/trace/Kconfig                                               |    2 
 kernel/trace/trace.c                                               |   38 -
 kernel/trace/trace.h                                               |   27 
 kernel/trace/trace_eprobe.c                                        |    3 
 kernel/trace/trace_events_hist.c                                   |   11 
 kernel/trace/trace_events_synth.c                                  |    2 
 kernel/trace/trace_probe.c                                         |    2 
 lib/Kconfig.debug                                                  |    1 
 mm/hugetlb.c                                                       |  333 +++-----
 net/ipv4/syncookies.c                                              |    7 
 net/mptcp/pm_userspace.c                                           |    4 
 net/mptcp/subflow.c                                                |   61 +
 security/device_cgroup.c                                           |   33 
 security/integrity/ima/Kconfig                                     |    2 
 security/integrity/ima/ima_main.c                                  |    7 
 security/integrity/ima/ima_template.c                              |    5 
 security/integrity/platform_certs/load_uefi.c                      |    1 
 sound/pci/hda/patch_cs8409.c                                       |    2 
 sound/pci/hda/patch_realtek.c                                      |   50 +
 sound/soc/jz4740/jz4740-i2s.c                                      |   39 -
 sound/usb/card.h                                                   |    1 
 sound/usb/endpoint.c                                               |   16 
 sound/usb/endpoint.h                                               |    3 
 sound/usb/implicit.c                                               |    6 
 sound/usb/implicit.h                                               |    2 
 sound/usb/pcm.c                                                    |   36 
 sound/usb/pcm.h                                                    |    2 
 sound/usb/quirks.c                                                 |    2 
 sound/usb/usbaudio.h                                               |    4 
 tools/testing/ktest/ktest.pl                                       |   23 
 tools/testing/selftests/lib.mk                                     |    5 
 197 files changed, 3009 insertions(+), 1142 deletions(-)

Aditya Garg (1):
      efi: Add iMac Pro 2017 to uefi skip cert quirk

Aidan MacDonald (1):
      ASoC: jz4740-i2s: Handle independent FIFO flush bits

Al Viro (1):
      ext2: unbugger ext2_empty_dir()

Alex Deucher (3):
      drm/amdgpu: skip MES for S0ix as well since it's part of GFX
      drm/amdgpu: handle polaris10/11 overlap asics (v2)
      drm/amdgpu: make display pinning more flexible (v2)

Alexander Antonov (2):
      perf/x86/intel/uncore: Disable I/O stacks to PMU mapping on ICX-D
      perf/x86/intel/uncore: Clear attr_update properly

Alexander Aring (2):
      fs: dlm: fix sock release if listen fails
      fs: dlm: retry accept() until -EAGAIN or error returns

Alexander Potapenko (1):
      fs: ext4: initialize fsdata in pagecache_write()

Alexander Sverdlin (1):
      mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()

Andrew Cooper (1):
      x86/fpu/xstate: Fix XSTATE_WARN_ON() to emit relevant diagnostics

Arnd Bergmann (1):
      ata: ahci: fix enum constants for gcc-13

Artem Bityutskiy (1):
      platform/x86: intel-uncore-freq: add Emerald Rapids support

Ashok Raj (1):
      x86/microcode/intel: Do not retry microcode reloading on the APs

Baokun Li (10):
      ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop
      ext4: correct inconsistent error msg in nojournal mode
      ext4: fix use-after-free in ext4_orphan_cleanup
      ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode
      ext4: add helper to check quota inums
      ext4: fix bug_on in __es_tree_search caused by bad quota inode
      ext4: fix bug_on in __es_tree_search caused by bad boot loader inode
      ext4: fix corruption when online resizing a 1K bigalloc fs
      ext4: fix bad checksum after online resize
      ext4: fix corrupt backup group descriptors after online resize

Biju Das (1):
      ravb: Fix "failed to switch device to config mode" message during unbind

Bixuan Cui (1):
      jbd2: use the correct print format

Boris Burkov (1):
      btrfs: fix resolving backrefs for inline extent followed by prealloc

Chris Chiu (1):
      ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude laptops

Chris Wilson (1):
      drm/i915/migrate: Account for the reserved_space

Corentin Labbe (1):
      crypto: n2 - add missing hash statesize

Damien Le Moal (2):
      block: mq-deadline: Fix dd_finish_request() for zoned devices
      block: mq-deadline: Do not break sequential write streams to zoned HDDs

Dan Carpenter (1):
      ipmi: fix use after free in _ipmi_destroy_user()

Dan Williams (1):
      cxl/region: Fix missing probe failure

Darrick J. Wong (2):
      ext4: don't fail GETFSUUID when the caller provides a long buffer
      ext4: dont return EINVAL from GETFSUUID when reporting UUID length

Eray Orçunus (2):
      platform/x86: ideapad-laptop: Revert "check for touchpad support in _CFG"
      platform/x86: ideapad-laptop: Add new _CFG bit numbers for future use

Eric Biggers (7):
      ext4: don't allow journal inode to have encrypt flag
      ext4: disable fast-commit of encrypted dir operations
      ext4: fix leaking uninitialized memory in fast-commit journal
      ext4: don't set up encryption key during jbd2 transaction
      ext4: add missing validation of fast-commit record lengths
      ext4: fix unaligned memory access in ext4_fc_reserve_space()
      ext4: fix off-by-one errors in fast-commit block filling

Eric Whitney (1):
      ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline

Evan Quan (6):
      drm/amd/pm: update SMU13.0.0 reported maximum shader clock
      drm/amd/pm: correct SMU13.0.0 pstate profiling clock settings
      drm/amd/pm: add missing SMU13.0.0 mm_dpm feature mapping
      drm/amd/pm: add missing SMU13.0.7 mm_dpm feature mapping
      drm/amd/pm: bump SMU13.0.0 driver_if header to version 0x34
      drm/amd/pm: correct the fan speed retrieving in PWM for some SMU13 asics

Fan Ni (1):
      cxl/region: Fix memdev reuse check

Florian-Ewald Mueller (1):
      md/bitmap: Fix bitmap chunk size overflow issues

Gaosheng Cui (1):
      ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Greg Kroah-Hartman (1):
      Linux 6.1.4

Guo Ren (2):
      riscv: Fixup compile error with !MMU
      riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument

Hans de Goede (11):
      platform/x86: thinkpad_acpi: Fix max_brightness of thinklight
      ACPI: video: Simplify __acpi_video_get_backlight_type()
      ACPI: video: Prefer native over vendor
      platform/x86: ideapad-laptop: Refactor ideapad_sync_touchpad_state()
      platform/x86: ideapad-laptop: Do not send KEY_TOUCHPAD* events on probe / resume
      platform/x86: ideapad-laptop: Only toggle ps2 aux port on/off on select models
      platform/x86: ideapad-laptop: Send KEY_TOUCHPAD_TOGGLE on some models
      platform/x86: ideapad-laptop: Stop writing VPCCMD_W_TOUCHPAD at probe time
      platform/x86: x86-android-tablets: Add Medion Lifetab S10346 data
      platform/x86: x86-android-tablets: Add Lenovo Yoga Tab 3 (YT3-X90F) charger + fuel-gauge data
      platform/x86: x86-android-tablets: Add Advantech MICA-071 extra button

Helge Deller (5):
      parisc: Drop locking in pdc console code
      parisc: Fix locking in pdc_iodc_print() firmware call
      parisc: Add missing FORCE prerequisites in Makefile
      parisc: Drop duplicate kgdb_pdc console
      parisc: Drop PMD_SHIFT from calculation in pgtable.h

Huaxin Lu (1):
      ima: Fix a potential NULL pointer access in ima_restore_measurement_list

Ian Abbott (1):
      rtc: ds1347: fix value written to century register

Isaac J. Manjarres (1):
      driver core: Fix bus_type.match() error handling in __driver_attach()

Jan Kara (4):
      ext4: avoid BUG_ON when creating xattrs
      ext4: fix deadlock due to mbcache entry corruption
      ext4: initialize quota before expanding inode in setproject ioctl
      ext4: avoid unaccounted block allocation when expanding inode

Jaroslav Kysela (1):
      ALSA: usb-audio: Add new quirk FIXED_RATE for JBL Quantum810 Wireless

Jason A. Donenfeld (4):
      media: stv0288: use explicitly signed char
      ARM: ux500: do not directly dereference __iomem
      random: use rejection sampling for uniform bounded random integers
      random: add helpers for random numbers with given floor or range

Jocelyn Falempe (1):
      drm/mgag200: Fix PLL setup for G200_SE_A rev >=4

Johan Hovold (5):
      arm64: dts: qcom: sc8280xp: fix UFS DMA coherency
      arm64: dts: qcom: sc8280xp: fix UFS reference clocks
      phy: qcom-qmp-combo: fix out-of-bounds clock access
      phy: qcom-qmp-combo: fix sdm845 reset
      phy: qcom-qmp-combo: fix sc8180x reset

Josef Bacik (1):
      btrfs: fix uninitialized parent in insert_state

José Expósito (1):
      HID: Ignore HP Envy x360 eu0009nv stylus battery

Kant Fan (1):
      PM/devfreq: governor: Add a private governor_data for governor

Kees Cook (1):
      um: virt-pci: Avoid GCC non-NULL warning

Keita Suzuki (1):
      media: dvb-core: Fix double free in dvb_register_device()

Kim Phillips (2):
      iommu/amd: Fix ivrs_acpihid cmdline parsing code
      iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Krzysztof Kozlowski (3):
      arm64: dts: qcom: sdm845-db845c: correct SPI2 pins drive strength
      arm64: dts: qcom: sdm850-samsung-w737: correct I2C12 pins drive strength
      arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength

Li Hua (1):
      test_kprobes: Fix implicit declaration error of test_kprobes

Li Huafei (2):
      RISC-V: kexec: Fix memory leak of fdt buffer
      RISC-V: kexec: Fix memory leak of elf header buffer

Li Ming (1):
      PCI/DOE: Fix maximum data object length miscalculation

Luca Ceresoli (2):
      staging: media: tegra-video: fix chan->mipi value on error
      staging: media: tegra-video: fix device_node use after free

Lucas Stach (2):
      drm/etnaviv: move idle mapping reaping into separate function
      drm/etnaviv: reap idle mapping if it doesn't match the softpin address

Lukas Czerner (1):
      ext4: journal_path mount options should follow links

Luo Meng (5):
      dm thin: resume even if in FAIL mode
      dm thin: Fix UAF in run_timer_softirq()
      dm integrity: Fix UAF in dm_integrity_dtr()
      dm clone: Fix UAF in clone_dtr()
      dm cache: Fix UAF in destroy()

Luís Henriques (2):
      ext4: remove trailing newline from ext4_msg() message
      ext4: fix error code return to user-space in ext4_get_branch()

Macpaul Lin (1):
      arm64: dts: mediatek: mt8195-demo: fix the memory size of node secmon

Manivannan Sadhasivam (2):
      soc: qcom: Select REMAP_MMIO for LLCC driver
      soc: qcom: Select REMAP_MMIO for ICC_BWMON driver

Maria Yu (1):
      remoteproc: core: Do pm_relax when in RPROC_OFFLINE state

Mario Limonciello (1):
      crypto: ccp - Add support for TEE for PCI ID 0x14CA

Masami Hiramatsu (Google) (4):
      arm64: Prohibit instrumentation on arch_stack_walk()
      x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK
      x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK
      tracing: Fix complicated dependency of CONFIG_TRACER_MAX_TRACE

Matthew Auld (2):
      drm/i915/ttm: consider CCS for backup objects
      drm/i915: improve the catch-all evict to handle lock contention

Matthieu Baerts (3):
      mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
      mptcp: dedicated request sock for subflow in v6
      mptcp: use proper req destructor for IPv6

Max Filippov (1):
      xtensa: add __umulsidi3 helper

Maximilian Luz (1):
      ipu3-imgu: Fix NULL pointer dereference in imgu_subdev_set_selection()

Michael Jeanson (1):
      powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1

Michael S. Tsirkin (1):
      PCI: Fix pci_device_is_present() for VFs by checking PF

Michael Walle (1):
      wifi: wilc1000: sdio: fix module autoloading

Mickaël Salaün (1):
      selftests: Use optional USERCFLAGS and USERLDFLAGS

Mike Kravetz (1):
      hugetlb: really allocate vma lock for all sharable vmas

Mike Snitzer (2):
      dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort
      dm cache: set needs_check flag after aborting metadata

Mikko Kovanen (1):
      drm/i915/dsi: fix VBT send packet port selection for dual link DSI

Namhyung Kim (1):
      perf/core: Call LSM hook after copying perf_event_attr

Nick Desaulniers (1):
      ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Paulo Alcantara (4):
      cifs: fix confusing debug message
      cifs: set correct tcon status after initial tree connect
      cifs: set correct ipc status after initial tree connect
      cifs: set correct status of tcon ipc when reconnecting

Peng Fan (1):
      remoteproc: imx_rproc: Correct i.MX93 DRAM mapping

Philipp Jungkamp (2):
      ALSA: patch_realtek: Fix Dell Inspiron Plus 16
      platform/x86: ideapad-laptop: support for more special keys in WMI

Qiang Yu (1):
      bus: mhi: host: Fix race between channel preparation and M0 event

Rob Herring (1):
      of/kexec: Fix reading 32-bit "linux,initrd-{start,end}" values

Roberto Sassu (1):
      ima: Fix memory leak in __ima_inode_hash()

Sascha Hauer (1):
      PCI/sysfs: Fix double free in error path

Sean Christopherson (3):
      KVM: VMX: Resume guest immediately when injecting #GP on ECREATE
      KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails
      KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1

Sergey Matyukevich (1):
      riscv: mm: notify remote harts about mmu cache updates

Shang XiaoJing (1):
      parisc: led: Fix potential null-ptr-deref in start_task()

Shengjiu Wang (1):
      remoteproc: imx_dsp_rproc: Add mutex protection for workqueue

Simon Ser (1):
      drm/connector: send hotplug uevent on connector cleanup

Smitha T Murthy (3):
      media: s5p-mfc: Fix to handle reference queue during finishing
      media: s5p-mfc: Clear workbit to handle error condition
      media: s5p-mfc: Fix in register read and write for H264

Steve French (1):
      cifs: fix missing display of three mount options

Steven Rostedt (2):
      kest.pl: Fix grub2 menu handling for rebooting
      ktest.pl minconfig: Unset configs instead of just removing them

Steven Rostedt (Google) (3):
      ftrace/x86: Add back ftrace_expected for ftrace bug reports
      tracing: Fix race where eprobes can be called before the event
      tracing/probes: Handle system names with hyphens

Takashi Iwai (1):
      media: dvb-core: Fix UAF due to refcount races at releasing

Tianjia Zhang (2):
      ima: Fix hash dependency to correct algorithm
      crypto: ccree,hisilicon - Fix dependencies to correct algorithm

Tim Huang (1):
      drm/amdgpu: skip mes self test after s0i3 resume for MES IP v11.0

Toke Høiland-Jørgensen (1):
      bpf: Resolve fext program type when checking map compatibility

Vitaly Rodionov (1):
      ALSA: hda/cirrus: Add extra 10 ms delay to allow PLL settle and lock.

Wang Weiyang (1):
      device_cgroup: Roll back to original exceptions after copy failure

Wei Yongjun (1):
      mptcp: netlink: fix some error return code

Wenchao Chen (1):
      mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K

Yaliang Wang (1):
      mtd: spi-nor: gigadevice: gd25q256: replace gd25q256_default_init with gd25q256_post_bfpt

Yang Jihong (1):
      tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Yang Wang (1):
      drm/amdgpu: fix mmhub register base coding error

Yazen Ghannam (2):
      EDAC/mc_sysfs: Increase legacy channel support to 12
      x86/MCE/AMD: Clear DFR errors found in THR handler

Ye Bin (6):
      ext4: fix reserved cluster accounting in __es_remove_extent()
      ext4: fix uninititialized value in 'ext4_evict_inode'
      ext4: init quota for 'old.inode' in 'ext4_rename'
      ext4: fix kernel BUG in 'ext4_write_inline_data_end()'
      ext4: fix inode leak in ext4_xattr_inode_create() on an error path
      ext4: allocate extended attribute value in vmalloc area

Yifan Zhang (1):
      drm/amd/display: Add DCN314 display SG Support

Yongqiang Liu (1):
      cpufreq: Init completion before kobject_init_and_add()

Yuan Can (1):
      drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()

Yuan ZhaoXiong (1):
      KVM: x86: fix APICv/x2AVIC disabled when vm reboot by itself

Zack Rusin (1):
      drm/vmwgfx: Validate the box size for the snooped cursor

Zhang Yi (2):
      ext4: silence the warning when evicting inode with dioread_nolock
      ext4: check and assert if marking an no_delete evicting inode dirty

Zhang Yuchen (1):
      ipmi: fix long wait in unload when IPMI disconnect

Zheng Yejian (3):
      tracing/hist: Fix out-of-bound write on 'action_data.var_ref_idx'
      tracing/hist: Fix wrong return value in parse_action_params()
      tracing: Fix issue of missing one synthetic field

Zhihao Cheng (2):
      dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata
      dm thin: Use last transaction's pmd->root when commit failed

void0red (1):
      btrfs: fix extent map use-after-free when handling missing device in read_one_chunk

