Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A343A17AE2D
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 19:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgCESgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 13:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgCESgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 13:36:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5F34207FD;
        Thu,  5 Mar 2020 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583433378;
        bh=urSJmFXZtuVP7mxVMlL8QTTLIHZL7fcAUvJR1bH4zcw=;
        h=Date:From:To:Cc:Subject:From;
        b=cfDR4O+49NVHorAav8m4Mq7GiQhCTSbKE+AwWjDU74FZgADuMBiNhDsMvKWMujOpM
         aVn6zOeS+wCpQEjZzjlpVy8rT19d54toh6gWJUI0rB6ZzP+NzT4IY1Q0+R0hjbedu3
         nPZqCHO7my06I1ftqF5gpBqkwWC9NTRgruybfqgY=
Date:   Thu, 5 Mar 2020 19:36:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.24
Message-ID: <20200305183616.GA2124984@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.24 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/kbuild/makefiles.rst                         |   17=20
 Documentation/networking/nf_flowtable.txt                  |    2=20
 Makefile                                                   |  106 -
 arch/arm/boot/dts/stihxxx-b2120.dtsi                       |    2=20
 arch/mips/kernel/vpe.c                                     |    2=20
 arch/x86/events/intel/core.c                               |    1=20
 arch/x86/events/intel/cstate.c                             |   22=20
 arch/x86/events/msr.c                                      |    3=20
 arch/x86/kernel/cpu/resctrl/internal.h                     |    1=20
 arch/x86/kernel/cpu/resctrl/monitor.c                      |    4=20
 arch/x86/kvm/svm.c                                         |   43=20
 arch/x86/kvm/vmx/nested.c                                  |   70=20
 arch/x86/kvm/vmx/vmx.c                                     |   15=20
 arch/x86/kvm/x86.c                                         |    6=20
 drivers/acpi/acpi_watchdog.c                               |    3=20
 drivers/bus/Kconfig                                        |    1=20
 drivers/char/ipmi/ipmi_ssif.c                              |   10=20
 drivers/cpufreq/cpufreq.c                                  |   12=20
 drivers/devfreq/devfreq.c                                  |    4=20
 drivers/edac/skx_common.c                                  |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                    |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.h                    |    1=20
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                      |   37=20
 drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile            |    6=20
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |    6=20
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c               |    2=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c         |    1=20
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c      |    6=20
 drivers/gpu/drm/amd/include/asic_reg/dce/dce_12_0_offset.h |    2=20
 drivers/gpu/drm/i915/Kconfig.debug                         |    1=20
 drivers/gpu/drm/i915/gvt/dmabuf.c                          |    2=20
 drivers/gpu/drm/i915/gvt/vgpu.c                            |    2=20
 drivers/gpu/drm/msm/msm_drv.c                              |    8=20
 drivers/gpu/drm/radeon/radeon_drv.c                        |   43=20
 drivers/gpu/drm/radeon/radeon_kms.c                        |    6=20
 drivers/hid/hid-alps.c                                     |    2=20
 drivers/hid/hid-core.c                                     |    4=20
 drivers/hid/hid-ite.c                                      |    5=20
 drivers/hid/usbhid/hiddev.c                                |    2=20
 drivers/i2c/busses/i2c-altera.c                            |    2=20
 drivers/i2c/busses/i2c-jz4780.c                            |   36=20
 drivers/infiniband/hw/hns/hns_roce_device.h                |    3=20
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c                 |   37=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                 |   80=20
 drivers/infiniband/sw/siw/siw_cm.c                         |    5=20
 drivers/macintosh/therm_windtunnel.c                       |   52=20
 drivers/net/bonding/bond_main.c                            |   55=20
 drivers/net/bonding/bond_options.c                         |    2=20
 drivers/net/dsa/b53/b53_common.c                           |    3=20
 drivers/net/ethernet/amazon/ena/ena_com.c                  |   96 -
 drivers/net/ethernet/amazon/ena/ena_com.h                  |    9=20
 drivers/net/ethernet/amazon/ena/ena_ethtool.c              |   46=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c               |    6=20
 drivers/net/ethernet/amazon/ena/ena_netdev.h               |    2=20
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c           |    2=20
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c        |    2=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c            |    8=20
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c           |    7=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                  |   12=20
 drivers/net/ethernet/cadence/macb_main.c                   |    6=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   22=20
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c         |    4=20
 drivers/net/ethernet/intel/ice/ice_common.c                |   17=20
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h            |    6=20
 drivers/net/ethernet/mscc/ocelot_board.c                   |    8=20
 drivers/net/ethernet/qlogic/qede/qede.h                    |    2=20
 drivers/net/ethernet/qlogic/qede/qede_rdma.c               |   29=20
 drivers/net/hyperv/netvsc.c                                |    2=20
 drivers/net/hyperv/netvsc_drv.c                            |    3=20
 drivers/net/phy/mdio-bcm-iproc.c                           |   20=20
 drivers/net/usb/qmi_wwan.c                                 |   43=20
 drivers/net/wireless/marvell/mwifiex/main.h                |   13=20
 drivers/net/wireless/marvell/mwifiex/tdls.c                |   75=20
 drivers/nfc/pn544/i2c.c                                    |    1=20
 drivers/nvme/host/core.c                                   |   10=20
 drivers/nvme/host/pci.c                                    |   25=20
 drivers/nvme/host/rdma.c                                   |    2=20
 drivers/nvme/host/tcp.c                                    |    9=20
 drivers/perf/arm_smmuv3_pmu.c                              |    2=20
 drivers/pwm/pwm-omap-dmtimer.c                             |   21=20
 drivers/s390/crypto/ap_bus.h                               |    4=20
 drivers/s390/crypto/ap_card.c                              |    8=20
 drivers/s390/crypto/ap_queue.c                             |    6=20
 drivers/s390/crypto/zcrypt_api.c                           |   16=20
 drivers/s390/net/qeth_l2_main.c                            |   29=20
 drivers/soc/tegra/fuse/fuse-tegra30.c                      |    3=20
 drivers/thermal/broadcom/brcmstb_thermal.c                 |   31=20
 drivers/thermal/db8500_thermal.c                           |    4=20
 drivers/vhost/net.c                                        |   10=20
 drivers/watchdog/wdat_wdt.c                                |    2=20
 fs/ceph/file.c                                             |   17=20
 fs/cifs/cifsacl.c                                          |    4=20
 fs/cifs/connect.c                                          |    2=20
 fs/cifs/inode.c                                            |    2=20
 fs/dax.c                                                   |    3=20
 fs/ext4/super.c                                            |    6=20
 fs/f2fs/data.c                                             |   32=20
 fs/io_uring.c                                              |   51=20
 fs/namei.c                                                 |    2=20
 fs/nfs/nfs4file.c                                          |    1=20
 fs/nfs/nfs4proc.c                                          |   18=20
 fs/ubifs/orphan.c                                          |    4=20
 fs/xfs/libxfs/xfs_attr.h                                   |    7=20
 fs/xfs/xfs_ioctl.c                                         |    2=20
 fs/xfs/xfs_ioctl32.c                                       |    2=20
 include/Kbuild                                             | 1185 --------=
