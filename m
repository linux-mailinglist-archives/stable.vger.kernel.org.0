Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869176ECD63
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjDXNXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjDXNW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:22:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2525274;
        Mon, 24 Apr 2023 06:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA02762258;
        Mon, 24 Apr 2023 13:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9289AC4339B;
        Mon, 24 Apr 2023 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342561;
        bh=5c6jDPnJuRXg9pVk5Sxjk5gThp8Z9aN4OHq9Go8uUVE=;
        h=From:To:Cc:Subject:Date:From;
        b=ZUiHCEPaM+mSVA5qwJ67Bi1H2+TR2oTh7b0br6ZHpCnrnwAHkmtnkcrA+Q6KU2ca1
         1S0HSY5mNjyE1keSKo4qpiaNBWD9WMi1ZWuT/1Mq2l2yaBaOd1hxCr8B33TlFdRZ7p
         v7WwO8ujHJDxx9zLwhk8CgXxXFNzwDGkIAW9c8n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 00/39] 5.4.242-rc1 review
Date:   Mon, 24 Apr 2023 15:17:03 +0200
Message-Id: <20230424131123.040556994@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.242-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.242-rc1
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

This is the start of the stable review cycle for the 5.4.242 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.242-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.242-rc1

Ekaterina Orlova <vorobushek.ok@gmail.com>
    ASN.1: Fix check for strdup() success

Dan Carpenter <error27@gmail.com>
    iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: meson: Explicitly set .polarity in .get_state()

Gao Xiang <hsiangkao@redhat.com>
    xfs: fix forkoff miscalculation related to XFS_LITINO(mp)

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

Pingfan Liu <kernelfans@gmail.com>
    x86/purgatory: Don't generate debug info for purgatory.ro

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Define RUNTIME_DISCARD_EXIT in LD script

Bhavya Kapoor <b-kapoor@ti.com>
    mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    memstick: fix memory leak if card device is never registered

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: initialize unused bytes in segment summary blocks

Brian Masney <bmasney@redhat.com>
    iio: light: tsl2772: fix reading proximity-diodes from device tree

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

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix i40e_setup_misc_vector() error handling

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix accessing vsi->active_filters without holding lock

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix ifdef to also consider nf_tables=m

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_net: bugfix overflow inside xdp_linearize_page()

Gwangun Jung <exsociety@gmail.com>
    net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    regulator: fan53555: Explicitly include bits header

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: fix recent physdev match breakage

Marc Gonzalez <mgonzalez@freebox.fr>
    arm64: dts: meson-g12-common: specify full DMC range

Jianqun Xu <jay.xu@rock-chips.com>
    ARM: dts: rockchip: fix a typo error for rk3288 spdif node


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |  2 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |  3 +-
 arch/mips/kernel/vmlinux.lds.S                     |  2 +
 arch/s390/kernel/ptrace.c                          |  8 +---
 arch/x86/purgatory/Makefile                        |  5 ++-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  2 +-
 drivers/iio/light/tsl2772.c                        |  1 +
 drivers/input/serio/i8042-x86ia64io.h              |  8 ++++
 drivers/memstick/core/memstick.c                   |  5 ++-
 drivers/mmc/host/sdhci_am654.c                     |  2 -
 drivers/net/dsa/b53/b53_mmap.c                     | 14 ++++++
 drivers/net/ethernet/intel/e1000e/netdev.c         | 51 +++++++++++-----------
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  9 ++--
 .../ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c |  2 +
 drivers/net/virtio_net.c                           |  8 +++-
 drivers/net/xen-netback/netback.c                  |  6 +--
 drivers/nvme/host/tcp.c                            | 46 ++++++++++---------
 drivers/pwm/pwm-meson.c                            |  7 +++
 drivers/regulator/fan53555.c                       | 11 ++---
 drivers/scsi/megaraid/megaraid_sas_base.c          |  2 +-
 drivers/scsi/scsi.c                                | 11 ++++-
 fs/ext4/inline.c                                   | 11 +++--
 fs/ext4/xattr.c                                    | 26 +----------
 fs/ext4/xattr.h                                    |  6 +--
 fs/nilfs2/segment.c                                | 20 +++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  8 +++-
 include/linux/skbuff.h                             |  5 ++-
 include/net/ipv6.h                                 |  2 +
 include/net/udp.h                                  |  2 +-
 include/net/udplite.h                              |  8 ----
 include/trace/events/f2fs.h                        |  2 +-
 kernel/bpf/verifier.c                              | 15 +++++++
 net/bridge/br_netfilter_hooks.c                    | 17 +++++---
 net/dccp/dccp.h                                    |  1 +
 net/dccp/ipv6.c                                    | 15 ++++---
 net/dccp/proto.c                                   |  8 +++-
 net/ipv4/udp.c                                     |  9 ++--
 net/ipv4/udplite.c                                 |  8 ++++
 net/ipv6/af_inet6.c                                | 15 ++++++-
 net/ipv6/ipv6_sockglue.c                           | 20 ++++-----
 net/ipv6/ping.c                                    |  6 ---
 net/ipv6/raw.c                                     |  2 -
 net/ipv6/tcp_ipv6.c                                |  8 +---
 net/ipv6/udp.c                                     | 17 ++++++--
 net/ipv6/udp_impl.h                                |  1 +
 net/ipv6/udplite.c                                 |  9 +++-
 net/l2tp/l2tp_ip6.c                                |  2 -
 net/sched/sch_qfq.c                                | 13 +++---
 net/sctp/socket.c                                  | 29 ++++++++----
 scripts/asn1_compiler.c                            |  2 +-
 .../selftests/sigaltstack/current_stack_pointer.h  | 23 ++++++++++
 tools/testing/selftests/sigaltstack/sas.c          |  7 +--
 53 files changed, 329 insertions(+), 197 deletions(-)


