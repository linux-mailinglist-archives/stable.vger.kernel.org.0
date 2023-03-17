Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEA6BE294
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjCQIF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCQIFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64889B855E;
        Fri, 17 Mar 2023 01:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA30E6220D;
        Fri, 17 Mar 2023 08:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86E3C4339E;
        Fri, 17 Mar 2023 08:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040277;
        bh=tigXkoSzuR+IyS6c4MVgzv//OGgXrYacCv3n/MEXB1M=;
        h=From:To:Cc:Subject:Date:From;
        b=rHOm8g0u4nB2m3lP81hYEmZkb8SMga53ffx2l4tIXxWnLnxNIU1nQMM0bajxIl5X7
         irzb6AmwI2td4gjpWn6ycia7ldRJV28Sl2/lqv5TdrKBWhtoai3jLKBNSmtSZjrgsc
         Vtk1vrVucrfv0BxjNcZMQZHcYa6OBsLBslf+i/8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.20
Date:   Fri, 17 Mar 2023 09:04:33 +0100
Message-Id: <1679040274157131@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.20 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/alpha/kernel/module.c                              |    4 
 arch/m68k/kernel/setup_mm.c                             |   10 
 arch/mips/include/asm/mach-rc32434/pci.h                |    2 
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts            |    1 
 arch/powerpc/include/asm/hw_irq.h                       |    6 
 arch/powerpc/include/asm/paca.h                         |    1 
 arch/powerpc/include/asm/smp.h                          |    1 
 arch/powerpc/kernel/iommu.c                             |    4 
 arch/powerpc/kernel/irq_64.c                            |  101 +++--
 arch/powerpc/kernel/prom.c                              |   12 
 arch/powerpc/kernel/setup-common.c                      |    4 
 arch/powerpc/kernel/setup_64.c                          |   16 
 arch/powerpc/kernel/time.c                              |    4 
 arch/powerpc/net/bpf_jit_comp32.c                       |   20 -
 arch/riscv/Makefile                                     |    7 
 arch/riscv/include/asm/ftrace.h                         |    2 
 arch/riscv/include/asm/parse_asm.h                      |    5 
 arch/riscv/include/asm/patch.h                          |    2 
 arch/riscv/kernel/compat_vdso/Makefile                  |    4 
 arch/riscv/kernel/ftrace.c                              |   13 
 arch/riscv/kernel/patch.c                               |   28 +
 arch/riscv/kernel/stacktrace.c                          |    2 
 arch/um/kernel/vmlinux.lds.S                            |    2 
 arch/x86/include/asm/kvm_host.h                         |    3 
 arch/x86/kernel/cpu/amd.c                               |    9 
 arch/x86/kvm/svm/svm.c                                  |   23 +
 arch/x86/kvm/vmx/vmx.c                                  |   91 +++-
 arch/x86/kvm/x86.c                                      |   15 
 block/blk.h                                             |    2 
 block/genhd.c                                           |   37 +
 block/ioctl.c                                           |   13 
 drivers/bus/mhi/ep/main.c                               |   41 --
 drivers/bus/mhi/ep/sm.c                                 |   42 +-
 drivers/char/ipmi/ipmi_ssif.c                           |   43 +-
 drivers/char/tpm/eventlog/acpi.c                        |    6 
 drivers/clk/renesas/Kconfig                             |    2 
 drivers/clk/renesas/r8a7795-cpg-mssr.c                  |  126 ------
 drivers/clk/renesas/rcar-gen3-cpg.c                     |   17 
 drivers/clk/renesas/renesas-cpg-mssr.c                  |   27 -
 drivers/clk/renesas/renesas-cpg-mssr.h                  |   14 
 drivers/gpu/drm/amd/amdgpu/nv.c                         |    7 
 drivers/gpu/drm/amd/amdgpu/soc15.c                      |    5 
 drivers/gpu/drm/amd/amdgpu/soc21.c                      |   69 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c               |    2 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c   |   62 +++
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h   |    4 
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c |    9 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c    |   36 +
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c  |    5 
 drivers/gpu/drm/display/drm_hdmi_helper.c               |    6 
 drivers/gpu/drm/drm_atomic.c                            |    1 
 drivers/gpu/drm/i915/display/icl_dsi.c                  |    3 
 drivers/gpu/drm/i915/display/intel_bios.c               |   71 ++-
 drivers/gpu/drm/i915/display/intel_bios.h               |   11 
 drivers/gpu/drm/i915/display/intel_connector.c          |    2 
 drivers/gpu/drm/i915/display/intel_display_types.h      |    2 
 drivers/gpu/drm/i915/display/intel_dp.c                 |    7 
 drivers/gpu/drm/i915/display/intel_lvds.c               |    4 
 drivers/gpu/drm/i915/display/intel_panel.c              |    8 
 drivers/gpu/drm/i915/display/intel_panel.h              |    1 
 drivers/gpu/drm/i915/display/intel_sdvo.c               |    2 
 drivers/gpu/drm/i915/display/vlv_dsi.c                  |    2 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                   |    6 
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c               |    4 
 drivers/gpu/drm/msm/adreno/adreno_device.c              |    6 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c          |   25 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c                  |    2 
 drivers/gpu/drm/msm/msm_gem_submit.c                    |    5 
 drivers/gpu/drm/nouveau/dispnv50/wndw.h                 |    5 
 drivers/hid/hid-core.c                                  |   32 +
 drivers/hid/uhid.c                                      |    1 
 drivers/input/touchscreen/exc3000.c                     |   10 
 drivers/macintosh/windfarm_lm75_sensor.c                |    4 
 drivers/macintosh/windfarm_smu_sensors.c                |    4 
 drivers/media/i2c/ov5640.c                              |    2 
 drivers/media/rc/gpio-ir-recv.c                         |   18 
 drivers/net/dsa/mt7530.c                                |   35 +
 drivers/net/ethernet/broadcom/bgmac.c                   |    8 
 drivers/net/ethernet/broadcom/bgmac.h                   |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c               |   23 -
 drivers/net/ethernet/intel/ice/ice_dcb.c                |    2 
 drivers/net/ethernet/intel/ice/ice_ethtool.c            |    6 
 drivers/net/ethernet/intel/ice/ice_tc_lib.c             |    8 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h         |    5 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c |    7 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c     |   16 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c     |   58 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h     |    3 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c             |    3 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h             |    1 
 drivers/net/ethernet/microchip/lan966x/lan966x_police.c |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |    1 
 drivers/net/phy/microchip.c                             |   32 +
 drivers/net/phy/phy_device.c                            |    8 
 drivers/net/phy/smsc.c                                  |   14 
 drivers/net/usb/lan78xx.c                               |   27 -
 drivers/nfc/fdp/i2c.c                                   |    4 
 drivers/platform/mellanox/Kconfig                       |    9 
 drivers/platform/x86/Kconfig                            |    3 
 drivers/scsi/hosts.c                                    |    2 
 drivers/scsi/megaraid/megaraid_sas.h                    |    2 
 drivers/scsi/megaraid/megaraid_sas_fp.c                 |    2 
 drivers/scsi/sd.c                                       |    7 
 drivers/scsi/sd_zbc.c                                   |    8 
 drivers/spi/spi-intel.c                                 |    8 
 drivers/staging/rtl8723bs/include/rtw_security.h        |    8 
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c       |   32 -
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c          |   33 -
 fs/btrfs/block-group.c                                  |    3 
 fs/btrfs/extent_map.c                                   |    7 
 fs/btrfs/volumes.c                                      |    2 
 fs/cifs/cifsproto.h                                     |   20 -
 fs/cifs/misc.c                                          |   67 +++
 fs/cifs/smb2inode.c                                     |   21 -
 fs/cifs/smb2ops.c                                       |   23 -
 fs/dlm/lock.c                                           |   95 -----
 fs/dlm/lockspace.c                                      |   21 -
 fs/dlm/lowcomms.c                                       |   16 
 fs/dlm/lowcomms.h                                       |    1 
 fs/dlm/main.c                                           |    7 
 fs/dlm/midcomms.c                                       |   96 ++++-
 fs/dlm/midcomms.h                                       |    6 
 fs/dlm/rcom.c                                           |    4 
 fs/erofs/decompressor_lzma.c                            |    2 
 fs/erofs/zdata.c                                        |   12 
 fs/ext4/fsmap.c                                         |    2 
 fs/ext4/inline.c                                        |    1 
 fs/ext4/inode.c                                         |    7 
 fs/ext4/ioctl.c                                         |    1 
 fs/ext4/namei.c                                         |   36 +
 fs/ext4/page-io.c                                       |   11 
 fs/ext4/xattr.c                                         |    3 
 fs/file.c                                               |    1 
 fs/locks.c                                              |    3 
 fs/nfsd/vfs.c                                           |    2 
 fs/udf/inode.c                                          |    2 
 include/linux/hid.h                                     |    3 
 include/linux/mhi_ep.h                                  |    4 
 include/linux/pci_ids.h                                 |    2 
 include/net/netfilter/nf_tproxy.h                       |    7 
 include/trace/events/dlm.h                              |  297 ++++++++++++++++
 io_uring/uring_cmd.c                                    |    4 
 kernel/bpf/btf.c                                        |    1 
 kernel/fork.c                                           |    2 
 kernel/watch_queue.c                                    |    1 
 net/caif/caif_usb.c                                     |    3 
 net/core/sock.c                                         |    3 
 net/ipv4/netfilter/nf_tproxy_ipv4.c                     |    2 
 net/ipv4/tcp_bpf.c                                      |    6 
 net/ipv4/udp_bpf.c                                      |    3 
 net/ipv6/ila/ila_xlat.c                                 |    1 
 net/ipv6/netfilter/nf_tproxy_ipv6.c                     |    2 
 net/netfilter/nf_conntrack_core.c                       |    4 
 net/netfilter/nf_conntrack_netlink.c                    |   14 
 net/netfilter/nft_last.c                                |    4 
 net/netfilter/nft_quota.c                               |    6 
 net/nfc/netlink.c                                       |    2 
 net/smc/af_smc.c                                        |   13 
 net/sunrpc/svc.c                                        |    6 
 net/tls/tls_device.c                                    |    2 
 net/tls/tls_main.c                                      |   23 -
 net/tls/tls_sw.c                                        |    2 
 net/unix/af_unix.c                                      |   10 
 net/unix/unix_bpf.c                                     |    3 
 scripts/checkkconfigsymbols.py                          |   13 
 scripts/clang-tools/run-clang-tools.py                  |   21 -
 scripts/diffconfig                                      |   16 
 tools/perf/builtin-inject.c                             |    1 
 tools/perf/builtin-stat.c                               |   15 
 tools/perf/util/stat.c                                  |    6 
 tools/perf/util/stat.h                                  |    1 
 tools/perf/util/target.h                                |   12 
 tools/testing/selftests/netfilter/nft_nat.sh            |    2 
 174 files changed, 1715 insertions(+), 860 deletions(-)

