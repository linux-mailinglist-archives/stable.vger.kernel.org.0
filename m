Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEB5300854
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 17:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbhAVQLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 11:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbhAVQKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 11:10:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721A5233FC;
        Fri, 22 Jan 2021 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611331784;
        bh=Y+wzIZMS7dU5npUlpi5Ctn1+VFjpV6NOLKscPy48wrk=;
        h=From:To:Cc:Subject:Date:From;
        b=iQ2fjcJA1P9SzK3+6wGUH/jl/IBSrSjmfkto0r2+RC+GvNd1GB0aiYHllUdXSdpSN
         c1IZwXgPCyL/DhPOX6KgmkCWvOKBdil0R0dS34r8UyVQ7YrH/C0sSufDkitQbB33Vb
         /3jxrmh0SfeRxuD1DY7wJyXTOp8b2YViEErQdskU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.9 00/33] 4.9.253-rc2 review
Date:   Fri, 22 Jan 2021 17:09:41 +0100
Message-Id: <20210122160829.171484729@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.253-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.253-rc2
X-KernelTest-Deadline: 2021-01-24T16:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.253 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Jan 2021 16:08:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.253-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.253-rc2

Michael Hennerich <michael.hennerich@analog.com>
    spi: cadence: cache reference clock rate during probe

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix NULL deref in tipc_link_xmit()

David Howells <dhowells@redhat.com>
    rxrpc: Fix handling of an unsupported token type in rxrpc_read()

Eric Dumazet <edumazet@google.com>
    net: avoid 32 x truesize under-estimation for tiny skbs

Jakub Kicinski <kuba@kernel.org>
    net: sit: unregister_netdevice on newlink's error path

Petr Machata <petrm@nvidia.com>
    net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Petr Machata <me@pmachata.org>
    net: dcb: Validate netlink message in DCB handler

Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
    rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Manish Chopra <manishc@marvell.com>
    netxen_nic: fix MSI/MSI-x interrupts

Jouni K. Seppänen <jks@iki.fi>
    net: cdc_ncm: correct overhead in delayed_ndp_size

J. Bruce Fields <bfields@redhat.com>
    nfsd4: readdirplus shouldn't return parent of export

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    usb: ohci: Make distrust_firmware param default to false

Jesper Dangaard Brouer <brouer@redhat.com>
    netfilter: conntrack: fix reading nf_conntrack_buckets

j.nixdorf@avm.de <j.nixdorf@avm.de>
    net: sunrpc: interpret the return value of kstrtou32 correctly

Jann Horn <jannh@google.com>
    mm, slub: consider rest of partial list if acquire_slab() fails

Dinghao Liu <dinghao.liu@zju.edu.cn>
    RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp

Jan Kara <jack@suse.cz>
    ext4: fix superblock checksum failure when setting password salt

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfs_igrab_and_active must first reference the superblock

Al Viro <viro@zeniv.linux.org.uk>
    dump_common_audit_data(): fix racy accesses to ->d_name

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: uinput - avoid FF flush when destroying device

Arnd Bergmann <arnd@arndb.de>
    ARM: picoxcell: fix missing interrupt-parent properties

Shawn Guo <shawn.guo@linaro.org>
    ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Michael Ellerman <mpe@ellerman.id.au>
    net: ethernet: fs_enet: Add missing MODULE_LICENSE

Arnd Bergmann <arnd@arndb.de>
    misdn: dsp: select CONFIG_BITREVERSE

Randy Dunlap <rdunlap@infradead.org>
    arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Masahiro Yamada <masahiroy@kernel.org>
    ARC: build: add boot_targets to PHONY

yangerkun <yangerkun@huawei.com>
    ext4: fix bug for rename with RENAME_WHITEOUT

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential missing huge page size info

Dexuan Cui <decui@microsoft.com>
    ACPI: scan: Harden acpi_device_add() against device ID overflows

Alexander Lobakin <alobakin@pm.me>
    MIPS: relocatable: fix possible boot hangup with KASLR enabled

Paul Cercueil <paul@crapouillou.net>
    MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Thomas Hebb <tommyhebb@gmail.com>
    ASoC: dapm: remove widget from dirty list on free


-------------

Diffstat:

 Makefile                                             |  4 ++--
 arch/arc/Makefile                                    |  1 +
 arch/arc/include/asm/page.h                          |  1 +
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi               |  4 ++++
 arch/mips/boot/compressed/decompress.c               |  3 ++-
 arch/mips/kernel/relocate.c                          | 10 ++++++++--
 drivers/acpi/internal.h                              |  2 +-
 drivers/acpi/scan.c                                  | 15 ++++++++++++++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c         |  3 +++
 drivers/input/ff-core.c                              | 13 ++++++++++---
 drivers/input/misc/uinput.c                          | 18 ++++++++++++++++++
 drivers/isdn/mISDN/Kconfig                           |  1 +
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c |  1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c     |  1 +
 drivers/net/ethernet/freescale/ucc_geth.h            |  9 ++++++++-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |  7 +------
 drivers/net/usb/cdc_ncm.c                            |  8 ++++++--
 drivers/net/usb/rndis_host.c                         |  2 +-
 drivers/spi/spi-cadence.c                            |  6 ++++--
 drivers/usb/host/ohci-hcd.c                          |  2 +-
 fs/ext4/ioctl.c                                      |  3 +++
 fs/ext4/namei.c                                      | 16 +++++++++-------
 fs/nfs/internal.h                                    | 12 +++++++-----
 fs/nfsd/nfs3xdr.c                                    |  7 ++++++-
 include/linux/acpi.h                                 |  7 +++++++
 include/linux/input.h                                |  1 +
 mm/hugetlb.c                                         |  2 +-
 mm/slub.c                                            |  2 +-
 net/core/skbuff.c                                    |  9 +++++++--
 net/dcb/dcbnl.c                                      |  2 ++
 net/ipv6/sit.c                                       |  5 ++++-
 net/netfilter/nf_conntrack_standalone.c              |  3 +++
 net/rxrpc/key.c                                      |  6 ++++--
 net/sunrpc/addr.c                                    |  2 +-
 net/tipc/link.c                                      | 11 +++++++++--
 security/lsm_audit.c                                 |  7 +++++--
 sound/soc/soc-dapm.c                                 |  1 +
 37 files changed, 159 insertions(+), 48 deletions(-)


