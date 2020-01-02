Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F7712ED0E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgABWYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:24:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729000AbgABWYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C267520866;
        Thu,  2 Jan 2020 22:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003870;
        bh=Pxz8ODjYDgYuwAp0d9hVyALhuLBrbihD1A8yQwaLYsY=;
        h=From:To:Cc:Subject:Date:From;
        b=V7P9LZylxNuv3JIAz/4HLVeP9tLIcgiKMrO+32yIw6l57YMDUBrtrghJz3IviZl4c
         N/P9plCPMkgvNohkJirm1CZmN3XLbYe5c1GkqnjUcQ2b02Quvj2tTgZDp2KFhnkF+9
         CBvP6/Sss5Mu86hiIikQjraGeyAe+1v02g3iKzxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/91] 4.14.162-stable review
Date:   Thu,  2 Jan 2020 23:06:42 +0100
Message-Id: <20200102220356.856162165@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.162-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.162-rc1
X-KernelTest-Deadline: 2020-01-04T22:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.162 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 04 Jan 2020 22:01:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.162-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.162-rc1

Taehee Yoo <ap420073@gmail.com>
    gtp: avoid zero size hashtable

Taehee Yoo <ap420073@gmail.com>
    gtp: fix an use-after-free in ipv4_pdp_find()

Taehee Yoo <ap420073@gmail.com>
    gtp: fix wrong condition in gtp_genl_dump_pdp()

Eric Dumazet <edumazet@google.com>
    tcp: do not send empty skb from tcp_write_xmit()

Eric Dumazet <edumazet@google.com>
    tcp/dccp: fix possible race __inet_lookup_established()

Taehee Yoo <ap420073@gmail.com>
    gtp: do not allow adding duplicate tid and ms_addr pdp context

Hangbin Liu <liuhangbin@gmail.com>
    sit: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    vti: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    tunnel: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    net/dst: add new function skb_dst_update_pmtu_no_confirm

Hangbin Liu <liuhangbin@gmail.com>
    gtp: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    ip6_gre: do not confirm neighbor when do pmtu update

Hangbin Liu <liuhangbin@gmail.com>
    net: add bool confirm_neigh parameter for dst_ops.update_pmtu

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: accept only packets with the right dst_cid

Antonio Messina <amessina@google.com>
    udp: fix integer overflow while computing available space in sk_rcvbuf

Vladis Dronov <vdronov@redhat.com>
    ptp: fix the race between the release of ptp_clock and cdev

Vladyslav Tarasiuk <vladyslavt@mellanox.com>
    net/mlxfw: Fix out-of-memory error in mfa2 flash burning

Netanel Belgazal <netanel@amazon.com>
    net: ena: fix napi handler misbehavior when the napi budget is zero

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Really serialize all register accesses

David Engraf <david.engraf@sysgo.com>
    tty/serial: atmel: fix out of range clock divider handling

Christophe Leroy <christophe.leroy@c-s.fr>
    spi: fsl: don't map irq during probe

Eric Dumazet <edumazet@google.com>
    hrtimer: Annotate lockless access to timer->state

Eric Dumazet <edumazet@google.com>
    net: icmp: fix data-race in cmp_global_allow()

Eric Dumazet <edumazet@google.com>
    net: add a READ_ONCE() in skb_peek_tail()

Eric Dumazet <edumazet@google.com>
    inetpeer: fix data-race in inet_putpeer / inet_putpeer

Eric Dumazet <edumazet@google.com>
    netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()

Eric Dumazet <edumazet@google.com>
    6pack,mkiss: fix possible deadlock

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: compat: reject all padding in matches/watchers

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Read all 64 bits of part_event_bitmap

Linus Torvalds <torvalds@linux-foundation.org>
    filldir[64]: remove WARN_ON_ONCE() for bad directory entries

Linus Torvalds <torvalds@linux-foundation.org>
    Make filldir[64]() verify the directory entry filename is valid

Mattias Jacobsson <2pi@mok.nu>
    perf strbuf: Remove redundant va_end() in strbuf_addv()