Alex Deucher (4):
      drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15
      drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc21
      drm/amdgpu: fix error checking in amdgpu_read_mm_registers for nv
      drm/amdgpu/soc21: don't expose AV1 if VCN0 is harvested

Alexander Aring (10):
      fs: dlm: fix log of lowcomms vs midcomms
      fs: dlm: add midcomms init/start functions
      fs: dlm: start midcomms before scand
      fs: dlm: remove send repeat remove handling
      fs: dlm: use packet in dlm_mhandle
      fd: dlm: trace send/recv of dlm message and rcom
      fs: dlm: fix use after free in midcomms commit
      fs: dlm: use WARN_ON_ONCE() instead of WARN_ON()
      fs: dlm: be sure to call dlm_send_queue_flush()
      fs: dlm: fix race setting stop tx flag

Alexander Lobakin (1):
      bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES

Alexandre Ghiti (1):
      riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

Alvaro Karsz (1):
      PCI: Add SolidRun vendor ID

Alvin Lee (1):
      drm/amd/display: Allow subvp on vactive pipes that are 2560x1440@60

Andrew Cooper (1):
      x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Arnd Bergmann (1):
      ethernet: ice: avoid gcc-9 integer overflow warning

Bart Van Assche (1):
      scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Benjamin Coddington (1):
      SUNRPC: Fix a server shutdown leak