-----
 include/acpi/actypes.h                                     |    3=20
 include/asm-generic/vdso/vsyscall.h                        |    4=20
 include/linux/blkdev.h                                     |    2=20
 include/linux/blktrace_api.h                               |   18=20
 include/linux/hid.h                                        |    2=20
 include/linux/netdevice.h                                  |    7=20
 include/linux/netfilter/ipset/ip_set.h                     |   11=20
 include/linux/sched/nohz.h                                 |    2=20
 include/net/flow_dissector.h                               |    9=20
 include/uapi/linux/usb/charger.h                           |   16=20
 init/Kconfig                                               |   22=20
 kernel/audit.c                                             |   40=20
 kernel/auditfilter.c                                       |   71=20
 kernel/kprobes.c                                           |    4=20
 kernel/locking/lockdep_proc.c                              |    4=20
 kernel/rcu/tree_exp.h                                      |   11=20
 kernel/sched/core.c                                        |   31=20
 kernel/sched/fair.c                                        |    7=20
 kernel/sched/loadavg.c                                     |   33=20
 kernel/time/vsyscall.c                                     |   37=20
 kernel/trace/blktrace.c                                    |  114 -
 kernel/trace/trace.c                                       |    2=20
 lib/Kconfig.debug                                          |   11=20
 mm/debug.c                                                 |    8=20
 mm/gup.c                                                   |    3=20
 mm/huge_memory.c                                           |   26=20
 net/core/dev.c                                             |   28=20
 net/core/fib_rules.c                                       |    2=20
 net/ipv4/udp.c                                             |    6=20
 net/ipv6/ip6_fib.c                                         |    7=20
 net/ipv6/route.c                                           |    1=20
 net/mac80211/mlme.c                                        |    6=20
 net/mac80211/util.c                                        |   34=20
 net/netfilter/ipset/ip_set_core.c                          |   34=20
 net/netfilter/ipset/ip_set_hash_gen.h                      |  635 ++++--
 net/netfilter/nft_tunnel.c                                 |    4=20
 net/netfilter/xt_hashlimit.c                               |   12=20
 net/netlink/af_netlink.c                                   |    5=20
 net/sched/cls_flower.c                                     |    1=20
 net/sctp/sm_statefuns.c                                    |   29=20
 net/smc/af_smc.c                                           |    2=20
 net/smc/smc_clc.c                                          |    4=20
 net/tls/tls_device.c                                       |   20=20
 net/wireless/ethtool.c                                     |    8=20
 net/wireless/nl80211.c                                     |    5=20
 scripts/Makefile.build                                     |    9=20
 scripts/Makefile.headersinst                               |   18=20
 scripts/Makefile.lib                                       |   18=20
 security/integrity/ima/ima_policy.c                        |   44=20
 tools/perf/ui/browsers/hists.c                             |    1=20
 tools/perf/ui/gtk/Build                                    |    5=20
 tools/testing/selftests/ftrace/Makefile                    |    2=20
 tools/testing/selftests/livepatch/Makefile                 |    2=20
 tools/testing/selftests/net/fib_tests.sh                   |    6=20
 tools/testing/selftests/rseq/Makefile                      |    2=20
 tools/testing/selftests/rtc/Makefile                       |    2=20
 usr/include/Makefile                                       |   15=20
 virt/kvm/kvm_main.c                                        |   12=20
 164 files changed, 1883 insertions(+), 2294 deletions(-)

