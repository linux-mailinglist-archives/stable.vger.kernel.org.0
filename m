Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEB5130985
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 19:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgAES4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 13:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgAES4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 13:56:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F67D207FD;
        Sun,  5 Jan 2020 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578250592;
        bh=7a2CEwVvhs+OH4RPV4OxJ+JEHOGQJ3XDU+66sowxuKA=;
        h=Date:From:To:Cc:Subject:From;
        b=IV+e3RJQw4a6QGtXNV3SdGuogRguUkQuUxkz+x4Q+8nBKEWBP41fPUMux+So04Qwq
         36hzF6tJhtK/kcm5f4V0uyaanonicw//KtE72ehvsMfxdmZtct2Se5O2k71CRhxfts
         /CpL/5OZIUSSys1/w3F6Y5SZ8jhO5pazjc0eKK88=
Date:   Sun, 5 Jan 2020 19:56:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.93
Message-ID: <20200105185629.GA1684930@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.93 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm/boot/compressed/libfdt_env.h               |    4=20
 arch/arm/mm/proc-v7-bugs.c                          |    3=20
 arch/powerpc/Makefile                               |    4=20
 arch/powerpc/boot/libfdt_env.h                      |    2=20
 arch/powerpc/include/asm/spinlock.h                 |    4=20
 arch/powerpc/kernel/security.c                      |   21 +--
 arch/powerpc/kernel/time.c                          |    2=20
 arch/powerpc/mm/hash_utils_64.c                     |   10 +
 arch/powerpc/platforms/pseries/cmm.c                |    5=20
 arch/powerpc/platforms/pseries/setup.c              |    7 -
 arch/powerpc/tools/relocs_check.sh                  |    2=20
 arch/powerpc/tools/unrel_branch_check.sh            |    4=20
 arch/s390/kernel/perf_cpum_sf.c                     |   17 ++-
 arch/x86/kernel/cpu/mcheck/mce.c                    |    2=20
 drivers/cdrom/cdrom.c                               |   12 +-
 drivers/clk/clk-gpio.c                              |    2=20
 drivers/clk/pxa/clk-pxa27x.c                        |    1=20
 drivers/clk/qcom/clk-rcg2.c                         |    2=20
 drivers/clk/qcom/common.c                           |    3=20
 drivers/clocksource/asm9260_timer.c                 |    4=20
 drivers/clocksource/timer-of.c                      |    2=20
 drivers/dma/xilinx/xilinx_dma.c                     |    1=20
 drivers/gpio/gpio-mpc8xxx.c                         |    3=20
 drivers/hid/hid-core.c                              |    4=20
 drivers/hid/hid-ids.h                               |    1=20
 drivers/hid/hid-logitech-hidpp.c                    |    3=20
 drivers/hid/hid-quirks.c                            |    1=20
 drivers/hid/hid-rmi.c                               |    3=20
 drivers/input/touchscreen/atmel_mxt_ts.c            |    4=20
 drivers/iommu/rockchip-iommu.c                      |    7 -
 drivers/iommu/tegra-smmu.c                          |   11 +
 drivers/irqchip/irq-bcm7038-l1.c                    |    4=20
 drivers/irqchip/irq-ingenic.c                       |   15 +-
 drivers/leds/leds-lm3692x.c                         |   13 +-
 drivers/mailbox/imx-mailbox.c                       |    4=20
 drivers/md/bcache/btree.c                           |    2=20
 drivers/net/bonding/bond_main.c                     |    3=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c        |   10 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     |    2=20
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c    |    7 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c |   14 +-
 drivers/net/gtp.c                                   |  111 +++++++++++----=