Brian Vazquez (1):
      net: use indirect calls helpers for sk_exit_memory_pressure()

Chandrakanth Patil (1):
      scsi: megaraid_sas: Update max supported LD IDs to 240

Changbin Du (1):
      perf stat: Fix counting when initial delay configured

Christophe Leroy (1):
      powerpc/bpf/32: Only set a stack frame when necessary

Chuck Lever (1):
      NFSD: Protect against filesystem freezing

Conor Dooley (1):
      RISC-V: Don't check text_mutex during stop_machine

Corey Minyard (3):
      ipmi:ssif: Remove rtc_us_timer
      ipmi:ssif: Increase the message retry time
      ipmi:ssif: Add a timer between request retries

D. Wythe (1):
      net/smc: fix fallback failed while sendmsg with fastopen

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix RX data corruption issue

Darrick J. Wong (1):
      ext4: fix another off-by-one fsmap error on 1k block filesystems

Dave Ertman (1):
      ice: Fix DSCP PFC TLV creation

David Disseldorp (1):
      watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths

Dmitry Baryshkov (8):
      drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register
      drm/msm/a5xx: fix highest bank bit for a530
      drm/msm/a5xx: fix the emptyness check in the preempt code
      drm/msm/a5xx: fix context faults during ring switch
      drm/msm/dpu: disable features unsupported by QCM2290
      drm/msm/dpu: fix len of sc7180 ctl blocks
      drm/msm/dpu: drop DPU_DIM_LAYER from MIXER_MSM8998_MASK
      drm/msm/dpu: fix clocks settings for msm8998 SSPP blocks