Aleksa Sarai (1):
      namei: only return -ECHILD from follow_dotdot_rcu()

Alexandra Winter (1):
      s390/qeth: vnicc Fix EOPNOTSUPP precedence

Alexandre Belloni (1):
      net: macb: ensure interface is not suspended on at91rm9200

Andrei Otcheretianski (1):
      mac80211: Remove a redundant mutex unlock

Anton Eidelman (1):
      nvme/tcp: fix bug on double requeue when send fails

Aric Cyr (1):
      drm/amd/display: Check engine is not NULL before acquiring

Aristeu Rozanski (1):
      EDAC: skx_common: downgrade message importance on missing PCI device

Arnaldo Carvalho de Melo (1):
      perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc

Arthur Kiyanovski (9):
      net: ena: fix potential crash when rxfh key is NULL
      net: ena: fix uses of round_jiffies()
      net: ena: add missing ethtool TX timestamping indication
      net: ena: fix incorrect default RSS key
      net: ena: rss: store hash function as values and not bits
      net: ena: fix incorrectly saving queue numbers when setting RSS indir=
ection table
      net: ena: fix corruption of dev_idx_to_host_tbl
      net: ena: ena-com.c: prevent NULL pointer dereference
      net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE

Arun Parameswaran (1):
      net: phy: restore mdio regs in the iproc mdio driver

Benjamin Poirier (2):
      ipv6: Fix route replacement with dev-only route
      ipv6: Fix nlmsg_flags when splitting a multipath route

Bijan Mottahedeh (1):
      nvme-pci: Hold cq_poll_lock while completing CQEs

