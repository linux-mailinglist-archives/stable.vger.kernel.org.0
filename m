Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F7B6C15DA
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjCTO6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbjCTO55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:57:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A9EA269;
        Mon, 20 Mar 2023 07:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2231CE12DC;
        Mon, 20 Mar 2023 14:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE6CC433EF;
        Mon, 20 Mar 2023 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324170;
        bh=8KOdPNZADtNP0VYhtS4hyOuvu3LwJDpiYU4U2GfrMmM=;
        h=From:To:Cc:Subject:Date:From;
        b=u0djYbZmqb6vquL36xPq/9TT23EYVDdHlAl7R3BTI7DQFdZ58se3+WQBG5QgoGqfw
         /C1F4Qw/maC8R60JeM/Sxroz35xrKBL1lNp9RBy4ytnhh+GfPjlxR69G6P0lC4vdGG
         9cH/TZoT2nG9NYuFuOzwfCyAJyeC1eK9MTXa/jJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 00/60] 5.4.238-rc1 review
Date:   Mon, 20 Mar 2023 15:54:09 +0100
Message-Id: <20230320145430.861072439@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.238-rc1
X-KernelTest-Deadline: 2023-03-22T14:54+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.238 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.238-rc1

Lee Jones <lee@kernel.org>
    HID: uhid: Over-ride the default maximum data buffer value with our own

Lee Jones <lee@kernel.org>
    HID: core: Provide new max_buffer_size attribute to over-ride the default

Lukas Wunner <lukas@wunner.de>
    PCI: Unify delay handling for reset and resume

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: add missing intersection check to ipl_report handling

Biju Das <biju.das.jz@bp.renesas.com>
    serial: 8250_em: Fix UART port type

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use stolen memory for ring buffers with LLC

Kees Cook <keescook@chromium.org>
    treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()

Tom Saeger <tom.saeger@oracle.com>
    Revert "treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()"

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    x86/mm: Fix use of uninitialized buffer in sme_enable()

Helge Deller <deller@gmx.de>
    fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Chen Zhongjin <chenzhongjin@huawei.com>
    ftrace: Fix invalid address access in lookup_rec() when index is 0

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: add missing consistency checks for CR0 and CR4

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Make tracepoint lockdep check actually test something

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Check field value in hist_field_name()

Johan Hovold <johan+linaro@kernel.org>
    interconnect: fix mem leak when freeing nodes

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: skip waiting for transmission complete when UARTCTRL_SBK is asserted

Theodore Ts'o <tytso@mit.edu>
    ext4: fix possible double unlock when moving a directory

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sh: intc: Avoid spurious sizeof-pointer-div warning

Qu Huang <qu.huang@linux.dev>
    drm/amdkfd: Fix an illegal memory access

Baokun Li <libaokun1@huawei.com>
    ext4: fix task hung in ext4_xattr_delete_inode

Baokun Li <libaokun1@huawei.com>
    ext4: fail ext4_iget if special inode unallocated

David Gow <davidgow@google.com>
    rust: arch/um: Disable FP/SIMD instruction to match x86

Yifei Liu <yifeliu@cs.stonybrook.edu>
    jffs2: correct logic when creating a hole in jffs2_write_begin

Tobias Schramm <t.schramm@manjaro.org>
    mmc: atmel-mci: fix race between stop command and start of next command

Linus Torvalds <torvalds@linux-foundation.org>
    media: m5mols: fix off-by-one loop termination error

Marcus Folkesson <marcus.folkesson@gmail.com>
    hwmon: (ina3221) return prober error code

Zheng Wang <zyytlz.wz@163.com>
    hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Fix masking of hysteresis registers

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Display smoothing attributes in correct order

Liang He <windhl@126.com>
    ethernet: sun: add check for the mdesc_grab()

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: Fix size of interrupt data

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect table ID in IOCTL path

Liang He <windhl@126.com>
    block: sunvdc: add check for mdesc_grab() returning NULL

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    nvmet: avoid potential UAF in nvmet_req_complete()

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Limit packet length to skb->len

Zheng Wang <zyytlz.wz@163.com>
    nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Eric Dumazet <edumazet@google.com>
    net: tunnels: annotate lockless accesses to dev->needed_headroom

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_dev: guard against a possible division by zero

Ivan Vecera <ivecera@redhat.com>
    i40e: Fix kernel crash during reboot when adapter is in recovery mode

Jianguo Wu <wujianguo@chinatelecom.cn>
    ipvlan: Make skb->skb_iif track skb->dev for l3s mode

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: pn533: initialize struct pn533_out_arg properly

Breno Leitao <leitao@debian.org>
    tcp: tcp_make_synack() can be called from process context

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a procfs host directory removal regression

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: core: Fix a comment in function scsi_host_dev_release()

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_redir: correct value of inet type `.maxattrs`