-----
 drivers/net/hamradio/6pack.c                        |    4=20
 drivers/net/hamradio/mkiss.c                        |    4=20
 drivers/nvdimm/btt.c                                |    8 -
 drivers/pci/hotplug/rpaphp_core.c                   |   38 +++---
 drivers/pinctrl/intel/pinctrl-baytrail.c            |   81 +++++++-------
 drivers/ptp/ptp_clock.c                             |   31 ++---
 drivers/ptp/ptp_private.h                           |    2=20
 drivers/s390/crypto/zcrypt_error.h                  |    2=20
 drivers/scsi/NCR5380.c                              |    6 -
 drivers/scsi/atari_scsi.c                           |    6 -
 drivers/scsi/csiostor/csio_lnode.c                  |   15 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c               |    8 +
 drivers/scsi/iscsi_tcp.c                            |    8 +
 drivers/scsi/lpfc/lpfc_els.c                        |    2=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                    |    7 +
 drivers/scsi/lpfc/lpfc_nportdisc.c                  |    4=20
 drivers/scsi/lpfc/lpfc_sli.c                        |   15 ++
 drivers/scsi/mac_scsi.c                             |    2=20
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                  |    3=20
 drivers/scsi/pm8001/pm80xx_hwi.c                    |    2=20
 drivers/scsi/scsi_debug.c                           |    5=20
 drivers/scsi/scsi_trace.c                           |   11 +
 drivers/scsi/sun3_scsi.c                            |    4=20
 drivers/scsi/ufs/ufshcd.c                           |   21 ++-
 drivers/spi/spi-fsl-spi.c                           |    7 -
 drivers/target/iscsi/iscsi_target.c                 |   10 +
 drivers/target/iscsi/iscsi_target_auth.c            |    2=20
 drivers/tty/serial/atmel_serial.c                   |   43 +++----
 drivers/vhost/vsock.c                               |    4=20
 drivers/watchdog/watchdog_dev.c                     |   70 +++++-------
 fs/ext4/inode.c                                     |   16 ++
 fs/f2fs/f2fs.h                                      |   23 ++--
 fs/f2fs/inode.c                                     |    6 -
 fs/f2fs/namei.c                                     |   15 ++
 fs/jbd2/commit.c                                    |    4=20
 fs/ocfs2/acl.c                                      |    4=20
 fs/quota/dquot.c                                    |   29 +++--
 fs/readdir.c                                        |   40 +++++++
 fs/userfaultfd.c                                    |   18 +--
 include/linux/hrtimer.h                             |   14 +-
 include/linux/libfdt_env.h                          |    3=20
 include/linux/posix-clock.h                         |   19 +--
 include/linux/quota.h                               |    2=20
 include/linux/rculist_nulls.h                       |   37 ++++++
 include/linux/skbuff.h                              |    6 -
 include/net/dst.h                                   |   13 +-
 include/net/dst_ops.h                               |    3=20
 include/net/inet_hashtables.h                       |   12 +-
 include/net/sock.h                                  |    5=20
 include/scsi/iscsi_proto.h                          |    1=20
 kernel/dma/debug.c                                  |    1=20
 kernel/sysctl.c                                     |    2=20
 kernel/time/hrtimer.c                               |   11 +
 kernel/time/posix-clock.c                           |   31 ++---
 net/bridge/br_netfilter_hooks.c                     |    3=20
 net/bridge/br_nf_core.c                             |    3=20
 net/bridge/netfilter/ebtables.c                     |   33 ++---
 net/core/sysctl_net_core.c                          |    2=20
 net/decnet/dn_route.c                               |    6 -
 net/ipv4/icmp.c                                     |   11 +
 net/ipv4/inet_connection_sock.c                     |    2=20
 net/ipv4/inet_diag.c                                |    3=20
 net/ipv4/inet_hashtables.c                          |   19 +--
 net/ipv4/inetpeer.c                                 |   12 +-
 net/ipv4/ip_tunnel.c                                |    2=20
 net/ipv4/ip_vti.c                                   |    2=20
 net/ipv4/route.c                                    |    9 +
 net/ipv4/tcp_ipv4.c                                 |    7 -
 net/ipv4/tcp_output.c                               |   11 +
 net/ipv4/udp.c                                      |    2=20
 net/ipv4/xfrm4_policy.c                             |    5=20
 net/ipv6/inet6_connection_sock.c                    |    2=20
 net/ipv6/inet6_hashtables.c                         |    3=20
 net/ipv6/ip6_gre.c                                  |    2=20
 net/ipv6/ip6_tunnel.c                               |    4=20
 net/ipv6/ip6_vti.c                                  |    2=20
 net/ipv6/route.c                                    |   22 ++-
 net/ipv6/sit.c                                      |    2=20
 net/ipv6/xfrm6_policy.c                             |    5=20
 net/netfilter/ipvs/ip_vs_xmit.c                     |    2=20
 net/netfilter/nf_queue.c                            |    2=20
 net/sctp/transport.c                                |    2=20
 scripts/kallsyms.c                                  |    2=20
 security/apparmor/label.c                           |   12 +-
 sound/pci/hda/hda_controller.c                      |    2=20
 tools/perf/builtin-script.c                         |    2=20
 tools/perf/util/perf_regs.h                         |    2=20
 tools/perf/util/strbuf.c                            |    1=20
 131 files changed, 836 insertions(+), 443 deletions(-)

