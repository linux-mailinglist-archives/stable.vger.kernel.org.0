Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5DE13098B
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 19:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgAES5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 13:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgAES5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 13:57:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE52207FD;
        Sun,  5 Jan 2020 18:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578250617;
        bh=ofg67pupATK4TJKq1dWgTms+R3Epyhp5KbpWcl3OTsw=;
        h=Date:From:To:Cc:Subject:From;
        b=HFHsPZmKWbpwgfv7yOV8KWpTDzQAEUL338drdxd5TwQgaEII+3QwPd+OhQ4OF0Ak0
         1uT3QszEsXG5qp+A5008hBbjjoMsAk5XVy9EJXMV3lOrk7CKExoKroSx/JUwj9vIp/
         R8U8iaVrHXwiqSZw/k/5jv/o5baC0UMfs3Gfs3xU=
Date:   Sun, 5 Jan 2020 19:56:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.8
Message-ID: <20200105185655.GA1685021@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.8 kernel.

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

 Documentation/devicetree/bindings/Makefile                  |    5=20
 Documentation/devicetree/writing-schema.rst                 |    6=20
 Makefile                                                    |    2=20
 arch/arm/boot/compressed/libfdt_env.h                       |    4=20
 arch/arm/mm/dma-mapping-nommu.c                             |    2=20
 arch/arm/mm/proc-v7-bugs.c                                  |    3=20
 arch/mips/include/asm/barrier.h                             |   13=20
 arch/mips/include/asm/futex.h                               |   15=20
 arch/powerpc/Makefile                                       |    4=20
 arch/powerpc/boot/libfdt_env.h                              |    2=20
 arch/powerpc/include/asm/fixmap.h                           |    7=20
 arch/powerpc/include/asm/spinlock.h                         |    4=20
 arch/powerpc/include/asm/uaccess.h                          |    9=20
 arch/powerpc/kernel/eeh_driver.c                            |    4=20
 arch/powerpc/kernel/security.c                              |   21 -
 arch/powerpc/kernel/time.c                                  |    2=20
 arch/powerpc/kernel/traps.c                                 |   15=20
 arch/powerpc/lib/string_32.S                                |    4=20
 arch/powerpc/lib/string_64.S                                |    6=20
 arch/powerpc/mm/book3s64/hash_utils.c                       |   10=20
 arch/powerpc/platforms/pseries/cmm.c                        |    5=20
 arch/powerpc/platforms/pseries/papr_scm.c                   |    4=20
 arch/powerpc/platforms/pseries/setup.c                      |    7=20
 arch/powerpc/tools/relocs_check.sh                          |    2=20
 arch/powerpc/tools/unrel_branch_check.sh                    |    4=20
 arch/s390/kernel/machine_kexec.c                            |    2=20
 arch/s390/kernel/perf_cpum_sf.c                             |   17=20
 arch/s390/kernel/unwind_bc.c                                |    5=20
 arch/s390/mm/maccess.c                                      |   12=20
 arch/um/drivers/virtio_uml.c                                |    8=20
 drivers/cdrom/cdrom.c                                       |   12=20
 drivers/clk/clk-gpio.c                                      |    2=20
 drivers/clk/pxa/clk-pxa27x.c                                |    1=20
 drivers/clk/qcom/clk-rcg2.c                                 |    2=20
 drivers/clk/qcom/clk-smd-rpm.c                              |    3=20
 drivers/clk/qcom/common.c                                   |    3=20
 drivers/clocksource/asm9260_timer.c                         |    4=20
 drivers/clocksource/timer-of.c                              |    2=20
 drivers/dma/fsl-qdma.c                                      |    3=20
 drivers/dma/xilinx/xilinx_dma.c                             |    1=20
 drivers/gpio/gpio-lynxpoint.c                               |    6=20
 drivers/gpio/gpio-mpc8xxx.c                                 |    6=20
 drivers/gpio/gpio-mxc.c                                     |   13=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                     |   37 +
 drivers/gpu/drm/drm_property.c                              |    2=20
 drivers/hid/hid-core.c                                      |    4=20
 drivers/hid/hid-ids.h                                       |    2=20
 drivers/hid/hid-logitech-hidpp.c                            |    3=20
 drivers/hid/hid-quirks.c                                    |    1=20
 drivers/hid/hid-rmi.c                                       |    3=20
 drivers/hid/i2c-hid/i2c-hid-core.c                          |    2=20
 drivers/hv/vmbus_drv.c                                      |    2=20
 drivers/i2c/busses/i2c-stm32f7.c                            |   19=20
 drivers/input/touchscreen/atmel_mxt_ts.c                    |    4=20
 drivers/input/touchscreen/ili210x.c                         |    7=20
 drivers/input/touchscreen/st1232.c                          |   22 -
 drivers/iommu/arm-smmu-v3.c                                 |    8=20
 drivers/iommu/rockchip-iommu.c                              |    7=20
 drivers/iommu/tegra-smmu.c                                  |   11=20
 drivers/irqchip/irq-bcm7038-l1.c                            |    4=20
 drivers/irqchip/irq-ingenic.c                               |   15=20
 drivers/leds/leds-an30259a.c                                |    7=20
 drivers/leds/leds-lm3692x.c                                 |   13=20
 drivers/leds/trigger/ledtrig-netdev.c                       |    5=20
 drivers/mailbox/imx-mailbox.c                               |   19=20
 drivers/md/bcache/btree.c                                   |    2=20
 drivers/md/md.c                                             |    1=20
 drivers/misc/habanalabs/memory.c                            |   30 +
 drivers/mmc/host/sdhci-esdhc.h                              |   14=20
 drivers/mmc/host/sdhci-of-esdhc.c                           |  232 +++++++=
