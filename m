Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C67A3D6EEB
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 08:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhG0GNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 02:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235390AbhG0GNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 02:13:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4246E610E9;
        Tue, 27 Jul 2021 06:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627366433;
        bh=sYHQZ5IUm3kHw0XS/4923a9afkVe+8EOC1S6QoLRyiI=;
        h=From:To:Cc:Subject:Date:From;
        b=VjkpsacAQCTmhiF7FfMtYmcu0mQseJmeVnC8SF3AUNcNd71hGKpiWWlX4bCObZlWR
         PEoQJwVpXaq9VaMYGoJ4tnOeonkmxevpmR+9XljBzpE3PJYbc6bkpnE6ei+CnWpeA0
         op/BX0npCP8l0UvroxF7S3deMct7waZ8+VX43ryQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/46] 4.4.277-rc2 review
Date:   Tue, 27 Jul 2021 08:13:51 +0200
Message-Id: <20210727061334.372078412@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.277-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.277-rc2
X-KernelTest-Deadline: 2021-07-29T06:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.277 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 29 Jul 2021 06:13:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.277-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.277-rc2

David Sterba <dsterba@suse.com>
    btrfs: compression: don't try to compress if we don't have enough pages

Stephan Gerhold <stephan@gerhold.net>
    iio: accel: bma180: Fix BMA25x bandwidth register values

Linus Walleij <linus.walleij@linaro.org>
    iio: accel: bma180: Use explicit member assignment

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Gustavo A. R. Silva <gustavoars@kernel.org>
    media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

Haoran Luo <www@aegistudio.net>
    tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.

John Keeping <john@metanate.com>
    USB: serial: cp210x: add ID for CEL EM3588 USB ZigBee stick

Ian Ray <ian.ray@ge.com>
    USB: serial: cp210x: fix comments for GE CS1000

Marco De Marco <marco.demarco@posteo.net>
    USB: serial: option: add support for u-blox LARA-R6 family

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Fix superfluous irqs happen after usb_pkt_pop()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: max-3421: Prevent corruption of freed memory

Julian Sikorski <belegdol@gmail.com>
    USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Disable USB 3 device initiated lpm if exit latency is too high

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S: Fix H_RTAS rets buffer overflow

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix lost USB 2 remote wake

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Fix potential ABBA deadlock in CSP driver

Vasily Gorbik <gor@linux.ibm.com>
    s390/ftrace: fix ftrace_update_ftrace_func implementation

Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
    proc: Avoid mixing integer types in mem_rw()

Vincent Palatin <vpalatin@chromium.org>
    Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: Fix protect handling in WRITE SAME(32)

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix iface sysfs attr detection

Nguyen Dinh Phi <phind.uet@gmail.com>
    netrom: Decrease sock refcount when sock timers expire

Yajun Deng <yajun.deng@linux.dev>
    net: decnet: Fix sleeping inside in af_decnet

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: fix uninit-value in caif_seqpkt_sendmsg

Colin Ian King <colin.king@canonical.com>
    s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

Riccardo Mancini <rickyman7@gmail.com>
    perf probe-file: Delete namelist in del_events() on the error path

Riccardo Mancini <rickyman7@gmail.com>
    perf test bpf: Free obj_buf

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    igb: Check if num of q_vectors is smaller than max before array access

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iavf: Fix an error handling path in 'iavf_probe()'

Eric Dumazet <edumazet@google.com>
    ipv6: tcp: drop silly ICMPv6 packet too big messages

Eric Dumazet <edumazet@google.com>
    tcp: annotate data races around tp->mtu_info

Taehee Yoo <ap420073@gmail.com>
    net: validate lwtstate->data before returning from skb_tunnel_info()

Pavel Skripkin <paskripkin@gmail.com>
    net: ti: fix UAF in tlan_remove_one

Pavel Skripkin <paskripkin@gmail.com>
    net: moxa: fix UAF in moxart_mac_probe

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Vadim Fedorenko <vfedorenko@novek.ru>
    net: ipv6: fix return value of ip6_skb_dst_mtu

