Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F032A31BC8B
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhBOPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:31:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230178AbhBOP3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:29:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F1BD64E5A;
        Mon, 15 Feb 2021 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402917;
        bh=DwgP99DdVL1xkqq7fBg6yeL8XsZs7S1iLYE/RkYFEFQ=;
        h=From:To:Cc:Subject:Date:From;
        b=SwJtNOiuWQrSSqIErp0l3Qk9Nd7PaA/Ns/TLTFGh9Xn1OIqUSo0XNhfD0eoxP3zli
         z0Zy8dh85ncpbsSjx4yO2lK85+jLMV8p6Tco9UEynACHQV8w/1TMOSYDZa7eZEZxOf
         tRM2erzQWMGoF4jqfSdi8wmRJWIpIks0R9h/SEq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/60] 5.4.99-rc1 review
Date:   Mon, 15 Feb 2021 16:26:48 +0100
Message-Id: <20210215152715.401453874@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.99-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.99-rc1
X-KernelTest-Deadline: 2021-02-17T15:27+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.99 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 17 Feb 2021 15:27:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.99-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.99-rc1

Miklos Szeredi <mszeredi@redhat.com>
    ovl: expand warning in ovl_d_real()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS

Stefano Garzarella <sgarzare@redhat.com>
    vsock: fix locking in vsock_shutdown()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: update credit only if socket is not closed

Edwin Peer <edwin.peer@broadcom.com>
    net: watchdog: hold device global xmit lock during tx disable

Norbert Slusarek <nslusarek@gmx.net>
    net/vmw_vsock: improve locking in vsock_connect_timeout()

NeilBrown <neilb@suse.de>
    net: fix iteration for sctp transport seq_files

Eric Dumazet <edumazet@google.com>
    net: gro: do not keep too many GRO packets in napi->rx_list

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: call teardown method on probe failure

Willem de Bruijn <willemb@google.com>
    udp: fix skb_copy_and_csum_datagram with odd segment sizes

David Howells <dhowells@redhat.com>
    rxrpc: Fix clearance of Tx/Rx ring when releasing a call

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    usb: dwc3: ulpi: Replace CPU-based busyloop with Protocol-based one

Felipe Balbi <balbi@kernel.org>
    usb: dwc3: ulpi: fix checkpatch warning

Randy Dunlap <rdunlap@infradead.org>
    h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: fix configuration of the digital filter

Jernej Skrabec <jernej.skrabec@siol.net>
    clk: sunxi-ng: mp: fix parent rate change flag check

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: dw-hdmi: Fix max. frequency for H6

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix H6 HDMI PHY configuration

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: tcon: set sync polarity for tcon1 channel

Fangrui Song <maskray@google.com>
    firmware_loader: align .builtin_fw to 8

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: add a check for queue_id in hclge_reset_vf_queue()

Borislav Petkov <bp@suse.de>
    x86/build: Disable CET instrumentation in the kernel for 32-bit too

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: skip identical origin tuple in same zone only

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Clear failover_pending if unable to schedule

Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
    net: stmmac: set TxQ mode back to DCB after disabling CBS

Vadim Fedorenko <vfedorenko@novek.ru>
    selftests: txtimestamp: fix compilation issue

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: initialize the RFS and RSS memories

Juergen Gross <jgross@suse.com>
    xen/netback: avoid race in xenvif_rx_ring_slots_available()

Sven Auhagen <sven.auhagen@voleatech.de>
    netfilter: flowtable: fix tcp and udp header checksum update

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: fix possible UAF over chains from packet path in netns

Jozsef Kadlecsik <kadlec@mail.kfki.hu>
    netfilter: xt_recent: Fix attempt to update deleted entry

Bui Quang Minh <minhquangbui99@gmail.com>
    bpf: Check for integer overflow when using roundup_pow_of_two()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hvs: Fix buffer overflow with the dlist handling

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: fix a possible memory leak in mt76_add_fragment()

Mark Rutland <mark.rutland@arm.com>
    lkdtm: don't move ctors to .rodata

Thomas Gleixner <tglx@linutronix.de>
    vmlinux.lds.h: Create section for protection against instrumentation

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: kexec: fix oops after TLB are invalidated

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: ensure the signal page contains defined contents

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: lpc32xx: Revert set default clock rate of HCLK PLL

Lin Feng <linf@wangsu.com>
    bfq-iosched: Revert "bfq: Fix computation of shallow depth"

Alexandre Ghiti <alex@ghiti.fr>
    riscv: virt_addr_valid must check the address belongs to linear mapping

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Decrement refcount of dc_sink before reassignment

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Free atomic state after drm_atomic_commit

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Fix dc_sink kref count in emulated_link_detect

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Add more Clock Sources to DCN2.1

Claus Stovgaard <claus.stovgaard@gmail.com>
    nvme-pci: ignore the subsysem NQN on Phison E16