+++--
 drivers/net/bonding/bond_main.c                             |    3=20
 drivers/net/dsa/bcm_sf2_cfp.c                               |    6=20
 drivers/net/dsa/sja1105/sja1105_main.c                      |    8=20
 drivers/net/dsa/sja1105/sja1105_static_config.c             |    7=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c                |   10=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   63 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                   |    1=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c           |   93 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h           |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c           |   38 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h           |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c               |    8=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                  |    1=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c          |    4=20
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                  |   21 -
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c         |    4=20
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h          |    1=20
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c              |   18=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |    2=20
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c            |    7=20
 drivers/net/ethernet/mellanox/mlxsw/reg.h                   |    1=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c              |    9=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c       |    3=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c         |   14=20
 drivers/net/gtp.c                                           |  111 +++--
 drivers/net/hamradio/6pack.c                                |    4=20
 drivers/net/hamradio/mkiss.c                                |    4=20
 drivers/net/hyperv/rndis_filter.c                           |    6=20
 drivers/net/phy/aquantia_main.c                             |    2=20
 drivers/net/phy/phylink.c                                   |    3=20
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c               |   24 -
 drivers/nvdimm/btt.c                                        |    8=20
 drivers/of/unittest.c                                       |    4=20
 drivers/pci/hotplug/rpaphp_core.c                           |   38 +
 drivers/platform/x86/Kconfig                                |    1=20
 drivers/platform/x86/intel_pmc_core.c                       |   17=20
 drivers/platform/x86/peaq-wmi.c                             |   66 ++-
 drivers/ptp/ptp_clock.c                                     |   31 -
 drivers/ptp/ptp_private.h                                   |    2=20
 drivers/s390/crypto/zcrypt_error.h                          |    2=20
 drivers/scsi/NCR5380.c                                      |    6=20
 drivers/scsi/atari_scsi.c                                   |    6=20
 drivers/scsi/csiostor/csio_lnode.c                          |   15=20
 drivers/scsi/hisi_sas/hisi_sas_main.c                       |    9=20
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                      |    1=20
 drivers/scsi/iscsi_tcp.c                                    |    8=20
 drivers/scsi/lpfc/lpfc_ct.c                                 |    6=20
 drivers/scsi/lpfc/lpfc_els.c                                |   42 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                            |   12=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                          |    4=20
 drivers/scsi/lpfc/lpfc_scsi.c                               |    5=20
 drivers/scsi/lpfc/lpfc_sli.c                                |   18=20
 drivers/scsi/mac_scsi.c                                     |    2=20
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                          |   15=20
 drivers/scsi/pm8001/pm80xx_hwi.c                            |    2=20
 drivers/scsi/scsi_debug.c                                   |    5=20
 drivers/scsi/scsi_trace.c                                   |   11=20
 drivers/scsi/sun3_scsi.c                                    |    4=20
 drivers/scsi/ufs/ufs-sysfs.c                                |   15=20
 drivers/scsi/ufs/ufshcd.c                                   |   35 +
 drivers/scsi/ufs/ufshcd.h                                   |    2=20
 drivers/scsi/zorro_esp.c                                    |   11=20
 drivers/target/iscsi/iscsi_target.c                         |   10=20
 drivers/target/iscsi/iscsi_target_auth.c                    |    2=20
 drivers/target/target_core_transport.c                      |   15=20
 drivers/vhost/vsock.c                                       |    4=20
 drivers/watchdog/imx7ulp_wdt.c                              |   16=20
 drivers/watchdog/watchdog_dev.c                             |   80 +---
 fs/cifs/cifsfs.c                                            |   13=20
 fs/cifs/cifsglob.h                                          |    5=20
 fs/cifs/connect.c                                           |   46 +-
 fs/cifs/file.c                                              |   74 ++-
 fs/ext4/inode.c                                             |   16=20
 fs/f2fs/f2fs.h                                              |   24 -
 fs/f2fs/file.c                                              |    1=20
 fs/f2fs/inode.c                                             |    6=20
 fs/f2fs/namei.c                                             |   15=20
 fs/f2fs/segment.c                                           |   21 -
 fs/hugetlbfs/inode.c                                        |   33 +
 fs/io_uring.c                                               |   10=20
 fs/iomap/direct-io.c                                        |    4=20
 fs/jbd2/commit.c                                            |    4=20
 fs/ocfs2/acl.c                                              |    4=20
 fs/quota/dquot.c                                            |   29 -
 fs/userfaultfd.c                                            |   18=20
 fs/xfs/xfs_log.c                                            |    2=20
 include/linux/dma-direct.h                                  |   12=20
 include/linux/dma-mapping.h                                 |    8=20
 include/linux/hrtimer.h                                     |   14=20
 include/linux/libfdt_env.h                                  |    3=20
 include/linux/posix-clock.h                                 |   19=20
 include/linux/quota.h                                       |    2=20
 include/linux/rculist_nulls.h                               |   37 +
 include/linux/skbuff.h                                      |    6=20
 include/linux/thread_info.h                                 |    2=20
 include/net/dst.h                                           |   13=20
 include/net/dst_ops.h                                       |    3=20
 include/net/inet_hashtables.h                               |   12=20
 include/net/sch_generic.h                                   |    5=20
 include/net/sock.h                                          |    5=20
 include/scsi/iscsi_proto.h                                  |    1=20
 kernel/dma/coherent.c                                       |   16=20
 kernel/dma/debug.c                                          |    1=20
 kernel/sysctl.c                                             |    2=20
 kernel/time/hrtimer.c                                       |   11=20
 kernel/time/posix-clock.c                                   |   31 -
 net/bridge/br_netfilter_hooks.c                             |    3=20
 net/bridge/br_nf_core.c                                     |    3=20
 net/bridge/netfilter/ebtables.c                             |   33 -
 net/decnet/dn_route.c                                       |    6=20
 net/ipv4/icmp.c                                             |   11=20
 net/ipv4/inet_connection_sock.c                             |    2=20
 net/ipv4/inet_diag.c                                        |    3=20
 net/ipv4/inet_hashtables.c                                  |   16=20
 net/ipv4/inetpeer.c                                         |   12=20
 net/ipv4/ip_tunnel.c                                        |    2=20
 net/ipv4/ip_vti.c                                           |    2=20
 net/ipv4/route.c                                            |    9=20
 net/ipv4/tcp_ipv4.c                                         |    7=20
 net/ipv4/tcp_output.c                                       |   11=20
 net/ipv4/udp.c                                              |    2=20
 net/ipv4/xfrm4_policy.c                                     |    5=20
 net/ipv6/addrconf.c                                         |    8=20
 net/ipv6/inet6_connection_sock.c                            |    2=20
 net/ipv6/ip6_gre.c                                          |    2=20
 net/ipv6/ip6_tunnel.c                                       |    4=20
 net/ipv6/ip6_vti.c                                          |    2=20
 net/ipv6/route.c                                            |   22 -
 net/ipv6/sit.c                                              |    2=20
 net/ipv6/xfrm6_policy.c                                     |    5=20
 net/netfilter/ipvs/ip_vs_xmit.c                             |    2=20
 net/sched/act_mirred.c                                      |   22 -
 net/sched/cls_api.c                                         |   31 -
 net/sched/cls_flower.c                                      |   12=20
 net/sched/sch_fq.c                                          |   17=20
 net/sctp/stream.c                                           |   30 -
 net/sctp/transport.c                                        |    2=20
 net/smc/af_smc.c                                            |   14=20
 scripts/dtc/Makefile                                        |    4=20
 scripts/kallsyms.c                                          |    2=20
 security/apparmor/label.c                                   |   12=20
 security/tomoyo/realpath.c                                  |   32 -
 tools/perf/builtin-diff.c                                   |    4=20
 tools/perf/builtin-script.c                                 |    2=20
 tools/perf/util/perf_regs.h                                 |    2=20
 tools/power/x86/intel-speed-select/isst-config.c            |    9=20
 tools/power/x86/intel-speed-select/isst-core.c              |    8=20
 tools/power/x86/intel-speed-select/isst-display.c           |    3=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c  |    2=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c  |    4=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c      |    2=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c      |    4=20
 tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c |    4=20
 tools/testing/selftests/vm/config                           |    1=20
 224 files changed, 1811 insertions(+), 866 deletions(-)