Bjorn Helgaas <bhelgaas@google.com>
    ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: Add Intel DG2 PCI ID and HDMI codec vid

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: Add Alderlake-S PCI ID and HDMI codec vid

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda - controller is in GPU on the DG1

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda - add Intel DG1 PCI and HDMI ids

Wenchao Hao <haowenchao2@huawei.com>
    scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()

Glenn Washburn <development@efficientek.com>
    docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate

Randy Dunlap <rdunlap@infradead.org>
    clk: HI655X: select REGMAP instead of depending on it

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: fix 1px pink line on GXM when scaling video overlay

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Move the in_send statistic to __smb_send_rqst()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/panfrost: Don't sync rpm suspension after mmu flushing

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Allow transport-mode states with AF_UNSPEC selector

Eric Biggers <ebiggers@google.com>
    ext4: fix cgroup writeback accounting with fs-layer encryption


-------------

Diffstat:

 Documentation/filesystems/vfs.rst           |  2 +-
 Makefile                                    |  4 +--
 arch/mips/lasat/picvue_proc.c               |  2 +-
 arch/s390/boot/ipl_report.c                 |  8 +++++
 arch/x86/Makefile.um                        |  6 ++++
 arch/x86/kvm/vmx/nested.c                   | 10 ++++--
 arch/x86/mm/mem_encrypt_identity.c          |  3 +-
 drivers/block/sunvdc.c                      |  2 ++
 drivers/clk/Kconfig                         |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c     |  9 ++---
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c  |  5 +--
 drivers/gpu/drm/meson/meson_vpp.c           |  2 ++
 drivers/gpu/drm/panfrost/panfrost_mmu.c     |  2 +-
 drivers/hid/hid-core.c                      | 18 +++++++---
 drivers/hid/uhid.c                          |  1 +
 drivers/hwmon/adt7475.c                     |  8 ++---
 drivers/hwmon/ina3221.c                     |  2 +-
 drivers/hwmon/xgene-hwmon.c                 |  1 +
 drivers/interconnect/core.c                 |  4 +++
 drivers/media/i2c/m5mols/m5mols_core.c      |  2 +-
 drivers/mmc/host/atmel-mci.c                |  3 --
 drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c   |  5 +++
 drivers/net/ethernet/sun/ldmvsw.c           |  3 ++
 drivers/net/ethernet/sun/sunvnet.c          |  3 ++
 drivers/net/ipvlan/ipvlan_l3s.c             |  1 +
 drivers/net/phy/smsc.c                      |  5 ++-
 drivers/net/usb/smsc75xx.c                  |  7 ++++
 drivers/nfc/pn533/usb.c                     |  1 +
 drivers/nfc/st-nci/ndlc.c                   |  6 ++--
 drivers/nvme/target/core.c                  |  4 ++-
 drivers/pci/pci-driver.c                    |  4 +--
 drivers/pci/pci.c                           | 54 +++++++++++++----------------
 drivers/pci/pci.h                           | 10 +++++-
 drivers/scsi/hosts.c                        |  5 +--
 drivers/scsi/mpt3sas/mpt3sas_transport.c    | 14 ++++++--
 drivers/tty/serial/8250/8250_em.c           |  4 +--
 drivers/tty/serial/fsl_lpuart.c             | 12 +++++--
 drivers/video/fbdev/stifb.c                 | 27 +++++++++++++++
 fs/cifs/transport.c                         | 21 +++++------
 fs/ext4/inode.c                             | 18 +++++-----
 fs/ext4/namei.c                             |  4 +--
 fs/ext4/page-io.c                           | 10 +++---
 fs/ext4/xattr.c                             | 11 ++++++
 fs/jffs2/file.c                             | 15 ++++----
 include/linux/hid.h                         |  3 ++
 include/linux/netdevice.h                   |  6 ++--
 include/linux/sh_intc.h                     |  5 ++-
 include/linux/tracepoint.h                  | 15 ++++----
 kernel/trace/ftrace.c                       |  3 +-
 kernel/trace/trace_events_hist.c            |  3 ++
 net/ipv4/fib_frontend.c                     |  3 ++
 net/ipv4/ip_tunnel.c                        | 12 +++----
 net/ipv4/tcp_output.c                       |  2 +-
 net/ipv6/ip6_tunnel.c                       |  4 +--
 net/iucv/iucv.c                             |  2 +-
 net/netfilter/nft_redir.c                   |  2 +-
 net/xfrm/xfrm_state.c                       |  3 --
 sound/pci/hda/hda_intel.c                   | 22 ++++++++++--
 sound/pci/hda/patch_hdmi.c                  |  3 ++
 60 files changed, 284 insertions(+), 145 deletions(-)


