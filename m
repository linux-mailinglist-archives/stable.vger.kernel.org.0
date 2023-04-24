Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE196ECEBD
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjDXNfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjDXNel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:34:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E654F5FE0;
        Mon, 24 Apr 2023 06:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0BA061E07;
        Mon, 24 Apr 2023 13:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47B4C433EF;
        Mon, 24 Apr 2023 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343254;
        bh=h0sR9So1fclHo/yvQLa82i/0HB49aTpNZRSsBSe+xIs=;
        h=From:To:Cc:Subject:Date:From;
        b=YcDFggfaKGDyzVehcB+owpJ5VNZB4YvqPK4dU8gLqxN10O9BndcvDDxzbPnhgxZz1
         VsBNDkIjJFMPchyurmq0nIjNydAswstxKsCNhlVILuxK8JR5B98r3akHBoa4BF7ylu
         VEBeuVw78kgRKKgilxJxhNQTKdAQu/ROxP9kemvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/68] 5.10.179-rc1 review
Date:   Mon, 24 Apr 2023 15:17:31 +0200
Message-Id: <20230424131127.653885914@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.179-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.179-rc1
X-KernelTest-Deadline: 2023-04-26T13:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.179 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.179-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.179-rc1

Ekaterina Orlova <vorobushek.ok@gmail.com>
    ASN.1: Fix check for strdup() success

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    ASoC: fsl_asrc_dma: fix potential null-ptr-deref

Dan Carpenter <error27@gmail.com>
    iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: hibvt: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: iqs620a: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: meson: Explicitly set .polarity in .get_state()

Kuniyuki Iwashima <kuniyu@amazon.com>
    sctp: Call inet6_destroy_sock() via sk->sk_destruct().

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp: Call inet6_destroy_sock() via sk->sk_destruct().

Kuniyuki Iwashima <kuniyu@amazon.com>
    inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_xattr_set_entry

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: remove duplicate definition of ext4_xattr_ibody_inline_set()

Tudor Ambarus <tudor.ambarus@linaro.org>
    Revert "ext4: fix use-after-free in ext4_xattr_set_entry"

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix deadlock between atomic O_TRUNC and page invalidation

Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
    fuse: always revalidate rename target dentry

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix attr version comparison in fuse_read_update_size()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check s_root when destroying sb

Connor Kuehl <ckuehl@redhat.com>
    virtiofs: split requests that exceed virtqueue size

Miklos Szeredi <mszeredi@redhat.com>
    virtiofs: clean up error handling in virtio_fs_get_tree()

Alyssa Ross <hi@alyssa.is>
    purgatory: fix disabling debug info

Salvatore Bonaccorso <carnil@debian.org>
    docs: futex: Fix kernel-doc references after code split-up preparation

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Define RUNTIME_DISCARD_EXIT in LD script

Qais Yousef <qyousef@layalina.io>
    sched/fair: Fixes for capacity inversion detection

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Fix a uninitialized variable warnings

Qais Yousef <qais.yousef@arm.com>
    sched/fair: Consider capacity inversion in util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/fair: Detect capacity inversion

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make cpu_overutilized() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make select_idle_capacity() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix fits_capacity() check in feec()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make task_fits_capacity() use util_fits_cpu()

Peter Xu <peterx@redhat.com>
    mm/khugepaged: check again on anon uffd-wp during isolation

Bhavya Kapoor <b-kapoor@ti.com>
    mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25

Ondrej Mosnacek <omosnace@redhat.com>
    kernel/sys.c: fix and improve control flow in __sys_setres[ug]id()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    memstick: fix memory leak if card device is never registered

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: initialize unused bytes in segment summary blocks

Brian Masney <bmasney@redhat.com>
    iio: light: tsl2772: fix reading proximity-diodes from device tree

Brian Foster <bfoster@redhat.com>
    xfs: drop submit side trans alloc for append ioends

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/doc: Fix htmldocs errors

Juergen Gross <jgross@suse.com>
    xen/netback: use same error messages for same errors

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix a possible UAF when failing to allocate an io queue

Heiko Carstens <hca@linux.ibm.com>
    s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: mmap: add phy ops

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: core: Improve scsi_vpd_inquiry() checks

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix fw_crash_buffer_show()

Nick Desaulniers <ndesaulniers@google.com>
    selftests: sigaltstack: fix -Wuninitialized

Jonathan Denose <jdenose@chromium.org>
    Input: i8042 - add quirk for Fujitsu Lifebook A574/H

Douglas Raillard <douglas.raillard@arm.com>
    f2fs: Fix f2fs_truncate_partial_nodes ftrace event

Sebastian Basierski <sebastianx.basierski@intel.com>
    e1000e: Disable TSO on i219-LM card to increase speed

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect verifier pruning due to missing register precision taints

Ido Schimmel <idosch@nvidia.com>
    mlxsw: pci: Fix possible crash during initialization

Alexander Aring <aahringo@redhat.com>
    net: rpl: fix rpl header size calculation

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix i40e_setup_misc_vector() error handling

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix accessing vsi->active_filters without holding lock

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Ding Hui <dinghui@sangfor.com.cn>
    sfc: Fix use-after-free due to selftest_work