Aaron Ma (1):
      HID: i2c-hid: fix no irq after reset on raydium 3118

Adrian Hunter (1):
      perf script: Fix brstackinsn for AUXTRACE

Alain Volmat (1):
      i2c: stm32f7: fix & reorder remove & probe error handling

Amit Cohen (1):
      mlxsw: spectrum_router: Skip loopback RIFs during MAC validation

Anatol Pomazau (1):
      scsi: iscsi: Don't send data to unbound connection

Anders Kaseorg (1):
      Revert "iwlwifi: assign directly to iwl_trans->cfg in QuZ detection"

Anders Roxell (1):
      selftests: vm: add fragment CONFIG_TEST_VMALLOC

Andrew Donnellan (1):
      powerpc: Fix __clear_user() with KUAP enabled

Andrew Duggan (1):
      HID: rmi: Check that the RMI_STARTED bit is set before unregistering =
the RMI transport device

Andy Shevchenko (1):
      gpio: lynxpoint: Setup correct IRQ handlers

Aneesh Kumar K.V (3):
      powerpc/pseries: Don't fail hash page table insert for bolted mapping
      powerpc/book3s64/hash: Add cond_resched to avoid soft lockup warning
      powerpc/book3s/mm: Update Oops message to print the correct translati=
on in use