Mahesh Bandewar <maheshb@google.com>
    bonding: fix active-backup transition after link failure

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Downgrade error message for single-cmd fallback

Marco Oliverio <marco.oliverio@tanaza.com>
    netfilter: nf_queue: enqueue skbs with NULL dst

Alexander Lobakin <alobakin@dlink.ru>
    net, sysctl: Fix compiler warning when only cBPF is present

Jan H. Schönherr <jschoenh@amazon.de>
    x86/mce: Fix possibly incorrect severity calculation on AMD

Mike Rapoport <rppt@linux.ibm.com>
    userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK

Johannes Weiner <hannes@cmpxchg.org>
    kernel: sysctl: make drop_caches write-only

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ocfs2: fix passing zero to 'PTR_ERR' warning

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Check for SDBT and SDB consistency

Masahiro Yamada <yamada.masahiro@socionext.com>
    libfdt: define INT32_MAX and UINT32_MAX in libfdt_env.h

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: handle new reply code FILTERED_BY_HYPERVISOR

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf regs: Make perf_reg_name() return "unknown" instead of NULL

Adrian Hunter <adrian.hunter@intel.com>
    perf script: Fix brstackinsn for AUXTRACE

Diego Elio Pettenò <flameeyes@flameeyes.com>
    cdrom: respect device capabilities during opening action

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()

Masahiro Yamada <yamada.masahiro@socionext.com>
    scripts/kallsyms: fix definitely-lost memory leak

Colin Ian King <colin.king@canonical.com>
    apparmor: fix unsigned len comparison with less than zero

Vladimir Oltean <vladimir.oltean@nxp.com>
    gpio: mpc8xxx: Don't overwrite default irq_set_type callback

Bart Van Assche <bvanassche@acm.org>
    scsi: target: iscsi: Wait for all commands to finish before freeing a session

Anatol Pomazau <anatol@google.com>
    scsi: iscsi: Don't send data to unbound connection

Finn Thain <fthain@telegraphics.com.au>
    scsi: NCR5380: Add disconnect_mask module parameter

Maurizio Lombardi <mlombard@redhat.com>
    scsi: scsi_debug: num_tgts must be >= 0

Subhash Jadavani <subhashj@codeaurora.org>
    scsi: ufs: Fix error handing during hibern8 enter

peter chang <dpf@google.com>
    scsi: pm80xx: Fix for SATA device discovery

Blaž Hrastnik <blaz@mxxn.io>
    HID: Improve Windows Precision Touchpad detection.

Qian Cai <cai@lca.pw>
    libnvdimm/btt: fix variable 'rc' set but not used

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: Silence intermittent get_battery_capacity errors

Coly Li <colyli@suse.de>
    bcache: at least try to shrink 1 node in bch_mca_scan()

Robert Jarzmik <robert.jarzmik@free.fr>
    clk: pxa: fix one of the pxa RTC clocks

Finn Thain <fthain@telegraphics.com.au>
    scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE

Gustavo L. F. Walbon <gwalbon@linux.ibm.com>
    powerpc/security: Fix wrong message when RFI Flush is disable

David Hildenbrand <david@redhat.com>
    powerpc/pseries/cmm: Implement release() function for sysfs device

Bean Huo <beanhuo@micron.com>
    scsi: ufs: fix potential bug which ends in system hang

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    fs/quota: handle overflows of sysctl fs.quota.* and report as unsigned long

Lee Jones <lee.jones@linaro.org>
    mfd: mfd-core: Honour Device Tree's request to disable a child-device

Paul Cercueil <paul@crapouillou.net>
    irqchip: ingenic: Error out if IRQ domain creation failed

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    clk: qcom: Allow constant ratio freq tables for rcg

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to update dir's i_pino during cross_rename

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow

Bart Van Assche <bvanassche@acm.org>
    scsi: tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)

Jan Kara <jack@suse.cz>
    jbd2: Fix statistics for the number of logged blocks

Matthew Bobrowski <mbobrowski@mbobrowski.org>
    ext4: update direct I/O read lock pattern for IOCB_NOWAIT

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/hash: Add cond_resched to avoid soft lockup warning