Jonathan Cooper <jonathan.s.cooper@amd.com>
    sfc: Split STATE_READY in to STATE_NET_DOWN and STATE_NET_UP.

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_net: bugfix overflow inside xdp_linearize_page()

Gwangun Jung <exsociety@gmail.com>
    net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    regulator: fan53555: Explicitly include bits header

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: fix recent physdev match breakage

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mm-evk: correct pmic clock source

Marc Gonzalez <mgonzalez@freebox.fr>
    arm64: dts: meson-g12-common: specify full DMC range

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: ipq8074-hk01: enable QMP device, not the PHY node

Jianqun Xu <jay.xu@rock-chips.com>
    ARM: dts: rockchip: fix a typo error for rk3288 spdif node


-------------

Diffstat:

 Documentation/kernel-hacking/locking.rst           |   2 +-
 Documentation/powerpc/associativity.rst            |  29 ++--
 Documentation/powerpc/index.rst                    |   1 +
 .../translations/it_IT/kernel-hacking/locking.rst  |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   3 +-
 arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi      |   2 +-
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts          |   4 +-
 arch/mips/kernel/vmlinux.lds.S                     |   2 +
 arch/s390/kernel/ptrace.c                          |   8 +-
 arch/x86/purgatory/Makefile                        |   3 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   2 +-
 drivers/iio/light/tsl2772.c                        |   1 +
 drivers/input/serio/i8042-x86ia64io.h              |   8 +
 drivers/memstick/core/memstick.c                   |   5 +-
 drivers/mmc/host/sdhci_am654.c                     |   2 -
 drivers/net/dsa/b53/b53_mmap.c                     |  14 ++
 drivers/net/ethernet/intel/e1000e/netdev.c         |  51 +++---
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   9 +-
 .../ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c |   2 +
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h       |   2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c            |   6 +-
 drivers/net/ethernet/sfc/efx.c                     |  30 ++--
 drivers/net/ethernet/sfc/efx_common.c              |  12 +-
 drivers/net/ethernet/sfc/efx_common.h              |   6 +-
 drivers/net/ethernet/sfc/ethtool_common.c          |   2 +-
 drivers/net/ethernet/sfc/net_driver.h              |  50 +++++-
 drivers/net/virtio_net.c                           |   8 +-
 drivers/net/xen-netback/netback.c                  |   6 +-
 drivers/nvme/host/tcp.c                            |  46 +++---
 drivers/pwm/pwm-hibvt.c                            |   1 +
 drivers/pwm/pwm-iqs620a.c                          |   1 +
 drivers/pwm/pwm-meson.c                            |   7 +
 drivers/regulator/fan53555.c                       |  11 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   2 +-
 drivers/scsi/scsi.c                                |  11 +-
 fs/ext4/inline.c                                   |  11 +-
 fs/ext4/xattr.c                                    |  26 +--
 fs/ext4/xattr.h                                    |   6 +-
 fs/fuse/dir.c                                      |   7 +-
 fs/fuse/file.c                                     |  31 ++--
 fs/fuse/fuse_i.h                                   |   3 +
 fs/fuse/inode.c                                    |   5 +-
 fs/fuse/virtio_fs.c                                |  46 ++++--
 fs/nilfs2/segment.c                                |  20 +++
 fs/xfs/xfs_aops.c                                  |  45 +----
 include/linux/skbuff.h                             |   5 +-
 include/net/ipv6.h                                 |   2 +
 include/net/udp.h                                  |   2 +-
 include/net/udplite.h                              |   8 -
 include/trace/events/f2fs.h                        |   2 +-
 kernel/bpf/verifier.c                              |  15 ++
 kernel/sched/core.c                                |  10 +-
 kernel/sched/fair.c                                | 183 ++++++++++++++++-----
 kernel/sched/sched.h                               |  70 +++++++-
 kernel/sys.c                                       |  69 ++++----
 mm/khugepaged.c                                    |   4 +
 net/bridge/br_netfilter_hooks.c                    |  17 +-
 net/dccp/dccp.h                                    |   1 +
 net/dccp/ipv6.c                                    |  15 +-
 net/dccp/proto.c                                   |   8 +-
 net/ipv4/udp.c                                     |   9 +-
 net/ipv4/udplite.c                                 |   8 +
 net/ipv6/af_inet6.c                                |  15 +-
 net/ipv6/ipv6_sockglue.c                           |  20 +--
 net/ipv6/ping.c                                    |   6 -
 net/ipv6/raw.c                                     |   2 -
 net/ipv6/rpl.c                                     |   3 +-
 net/ipv6/tcp_ipv6.c                                |   8 +-
 net/ipv6/udp.c                                     |  17 +-
 net/ipv6/udp_impl.h                                |   1 +
 net/ipv6/udplite.c                                 |   9 +-
 net/l2tp/l2tp_ip6.c                                |   2 -
 net/mptcp/protocol.c                               |   7 -
 net/sched/sch_qfq.c                                |  13 +-
 net/sctp/socket.c                                  |  29 +++-
 scripts/asn1_compiler.c                            |   2 +-
 sound/soc/fsl/fsl_asrc_dma.c                       |  11 +-
 .../selftests/sigaltstack/current_stack_pointer.h  |  23 +++
 tools/testing/selftests/sigaltstack/sas.c          |   7 +-
 81 files changed, 751 insertions(+), 409 deletions(-)