Anson Huang (1):
      gpio: mxc: Only get the second IRQ when there is more than one IRQ

Anthony Steinhauser (1):
      powerpc/security/book3s64: Report L1TF status in sysfs

Antonio Messina (1):
      udp: fix integer overflow while computing available space in sk_rcvbuf

Arnaldo Carvalho de Melo (2):
      perf diff: Use llabs() with 64-bit values
      perf regs: Make perf_reg_name() return "unknown" instead of NULL

Bart Van Assche (3):
      scsi: tracing: Fix handling of TRANSFER LENGTH =3D=3D 0 for READ(6) a=
nd WRITE(6)
      scsi: target: core: Release SPC-2 reservations when closing a session
      scsi: target: iscsi: Wait for all commands to finish before freeing a=
 session

Bean Huo (1):
      scsi: ufs: fix potential bug which ends in system hang

Bla=C5=BE Hrastnik (1):
      HID: Improve Windows Precision Touchpad detection.

Brian Foster (1):
      xfs: fix mount failure crash on invalid iclog memory access

Cambda Zhu (1):
      tcp: Fix highest_sack and highest_sack_seq

Can Guo (1):
      scsi: ufs: Fix up auto hibern8 enablement

Chao Yu (2):
      f2fs: fix to update time in lazytime mode
      f2fs: fix to update dir's i_pino during cross_rename

