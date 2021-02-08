Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F625313698
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhBHPNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233056AbhBHPKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D39764EDB;
        Mon,  8 Feb 2021 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796840;
        bh=5jUi6k/PhVW0pf+sT/o6sL4j8fL4vWL59G0IU6s2hMA=;
        h=From:To:Cc:Subject:Date:From;
        b=UJqvvDLXlUe+/XrNLta9s8vcqjyHER1xRctyFf8m7qBOYvdAztSAsBfBEpWVyd8I/
         TlWD0hQ54WMJUfh1lNiqmdlw75EVgzi8qpAiNW1GgWpc2VJhgaXECgOw0zaxnhD/DU
         alXQY/PuB4jyGrzllSgU/LoTLECapDkPs1Zjupes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/30] 4.14.221-rc1 review
Date:   Mon,  8 Feb 2021 16:00:46 +0100
Message-Id: <20210208145805.239714726@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.221-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.221-rc1
X-KernelTest-Deadline: 2021-02-10T14:58+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.221 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.221-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.221-rc1

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Nadav Amit <namit@vmware.com>
    iommu/vt-d: Do not use flush-queue when caching-mode is on

Benjamin Valentin <benpicco@googlemail.com>
    Input: xpad - sync supported devices with fork on GitHub

Dave Hansen <dave.hansen@linux.intel.com>
    x86/apic: Add extra serialization for non-serializing MSRs

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/build: Disable CET instrumentation in the kernel

Hugh Dickins <hughd@google.com>
    mm: thp: fix MADV_REMOVE deadlock on shmem THP

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix a race between isolating and freeing page

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: footbridge: fix dc21285 PCI configuration accessors

Thorsten Leemhuis <linux@leemhuis.info>
    nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs

Fengnan Chang <fengnanchang@gmail.com>
    mmc: core: Limit retries when analyse of SDIO tuples fails

Gustavo A. R. Silva <gustavoars@kernel.org>
    smb3: Fix out-of-bounds bug in SMB2_negotiate()

Aurelien Aptel <aaptel@suse.com>
    cifs: report error instead of invalid when revalidating a dentry fails

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix bounce buffer usage for non-sg list case

Wang ShaoBo <bobo.shaobowang@huawei.com>
    kretprobe: Avoid re-registration of the same kretprobe earlier

Felix Fietkau <nbd@nbd.name>
    mac80211: fix station rate table updates on assoc

Liangyan <liangyan.peng@linux.alibaba.com>
    ovl: fix dentry leak in ovl_get_redirect

Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
    usb: dwc2: Fix endpoint direction check in ep_from_windex

Jeremy Figgins <kernel@jeremyfiggins.com>
    USB: usblp: don't call usb_set_interface if there's a single alt

Dan Carpenter <dan.carpenter@oracle.com>
    USB: gadget: legacy: fix an error code in eth_bind()

Wei Wang <weiwan@google.com>
    ipv4: fix race condition between route lookup and invalidation

Arnd Bergmann <arnd@arndb.de>
    elfcore: fix building with clang

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Support Clang non-section symbols in ORC generation

Xie He <xie.he.0141@gmail.com>
    net: lapb: Copy the skb before sending a packet

Zyta Szpak <zr@semihalf.com>
    arm64: dts: ls1046a: fix dcfg address range

Alexey Dobriyan <adobriyan@gmail.com>
    Input: i8042 - unbreak Pegatron C15B

Christoph Schemmel <christoph.schemmel@gmail.com>
    USB: serial: option: Adding support for Cinterion MV31

Chenxin Jin <bg4akv@hotmail.com>
    USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Pho Tran <Pho.Tran@silabs.com>
    USB: serial: cp210x: add pid/vid for WSDA-200-USB


-------------

Diffstat:

 Makefile                                       | 10 ++-----
 arch/arm/mach-footbridge/dc21285.c             | 12 ++++----
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi |  2 +-
 arch/x86/Makefile                              |  3 ++
 arch/x86/include/asm/apic.h                    | 10 -------
 arch/x86/include/asm/barrier.h                 | 18 ++++++++++++
 arch/x86/kernel/apic/apic.c                    |  4 +++
 arch/x86/kernel/apic/x2apic_cluster.c          |  6 ++--
 arch/x86/kernel/apic/x2apic_phys.c             |  6 ++--
 drivers/input/joystick/xpad.c                  | 17 +++++++++++-
 drivers/input/serio/i8042-x86ia64io.h          |  2 ++
 drivers/iommu/intel-iommu.c                    |  6 ++++
 drivers/mmc/core/sdio_cis.c                    |  6 ++++
 drivers/net/dsa/mv88e6xxx/chip.c               |  6 +++-
 drivers/nvme/host/pci.c                        |  2 ++
 drivers/usb/class/usblp.c                      | 19 +++++++------
 drivers/usb/dwc2/gadget.c                      |  8 +-----
 drivers/usb/gadget/legacy/ether.c              |  4 ++-
 drivers/usb/host/xhci-ring.c                   | 31 +++++++++++++--------
 drivers/usb/serial/cp210x.c                    |  2 ++
 drivers/usb/serial/option.c                    |  6 ++++
 fs/cifs/dir.c                                  | 22 +++++++++++++--
 fs/cifs/smb2pdu.h                              |  2 +-
 fs/hugetlbfs/inode.c                           |  3 +-
 fs/overlayfs/dir.c                             |  2 +-
 include/linux/elfcore.h                        | 22 +++++++++++++++
 include/linux/hugetlb.h                        |  3 ++
 kernel/Makefile                                |  1 -
 kernel/elfcore.c                               | 26 ------------------
 kernel/kprobes.c                               |  4 +++
 mm/huge_memory.c                               | 37 +++++++++++++++----------
 mm/hugetlb.c                                   |  9 +++---
 net/ipv4/route.c                               | 38 +++++++++++++-------------
 net/lapb/lapb_out.c                            |  3 +-
 net/mac80211/driver-ops.c                      |  5 +++-
 net/mac80211/rate.c                            |  3 +-
 tools/objtool/orc_gen.c                        | 33 +++++++++++++++++-----
 37 files changed, 255 insertions(+), 138 deletions(-)