Bj=F8rn Mork (2):
      qmi_wwan: re-add DW5821e pre-production variant
      qmi_wwan: unconditionally reject 2 ep interfaces

Brett Creeley (1):
      i40e: Fix the conditional for i40e_vc_validate_vqs_bitmaps

Brian Norris (2):
      mwifiex: drop most magic numbers from mwifiex_process_tdls_action_fra=
me()
      mwifiex: delete unused mwifiex_get_intf_num()

Bruce Allan (1):
      ice: update Unit Load Status bitmask to check after reset

Chao Yu (1):
      f2fs: fix to add swap extent correctly

Cheng Jian (1):
      sched/fair: Optimize select_idle_cpu

Christoph Hellwig (1):
      xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HANDLE

Christophe JAILLET (3):
      HID: alps: Fix an error handling path in 'alps_input_configured()'
      MIPS: VPE: Fix a double free and a memory leak in 'release_vpe()'
      drivers: net: xgene: Fix the order of the arguments of 'alloc_etherde=
v_mqs()'

Cong Wang (1):
      netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()

Corey Minyard (1):
      ipmi:ssif: Handle a possible NULL pointer reference

Dan Carpenter (1):
      ext4: potential crash on allocation error in ext4_alloc_flex_bg_array=
()

Daniel Kolesa (1):
      amdgpu: Prevent build errors regarding soft/hard-float FP ABI tags

Daniel Vetter (2):
      drm/amdgpu: Drop DRIVER_USE_AGP
      drm/radeon: Inline drm_get_pci_dev

David Rientjes (1):
      mm, thp: fix defrag setting if newline is not used

Dmitry Bogdanov (1):
      net: atlantic: fix out of range usage of active_vlans array

Dmitry Osipenko (1):
      nfc: pn544: Fix occasional HW initialization failure

Eugenio P=E9rez (1):
      vhost: Check docket sk_family instead of call getname

Florian Fainelli (2):
      net: dsa: b53: Ensure the default VID is untagged
      thermal: brcmstb_thermal: Do not use DT coefficients

Frank Sorenson (1):
      cifs: Fix mode output in debugging statements

Geert Uytterhoeven (1):
      ubifs: Fix ino_t format warnings in orphan_delete()

Greg Kroah-Hartman (1):
      Linux 5.4.24

Guangbin Huang (1):
      net: hns3: fix a copying IPv6 address error in hclge_fd_get_flow_tupl=
es()

Gustavo A. R. Silva (1):
      i2c: altera: Fix potential integer overflow

Haiyang Zhang (1):
      hv_netvsc: Fix unwanted wakeup in netvsc_attach()

Hans de Goede (1):
      HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboar=
d dock

Harald Freudenberger (1):
      s390/zcrypt: fix card and queue total counter wrap

Horatiu Vultur (1):
      net: mscc: fix in frame extraction

Isabel Zhang (1):
      drm/amd/display: Add initialitions for PLL2 clock source

Jan Kara (1):
      blktrace: Protect q->blk_trace with RCU

Janne Karhunen (1):
      ima: ima/lsm policy rule loading logic bug fixes

Jason Baron (1):
      net: sched: correct flower port blocking

Jeff Moyer (1):
      dax: pass NOWAIT flag to iomap_apply

Jens Axboe (2):
      io_uring: grab ->fs as part of async offload
      io_uring: fix 32-bit compatability with sendmsg/recvmsg

Jethro Beekman (1):
      net: fib_rules: Correctly set table field when table number exceeds 8=
 bits

Jim Mattson (2):
      kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
      kvm: nVMX: VMWRITE checks unsupported field before read-only field

Jiri Olsa (1):
      perf ui gtk: Add missing zalloc object

Johan Korsnes (2):
      HID: core: fix off-by-one memset in hid_report_raw_event()
      HID: core: increase HID report buffer size to 8KiB

Johannes Berg (2):
      mac80211: consider more elements in parsing CRC
      nl80211: fix potential leak in AP start

John Garry (1):
      perf/smmuv3: Use platform_get_irq_optional() for wired interrupt