Christophe Leroy (1):
      powerpc/fixmap: Use __fix_to_virt() instead of fix_to_virt()

Chuhong Yuan (2):
      leds: an30259a: add a check for devm_regmap_init_i2c
      clocksource/drivers/asm9260: Add a check for of_clk_get

Colin Ian King (1):
      apparmor: fix unsigned len comparison with less than zero

Coly Li (1):
      bcache: at least try to shrink 1 node in bch_mca_scan()

Dan Carpenter (1):
      scsi: csiostor: Don't enable IRQs too early

Daniel Baluta (2):
      mailbox: imx: Clear the right interrupts at shutdown
      mailbox: imx: Fix Tx doorbell shutdown path

Daniel Vetter (1):
      drm: limit to INT_MAX in create_blob ioctl

David Disseldorp (1):
      scsi: target: compare full CHAP_A Algorithm strings

David Hildenbrand (1):
      powerpc/pseries/cmm: Implement release() function for sysfs device

Davide Caratti (1):
      net/sched: add delete_empty() to filters and use it in cls_flower

Diego Elio Petten=C3=B2 (1):
      cdrom: respect device capabilities during opening action

Ding Xiang (1):
      ocfs2: fix passing zero to 'PTR_ERR' warning

Dmitry Torokhov (3):
      platform/x86: peaq-wmi: switch to using polled mode of input devices
      Input: st1232 - do not reset the chip too early
      Input: ili210x - handle errors from input_mt_init_slots()

Doug Berger (1):
      ARM: 8937/1: spectre-v2: remove Brahma-B53 from hardening

Erhard Furtner (1):
      of: unittest: fix memory leak in attach_node_and_children

Eric Dumazet (10):
      dma-debug: add a schedule point in debug_dma_dump_mappings()
      6pack,mkiss: fix possible deadlock
      netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
      inetpeer: fix data-race in inet_putpeer / inet_putpeer
      net: add a READ_ONCE() in skb_peek_tail()
      net: icmp: fix data-race in cmp_global_allow()
      hrtimer: Annotate lockless access to timer->state
      net_sched: sch_fq: properly set sk->sk_pacing_status
      tcp: do not send empty skb from tcp_write_xmit()
      tcp/dccp: fix possible race __inet_lookup_established()

Evan Green (1):
      Input: atmel_mxt_ts - disable IRQ across suspend

Ezequiel Garcia (1):
      iommu: rockchip: Free domain on .domain_free

Fabio Estevam (1):
      watchdog: imx7ulp: Fix reboot hang

Finn Thain (2):
      scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE
      scsi: NCR5380: Add disconnect_mask module parameter

Florian Fainelli (2):
      irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary
      net: dsa: bcm_sf2: Fix IP fragment location and behavior

Florian Westphal (1):
      netfilter: ebtables: compat: reject all padding in matches/watchers

Gayatri Kammela (2):
      platform/x86: intel_pmc_core: Fix the SoC naming inconsistency
      platform/x86: intel_pmc_core: Add Comet Lake (CML) platform support t=
o intel_pmc_core driver

Geert Uytterhoeven (1):
      clocksource/drivers/timer-of: Use unique device name instead of timer

Greg Kroah-Hartman (4):
      Revert "MIPS: futex: Restore \n after sync instructions"
      Revert "MIPS: futex: Emit Loongson3 sync workarounds within asm"
      Revert "powerpc/vcpu: Assume dedicated processors as non-preempt"
      Linux 5.4.8