Adrian Hunter (1):
      perf script: Fix brstackinsn for AUXTRACE

Alexander Lobakin (1):
      net, sysctl: Fix compiler warning when only cBPF is present

Anatol Pomazau (1):
      scsi: iscsi: Don't send data to unbound connection

Andrew Duggan (1):
      HID: rmi: Check that the RMI_STARTED bit is set before unregistering =
the RMI transport device

Aneesh Kumar K.V (2):
      powerpc/pseries: Don't fail hash page table insert for bolted mapping
      powerpc/book3s64/hash: Add cond_resched to avoid soft lockup warning

Anthony Steinhauser (1):
      powerpc/security/book3s64: Report L1TF status in sysfs

Antonio Messina (1):
      udp: fix integer overflow while computing available space in sk_rcvbuf

Arnaldo Carvalho de Melo (1):
      perf regs: Make perf_reg_name() return "unknown" instead of NULL

Bart Van Assche (2):
      scsi: tracing: Fix handling of TRANSFER LENGTH =3D=3D 0 for READ(6) a=
nd WRITE(6)
      scsi: target: iscsi: Wait for all commands to finish before freeing a=
 session

Bean Huo (1):
      scsi: ufs: fix potential bug which ends in system hang

Bla=C5=BE Hrastnik (1):
      HID: Improve Windows Precision Touchpad detection.

Cambda Zhu (1):
      tcp: Fix highest_sack and highest_sack_seq

Chao Yu (2):
      f2fs: fix to update time in lazytime mode
      f2fs: fix to update dir's i_pino during cross_rename

Christophe Leroy (2):
      spi: fsl: don't map irq during probe
      spi: fsl: use platform_get_irq() instead of of_irq_to_resource()

Chuhong Yuan (1):
      clocksource/drivers/asm9260: Add a check for of_clk_get

Colin Ian King (1):
      apparmor: fix unsigned len comparison with less than zero

Coly Li (1):
      bcache: at least try to shrink 1 node in bch_mca_scan()

Dan Carpenter (1):
      scsi: csiostor: Don't enable IRQs too early

Daniel Baluta (1):
      mailbox: imx: Fix Tx doorbell shutdown path

David Disseldorp (1):
      scsi: target: compare full CHAP_A Algorithm strings

David Engraf (1):
      tty/serial: atmel: fix out of range clock divider handling

David Hildenbrand (1):
      powerpc/pseries/cmm: Implement release() function for sysfs device

Diego Elio Petten=C3=B2 (1):
      cdrom: respect device capabilities during opening action

Ding Xiang (1):
      ocfs2: fix passing zero to 'PTR_ERR' warning

Doug Berger (1):
      ARM: 8937/1: spectre-v2: remove Brahma-B53 from hardening