Anthony Steinhauser <asteinhauser@google.com>
    powerpc/security/book3s64: Report L1TF status in sysfs

Chuhong Yuan <hslester96@gmail.com>
    clocksource/drivers/asm9260: Add a check for of_clk_get

Eric Dumazet <edumazet@google.com>
    dma-debug: add a schedule point in debug_dma_dump_mappings()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/tools: Don't quote $objdump in scripts

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/pseries: Don't fail hash page table insert for bolted mapping

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Mark accumulate_stolen_time() as notrace

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: csiostor: Don't enable IRQs too early

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices

David Disseldorp <ddiss@suse.de>
    scsi: target: compare full CHAP_A Algorithm strings

Thierry Reding <treding@nvidia.com>
    iommu/tegra-smmu: Fix page tables in > 4 GiB memory

Evan Green <evgreen@chromium.org>
    Input: atmel_mxt_ts - disable IRQ across suspend

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix locking on mailbox command completion

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix clear pending bit in ioctl status

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix discovery failures when target device connectivity bounces


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm/boot/compressed/libfdt_env.h            |   4 +-
 arch/powerpc/boot/libfdt_env.h                   |   2 +
 arch/powerpc/kernel/security.c                   |  21 +++--
 arch/powerpc/kernel/time.c                       |   2 +-
 arch/powerpc/mm/hash_utils_64.c                  |  10 +-
 arch/powerpc/platforms/pseries/cmm.c             |   5 +
 arch/powerpc/tools/relocs_check.sh               |   2 +-
 arch/powerpc/tools/unrel_branch_check.sh         |   4 +-
 arch/s390/kernel/perf_cpum_sf.c                  |  17 +++-
 arch/x86/kernel/cpu/mcheck/mce.c                 |   2 +-
 drivers/cdrom/cdrom.c                            |  12 ++-
 drivers/clk/pxa/clk-pxa27x.c                     |   1 +
 drivers/clk/qcom/clk-rcg2.c                      |   2 +
 drivers/clk/qcom/common.c                        |   3 +
 drivers/clocksource/asm9260_timer.c              |   4 +
 drivers/gpio/gpio-mpc8xxx.c                      |   3 +-
 drivers/hid/hid-core.c                           |   4 +
 drivers/hid/hid-logitech-hidpp.c                 |   3 +
 drivers/input/touchscreen/atmel_mxt_ts.c         |   4 +
 drivers/iommu/tegra-smmu.c                       |  11 ++-
 drivers/irqchip/irq-bcm7038-l1.c                 |   4 +
 drivers/irqchip/irq-ingenic.c                    |  15 ++-
 drivers/md/bcache/btree.c                        |   2 +
 drivers/mfd/mfd-core.c                           |   5 +
 drivers/net/bonding/bond_main.c                  |   3 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  10 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c |   7 +-
 drivers/net/gtp.c                                | 111 +++++++++++++----------
 drivers/net/hamradio/6pack.c                     |   4 +-
 drivers/net/hamradio/mkiss.c                     |   4 +-
 drivers/nvdimm/btt.c                             |   8 +-
 drivers/pci/switch/switchtec.c                   |   2 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c         |  81 +++++++++--------
 drivers/ptp/ptp_clock.c                          |  31 +++----
 drivers/ptp/ptp_private.h                        |   2 +-
 drivers/s390/crypto/zcrypt_error.h               |   2 +
 drivers/scsi/NCR5380.c                           |   6 +-
 drivers/scsi/atari_scsi.c                        |   6 +-
 drivers/scsi/csiostor/csio_lnode.c               |  15 +--
 drivers/scsi/iscsi_tcp.c                         |   8 ++
 drivers/scsi/lpfc/lpfc_els.c                     |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                 |   7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c               |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c                     |  15 ++-
 drivers/scsi/mac_scsi.c                          |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c               |   3 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                 |   2 +
 drivers/scsi/scsi_debug.c                        |   5 +
 drivers/scsi/scsi_trace.c                        |  11 ++-
 drivers/scsi/sun3_scsi.c                         |   4 +-
 drivers/scsi/ufs/ufshcd.c                        |  21 +++--
 drivers/spi/spi-fsl-spi.c                        |   5 +-
 drivers/target/iscsi/iscsi_target.c              |  10 +-
 drivers/target/iscsi/iscsi_target_auth.c         |   2 +-
 drivers/tty/serial/atmel_serial.c                |  43 ++++-----
 drivers/vhost/vsock.c                            |   4 +-
 fs/ext4/inode.c                                  |   8 +-
 fs/f2fs/namei.c                                  |  15 ++-
 fs/f2fs/super.c                                  |  20 ++--
 fs/jbd2/commit.c                                 |   4 +-
 fs/ocfs2/acl.c                                   |   4 +-
 fs/quota/dquot.c                                 |  29 +++---
 fs/readdir.c                                     |  40 ++++++++
 fs/userfaultfd.c                                 |  18 ++--
 include/linux/hrtimer.h                          |  14 ++-
 include/linux/libfdt_env.h                       |   3 +
 include/linux/posix-clock.h                      |  19 ++--
 include/linux/quota.h                            |   2 +-
 include/linux/rculist_nulls.h                    |  37 ++++++++
 include/linux/skbuff.h                           |   6 +-
 include/net/dst.h                                |  11 ++-
 include/net/dst_ops.h                            |   3 +-
 include/net/inet_hashtables.h                    |  12 ++-
 include/net/sock.h                               |   5 +
 include/scsi/iscsi_proto.h                       |   1 +
 kernel/sysctl.c                                  |   2 +-
 kernel/time/hrtimer.c                            |  11 ++-
 kernel/time/posix-clock.c                        |  31 +++----
 lib/dma-debug.c                                  |   1 +
 net/bridge/br_netfilter_hooks.c                  |   3 +
 net/bridge/br_nf_core.c                          |   3 +-
 net/bridge/netfilter/ebtables.c                  |  33 ++++---
 net/core/sysctl_net_core.c                       |   2 +
 net/decnet/dn_route.c                            |   6 +-
 net/ipv4/icmp.c                                  |  11 ++-
 net/ipv4/inet_connection_sock.c                  |   2 +-
 net/ipv4/inet_diag.c                             |   3 +-
 net/ipv4/inet_hashtables.c                       |  18 ++--
 net/ipv4/inetpeer.c                              |  12 ++-
 net/ipv4/ip_tunnel.c                             |   2 +-
 net/ipv4/ip_vti.c                                |   2 +-
 net/ipv4/route.c                                 |   9 +-
 net/ipv4/tcp_ipv4.c                              |   7 +-
 net/ipv4/tcp_output.c                            |   8 ++
 net/ipv4/udp.c                                   |   2 +-
 net/ipv4/xfrm4_policy.c                          |   5 +-
 net/ipv6/inet6_connection_sock.c                 |   2 +-
 net/ipv6/inet6_hashtables.c                      |   3 +-
 net/ipv6/ip6_gre.c                               |   2 +-
 net/ipv6/ip6_tunnel.c                            |   4 +-
 net/ipv6/ip6_vti.c                               |   2 +-
 net/ipv6/route.c                                 |  22 +++--
 net/ipv6/sit.c                                   |   2 +-
 net/ipv6/xfrm6_policy.c                          |   5 +-
 net/netfilter/ipvs/ip_vs_xmit.c                  |   2 +-
 net/netfilter/nf_queue.c                         |   2 +-
 net/sctp/transport.c                             |   2 +-
 scripts/kallsyms.c                               |   2 +
 security/apparmor/label.c                        |  12 ++-
 sound/pci/hda/hda_controller.c                   |   2 +-
 tools/perf/builtin-script.c                      |   2 +-
 tools/perf/util/perf_regs.h                      |   2 +-
 tools/perf/util/strbuf.c                         |   1 -
 114 files changed, 718 insertions(+), 361 deletions(-)