Dmitry Torokhov (1):
      Input: exc3000 - properly stop timer on shutdown

Edward Humes (1):
      alpha: fix R_ALPHA_LITERAL reloc for large modules

Eric Biggers (1):
      ext4: fix cgroup writeback accounting with fs-layer encryption

Eric Dumazet (3):
      ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
      netfilter: conntrack: adopt safer max chain length
      af_unix: fix struct pid leaks in OOB support

Eric Whitney (1):
      ext4: fix RENAME_WHITEOUT handling for inline directories

Fedor Pchelkin (1):
      nfc: change order inside nfc_se_io error path

Filipe Manana (1):
      btrfs: fix extent map logging bit not cleared for split maps after dropping range

Florian Westphal (1):
      netfilter: tproxy: fix deadlock due to missing BH disable

Gao Xiang (2):
      erofs: fix wrong kunmap when using LZMA on HIGHMEM platforms
      erofs: Revert "erofs: fix kvcalloc() misuse with __GFP_NOFAIL"

Geert Uytterhoeven (1):
      m68k: mm: Move initrd phys_to_virt handling after paging_init()

Greg Kroah-Hartman (2):
      powerpc/iommu: fix memory leak with using debugfs_lookup()
      Linux 6.1.20

Hangbin Liu (1):
      selftests: nft_nat: ensuring the listening side is up before starting the client

Hangyu Hua (1):
      net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()

Hans de Goede (2):
      staging: rtl8723bs: Fix key-store index handling
      staging: rtl8723bs: Pass correct parameters to cfg80211_get_bss()

Harry Wentland (2):
      drm/display: Don't block HDR_OUTPUT_METADATA on unknown EOTF
      drm/connector: print max_requested_bpc in state debugfs

Heiner Kallweit (1):
      net: phy: smsc: fix link up detection in forced irq mode

Horatiu Vultur (1):
      net: lan966x: Fix port police support using tc-matchall

Ivan Delalande (1):
      netfilter: ctnetlink: revert to dumping mark regardless of event type

Jakub Kicinski (2):
      tls: rx: fix return value for async crypto
      net: tls: fix device-offloaded sendpage straddling records

Jan Kara (3):
      udf: Fix off-by-one error when discarding preallocation
      ext4: Fix possible corruption when moving a directory
      ext4: Fix deadlock during directory rename

Jens Axboe (1):
      io_uring/uring_cmd: ensure that device supports IOPOLL

Jiri Slaby (SUSE) (1):
      drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype

Joel Fernandes (Google) (1):
      adreno: Shutdown the GPU properly

Johan Hovold (1):
      drm/msm/adreno: fix runtime PM imbalance at unbind

Johannes Thumshirn (1):
      btrfs: fix percent calculation for bg reclaim message

Kalyan Thota (1):
      drm/msm/dpu: clear DSPP reservations in rm release

Kang Chen (1):
      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Lee Jones (2):
      HID: core: Provide new max_buffer_size attribute to over-ride the default
      HID: uhid: Over-ride the default maximum data buffer value with our own

Li Jun (1):
      media: rc: gpio-ir-recv: add remove function

Liao Chang (1):
      riscv: Add header include guards to insn.h

Liu Jian (1):
      bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()

Lorenz Bauer (1):
      btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