Eric Dumazet (9):
      dma-debug: add a schedule point in debug_dma_dump_mappings()
      6pack,mkiss: fix possible deadlock
      netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
      inetpeer: fix data-race in inet_putpeer / inet_putpeer
      net: add a READ_ONCE() in skb_peek_tail()
      net: icmp: fix data-race in cmp_global_allow()
      hrtimer: Annotate lockless access to timer->state
      tcp/dccp: fix possible race __inet_lookup_established()
      tcp: do not send empty skb from tcp_write_xmit()

Evan Green (1):
      Input: atmel_mxt_ts - disable IRQ across suspend

Ezequiel Garcia (1):
      iommu: rockchip: Free domain on .domain_free

Finn Thain (2):
      scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE
      scsi: NCR5380: Add disconnect_mask module parameter

Florian Fainelli (1):
      irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary

Florian Westphal (1):
      netfilter: ebtables: compat: reject all padding in matches/watchers

Geert Uytterhoeven (1):
      clocksource/drivers/timer-of: Use unique device name instead of timer

Greg Kroah-Hartman (2):
      Revert "powerpc/vcpu: Assume dedicated processors as non-preempt"
      Linux 4.19.93

Guido G=C3=BCnther (1):
      leds: lm3692x: Handle failure to probe the regulator

Gustavo L. F. Walbon (1):
      powerpc/security: Fix wrong message when RFI Flush is disable

Hangbin Liu (8):
      net: add bool confirm_neigh parameter for dst_ops.update_pmtu
      ip6_gre: do not confirm neighbor when do pmtu update
      gtp: do not confirm neighbor when do pmtu update
      net/dst: add new function skb_dst_update_pmtu_no_confirm
      tunnel: do not confirm neighbor when do pmtu update
      vti: do not confirm neighbor when do pmtu update
      sit: do not confirm neighbor when do pmtu update
      net/dst: do not confirm neighbor for vxlan and geneve pmtu update

Hans de Goede (2):
      HID: logitech-hidpp: Silence intermittent get_battery_capacity errors
      pinctrl: baytrail: Really serialize all register accesses

Harald Freudenberger (1):
      s390/zcrypt: handle new reply code FILTERED_BY_HYPERVISOR

James Smart (5):
      scsi: lpfc: Fix discovery failures when target device connectivity bo=
unces
      scsi: lpfc: Fix locking on mailbox command completion
      scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices
      scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow
      scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer derefere=
nces

Jan H. Sch=C3=B6nherr (1):
      x86/mce: Fix possibly incorrect severity calculation on AMD

Jan Kara (1):
      jbd2: Fix statistics for the number of logged blocks

Jeffrey Hugo (1):
      clk: qcom: Allow constant ratio freq tables for rcg

Jinke Fan (1):
      HID: quirks: Add quirk for HP MSU1465 PIXART OEM mouse

Johannes Weiner (1):
      kernel: sysctl: make drop_caches write-only

Kevin Hao (1):
      watchdog: Fix the race between the release of watchdog_core_data and =
cdev

Konstantin Khlebnikov (1):
      fs/quota: handle overflows of sysctl fs.quota.* and report as unsigne=
d long

Linus Torvalds (2):
      Make filldir[64]() verify the directory entry filename is valid
      filldir[64]: remove WARN_ON_ONCE() for bad directory entries

Mahesh Bandewar (1):
      bonding: fix active-backup transition after link failure

Marco Oliverio (1):
      netfilter: nf_queue: enqueue skbs with NULL dst

Martin Blumenstingl (1):
      net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs

Masahiro Yamada (2):
      scripts/kallsyms: fix definitely-lost memory leak
      libfdt: define INT32_MAX and UINT32_MAX in libfdt_env.h

Matthew Bobrowski (2):
      ext4: update direct I/O read lock pattern for IOCB_NOWAIT
      ext4: iomap that extends beyond EOF should be marked dirty