John Hubbard (1):
      mm/gup: allow FOLL_FORCE for get_user_pages_fast()

Jozsef Kadlecsik (2):
      netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports
      netfilter: ipset: Fix forceadd evaluation path

Kan Liang (3):
      perf/x86/intel: Add Elkhart Lake support
      perf/x86/cstate: Add Tremont support
      perf/x86/msr: Add Tremont support

Keith Busch (1):
      nvme/pci: move cqe check after device shutdown

Krishnamraju Eraparaju (1):
      RDMA/siw: Remove unwanted WARN_ON in siw_cm_llp_data_ready()

Kuninori Morimoto (1):
      ARM: dts: sti: fixup sound frame-inversion for stihxxx-b2120.dtsi

Lijun Ou (1):
      RDMA/hns: Bugfix for posting a wqe with sge

Linus Walleij (1):
      thermal: db8500: Depromote debug print

Masahiro Yamada (5):
      kbuild: fix DT binding schema rule to detect command line changes
      kbuild: remove header compile test
      kbuild: move headers_check rule to usr/include/Makefile
      kbuild: remove unneeded variable, single-all
      kbuild: make single target builds even faster

Masami Hiramatsu (1):
      kprobes: Set unoptimized flag after unoptimizing code

Matteo Croce (1):
      netfilter: nf_flowtable: fix documentation

Michael Ellerman (1):
      selftests: Install settings files to fix TIMEOUT failures

Michal Kalderon (1):
      qede: Fix race between rdma destroy workqueue and link change event

Mika Westerberg (2):
      ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro
      ACPI: watchdog: Fix gas->access_width usage

Neeraj Upadhyay (1):
      rcu: Allow only one expedited GP to run concurrently with wakeups

Nigel Kirkland (1):
      nvme: prevent warning triggered by nvme_stop_keep_alive

Nikolay Aleksandrov (1):
      net: netlink: cap max groups which will be considered in netlink_bind=
()

Oliver Upton (1):
      KVM: VMX: check descriptor table exits on instruction emulation

Orson Zhai (1):
      Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"

Paolo Abeni (1):
      Revert "net: dev: introduce support for sch BYPASS for lockless qdisc"

Paul Moore (2):
      audit: fix error handling in audit_data_to_entry()
      audit: always check the netlink payload length in audit_receive_msg()

Pavel Belous (2):
      net: atlantic: fix use after free kasan warn
      net: atlantic: fix potential error handling

Peter Chen (1):
      usb: charger: assign specific number for enum value

Peter Zijlstra (Intel) (1):
      timers/nohz: Update NOHZ load in remote tick

Rafael J. Wysocki (1):
      cpufreq: Fix policy initialization for internal governor drivers

Rohit Maheshwari (1):
      net/tls: Fix to avoid gettig invalid tls record

Sameeh Jubran (3):
      net: ena: rss: do not allocate key when not supported
      net: ena: rss: fix failure to get indirection table
      net: ena: ethtool: use correct value for crc32 hash

Sameer Pujar (1):
      bus: tegra-aconnect: Remove PM_CLK dependency

Scott Wood (1):
      sched/core: Don't skip remote tick for idle CPUs

Sean Christopherson (3):
      KVM: Check for a bad hva before dropping into the ghc slow path
      KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path
      KVM: x86: Remove spurious clearing of async #PF MSR

Sean Paul (1):
      drm/msm: Set dma maximum segment size for mdss

Sergey Matyukevich (2):
      cfg80211: check wiphy driver existence for drvinfo report
      cfg80211: add missing policy for NL80211_ATTR_STATUS_CODE

Shay Bar (1):
      mac80211: fix wrong 160/80+80 MHz setting

Shirish S (1):
      amdgpu/gmc_v9: save/restore sdpif regs during S3

Steven Rostedt (VMware) (1):
      tracing: Disable trace_printk() on post poned tests

Sung Lee (1):
      drm/amd/display: Do not set optimized_require to false after plane di=
sable

Taehee Yoo (3):
      bonding: add missing netdev_update_lockdep_key()
      net: export netdev_next_lower_dev_rcu()
      bonding: fix lockdep warning in bond_get_stats()