Thomas Gleixner <tglx@linutronix.de>
    x86/fpu: Make init_fpstate correct with optimized XSAVE

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "memory: fsl_ifc: fix leak of IO mapping on probe failure"

Odin Ugedal <odin@uged.al>
    sched/fair: Fix CFS bandwidth hrtimer expiry type

Colin Ian King <colin.king@canonical.com>
    scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8

Matthias Maennich <maennich@google.com>
    kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set

Yang Yingliang <yangyingliang@huawei.com>
    thermal/core: Correct function name thermal_zone_device_unregister()

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info

Primoz Fiser <primoz.fiser@norik.com>
    ARM: dts: imx6: phyFLEX: Fix UART hardware flow control

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM63xx: Fix NAND nodes names

Rafał Miłecki <rafal@milecki.pl>
    ARM: brcmstb: dts: fix NAND nodes names


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/bcm63138.dtsi                    |  2 +-
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |  4 +-
 arch/arm/boot/dts/bcm7445.dtsi                     |  2 +-
 arch/arm/boot/dts/bcm963138dvt.dts                 |  4 +-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  5 +-
 arch/arm/mach-imx/suspend-imx53.S                  |  4 +-
 arch/powerpc/kvm/book3s_rtas.c                     | 25 +++++-
 arch/s390/include/asm/ftrace.h                     |  1 +
 arch/s390/kernel/ftrace.c                          |  2 +
 arch/s390/kernel/mcount.S                          |  4 +-
 arch/s390/net/bpf_jit_comp.c                       |  2 +-
 arch/x86/include/asm/fpu/internal.h                | 30 ++------
 arch/x86/kernel/fpu/xstate.c                       | 37 ++++++++-
 drivers/iio/accel/bma180.c                         | 75 +++++++++++-------
 drivers/media/pci/ngene/ngene-core.c               |  2 +-
 drivers/media/pci/ngene/ngene.h                    | 14 ++--
 drivers/memory/fsl_ifc.c                           |  4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 21 ++---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  6 --
 drivers/net/ethernet/intel/i40evf/i40evf_main.c    |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  9 ++-
 drivers/net/ethernet/moxa/moxart_ether.c           |  4 +-
 drivers/net/ethernet/ti/tlan.c                     |  3 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |  2 +-
 drivers/scsi/scsi_transport_iscsi.c                | 90 ++++++++--------------
 drivers/target/target_core_sbc.c                   | 35 ++++-----
 drivers/thermal/thermal_core.c                     |  2 +-
 drivers/usb/core/hub.c                             | 68 +++++++++++++---
 drivers/usb/core/quirks.c                          |  4 -
 drivers/usb/host/max3421-hcd.c                     | 44 ++++-------
 drivers/usb/host/xhci-hub.c                        |  3 +-
 drivers/usb/renesas_usbhs/fifo.c                   |  7 ++
 drivers/usb/serial/cp210x.c                        |  5 +-
 drivers/usb/serial/option.c                        |  3 +
 drivers/usb/storage/unusual_uas.h                  |  7 ++
 fs/btrfs/inode.c                                   |  2 +-
 fs/proc/base.c                                     |  2 +-
 include/net/dst_metadata.h                         |  4 +-
 include/net/ip6_route.h                            |  2 +-
 kernel/sched/fair.c                                |  4 +-
 kernel/trace/ring_buffer.c                         | 28 ++++++-
 net/caif/caif_socket.c                             |  3 +-
 net/decnet/af_decnet.c                             | 27 +++----
 net/ipv4/tcp_ipv4.c                                |  4 +-
 net/ipv4/tcp_output.c                              |  1 +
 net/ipv6/tcp_ipv6.c                                | 19 ++++-
 net/ipv6/xfrm6_output.c                            |  2 +-
 net/netrom/nr_timer.c                              | 20 ++---
 scripts/mkcompile_h                                | 14 +++-
 sound/isa/sb/sb16_csp.c                            |  4 +
 tools/perf/tests/bpf.c                             |  2 +
 tools/perf/util/probe-file.c                       |  4 +-
 53 files changed, 403 insertions(+), 274 deletions(-)