Guido G=C3=BCnther (1):
      leds: lm3692x: Handle failure to probe the regulator

Gustavo L. F. Walbon (1):
      powerpc/security: Fix wrong message when RFI Flush is disable

Haiyang Zhang (1):
      hv_netvsc: Fix tx_table init in rndis_set_subchannel()

Hangbin Liu (9):
      net: add bool confirm_neigh parameter for dst_ops.update_pmtu
      ip6_gre: do not confirm neighbor when do pmtu update
      gtp: do not confirm neighbor when do pmtu update
      net/dst: add new function skb_dst_update_pmtu_no_confirm
      tunnel: do not confirm neighbor when do pmtu update
      vti: do not confirm neighbor when do pmtu update
      sit: do not confirm neighbor when do pmtu update
      net/dst: do not confirm neighbor for vxlan and geneve pmtu update
      ipv6/addrconf: only check invalid header values when NETLINK_F_STRICT=
_CHK is set

Hans de Goede (1):
      HID: logitech-hidpp: Silence intermittent get_battery_capacity errors

Harald Freudenberger (1):
      s390/zcrypt: handle new reply code FILTERED_BY_HYPERVISOR

Ido Schimmel (1):
      mlxsw: spectrum: Use dedicated policer for VRRP packets

James Smart (9):
      scsi: lpfc: Fix spinlock_irq issues in lpfc_els_flush_cmd()
      scsi: lpfc: Fix discovery failures when target device connectivity bo=
unces
      scsi: lpfc: Fix locking on mailbox command completion
      scsi: lpfc: Fix list corruption in lpfc_sli_get_iocbq
      scsi: lpfc: Fix hardlockup in lpfc_abort_handler
      scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices
      scsi: lpfc: Fix unexpected error messages during RSCN handling
      scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow
      scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer derefere=
nces

Jan Kara (1):
      jbd2: Fix statistics for the number of logged blocks

Jan Stancek (2):
      iomap: fix return value of iomap_dio_bio_actor on 32bit systems
      mm/hugetlbfs: fix for_each_hstate() loop in init_hugetlbfs_fs()

Jason Gunthorpe (1):
      drm/amdgpu: Call find_vma under mmap_sem

Jean-Philippe Brucker (1):
      iommu/arm-smmu-v3: Don't display an error when IRQ lines are missing

Jeffrey Hugo (2):
      clk: qcom: smd: Add missing pnoc clock
      clk: qcom: Allow constant ratio freq tables for rcg

Jens Axboe (1):
      io_uring: io_allocate_scq_urings() should return a sane state

Jinke Fan (1):
      HID: quirks: Add quirk for HP MSU1465 PIXART OEM mouse

Johannes Berg (1):
      um: virtio: Keep reading on -EAGAIN

Johannes Weiner (1):
      kernel: sysctl: make drop_caches write-only

Jonathan Lemon (1):
      bnxt: apply computed clamp value for coalece parameter

Julia Cartwright (1):
      watchdog: prevent deferral of watchdogd wakeup on RT

Kars de Jong (1):
      scsi: zorro_esp: Limit DMA transfers to 65536 bytes (except on Fastla=
ne)

Kees Cook (2):
      dma-mapping: Add vmap checks to dma_map_single()
      uaccess: disallow > INT_MAX copy sizes

Kevin Hao (1):
      watchdog: Fix the race between the release of watchdog_core_data and =
cdev

Konstantin Khlebnikov (1):
      fs/quota: handle overflows of sysctl fs.quota.* and report as unsigne=
d long

Krzysztof Kozlowski (1):
      dmaengine: fsl-qdma: Handle invalid qdma-queue0 IRQ

Luo Jiaxing (1):
      scsi: hisi_sas: Delete the debugfs folder of hisi_sas when the probe =
fails

Madalin Bucur (1):
      net: phy: aquantia: add suspend / resume ops for AQR105

Mahesh Bandewar (1):
      bonding: fix active-backup transition after link failure