Thierry Reding (1):
      soc/tegra: fuse: Fix build with Tegra194 configuration

Thomas Gleixner (2):
      lib/vdso: Make __arch_update_vdso_data() logic understandable
      lib/vdso: Update coarse timekeeper unconditionally

Tina Zhang (2):
      drm/i915/gvt: Fix orphan vgpu dmabuf_objs' lifetime
      drm/i915/gvt: Separate display reset from ALL_ENGINES reset

Tom Lendacky (1):
      KVM: SVM: Override default MMIO mask if memory encryption is enabled

Trond Myklebust (1):
      NFSv4: Fix races between open and dentry revalidation

Ursula Braun (2):
      net/smc: transfer fasync_list in case of fallback
      net/smc: no peer ID in CLC decline for SMCD

Uwe Kleine-K=F6nig (1):
      pwm: omap-dmtimer: put_device() after of_find_device_by_node()

Vasundhara Volam (2):
      bnxt_en: Improve device shutdown method.
      bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.

Vincent Guittot (1):
      sched/fair: Prevent unlimited runtime on throttled group

Vlastimil Babka (1):
      mm/debug.c: always print flags in dump_page()

Waiman Long (1):
      locking/lockdep: Fix lockdep_stats indentation problem

Wei Yang (1):
      mm/huge_memory.c: use head to check huge zero page

Willem de Bruijn (1):
      udp: rehash on disconnect

Wolfram Sang (2):
      macintosh: therm_windtunnel: fix regression when instantiating devices
      i2c: jz4780: silence log flood on txabrt

Xiaochen Shen (1):
      x86/resctrl: Check monitoring static key in the MBM overflow handler

Xin Long (2):
      sctp: move the format error check out of __sctp_sf_do_9_1_abort
      netfilter: nft_tunnel: no need to call htons() when dumping ports

Xiubo Li (1):
      ceph: do not execute direct write in parallel if O_APPEND is specified

Yixian Liu (1):
      RDMA/hns: Simplify the calculation and usage of wqe idx for post verbs

Yongqiang Sun (1):
      drm/amd/display: Limit minimum DPPCLK to 100MHz.

Yufeng Mo (1):
      net: hns3: add management table after IMP reset

dan.carpenter@oracle.com (1):
      HID: hiddev: Fix race in in hiddev_disconnect()


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5hRqAACgkQONu9yGCS
aT5ZHBAAwdAs6gOMusqyk1ar2ZLb/s2z+A9RHa667dM/mlZrEA/4C8G+mYBj1kKg
ZhHphYuPcysuXUoL2ZpkRlpCFIN0KNV7slEANDEve6J5JI+eAM+hN3KULd2n1R+K
BZdnzDhzTMtWg8MowzIPbhFOZt3gtQpn+zJDkygywqbuW0y0qpF8A5BT+3WlqJBe
qPDN1HpVuodth5eerkym0vWlrmfH5gRMQlGTQXx/cGQSgqIyXKsoYuDV45QBOrl1
xE55cMzvu0NAHEPbEJBrZNqeskFRoKAu4B2fyFpbJabR+enr8IbjevE8ptwS7yNc
dMu9tA2hec7kehRijfjv6jlezoJLNt6wxIiXZOfGxZS2imYYbLT6K1UD4a+4R4UD
3S9TTIHFghveDJsyulIxOWA8peuLH4tb5TU3vumDuKub9Vl+dzwmGgN8x+XnxhR5
bqRCwrMffLa/ydUa4lUU3yagDmVcRzj3EEzmcjz+9R54HxU29jjTXRlH2M6zvQiU
5GTwcIy5YY2osxOpRua6KrjQkgwKZ6h1P+tjA3ON+MSONeMoCxRYLEP2O8bJTYnp
y4pb0iknsmAUvESo04S3Qm/01tReyhc59O8N8eGMgexX5ZNAkTSLErncnkRs8kf2
Gnvx9aBW6JiHM18aA8ldjbaStmICzL+KVgB9Syhkec0yqgatb44=
=O5DY
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