Amir Goldstein <amir73il@gmail.com>
    ovl: skip getxattr of security labels

Miklos Szeredi <mszeredi@redhat.com>
    cap: fix conversions on getxattr

Miklos Szeredi <mszeredi@redhat.com>
    ovl: perform vfs_getxattr() with mounter creds

Hans de Goede <hdegoede@redhat.com>
    platform/x86: hp-wmi: Disable tablet-mode reporting by default

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix suspcious RCU usage splats for omap_enter_idle_coupled

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: sdm845: Reserve LPASS clocks in gcc

Marc Zyngier <maz@kernel.org>
    arm64: dts: rockchip: Fix PCIe DT properties on rk3399

Odin Ugedal <odin@uged.al>
    cgroup: fix psi monitor for root cgroup

Julien Grall <jgrall@amazon.com>
    arm/xen: Don't probe xenbus as part of an early initcall

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check length before giving out the filter buffer

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Do not count ftrace events in top level enable output

Nikita Shubin <nikita.shubin@maquefel.me>
    gpio: ep93xx: Fix single irqchip with multi gpiochips

Nikita Shubin <nikita.shubin@maquefel.me>
    gpio: ep93xx: fix BUG_ON port F usage


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                     |   3 -
 arch/arm/include/asm/kexec-internal.h              |  12 ++
 arch/arm/kernel/asm-offsets.c                      |   5 +
 arch/arm/kernel/machine_kexec.c                    |  20 +-
 arch/arm/kernel/relocate_kernel.S                  |  38 ++--
 arch/arm/kernel/signal.c                           |  14 +-
 arch/arm/mach-omap2/cpuidle44xx.c                  |  16 +-
 arch/arm/xen/enlighten.c                           |   2 -
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   4 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   2 +-
 arch/h8300/kernel/asm-offsets.c                    |   3 +
 arch/powerpc/kernel/vmlinux.lds.S                  |   1 +
 arch/riscv/include/asm/page.h                      |   5 +-
 arch/x86/Makefile                                  |   6 +-
 block/bfq-iosched.c                                |   8 +-
 drivers/clk/sunxi-ng/ccu_mp.c                      |   2 +-
 drivers/gpio/gpio-ep93xx.c                         | 216 +++++++++++----------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  22 +--
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  10 +
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |  25 +++
 drivers/gpu/drm/sun4i/sun4i_tcon.h                 |   6 +
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |   6 +-
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |  26 +--
 drivers/gpu/drm/vc4/vc4_plane.c                    |  18 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  11 +-
 drivers/misc/lkdtm/Makefile                        |   2 +-
 drivers/misc/lkdtm/rodata.c                        |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  59 ++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   7 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  17 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   8 +-
 drivers/net/xen-netback/rx.c                       |   9 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/platform/x86/hp-wmi.c                      |  14 +-
 drivers/usb/dwc3/ulpi.c                            |  20 +-
 drivers/xen/xenbus/xenbus.h                        |   1 -
 drivers/xen/xenbus/xenbus_probe.c                  |   2 +-
 fs/overlayfs/copy_up.c                             |  15 +-
 fs/overlayfs/inode.c                               |   2 +
 fs/overlayfs/super.c                               |  13 +-
 include/asm-generic/sections.h                     |   3 +
 include/asm-generic/vmlinux.lds.h                  |  12 +-
 include/linux/compiler.h                           |  53 +++++
 include/linux/compiler_types.h                     |   4 +
 include/linux/netdevice.h                          |   2 +
 include/linux/uio.h                                |   8 +-
 include/xen/xenbus.h                               |   2 -
 kernel/bpf/stackmap.c                              |   2 +
 kernel/cgroup/cgroup.c                             |   4 +-
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace_events.c                        |   3 +-
 lib/iov_iter.c                                     |  24 ++-
 net/core/datagram.c                                |  12 +-
 net/core/dev.c                                     |  11 +-
 net/dsa/dsa2.c                                     |   7 +-
 net/netfilter/nf_conntrack_core.c                  |   3 +-
 net/netfilter/nf_flow_table_core.c                 |   4 +-
 net/netfilter/nf_tables_api.c                      |  25 ++-
 net/netfilter/xt_recent.c                          |  12 +-
 net/qrtr/tun.c                                     |   6 +
 net/rds/rdma.c                                     |   3 +
 net/rxrpc/call_object.c                            |   2 -
 net/sctp/proc.c                                    |  16 +-
 net/vmw_vsock/af_vsock.c                           |  13 +-
 net/vmw_vsock/hyperv_transport.c                   |   4 -
 net/vmw_vsock/virtio_transport_common.c            |   4 +-
 scripts/mod/modpost.c                              |   2 +-
 security/commoncap.c                               |  67 ++++---
 .../networking/timestamping/txtimestamp.c          |   6 +-
 73 files changed, 666 insertions(+), 321 deletions(-)