Marcelo Ricardo Leitner (1):
      sctp: fix err handling of stream initialization

Martin Blumenstingl (1):
      net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs

Martin Schiller (1):
      leds: trigger: netdev: fix handling on interface rename

Masahiro Yamada (2):
      scripts/kallsyms: fix definitely-lost memory leak
      libfdt: define INT32_MAX and UINT32_MAX in libfdt_env.h

Matthew Bobrowski (2):
      ext4: update direct I/O read lock pattern for IOCB_NOWAIT
      ext4: iomap that extends beyond EOF should be marked dirty

Maurizio Lombardi (1):
      scsi: scsi_debug: num_tgts must be >=3D 0

Michael Chan (2):
      bnxt_en: Fix MSIX request logic for RDMA driver.
      bnxt_en: Free context memory in the open path if firmware has been re=
set.

Michael Ellerman (4):
      powerpc/pseries: Mark accumulate_stolen_time() as notrace
      selftests/powerpc: Fixup clobbers for TM tests
      powerpc/tools: Don't quote $objdump in scripts
      selftests/powerpc: Skip tm-signal-sigreturn-nt if TM not available

Michael Hennerich (1):
      clk: clk-gpio: propagate rate change to parent

Michael Kelley (1):
      Drivers: hv: vmbus: Fix crash handler reset of Hyper-V synic

Mike Kravetz (1):
      mm/hugetlbfs: fix error handling when setting up mounts

Mike Rapoport (1):
      userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK

Nathan Chancellor (1):
      powerpc: Don't add -mabi=3D flags when building with Clang

Netanel Belgazal (1):
      net: ena: fix napi handler misbehavior when the napi budget is zero

Nicholas Graumann (1):
      dmaengine: xilinx_dma: Clear desc_pendingcount in xilinx_dma_reset

Nicolas Saenz Julienne (1):
      dma-direct: check for overflows on 32 bit DMA addresses

Omer Shpigelman (1):
      habanalabs: skip VA block list update in reset flow

Paul Cercueil (1):
      irqchip: ingenic: Error out if IRQ domain creation failed

Paulo Alcantara (SUSE) (1):
      cifs: Fix use-after-free bug in cifs_reconnect()

Pavel Modilaynen (1):
      dtc: Use pkg-config to locate libyaml

Qian Cai (1):
      libnvdimm/btt: fix variable 'rc' set but not used

Rahul Lakkireddy (1):
      cxgb4/cxgb4vf: fix flow control display for auto negotiation

Rob Herring (1):
      dt-bindings: Improve validation build error handling

Robert Jarzmik (1):
      clk: pxa: fix one of the pxa RTC clocks

Ronnie Sahlberg (1):
      cifs: move cifsFileInfo_put logic into a work-queue

Russell King (3):
      gpio/mpc8xxx: fix qoriq GPIO reading
      net: marvell: mvpp2: phylink requires the link interrupt
      net: phylink: fix interface passed to mac_link_up

Sahitya Tummala (1):
      f2fs: Fix deadlock in f2fs_gc() context during atomic files handling

Sam Bobroff (1):
      powerpc/eeh: differentiate duplicate detection message

Shmulik Ladkani (1):
      net/sched: act_mirred: Pull mac prior redir to non mac_header_xmit de=
vice

Sreekanth Reddy (2):
      scsi: mpt3sas: Fix clear pending bit in ioctl status
      scsi: mpt3sas: Reject NVMe Encap cmnds to unsupported HBA

Srinivas Pandruvada (2):
      tools/power/x86/intel-speed-select: Remove warning for unused result
      tools/power/x86/intel-speed-select: Ignore missing config level

Stefano Garzarella (1):
      vhost/vsock: accept only packets with the right dst_cid

Subhash Jadavani (1):
      scsi: ufs: Fix error handing during hibern8 enter

Taehee Yoo (4):
      gtp: fix wrong condition in gtp_genl_dump_pdp()
      gtp: avoid zero size hashtable
      gtp: fix an use-after-free in ipv4_pdp_find()
      gtp: do not allow adding duplicate tid and ms_addr pdp context