Mattias Jacobsson (1):
      perf strbuf: Remove redundant va_end() in strbuf_addv()

Maurizio Lombardi (1):
      scsi: scsi_debug: num_tgts must be >=3D 0

Michael Ellerman (2):
      powerpc/pseries: Mark accumulate_stolen_time() as notrace
      powerpc/tools: Don't quote $objdump in scripts

Michael Hennerich (1):
      clk: clk-gpio: propagate rate change to parent

Mike Rapoport (1):
      userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK

Nathan Chancellor (1):
      powerpc: Don't add -mabi=3D flags when building with Clang

Netanel Belgazal (1):
      net: ena: fix napi handler misbehavior when the napi budget is zero

Nicholas Graumann (1):
      dmaengine: xilinx_dma: Clear desc_pendingcount in xilinx_dma_reset

Paul Cercueil (1):
      irqchip: ingenic: Error out if IRQ domain creation failed

Qian Cai (1):
      libnvdimm/btt: fix variable 'rc' set but not used

Robert Jarzmik (1):
      clk: pxa: fix one of the pxa RTC clocks

Russell King (1):
      net: marvell: mvpp2: phylink requires the link interrupt

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix clear pending bit in ioctl status

Stefano Garzarella (1):
      vhost/vsock: accept only packets with the right dst_cid

Subhash Jadavani (1):
      scsi: ufs: Fix error handing during hibern8 enter

Taehee Yoo (4):
      gtp: do not allow adding duplicate tid and ms_addr pdp context
      gtp: fix wrong condition in gtp_genl_dump_pdp()
      gtp: fix an use-after-free in ipv4_pdp_find()
      gtp: avoid zero size hashtable

Takashi Iwai (1):
      ALSA: hda - Downgrade error message for single-cmd fallback

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

Vladimir Oltean (1):
      gpio: mpc8xxx: Don't overwrite default irq_set_type callback

Vladis Dronov (1):
      ptp: fix the race between the release of ptp_clock and cdev

Vladyslav Tarasiuk (1):
      net/mlxfw: Fix out-of-memory error in mfa2 flash burning

Xiang Chen (1):
      scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()

peter chang (1):
      scsi: pm80xx: Fix for SATA device discovery


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4SMV0ACgkQONu9yGCS
aT6VixAAzeGtnVk4GIvP1LF83aR3GKtAca1sHywut59puAeH1y2muTRW78m5ig2m
iD3kNNnLvNJ0Y5HXTuZlDfpUEffiyByVgXeCiUoX2WWt4PdAHP5siD7yqxyycATA
8VD6Tot5cf1R6o0KG3Giy2MhOpkI8EQHzHL23mqb5qieWAOkCjRzUFlgg72KQarP
5k6wbHS5yfm/k/eT2RjUh579q7Z8bnVppmG1tbhs6XD3cU22W34NEJQPlVZ14PDO
T/uRySn7AGw8L3yzo9jMhOz1o3gdMWklQ03kY21Ymuo4PoZld15yCTisiJPu5pnk
Q8Au+x688GkJEkZkSmNn02FUVhVqYEiMtVds846BjvCTSpkTRXaR/7PHBKS/nXQ3
UhsJFzmd4/bVm2E0bKb1ZXlOaAdaNG4kwGzUxEB+RJjGUBLJtg74PwK22zrSUZLS
9ng6Dq0gSo55IAyxYaV7SVNyfa2D/nU7U9RckqfMwNLf83v5hmowD8O7I6Wn9Sjy
lQ1GEACFfFkPKlaZTlvvxMvxhPrGuxJ9bQTJY/I4JMW7ILnmCrKefAwaVkuojuYV
JQMCnUCVtJy1sHzsV4jPndFPZFSwXFwN0eF4iSurGHxcFWSP9SZ2wCxnRQT6Rnox
tY2qBcC8AXdJX2k6/IVqPA+MCeeefxjXOBzBNXjD00iDKgn1W5k=
=N53/
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