Manivannan Sadhasivam (2):
      bus: mhi: ep: Power up/down MHI stack during MHI RESET
      bus: mhi: ep: Change state_lock to mutex

Martin KaFai Lau (1):
      Revert "bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES"

Masahiro Yamada (2):
      scripts: handle BrokenPipeError for python scripts
      UML: define RUNTIME_DISCARD_EXIT

Michael Chan (1):
      bnxt_en: Avoid order-5 memory allocation for TPA data

Mika Westerberg (1):
      spi: intel: Check number of chip selects after reading the descriptor

Morten Linderud (1):
      tpm/eventlog: Don't abort tpm_read_log on faulty ACPI address

Namhyung Kim (1):
      perf inject: Fix --buildid-all not to eat up MMAP2

Naohiro Aota (1):
      btrfs: fix unnecessary increment of read error stat on write error

Nathan Chancellor (1):
      macintosh: windfarm: Use unsigned type for 1-bit bitfields

Nicholas Piggin (3):
      powerpc/64: Don't recurse irq replay
      powerpc/64: Fix task_cpu in early boot when booting non-zero cpuid
      powerpc/64: Move paca allocation to early_setup()

Pablo Neira Ayuso (2):
      netfilter: nft_last: copy content when cloning expression
      netfilter: nft_quota: copy content when cloning expression

Palmer Dabbelt (1):
      RISC-V: Stop emitting attributes

Paul Elder (1):
      media: ov5640: Fix analogue gain control

Paulo Alcantara (1):
      cifs: improve checking of DFS links over STATUS_OBJECT_NAME_INVALID

Petr Oros (1):
      ice: copy last block omitted in ice_get_module_eeprom()

Rafał Miłecki (1):
      bgmac: fix *initial* chip reset to support BCM5358

Randy Dunlap (2):
      platform: mellanox: select REGMAP instead of depending on it
      platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it

Rob Clark (1):
      drm/msm: Fix potential invalid ptr free

Rohan McLure (1):
      powerpc/kcsan: Exclude udelay to prevent recursive instrumentation

Rongguang Wei (1):
      net: stmmac: add to set device wake up flag when stmmac init phy

Russell King (Oracle) (1):
      net: phylib: get rid of unnecessary locking

Samson Tam (1):
      drm/amd/display: adjust MALL size available for DCN32 and DCN321

Sean Christopherson (4):
      KVM: VMX: Reset eVMCS controls in VP assist page during hardware disabling
      KVM: VMX: Don't bother disabling eVMCS static key on module exit
      KVM: x86: Move guts of kvm_arch_init() to standalone helper
      KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace

Seth Forshee (1):
      filelocks: use mount idmapping for setlease permission check

Shashank Sharma (1):
      drm/amdgpu: fix return value check in kfd

Shigeru Yoshida (1):
      net: caif: Fix use-after-free in cfusbl_device_notify()

Shin'ichiro Kawasaki (1):
      scsi: sd: Fix wrong zone_write_granularity value during revalidate

Suman Ghosh (1):
      octeontx2-af: Unlock contexts in the queue context cache in case of fault detection

Theodore Ts'o (1):
      fs: prevent out-of-bounds array speculation when closing a file descriptor

Tobias Klauser (1):
      fork: allow CLONE_NEWTIME in clone3 flags

Veerabadhran Gopalakrishnan (1):
      drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4

Ville Syrjälä (3):
      drm/i915: Introduce intel_panel_init_alloc()
      drm/i915: Do panel VBT init early if the VBT declares an explicit panel type
      drm/i915: Populate encoder->devdata for DSI on icl+

Vladimir Oltean (2):
      powerpc: dts: t1040rdb: fix compatible string for Rev A boards
      net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC

Wolfram Sang (1):
      clk: renesas: rcar-gen3: Disable R-Car H3 ES1.*

Ye Bin (2):
      ext4: move where set the MAY_INLINE_DATA flag is set
      ext4: fix WARNING in ext4_update_inline_data

Yu Kuai (3):
      block: Revert "block: Do not reread partition table on exclusively open device"
      block: fix scan partition for exclusively open device again
      block: fix wrong mode for blkdev_put() from disk_scan_partitions()

Yuiko Oshino (1):
      net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Zhihao Cheng (1):
      ext4: zero i_disksize when initializing the bootloader inode

xurui (1):
      MIPS: Fix a compilation issue