Tetsuo Handa (1):
      tomoyo: Don't use nifty names on sockets.

Thierry Reding (1):
      iommu/tegra-smmu: Fix page tables in > 4 GiB memory

Thomas Richter (1):
      s390/cpum_sf: Check for SDBT and SDB consistency

Tyrel Datwyler (4):
      PCI: rpaphp: Fix up pointer to first drc-info entry
      PCI: rpaphp: Don't rely on firmware feature to imply drc-info support
      PCI: rpaphp: Annotate and correctly byte swap DRC properties
      PCI: rpaphp: Correctly match ibm, my-drc-index to drc-name when using=
 drc-info

Ursula Braun (1):
      net/smc: add fallback check to connect()

Vaibhav Jain (1):
      powerpc/papr_scm: Fix an off-by-one check in papr_scm_meta_{get, set}

Vasily Gorbik (2):
      s390/unwind: filter out unreliable bogus %r14
      s390: disable preemption when switching to nodat stack with CALL_ON_S=
TACK

Vasundhara Volam (5):
      bnxt_en: Return error if FW returns more data than dump length
      bnxt_en: Fix bp->fw_health allocation and free logic.
      bnxt_en: Remove unnecessary NULL checks for fw_health
      bnxt_en: Fix the logic that creates the health reporters.
      bnxt_en: Add missing devlink health reporters for VFs.

Vladimir Murzin (1):
      dma-mapping: fix handling of dma-ranges for reserved memory (again)

Vladimir Oltean (2):
      gpio: mpc8xxx: Don't overwrite default irq_set_type callback
      net: dsa: sja1105: Reconcile the meaning of TPID and TPID2 for E/T an=
d P/Q/R/S

Vladis Dronov (1):
      ptp: fix the race between the release of ptp_clock and cdev

Vladyslav Tarasiuk (1):
      net/mlxfw: Fix out-of-memory error in mfa2 flash burning

Xiang Chen (1):
      scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()

Yangbo Lu (2):
      mmc: sdhci-of-esdhc: fix up erratum A-008171 workaround
      mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround

Yufen Yu (1):
      md: make sure desc_nr less than MD_SB_DISKS

peter chang (1):
      scsi: pm80xx: Fix for SATA device discovery


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4SMXcACgkQONu9yGCS
aT5dohAAhKFalDifCIZoxxTPTQhN27dN+cxglwRDMzJPfDzE/SCRVa9SG0miuDPy
6jEi5DWZi/zqBzpxpsqaMMYem72Q7adOsjT0mGZnK757PNZ1hegA0kxepOa/MRa2
EuG8fI1pLBbOZTiFAk7tmEzF6JCCLxR2DonGkWILWKg69eaKJEEupzIR53qy0FiS
KY/U/tKbsskZW1ngQfRnNCQe9Cn2lIDNOdKPq68IzfxP+w9YaV8iC40KFWgBYv4U
Zr2RAem7Otx2PhisSnQrCDVd4ZaSHdg6fvCEQ981Gii5b24Wt3150BLlpL5mvNZb
btJAFE6xGF7bW1UAd9ZvdyYGTAWwrfCzePh+9EZp7d3kOGTIx0lXWnsmXbshhWzh
T0VMHMXAh9iK7y32aYe8Jsr2A9V9zPEDEKWhgUskGATDFcEUtypEp679M9jUdtJX
ekkuP+NWQHVejhjujheaE7r6Z6iGvjNY67sgEIuPs/8FEEUOCggJsoIeQwyiQipI
QY/6Ii5dnkK1QYze2RBgjsGKcwQI2LL9aWxC2gMs9pJ4HESNzwoy+VBntiU4Z34W
14N4TkoMIbbCvC9QzCStkPc/Ef1ciIbInBrDxwgttx0KWU1frXFq5I1gKeNFyVa8
6yv4HNOUOsjRut8RvIk+TwbCUOSMYNbi8F9VlT22VVdypVsZi0o=
=UmTn
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
